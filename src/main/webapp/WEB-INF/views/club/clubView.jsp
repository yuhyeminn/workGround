<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<style>
.note-editing-area {
max-height: 400px;
}
#navbar-club #noticeSearchFrm{margin-left: 1rem;}
#info-wrapper .card-body{padding: 3rem 1.25rem;}
#info-wrapper .card-header{margin-top: 0;}
#info-wrapper .card-title{color: ##464c59; font-size: 1rem; font-weight: bold;}
/* nav new club */
#nav-new-club{color:white;border:none;padding:0.35rem 0.5rem;margin-right:1rem;border-radius: 0.25rem;}
/* new club card */
#new-club-card{height: 298x; text-align: center; padding: 6rem 0rem;}
#new-club-card .card-body{color: #17a2b8;}
#new-club-card i{margin-bottom: .7rem; font-size:30px;}
#new-club-card:hover {background: #17a2b8;}
#new-club-card:hover .card-body{color: #fff;}
</style>

<script>
$(function(){
	//Summernote
	$('.textarea').summernote();
	//Date range picker
	$('#reservation').daterangepicker();
	//Date range picker with time picker
	$('#reservationtime').daterangepicker({
	    timePicker: true,
	    timePickerIncrement: 30,
	    locale: {
	    format: 'MM/DD/YYYY hh:mm A'
	    }
	});
	//Date range as a button
	$('#daterange-btn').daterangepicker(
	    {
	    ranges: {
	        'Today': [moment(), moment()],
	        'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
	        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
	        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
	        'This Month': [moment().startOf('month'), moment().endOf('month')],
	        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
	    },
	    startDate: moment().subtract(29, 'days'),
	    endDate: moment()
	    },
	    function (start, end) {
	    $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'))
	    }
	);
	
	sidebarActive(); //사이드바 활성화
	tabActive(); //서브헤더 탭 활성화
});

//사이드바 활성화
function sidebarActive(){
	let navLinkArr = document.querySelectorAll(".sidebar .nav-link");
	
	navLinkArr.forEach((obj, idx)=>{
		let $obj = $(obj);
		if($obj.hasClass('active'))
			$obj.removeClass('active');
	});
	
	$("#sidebar-club").addClass("active");
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

    $("#tab-club").addClass("active");
}
</script>

<!-- Navbar ClubView -->
<nav id="navbar-club" class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
    <!-- Left navbar links -->
    <!-- SEARCH FORM -->
    <form id="noticeSearchFrm" class="form-inline">
        <div class="input-group input-group-sm">
            <input class="form-control form-control-navbar" type="search" placeholder="oo동호회 검색" aria-label="Search">
            <div class="input-group-append">
            <button class="btn btn-navbar" type="submit">
                <i class="fas fa-search"></i>
            </button>
            </div>
        </div>
    </form>

    <!-- Middle navbar links -->
    <ul id="navbar-tab" class="navbar-nav ml-auto">
        <li id="tab-club" class="nav-item"><button type="button">동호회</button></li>
        <li id="tab-calendar" class="nav-item"><button type="button">일정</button></li>
        <li id="tab-member" class="nav-item"><button type="button">멤버</button></li>
        <li id="tab-attachment" class="nav-item"><button type="button">파일</button></li>
    </ul>

    <!-- Right navbar links -->
    <ul id="viewRightNavbar-wrapper" class="navbar-nav ml-auto">
        <!-- 동호회 대화 -->
        <li class="nav-item">
            <button type="button" class="btn btn-block btn-default btn-xs nav-link">
                <i class="far fa-comments"></i> 동호회 대화
            </button>
        </li>

        <!-- 동호회 멤버 -->
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

        <!-- 동호회 설정 -->
        <li class="nav-item">
            <button type="button" class="btn btn-block btn-default btn-xs nav-link">
                <i class="fas fa-cog"></i>
            </button>
        </li>
    </ul>
