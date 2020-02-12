<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<style>
.btn-drop{background-color:transparent; border:0px transparent solid;}
.navbar-project .dropdown-menu{min-width: 6rem;}
#tbl-projectAttach.table.member-table td{padding: .5rem 0;}
#tbl-projectAttach.member-table img{display: inline-block; width: 40px; height: auto; margin-right: .3rem;}
.btn-admin{width: 45px !important; margin: 0 auto; font-size: .7rem;}
#tbl-projectAttach.member-table .dropdown-item{color: #dc3545; font-size: .8rem;}
#tbl-projectAttach.member-table .dropdown-item i{margin-right: .3rem;}
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

function fileDownload(oName, rName, clubNo) {
	oName = encodeURIComponent(oName);
	
	location.href = "${pageContext.request.contextPath}/club/clubFileDownload.do?clubNo="+clubNo+"&oName="+oName+"&rName="+rName;
}
</script>	

<!-- Navbar ClubView -->
<nav id="navbar-club"
	class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
	<!-- Left navbar links -->
	<!-- SEARCH FORM -->
	<form id="noticeSearchFrm" class="form-inline">
		<div class="input-group input-group-sm">
			<input class="form-control form-control-navbar" type="search"
				placeholder="oo동호회 검색" aria-label="Search">
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
		<c:if test="${memberLoggedIn.memberId == 'admin' or club.clubManagerId == memberLoggedIn.memberId}">
			<li id="tab-member" class="nav-item">
			<button type="button" onclick="memberList('${club.clubNo}');">동호회멤버</button></li>
		</c:if>
		<li id="tab-attachment" class="nav-item"><button type="button" onclick="clubFileList('${club.clubNo}');">파일</button></li>
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
				<a href="#" class="dropdown-item"> <!-- Message Start -->
					<div class="media">
						<img src="${pageContext.request.contextPath}/resources/img/profile.jfif"
							 alt="User Avatar" class="img-circle img-profile ico-profile" />
						<div class="media-body">
							<p class="memberName">Brad Diesel</p>
						</div>
					</div> <!-- Message End -->
				</a> 
				<a href="#" class="dropdown-item"> <!-- Message Start -->
					<div class="media">
						<img src="${pageContext.request.contextPath}/resources/img/profile.jfif"
							 alt="User Avatar" class="img-circle img-profile ico-profile">
						<div class="media-body">
							<p class="memberName">Brad Diesel</p>
						</div>
					</div> <!-- Message End -->
				</a> 
				<a href="#" class="dropdown-item"> <!-- Message Start -->
					<div class="media">
						<img src="${pageContext.request.contextPath}/resources/img/profile.jfif"
							 alt="User Avatar" class="img-circle img-profile ico-profile">
						<div class="media-body">
							<p class="memberName">Brad Diesel</p>
						</div>
					</div> <!-- Message End -->
				</a> 
				<a href="#" class="dropdown-item"> <!-- Message Start -->
					<div class="media">
						<img src="${pageContext.request.contextPath}/resources/img/profile.jfif"
							 alt="User Avatar" class="img-circle img-profile ico-profile">
						<div class="media-body">
							<div class="media-body">
								<p class="memberName">Brad Diesel</p>
							</div>
						</div>
					</div> <!-- Message End -->
				</a> 
				<a href="#" class="dropdown-item"> <!-- Message Start -->
					<div class="media">
						<img src="${pageContext.request.contextPath}/resources/img/profile.jfif"
							 alt="User Avatar" class="img-circle img-profile ico-profile">
						<div class="media-body">
							<p class="memberName">Brad Diesel</p>
						</div>
					</div> <!-- Message End -->
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
<div id="member-list" class="content-wrapper">
    <!-- Main content -->
    <section class="content">
        <h2>파일</h2>
        
        <div id="member-inner" class="table-responsive p-0">
            <!-- SEARCH FORM -->
            <div class="navbar-light">
                <form id="memberSearchFrm" class="form-inline">
                    <div class="input-group input-group-sm">
                    <input class="form-control form-control-navbar" type="search" placeholder="파일 검색하기" aria-label="Search">
                    <div class="input-group-append">
                        <button class="btn btn-navbar" type="submit">
                        <i class="fas fa-search"></i>
                        </button>
                    </div>
                    </div>
                </form>
            </div>

            <!-- 멤버리스트 -->
            <table id="tbl-projectAttach" class="table table-hover text-nowrap member-table">
                <thead>
                    <tr>
                        <th style="width: 10%"></th>
                        <th style="width: 40%">사진제목</th>
                        <th style="width: 25%">파일이름</th>
                        <th style="width: 25%">공유한 날짜</th>
                    </tr>
                </thead>
                <tbody>
                	<c:forEach items="${clubPhotoList}" var="clubPhoto">
                    <tr>
                        <td>
                            <%-- <img src="${pageContext.request.contextPath }/resources/upload/club/${clubPhoto.clubNo }/${clubPhoto.clubPhotoRenamed}" alt="User Avatar" class="img-circle img-profile ico-profile"> --%>
                        </td>
                        <td onclick="fileDownload('${clubPhoto.clubPhotoOriginal}', '${clubPhoto.clubPhotoRenamed }', '${clubPhoto.clubNo }');">
                        	${clubPhoto.clubPhotoTitle}
                        </td>
                        <td>${clubPhoto.clubPhotoOriginal}</td>
                        <td>${clubPhoto.clubPhotoDate}</td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>    
        </div>
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->		

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>