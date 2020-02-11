<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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
	height: auto;
	margin-right: .3rem;
}

.btn-admin {
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
}
#manage-change{
	color: black;
}

#delMem{
	color: #dc3545;
}
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

//가입승인
function approveJoin(memberId){
	var clubNo ='${clubNo}';
	location.href = "${pageContext.request.contextPath}/club/approveClubMember.do?clubNo="+clubNo+"&&memberId="+memberId;
}
</script>


<!-- Content Wrapper. Contains page content -->
<div id="member-list" class="content-wrapper">
	<!-- Main content -->
	<section class="content">
		<h2>동호회 멤버</h2>

		<div id="member-inner" class="table-responsive p-0">
			<!-- SEARCH FORM -->
			<div class="navbar-light">
				<form id="clubMemberSearchFrm" class="form-inline"
				action="${pageContext.request.contextPath}/club/searchClubMember.do"
				method="post" enctype="multipart/form-data">
					<div class="input-group input-group-sm">
						<input class="form-control form-control-navbar" type="search"
							placeholder="멤버 검색하기" aria-label="Search" name="keyword">
						<div class="input-group-append">
							<button class="btn btn-navbar" type="submit">
								<i class="fas fa-search"></i>
							</button>
						</div>
					</div>
				</form>
			</div>
			<br />

			<!-- 멤버리스트 -->
			<table id="tbl-projectAttach"
				class="table table-hover text-nowrap member-table">
				<thead>
					<tr>
						<th style="width: 8%"></th>
						<th style="width: 22%">이름</th>
						<th style="width: 17%">직급</th>
						<th style="width: 17%">부서</th>
						<th style="width: 26%">이메일</th>
						<th style="width: 16%"></th>
					</tr>
				</thead>
				<tbody id="member-body">
					<c:forEach items="${memberList}" var="m">
						<tr>
							<td>
								
								<c:if test="${fn:contains(m.clubManagerYN,'Y')}">
									<button type="button"
										class="btn btn-block btn-outline-warning btn-xs btn-admin">관리자</button>
								</c:if>
							</td>
							<td onclick="goMemberProfile('${m.empId}');"><img
								src="${pageContext.request.contextPath }/resources/img/profile/${m.clubMemberList[0].renamedFileName}"
								alt="User Avatar" class="img-circle img-profile ico-profile">
								${m.clubMemberList[0].memberName}</td>
							<td>${m.jobTitle}</td>
							<td>${m.deptTitle}</td>

							<td>${m.clubMemberList[0].email}

							</td>

							<td><c:if
									test="${fn:contains(m.clubApproveYN,'N')}">
									<button type="button" class="btn btn-primary btn-sm allow-btn" onclick="approveJoin('${m.empId}')">Allow</button>
								</c:if>

								<div class="dropdown">
									<button type="button" class="btn-moreMenu btn-drop btn-file"
										data-toggle="dropdown" aria-haspopup="true"
										aria-expanded="false">
										<i class="fas fa-ellipsis-v"></i>
									</button>
									<div class="dropdown-menu dropdown-menu-right">
										<a href="#" class="dropdown-item" onclick="deleteClubMem('${m.clubMemberNo}')"><i
											class="far fa-trash-alt"></i> 탈퇴</a>
											
										<c:if test="${fn:contains(m.clubManagerYN,'N') and fn:contains(m.clubApproveYN,'Y')}">
											<a href="#" class="dropdown-item" onclick="addManager('${m.empId}')"><i class="fas fa-star"></i>관리자변경</a>
										</c:if>
									</div>
								</div></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</section>
	<!-- /.content -->
</div>



<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>