<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<link rel="stylesheet" property="stylesheet" href="${pageContext.request.contextPath}/resources/css/hyemin.css">

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
        ['', 5, 6, 4, 3]
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
        ['해야할 일', 5, 6, 4, 3],
        ['진행중', 0, 2, 11, 5],
        ['완료', 15, 0, 0, 0]
    ]);
    var options_fullStacked = {
        isStacked: 'percent',
        height: 300,
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
        ['완료됨', 11],
        ['마감일 지남', 2],
        ['계획됨', 2],
        ['마감일 없음', 2]
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
        tooltip: {
            trigger:'none'
        },
        colors: ['rgb(39, 182, 186)', 'rgb(233, 94, 81)', 'rgb(255, 176, 36)', 'rgb(176, 180, 187)']
    };

    var chart = new google.visualization.PieChart(document.getElementById('mywork-assign_chart'));
    chart.draw(data, options);
    $('#cnt').text('5');
    window.addEventListener('resize', function() { chart.draw(data, options); }, false);
}

// 내가 작성한 업무
function myworkWriteChart(){
    var data = google.visualization.arrayToDataTable([
        ['Task', 'Hours per Day'],
        ['완료됨', 2],
        ['마감일 지남', 1],
        ['계획됨', 0],
        ['마감일 없음', 2]
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
        tooltip: {
            trigger:'none'
        },
        colors: ['rgb(39, 182, 186)', 'rgb(233, 94, 81)', 'rgb(255, 176, 36)', 'rgb(176, 180, 187)']
        };

    var chart = new google.visualization.PieChart(document.getElementById('mywork-write_chart'));
    chart.draw(data, options);
    $('#write-cnt').text('5');
    window.addEventListener('resize', function() { chart.draw(data, options); }, false);
}
</script>		

<!-- Navbar Project -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light navbar-project navbar-projectView">
    <!-- Left navbar links -->
    <ul class="navbar-nav">
    <li id="go-back" class="nav-item text-center">
        <a class="nav-link" href=""><i class="fas fa-chevron-left"></i></a>
    </li>
    <li id="project-name" class="nav-item">
        <button type="button" id="btn-star"><i class="fas fa-star"></i></button>
        기획
    </li>
    </ul>

    <!-- Middle navbar links -->
    <ul id="navbar-tab" class="navbar-nav ml-auto">
        <li id="tab-work" class="nav-item"><button type="button">업무</button></li>
        <li id="tab-timeline" class="nav-item"><button type="button">타임라인</button></li>
        <li id="tab-analysis" class="nav-item"><button type="button">분석</button></li>
        <li id="tab-attachment" class="nav-item"><button type="button" id="btn-tab-attach">파일</button></li>
    </ul>

    <!-- Right navbar links -->
    <ul id="viewRightNavbar-wrapper" class="navbar-nav ml-auto">
        <!-- 프로젝트 대화 -->
        <li class="nav-item">
            <button type="button" class="btn btn-block btn-default btn-xs nav-link">
                <i class="far fa-comments"></i> 프로젝트 대화
            </button>
        </li>

        <!-- 프로젝트 멤버 -->
        <li id="nav-member" class="nav-item dropdown">
            <a class="nav-link" data-toggle="dropdown" href="#">
                <i class="far fa-user"></i> 6
            </a>
            <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
            <a href="#" class="dropdown-item">
                <!-- Message Start -->
                <div class="media">
                <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                <div class="media-body">
                    <p class="memberName">Brad Diesel</p>
                </div>
                </div>
                <!-- Message End -->
            </a>
            <a href="#" class="dropdown-item">
                <!-- Message Start -->
                <div class="media">
                <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                <div class="media-body">
                    <p class="memberName">Brad Diesel</p>
                </div>
                </div>
                <!-- Message End -->
            </a>
            <a href="#" class="dropdown-item">
                <!-- Message Start -->
                <div class="media">
                <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                <div class="media-body">
                    <p class="memberName">Brad Diesel</p>
                </div>
                </div>
                <!-- Message End -->
            </a>
            <a href="#" class="dropdown-item">
                <!-- Message Start -->
                <div class="media">
                <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                <div class="media-body">
                    <div class="media-body">
                    <p class="memberName">Brad Diesel</p>
                    </div>
                </div>
                </div>
                <!-- Message End -->
            </a>
            <a href="#" class="dropdown-item">
                <!-- Message Start -->
                <div class="media">
                <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                <div class="media-body">
                    <p class="memberName">Brad Diesel</p>
                </div>
                </div>
                <!-- Message End -->
            </a>
            </div>
        </li>

        <!-- 프로젝트 설정 -->
        <li class="nav-item">
            <button type="button" class="btn btn-block btn-default btn-xs nav-link">
            <i class="fas fa-cog"></i>
            </button>
        </li>
    </ul>
</nav>
<!-- /.navbar -->		

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper navbar-light">
    <div class="analysis-content">
        <div class="project-summary content-box">
            <div class="row">
            <div class="summary-col-sm col-6 border-right">
                <div class="description-block ">
                <h5 class="description-header">시작일</h5>
                <span class="description-text">1월 10일</span>
                </div>
                <!-- /.description-block -->
            </div>
            <!-- /.col -->
            <div class="summary-col-sm col-6 border-right">
                <div class="description-block ">
                <h5 class="description-header">마감일</h5>
                <span class="description-text">1월 31일</span>
                </div>
                <!-- /.description-block -->
            </div>
            <!-- /.col -->
            <div class="summary-col-sm col-6 border-right">
                <div class="description-block ">
                <h5 class="description-header">완료일</h5>
                <span class="description-text"> - </span>
                </div>
                <!-- /.description-block -->
            </div>
            <!-- /.col -->
            <div class="summary-col-sm col-6 border-right">
                <div class="description-block ">
                <h5 class="description-header">경과 시간</h5>
                <span class="description-text"> - </span>
                </div>
                <!-- /.description-block -->
            </div>
            <div class="summary-col-sm col-6 border-right">
                <div class="description-block ">
                <h5 class="description-header">남은 시간</h5>
                <span class="description-text"> 15일 </span>
                </div>
                <!-- /.description-block -->
            </div>
            <div class="summary-col-sm col-6 border-right">
                <div class="description-block ">
                <h5 class="description-header">완료됨</h5>
                <span class="description-text">3개 업무(27%)</span>
                </div>
                <!-- /.description-block -->
            </div>
            <div class="summary-col-sm col-6">
                <div class="description-block">
                <h5 class="description-header">남은업무</h5>
                <span class="description-text">8개 업무 (73%)</span>
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
                <p class="content-box-header" style="text-align: center;margin-bottom: 20px;">내가 작성한 업무</p>
                <div class="chart-container">
                <div id="mywork-write_chart"></div>
                <div id="write-cnt" class="overlay"></div>
                <div class="overlay-label">전체 업무</div>
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
</div>
<!-- /.content-wrapper -->

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>