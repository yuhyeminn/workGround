<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script>
$(function(){
	drawTimeline(); //타임라인
	tabActive(); //서브헤더 탭 활성화
	
	//푸터 너비 조정
	let width = $('#timeline-wrapper').prop('scrollWidth');
	$('.main-footer').css('width', width);
});

//날짜형식 변환 함수: 문자열 -> 날짜
function changeDateFormat(dateStr){
	let yyyy = dateStr.split('-')[0];
	let mm = dateStr.split('-')[1];
	let dd = dateStr.split('-')[2];
	
	let d = new Date(yyyy, mm-1, dd);
	return d;
}

//커스텀 툴팁
function createTooltip(title){
	return '<div class="tooltip-wrapper"><p>'+title+'</p></div>';
}
function createTooltipForWork(title, state){
	return '<div class="tooltip-wrapper">'
			+'<p>'+title+'</p>'
			+'<p>'+state+'</p>'
			+'</div>';
}

//타임라인 
function drawTimeline(){
	google.charts.load('current', {'packages':['timeline']});
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
        let container = document.getElementById('timeline');
        let chart = new google.visualization.Timeline(container);
        let dataTable = new google.visualization.DataTable();
        
        dataTable.addColumn({ type: 'string', id: 'title' });
        dataTable.addColumn({ type: 'string', id: 'bar label' });
        dataTable.addColumn({ type: 'string', role: 'tooltip', 'p': {'html': true} });
        dataTable.addColumn({ type: 'string', id: 'style', role: 'style' }); 
        dataTable.addColumn({ type: 'date', id: 'start' });
        dataTable.addColumn({ type: 'date', id: 'end' });
        
        
        //프로젝트 일정
        let totalArr = []; //최종 dataTable에 들어가게 될 배열
        let today = new Date();
        let ps = changeDateFormat('${project.projectStartDate}'); //프로젝트 시작일
        let pe; //프로젝트 마감/종료일(없으면 undefined)
        
        //실제 완료일 있는 경우
        if('${project.projectRealEndDate}'!=='') {
        	pe = changeDateFormat('${project.projectRealEndDate}');
        }
        //실제 완료일 없는 경우
        else{
        	//마감일 있는 경우
        	if('${project.projectEndDate}'!==''){
        		pe = changeDateFormat('${project.projectEndDate}');
        	}
        	//마감일 없는 경우: 업무리스트 마감(종료)일 중 가장 늦은 마감(종료)일 
        }
        
        
        //업무리스트: 업무가 없는 업무리스트는 포함x
        let wlList = [];
        let workList;
        let wlStart; //업무리스트 시작일: 포함하는 업무 중 가장 빠른 시작일
        let wlEnd; //업무리스트 종료일: 포함하는 업무 중 가장 늦은 마감(종료)일
        let sArr; //시작일 배열
        let eArr; //마감,종료일 배열
        let peArr = []; //프로젝트 종료(마감)일 둘 다 없는 경우를 위한 비교 배열 
        let initialValue;
        let reducerS = (accumulator, value)=>{
			if(accumulator < value) accumulator = accumulator;
			else accumulator = value;
			return accumulator;
 		}; //시작일 구하기
 		let reducerE = (accumulator, value)=>{
			if(accumulator > value) accumulator = accumulator;
			else accumulator = value;
			return accumulator;
 		}; //종료일 구하기
        
        
        <c:forEach items="${wlList}" var="wl"> 
	        workList = []; //업무들 담길 배열
	        wlStart = ""; //업무리스트 시작일
	        wlEnd = ""; //업무리스트 종료일
	        sArr = []; //업무 시작일 담길 배열
	        eArr = []; //업무 종료일 담길 배열
	        
        	<c:forEach items="${wl.workList}" var="w">
        		workList.push({wTitle: '${w.workTitle}', wStart: '${w.workStartDate}', wEnd: '${w.workEndDate}', wRealEnd: '${w.workRealEndDate}'});
        		
        		<c:if test="${w.workStartDate!=null}">
        			sArr.push(changeDateFormat('${w.workStartDate}'));
        		</c:if>
        		
        		//완료일이 있지만 마감일이 더 늦은 경우 마감일을 배열에 넣기
        		<c:if test="${w.workRealEndDate!=null}">
        			if(changeDateFormat('${w.workRealEndDate}') < changeDateFormat('${w.workEndDate}'))
        				eArr.push(changeDateFormat('${w.workEndDate}'));
        			else
        				eArr.push(changeDateFormat('${w.workRealEndDate}'));
        		</c:if>
        		//완료일 없고, 마감일 있는 경우 마감일을 배열에 넣기
        		<c:if test="${w.workRealEndDate==null && w.workEndDate!=null}">
    				eArr.push(changeDateFormat('${w.workEndDate}'));
    			</c:if>
        	</c:forEach>
        	
        	//업무리스트 시작일 구하기
   			initialValue = sArr[0];
   			wlStart = sArr.reduce(reducerS, initialValue); //업무시작일들 중 가장 빠른 날짜 구함
   			if(wlStart===undefined) wlStart = ps; //지정된 날짜가 없다면 프로젝트 시작일
   			
   			//업무리스트 종료일 구하기
   			initialValue = eArr[0];
   			wlEnd = eArr.reduce(reducerE, initialValue); //업무종료일들 중 가장 늦은 날짜 구함
   			if(wlEnd===undefined) wlEnd = wlStart; //지정된 날짜가 없다면 업무리스트 시작일
   			
   			peArr.push(wlEnd);
        	
			
        	<c:if test="${wl.workList!=null && !empty wl.workList}">
        		wlList.push({wlTitle: '${wl.worklistTitle}', workList: workList, wlStart: wlStart, wlEnd: wlEnd});        	
        	</c:if>
        </c:forEach>
        
        
        //프로젝트 마감일 없는 경우 업무리스트 마감일로 비교, 구하기
        if(pe===undefined){
        	initialValue = "";
        	pe = peArr.reduce(reducerE, initialValue);
        }
        
        totalArr.push(['${project.projectTitle}', null, createTooltip('프로젝트: ${project.projectTitle}'), 'color: #1F5C87;', ps, pe]);
        
        
		let style;
		let state;
		let duration;
		let startDate; //업무시작일
		let endDate; //업무마감(종료)일
		
        for(let i in wlList){ //wl = wlList(배열)안의 업무리스트(객체)
	        //업무리스트 정보 담기
        	totalArr.push([wlList[i]['wlTitle'], null, createTooltip('업무리스트: '+wlList[i]['wlTitle']), 'color: #d4d6db; opacity: .7; stroke-color: #777; stroke-width: 2px;', wlList[i]['wlStart'], wlList[i]['wlEnd']]);
        	
        	for(let w of wlList[i]['workList']){ //wr = 업무리스트(객체) 안의 업무들(배열) 안의 업무(객체)
        		style = "";
        		state = "";
        		duration = "";
        		startDate = "";
        		endDate = "";
        		
        		//업무 시작일 설정
        		if(w['wStart']==="") startDate = wlList[i]['wlStart']; //시작일 없으면 업무리스트 시작일
        		else startDate = changeDateFormat(w['wStart']);
        		
        		
        		//종료일 있는 경우: 초록색+'완료된 업무, 기간 3일'
        		if(w['wRealEnd']!==""){
        			//시작일이 없는 경우
        			if(w['wStart']===""){
	        			state = "완료된 업무, 시작일/마감일 없는 업무";
	        			endDate = changeDateFormat(w['wRealEnd']);
        			}
        			//시작일이 있는 경우
        			else{
        				//시작일보다 종료를 빨리 한 경우 
        				if(changeDateFormat(w['wStart']) > changeDateFormat(w['wRealEnd'])){
        					//마감일이 있는 경우
        					if(w['wEnd']!==""){
			        			endDate = changeDateFormat(w['wEnd']);
			        			duration = Math.round((endDate-changeDateFormat(w['wStart']))/(24*60*60*1000));
			        			state = "완료된 업무, 기간 "+(duration)+"일";
        					}
        					//마감일이 없는 경우
        					else{
			        			endDate = changeDateFormat(w['wStart']);
			        			state = "완료된 업무, 기간 1일";
        					}
        				}
        				//시작일 지나서 종료한 경우
        				else{
		        			endDate = changeDateFormat(w['wRealEnd']);
		        			duration = Math.round((changeDateFormat(w['wRealEnd'])-changeDateFormat(w['wStart']))/(24*60*60*1000));
		        			state = "완료된 업무, 기간 "+(duration)+"일";
        				}
        			}
        			style = "color: #20c997; opacity: .4; stroke-color: #20c997; stroke-width: 2px";
        		}
        		//종료일 없고 마감일 있는 경우
        		else if(w['wRealEnd']==="" && w['wEnd']!==""){
	        		//기간 안지난 경우: 파란색+'진행중인 업무, 기간 8일'
        			if(today <= changeDateFormat(w['wEnd'])){
        				duration = Math.round((changeDateFormat(w['wEnd'])-changeDateFormat(w['wStart']))/(24*60*60*1000));
	        			style = "color: #007bff; opacity: .4; stroke-color: #007bff; stroke-width: 2px";
	        			state = "진행중인 업무, 기간 "+(duration)+"일";
        			}
	        		//기간 지난 경우: 빨간색+'마감일 4일 지남'
	        		else{
	        			duration = Math.round((today-changeDateFormat(w['wEnd']))/(24*60*60*1000));
	        			style = "color: #dc3545; opacity: .4; stroke-color: #dc3545; stroke-width: 2px";
	        			state = "마감일 "+(duration)+"일 지남";
	        		}
        			endDate = changeDateFormat(w['wEnd']);
        		}
        		//마감일 없고 종료일도 없는 경우
        		else if(w['wEnd']==="" && w['wRealEnd']===""){
        			//시작일도 없는 경우: 회색+보더+'시작일/마감일 없는 업무'
        			if(w['wStart']==="") {
	        			endDate = startDate;
	        			state = "시작일/마감일 없는 업무";
	        			style = "color: #8e8e8e; opacity: .7;";
        			}
        			//시작일만 있는 경우: 파란색+'진행중인 업무, 기간 1일'
            		else {
	        			endDate = startDate;
	        			duration = Math.round((today-changeDateFormat(w['wStart']))/(24*60*60*1000));
	        			state = "진행중인 업무, 기간 "+(duration)+"일";
	        			style = "color: #007bff; opacity: .4; stroke-color: #007bff; stroke-width: 2px";
            		}
        		}
        		totalArr.push([w['wTitle'], null, createTooltipForWork('업무: '+w['wTitle'], state), style, startDate, endDate]);
        		
        	}//end of for(let w in wl): 업무리스트 안의 업무 
        }//end of for(let wl of wlList): 업무리스트의 리스트 안의 업무리스트
        
        
        dataTable.addRows(
        	totalArr
        );
    		
      	//options
      	let html;
        let ticks = [];
      	let height = (50*totalArr.length-1)-120; 	
       	for(let i=1; i<=90; i++){
       		ticks.push(new Date(ps.getFullYear(), ps.getMonth(), ps.getDate()+i));
       	}
      
        let options = {
       	  width: 5000,
       	  height: height,
          backgroundColor: '#fff',
          hAxis: {
        	format: 'MM-dd',
            minValue: ps,
            maxValue: new Date(ps.getFullYear(), ps.getMonth()+3, ps.getDate()),
            ticks: ticks
          }, 
          tooltip: {
        	  isHtml: true
          }
        }; //end of options
        
        
        chart.draw(dataTable, options); 
        
    } //end of drawChart()
}

