<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<script>
$(function(){
	$(".club").click(function(){
	  //$("#modal-club").modal();
		
	});
	
	$("#new-club-card").click(function(){
	  $("#modal-new-club").modal();
	});
	
	$("#nav-new-club").click(function(){
	  $("#modal-new-club").modal();
	});
	
	sidebarActive(); //사이드바 활성화
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
</script>

<style>
/*card*/
.card-club-image img {
	margin-top: 0.5rem;
	width: 100%;
	height: 200px;
}

.card-enroll-date {
	margin-top: 0.5rem;
	float: right;
}

.card-stand {
	margin-top: 0.5rem;
}

/*modal*/
.modal-club-info {
	color: gray;
}

#modal-image-slider img {
	width: 70%;
	height: 300px;
	margin-bottom: 2rem;
}

#up-btn {
	margin-top: 0.5rem;
	color: #464c59;
}
/*club-form*/
.form-check {
	margin: 0.7rem;
}

#btn-sub {
	margin: 1rem 0 2rem;
	text-align: center;
}
/* nav new club */
#nav-new-club {
	color: white;
	border: none;
	padding: 0.35rem 0.5rem;
	margin-right: 1rem;
	border-radius: 0.25rem;
}
/* new club card */
#new-club-card {
	height: 298x;
	text-align: center;
	padding: 6rem 0rem;
}

#new-club-card .card-body {
	color: #17a2b8;
}

#new-club-card i {
	margin-bottom: .7rem;
	font-size: 30px;
}

#new-club-card:hover {
	background: #17a2b8;
}

#new-club-card:hover .card-body {
	color: #fff;
}

/*meeting-cycle*/
#meeting-cycle {
	width: 20%;
}
</style>

<!-- Navbar Club -->
<nav
	class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
	<!-- Left navbar links -->
	<ul class="navbar-nav">
		<li class="nav-item dropdown"><a class="nav-link dropdown-toggle"
			data-toggle="dropdown" href="#"> 카테고리 <span class="caret"></span>
		</a>
			<div class="dropdown-menu">
				<a class="dropdown-item" tabindex="-1" href="#">사회</a> <a
					class="dropdown-item" tabindex="-1" href="#">취미</a> <a
					class="dropdown-item" tabindex="-1" href="#">음식</a> <a
					class="dropdown-item" tabindex="-1" href="#">운동</a> <a
					class="dropdown-item" tabindex="-1" href="#">문학</a> <a
					class="dropdown-item" tabindex="-1" href="#">기타</a>

			</div></li>
	</ul>

	<!-- Right navbar links -->
	<ul class="navbar-nav ml-auto navbar-nav-sort">
		<li class="nav-item dropdown">정렬 <a
			class="nav-link dropdown-toggle" data-toggle="dropdown" href="#">
				이름순 <span class="caret"></span>
		</a>
			<div class="dropdown-menu">
				<a class="dropdown-item" tabindex="-1" href="#">등록일순</a> <a
					class="dropdown-item" tabindex="-1" href="#">이름순</a>
			</div>
		</li>
		<!-- 새 동호회 만들기 -->
		<li class="nav-item">
			<button id="nav-new-club" class="bg-info" style="font-size: 0.85rem;"
				data-toggle="modal" data-target="#add-project-modal">
				<i class="fa fa-plus"></i> <span>새 동호회</span>
			</button>
		</li>
	</ul>
