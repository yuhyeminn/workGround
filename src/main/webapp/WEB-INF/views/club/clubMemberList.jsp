<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<link rel="stylesheet" property="stylesheet" href="${pageContext.request.contextPath}/resources/css/hyemin.css">
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<style>
.btn-drop {
	background-color: transparent;
	border: 0px transparent solid;
}

.navbar-project .dropdown-menu {
	min-width: 6rem;
}

#tbl-projectAttach.table.member-table td {
	padding: .5rem 0;
}

#tbl-projectAttach.member-table img {
	display: inline-block;
	width: 40px;
	height: 40px;
	margin-right: .3rem;
	object-fit: cover;
}

.btn-admin {
	width: 45px !important;
	margin: 0 auto;
	font-size: .7rem;
}

.btn-manager {
	width: 45px !important;
	margin: 0 auto;
	font-size: .7rem;
}

#tbl-projectAttach.member-table .dropdown-item {
	font-size: .8rem;
}

#tbl-projectAttach.member-table .dropdown-item i {
	margin-right: .3rem;
}

.allow-btn {
	width: 60px;
	min-width: 3rem;
	margin-right: .3rem;
}

#manage-change {
	color: black;
}

#delMem {
	color: #dc3545;
}

#clubMemberSearchFrm {
	left: 10px;
}

.control-sidebar {
      display: block;
      top: 92px !important;
      overflow: hidden;
      background-color: #fff;
      box-shadow: -1px 6px 10px 0 rgba(0, 0, 0, .2);
      color: #696f7a;
    }

.control-sidebar,
.control-sidebar::before {
  bottom: calc(3.5rem + 1px);
  display: none;
  right: -475px;
  width: 475px;
  transition: right .3s ease-in-out, display .3s ease-in-out;
}
#viewRightNavbar-wrapper{margin-right: 1.2rem;}
</style>

