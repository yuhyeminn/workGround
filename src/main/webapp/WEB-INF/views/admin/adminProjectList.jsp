<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<style>
.content{margin-top: -46px;}
.btn-drop{background-color:transparent; border:0px transparent solid;}
.navbar-project .dropdown-menu{min-width: 6rem;}
#tbl-projectAttach.table.member-table td{padding: .9rem 0;}
#tbl-projectAttach.member-table img{display: inline-block; width: 40px; height: auto; margin-right: .3rem;}
.btn-admin{width: 45px !important; margin: 0 auto; font-size: .7rem;}
#tbl-projectAttach.member-table .dropdown-item{color: #dc3545; font-size: .8rem;}
#tbl-projectAttach.member-table .dropdown-item i{margin-right: .5rem;}
.comment-reply.work-comment-reply.float-right{border: 0;background: darkgray;border-radius: 3px;margin-right: .9rem;color: white;}
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
        order : [[0, 'desc']]
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
	
	$("#sidebar-project").addClass("active");
}

//멤버 프로필 페이지로 이동
function goMemberProfile(memberId){
    location.href = '${pageContext.request.contextPath}/member/memberView.do?memberId='+memberId;
}

function deleteChk(projectNo){
	var result = confirm("프로젝트를 삭제하시겠습니까?"); 
	if(result == true){
		location.href = '${pageContext.request.contextPath}/project/deleteProject.do?projectNo='+projectNo;
	}
}

//프로젝트로 이동
function goProjectInfo(projectNo){
	
	location.href = '${pageContext.request.contextPath}/project/projectView.do?projectNo='+projectNo;
}
</script>	


<!-- Content Wrapper. Contains page content -->
<div id="member-list" class="content-wrapper">
    <!-- Main content -->
    <section class="content">
        <h2 style="margin-bottom: 1.4rem;">프로젝트</h2>
        
        <div id="member-inner" class="table-responsive p-0">
            
            <!-- 멤버리스트 -->
            <table id="tbl-projectAttach" class="table table-hover text-nowrap member-table">
                <thead>
                    <tr>
                    	<th style="width: 5%;text-align:center;padding:.75rem 0px;">번호</th>
                        <th style="width: 38%;text-align:center;" >제목</th>
                        <th style="width: 20%">작성자</th>
                        <th style="width: 5%;text-align:center;">프로젝트 상태</th>
                        <th style="width: 17%"></th>
                    </tr>
                </thead>
                <tbody>
                	<c:forEach items="${projectList}" var="p">
                    <tr>
                    	<td style="text-align:center">${p.projectNo}</td>
                        <td style="text-align:center;" onclick="goProjectInfo('${p.projectNo}')">${p.projectTitle}</td>
                        <td onclick="goMemberProfile('${p.projectWriter}');">${p.memberName}</td>
                        <td style="text-align:center;"><span class="btn btn-block btn-sm btn-outline-${p.projectStatusColor}">${p.projectStatusTitle}</span></td>
                        <td>
                            <button class="comment-reply work-comment-reply float-right" onclick="deleteChk(${p.projectNo})">삭제</button>
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

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>