</nav>
<!-- /.navbar -->

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
	<!-- Main content -->
	<div class="content">
		<div class="container-fluid">

			<!-- 동호회 목록 -->
			<section class="club-all-list">
				<div class="card-header" role="button" onclick="toggleList(this);">
					<h3>
						<i class="fas fa-chevron-down"></i> 동호회 목록 <span
							class="header-count">(1)</span>
					</h3>
				</div>
				<!-- /.card-header -->

				<div class="row card-content">
				
				<c:forEach items="${clubList}" var="club">
					<div class="col-12 col-sm-6 col-md-3">
						<div class="card club card-hover">
							<div class="card-body" onclick="location.href = '${pageContext.request.contextPath}/club/clubView.do?clubNo=${club.clubNo }'">
								<div class="card-title">
									${club.clubName }
								</div>


								<!-- 삭제 버튼 -->
								<div class="card-tools text-right">

									<button type="button" class="btn btn-tool"
										data-card-widget="remove">
										<i class="fas fa-times"></i>
									</button>
								</div>

								<div class="card-club-image">
									<img
										src="${pageContext.request.contextPath}/resources/img/fs.JPG"
										alt="">
								</div>
								<!-- 수정 버튼 -->
								<button type="button" id="up-btn">
									<i class="fas fa-edit"></i>
								</button>
								<div class="card-enroll-date">
									<span class="enroll-date">${club.clubEnrollDate }</span>
								</div>
							</div>
						</div>
						<!-- /.card -->
					</div>
				</c:forEach>

					<div class="col-12 col-sm-6 col-md-3">
						<div class="card new" id="new-club-card">
							<div class="card-body">
								<i class="fas fa-plus"></i>
								<h6>새 동호회</h6>
							</div>
						</div>
						<!-- /.card -->
					</div>

				</div>
			</section>

			<!-- 내가 가입한 동호회 목록 -->
			<section class="my-club">
				<div class="card-header" role="button" onclick="toggleList(this);">
					<h3>
						<i class="fas fa-chevron-down"></i> 내가 가입한 동호회 <span
							class="header-count">(1)</span>
					</h3>
				</div>
				<!-- /.card-header -->
				<div class="row card-content">
					<div class="col-12 col-sm-6 col-md-3">
						<div class="card club card-hover">
							<a href="${pageContext.request.contextPath}/club/clubView.do">
								<div class="card-body">
									<div class="card-title">
										<h5>야구</h5>
									</div>
									<!-- 삭제 버튼 -->
									<div class="card-tools text-right">
										<button type="button" class="btn btn-tool"
											data-card-widget="remove">
											<i class="fas fa-times"></i>
										</button>
									</div>
									<div class="card-club-image">
										<img
											src="${pageContext.request.contextPath}/resources/img/fs.JPG"
											alt="">
									</div>
									<div class="card-enroll-date">
										<span class="enroll-date">2019/03/20</span>
									</div>
								</div>
							</a>
						</div>
						<!-- /.card -->
					</div>
				</div>
			</section>

			<!-- 승인 대기중인 동아리 목록 -->
			<section class="stand-by-club">
				<div class="card-header" role="button" onclick="toggleList(this);">
					<h3>
						<i class="fas fa-chevron-down"></i> 승인 대기중인 동호회 <span
							class="header-count">(1)</span>
					</h3>
				</div>
				<!-- /.card-header -->

				<div class="row card-content">
					<div class="col-12 col-sm-6 col-md-3">
						<div class="card club card-hover">
							<div class="card-body">
								<!-- 타이틀 -->
								<div class="card-title">
									<h5>애니메이션</h5>
								</div>
								<!-- 삭제 버튼 -->
								<div class="card-tools text-right">
									<button type="button" class="btn btn-tool"
										data-card-widget="remove">
										<i class="fas fa-times"></i>
									</button>
								</div>
								<div class="card-club-image">
									<img
										src="${pageContext.request.contextPath}/resources/img/dd.JPG"
										alt="">
								</div>
								<!-- 프로젝트 상태 / 마감일 -->

								<div class="card-stand">
									<span>승인대기</span>
								</div>

								<div class="card-enroll-date">
									<span class="enroll-date">2019/03/20</span>
								</div>
							</div>
						</div>
						<!-- /.card -->
					</div>
				</div>
			</section>

		</div>
		<!-- /.container-fluid -->
	</div>
	<!-- /.content -->
</div>
<!-- /.content-wrapper -->

<!-- modal Club 부분 -->
<div class="modal fade" id="modal-club">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">여행여행</h4>

				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<!-- image -->
				<div id="modal-image-slider" class="carousel slide"
					data-ride="carousel">
					<ol class="carousel-indicators">
						<li data-target="#modal-image-slider" data-slide-to="0"
							class="active"></li>
						<li data-target="#modal-image-slider" data-slide-to="1"></li>
						<li data-target="#modal-image-slider" data-slide-to="2"></li>
					</ol>
					<div class="carousel-inner">
						<div class="carousel-item active">
							<img class="d-block w-100"
								src="${pageContext.request.contextPath}/resources/img/dd.JPG"
								alt="First slide">
						</div>
						<div class="carousel-item">
							<img class="d-block w-100"
								src="${pageContext.request.contextPath}/resources/img/dd.JPG"
								alt="Second slide">
						</div>
						<div class="carousel-item">
							<img class="d-block w-100"
								src="${pageContext.request.contextPath}/resources/img/dd.JPG"
								alt="Third slide">
						</div>
					</div>
					<a class="carousel-control-prev" href="#modal-image-slider"
						role="button" data-slide="prev"> <span
						class="carousel-control-prev-icon" aria-hidden="true"></span> <span
						class="sr-only">Previous</span>
					</a> <a class="carousel-control-next" href="#modal-image-slider"
						role="button" data-slide="next"> <span
						class="carousel-control-next-icon" aria-hidden="true"></span> <span
						class="sr-only">Next</span>
					</a>
				</div>

				<span class="modal-text">국내여행.해외여행.정기모임.트레킹(산행).섬여행. 명승지관광.
					정모를 통하여 친목을 다지며 국내여행과 더존나라 해외여행으로 견문을 넓히며 보다 건강하고 즐겁게 삶의 여유를 가지고
					살아가는 회원들이 주최인 여행동호회 입니다.</span>
				<hr>
				<div class="modal-club-info">
					<span>회원 - </span>&nbsp; <span>10명</span> <br> <span>담당대표
						- </span>&nbsp; <span>박보검</span> <br> <span>모임날짜 - </span>&nbsp; <span>월,
						금</span> <br> <span>등록일 - </span>&nbsp; <span>2019/03/20</span>
				</div>

			</div>
			<div class="modal-footer justify-content-between">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" id="join">가입하기</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->

