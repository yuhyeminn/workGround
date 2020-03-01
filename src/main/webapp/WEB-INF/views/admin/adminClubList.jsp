<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
<%-- <jsp:include page="/WEB-INF/views/club/clubViewModal.jsp"></jsp:include> --%>

<style>
.content{margin-top: -46px;}
.btn-drop{background-color:transparent; border:0px transparent solid;}
.navbar-project .dropdown-menu{min-width: 6rem;}
#tbl-projectAttach.table.member-table td{padding: .5rem 0;}
#tbl-projectAttach.member-table img{display: inline-block; width: 40px; height: auto; margin-right: .3rem;}
.btn-admin{width: 45px !important; margin: 0 auto; font-size: .7rem;}
#tbl-projectAttach.member-table .dropdown-item{color: #dc3545; font-size: .8rem;}
#tbl-projectAttach.member-table .dropdown-item i{margin-right: .3rem;}
.comment-reply.work-comment-reply.float-right{border: 0;background: darkgray;border-radius: 3px;margin-right: .3rem;color: white;}
.comment-reply.work-comment-reply.float-right:hover{background:#dc3545;}
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

function deleteChk(clubNo){
	var result = confirm("동호회를 삭제하시겠습니까?"); 
	if(result == true){
		location.href = "${pageContext.request.contextPath}/club/deleteClub.do?clubNo="+clubNo;
	}
}  
</script>	


<!-- Content Wrapper. Contains page content -->
<div id="member-list" class="content-wrapper">
    <!-- Main content -->
    <section class="content">
        <h2 style="margin-bottom: 1.4rem;">동호회</h2>
        
        <div id="member-inner" class="table-responsive p-0">

            <!-- 멤버리스트 -->
            <table id="tbl-projectAttach" class="table table-hover text-nowrap member-table">
                <thead>
                    <tr>
                        <th style="width: 35%">동호회</th>
                        <th style="width: 20%">동호회장</th>
                        <th style="width: 20%">개설날짜</th>
                        <th style="width: 20%">카테고리</th>
                        <th style="width: 17%"></th>
                    </tr>
                </thead>
                <tbody>
                	<c:forEach items="${clubList}" var="club">
                    <tr>
                        <td style="padding-left: 1.3rem;" data-toggle="modal" data-target="#modal-club-${club.clubNo}">${club.clubName}</td>
                        <td onclick="goMemberProfile('${club.clubManagerId}');">${club.memberName}</td>
                        <td>${club.clubEnrollDate}</td>
                       	<td><button type="button" class="btn btn-outline-warning btn-xs btn-admin btn-clubCate">${club.clubCategory}</button></td>
                        <td>
                          	<button class="comment-reply work-comment-reply float-right" onclick="deleteChk(${club.clubNo})">삭제</button>
                        </td>
                    </tr>
                   </c:forEach>
                </tbody>
            </table>    
        </div>
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->		

<jsp:include page="/WEB-INF/views/club/clubListModal.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>