<script>
$(function(){
	//데이터 테이블 설정
	$('#tbl-projectAttach').DataTable({
        "paging": true,
        "lengthChange": false,
        "searching": false,
        "ordering": true,
        "info": false,
        "autoWidth": false,
    });
	
	//채팅방
	$('#btn-openChatting').on('click', ()=>{
			var $side = $("#setting-sidebar");
			var clubNo = ${club.clubNo};
			
	    	$.ajax({
				url: "${pageContext.request.contextPath}/chat/clubChatting.do",
				type: "get",
				data: {clubNo:clubNo},
				dataType: "html",
				success: data => {
					$side.html("");
					$side.html(data); 
				},
				error: (x,s,e) => {
					console.log(x,s,e);
				}
			});
	        
	        $side.addClass('open');
	        if($side.hasClass('open')) {
	        	$side.stop(true).animate({right:'0px'});
	        }
	  });
	
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

    $("#tab-member").addClass("active");
}

//멤버 프로필 페이지로 이동
function goMemberProfile(memberId){
    location.href = '${pageContext.request.contextPath}/member/memberView.do?memberId='+memberId;
}

//멤버 삭제
function deleteClubMem(clubMemberNo){
	
	var clubNo ='${clubNo}';
	if(!confirm("회원을 탈퇴시키겠니까?")) return false;
	else {
		location.href = "${pageContext.request.contextPath}/club/deleteClubMember.do?clubMemberNo="+clubMemberNo+"&&clubNo="+clubNo;
	}
}

//관리자변경
function addManager(memberId){
	
	var clubNo ='${clubNo}';
	location.href = "${pageContext.request.contextPath}/club/updateClubManager.do?clubNo="+clubNo+"&&memberId="+memberId;
	
}

//관리자 취소
function cancelManager(memberId){
	var clubNo ='${clubNo}';
	location.href = "${pageContext.request.contextPath}/club/cancelClubManager.do?clubNo="+clubNo+"&&memberId="+memberId;
}

//가입승인
function approveJoin(memberId){
	var clubNo ='${clubNo}';
	location.href = "${pageContext.request.contextPath}/club/approveClubMember.do?clubNo="+clubNo+"&&memberId="+memberId;
}

function clubView(clubNo) {
	location.href = "${pageContext.request.contextPath}/club/clubView.do?clubNo="+clubNo;
}


</script>

<nav id="navbar-club"
	class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
	<!-- Left navbar links -->
	<!-- SEARCH FORM -->
	<form id="noticeSearchFrm" class="form-inline"
		style="margin-left: 20px"
		action="${pageContext.request.contextPath }/club/searchClubContent.do"
		method="POST">
		<div class="input-group input-group-sm" style="margin-top: 20px;">
			<input class="form-control form-control-navbar" type="search"
				placeholder="${club.clubName } 검색" aria-label="Search"
				name="keyword"> <input type="hidden" name="clubNo"
				value="${club.clubNo }" />
			<div class="input-group-append">
				<button class="btn btn-navbar" type="submit">
					<i class="fas fa-search"></i>
				</button>
			</div>
		</div>
	</form>


	<!-- Middle navbar links -->
	<ul id="navbar-tab" class="navbar-nav ml-auto">
		<li id="tab-club" class="nav-item"><button type="button"
				onclick="clubView('${clubNo}');">동호회</button></li>
		<li id="tab-calendar" class="nav-item"><button type="button"
				onclick="location.href='${pageContext.request.contextPath}/club/clubCalendar.do?clubNo='+${clubNo}">일정</button></li>
		<li id="tab-member" class="nav-item">
			<button type="button" onclick="memberList('${clubNo}');">동호회멤버</button>
		</li>
		<li id="tab-attachment" class="nav-item"><button type="button"
				onclick="location.href='${pageContext.request.contextPath}/club/clubFileList.do?clubNo='+${clubNo}");">파일</button></li>
	</ul>

	<!-- Right navbar links -->
	<ul id="viewRightNavbar-wrapper" class="navbar-nav ml-auto">
		<!-- 동호회 대화 -->
		<li class="nav-item">
			<button type="button"
				class="btn btn-block btn-default btn-xs nav-link" id="btn-openChatting">
				<i class="far fa-comments"></i> 동호회 대화
			</button>
		</li>

		<!-- 동호회 멤버 -->
		<li id="nav-member" class="nav-item dropdown"><a class="nav-link"
			data-toggle="dropdown" href="#"> <i class="far fa-user"></i> ${fn:length(memberList)}
		</a>
			<div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
				<c:if test="${not empty memberList }">
					<c:forEach items="${memberList }" var="clubMember">
						<a
							href="${pageContext.request.contextPath }/member/memberView.do?memberId=${clubMember.empId }"
							class="dropdown-item"> <!-- Message Start -->
							<div class="media">
								<img
									src="${pageContext.request.contextPath}/resources/img/profile/${clubMember.clubMemberList[0].renamedFileName }"
									alt="User Avatar" class="img-circle img-profile ico-profile" />
								<div class="media-body">
									<p class="memberName">${clubMember.clubMemberList[0].memberName }</p>
								</div>
							</div> <!-- Message End -->
						</a>
					</c:forEach>
				</c:if>
			</div></li>

		<!-- 동호회 설정 -->
		<li class="nav-item">
			<button type="button"
				class="btn btn-block btn-default btn-xs nav-link">
				<i class="fas fa-cog"></i>
			</button>
		</li>
	</ul>
</nav>
<!-- /.navbar -->

<!-- 오른쪽 채팅 사이드 바-->
<aside class="work-setting" id="setting-sidebar" style="display: block;">
</aside>

