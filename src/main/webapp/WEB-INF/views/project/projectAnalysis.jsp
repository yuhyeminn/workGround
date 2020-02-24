<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />

<link rel="stylesheet" property="stylesheet" href="${pageContext.request.contextPath}/resources/css/hyemin.css">

<!-- 오늘 날짜 -->
<jsp:useBean id="now" class="java.util.Date" />
<fmt:parseNumber value="${now.time / (1000*60*60*24)}" integerOnly="true" var="today"></fmt:parseNumber>
<fmt:formatDate value="${now}" var="nowDate" pattern="yyyy-MM-dd"/>

<!-- 프로젝트 시작일 -->
<fmt:parseDate value="${project.projectStartDate}" var="projectStartDate" pattern="yyyy-MM-dd"/>
<fmt:parseNumber value="${projectStartDate.time / (1000*60*60*24)}" integerOnly="true" var="startDate"></fmt:parseNumber>

<!-- 프로젝트 마감일 -->
<fmt:parseDate value="${project.projectEndDate}" var="projectEndDate" pattern="yyyy-MM-dd"/>
<fmt:parseNumber value="${projectEndDate.time / (1000*60*60*24)}" integerOnly="true" var="endDate"></fmt:parseNumber>

<!-- 프로젝트 개요 정보(완료됨, 마감일 지남, 계획됨, 마감일 없음) -->
<c:set var="completeWorkCnt" value="0"/> <!-- 완료 업무 개수 -->
<c:set var="ncompleteWorkCnt" value="0"/> <!-- 완료되지 않은 업무 개수 -->
<c:set var="lateEndWorkCnt" value="0"/> <!-- 마감일 지남 -->
<c:set var="planWorkCnt" value="0"/> <!-- 계획됨 -->
<c:set var="nullEndWorkCnt" value="0"/> <!-- 마감일없음 -->
<c:forEach items="${project.worklistList }" var="wl">
    <c:forEach items="${wl.workList}" var="work">
      <c:if test="${work.workCompleteYn eq 'Y'}">
         <c:set var="completeWorkCnt" value="${completeWorkCnt+1}"/>
      </c:if>
      <c:if test="${work.workCompleteYn eq 'N'}">
         <c:set var="ncompleteWorkCnt" value="${ncompleteWorkCnt+1}"/>
         <fmt:formatDate value="${work.workEndDate}" var="workEndDate" pattern="yyyy-MM-dd"/>
         <!-- 마감일 지남 -->
		 <c:if test="${workEndDate < nowDate}">
		   <c:set var="lateEndWorkCnt" value="${lateEndWorkCnt+1}"/>
		 </c:if>
		 <!-- 계획 됨 -->
		 <c:if test="${workEndDate >= nowDate}">
		   <c:set var="planWorkCnt" value="${planWorkCnt+1}"/>
		 </c:if>
		 <!-- 마감일 없음 -->
		 <c:if test="${work.workEndDate == null or work.workEndDate ==''}">
		   <c:set var="nullEndWorkCnt" value="${nullEndWorkCnt+1}"/>
		 </c:if>
      </c:if>
    </c:forEach>
</c:forEach>

<c:set var="mycompleteWorkCnt" value="0"/> <!-- 완료 업무 개수 -->
<c:set var="mylateEndWorkCnt" value="0"/> <!-- 마감일 지남 -->
<c:set var="myplanWorkCnt" value="0"/> <!-- 계획됨 -->
<c:set var="mynullEndWorkCnt" value="0"/> <!-- 마감일없음 -->
<!-- 나에게 배정된 업무 개요-->
<c:forEach items="${myWorkList}" var="mwork">
      <c:if test="${mwork.workCompleteYn eq 'Y'}">
         <c:set var="mycompleteWorkCnt" value="${mycompleteWorkCnt+1}"/>
      </c:if>
      <c:if test="${mwork.workCompleteYn eq 'N'}">
         <fmt:formatDate value="${mwork.workEndDate}" var="myworkEndDate" pattern="yyyy-MM-dd"/>
         <!-- 마감일 지남 -->
		 <c:if test="${myworkEndDate < nowDate}">
		   <c:set var="mylateEndWorkCnt" value="${mylateEndWorkCnt+1}"/>
		 </c:if>
		 <!-- 계획 됨 -->
		 <c:if test="${myworkEndDate >= nowDate}">
		   <c:set var="myplanWorkCnt" value="${myplanWorkCnt+1}"/>
		 </c:if>
		 <!-- 마감일 없음 -->
		 <c:if test="${myworkEndDate == null or myworkEndDate ==''}">
		   <c:set var="mynullEndWorkCnt" value="${mynullEndWorkCnt+1}"/>
		 </c:if>
      </c:if>
