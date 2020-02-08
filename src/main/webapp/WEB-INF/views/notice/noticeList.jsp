<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<style>
/* 공지, 게시판 카드 */
#noticeSearchFrm{margin: 15px 1rem 15px;} /*공지, 게시판 검색*/
div.content-wrapper>div.content{padding-bottom: 5rem;} /*페이지 아래 길이 늘려주기*/
div.header-line{padding: 1rem .5rem .8rem; margin: 1rem 0 .5rem; color: rgba(0,0,0,.5);}
div.header-line h6{font-weight: bold;}
i.fa-plus-square{float: right; font-size: 2rem; margin-right: .5rem; cursor: pointer; color: darkgray;} /*공지, 게시판 추가 버튼*/
i.fa-plus-square:hover{color: gray;}
.card{height: 20rem;}
.card-body{overflow: hidden;} /*카드내용 밖으로 넘어감 처리*/
img.card-img-top{height: 10rem; object-fit: cover; margin-bottom: 1.5rem; border-radius: 5px;}
.card-title{margin-bottom: .5rem; font-size: 1rem; font-weight: bold;}
.carousel-item-next, .carousel-item-prev, .carousel-item.active{display: flex;}
.carousel-indicators{bottom: -3rem;} 
.carousel-indicators li{background-color: gray;}
i.slide-arrow{color: rgb(199, 195, 195); font-size: 2rem; cursor: pointer; position: absolute; top: 45%;}
i.slide-arrow:hover{color:gray;}
i.slide-arrow-left{left: -2rem;}
i.slide-arrow-right{right: -1rem;}
.btn-moreMenu{position: absolute; border: 0; background: #00ff0000; color: darkgray; font-size: .8rem; right: .1rem; top: .3rem;} /*수정, 삭제*/
.btn-moreMenu:hover{color: gray;}
a.dropdown-item{color: gray;}
span#myDept{width: 1rem; height: 1rem; border: 2px solid lightgray; background: white; border-radius: 5px; padding: 0 .3rem;}
/* 공지, 게시판 상세보기 모달 */
div.modal-dialog{max-width: 50%;}
.modal-header .close{margin: -1.5rem -1rem -1.5rem auto;}
.modal-header .close>span{font-size: 2rem;}
.modal-title{color: #5a5454;}
.noticeView, .deptNoticeView, .boardView{margin-bottom: 1rem;}
.user-block{float: none;}
.view-img{width: 100%; display: block; margin: 0 auto;}
.deptNoticeView>.view-title, .boardView>.view-title{margin-bottom: .5rem;}
p.view-title{font-size: 1.2rem; font-weight: bold;}
p.view-content{margin: 1rem 1rem 2.5rem;}
.comment-count{margin-bottom: 0.5rem; color: rgb(93, 93, 93);}
.comment-text-area{display: inline-block; width: 90%; height: 2rem; margin-right: .3rem;}
.comment-reply{border: 0; background: darkgray; border-radius: 3px; margin-right: .3rem; color: white;}
.comment-delete{border: 0; background: darkgray; border-radius: 3px; color: white;}
.comment-submit{border: 0; background: darkgray; border-radius: 3px; width: 3rem; height: 2rem; color: white;}
.comment-submit:hover, .comment-reply:hover{background: #007bff;}
.comment-delete:hover{background: #dc3545;}
.comment-level2{margin-left: 3rem;}
.btn-outline-success{border: 0; background: darkgray; border-radius: 3px; color: white;}
.btn-outline-success:hover{background: #007bff;}
.note-editor.note-frame{border: 1px solid #ced4da; width: 100%; height: 100%;} /*텍스트 에디터*/
.note-editable{height: 10rem;}

</style>

<script>
$(function(){
  // Summernote
  $('.textarea').summernote();
  
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
	
	$("#sidebar-notice").addClass("active");
}

</script>

<!-- #############주현 할 일############
[할 일]
@ - 관리자: 모든 게시물 수정/삭제 가능?
- 게시글 작성자 기본 프로필
- 수정 모달창 forEach / 카드 안에 수정모달창 index주기
- 카드 내용 ...
- 댓글
- 댓글 작성자  프로필 없을 경우 기본 이미지
- 관리자 기획부가 맞는 건지?
- 이미지 없을 때 내용 가운데로?
- DB 내용 정리
- 상세보기 작성자 클릭 시 프로필 이동?
@ - **부서별공지, 자유게시판 작성자 이름으로
@ - 슬라이드 바 개수 맞추기!!
- 공지 수정 창 추가: #updateDeptNoticeModal${deptnvs.count}
 -->

<!-- Navbar NoticeList -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
  <!-- Left navbar links -->
  <!-- SEARCH FORM -->
  <form id="noticeSearchFrm" class="form-inline">
    <div class="input-group input-group-sm">
      <input class="form-control form-control-navbar" type="search" placeholder="공지 및 게시판 검색" aria-label="Search">
      <div class="input-group-append">
        <button class="btn btn-navbar" type="submit">
          <i class="fas fa-search"></i>
        </button>
      </div>
    </div>
  </form>

  <!-- Right navbar links -->
  <ul class="navbar-nav ml-auto navbar-nav-sort">
    <li class="nav-item dropdown">
      정렬
      <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#">
        업데이트순 <span class="caret"></span>
      </a>
      <div class="dropdown-menu">
        <a class="dropdown-item" tabindex="-1" href="#">업데이트순</a>
        <a class="dropdown-item" tabindex="-1" href="#">제목순</a>
      </div>
    </li>
  </ul>
</nav>
<!-- /.navbar -->		

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
  <h2 class="sr-only">공지 목록</h2>
  <!-- Main content -->
  <div class="content">
    <div class="container-fluid">
      <!-- 전체공지 -->
      <section class="notice-area">
        <div class="header-line">
          <h6><i class="fas fa-exclamation-circle"></i>&nbsp; 전체 공지 <span class="header-count">(${fn:length(noticeList)})</span>
              <i class="fas fa-plus-square" data-toggle="modal" data-target="#addNoticeModal" ${memberLoggedIn.jobTitle=='관리자'?'"style=display:block;"':"style=display:none;"}></i></h6>
        </div><!-- /.card-header -->
        <div id="notice_indicators" class="carousel slide" data-ride="carousel" data-interval="false">
          <ol class="carousel-indicators">
<!-- 		<li data-target="#notice_indicators" data-slide-to="0" class="active"></li>
			<li data-target="#notice_indicators" data-slide-to="1"></li>
            <li data-target="#notice_indicators" data-slide-to="2"></li> -->
          	<!-- 리스트 비어있지 않으면 첫 번째 바는 무조건 나옴 -->
          	<c:if test="${noticeList != null}">
	            <li data-target="#notice_indicators" data-slide-to="0" class="active"></li>
          	</c:if>
          	<!-- barCnt: 바개수 올림 (공지 개수/4 올림) -->
			<c:set var="noticeBarCnt" value="${fn:length(noticeList)/4}"/>
          	<c:forEach var="i" begin="1" end="${noticeBarCnt+(1-(noticeBarCnt%1))%1-1}" step="1">
	            <li data-target="#notice_indicators" data-slide-to="i"></li>
          	</c:forEach>
          </ol>
          <div class="carousel-inner">          
            <!-- row1 -->
            <c:forEach items="${noticeList }" var="n" varStatus="nvs">
            	<c:if test="${nvs.count == 1}">
              	<div class="row card-content carousel-item active">
          	</c:if>
          	<c:if test="${nvs.count % 4 == 1 && nvs.count != 1}">
              	<div class="row card-content carousel-item">
          	</c:if>
   	        <div class="col-12 col-sm-6 col-md-3">
   	          <div class="card">
   	            <!-- Default droprleft button -->
   	            <div class="dropleft">
   	              <button class="btn-moreMenu" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" ${memberLoggedIn.memberId == n.noticeWriter?"style = display:block;":"style = display:none;"}><i class="fas fa-ellipsis-v"></i></button>
   	              <div class="dropdown-menu">
   	                <a href="#" class="dropdown-item" data-toggle="modal" data-target="#updateNoticeModal${nvs.count}">공지 수정</a>
   	                <a href="#" class="dropdown-item">공지 삭제</a>
   	              </div>
   	            </div>
   	            <div class="card-body" data-toggle="modal" data-target="#noticeViewModal${nvs.count}">
   	              <img src="${pageContext.request.contextPath}/resources/img/${n.noticeRenamedFileName}" class="card-img-top" onerror="this.style.display='none'">
	   	              <h5 class="card-title">${n.noticeTitle }</h5>
	   	              <p class="card-text">${n.noticeContent }</p>
   	            </div>
   	          </div><!-- /.card -->
   	        </div>
            	<c:if test="${nvs.count % 4 == 0 || nvs.last}">
   				</div>
          	</c:if>
            </c:forEach>
          </div> <!-- /.carousel-inner notice-carousel  -->
          <!-- <a href="#notice_indicators" data-slide="prev"> -->
          <i class="fas fa-angle-left slide-arrow slide-arrow-left" data-target="#notice_indicators" data-slide="prev"></i>
          <!-- </a> -->
          <!-- <a href="#notice_indicators" data-slide="next"> -->
          <i class="fas fa-angle-right slide-arrow slide-arrow-right" data-target="#notice_indicators" data-slide="next"></i>
          <!-- </a> -->
        </div> <!--slide-->
      </section>

      <!-- 내가 속한 부서 공지 -->
      <!-- 로그인한 멤버의 부서대로 리스트 불러와 deptNoticeList라는 변수에 담겠다.-->
      <c:set var="deptNoticeList" value="${memberLoggedIn.deptCode=='D1'?planningDeptNoticeList:memberLoggedIn.deptCode=='D2'?designDeptNoticeList:developmentDeptNoticeList}"/>
      <section class="myDeptNotice-area">
        <div class="header-line" style="margin-top: 4rem;">
          <h6><span id="myDept"><i class="fas fa-user"></i> &nbsp;${memberLoggedIn.deptCode=='D1'?"기획":memberLoggedIn.deptCode=='D2'?"디자인":"개발" }</span>
              &nbsp; 내가 속한 부서의 공지 <span class="header-count">(${fn:length(deptNoticeList)})</span>
              <i class="fas fa-plus-square" data-toggle="modal" data-target="#addNoticeModal"></i></h6>
        </div><!-- /.card-header -->
        <div id="myDeptNotice_indicators" class="carousel slide" data-ride="carousel" data-interval="false">
          <ol class="carousel-indicators">
<!-- 	    <li data-target="#myDeptNotice_indicators" data-slide-to="0" class="active"></li>
           	<li data-target="#myDeptNotice_indicators" data-slide-to="1"></li>
            <li data-target="#myDeptNotice_indicators" data-slide-to="2"></li> -->
            
            <!-- 리스트 비어있지 않으면 첫 번째 바는 무조건 나옴 -->
          	<c:if test="${deptNoticeList != null}">
	            <li data-target="#myDeptNotice_indicators" data-slide-to="0" class="active"></li>
          	</c:if>
          	<!-- barCnt: 바개수 올림 (공지 개수/4 올림) -->
			<c:set var="deptNoticeBarCnt" value="${fn:length(deptNoticeList)/4}"/>
          	<c:forEach var="i" begin="1" end="${deptNoticeBarCnt+(1-(deptNoticeBarCnt%1))%1-1}" step="1">
	            <li data-target="#myDeptNotice_indicators" data-slide-to="i"></li>
          	</c:forEach>
          </ol>
          <div class="carousel-inner">
            <c:forEach items="${deptNoticeList}" var="deptn" varStatus="deptnvs">
	            <c:if test="${deptnvs.count == 1}">
	              	<div class="row card-content carousel-item active">
	          	</c:if>
	          	<c:if test="${deptnvs.count % 4 == 1 && deptnvs.count != 1}">
	              	<div class="row card-content carousel-item">
	          	</c:if>
	   	        <div class="col-12 col-sm-6 col-md-3">
	   	          <div class="card">
	   	            <!-- Default droprleft button -->
	   	            <div class="dropleft">
	   	              <button class="btn-moreMenu" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" ${memberLoggedIn.memberId==deptn.noticeWriter || memberLoggedIn.memberId=='admin'?"style=display:block;":"style=display:none;"}><i class="fas fa-ellipsis-v"></i></button>
	   	              <div class="dropdown-menu">
	   	                <a href="#" class="dropdown-item" data-toggle="modal" data-target="#updateDeptNoticeModal${deptnvs.count}">공지 수정</a>
	   	                <a href="#" class="dropdown-item">공지 삭제</a>
	   	              </div>
	   	            </div>
	   	            <div class="card-body" data-toggle="modal" data-target="#myDeptNoticeViewModal${deptnvs.count}">
	   	              <img src="${pageContext.request.contextPath}/resources/img/${deptn.noticeRenamedFileName}" class="card-img-top" onerror="this.style.display='none'">
	   	              <h5 class="card-title">${deptn.noticeTitle }</h5>
	   	              <p class="card-text">${deptn.noticeContent }</p>
	   	            </div>
	   	          </div><!-- /.card -->
	   	        </div>
	            <c:if test="${deptnvs.count % 4 == 0 || deptnvs.last}">
	   				</div>
	          	</c:if>
            </c:forEach>
          </div> <!--/.carousel inner-->
          <!-- <a href="#notice_indicators" data-slide="prev"> -->
          <i class="fas fa-angle-left slide-arrow slide-arrow-left" data-target="#myDeptNotice_indicators" data-slide="prev"></i>
          <!-- </a> -->
          <!-- <a href="#notice_indicators" data-slide="next"> -->
          <i class="fas fa-angle-right slide-arrow slide-arrow-right" data-target="#myDeptNotice_indicators" data-slide="next"></i>
          <!-- </a> -->
        </div> <!--slide-->
      </section>

      <!-- 자유게시판 -->
      <section class="board-area">
        <div class="header-line" style="margin-top: 4rem;">
          <h6><i class="fas fa-sticky-note"></i>&nbsp; 자유게시판 <span class="header-count">(${fn:length(communityList)})</span>
              <i class="fas fa-plus-square" data-toggle="modal" data-target="#addBoardModal"></i></h6>
        </div><!-- /.card-header -->
        <div id="board_indicators" class="carousel slide" data-ride="carousel" data-interval="false">
          <ol class="carousel-indicators">
<!--             <li data-target="#board_indicators" data-slide-to="0" class="active"></li>
            <li data-target="#board_indicators" data-slide-to="1"></li>
            <li data-target="#board_indicators" data-slide-to="2"></li> -->
          	<!-- 리스트 비어있지 않으면 첫 번째 바는 무조건 나옴 -->
          	<c:if test="${communityList != null}">
	            <li data-target="#board_indicators" data-slide-to="0" class="active"></li>
          	</c:if>
          	<!-- barCnt: 바개수 올림 (공지 개수/4 올림) -->
			<c:set var="boardBarCnt" value="${fn:length(communityList)/4}"/>
          	<c:forEach var="i" begin="1" end="${boardBarCnt+(1-(boardBarCnt%1))%1-1}" step="1">
	            <li data-target="#board_indicators" data-slide-to="i"></li>
          	</c:forEach>
          </ol>
          <div class="carousel-inner">
            <!-- row1 -->
            <c:forEach items="${communityList}" var="c" varStatus="cvs">
	            <c:if test="${cvs.count == 1}">
	              	<div class="row card-content carousel-item active">
	          	</c:if>
	          	<c:if test="${cvs.count % 4 == 1 && cvs.count != 1}">
	              	<div class="row card-content carousel-item">
	          	</c:if>
	   	        <div class="col-12 col-sm-6 col-md-3">
	   	          <div class="card">
	   	            <!-- Default droprleft button -->
	   	            <div class="dropleft">
	   	              <button class="btn-moreMenu" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" ${memberLoggedIn.memberId==c.commuWriter || memberLoggedIn.memberId=='admin'?"style=display:block;":"style=display:none;"}><i class="fas fa-ellipsis-v"></i></button>
	   	              <div class="dropdown-menu">
	   	                <a href="#" class="dropdown-item" data-toggle="modal" data-target="#updateBoardModal${cvs.count}">게시글 수정</a>
	   	                <a href="#" class="dropdown-item">게시글 삭제</a>
	   	              </div>
	   	            </div>
	   	            <div class="card-body" data-toggle="modal" data-target="#boardViewModal${cvs.count}">
	   	              <img src="${pageContext.request.contextPath}/resources/img/${c.commuRenamedFileName}" class="card-img-top" onerror="this.style.display='none'">
	   	              <h5 class="card-title">${c.commuTitle }</h5>
	   	              <p class="card-text">${c.commuContent }</p>
	   	            </div>
	   	          </div><!-- /.card -->
	   	        </div>
	            <c:if test="${cvs.count % 4 == 0 || cvs.last}">
	   				</div>
	          	</c:if>
            </c:forEach>
          </div> <!--/.carousel-inner-->
          <a href="#board_indicators" data-slide="prev">
            <i class="fas fa-angle-left slide-arrow slide-arrow-left"></i>
          </a>
          <a href="#board_indicators" data-slide="next">
            <i class="fas fa-angle-right slide-arrow slide-arrow-right"></i>
          </a>
        </div> <!--slide-->
      </section>

    </div><!-- /.container-fluid -->
  </div><!-- /.content -->
</div>
<!-- /.content-wrapper -->

<!-- 전체 공지 상세보기 모달 -->
<c:forEach items="${noticeList}" var="n" varStatus="nvs">
	<div class="modal fade" id="noticeViewModal${nvs.count}" tabindex="-1" role="dialog" aria-labelledby="noticeViewModalLabel${nvs.count }" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title"><i class="fas fa-exclamation-circle"></i>&nbsp; 전체 공지</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	        <div class="noticeView">
	          <p class="view-title">${n.noticeTitle}</p>
	          <div style="font-size: .8rem; color: gray; margin-bottom: .5rem;">게시일 ${n.noticeDate}</div>
	            <div class="view-body">
	              <img class="view-img" src="${pageContext.request.contextPath}/resources/img/${n.noticeRenamedFileName}" alt="noticeViewPhoto" onerror="this.style.display='none'">
	              <p class="view-content">${n.noticeContent}</p>
	            </div>
	            <!-- /.view-body -->
	            <div class="comment-count"><i class="fas fa-comments"></i>&nbsp; 댓글 <span>(2)</span></div>
	            <div class="card-footer card-comments">
	              <div class="card-comment">
	                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/고양이.jpg" alt="User Image">
	                <div class="comment-text">
	                  <span class="username">이단비<span class="text-muted float-right">2020-01-25</span></span>
	                  <span>네! 알겠습니다!</span>
	                  <button class="comment-delete float-right">삭제</button>
	                  <button class="comment-reply float-right">답글</button>
	                </div>
	              </div>
	              <div class="card-comment comment-level2">
	                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/차은우.jpg" alt="User Image">
	                <div class="comment-text">
	                  <span class="username">유혜민<span class="text-muted float-right">2020-01-26</span></span>
	                  <span>넵! 알겠습니당</span>
	                  <button class="comment-delete float-right">삭제</button>
	                  <button class="comment-reply float-right">답글</button>
	                </div>
	              </div>
	            </div>
	            <div class="card-footer">
	              <form action="#" method="post">
	                <img class="img-fluid img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/${memberLoggedIn.renamedFileName == null?'기본프로필.jpg':memberLoggedIn.renamedFileName}">
	                <div class="img-push">
	                  <input type="text" class="form-control form-control-sm comment-text-area" placeholder="댓글을 입력하세요.">
	                  <input class="comment-submit" type="submit" value="등록">
	                </div>
	              </form>
	            </div> <!-- /.card-footer -->
	          </div> <!-- /.card -->
	      </div>
	    </div>
	  </div>
	</div>
</c:forEach>


<!-- 게시판 상세보기 모달 -->
<c:forEach items="${communityList}" var="c" varStatus="cvs">
	<div class="modal fade" id="boardViewModal${cvs.count}" tabindex="-1" role="dialog" aria-labelledby="boardModalLabel${cvs.count }" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title"><i class="fas fa-sticky-note"></i>&nbsp; 자유게시판</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	        <div class="boardView">
	          <p class="view-title">${c.commuTitle }</p>
	          <div class="user-block" style="margin-bottom: .5rem;">
	          	<img class="img-circle" src="${pageContext.request.contextPath}/resources/img/${c.renamedFileName == null?'기본프로필.jpg':c.renamedFileName}" alt="User Image">
	            <span class="username"><a href="#" style="color: black;">작성자 ${c.memberName }</a></span>
	            <span class="description">게시일 ${c.commuDate }</span>
	          </div>
	            <div class="view-body">
	              <img class="view-img" src="${pageContext.request.contextPath}/resources/img/${c.commuRenamedFileName}" alt="Photo" onerror="this.style.display='none'">
	              <p class="view-content">${c.commuContent }</p>
	            </div>
	            <!-- /.view-body -->
	            <div class="comment-count"><i class="fas fa-comments"></i>&nbsp; 댓글 <span>(3)</span></div>
	            <div class="card-footer card-comments">
	              <div class="card-comment">
	                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/우식01.jpeg" alt="User Image">
	                <div class="comment-text">
	                  <span class="username">김효정<span class="text-muted float-right">2020-01-26</span></span>
	                  <span>오오 감사합니당</span>
	                  <button class="comment-delete float-right">삭제</button>
	                  <button class="comment-reply float-right">답글</button>
	                </div>
	              </div>
	              <div class="card-comment">
	                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/박보검.png" alt="User Image">
	                <div class="comment-text">
	                  <span class="username">주보라<span class="text-muted float-right">2020-01-27</span></span>
	                  <span>괜찮은데요??</span>
	                  <button class="comment-delete float-right">삭제</button>
	                  <button class="comment-reply float-right">답글</button>
	                </div>
	              </div>
	              <div class="card-comment comment-level2">
	                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/재현.jpg" alt="User Image">
	                <div class="comment-text">
	                  <span class="username">이소현<span class="text-muted float-right">2020-01-27</span></span>
	                  <span>훨씬 편하네요~</span>
	                  <button class="comment-delete float-right">삭제</button>
	                  <button class="comment-reply float-right">답글</button>
	                </div>
	              </div>
	            </div>
	            <div class="card-footer">
	              <form action="#" method="post">
	                <img class="img-fluid img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/${memberLoggedIn.renamedFileName == null?'기본프로필.jpg':memberLoggedIn.renamedFileName}">
	                <div class="img-push">
	                  <input type="text" class="form-control form-control-sm comment-text-area" placeholder="댓글을 입력하세요.">
	                  <input class="comment-submit" type="submit" value="등록">
	                </div>
	              </form>
	            </div> <!-- /.card-footer -->
	          </div> <!-- /.card -->
	      </div>
	    </div>
	  </div>
	</div>
</c:forEach>

<!-- 공지 추가 모달 -->
<!-- 관리자: 전체/부서별 공지 작성 가능 -->
<!-- 부서별: 자기 부서는 selected / 나머지 부서 disabled -->
<div class="modal fade" id="addNoticeModal" tabindex="-1" role="dialog" aria-labelledby="addNoticeModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 공지 작성</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form action="">
        <div class="modal-body">
          <div class="addNotice" style="padding: 1rem;">
            <div class="form-group">
              <label for="inputDept">부서</label>
              <select class="form-control custom-select">
                <option selected>전체</option>
				<option value="D1">기획부</option>
                <option value="D2">디자인부</option>
                <option value="D3">개발부</option>
              </select>
            </div>
            <div class="form-group">
              <label for="inputName">공지 제목</label>
              <input type="text" id="inputName" class="form-control">
            </div>
            <!-- <div class="form-group">
              <label for="inputDescription">공지 카드 내용</label>
              <input type="text" class="form-control" maxlength="35" placeholder="35자 이내로 입력하세요.">
            </div> -->
            <div class="form-group">
              <label for="inputDescription">공지 내용</label>
              <textarea class="textarea"></textarea>
            </div>
            <div class="form-group">
              <label for="exampleFormControlFile1">파일 첨부</label>
              <input type="file" class="form-control-file" id="exampleFormControlFile1">
            </div>
          </div><!-- /.card-body -->
        </div> <!--/.modal-body-->
        <div class="modal-footer">
          <button type="submit" class="btn btn-outline-success">작성</button>
          <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 게시판 추가 모달 -->
<div class="modal fade" id="addBoardModal" tabindex="-1" role="dialog" aria-labelledby="addBoardModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 게시글 작성</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <form action="">
          <div class="modal-body">
              <div class="addNotice" style="padding: 1rem;">
                <div class="form-group">
                  <label for="inputName">게시글 제목</label>
                  <input type="text" id="inputName" class="form-control" maxlength="15" placeholder="15자 이내로 입력하세요.">
                </div>
                <!-- <div class="form-group">
                  <label for="inputDescription">게시글 카드 내용</label>
                  <input type="text" class="form-control" maxlength="35" placeholder="35자 이내로 입력하세요.">
                </div> -->
                <div class="form-group">
                  <label for="inputDescription">게시글 내용</label>
                  <textarea class="textarea"></textarea>
                </div>
                <div class="form-group">
                  <label for="exampleFormControlFile1">파일 첨부</label>
                  <input type="file" class="form-control-file" id="exampleFormControlFile1">
                </div>
              </div><!-- /.card-body -->
          </div> <!--/.modal-body-->
          <div class="modal-footer">
            <button type="submit" class="btn btn-outline-success">작성</button>
            <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
          </div>
        </form>
      </div>
    </div>
</div>

<!-- 공지수정 모달 -->
<!-- 관리자: 전체공지만 수정 / 부서별공지는 내가속한 부서에서 수정 -->
<!-- 부서별 옵션: 내가속한 부서만 selected 그 외엔 disabled -->
<div class="modal fade" id="updateNoticeModal" tabindex="-1" role="dialog" aria-labelledby="updateNoticeModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 공지 수정</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form action="">
        <div class="modal-body">
            <div class="addNotice" style="padding: 1rem;">
              <div class="form-group">
                <label for="inputDept">부서</label>
                <select class="form-control custom-select">
                  <option selected>전체</option>
                  <option>기획부</option>
                  <option>디자인부</option>
                  <option>개발부</option>
                </select>
              </div>
              <div class="form-group">
                <label for="inputName">공지 제목</label>
                <input type="text" id="inputName" class="form-control" value="모든 부서 전체 공지">
              </div>
              <!-- <div class="form-group">
                <label for="inputDescription">공지 카드 내용</label>
                <input type="text" class="form-control" maxlength="35" placeholder="35자 이내로 입력하세요." value="파이널 프로젝트가 본격적으로 시작되었습니다! 다들 화이팅!">
              </div> -->
              <div class="form-group">
                <label for="inputDescription">공지 내용</label>
                <textarea class="textarea">모든 부서 팀원들은 배부된 서류를 오늘 자정까지 제출해주세요!</textarea>
              </div>
              <div class="form-group">
                <label for="exampleFormControlFile1">파일 첨부</label>
                <input type="file" class="form-control-file" id="exampleFormControlFile1">
              </div>
            </div><!-- /.card-body -->
        </div> <!--/.modal-body-->
        <div class="modal-footer">
          <button type="submit" class="btn btn-outline-success">수정</button>
          <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 게시판 수정 모달 -->
<div class="modal fade" id="updateBoardModal" tabindex="-1" role="dialog" aria-labelledby="updateBoardModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 게시글 수정</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form action="">
        <div class="modal-body">
            <div class="addNotice" style="padding: 1rem;">
              <div class="form-group">
                <label for="inputName">게시글 제목</label>
                <input type="text" id="inputName" class="form-control" value="업무 메신저 기능">
              </div>
              <!-- <div class="form-group">
                <label for="inputDescription">게시글 카드 내용</label>
                <input type="text" class="form-control" maxlength="35" placeholder="35자 이내로 입력하세요." value="연휴가 벌써 지나갔네요ㅠㅠ">
              </div> -->
              <div class="form-group">
                <label for="inputDescription">게시글 내용</label>
                <textarea class="textarea">업무 메신저 기능이 추가되었네요! 모두 확인해보시길~</textarea>
              </div>
              <div class="form-group">
                <label for="exampleFormControlFile1">파일 첨부</label>
                <input type="file" class="form-control-file" id="exampleFormControlFile1">
              </div>
            </div><!-- /.card-body -->
        </div> <!--/.modal-body-->
        <div class="modal-footer">
          <button type="submit" class="btn btn-outline-success">수정</button>
          <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 부서별 공지 상세보기 모달 -->
<c:forEach items="${deptNoticeList}" var="deptn" varStatus="deptnvs">
	<div class="modal fade" id="myDeptNoticeViewModal${deptnvs.count}" tabindex="-1" role="dialog" aria-labelledby="myDeptNoticeViewModalLabel${deptnvs.count}" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title"><span id="myDept"><i class="fas fa-user"></i> &nbsp;${memberLoggedIn.deptCode=='D1'?"기획":memberLoggedIn.deptCode=='D2'?"디자인":"개발" }</span>&nbsp; 부서별 공지</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	        <div class="deptNoticeView">
	          <p class="view-title">${deptn.noticeTitle}</p>
	          <div class="user-block" style="margin-bottom: .5rem;">
	            <img class="img-circle" src="${pageContext.request.contextPath}/resources/img/${deptn.renamedFileName == null?'기본프로필.jpg':deptn.renamedFileName}" alt="User Image">
	            <span class="username"><a href="#" style="color: black;">작성자 ${deptn.memberName}</a></span>
	            <span class="description">게시일 ${deptn.noticeDate}</span>
	          </div>
	            <div class="view-body">
	              <img class="view-img" src="${pageContext.request.contextPath}/resources/img/${deptn.noticeRenamedFileName}" onerror="this.style.display='none'" alt="Photo">
	              <p class="view-content">${deptn.noticeContent}</p>
	            </div>
	            <!-- /.view-body -->
	            <div class="comment-count"><i class="fas fa-comments"></i>&nbsp; 댓글 <span>(2)</span></div>
	            <div class="card-footer card-comments">
	              <div class="card-comment">
	                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/재현01.jpg" alt="User Image">
	                <div class="comment-text">
	                  <span class="username">이주현<span class="text-muted float-right">2020-01-25</span></span>
	                  <span>네넵! 확인 완료!</span>
	                  <button class="comment-delete float-right">삭제</button>
	                  <button class="comment-reply float-right">답글</button>
	                </div>
	              </div>
	              <div class="card-comment">
	                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/우식01.jpeg" alt="User Image">
	                <div class="comment-text">
	                  <span class="username">김효정<span class="text-muted float-right">2020-01-26</span></span>
	                  <span>넵 확인했습니다!</span>
	                  <button class="comment-delete float-right">삭제</button>
	                  <button class="comment-reply float-right">답글</button>
	                </div>
	              </div>
	            </div>
	            <div class="card-footer">
	              <form action="#" method="post">
	                <img class="img-fluid img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/${memberLoggedIn.renamedFileName == null?'기본프로필.jpg':memberLoggedIn.renamedFileName}">
	                <div class="img-push">
	                  <input type="text" class="form-control form-control-sm comment-text-area" placeholder="댓글을 입력하세요.">
	                  <input class="comment-submit" type="submit" value="등록">
	                </div>
	              </form>
	            </div> <!-- /.card-footer -->
	          </div> <!-- /.card -->
	      </div>
	    </div>
	  </div>
	</div>
</c:forEach>




<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>