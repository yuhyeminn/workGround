<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<style>
.badge{
float: right; 
height: 1.5rem;
width: 3rem; 
padding-top: .5rem
}
.td{
border-bottom:1px solid #e6e8ec; 
border-top: 0px;
}
.name{
display: inline-block;
padding-left: 1rem;
padding-top: .5rem;
}
.span{
float: right;
padding-right: 4.2rem;
padding-top: .5rem;
}
.card-body:hover{
background: lightgray;
}
.col-md-10>div{
background: white; 
border-radius: .25rem; 
box-shadow: 0 0 1px rgba(0,0,0,.125), 0 1px 3px rgba(0,0,0,.2);
}
.card-header{
border-bottom: 1px solid rgba(0,0,0,.125); 
margin: 1rem 0 0 0;
padding: 1rem 1rem .8rem;
}
.card-body{
padding-top: 1rem; 
border-bottom: 1px solid #e6e8ec;
}
.deadline{
float: right; 
padding-right: 1rem;
}
.col-md-10{
margin: 0 auto;
}
#navbar-tab{margin: 0 auto;}
#attachment-wrapper{padding: 5px 3rem 3rem;}
</style>

<script>
$(function(){
	sidebarActive(); //사이드바 비활성화
	//tabActive(); //서브헤더 탭 활성화
	//goTabMenu(); //서브헤더 탭 링크 이동
});

//사이드바 비활성화
function sidebarActive(){
	let navLinkArr = document.querySelectorAll(".sidebar .nav-link");
	
	navLinkArr.forEach((obj, idx)=>{
		let $obj = $(obj);
		if($obj.hasClass('active'))
			$obj.removeClass('active');
	});
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

    $("#tab-whole").addClass("active");
}
</script>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper navbar-light">
    <h2 class="sr-only">통합검색</h2>
    <!-- Main content -->
    <div id="attachment-wrapper" class="content view">
        <div class="col-md-10" >
            <div>
                <div class="card-header">
                    <h3><i class="far fa-file-word"></i>&nbsp;&nbsp;업무</h3>
                </div><!-- /.card-header -->
                <div class="card-body">
                    <div class="tab-content">
                        <div class="active tab-pane" id="activity">
                            <!-- Post -->
                            <div class="post">
                            <p>기획>해야할 일</p>
                            <h5>제목</h5>
                            <p>내용내용내용</p>
                        </div>
                    </div>
                </div>
                </div>
                <div class="card-body">
                    <div class="tab-content">
                        <div class="active tab-pane" id="activity">
                            <!-- Post -->
                            <div class="post">
                            <p>기획>해야할 일</p>
                            <h5>제목</h5>
                            <p>내용내용내용</p>
                        </div>
                    </div>
                </div>
                </div>
            </div>
        </div>
        <div class="col-md-10">
            <div>
                <div class="card-header">
                    <h3><i class="nav-icon far fa-calendar-check"></i>&nbsp;&nbsp;프로젝트</h3>
                </div><!-- /.card-header -->
                <div class="card-body">
                    <div class="tab-content">
                        <div class="active tab-pane" id="activity">
                            <!-- Post -->
                            <div class="post">
                                <span class="badge badge-success">진행중</span>
                                <span class="deadline">마감일 4시간 지남</span>
                                <h6>기획</h6>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div> 
        <div class="col-md-10" >
            <div>
                <div class="card-header">
                    <h3><i class="fas fa-tasks"></i>&nbsp;&nbsp;업무리스트</h3>
                </div><!-- /.card-header -->
                <div class="card-body" >
                    <div class="tab-content">
                        <div class="active tab-pane" id="activity">
                            <!-- Post -->
                            <div class="post">
                                <p>test</p>  
                                <h6>test</h6>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-10">
            <div>
                <div class="card-header">
                    <h3><i class="fas fa-users"></i>&nbsp;&nbsp;멤버</h3>
                </div><!-- /.card-header -->
                <div class="card-body">
                    <div class="tab-content">
                        <div class="active tab-pane" id="activity">
                            <!-- Post -->
                            <div class="post">
                                <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user2-160x160.jpg" alt="Message User Image">
                                <h6 class="name">이주현</h6>
                                <span class="span">teetee77@naver.com</span>
                                <span class="span">010-1234-1234</span>
                                <span class="span">인턴</span>
                                <span class="span">개발팀</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="tab-content">
                        <div class="active tab-pane" id="activity">
                            <!-- Post -->
                            <div class="post">
                                <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user2-160x160.jpg" alt="Message User Image">
                                <h6 class="name">이주현</h6>
                                <span class="span">teetee77@naver.com</span>
                                <span class="span">010-1234-1234</span>
                                <span class="span">인턴</span>
                                <span class="span">개발팀</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>           
    </div>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>