</c:forEach>

    <div class="analysis-content">
        <div class="project-summary content-box">
            <div class="row">
            <div class="summary-col-sm col-6 border-right">
                <div class="description-block ">
                <h5 class="description-header">시작일</h5>
                <span class="description-text">
                 <c:if test="${project.projectStartDate != null and project.projectStartDate !='' }">
                 	${project.projectStartDate }
                 </c:if>
                 <c:if test="${project.projectStartDate == null or project.projectStartDate =='' }">-</c:if>
                </span>
                </div>
                <!-- /.description-block -->
            </div>
            <!-- /.col -->
            <div class="summary-col-sm col-6 border-right">
                <div class="description-block ">
                <h5 class="description-header">마감일</h5>
                <span class="description-text">
                <c:if test="${project.projectEndDate != null and project.projectEndDate !='' }">
                 	${project.projectEndDate}
                 </c:if>
                 <c:if test="${project.projectEndDate == null or project.projectEndDate =='' }">-</c:if>
                </span>
                </div>
                <!-- /.description-block -->
            </div>
            <!-- /.col -->
            <div class="summary-col-sm col-6 border-right">
                <div class="description-block ">
                <h5 class="description-header">완료일</h5>
                <span class="description-text">
                <c:if test="${project.projectRealEndDate != null and project.projectRealEndDate !='' }">
                 	 ${project.projectRealEndDate }
                 </c:if>
                 <c:if test="${project.projectRealEndDate == null or project.projectRealEndDate =='' }">-</c:if>
                </span>
                </div>
                <!-- /.description-block -->
            </div>
            <!-- /.col -->
            <div class="summary-col-sm col-6 border-right">
                <div class="description-block ">
                <h5 class="description-header">경과 시간</h5>
                <span class="description-text"> 
                <c:if test="${today - starDate >= 0}">
                	${today - startDate - 1}일
                </c:if>
                <c:if test="${today - starDate < 0}">-</c:if>
                </span>
                </div>
                <!-- /.description-block -->
            </div>
            <div class="summary-col-sm col-6 border-right">
                <div class="description-block ">
                <h5 class="description-header">남은 시간</h5>
                <span class="description-text">
                <c:if test="${endDate - today >= 0}">
                	${endDate - today + 1}일
                </c:if>
                <c:if test="${endDate - today < 0}">-</c:if>
				 </span>
                </div>
                <!-- /.description-block -->
            </div>
            <div class="summary-col-sm col-6 border-right">
                <div class="description-block ">
                <h5 class="description-header">완료됨</h5>
                <span class="description-text">${completeWorkCnt}개 업무</span>
                </div>
                <!-- /.description-block -->
            </div>
            <div class="summary-col-sm col-6">
                <div class="description-block">
                <h5 class="description-header">남은업무</h5>
                <span class="description-text">${ncompleteWorkCnt}개 업무</span>
                </div>
                <!-- /.description-block -->
            </div>
            </div>
            <!-- /.row -->
        </div>
        <!-- /.project-summary-->

        <!--프로젝트 개요 차트-->
        <div class="project-summary-chart content-box">
            <span class="content-box-header">프로젝트 개요</span>
            <div id="project_chart" style="width:100%"></div>
        </div>
    
        <!-- 나에게 배정된 업무, 내가 작성한 업무 차트-->
        <div class="my-summary-chart">
            <div class="row">
            <div class="col-md-6 content-box">
                <p class="content-box-header" style="text-align: center;margin-bottom: 20px;">나에게 배정된 업무</p>
                <div class="chart-container">
                <div id="mywork-assign_chart"></div>
                <div id="cnt" class="overlay"></div>
                <div class="overlay-label">전체 업무</div>
            </div>
            </div>
            <div class="col-md-6 content-box">
                <p class="content-box-header" style="text-align: center;margin-bottom: 20px;">나의 활동 이력</p>
                <div class="chart-container">
                <div id="mywork-write_chart"></div>
                <div id="write-cnt" class="overlay"></div>
                <div class="overlay-label">전체 이력</div>
                </div>
            </div>
            </div>
            <!-- /.end row-->
        </div>

        <!--업무리스트 개요 차트-->
        <div class="worklist-summary-chart content-box">
            <span class="content-box-header">업무리스트 개요</span>
        <div id="worklist_chart" style="width:100%"></div>
    </div>

    </div>
    <!-- /.analysis-content-->

