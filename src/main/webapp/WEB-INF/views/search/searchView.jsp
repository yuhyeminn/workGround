<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="com.kh.workground.common.util.Utils"%>
<%
	//페이지바 작업
	String keyword = (String)request.getAttribute("keyword");
	String type = (String)request.getAttribute("type");
	int totalContents = (int)request.getAttribute("totalContents");
	int cPage = (int)request.getAttribute("cPage");
	int numPerPage = (int)request.getAttribute("numPerPage");
	String url = "searchView.do?keyword="+keyword+"&type="+type; 
	
	String pageBar = Utils.getPageBar(totalContents, cPage, numPerPage, url);
	
	pageContext.setAttribute("pageBar", pageBar);
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<style>
.td{
border-bottom:1px solid #e6e8ec; 
border-top: 0px;
}
.name{
display: inline-block;
padding-left: .5rem;
padding-top: .3rem;
color: #464c59;
}
.span{
padding-right: 4.2rem;
padding-top: .5rem;
}
.col-md-10{margin: 0 auto 1.8rem;}
.col-md-10>.card-wrapper{
background: white; 
border-radius: .25rem; 
box-shadow: 0 0 1px rgba(0,0,0,.125), 0 1px 3px rgba(0,0,0,.2);
}
.card-header{
border-bottom: 1px solid rgba(0,0,0,.125); 
margin: 1rem 0 0 0;
padding: 1rem 1.5rem .7rem;
}
.card-header:hover{background: #fff; border-radius: .25rem; cursor: default;}
.card-header h3{display:inline-block; font-size: .95rem;}
.card-body{padding-top: 1rem; border-bottom: 1px solid rgba(0,0,0,.125); cursor: pointer;}
.card-body:hover{background: #f3f4f5;}
.card-body:last-of-type:hover{border-radius: .25rem;}
.deadline{float: right; padding-right: 1rem;}
#navbar-tab{margin: 0 auto;}
#attachment-wrapper{padding: 1.8rem 3rem 3rem; margin-top: -46px;}
.tab-content{background-color: inherit; padding: 0 0 0 .25rem;}
.tab-content h5{display: inline-block; padding-top: .2rem; margin: 0; font-size: 1rem;}
.btn-more{float: right; color: #8d919a; font-size: .88rem;}
.btn-more:hover, .btn-more:active, .btn-more:focus{color: #464c59;}

#project-wrapper h5, #community-wrapper h5, #dept-wrapper h5{display: inline-block;}
.card-status{float: right; margin-top: 0; padding-right: .5rem; padding-top: .2rem; color: #8d919a;}
.card-status>span{position: unset;}
.card-status .date{float: none; width: 6rem; margin-right: 13.5rem; font-size: .8rem;}
.card-status .writer{color: #464c59;}
#project-wrapper .date{width: 8rem; margin-left: 29rem;}
.date-color{color: #17a2b8;}
.date-color.over{color: #dc3545;}
.btn-clubCate{margin-left: .5rem; margin-top: -3px;}

#member-wrapper .card-body{padding: 1rem 1.5rem;}
.direct-chat-img{width: 30px; height: 30px; object-fit: cover;}
.email{float: right; padding: .2rem .3rem 0 0; color: #464c59;}
.dept{margin-left: 27rem;}

#empty-wrapper{width: 800px; height: 450px; margin: 1rem auto 0; padding: 3rem; background: #fff; border: 1px solid rgba(29,34,43,.1); border-radius: 2px;}
#empty-wrapper img{display: block; width: 30%; margin: 0 auto;}
#empty-wrapper p{margin-top: 1rem; color: #464c59; font-weigth: bold; text-align: center;}
</style>

<script>
$(function(){
	sidebarActive(); //사이드바 비활성화
	showAll();
});

//모두보기 이동
function showAll(){
	$(".btn-more").on('click', (e)=>{
		let val = e.target.value;
		let keyword = val.split(',')[0]; 
		let type = val.split(',')[1];
		
		location.href="${pageContext.request.contextPath}/search/searchView.do?keyword="+keyword+"&type="+type;
	});
}

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
<div class="content-wrapper navbar-light">
    <h2 class="sr-only">통합검색</h2>
    <!-- Main content -->
    <div id="attachment-wrapper" class="content view">
    
    	<c:if test="${type=='total' || type=='dept'}">
        <!-- 공지/부서별 게시글-->
        <div class="col-md-10" >
        	 <div class="card-wrapper">
	             <div class="card-header">
	             	 <h3>
		                 <i class="far fa-file-word"></i>&nbsp;&nbsp;
		                 <c:if test="${type == 'total'}">
		                  	공지 
		                 </c:if>
		                 <c:if test="${type == 'dept'}">
		                  	${memberLoggedIn.deptTitle} 게시글
		                 </c:if>
		                 <span class="header-count">(${totalContents})</span>
	                 </h3>
	             </div><!-- /.card-header -->
	             <c:forEach items="${list}" var="n">
	             <div class="card-body"> 
	                 <div class="tab-content">
	                     <div class="active tab-pane">
	                         <h5>${n.noticeTitle}</h5>
	                         <div class="card-status">
                                <span class="date">${n.noticeDate}</span>
                                <span class="writer">${n.memberName}</span>
                             </div>
	                     </div>
	                 </div>
	             </div>
	             </c:forEach>
             </div>
        </div>
        ${pageBar} 
        </c:if>
        
        <c:if test="${type=='commu'}">
        <!-- 커뮤니티 -->
        <div class="col-md-10" >
        	 <div id="community-wrapper" class="card-wrapper">
	             <div class="card-header">
	                 <h3><i class="far fa-file-word"></i>&nbsp;&nbsp;커뮤니티 <span class="header-count">(${totalContents})</span></h3>
	             </div><!-- /.card-header -->
	             <c:forEach items="${list}" var="c">
	             <div class="card-body">
	                 <div class="tab-content">
	                     <div class="active tab-pane">
	                         <h5>${c.commuTitle}</h5>
	                         <div class="card-status">
                                <span class="date">${c.commuDate}</span>
                                <span class="writer">${c.memberName}</span>
                             </div>
	                     </div>
	                 </div>
	             </div>
	             </c:forEach>
             </div>
        </div>
        ${pageBar}     
        </c:if>
        
        <c:if test="${type=='project'}">
        <!-- 프로젝트 -->
        <div class="col-md-10">
            <div id="project-wrapper" class="card-wrapper">
                <div class="card-header">
                    <h3><i class="nav-icon far fa-calendar-check"></i>&nbsp;&nbsp;프로젝트 <span class="header-count">(${totalContents})</span></h3>
                </div><!-- /.card-header -->
                
                <c:forEach items="${list}" var="p">
                <a href="${pageContext.request.contextPath}/project/projectView.do?projectNo=${p.projectNo}">
                <div class="card-body">
                    <div class="tab-content">
                        <div class="active tab-pane">
                            <h5>${p.projectTitle}</h5>
                            <div class="card-status">
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
                                <span class="btn btn-block btn-sm bg-${p.projectStatusColor}">${p.projectStatusTitle}</span>
                            </div>
                        </div>
                    </div>
                </div>
                </a>
                </c:forEach>
            </div>
        </div> 
        ${pageBar}     
        </c:if>
        
        <c:if test="${type=='club'}">
        <!-- 동호회 -->
        <div class="col-md-10" >
        	 <div id="community-wrapper" class="card-wrapper">
	             <div class="card-header">
	                 <h3><i class="far fa-file-word"></i>&nbsp;&nbsp;동호회 <span class="header-count">(${totalContents})</span></h3>
	             </div><!-- /.card-header -->
	             <c:forEach items="${clubList}" var="map" begin="0" end="4">
	             <div class="card-body">
	                 <div class="tab-content">
	                     <div class="active tab-pane">
	                         <h5>${map['clubName']}</h5>
	                         <button type="button" class="btn btn-outline-warning btn-xs btn-admin btn-clubCate">${map['category']}</button>
	                         <div class="card-status">
                                <span class="date"><fmt:formatDate value="${map['enrollDate']}" type="date" pattern="yyyy-MM-dd" /></span>
                                <span class="writer">${map['clubManager']}</span>
                             </div>
	                     </div>
	                 </div>
	             </div>
	             </c:forEach>
             </div>
        </div>
        ${pageBar}     
        </c:if>
        
        <c:if test="${type=='member'}">
        <!-- 멤버 -->
        <div class="col-md-10">
            <div id="member-wrapper" class="card-wrapper">
                <div class="card-header">
                    <h3><i class="fas fa-users"></i>&nbsp;&nbsp;멤버 <span class="header-count">(${totalContents})</span></h3>
                </div><!-- /.card-header -->
                <c:forEach items="${list}" var="m">
                <a href="${pageContext.request.contextPath}/member/memberView.do?memberId=${m.memberId}">
                <div class="card-body">
                    <div class="tab-content">
                        <div class="active tab-pane">
                             <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Image">
                             <h5 class="name">${m.memberName}</h5>
		                     <span class="dept">${m.deptTitle}</span>
		                          <span class="email">${m.email}</span>
                        </div>
                    </div>
                </div>
                </a>
                </c:forEach>
            </div>
        </div>
        ${pageBar}     
        </c:if> 
        
    </div>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>