</nav>
<!-- /.navbar -->

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <h2 class="sr-only">동호회 상세보기</h2>
    <!-- Main content -->
    <div class="content">
        <div class="container-fluid">
            <!-- 동호회 사진 -->
            <section class="project-recent">
            <div class="card-header" role="button" onclick="toggleList(this);">
                <h3><i class="fas fa-chevron-down"></i> <i class="fas fa-images"></i> 활동사진</h3>
            </div><!-- /.card-header -->
            <div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
                <div class="carousel-inner">
                <div class="carousel-item active">
                    <div class="row card-content">
                    <div class="col-12 col-sm-6 col-md-3">
                        <div class="card">
                        <div class="card-body">
                            <img src="${pageContext.request.contextPath}/resources/img/club/volunteer1.jpg" alt="..." class="img-thumbnail" data-toggle="modal"
                            data-target="#exampleModalCenter">
                        </div>
                        </div><!-- /.card -->
                    </div>
                    <div class="col-12 col-sm-6 col-md-3">
                        <div class="card">
                        <div class="card-body">
                            <img src="${pageContext.request.contextPath}/resources/img/photo2.png" alt="..." class="img-thumbnail">
                        </div>
                        </div><!-- /.card -->
                    </div>
                    <div class="col-12 col-sm-6 col-md-3">
                        <div class="card">
                        <div class="card-body">
                            <img src="${pageContext.request.contextPath}/resources/img/photo3.jpg" alt="..." class="img-thumbnail">
                        </div>
                        </div><!-- /.card -->
                    </div>
                    <div class="col-12 col-sm-6 col-md-3">
                        <div class="card">
                        <div class="card-body">
                            <img src="${pageContext.request.contextPath}/resources/img/photo4.jpg" alt="..." class="img-thumbnail">
                        </div>
                        </div><!-- /.card -->
                    </div>
                    </div>
                </div>
                <div class="carousel-item">
                    <div class="row card-content">
                    <div class="col-12 col-sm-6 col-md-3">
                        <div class="card">
                        <div class="card-body">
                            <img src="${pageContext.request.contextPath}/resources/img/club/volunteer1.jpg" alt="..." class="img-thumbnail" data-toggle="modal"
                            data-target="#exampleModalCenter">
                        </div>
                        </div><!-- /.card -->
                    </div>
                    <div class="col-12 col-sm-6 col-md-3">
                        <div class="card">
                        <div class="card-body">
                            <img src="${pageContext.request.contextPath}/resources/img/club/volunteer2.jpg" alt="..." class="img-thumbnail">
                        </div>
                        </div><!-- /.card -->
                    </div>
                    <div class="col-12 col-sm-6 col-md-3">
                        <div class="card">
                        <div class="card-body">
                            <img src="${pageContext.request.contextPath}/resources/img/club/volunteer3.jpg" class="img-thumbnail">
                        </div>
                        </div><!-- /.card -->
                    </div>
                    <div class="col-12 col-sm-6 col-md-3">
                        <div class="card">
                        <div class="card-body">
                            <img src="${pageContext.request.contextPath}/resources/img/club/volunteer4.jfif" alt="..." class="img-thumbnail">
                        </div>
                        </div><!-- /.card -->
                    </div>
                    </div>
                </div>
                <div class="carousel-item">
                    <div class="row card-content">
                    <div class="col-12 col-sm-6 col-md-3">
                        <div class="card">
                        <div class="card-body">
                            <img src="${pageContext.request.contextPath}/resources/img/photo1.png" alt="..." class="img-thumbnail">
                        </div>
                        </div><!-- /.card -->
                    </div>
                    <div class="col-12 col-sm-6 col-md-3">
                        <div class="card">
                        <div class="card-body">
                            <img src="${pageContext.request.contextPath}/resources/img/photo2.png" alt="..." class="img-thumbnail">
                        </div>
                        </div><!-- /.card -->
                    </div>
                    <div class="col-12 col-sm-6 col-md-3">
                        <div class="card">
                        <div class="card-body">
                            <img src="${pageContext.request.contextPath}/resources/img/photo3.jpg" alt="..." class="img-thumbnail">
                        </div>
                        </div><!-- /.card -->
                    </div>
                    <div class="col-12 col-sm-6 col-md-3">
                        <div class="card">
                        <div class="card-body">
                            <img src="${pageContext.request.contextPath}/resources/img/photo4.jpg" alt="..." class="img-thumbnail">
                        </div>
                        </div><!-- /.card -->
                    </div>
                    </div>
                </div>
                </div>
                <!-- Image Modal -->
                <div class="modal fade cd-example-modal-lg" id="exampleModalCenter" tabindex="-1" role="dialog"
                aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content card card-outline card-info">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLongTitle">연탄봉사활동</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <img src="${pageContext.request.contextPath}/resources/img/club/volunteer1.jpg" alt="..." class="img-thumbnail" data-toggle="modal"
                        data-target="#exampleModalCenter">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary" data-dismiss="modal" data-toggle="modal"
                        style="background-color: #17a2b8; border-color: #17a2b8;">수정</button>
                    </div>
                    </div>
                </div>
                </div>
                <a class="carousel-control-prev" href="#carouselExampleControls" role="button" data-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="sr-only">Previous</span>
                </a>
                <a class="carousel-control-next" href="#carouselExampleControls" role="button" data-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="sr-only">Next</span>
                </a>
            </div>
            </section>
            <!-- /.card-content -->

            <!-- 동호회 소개 -->
            <section id="info-wrapper" class="project-important">
                <div class="card-header" role="button" onclick="toggleList(this);">
                    <h3><i class="fas fa-chevron-down"></i> <i class="fas fa-poll-h"></i> 동호회 소개
                </div><!-- /.card-header -->
                <div class="col-md-12" data-toggle="modal" data-target="#info">
                    <div class="card">
                        <div class="card-header" style="border-bottom: 1px solid rgba(0,0,0,.125);">
                            <h5 class="card-title" style="padding-left: 25px;">봉사동호회</h5>
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">
                            <p class="text-center">
                                봉사활동을 하고싶으신 분들을 위해 모이기 시작한 동호회입니다
                                <br>
                                한 달에 두 번 토요일에 봉사활동을 하는 정기모임을 갖습니다.
                            </p>
                        </div>
                        <!-- ./card-body -->
                    </div>
                    <!-- /.card -->
                </div>
                <!-- /.col -->
            </section>
            <!-- /.card-content -->

            <!-- info Modal -->
            <div class="modal fade" id="info" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content card card-outline card-info">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">봉사동아리</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <br>
                    봉사활동을 하고싶으신 분들을 위해 모이기 시작한 동호회입니다.
                    <br>
                    한 달에 두 번 토요일에 봉사활동을 하는 정기모임을 갖습니다.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-primary" data-dismiss="modal" data-toggle="modal"
                    style="background-color: #17a2b8; border-color: #17a2b8;">수정</button>
                </div>
                </div>
            </div>
            </div>
            <!-- plan-details Modal -->
            <form action="" method="post">
            <div class="modal fade cd-example-modal-lg" id="plan-details" tabindex="-1" role="dialog"
                aria-labelledby="exampleModalCenterTitle" aria-hidden="true" data-backdrop="static">
                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                <div class="modal-content card card-outline card-info">
                    <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">일정추가하기</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    </div>
                    <div class="modal-body">
                    <div class="form-group">
                        <label for="inputName">일정</label>
                        <p style="margin-left: 10px;">보육원 봉사</p>
                    </div>
                    <div class="form-group">
                        <div class="mb-3">
                        <label for="inputDescription">일정 내용</label>
                        <div style="margin-left: 10px;">
                            희망보육원에서 오전 11시부터 오후 4시까지 봉사활동을 할 예정입니다.
                            <br>
                            많은 참석 부탁드립니다.
                        </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputStatus">상태</label>
                        <span class="btn btn-block btn-sm bg-success" style="margin-left: 10px; width: 70px;">예정</span>
                    </div>
                    <div class="form-group">
                        <label for="inputClientCompany">장소</label>
                        <p style="margin-left: 10px;">희망보육원</p>
                    </div>
                    <div class="form-group">
                        <label for="inputProjectLeader">담당진행자</label>
                        <p style="margin-left: 10px;">봉동회장</p>
                    </div>
                    <div class="form-group">
                        <label for="inputProjectLeader">참석자</label>
                        <p>
                        <!-- 프로필 사진 -->
                        <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile"
                            style="width: 50px; margin-left: 10px;">
                        </p>
                    </div>
                    </div>
                    <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-primary" data-target="#plan-modify" data-dismiss="modal"
                        data-toggle="modal" style="background-color: #17a2b8; border-color: #17a2b8;">수정</button>
                    <button type="button" class="btn btn-info float-right"><i class="fas fa-plus"></i></button>
                    </div>
                </div>
                </div>
            </div>
            </form>
            <!-- plan Modal -->
            <form action="" method="post">
            <div class="modal fade cd-example-modal-lg" id="plan" tabindex="-1" role="dialog"
                aria-labelledby="exampleModalCenterTitle" aria-hidden="true" data-backdrop="static">
                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                <div class="modal-content card card-outline card-info">
                    <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">일정추가하기</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    </div>
                    <div class="modal-body">
                    <div class="form-group">
                        <label for="inputName">일정</label>
                        <input type="text" id="inputName" class="form-control" placeholder="일정을 입력하세요.">
                    </div>
                    <!-- <div class="form-group">
                        <label for="inputDescription">일정 내용</label>
                        <textarea id="inputDescription" class="form-control" rows="4"></textarea>
                    </div> -->
                    <div class="form-group">
                        <div class="mb-3">
                        <label for="inputDescription">일정 내용</label>
                        <textarea id="inputDescription" class="textarea"
                            style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;"></textarea>
                        </div>
                    </div>
                    <!-- Date picker -->
                    <div class="form-group">
                        <label for="">날짜</label>
                        <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="far fa-calendar-alt"></i></span>
                        </div>
                        <input type="text" class="form-control float-right" id="reservation">
                        </div>
                        <!-- /.input group -->
                    </div>
                    <!-- /.form group -->
                    <div class="form-group">
                        <label for="inputStatus">상태</label>
                        <select class="form-control custom-select">
                        <option selected disabled>선택하세요.</option>
                        <option selected>예정</option>
                        <option>완료</option>
                        <option>취소</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="inputClientCompany">장소</label>
                        <input type="text" id="inputClientCompany" class="form-control" placeholder="장소를 입력하세요.">
                    </div>
                    <div class="form-group">
                        <label for="inputProjectLeader">담당진행자</label>
                        <input type="text" id="inputProjectLeader" class="form-control" placeholder="담당진행자를 입력하세요.">
                    </div>
                    </div>
                    <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-primary" data-target="#notice-modify"
                        style="background-color: #17a2b8; border-color: #17a2b8;">추가</button>
                    </div>
                </div>
                </div>
            </div>
            </form>
            <!-- plan-modify Modal -->
            <form action="" method="post">
            <div class="modal fade cd-example-modal-lg" id="plan-modify" tabindex="-1" role="dialog"
                aria-labelledby="exampleModalCenterTitle" aria-hidden="true" data-backdrop="static"
                style="overflow-y: auto;">
                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                <div class="modal-content card card-outline card-info">
                    <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">일정추가하기</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    </div>
                    <div class="modal-body">
                    <div class="form-group">
                        <label for="inputName">일정</label>
                        <input type="text" id="inputName" class="form-control" placeholder="일정을 입력하세요." value="보육원 봉사">
                    </div>
                    <!-- <div class="form-group">
                        <label for="inputDescription">일정 내용</label>
                        <textarea id="inputDescription" class="form-control" rows="4"></textarea>
                    </div> -->
                    <div class="form-group">
                        <div class="mb-3">
                        <label for="inputDescription">일정 내용</label>
                        <textarea id="inputDescription" class="textarea"
                            style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;">희망보육원에서 오전 11시부터 오후 4시까지 봉사활동을 할 예정입니다.
                            <br>
                            많은 참석 부탁드립니다.</textarea>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputStatus">상태</label>
                        <select class="form-control custom-select">
                        <option selected disabled>선택하세요.</option>
                        <option selected>예정</option>
                        <option>완료</option>
                        <option>취소</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="inputClientCompany">장소</label>
                        <input type="text" id="inputClientCompany" class="form-control" placeholder="장소를 입력하세요."
                        value="희망보육원">
                    </div>
                    <div class="form-group">
                        <label for="inputProjectLeader">담당진행자</label>
                        <input type="text" id="inputProjectLeader" class="form-control" placeholder="담당진행자를 입력하세요."
                        value="봉동회장">
                    </div>
                    </div>
                    <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-primary" data-target="#notice-modify"
                        style="background-color: #17a2b8; border-color: #17a2b8;">추가</button>
                    </div>
                </div>
                </div>
            </div>
            </form>

            <!-- 동호회 일정 -->
            <section id="project-in">
                <div class="card-header" role="button" onclick="toggleList(this);">
                    <h3><i class="fas fa-chevron-down"></i> <i class="fas fa-calendar-alt"></i> 2월 일정 <span
                        class="header-count">(2)</span></h3>
                </div><!-- /.card-header -->
                <div class="row card-content">
                    <!-- 일정 -->
                    <div class="col-12 col-sm-6 col-md-3">
                        <div class="card mywork" data-toggle="modal" data-target="#plan-details">
                            <div class="card-body">
                                <!-- 타이틀 -->
                                <div class="card-title text-center">
                                    <h5>보육원 봉사</h5>
                                </div>
                                <!-- 날짜정보 -->
                                <div class="card-status">
                                    <span class="btn btn-block btn-sm bg-success">예정</span>
                                    <span class="end-date"><i class="far fa-calendar-alt"></i> 2월 8일</span>
                                </div>
                            </div>
                        </div><!-- /.card -->
                    </div>

                    <!-- 일정 추가 -->
                    <div class="col-12 col-sm-6 col-md-3">
		              <div class="card new" id="new-club-card">
		                <div class="card-body">
		                  <i class="fas fa-plus"></i>
		                  <h6>새 일정</h6>
		                </div>
		              </div><!-- /.card -->
		            </div>
                </div>
            </section>
            <!-- /.card-content -->

            <!-- notice Modal -->
            <div class="modal fade cd-example-modal-lg" id="notice" tabindex="-1" role="dialog"
            aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                <div class="modal-content card card-outline card-info">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">2월 14일 신입회원 환영회 있습니다.</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    2월 14일 신입회원 환영회식 있습니다.
                    <br>
                    장소는 진씨화로이며 시간은 퇴근 후 7시 30분입니다.
                    <br><br>
                    새로 들어오신 신입회원분들과 친해지기 위해서 모두 늦지않게 도착해주시기 바랍니다.
                    <br><br>
                    항상 열심히 해주시는 모든 회원분들께 감사드립니다.
                    <br>
                    좋은하루 보내시기 바랍니다.
                </div>
                <div class="card-footer card-comments">
                    <div class="card-comment">
                    <!-- User image -->
                    <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/user3-128x128.jpg" alt="User Image">

                    <div class="comment-text">
                        <span class="username">
                        Maria Gonzales
                        <span class="text-muted float-right">8:03 PM Today</span>
                        </span><!-- /.username -->
                        It is a long established fact that a reader will be distracted
                        by the readable content of a page when looking at its layout.
                    </div>
                    <!-- /.comment-text -->
                    </div>
                    <!-- /.card-comment -->
                    <div class="card-comment">
                    <!-- User image -->
                    <img class="img-circle img-sm" src="../dist/img/user4-128x128.jpg" alt="User Image">

                    <div class="comment-text">
                        <span class="username">
                        Luna Stark
                        <span class="text-muted float-right">8:03 PM Today</span>
                        </span><!-- /.username -->
                        It is a long established fact that a reader will be distracted
                        by the readable content of a page when looking at its layout.
                    </div>
                    <!-- /.comment-text -->
                    </div>
                    <!-- /.card-comment -->
                </div>
                <!-- /.card-footer -->
                <div class="card-footer">
                    <form action="#" method="post">
                    <img class="img-fluid img-circle img-sm" src="../dist/img/user4-128x128.jpg" alt="Alt Text">
                    <!-- .img-push is used to add margin to elements next to floating images -->
                    <div class="img-push">
                        <input type="text" class="form-control form-control-sm" placeholder="Press enter to post comment">
                    </div>
                    </form>
                </div>
                <!-- /.card-footer -->
                <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" data-toggle="modal"
                    data-target="#notice-modify" style="background-color: #17a2b8; border-color: #17a2b8;">수정</button>
                </div>
            </div>
            </div>
        </div>
        
        <!-- 공지사항 -->
        <section id="project-in">
            <div class="card-header" role="button" onclick="toggleList(this);">
            	<h3><i class="fas fa-chevron-down"></i> <i class="fas fa-exclamation-circle"></i> 공지사항 <span class="header-count">(1)</span></h3>
            </div><!-- /.card-header -->
            <div class="row card-content">
            <!-- 공지사항 -->
            <div class="col-12 col-sm-6 col-md-3">
                <div class="card mywork">
                <div class="card-body" data-toggle="modal" data-target="#notice">
                    <!-- 제목 -->
                    <div class="card-title" style="margin-bottom: 50px;">
                    <h5>2월 14일 신입회원 환영회식 있습니다.</h5>
                    </div>
                    <!-- 프로필 사진 -->
                    <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile">
                    <!-- 타이틀 -->
                    <div class="card-title text-center">
                    <h5>봉동회장</h5>
                    </div>
                </div>
                </div><!-- /.card -->
            </div>

            <!-- 공지 추가 -->
            <!-- 일정 추가 -->
            <div class="col-12 col-sm-6 col-md-3">
		      <div class="card new" id="new-club-card">
		        <div class="card-body">
		          <i class="fas fa-plus"></i>
		          <h6>새 공지</h6>
		        </div>
		      </div><!-- /.card -->
		    </div>
        </section>
        <!-- /.card-content -->

        <!-- notice Modal -->
        <div class="modal fade cd-example-modal-lg" id="notice" tabindex="-1" role="dialog"
            aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
            <div class="modal-content card card-outline card-info">
                <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLongTitle">2월 14일 신입회원 환영회 있습니다.</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                </div>
                <div class="modal-body">
                2월 14일 신입회원 환영회식 있습니다.
                <br>
                장소는 진씨화로이며 시간은 퇴근 후 7시 30분입니다.
                <br><br>
                새로 들어오신 신입회원분들과 친해지기 위해서 모두 늦지않게 도착해주시기 바랍니다.
                <br><br>
                항상 열심히 해주시는 모든 회원분들께 감사드립니다.
                <br>
                좋은하루 보내시기 바랍니다.
                </div>
                <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" data-toggle="modal"
                    data-target="#notice-modify" style="background-color: #17a2b8; border-color: #17a2b8;">수정</button>
                </div>
            </div>
            </div>
        </div>
        </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->