<script>
$(function(){
	sidebarActive(); //사이드바 활성화
	tabActive(); //서브헤더 탭 활성화
	
	//차트
	google.charts.load('current', {'packages':['bar','corechart']});
	google.charts.load("current", {packages:["corechart"]});
	google.charts.setOnLoadCallback(projectSummaryChart);
	google.charts.setOnLoadCallback(worklistSummaryChart);
	google.charts.setOnLoadCallback(myworkAssignChart);
	google.charts.setOnLoadCallback(myworkWriteChart);
});

//사이드바 활성화
function sidebarActive(){
	let navLinkArr = document.querySelectorAll(".sidebar .nav-link");
	
	navLinkArr.forEach((obj, idx)=>{
		let $obj = $(obj);
		if($obj.hasClass('active'))
			$obj.removeClass('active');
	});
	
	$("#sidebar-project").addClass("active");
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

    $("#tab-analysis").addClass("active");
}

//프로젝트 개요
function projectSummaryChart() {
    var data = google.visualization.arrayToDataTable([
        ['', '완료됨', '마감일 지남', '계획됨', '마감일 없음'],
        ['', ${completeWorkCnt}, ${lateEndWorkCnt}, ${planWorkCnt}, ${nullEndWorkCnt}]
    ]);

    var options_fullStacked = {
        isStacked: 'percent',
        height: 150,
        legend: {position: 'bottom', maxLines: 3},
        series: {
            0: { color: 'rgb(39, 182, 186)' },
            1: { color: 'rgb(233, 94, 81)' },
            2: { color: 'rgb(255, 176, 36)' },
            3: { color: 'rgb(176, 180, 187)' }
        },
        //x축 숨기기
        vAxis: {textPosition : 'none',},
        hAxis: {
            minValue: 0,
            ticks: [0, .3, .6, .9, 1],
            // y축 텍스트 숨기기
            textPosition : 'none',
            baseline:'rgb(255, 255, 255)',
            gridlines:{color: 'rgb(255, 255, 255)'}
        }
    };

    var chart = new google.visualization.BarChart(document.getElementById('project_chart'));
    chart.draw(data, options_fullStacked);
    //반응형 그래프 출력 - 반응형 그래프를 원하지 않을 시 제거하거나 주석처리 하세요.
    window.addEventListener('resize', function() { chart.draw(data, options_fullStacked); }, false);
}

