<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<style>
#member-inner{margin-top: 1rem;}
#tbl-projectAttach thead{background: #fff;}
.card-header{
border-bottom: 1px solid rgba(0,0,0,.125); 
margin: 1rem 0 0 0;
padding: 1rem 1.5rem .7rem;
cursor: default;
}
.card-header:hover{background: inherit; border-radius: .25rem; cursor: default;}
.card-header h3{display:inline-block; margin-bottom: 0; font-size: .95rem;}

#tbl-projectAttach .direct-chat-img{width: 30px; height: 30px;}
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
	
	sidebarActive(); //사이드바 비활성화
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
</script>	


<!-- Content Wrapper. Contains page content -->
<div id="member-list" class="content-wrapper">
    <!-- Main content -->
    <section class="content">
        
        <div id="member-inner" class="table-responsive p-0">
        	
        	<c:if test="${type=='total' || type=='dept'}">
            <!-- 공지/부서별 게시글-->
            <table id="tbl-projectAttach" class="table table-hover text-nowrap member-table">
                <thead>
                    <tr>
                        <th class="card-header">
                        	<h3>
                        		<i class="far fa-file-word"></i>&nbsp;&nbsp;
	                        	<c:if test="${type == 'total'}">
                        		공지 
	                        	</c:if>
	                        	<c:if test="${type == 'dept'}">
                        		${memberLoggedIn.deptTitle} 게시글
	                        	</c:if>
                        		<span class="header-count">(${fn:length(list)})</span>
                        	</h3>
                        </th>
                    </tr>
                </thead>
                <tbody>
                	<c:forEach items="${list}" var="n">
                    <tr>
                        <td><h5>${n.noticeTitle}</h5></td>
                        <td>${n.noticeDate}</td>
                        <td>${n.memberName}</td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>   
            </c:if>
            
            <%-- <c:if test="${type=='commu'}">
            <!-- 커뮤니티 게시글-->
            <table class="tbl-projectAttach" class="table table-hover text-nowrap member-table">
                <thead>
                    <tr>
                        <th class="card-header">
                        	<h3>
                        		<i class="far fa-file-word"></i>&nbsp;&nbsp;커뮤니티 <span class="header-count">(${fn:length(list)})</span>
                        	</h3>
                        </th>
                    </tr>
                </thead>
                <tbody>
                	<c:forEach items="${list}" var="c">
                    <tr>
                        <td><h5>${c.commuTitle}</h5></td>
                        <td>${c.commuDate}</td>
                        <td>${c.memberName}</td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>   
            </c:if>
            
            <c:if test="${type=='project'}">
            <!-- 프로젝트 -->
            <table id="tbl-projectAttach" class="table table-hover text-nowrap member-table">
                <thead>
                    <tr>
                        <th class="card-header">
                        	<h3>
                        		<i class="far fa-file-word"></i>&nbsp;&nbsp;프로젝트 <span class="header-count">(${fn:length(list)})</span>
                        	</h3>
                        </th>
                    </tr>
                </thead>
                <tbody>
                	<c:forEach items="${list}" var="p">
                    <tr>
                        <td><h5>${p.projectTitle}</h5></td>
                        <td class="date">
                        	<c:set var="now" value="<%= new Date() %>"/>
	                    	<fmt:formatDate var="nowStr" value="${now}" type="date" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseDate var="today" value="${nowStr}" type="date" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseNumber var="today_D" value="${today.time/(1000*60*60*24)}" integerOnly="true"/>
	                    	<fmt:parseDate var="enddate" value="${p.projectEndDate}" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseNumber var="enddate_D" value="${enddate.time/(1000*60*60*24)}" integerOnly="true"/>
                        
                        	<span class="date">
                               <!-- 실제완료일이 없는 경우 -->
                               <c:if test="${p.projectRealEndDate==null}">
                               	<!-- 마감일이 없는 경우 -->
                               	<c:if test="${p.projectEndDate==null}">
	                                <!-- 시작일만 있는 경우 -->
		                        	<c:if test="${p.projectStartDate!=null && p.projectEndDate==null}">
			                        	<span class="date-color"><fmt:formatDate value="${p.projectStartDate}" type="date" pattern="MM월 dd일"/></span>에 시작
		                        	</c:if>
		                        </c:if>
                                <!-- 마감일이 있는 경우 -->
                                <c:if test="${p.projectEndDate!=null}">
                                	<!-- 마감일 안 지난 경우: 시작일이 있는 경우 -->
	                        		<c:if test="${today_D <= enddate_D && p.projectStartDate!=null}">
                                	<span class="date-color">
										<fmt:formatDate value="${p.projectStartDate}" type="date" pattern="MM월 dd일"/> -
	                        			<fmt:formatDate value="${p.projectEndDate}" type="date" pattern="MM월 dd일"/>
									</span>
									</c:if> 
									<!-- 마감일 안 지난 경우: 시작일이 없는 경우 -->
									<c:if test="${today_D <= enddate_D && p.projectStartDate==null}">
										<span class="date-color"><fmt:formatDate value="${p.projectEndDate}" type="date" pattern="MM월 dd일"/></span>에 마감
									</c:if>
									<!-- 마감일 지난 경우 -->
	                        		<c:if test="${today_D > enddate_D}">
										<span class="date-color over">마감일 ${today_D - enddate_D}일 지남</span>
									</c:if> 
                                </c:if>
	                        </c:if>
	                        <!-- 실제완료일이 있는 경우 -->
                               <c:if test="${p.projectRealEndDate!=null}">
                               	<span class="date-color"><fmt:formatDate value="${p.projectStartDate}" type="date" pattern="MM월 dd일"/></span>에 완료
                               </c:if>
                        	</span>
                        </td>
                        <td><span class="btn btn-block btn-sm bg-${p.projectStatusColor}">${p.projectStatusTitle}</span></td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>   
            </c:if>
             
            <c:if test="${type=='club'}">
            <!-- 동호회 -->
            <table class="tbl-projectAttach" class="table table-hover text-nowrap member-table">
                <thead>
                    <tr>
                        <th class="card-header">
                        	<h3>
                        		<i class="far fa-file-word"></i>&nbsp;&nbsp;동호회 <span class="header-count">(${fn:length(list)})</span>
                        	</h3>
                        </th>
                    </tr>
                </thead>
                <tbody>
                	<c:forEach items="${list}" var="map">
                    <tr>
                        <td>
                        	<h5>${map['clubName']}</h5>
                        	<button type="button" class="btn btn-outline-warning btn-xs btn-admin btn-clubCate">${map['category']}</button>
                        </td>
                        <td><span class="date"><fmt:formatDate value="${map['enrollDate']}" type="date" pattern="yyyy-MM-dd" /></span></td>
                        <td><span class="writer">${map['clubManager']}</span></td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>   
            </c:if> 
             
            <c:if test="${type=='member'}">
            <!-- 멤버 -->
            <table class="tbl-projectAttach" class="table table-hover text-nowrap member-table">
            	<colgroup>
            		<col width="60%"/>
            		<col width="20%"/>
            		<col width="20%"/>
            	</colgroup>
                <thead>
                    <tr>
                        <th colspan="3" class="card-header">
                        	<h3>
                        		<i class="far fa-file-word"></i>&nbsp;&nbsp;멤버 <span class="header-count">(${fn:length(list)})</span>
                        	</h3>
                        </th>
                    </tr>
                </thead>
                <tbody>
                	<c:forEach items="${list}" var="m">
                    <tr>
                        <td>
                        	<img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Image">
                        	<h5>${m.memberName}</h5>
                        </td>
                        <td><span class="dept">${m.deptTitle}</span></td>
                        <td><span class="email">${m.email}</td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>    
            </c:if>  --%>
        </div>
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->		

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>