<!-- #notice-modify modal -->
<form method="POST">
	<div class="modal fade cd-example-modal-lg" id="notice-modify" tabindex="-1" role="dialog"
	    aria-labelledby="myLargeModalLabel" aria-hidden="true" data-backdrop="static">
	    <div class="modal-dialog modal-dialog-centered modal-lg">
	    <div class="modal-content card card-outline card-info">
	        <div class="modal-header col-12">
	        <input type="text" class="form-control" value="2월 14일 신입회원 환영회 있습니다.">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	            <span aria-hidden="true">&times;</span>
	        </button>
	        </div>
	        <div class="card-body pad">
	        <div class="mb-3">
	            <textarea class="textarea"
	            style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;">2월 14일 신입회원 환영회식 있습니다.
	            <br>
	            장소는 진씨화로이며 시간은 퇴근 후 7시 30분입니다.
	            <br><br>
	            새로 들어오신 신입회원분들과 친해지기 위해서 모두 늦지않게 도착해주시기 바랍니다.
	            <br><br>
	            항상 열심히 해주시는 모든 회원분들께 감사드립니다.
	            <br>
	            좋은하루 보내시기 바랍니다.</textarea>
	        </div>
	        </div>
	        <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
	        <button type="button" class="btn btn-primary"
	            style="background-color: #17a2b8; border-color: #17a2b8;">수정</button>
	        </div>
	    </div>
	    </div>
	</div>
</form>

<!-- #notice-input modal -->
<form method="POST">
	<div class="modal fade cd-example-modal-lg" id="notice-input" tabindex="-1" role="dialog"
	    aria-labelledby="myLargeModalLabel" aria-hidden="true" data-backdrop="static">
	    <div class="modal-dialog modal-dialog-centered modal-lg">
	    <div class="modal-content card card-outline card-info">
	        <div class="modal-header col-12">
	        <input type="text" class="form-control" placeholder="제목을 입력하세요.">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	            <span aria-hidden="true">&times;</span>
	        </button>
	        </div>
	        <div class="card-body pad">
	        <div class="mb-3">
	            <textarea class="textarea"
	            style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;"></textarea>
	        </div>
	        </div>
	        <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
	        <button type="button" class="btn btn-primary"
	            style="background-color: #17a2b8; border-color: #17a2b8;">추가</button>
	        </div>
	    </div>
	    </div>
	</div>
</form>		

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>