// 업무리스트 개요
function worklistSummaryChart() {
	
    var data = google.visualization.arrayToDataTable([
        ['업무리스트', '완료됨', '마감일 지남', '계획됨', '마감일 없음'],
        <c:forEach items="${project.worklistList }" var="wl" varStatus="vs">
			<c:set var="completeWorkCnt" value="0"/> <!-- 완료 업무 개수 -->
			<c:set var="ncompleteWorkCnt" value="0"/> <!-- 완료되지 않은 업무 개수 -->
			<c:set var="lateEndWorkCnt" value="0"/> <!-- 마감일 지남 -->
			<c:set var="planWorkCnt" value="0"/> <!-- 계획됨 -->
			<c:set var="nullEndWorkCnt" value="0"/> <!-- 마감일없음 -->
		    <c:forEach items="${wl.workList}" var="work">
		      <c:if test="${work.workCompleteYn eq 'Y'}">
		         <c:set var="completeWorkCnt" value="${completeWorkCnt+1}"/>
		      </c:if>
		      <c:if test="${work.workCompleteYn eq 'N'}">
		         <fmt:formatDate value="${work.workEndDate}" var="workEndDate" pattern="yyyy-MM-dd"/>
		         <!-- 마감일 지남 -->
				 <c:if test="${workEndDate < nowDate}">
				   <c:set var="lateEndWorkCnt" value="${lateEndWorkCnt+1}"/>
				 </c:if>
				 <!-- 계획 됨 -->
				 <c:if test="${workEndDate >= nowDate}">
				   <c:set var="planWorkCnt" value="${planWorkCnt+1}"/>
				 </c:if>
				 <!-- 마감일 없음 -->
				 <c:if test="${work.workEndDate == null or work.workEndDate ==''}">
				   <c:set var="nullEndWorkCnt" value="${nullEndWorkCnt+1}"/>
				 </c:if>
		      </c:if>
		    </c:forEach>
	    ['${wl.worklistTitle}',${completeWorkCnt},${lateEndWorkCnt},${planWorkCnt},${nullEndWorkCnt}] ${vs.last?"":","}
		</c:forEach>
    ]);
    var options_fullStacked = {
        isStacked: 'percent',
        height: ${fn:length(project.worklistList)}*100 ,
        legend: {position: 'top', maxLines: 3},
        series: {
            0: { color: 'rgb(39, 182, 186)' },
            1: { color: 'rgb(233, 94, 81)' },
            2: { color: 'rgb(255, 176, 36)' },
            3: { color: 'rgb(176, 180, 187)' }
        },
        hAxis: {
            minValue: 0,
            ticks: [0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1],
        }
    };

    var chart = new google.visualization.BarChart(document.getElementById('worklist_chart'));
    chart.draw(data, options_fullStacked);
    //반응형 그래프 출력 - 반응형 그래프를 원하지 않을 시 제거하거나 주석처리 하세요.
    window.addEventListener('resize', function() { chart.draw(data, options_fullStacked); }, false);
}

//나에게 배정된 업무
function myworkAssignChart(){
    var data = google.visualization.arrayToDataTable([
        ['Task', 'Hours per Day'],
        ['완료됨', ${mycompleteWorkCnt}],
        ['마감일 지남', ${mylateEndWorkCnt}],
        ['계획됨', ${myplanWorkCnt}],
        ['마감일 없음', ${mynullEndWorkCnt}]
    ]);

    var options = {
        height: 280,
        pieHole: 0.8,
        showLables: 'true',
        pieSliceText:'none',
        legend:{alignment:'center',
                textStyle:{ color: 'black',fontSize: '14'}
        },
        chartArea: { 
            left: "25%", 
            width: 380, 
            height: 380
        },
        colors: ['rgb(39, 182, 186)', 'rgb(233, 94, 81)', 'rgb(255, 176, 36)', 'rgb(176, 180, 187)']
    };

    var chart = new google.visualization.PieChart(document.getElementById('mywork-assign_chart'));
    chart.draw(data, options);
    $('#cnt').text(${mycompleteWorkCnt+mylateEndWorkCnt+myplanWorkCnt+mynullEndWorkCnt});
    window.addEventListener('resize', function() { chart.draw(data, options); }, false);
}

// 나의 활동 이력(체크리스트 작성 개수, 코멘트 개수, 첨부파일 개수)
function myworkWriteChart(){
    var data = google.visualization.arrayToDataTable([
        ['종류', '개수'],
        ['체크리스트', ${myActivityCnt.myChkCnt}],
        ['코멘트', ${myActivityCnt.myAttachCnt}],
        ['첨부파일', ${myActivityCnt.myCommentCnt}]
    ]);

    var options ={
        height: 280,
        pieHole: 0.8,
        showLables: 'true',
        pieSliceText:'none',
        legend:{alignment:'center',
                textStyle:{ color: 'black',fontSize: '14'}
        },
        chartArea: { 
            left: "25%", 
            width: 380, 
            height: 380
        },
        colors: ['rgb(39, 182, 186)', 'rgb(233, 94, 81)', 'rgb(255, 176, 36)', 'rgb(176, 180, 187)']
        };

    var chart = new google.visualization.PieChart(document.getElementById('mywork-write_chart'));
    chart.draw(data, options);
    $('#write-cnt').text(${myActivityCnt.myChkCnt + myActivityCnt.myAttachCnt + myActivityCnt.myCommentCnt});
    window.addEventListener('resize', function() { chart.draw(data, options); }, false);
}
</script>