//서브헤더 탭 active
function tabActive(){
    let tabArr = document.querySelectorAll("#navbar-tab li");

    tabArr.forEach((obj, idx)=>{
        let $obj = $(obj);
        if($obj.hasClass('active')){
            $obj.removeClass('active');
        }
    });

    $("#tab-timeline").addClass("active");
}
</script>		

<!-- Content Wrapper. Contains page content -->
<!-- <div class="content-wrapper navbar-light"> -->
    <h2 class="sr-only">프로젝트 타임라인</h2>
    <!-- Main content -->
    <div id="timeline-wrapper" class="content view">
    	<div id="timeline-header">
    		<div class="guide">
    			<span class="cell"></span>
    			<span class="cell-type">프로젝트</span>
    		</div>
    		<div class="guide wl">
    			<span class="cell"></span>
    			<span class="cell-type">업무리스트</span>
    		</div>
    		<div class="guide ing-work">
    			<span class="cell"></span>
    			<span class="cell-type">진행중인 업무</span>
    		</div>
    		<div class="guide cmptd-work">
    			<span class="cell"></span>
    			<span class="cell-type">완료된 업무</span>
    		</div>
    		<div class="guide over-work">
    			<span class="cell"></span>
    			<span class="cell-type">마감일 지난 업무</span>
    		</div>
    		<div class="guide none-work">
    			<span class="cell"></span>
    			<span class="cell-type">시작일/마감일 없는 업무</span>
    		</div>
    	</div>
    	<div id="timeline"></div>
    </div>
    <!-- /.content -->
<!-- /.content-wrapper -->

