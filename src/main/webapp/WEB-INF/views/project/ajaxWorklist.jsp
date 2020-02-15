<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />

<!-- 업무리스트 -->
<section class="worklist" id="worklist-${wl.worklistNo}">
            <!-- 업무리스트 타이틀 -->
            <div class="worklist-title">
                <h5>${wl.worklistTitle}</h5>
                
                <!-- 업무 생성/업무리스트 삭제: admin, 프로젝트 팀장에게만 보임 -->
                <c:if test="${'admin'==memberLoggedIn.memberId || projectManager==memberLoggedIn.memberId}">
                <div class="worklist-title-btn">
	                <button type="button" class="btn-addWork" value="${wl.worklistNo}"><i class="fas fa-plus"></i></button>
	                <button type="button" class="btn-removeWorklist-modal" value="${wl.worklistNo},${wl.worklistTitle}" data-toggle="modal" data-target="#modal-worklist-remove"><i class="fas fa-times"></i></button>
                </div>
                </c:if>
                
                <!-- 진행 중인 업무 -->
                <div class="worklist-titleInfo-top">
                    <p>진행 중인 업무 ${fn:length(wl.workList)-wl.completedWorkCnt}개</p>
                </div>

                <!-- 새 업무 만들기 -->
                <div class="addWork-wrapper">
	                <form class="addWorkFrm">
	                    <!-- 업무 타이틀 작성 -->
	                    <textarea name="workTitle" class="addWork-textarea" placeholder="새 업무 만들기"></textarea>
	
	                    <!-- 하단부 버튼 모음 -->
	                    <div class="addWork-btnWrapper">
		                    <!-- 업무 설정 -->
		                    <div class="addWork-btnLeft">
		                        <!-- 업무 멤버 배정 -->
		                        <div class="add-member dropdown">
			                        <button type="button" class="nav-link btn-addWorkMember" data-toggle="dropdown"><i class="fas fa-user-plus"></i></button>
			                        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
			                            <c:forEach items="${pMemList}" var="m">
							            <a href="javascript:void(0)" class="dropdown-item drop-memTag ${m.memberId}">
							                <div class="media">
								                <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile">
								                <div class="media-body">
								                    <p class="memberName">${m.memberName}</p>
								                </div>
							                </div>
							            </a>
							            </c:forEach>
		                        	</div>
		                        </div>
		
		                        <!-- 태그 설정 -->
		                        <div class="add-tag dropdown">
			                        <button type="button" class="nav-link btn-addWorkTag" data-toggle="dropdown"><i class="fas fa-tag"></i></button>
			                        <div class="dropdown-menu dropdown-menu-right">
			                            <a href="javascript:void(0)" class="dropdown-item work-tag drop-workTag WT1">
			                            	<span class="btn btn-xs bg-danger WT1">priority</span>
			                            </a>
			                            <a href="javascript:void(0)" class="dropdown-item work-tag drop-workTag WT2">
			                            	<span class="btn btn-xs bg-primary WT2">important</span>
			                            </a>
			                            <a href="javascript:void(0)" class="dropdown-item work-tag drop-workTag WT3">
			                            	<span class="btn btn-xs bg-warning WT3">review</span>
			                            </a>
			                        </div>
		                        </div>
		
		                        <!-- 날짜 설정 -->
		                        <div class="add-date">
			                        <button type="button" class="btn-addWorkDate"><i class="far fa-calendar-alt"></i></button>
			                        <!-- <button type="button" class="btn-cancelDate">2월 12일 - 2월 14일 <i class="fas fa-times"></i></button> -->
		                        </div>
		                    </div>
	
		                    <!-- 취소/만들기 버튼 -->
		                    <div class="addWork-btnRight">
		                        <button type="button" class="btn-addWork-cancel">취소</button>
		                        <button type="button" class="btn-addWork-submit">만들기</button>
		                    </div>
	                    </div>
	                </form>
                </div>

            </div><!-- /.worklist-title -->
            
            <!-- 진행 중인 업무 -->
            <div class="worklist-titleInfo-bottom">
                <button type="button" class="btn-showCompletedWork" value="${wl.worklistNo}">완료된 업무 ${wl.completedWorkCnt}개 보기</button>
            </div>
</section><!-- /.worklist -->