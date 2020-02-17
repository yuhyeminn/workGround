<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />

<style>
#timeline-wrapper{width: 5030px; background: #f8f9fa;}
.tooltip-wrapper{min-width: 10rem; padding: .5rem; background: #0c3865;}
.tooltip-wrapper p{color: #fff; font-weight: bold;}
</style>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script>
$(function(){
	drawTimeline(); //타임라인
	tabActive(); //서브헤더 탭 활성화
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
        let today = new Date();
        let s = changeDateFormat('${project.projectStartDate}'); //시작일
        let e; //마감일(undefined)
        let re; //실제완료일
        
        //실제 완료일 있는 경우
        if('${project.projectRealEndDate}'!=='') {
        	e = changeDateFormat('${project.projectRealEndDate}');
        }
        //실제 완료일 없는 경우
        else{
        	//마감일 있는 경우
        	if('${project.projectEndDate}'!==''){
        		e = changeDateFormat('${project.projectEndDate}');
        	}
        	///마감일 없는 경우
        	else{
        		e = today;
        	}
        }
        
        //업무리스트: 업무가 없는 업무리스트는 포함x
        let wlList = [];
        let workList;
        let wlStart; //업무리스트 시작일: 포함하는 업무 중 가장 빠른 시작일
        let wlEnd; //업무리스트 종료일: 포함하는 업무 중 가장 늦은 마감/종료일
        let sArr; //시작일 배열
        let eArr; //마감,종료일 배열
        let initialValue;
        let reducer = (accumulator, value)=>{
			if(accumulator > value) accumulator = accumulator;
			else accumulator = value;
			return accumulator;
		}
        
        <c:forEach items="${wlList}" var="wl">
	        workList = [];
	        wlStart = "";
	        wlEnd = "";
	        sArr = []; 
	        eArr = []; 
        	<c:forEach items="${wl.workList}" var="w">
        		workList.push({wTitle: '${w.workTitle}', wStart: '${w.workStartDate}', wEnd: '${w.workEndDate}', wRealEnd: '${w.workRealEndDate}'});
        		<c:if test="${w.workStartDate!=null}">
        			sArr.push(changeDateFormat('${w.workStartDate}'));
        		</c:if>
        		
        		<c:if test="${w.workRealEndDate!=null}">
        			eArr.push(changeDateFormat('${w.workRealEndDate}'));
        		</c:if>
        		<c:if test="${w.workRealEndDate==null && w.workEndDate!=null}">
    				eArr.push(changeDateFormat('${w.workEndDate}'));
    			</c:if>
        	</c:forEach>
        	
   			initialValue = "";
   			wlStart = sArr.reduce(reducer, initialValue);
   			wlEnd = eArr.reduce(reducer, initialValue);
        	
        	<c:if test="${wl.workList!=null && !empty wl.workList}">
        		wlList.push({wlTitle: '${wl.worklistTitle}', workList: workList, wlStart: wlStart, wlEnd: wlEnd});        	
        	</c:if>
        </c:forEach>
        
        console.log(wlList);
        
        
        
        let totalArr = [];
        let wlArr; //객체->배열 옮겨담는 용
        let wArr;
		let style;
		let state;
		let duration;
		let startDate;
		let endDate;
        //업무리스트 정보 담기
        for(let wl of wlList){ //wl = wlList안의 업무리스트 하나(객체)
        	wlArr = []; //객체인 업무리스트를 배열로
        	wlArr.push(wl['wlTitle'], null, createTooltip(wl['wlTitle']), 'color: #d4d6db; opacity: .3', wl['wlStart'], wl['wlEnd']);
        	tototalArr.push(wl); //최종 배열에 넣기
        	
        	for(let wr in wl){ //wr = 업무리스트 안의 업무배열
        		if(wr==='workList'){ 
        			for(let w in wr){ //w = 업무 하나
		        		wArr = []; //객체인 업무를 배열로
		        		style = "";
		        		state = "";
		        		duration = "";
		        		startDate = "";
		        		endDate = "";
		        		
		        		//업무 시작일 설정
		        		if(w['wStart']==="") startDate = s; //프로젝트 시작일
		        		else startDate = changeDateFormat(wl['wStart']);
		        		
		        		
		        		//종료일 있는 경우: 초록색+'완료된 업무, 기간 3일'
		        		if(wl['wRealEnd']!==""){
		        			//시작일이 없는 경우
		        			if(wl['wStart']===""){
			        			state = "완료된 업무, 시작일/마감일 없는 업무";
		        			}
		        			//시작일이 있는 경우
		        			else{
			        			duration = changeDateFormat(wl['wRealEnd']) - changeDateFormat(wl['wStart']);
			        			state = "완료된 업무, 기간 "+(duration)+"일";
		        			}
		        			style = "color: #20c997; opacity: .5; stroke-color: #20c997;";
		        			endDate = changeDateFormat(wl['wRealEnd']);
		        		}
		        		//종료일 없고 마감일 있는 경우
		        		else if(wl['wRealEnd']==="" && wl['wEnd']!==""){
			        		//기간 안지난 경우: 파란색+'진행중인 업무, 기간 8일'
		        			if(today <= changeDateFormat(wl['wEnd'])){
		        				duration = changeDateFormat(wl['wEnd']) - changeDateFormat(wl['wStart']);
			        			style = "color: #007bff; opacity: .5; stroke-color: #007bff;";
			        			state = "진행중인 업무, 기간 "+(duration)+"일";
		        			}
			        		//기간 지난 경우: 빨간색+'마감일 4일 지남'
			        		else{
			        			duration = today - changeDateFormat(wl['wEnd']);
			        			style = "color: #dc3545; opacity: .5; stroke-color: #dc3545;";
			        			state = "마감일 "+(duration)+"일 지남";
			        		}
		        			endDate = changeDateFormat(wl['wEnd']);
		        		}
		        		//마감일 없고 종료일도 없는 경우: 회색+보더+'시작일/마감일 없는 업무'
		        		else if(wl['wEnd']==="" && wl['wRealEnd']===""){
		        			//시작일 없는 경우
		        			
		        			//시작일 있는 경우
		        			style = "color: #d4d6db; opacity: .5; stroke-color: #d4d6db; stroke-width: 2px";
		        			state = "시작일/마감일 없는 업무";
		        		}
		        		wArr.push(wl['wTitle'], null, createTooltipForWork(wl['wTitle'], state), style, startDate, endDate);
		        		tototalArr.push(wArr);
	        		} // end of for(let w in wr) //w = 업무 하나
	        	}
        	}//end of for(let w in wl): 업무리스트 안의 업무 배열
        	
        }//end of for(let wl of wlList): 업무리스트의 리스트 안의 업무리스트
        
        
        console.log(tototalArr);
        
        
        
        dataTable.addRows([
        	['${project.projectTitle}', null, createTooltip('${project.projectTitle}'), 'color: #d4d6db;', s, e]
      	]);
          
          
        
        
      	//ticks
        let ticks = [];
       	for(let i=1; i<=90; i++){
       		ticks.push(new Date(s.getFullYear(), s.getMonth(), s.getDate()+i));
       	}
       	
        let options = {
       	  width: 5000,
          backgroundColor: '#fff',
          hAxis: {
        	format: 'MM-dd',
            minValue: s,
            maxValue: new Date(s.getFullYear(), s.getMonth()+3, s.getDate()),
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

<!-- 프로젝트 관리자 -->
<c:set var="projectManager" value=""/>
<c:set var="isprojectManager" value="false"/>
<c:forEach var="pm" items="${project.projectMemberList}">
	<c:if test="${pm.managerYn eq 'Y'}">
		<c:set var="projectManager" value="${projectManager=pm.memberId}" />
	</c:if>
	<c:if test="${pm.memberId eq memberLoggedIn.memberId }">
		<c:if test="${pm.managerYn eq 'Y'}"><c:set var="isprojectManager" value="true"/> </c:if>
	</c:if>
</c:forEach>
<!-- 나의 워크패드인 경우 -->
<c:if test="${project.privateYn=='Y'}">
	<c:set var="projectManager" value="${projectManager=project.projectWriter}" />
</c:if>


<!-- Content Wrapper. Contains page content -->
<!-- <div class="content-wrapper navbar-light"> -->
    <h2 class="sr-only">프로젝트 타임라인</h2>
    <!-- Main content -->
    <div id="timeline-wrapper" class="content view">
    	<div id="timeline"></div>
    </div>
    <!-- /.content -->
<!-- /.content-wrapper -->

