<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<link rel="stylesheet" property="stylesheet" href="${pageContext.request.contextPath}/resources/css/hyemin.css">
<style>
.note-editing-area {
	min-height: 100px;
}
.note-editor.note-frame {
	max-height: 148px;
}

#navbar-club #noticeSearchFrm {
	margin-left: 1rem;
}

#info-wrapper .card-body {
	padding: 3rem 1.25rem;
}

#info-wrapper .card-header {
	margin-top: 0;
}

#info-wrapper .card-title {
	color: ##464c59;
	font-size: 1rem;
	font-weight: bold;
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

  $("#tab-attachment").addClass("active");
}

//멤버 프로필 페이지로 이동
function goMemberProfile(memberId){
    location.href = '${pageContext.request.contextPath}/member/memberView.do?memberId='+memberId;
}

function fileDownload(oName, rName, clubNo) {
	oName = encodeURIComponent(oName);
	
	location.href = "${pageContext.request.contextPath}/club/clubFileDownload.do?clubNo="+clubNo+"&oName="+oName+"&rName="+rName;
}

function clubView(clubNo) {
	location.href = "${pageContext.request.contextPath}/club/clubView.do?clubNo="+clubNo;
}

function memberList(clubNo){
	location.href = "${pageContext.request.contextPath}/club/clubMemberList.do?clubNo="+clubNo;
}

function clubFileList(clubNo) {
	location.href = "${pageContext.request.contextPath}/club/clubFileList.do?clubNo="+clubNo;
}
</script>	

<!-- Navbar ClubView -->
<nav id="navbar-club"
	class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
	<!-- Left navbar links -->
	<!-- SEARCH FORM -->
	<form id="noticeSearchFrm" class="form-inline" action="${pageContext.request.contextPath }/club/searchClubContent.do" method="POST">
		<div class="input-group input-group-sm">
			<input class="form-control form-control-navbar" type="search" placeholder="${club.clubName } 검색" aria-label="Search" name="keyword">
			<input type="hidden" name="clubNo" value="${club.clubNo }" />
			<div class="input-group-append">
				<button class="btn btn-navbar" type="submit">
					<i class="fas fa-search"></i>
				</button>
			</div>
		</div>
	</form>

	<!-- Middle navbar links -->
	<ul id="navbar-tab" class="navbar-nav ml-auto">
		<li id="tab-club" class="nav-item"><button type="button" onclick="clubView('${club.clubNo}');">동호회</button></li>
		<li id="tab-calendar" class="nav-item"><button type="button" onclick="location.href='${pageContext.request.contextPath}/club/clubCalendar.do?clubNo='+'${club.clubNo}'">일정</button></li>
		<c:if test="${memberLoggedIn.memberId == 'admin' or isManager}">
			<li id="tab-member" class="nav-item">
			<button type="button" onclick="memberList('${club.clubNo}');">동호회멤버</button></li>
		</c:if>
		<li id="tab-attachment" class="nav-item"><button type="button" onclick="clubFileList('${club.clubNo}');">파일</button></li>
	</ul>

	<!-- Right navbar links -->
	<ul id="viewRightNavbar-wrapper" class="navbar-nav ml-auto">
		<!-- 동호회 대화 -->
		<li class="nav-item">
			<button type="button" id="btn-openChatting" class="btn btn-block btn-default btn-xs nav-link">
				<i class="far fa-comments"></i> 동호회 대화
			</button>
		</li>

		<!-- 동호회 멤버 -->
		<li id="nav-member" class="nav-item dropdown">
		<a class="nav-link" data-toggle="dropdown" href="#"> 
			<i class="far fa-user"></i> 6
		</a>
			<div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
			  <c:if test="${not empty clubMemberList }">
			  <c:forEach items="${clubMemberList }" var="clubMember">
				<a href="${pageContext.request.contextPath }/member/memberView.do?memberId=${clubMember.empId }" class="dropdown-item"> <!-- Message Start -->
				  <div class="media">
				  	<img src="${pageContext.request.contextPath}/resources/img/profile/${clubMember.clubMemberList[0].renamedFileName }"
				  		 alt="User Avatar" class="img-circle img-profile ico-profile" />
				  	<div class="media-body">
				  		<p class="memberName">${clubMember.clubMemberList[0].memberName }</p>
				  	</div>
				  </div> <!-- Message End -->
				</a> 
			  </c:forEach>
			  </c:if>
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

<!-- 오른쪽 채팅 사이드 바-->
<aside class="work-setting" id="setting-sidebar" style="display: block;">
</aside>

<!-- Content Wrapper. Contains page content -->
<div id="member-list" class="content-wrapper" style="padding-top: 50px;">
    <!-- Main content -->
    <section class="content">
        <h2>파일</h2>
        
        <div id="member-inner" class="table-responsive p-0">
            <!-- SEARCH FORM -->
            <div class="navbar-light">
                <form id="memberSearchFrm" class="form-inline" action="${pageContext.request.contextPath }/club/searchClubFile.do" method="POST">
                    <div class="input-group input-group-sm">
                    <input class="form-control form-control-navbar" type="search" placeholder="파일 검색하기" aria-label="Search" name="keyword">
                    <input type="hidden" name="clubNo" value="${club.clubNo }" />
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
                	<c:if test="${not empty clubPhotoList }">
                	<c:forEach items="${clubPhotoList}" var="clubPhoto">
                    <tr>
                        <td>
                          <button type="button" class="btn btn-block btn-outline-info btn-xs btn-admin">사진</button>
                        </td>
                        <td onclick="fileDownload('${clubPhoto.clubPhotoOriginal}', '${clubPhoto.clubPhotoRenamed }', '${clubPhoto.clubNo }');">
                        	${clubPhoto.clubPhotoTitle}
                        </td>
                        <td>${clubPhoto.clubPhotoOriginal}</td>
                        <td>${clubPhoto.clubPhotoDate}</td>
                    </tr>
                    </c:forEach>
                	</c:if>
                    <c:forEach items="${clubNoticeList }" var="clubNotice">
                    <c:if test="${clubNotice.clubNoticeOriginal ne null }">
                    <tr>
                        <td>
                          <button type="button" class="btn btn-block btn-outline-primary btn-xs btn-admin">공지</button>
                        </td>
                        <td onclick="fileDownload('${clubNotice.clubNoticeOriginal}', '${clubNotice.clubNoticeRenamed }', '${clubNotice.clubNo }');">
                        	${clubNotice.clubNoticeTitle}
                        </td>
                        <td>${clubNotice.clubNoticeOriginal}</td>
                        <td>${clubNotice.clubNoticeDate}</td>
                    </tr>
                    </c:if>
                    </c:forEach>
                </tbody>
            </table>    
        </div>
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->		

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>