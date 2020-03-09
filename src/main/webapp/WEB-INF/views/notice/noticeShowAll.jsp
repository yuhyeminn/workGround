<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
<link rel="stylesheet" property="stylesheet" href="${pageContext.request.contextPath}/resources/css/notice.css">

<style>
.layout-navbar-fixed .wrapper .content-wrapper{margin-top: 46px;}
.btn-drop{background-color:transparent; border:0px transparent solid;}
.navbar-project .dropdown-menu{min-width: 6rem;}
#tbl-projectAttach.table.member-table td{padding: .5rem 0;}
#tbl-projectAttach.member-table img{display: inline-block; width: 40px; height: auto; margin-right: .3rem;}
.btn-admin{width: 45px !important; margin: 0 auto; font-size: .7rem;}
#tbl-projectAttach.member-table .dropdown-item{color: #dc3545; font-size: .8rem;}
#tbl-projectAttach.member-table .dropdown-item i{margin-right: .3rem;}

#tbl-projectAttach th{text-align: center;}
#tbl-projectAttach tr{height: 2.8rem;}
#tbl-projectAttach.table th:first-of-type {padding-left: 2rem;}
</style>

<script>
$(function(){
	//데이터 테이블 설정
	$('#tbl-projectAttach').DataTable({
        "paging": true,
        "lengthChange": false,
        "searching": false,
        "ordering": false,
        "info": false,
        "autoWidth": false,
    });
	
	sidebarActive(); //사이드바 활성화
	showModal(); //모달 띄우기
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

//공지/커뮤니티 상세보기에서 댓글 작성, 삭제
//공지 댓글 삭제
function deleteNoticeComment(noticeCommentNo){
	if(!confirm("댓글을 삭제하시겠습니까?"))
		return;
	location.href = "${pageContext.request.contextPath}/notice/noticeCommentDelete.do?noticeCommentNo="+noticeCommentNo;
}

//게시판 댓글 삭제
function deleteCommunityComment(communityCommentNo){
	if(!confirm("댓글을 삭제하시겠습니까?"))
		return;
	location.href = "${pageContext.request.contextPath}/community/communityCommentDelete.do?communityCommentNo="+communityCommentNo;

}

//댓글 유효성 검사
function checkComment(commentContent){
	if(commentContent.trim() == 0){
		alert("댓글을 입력하지 않으셨습니다!");
		return false;
	}
	return true;
} 

//모달 띄우기
function showModal(){
	$(document).on('click', 'tr', (e)=>{
		let obj;
		if(e.target.tagName==='TD') obj = e.target.parentNode;
		else obj = e.target;
		
		let targetArr = $(obj).attr('data-target').split('Modal');
		let no = targetArr[1]*1;
		let boardType;
		
		//게시글 타입 설정
		if(targetArr[0]==='#noticeView') boardType = 'total';
		else if(targetArr[0]==='#myDeptNoticeView') boardType = 'dept';
		else boardType = 'community';
		
		let data = {
			modalType: 'show',
			boardType: boardType,
			no: no
		};
		
		$.ajax({
			url: '${pageContext.request.contextPath}/notice/selectBoardOne.do',
			data: data,
			dataTyp: 'html',
			type: 'GET',
			success: data=>{
				$('.modal').remove();
				$('.modal-backdrop').remove();
				$('.content-wrapper').append(data);
				$('.modal').modal();
			},
			error: (x,s,e)=>{
				console.log(x,s,e);
			}
		});
	});
}
</script>	


<!-- Content Wrapper. Contains page content -->
<div id="member-list" class="content-wrapper">
    <!-- Main content -->
    <section class="content">
    	<c:if test="${type=='total'}">
	        <h2><i class="far fa-file-word"></i>&nbsp;&nbsp;전체 공지 (${fn:length(noticeList)})</h2>
    	</c:if>
    	<c:if test="${type=='dept'}">
	        <h2><i class="far fa-file-word"></i>&nbsp;&nbsp;${memberLoggedIn.deptTitle} 게시글  (${fn:length(deptNoticeList)})</h2>
    	</c:if>
    	<c:if test="${type=='commu'}">
	        <h2><i class="far fa-file-word"></i>&nbsp;&nbsp;커뮤니티 (${fn:length(communityList)})</h2>
    	</c:if>
        <div id="member-inner" class="table-responsive p-0">
            <table id="tbl-projectAttach" class="table table-hover text-nowrap member-table">
                <thead>
                    <tr>
                        <th style="width: 40%; text-align: left;">제목</th>
                        <th style="width: 17%">작성날짜</th>
                        <th style="width: 17%">작성자</th>
                    </tr>
                </thead>
                <tbody>
                	<!-- 공지/부서별 게시글 -->
                	<c:if test="${type=='total' || type=='dept'}">
	                	<c:forEach items="${type == 'total'?noticeList:deptNoticeList}" var="n">
		                    <c:if test="${type == 'total'}">
			                    <tr data-toggle="modal" data-target="#noticeViewModal${n.noticeNo}">
		                    </c:if>
		                    <c:if test="${type == 'dept'}">
			                    <tr data-toggle="modal" data-target="#myDeptNoticeViewModal${n.noticeNo}">
		                    </c:if>
		                        <td style="padding-left: 2rem;">${n.noticeTitle}</td>
		                        <td style="text-align: center;">${n.noticeDate}</td>
		                        <td style="text-align: center;">${n.memberName}</td>
		                    </tr>
	                    </c:forEach>
                	</c:if>
	                	<c:forEach items="${communityList}" var="c">
		                	<c:if test="${type=='commu'}">
		                		<tr data-toggle="modal" data-target="#boardViewModal${c.commuNo}">
			                        <td style="padding-left: 2rem;">${c.commuTitle}</td>
			                        <td style="text-align: center;">${c.commuDate}</td>
			                        <td style="text-align: center;">${c.memberName}</td>
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

<jsp:include page="/WEB-INF/views/notice/noticeModal.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>