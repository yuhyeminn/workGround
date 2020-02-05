<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/club/clubViewModal.jsp"></jsp:include>

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

$(function() {
	//파일 선택/취소시에 파일명 노출하기
	$("[name=upFile]").on("change", function() {
		//파일입력 취소
		if($(this).prop("files")[0] === undefined) {
			$(this).next(".custom-file-label").html("파일을 선택하세요.");
			return;
		}
		
		var fileName = $(this).prop('files')[0].name;
		$(this).next(".custom-file-label").html(fileName);
	});
	
});

function validate() {
	var title = $("[name=clubPhotoTitle]").val();
	var fileName = $(this).prop('files')[0].name;
	if(title.trim().length==0) {
		alert('제목을 입력하세요.');
		return false;
	}
	else if(fileName.length==0) {
		alert('파일을 선택하세요.');
		return false;
	}
	return true;
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
			              <div class="card new" id="new-club-card" data-toggle="modal" data-target="#insertPhoto">
			                <div class="card-body">
			                  <i class="fas fa-plus"></i>
			                  <h6>새 사진</h6>
			                </div>
			              </div><!-- /.card -->
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
                                 ${club.clubIntroduce }
                            </p>
                        </div>
                        <!-- ./card-body -->
                    </div>
                    <!-- /.card -->
                </div>
                <!-- /.col -->
            </section>
            <!-- /.card-content -->

            <!-- 동호회 일정 -->
            <section id="project-in">
                <div class="card-header" role="button" onclick="toggleList(this);">
                    <h3><i class="fas fa-chevron-down"></i> <i class="fas fa-calendar-alt"></i> 2월 일정 <span
                        class="header-count">(2)</span></h3>
                </div><!-- /.card-header -->
                <div class="row card-content">
                    <!-- 일정 -->
                    <c:if test="${not empty clubPlanList }">
					<c:forEach items="${clubPlanList }" var="clubPlan" varStatus="vs">
	                    <div class="col-12 col-sm-6 col-md-3">
	                        <div class="card mywork" data-toggle="modal" data-target="'#planView'+${clubPlan.clubNo }">
	                            <div class="card-body">
	                                <!-- 타이틀 -->
	                                <div class="card-title text-center">
	                                    <h5>${clubPlan.clubPlanTitle }</h5>
	                                </div>
	                                <!-- 날짜정보 -->
	                                <div class="card-status">
	                                    <span class="btn btn-block btn-sm bg-success">${clubPlan.clubPlanState }</span>
	                                    <span class="end-date"><i class="far fa-calendar-alt"></i> ${clubPlan.clubPlanStart }</span>
	                                </div>
	                            </div>
	                        </div><!-- /.card -->
	                    </div>
                    </c:forEach>
					</c:if>

                    <!-- 일정 추가 -->
                    <div class="col-12 col-sm-6 col-md-3">
		              <div class="card new" id="new-club-card" data-toggle="modal" data-target="#insertPlan">
		                <div class="card-body">
		                  <i class="fas fa-plus"></i>
		                  <h6>새 일정</h6>
		                </div>
		              </div><!-- /.card -->
		            </div>
                </div>
            </section>
            <!-- /.card-content -->

            
        
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
		      <div class="card new" id="new-club-card" data-toggle="modal" data-target="#insertNotice">
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


<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>