<!-- new Club modal -->
<!-- modal 부분 -->
<div class="modal fade" id="modal-new-club" data-backdrop="static">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">동호회 개설</h4>

				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				
			</div>
			<div class="modal-body">
				<div>
					<!-- form start -->
					<form role="form" id="new-club-form" 
						  action="${pageContext.request.contextPath}/club/insertNewClub.do" 
						  method="post"
						  enctype="multipart/form-data">
						<div class="form-group">
							<label>이름</label> <input type="text" name="clubName" class="form-control" required>
						</div>
						<!--  /.form-group -->
						<div class="form-group">
							<label>소개</label>
							<textarea class="form-control" name="clubIntroduce" rows="7" placeholder="소개글을 작성해주세요" required></textarea>
						</div>
						<!--  /.form-group -->

						<div class="form-group">
							<label>모임주기</label> <select class="form-control" name="meetingCycle">
								<option>매주</option>
								<option>격주</option>
							</select>
						</div>
						<label for="check-week">모임 요일</label>
						<div id="check-week" class="input-group">
							<div class="form-check">
								<input type="checkbox" class="form-check-input" name="meetingDate" id="meetingDate0" value="월" checked>
								<label class="form-check-label" for="meetingDate0">월</label>
							</div>
							<div class="form-check">
								<input type="checkbox" class="form-check-input" name="meetingDate" id="meetingDate1" value="화">
								<label class="form-check-label" for="meetingDate1">화</label>
							</div>
							<div class="form-check">
								<input type="checkbox" class="form-check-input" name="meetingDate" id="meetingDate2" value="수">
								<label class="form-check-label" for="meetingDate2">수</label>
							</div>
							<div class="form-check">
								<input type="checkbox" class="form-check-input" name="meetingDate" id="meetingDate3" value="목">
								<label class="form-check-label" for="meetingDate3">목</label>
							</div>
							<div class="form-check">
								<input type="checkbox" class="form-check-input" name="meetingDate" id="meetingDate4" value="금">
								<label class="form-check-label" for="meetingDate4">금</label>
							</div>
							<div class="form-check">
								<input type="checkbox" class="form-check-input" name="meetingDate" id="meetingDate5" value="토">
								<label class="form-check-label" for="meetingDate5">토</label>
							</div>
							<div class="form-check">
								<input type="checkbox" class="form-check-input" name="meetingDate" id="meetingDate6" value="일">
								<label class="form-check-label" for="meetingDate6">일</label>
							</div>
						</div>
						<!-- /.input-group -->

						<label for="radio-category">카테고리</label>
						<div id="radio-category" class="input-group">
							<div class="form-check">
								<input class="form-check-input" type="radio" name="clubCategory" id="clubCategory0" value="사회"
									checked> <label class="form-check-label" for="clubCategory0">사회</label>
							</div>
							<div class="form-check">
								<input class="form-check-input" type="radio" name="clubCategory" id="clubCategory1" value="취미">
								<label class="form-check-label" for="clubCategory1">취미</label>
							</div>
							<div class="form-check">
								<input class="form-check-input" type="radio" name="clubCategory" id="clubCategory2" value="음식">
								<label class="form-check-label" for="clubCategory2">음식</label>
							</div>
							<div class="form-check">
								<input class="form-check-input" type="radio" name="clubCategory" id="clubCategory3" value="운동">
								<label class="form-check-label" for="clubCategory3">운동</label>
							</div>
							<div class="form-check">
								<input class="form-check-input" type="radio" name="clubCategory" id="clubCategory4" value="문학">
								<label class="form-check-label" for="clubCategory4">문학</label>
							</div>
							<div class="form-check">
								<input class="form-check-input" type="radio" name="clubCategory" id="clubCategory5" value="기타">
								<label class="form-check-label" for="clubCategory5">기타</label>
							</div>

						</div>

						<div id="btn-sub">
							<button type="submit" id="join-btn" class="btn btn-primary">생성하기</button>
						</div>
					</form>
					<!-- form end -->
				</div>
			</div>
			<!-- /.modal-body -->
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>