<!-- Content Wrapper. Contains page content -->
<div id="member-list" class="content-wrapper">


	<div class="content">
		<div class="container-fluid">
			<!-- Main content -->
			<section class="content">

				<div>
					<form id="clubMemberSearchFrm" class="form-inline"
						action="${pageContext.request.contextPath}/club/searchClubMember.do"
						method="post" enctype="multipart/form-data">
						<div class="input-group input-group-sm">
							<input class="form-control form-control-navbar" type="search"
								placeholder="멤버 검색하기" aria-label="Search" name="keyword">
							<input type="hidden" value="${clubNo }" name="clubNo" />
							<div class="input-group-append">
								<button class="btn btn-navbar" type="submit">
									<i class="fas fa-search"></i>
								</button>
							</div>
						</div>
					</form>
				</div>

				<div id="member-inner" class="table-responsive p-0">


					<!-- 멤버리스트 -->
					<table id="tbl-projectAttach"
						class="table table-hover text-nowrap member-table">
						<thead>
							<tr>
								<th style="width: 8%"></th>
								<th style="width: 22%">이름</th>
								<th style="width: 17%">직급</th>
								<th style="width: 17%">부서</th>
								<th style="width: 17%">이메일</th>
								<th style="width: 13%"></th>
							</tr>
						</thead>
						<tbody id="member-body">
							<c:forEach items="${memberList}" var="m">
								<tr>
									<td><c:if test="${fn:contains(m.clubManagerYN,'Y')}">

											<c:choose>

												<c:when
													test="${club.clubManagerId eq m.clubMemberList[0].memberId}">
													<button type="button"
														class="btn btn-block btn-outline-warning btn-xs btn-admin">회장</button>
												</c:when>

												<c:otherwise>
													<button type="button"
														class="btn btn-block btn-outline-danger btn-xs btn-manager">관리자</button>
												</c:otherwise>
											</c:choose>

										</c:if></td>
									<td onclick="goMemberProfile('${m.empId}');"><img
										src="${pageContext.request.contextPath }/resources/img/profile/${m.clubMemberList[0].renamedFileName}"
										alt="User Avatar" class="img-circle img-profile ico-profile">
										${m.clubMemberList[0].memberName}</td>
									<td>${m.jobTitle}</td>
									<td>${m.deptTitle}</td>

									<td>${m.clubMemberList[0].email}</td>

									<td><c:if test="${fn:contains(m.clubApproveYN,'N')}">
											<button type="button"
												class="btn btn-primary btn-sm allow-btn"
												onclick="approveJoin('${m.empId}')">Allow</button>
										</c:if>

									<c:if test="${club.clubManagerId ne m.clubMemberList[0].memberId}">
										<div class="dropdown">
											<button type="button" class="btn-moreMenu btn-drop btn-file"
												data-toggle="dropdown" aria-haspopup="true"
												aria-expanded="false">
												<i class="fas fa-ellipsis-v"></i>
											</button>
										
											<div class="dropdown-menu dropdown-menu-right">
												
												
														<a href="#" class="dropdown-item"
														onclick="deleteClubMem('${m.clubMemberNo}')"><i
														class="far fa-trash-alt"></i> 탈퇴</a>
												
											

												<c:if
													test="${fn:contains(m.clubManagerYN,'N') and fn:contains(m.clubApproveYN,'Y')}">
													<a href="#" class="dropdown-item"
														onclick="addManager('${m.empId}')"><i
														class="fas fa-star"></i>관리자변경</a>
												</c:if>

												<c:if
													test="${club.clubManagerId eq memberLoggedIn.memberId }">

													<c:if test="${fn:contains(m.clubManagerYN,'Y')}">
														<c:choose>
															<c:when
																test="${club.clubManagerId eq m.clubMemberList[0].memberId }">

															</c:when>
															<c:otherwise>
																<a href="#" class="dropdown-item"
																	onclick="cancelManager('${m.empId}')"><i
																	class="far fa-trash-alt"></i>관리자취소</a>
															</c:otherwise>
														</c:choose>

													</c:if>
												</c:if>
											</div>
										</div>
										</c:if>
										</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</section>
			<!-- /.content -->
		</div>
	</div>
</div>



<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>