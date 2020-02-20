<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />

    <h2 class="sr-only">프로젝트 목록</h2>
    <!-- Main content -->
    <div class="content">
        <div class="container-fluid">
        <!-- 최근 프로젝트 -->
        <section id="project-recent">
            <div class="card-header" role="button" tabindex="0" onclick="toggleList(this);">
                <h3><i class="fas fa-chevron-down"></i> 최근 프로젝트</h3>
            </div><!-- /.card-header -->
            <div class="row card-content" id="project-recent-content">
            
            <c:forEach items="${projectMap.listByDept}" var="p">
	            <div class="col-12 col-sm-6 col-md-3">
	                <div class="card card-hover">
	                <a href="${pageContext.request.contextPath}/project/projectView.do?projectNo=${p.projectNo}">
	                    <div class="card-body">
	                    <div class="card-title">
	                        <h5>${p.projectTitle}</h5>
	                    </div>
	                    </div>
	                </a>
	                </div><!-- /.card -->
	            </div>
	        </c:forEach> 
	        
	        </div><!-- /.card-content -->
        </section>

        <!-- 중요 표시된 프로젝트 -->
        <section id="project-important">
            <div class="card-header" role="button" tabindex="0" onclick="toggleList(this);">
            	<h3><i class="fas fa-chevron-down"></i> <i class="fas fa-star"></i> 중요 표시된 프로젝트 <span class="header-count" id="important-count">(${fn:length(listByImportant)})</span></h3>
            </div><!-- /.card-header -->
            <div class="row card-content" id="project-important-content">
            
            <c:forEach items="${projectMap.listByImportant}" var="p">
            <div class="col-12 col-sm-6 col-md-3">
                <div class="card card-hover">
                    <a href="${pageContext.request.contextPath}/project/projectView.do?projectNo=${p.projectNo}">
                    <div class="card-body star-body">
                        <!-- 타이틀 -->
                        <div class="card-title">
                        	<h5>${p.projectTitle}</h5>
                        </div>
                        <!-- 중요표시 -->
                        <div class="card-star text-right">
                        	<i class="fas fa-star"></i>
                        	<c:if test="${memberLoggedIn.memberId == p.projectWriter}">
                        	<span class="line"></span>
                        	<button type="button" class="btn-del-project" value="${p.projectNo},${p.projectTitle}" data-toggle="modal" data-target="#modal-project-remove"><i class="fas fa-times del-project"></i></button>
                        	</c:if>
                        </div>
                        <!-- 프로젝트 상태 / 마감일 -->
                        <div class="card-status">
                        	<span class="btn btn-block btn-sm bg-${p.projectStatusColor}">${p.projectStatusTitle}</span>
	                        <span class="end-date">
	                        	<c:set var="now" value="<%= new Date() %>"/>
		                    	<fmt:formatDate var="nowStr" value="${now}" type="date" pattern="yyyy-MM-dd"/>
		                    	<fmt:parseDate var="today" value="${nowStr}" type="date" pattern="yyyy-MM-dd"/>
		                    	<fmt:parseNumber var="today_D" value="${today.time/(1000*60*60*24)}" integerOnly="true"/>
		                    	<fmt:parseDate var="enddate" value="${p.projectEndDate}" pattern="yyyy-MM-dd"/>
		                    	<fmt:parseNumber var="enddate_D" value="${enddate.time/(1000*60*60*24)}" integerOnly="true"/>
		                    	
	                        	<!-- 실제완료일이 있는 경우  -->
	                        	<c:if test="${p.projectRealEndDate!=null}">
	                        	<span class="p-completed"><fmt:formatDate value="${p.projectRealEndDate}" type="date" pattern="MM월 dd일"/>에 완료</span>
	                        	</c:if>
	                        	<!-- 실제완료일 없고 마감일만 있는 경우 -->
	                        	<c:if test="${p.projectRealEndDate==null && p.projectEndDate!=null}">
	                        		<!-- 마감일 안 지난 경우 -->
	                        		<c:if test="${today_D <= enddate_D}">
		                        	<i class="far fa-calendar-alt"></i> 
		                        	${p.projectEndDate}
	                        		</c:if>
	                        		<c:if test="${today_D > enddate_D}">
		                        	<span class="p-over">마감일 ${today_D - enddate_D}일 지남</span>
	                        		</c:if>
	                        		<!-- 마감일 지난 경우 -->
	                        	</c:if>
	                        </span>
                        </div>
                        <div class="progress-group card-progress">
	                        <span class="progress-title"><span class="percent">${p.completePercent}%</span> 완료</span>
	                        <span class="progress-title float-right"><span>${p.totalProjectCompletedWorkCnt}</span>/<span>${p.totalProjectWorkCnt}</span> 개 업무</span>
	                        <div class="progress progress-sm">
	                            <div class="progress-bar bg-info" style="width: ${p.completePercent}%"></div>
	                        </div>
                        </div>
                    </div>
                    </a>
                </div><!-- /.card -->
            </div>
            </c:forEach>
            
            </div><!-- /.card-content -->
        </section>
        
        <!-- 내가 속한 프로젝트 -->
        <section id="project-in">
            <div class="card-header" role="button" tabindex="0" onclick="toggleList(this);">
            	<h3><i class="fas fa-chevron-down"></i> 내가 속한 프로젝트 <span class="header-count" id="include-count">(${fn:length(listByInclude)})</span></h3>
            </div><!-- /.card-header -->
            <div class="row card-content" id="project-include-content">
            
            <!-- 내 업무 -->
            <div class="col-12 col-sm-6 col-md-3">
                <div class="card card-hover mywork">
                    <a href="${pageContext.request.contextPath}/project/projectView.do?projectNo=${listByInclude[0].projectNo}">
                    <div class="card-body">
                        <!-- 프로필 사진 -->
                        <img src="${pageContext.request.contextPath}/resources/img/profile/${memberLoggedIn.renamedFileName}" alt="User Avatar" class="img-circle img-profile">
                        <!-- 타이틀 -->
                        <div class="card-title text-center"><h5>${listByInclude[0].projectTitle}</h5></div>
                        <!-- 프로젝트 상태  -->
                        <div class="progress-group card-progress">
	                        <span class="progress-title"><span class="percent">${listByInclude[0].completePercent}%</span> 완료</span>
	                        <span class="progress-title float-right"><span>${listByInclude[0].totalProjectCompletedWorkCnt}</span>/<span>${listByInclude[0].totalProjectWorkCnt}</span> 개 업무</span>
	                        <div class="progress progress-sm">
	                            <div class="progress-bar bg-info" style="width: ${listByInclude[0].completePercent}%"></div>
	                        </div>
                        </div>
                    </div>
                    </a>
                </div><!-- /.card -->
            </div>
            
            <!-- 프로젝트 -->
			<c:forEach items="${projectMap.listByInclude}" begin="1" var="p">
            <div class="col-12 col-sm-6 col-md-3">
                <div class="card card-hover">
                <a href="${pageContext.request.contextPath}/project/projectView.do?projectNo=${p.projectNo}">
                <c:if test="${p.projectStarYn=='Y'}">
                    <div class="card-body star-body">
                </c:if>
                <c:if test="${p.projectStarYn=='N'}">
                    <div class="card-body">
                </c:if>
                    <!-- 타이틀 -->
                    <div class="card-title">
                        <h5>${p.projectTitle}</h5>
                    </div>

                    <!-- 중요표시 -->
                    <div class="card-star text-right">
	                    <c:if test="${p.projectStarYn=='Y'}">
                    	<i class="fas fa-star"></i>
	                    </c:if>
	                    
	                    <c:if test="${memberLoggedIn.memberId == p.projectWriter}">
	                    	<c:if test="${p.projectStarYn=='Y'}">
	                    	<span class="line"></span>
                        	<button type="button" class="btn-del-project" value="${p.projectNo},${p.projectTitle}" data-toggle="modal" data-target="#modal-project-remove"><i class="fas fa-times del-project"></i></button>
	                    	</c:if>
	                    	<c:if test="${p.projectStarYn=='N'}">
                        	<button type="button" class="btn-del-project" value="${p.projectNo},${p.projectTitle}" data-toggle="modal" data-target="#modal-project-remove"><i class="fas fa-times del-project no-star"></i></button>
	                    	</c:if>
                        </c:if>
                    </div>

                    <!-- 프로젝트 상태 / 마감일 -->
                    <div class="card-status">
                        <span class="btn btn-block btn-sm bg-${p.projectStatusColor}">${p.projectStatusTitle}</span>
                        <span class="end-date">
                        	<c:set var="now" value="<%= new Date() %>"/>
	                    	<fmt:formatDate var="nowStr" value="${now}" type="date" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseDate var="today" value="${nowStr}" type="date" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseNumber var="today_D" value="${today.time/(1000*60*60*24)}" integerOnly="true"/>
	                    	<fmt:parseDate var="enddate" value="${p.projectEndDate}" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseNumber var="enddate_D" value="${enddate.time/(1000*60*60*24)}" integerOnly="true"/>
	                    	
                        	<!-- 실제완료일이 있는 경우  -->
                        	<c:if test="${p.projectRealEndDate!=null}">
                        	<span class="p-completed"><fmt:formatDate value="${p.projectRealEndDate}" type="date" pattern="MM월 dd일"/>에 완료</span>
                        	</c:if>
                        	<!-- 실제완료일 없고 마감일만 있는 경우 -->
                        	<c:if test="${p.projectRealEndDate==null && p.projectEndDate!=null}">
                        		<!-- 마감일 안 지난 경우 -->
                        		<c:if test="${today_D <= enddate_D}">
	                        	<i class="far fa-calendar-alt"></i> 
	                        	${p.projectEndDate}
                        		</c:if>
                        		<c:if test="${today_D > enddate_D}">
	                        	<span class="p-over">마감일 ${today_D - enddate_D}일 지남</span>
                        		</c:if>
                        		<!-- 마감일 지난 경우 -->
                        	</c:if>
                        </span>
                    </div>
                    <c:if test="${p.projectStarYn=='N'}">
                    <div class="progress-group card-progress star-n">
                    </c:if>
                    <c:if test="${p.projectStarYn=='Y'}">
                    <div class="progress-group card-progress">
                    </c:if>
                        <span class="progress-title"><span class="percent">${p.completePercent}%</span> 완료</span>
                        <span class="progress-title float-right"><span>${p.totalProjectCompletedWorkCnt}</span>/<span>${p.totalProjectWorkCnt}</span> 개 업무</span>
                        <div class="progress progress-sm">
                        <div class="progress-bar bg-info" style="width: ${p.completePercent}%"></div>
                        </div>
                    </div>
                    </div><!-- /.card-body -->
                </a>
                </div><!-- /.card -->
            </div>
            </c:forEach> 
            
            <!-- 새 프로젝트 추가 -->
            <c:if test="${memberLoggedIn.jobTitle eq '팀장'}">
            <div class="col-12 col-sm-6 col-md-3">
                <div class="card addpr-hover add-project" data-toggle="modal" data-target="#add-project-modal">
                <div class="card-body addpr-center">
                    <i class="fa fa-plus" style="font-size:30px;"></i>
                    <h6>새 프로젝트</h6>
                </div>
                </div><!-- /.card -->
            </div>
            </c:if>
            </div><!-- /.card-content -->
        </section>
        </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
