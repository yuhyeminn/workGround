<%@page import="com.kh.workground.project.model.vo.Project"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.kh.workground.member.model.vo.Member"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />

<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<link rel="stylesheet" property="stylesheet" href="${pageContext.request.contextPath}/resources/css/hyemin.css">
<script src="${pageContext.request.contextPath}/resources/js/projectView.js"></script>

<!-- 프로젝트 관리자 -->
<c:set var="pmObj" value=""/>
<c:set var="isprojectManager" value="false"/>
<c:forEach var="pm" items="${project.projectMemberList}">
	<c:if test="${pm.managerYn eq 'Y'}">
		<c:set var="pmObj" value="${pm}"/>
	</c:if>
	<c:if test="${pm.memberId eq memberLoggedIn.memberId }">
		<c:if test="${pm.managerYn eq 'Y'}"><c:set var="isprojectManager" value="true"/></c:if>
	</c:if>
</c:forEach>
<!-- 나의 워크패드인 경우 -->
<c:if test="${project.privateYn=='Y'}">
	<c:set var="isprojectManager" value="true"/>
</c:if>
<input type="hidden" id="hiddenProjectNo" value="${project.projectNo}" />

<script>
//multiselect.js파일에서 사용할 contextPath 전역변수
var contextPath = "${pageContext.request.contextPath}";

function ViewInfo() {};
ViewInfo.prototype.projectNo = ${project.projectNo};
ViewInfo.prototype.privateYn = '${project.privateYn}';
ViewInfo.prototype.memberId = '${memberLoggedIn.memberId}';
ViewInfo.prototype.memberName = '${memberLoggedIn.memberName}';
ViewInfo.prototype.isProjectManager = ${isprojectManager};

$(()=>{
	let info = new ViewInfo();
	
	//푸터 너비 조정
	let width = $('.content').prop('scrollWidth');
	$('.main-footer').css('width', width);
	
	sidebarActive(); //사이드바 활성화
	tabActive(); //서브헤더 탭 활성화
    goTabMenu(info); //서브헤더 탭 링크 이동
    setting(info); //설정창
	
	if('${project.privateYn}'==='N'){
		let info = new ViewInfo();
		projectStar(info); //프로젝트 별 해제/등록
	}
	searchWork(info); //업무검색
	
    addWorklist(info); //새 업무리스트 만들기
    updateWorklistTitle(); //업무리스트 제목 수정
    deleteWorklist(); //업무리스트 삭제하기
    
    addWork(info); //새 업무 만들기
    deleteWork(info); //업무 삭제하기
    workComplete(info); //업무 완료하기
    checklist(info); //체크리스트 완료하기
    openCompletedWork(); //완료된 업무 펼쳐보기
    
    //projectView.js
    updateDesc(); //업무, 프로젝트 설명 수정
    updateTitle(); //업무, 프로젝트 제목 수정
    updateChkChargedMember(); //체크리스트 업무 배정 멤버 변경
	deleteChecklist(); //체크리스트 삭제
	deleteWorkComment(); //업무 코멘트 삭제
	delWorkFile(); //파일 삭제
	updateChklist(); //체크리스트 수정
	
	workCopy();
});

function resetWorklist(worklistNo){
	$.ajax({
		url: '${pageContext.request.contextPath}/project/resetWorklist.do',
		data: {isProjectManager: '${isprojectManager}',projectNo: ${project.projectNo},worklistNo: worklistNo},
		dataType: 'html',
		type: 'POST',
		success: data=>{
			if(data!=null){
				$("#worklist-"+worklistNo).html(data);
			}
		},
		error: (x,s,e) => {
			console.log(x,s,e);
		}
	}); 
}
</script>		

<!-- Navbar Project -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light navbar-project navbar-projectView">
    <!-- Left navbar links -->
    <ul class="navbar-nav">
    
    <!-- 뒤로가기 -->
    <c:if test="${project.privateYn=='N'}">
    <li id="go-back" class="nav-item text-center">
    </c:if>
    <c:if test="${project.privateYn=='Y'}">
    <li id="go-back" class="nav-item text-center private-y">
    </c:if>
        <a class="nav-link" href="${pageContext.request.contextPath}/project/projectList.do"><i class="fas fa-chevron-left"></i></a>
    </li>
    
    <!-- 프로젝트 중요표시, 이름 -->
    <li id="project-name" class="nav-item">
		<input type="hidden" id="hiddenProjectNo" value="${project.projectNo}"/>
        <c:if test="${project.privateYn=='N'}">
        <button type="button" id="btn-star">
        	<c:if test="${project.projectStarYn=='Y'}">
        	<i class="fas fa-star"></i>
        	</c:if>
        	<c:if test="${project.projectStarYn=='N'}">
        	<i class="far fa-star"></i>
        	</c:if>
        </button>
        </c:if> 
        <span id="header-project-title">${project.projectTitle}</span>
    </li>
    </ul>

    <!-- Middle navbar links -->
    <ul id="navbar-tab" class="navbar-nav ml-auto">
        <li id="tab-work" class="nav-item"><button type="button" id="btn-tab-work">업무</button></li>
        <c:if test="${project.privateYn=='N'}">
        <li id="tab-timeline" class="nav-item"><button type="button" id="btn-tab-timeline">타임라인</button></li>
        <li id="tab-analysis" class="nav-item"><button type="button" id="btn-tab-analysis">분석</button></li>
        </c:if>
        <li id="tab-attachment" class="nav-item"><button type="button" id="btn-tab-attach">파일</button></li>
    </ul>
	
    <!-- Right navbar links -->
    <ul id="viewRightNavbar-wrapper" class="navbar-nav ml-auto">
	<c:if test="${project.privateYn=='N'}">
        <!-- 프로젝트 대화 -->
        <li class="nav-item">
            <button type="button" id="btn-openChatting" class="btn btn-block btn-default btn-xs nav-link">
                <i class="far fa-comments"></i> 프로젝트 대화
            </button>
        </li>
	
        <!-- 프로젝트 멤버 -->
        <li id="nav-member" class="nav-item dropdown">
            <a class="nav-link" data-toggle="dropdown" href="#">
                <i class="far fa-user"></i> <span id="nav-member-cnt">${fn:length(inMemList)}</span>
            </a>
            <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right pmember-dropdown">
            <c:forEach items="${inMemList}" var="m">
            <a href="${pageContext.request.contextPath}/member/memberView.do?memberId=${m.memberId}" class="dropdown-item">
                <div class="media">
	                <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile">
	                <div class="media-body">
	                    <p class="memberName">${m.memberName}</p>
	                </div>
                </div>
            </a>
            </c:forEach>
            </div>
        </li>

        <!-- 프로젝트 설정 -->
        <li id="nav-psetting" class="nav-item">
            <button type="button" class="btn btn-block btn-default btn-xs nav-link" id="project-setting-toggle">
            	<i class="fas fa-cog"></i>
            </button>
            <button type="button" class="btn btn-block btn-default btn-xs nav-link" id="btn-projectLog"><i class="fas fa-file-contract"></i></button>
        </li>
    </c:if>
    </ul>
</nav>
<!-- /.navbar -->

<!-- 오른쪽 프로젝트/업무 설정 사이드 바-->
<aside class="work-setting" id="setting-sidebar" style="display: block;">
</aside>

<!-- Content Wrapper. Contains page content -->
<div id="pjv-content-wrapper" class="content-wrapper projectView-wrapper navbar-light">
    <h2 class="sr-only">프로젝트 일정 상세보기</h2>
    <!-- Main content -->
    <div class="content view">
    <h3 class="sr-only">${project.projectTitle}</h3>
    <div class="container-fluid">
        <h4 class="sr-only">업무</h4>
        
        <!-- SEARCH FORM -->
        <form id="workSearchFrm" class="form-inline" onsubmit="return false;">
	        <div class="input-group input-group-sm">
	            <input class="form-control form-control-navbar" name="searchWorkKeyword" type="search" placeholder="업무 검색" aria-label="Search">
	            <div class="input-group-append">
	            <button class="btn btn-navbar" type="button" id="btn-searchWork">
	                <i class="fas fa-search"></i>
	            </button>
	            </div>
	        </div>
        </form>
        
        <div id="wlList-wrapper">
        <!-- 업무리스트 -->
        <c:forEach items="${wlList}" var="wl" varStatus="wlVs">
        <section class="worklist" id="worklist-${wl.worklistNo}">
            <!-- 업무리스트 타이틀 -->
            <div class="worklist-title">
            	<div class="wlTitle-inner">
	                <h5>${wl.worklistTitle}</h5>
	                
	                <!-- 업무 생성/업무리스트 삭제: admin, 프로젝트 팀장에게만 보임 -->
	                <c:if test="${'admin'==memberLoggedIn.memberId || isprojectManager==true}">
	                <div class="worklist-title-btn">
	                	<button type="button" class="btn-showUpdateFrm" value="${wl.worklistNo}"><i class="fas fa-pencil-alt"></i></button>
		                <button type="button" class="btn-addWork" value="${wl.worklistNo}"><i class="fas fa-plus"></i></button>
		                <button type="button" class="btn-removeWorklist-modal" value="${wl.worklistNo},${wl.worklistTitle}" data-toggle="modal" data-target="#modal-worklist-remove"><i class="fas fa-times"></i></button>
	                </div>
	                </c:if>
                </div>
                
                <!-- 업무리스트 타이틀 수정폼 -->
               	<section class="update-wlTitle-wrapper" role="button" tabindex="0">
		            <!-- 타이틀 -->
		            <div class="worklist-title update-wklt">
		                <form claa="updateWlTitleFrm" onsubmit="return false;">
		                    <input type="text" name="newWorklistTitle" required/>
		                    <div class="worklist-title-btn">
		                        <button type="button" class="btn-updateWlTitle" value="${wl.worklistNo}"><i class="fas fa-pencil-alt"></i></button>
		                        <button type="button" class="btn-cancel-updateWlTitle"><i class="fas fa-times"></i></button>
		                    </div>
		                </form>
		                <div class="clear"></div>
		            </div><!-- /.worklist-title -->
		        </section><!-- /.worklist -->
                
                <!-- 새 업무 만들기 -->
                <div class="addWork-wrapper">
	                <form class="addWorkFrm">
	                    <!-- 업무 타이틀 작성 -->
	                    <textarea name="workTitle" class="addWork-textarea" placeholder="새 업무 만들기"></textarea>
	
	                    <!-- 하단부 버튼 모음 -->
	                    <div class="addWork-btnWrapper">
		                    <!-- 업무 설정 -->
		                    <div class="addWork-btnLeft">
		                    	
		                    	<c:if test="${project.privateYn == 'N'}">
		                        <!-- 업무 멤버 배정 -->
		                        <div class="add-member dropdown">
		                        	<span class="badge navbar-badge addMem-badge"></span>
			                        <button type="button" class="nav-link btn-addWorkMember" data-toggle="dropdown"><i class="fas fa-user-plus"></i></button>
			                        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right" id="test-member-ajax">
			                            <c:forEach items="${inMemList}" var="m">
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
		                        </c:if>
		
		                        <!-- 태그 설정 -->
		                        <div class="add-tag dropdown">
		                        	<span class="badge navbar-badge addTag-badge"></span>
			                        <button type="button" class="nav-link btn-addWorkTag" data-toggle="dropdown"><i class="fas fa-tag"></i></button>
			                        <div class="dropdown-menu">
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
		                        </div>
		                    </div>
	
		                    <!-- 취소/만들기 버튼 -->
		                    <div class="addWork-btnRight">
		                        <button type="button" class="btn-addWork-cancel" value="${wl.worklistNo}">취소</button>
		                        <button type="button" class="btn-addWork-submit">만들기</button>
		                    </div>
	                    </div>
	                </form>
                </div>

            	<!-- 진행 중인 업무 -->
                <div class="worklist-titleInfo-top">
                    <p>진행 중인 업무 ${fn:length(wl.workList)-wl.completedWorkCnt}개</p>
                </div>
            </div><!-- /.worklist-title -->
            
            <!-- 업무리스트 컨텐츠 -->
            <div class="worklist-contents">
            	<c:set var="workList" value="${wl.workList}"/>
            	
            	<!-- 진행중인 업무 -->
                <div class="workIng-wrapper">
	            	<c:forEach items="${workList}" var="w" varStatus="wVs">
	            	<c:if test="${w.workCompleteYn=='N'}">
	                <!-- 업무 -->
	                <section class="work-item" role="button" tabindex="0" id="${w.workNo}">
	                	<input type="hidden" id="hiddenworklistTitle" value="${wl.worklistTitle}"/>
	                	
						<!-- 업무배정된 멤버아이디 구하기 -->
						<c:set var="workCharedMemId" value=""/>
						<c:forEach items="${w.workChargedMemberList}" var="m" varStatus="wcmVs">
							<c:set var="workCharedMemId" value="${wcmVs.last?workCharedMemId.concat(m.memberId):workCharedMemId.concat(m.memberId).concat(',')}"/>
						</c:forEach>
	                	<input type="hidden" class="hiddenWorkChargedMemId" value="${workCharedMemId}"/>
						            	
		                <!-- 태그 -->
		                <c:if test="${w.workTagCode!=null}">
		                <div class="work-tag">
		                	<span class="btn btn-xs bg-${w.workTagColor}">${w.workTagTitle}</span>
		                </div>
		                </c:if>
	
		                <!-- 업무 타이틀 -->
		                <div class="work-title">
		                    <h6>
		                    	<button type="button" class="btn-check btn-checkWork" value="${w.workNo}"><i class="far fa-square"></i></button>
		                    	${w.workTitle}
		                    </h6>
		                    <div class="work-importances">
		                    <c:set var="point" value="${w.workPoint}" />
		                    <c:if test="${point>0}">
			                    <c:forEach var="i" begin="1" end="${point}">
			                    <span class="importance-dot checked"></span>
			                    </c:forEach>
			                    <c:forEach var="i" begin="1" end="${5-point}">
			                    <span class="importance-dot"></span>
			                    </c:forEach>
		                    </c:if>
		                    <c:if test="${point==0}">
		                    	<c:forEach var="i" begin="1" end="5">
			                    <span class="importance-dot"></span>
			                    </c:forEach>
		                    </c:if>
		                    </div>
		                </div>
	
		                <div class="work-checklist">
		                <!-- 체크리스트 -->
		                <c:if test="${w.checklistList!=null && !empty w.checklistList}">
		                <c:set var="clList" value="${w.checklistList}" />
		                    <table class="tbl-checklist">
			                    <tbody>
				                	<c:forEach items="${clList}" var="chk">
					                	<c:set var="m" value="${chk.checklistChargedMember}"/>
					                	<!-- 체크리스트 배정된 멤버 구하기 -->
					                    <c:set var="chkChargedMemId" value="${m.memberId}"/>
					                    
					                	<c:if test="${chk.completeYn=='Y'}">
				                        <tr class="completed" id="${chk.checklistNo}">
					                		<th>
					                			<button type="button" class="btn-check" value="${w.workNo},${chk.checklistNo}"><i class="fas fa-check-square"></i></button>
					                			<input type="hidden" class="hiddenChkChargedMemId" value="${chkChargedMemId}"/>	
					                		</th>
					                        <td style="text-decoration:line-through;">
					                    </c:if>
					                    <c:if test="${chk.completeYn=='N'}">
				                        <tr id="${chk.checklistNo}">
				                        	<th>
				                        		<button type="button" class="btn-check" value="${w.workNo},${chk.checklistNo}"><i class="far fa-square"></i></button>
				                        		<input type="hidden" class="hiddenChkChargedMemId" value="${chkChargedMemId}"/>
				                        	</th>
					                        <td>
					                    </c:if>
					                        	<c:if test="${chk.checklistChargedMemberId!=null}">
					                            <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile" title="${m.memberName}">
					                            </c:if>
					                            <span class="checklistContent">${chk.checklistContent}</span>
					                        </td>
				                        </tr>
			                        </c:forEach>
			                    </tbody>
		                    </table>                
						</c:if>
	                	</div><!-- /.work-checklist -->
						
		                <!-- 날짜 설정 -->
		                <div class="work-deadline">
		                <!-- 마감일 없고 시작일만 있는 경우 -->
		                <c:if test="${w.workEndDate==null && w.workStartDate!=null}">
		                	<p>
		                	<fmt:formatDate value="${w.workStartDate}" type="date" pattern="MM월dd일" />에 시작
		                	</p>
		                </c:if>
		                <!-- 마감일 있는 경우 -->
		                <c:if test="${w.workEndDate!=null}">
		                	<c:set var="now" value="<%= new Date() %>"/>
	                    	<fmt:formatDate var="nowStr" value="${now}" type="date" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseDate var="today" value="${nowStr}" type="date" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseNumber var="today_D" value="${today.time/(1000*60*60*24)}" integerOnly="true"/>
	                    	<fmt:parseDate var="enddate" value="${w.workEndDate}" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseNumber var="enddate_D" value="${enddate.time/(1000*60*60*24)}" integerOnly="true"/>
	                    	
		                	<!-- 시작일 있는 경우 -->
		                	<c:if test="${w.workStartDate!=null}">
		                		<p>
			                	<!-- 마감일 안 지난 경우 -->
			                	<c:if test="${today_D < enddate_D}">
			                		<fmt:formatDate value="${w.workStartDate}" type="date" pattern="MM월dd일" /> - 
		                    		<fmt:formatDate value="${w.workEndDate}" type="date" pattern="MM월dd일" />
								</c:if> 
			                	<!-- 마감일 지난 경우 -->
			                	<c:if test="${today_D > enddate_D}">
									<p class="over">마감일 ${today_D - enddate_D}일 지남</p>
								</c:if>      
		                		</p>
		                	</c:if>
		                	
		                	<!-- 시작일 없는 경우 -->
		                	<c:if test="${w.workStartDate==null}">
		                		<p>
			                	<!-- 마감일 안 지난 경우 -->
			                	<c:if test="${today_D < enddate_D}">
			                		<fmt:formatDate value="${w.workEndDate}" type="date" pattern="MM월dd일" />에 마감
								</c:if> 
			                	<!-- 마감일 지난 경우 -->
			                	<c:if test="${today_D > enddate_D}">
									<p class="over">마감일 ${today_D - enddate_D}일 지남</p>
								</c:if>
								</p>
		                	</c:if>
		                </c:if>
		                </div><!-- /.work-deadline -->
		                
						<!-- 완료 체크리스트 수 구하기 -->
						<c:set var="chkCnt" value="0"/>
						<c:forEach items="${w.checklistList}" var="chk">
							<c:if test="${chk.completeYn=='Y'}">
								<c:set var="chkCnt" value="${chkCnt+1}"/>
							</c:if>
						</c:forEach>
						
		                <!-- 기타 아이콘 모음 -->
		                <div class="work-etc">
		                    <!-- 체크리스트/코멘트/첨부파일 수 -->
		                	<c:if test="${fn:length(w.checklistList)==0}">
		                    	<span class="ico"><i class="far fa-list-alt"></i> 0</span>
		                    </c:if>
		                    <c:if test="${fn:length(w.checklistList)>0}">
		                    	<span class="ico chklt-cnt">
		                    		<i class="far fa-list-alt"></i> 
		                    		<span class="chklt-cnt-completed">${chkCnt}</span>/<span class="chklt-cnt-total">${fn:length(w.checklistList)}</span>
		                    	</span>
		                    </c:if>
		                    <span class="ico"><i class="far fa-comment"></i> <span class="comment-cnt">${fn:length(w.workCommentList)}</span></span>
		                    <span class="ico"><i class="fas fa-paperclip"></i> <span class="attach-cnt-total">${fn:length(w.attachmentList)}</span></span>
		                    
		                    <!-- 업무 배정된 멤버 -->
		                    <c:if test="${w.workChargedMemberList!=null && !empty w.workChargedMemberList}">
		                    <div class="chared-member text-right">
		                    <c:forEach items="${w.workChargedMemberList}" var="m">
			                    <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile" title="${m.memberName}">
		                    </c:forEach>
		                    </div>
		                    </c:if>
		                </div>
	
		                <!-- 커버 이미지 -->
		                <c:if test="${w.attachmentList!=null && !empty w.attachmentList}">
			                <c:forTokens items="${fn:toLowerCase(w.attachmentList[0].renamedFilename)}" var="token" delims="." varStatus="vs">
	                        <c:if test="${vs.last}">
	                   	 		<c:if test="${token=='bmp' || token=='jpg' || token=='jpeg' || token=='gif' || token=='png' || token=='tif' || token=='tiff' || token=='jfif'}">
	                   	 		<div class="work-coverImage">
	                   	 			<img src="${pageContext.request.contextPath}/resources/upload/project/${project.projectNo}/${w.attachmentList[0].renamedFilename}" class="img-cover" alt="커버이미지">
	                   	 		</div>
	                   	 		</c:if>
	                   	 	</c:if>
	                        </c:forTokens>
		                </c:if>
		                
	                </section><!-- /.work-item -->
	            	</c:if>	
	                </c:forEach>
                </div><!-- /.workIng-wrapper -->
                
                <!-- 완료된 업무 -->
                <div class="workCompleted-wrapper hide">
                	<c:forEach items="${workList}" var="w" varStatus="wVs">
            		<c:if test="${w.workCompleteYn=='Y'}">
                	<!-- 업무 -->
	                <section class="work-item completed" role="button" tabindex="0" id="${w.workNo}">
	                	<input type="hidden" id="hiddenworklistTitle" value="${wl.worklistTitle}"/>
	                	
						<!-- 업무배정된 멤버아이디 구하기 -->
						<c:set var="workCharedMemId" value=""/>
						<c:forEach items="${w.workChargedMemberList}" var="m" varStatus="wcmVs">
							<c:set var="workCharedMemId" value="${wcmVs.last?workCharedMemId.concat(m.memberId):workCharedMemId.concat(m.memberId).concat(',')}"/>
						</c:forEach>
	                	<input type="hidden" class="hiddenWorkChargedMemId" value="${workCharedMemId}"/>
						            	
		                <!-- 태그 -->
		                <div class="work-tag">
		                <c:if test="${w.workTagCode!=null}">
		                	<span class="btn btn-xs bg-${w.workTagColor}">${w.workTagTitle}</span>
		                </c:if>
		                </div>
	
		                <!-- 업무 타이틀 -->
		                <div class="work-title">
		                    <h6>
		                    	<button type="button" class="btn-check btn-checkWork" value="${w.workNo}"><i class="fas fa-check-square"></i></button>
		                    	${w.workTitle}
		                    </h6>
		                    <div class="work-importances">
		                    <c:set var="point" value="${w.workPoint}" />
		                    <c:if test="${point>0}">
			                    <c:forEach var="i" begin="1" end="${point}">
			                    <span class="importance-dot checked"></span>
			                    </c:forEach>
			                    <c:forEach var="i" begin="1" end="${5-point}">
			                    <span class="importance-dot"></span>
			                    </c:forEach>
		                    </c:if>
		                    <c:if test="${point==0}">
		                    	<c:forEach var="i" begin="1" end="5">
			                    <span class="importance-dot"></span>
			                    </c:forEach>
		                    </c:if>
		                    </div>
		                </div>
	
		                <!-- 체크리스트 -->
		                <c:if test="${w.checklistList!=null && !empty w.checklistList}">
		                <c:set var="clList" value="${w.checklistList}" />
		                <div class="work-checklist">
		                    <table class="tbl-checklist">
			                    <tbody>
				                	<c:forEach items="${clList}" var="chk">
					                	<c:set var="m" value="${chk.checklistChargedMember}"/>
					                	<!-- 체크리스트 배정된 멤버 구하기 -->
					                    <c:set var="chkChargedMemId" value="${m.memberId}"/>
					                    
					                	<c:if test="${chk.completeYn=='Y'}">
				                        <tr class="completed" id="${chk.checklistNo }">
					                		<th>
					                			<button type="button" class="btn-check" value="${w.workNo},${chk.checklistNo}"><i class="fas fa-check-square"></i></button>
					                			<input type="hidden" class="hiddenChkChargedMemId" value="${chkChargedMemId}"/>	
					                		</th>
					                        <td style="text-decoration:line-through;">
					                    </c:if>
					                    <c:if test="${chk.completeYn=='N'}">
				                        <tr id="${chk.checklistNo}">
				                        	<th>
				                        		<button type="button" class="btn-check" value="${w.workNo},${chk.checklistNo}"><i class="far fa-square"></i></button>
				                        		<input type="hidden" class="hiddenChkChargedMemId" value="${chkChargedMemId}"/>
				                        	</th>
					                        <td>
					                    </c:if>
					                        	<c:if test="${chk.checklistChargedMemberId!=null}">
					                            <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile" title="${m.memberName}">
					                            </c:if>
					                            ${chk.checklistContent}
					                        </td>
				                        </tr>
			                        </c:forEach>
			                    </tbody>
		                    </table>                
	                	</div><!-- /.work-checklist -->
						</c:if>
						
		                <!-- 날짜 설정 -->
		                <c:if test="${w.workRealEndDate!=null}">
		                <div class="work-deadline">
		                    <p class="complete"><fmt:formatDate value="${w.workRealEndDate}" type="date" pattern="MM월dd일"/>에 완료</p>
		                </div><!-- /.work-deadline -->
						</c:if>
						
						<!-- 완료 체크리스트 수 구하기 -->
						<c:set var="chkCnt" value="0"/>
						<c:forEach items="${w.checklistList}" var="chk">
							<c:if test="${chk.completeYn=='Y'}">
								<c:set var="chkCnt" value="${chkCnt+1}"/>
							</c:if>
						</c:forEach>
						
		                <!-- 기타 아이콘 모음 -->
		                <div class="work-etc">
		                	<!-- 체크리스트/코멘트/첨부파일 수 -->
		                	<c:if test="${fn:length(w.checklistList)==0}">
		                    	<span class="ico"><i class="far fa-list-alt "></i> 0</span>
		                    </c:if>
		                    <c:if test="${fn:length(w.checklistList)>0}">
		                    	<span class="ico chklt-cnt">
		                    		<i class="far fa-list-alt"></i> 
		                    		<span class="chklt-cnt-completed">${chkCnt}</span>/<span class="chklt-cnt-total">${fn:length(w.checklistList)}</span>
		                    	</span>
		                    </c:if>
		                    <span class="ico"><i class="far fa-comment"></i> <span class="comment-cnt">${fn:length(w.workCommentList)}</span></span>
		                    <span class="ico"><i class="fas fa-paperclip"></i> <span class="attach-cnt">${fn:length(w.attachmentList)}</span></span>
		                    
		                    <!-- 업무 배정된 멤버 -->
		                    <c:if test="${w.workChargedMemberList!=null && !empty w.workChargedMemberList}">
		                    <div class="chared-member text-right">
		                    <c:forEach items="${w.workChargedMemberList}" var="m">
			                    <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile" title="${m.memberName}">
		                    </c:forEach>
		                    </div>
		                    </c:if>
		                </div>
	
		                <!-- 커버 이미지 -->
		                <c:if test="${w.attachmentList!=null && !empty w.attachmentList}">
			                <c:forTokens items="${fn:toLowerCase(w.attachmentList[0].renamedFilename)}" var="token" delims="." varStatus="vs">
	                        <c:if test="${vs.last}">
	                   	 		<c:if test="${token=='bmp' || token=='jpg' || token=='jpeg' || token=='gif' || token=='png' || token=='tif' || token=='tiff' || token=='jfif'}">
	                   	 		<div class="work-coverImage">
	                   	 			<img src="${pageContext.request.contextPath}/resources/upload/project/${project.projectNo}/${w.attachmentList[0].renamedFilename}" class="img-cover" alt="커버이미지">
	                   	 		</div>
	                   	 		</c:if>
	                   	 	</c:if>
	                        </c:forTokens>
		                </c:if>
		                
	                </section><!-- /.work-item -->
                	</c:if>	
                	</c:forEach>
                </div><!-- /.workCompleted-wrapper -->
                
            </div><!-- /.worklist-contents -->
            
            <!-- 진행 중인 업무 -->
            <div class="worklist-titleInfo-bottom">
                <button type="button" class="btn-showCompletedWork" value="${wl.worklistNo}">완료된 업무 ${wl.completedWorkCnt}개 보기</button>
            </div>
        </section><!-- /.worklist -->
        </c:forEach>
        
        
        <!-- 업무리스트 추가: 내워크패드인 경우 / 아닌 경우는 admin, 프로젝트 매니저에게만 보임 -->
        <c:if test="${'Y'==project.privateYn || ('N'==project.privateYn && ('admin'==memberLoggedIn.memberId || isprojectManager==true)) }">
        <section id="add-wklt-wrapper" class="worklist add-worklist" role="button" tabindex="0">
            <!-- 타이틀 -->
            <div class="worklist-title add-wklt">
                <h5><i class="fas fa-plus"></i> 업무리스트 추가</h5>
                <div class="clear"></div>
            </div><!-- /.worklist-title -->
        </section><!-- /.worklist -->
		</c:if>
		
        <!-- 업무리스트 추가 폼 -->
        <section id="add-wkltfrm-wrapper" class="worklist add-worklist" role="button" tabindex="0">
            <!-- 타이틀 -->
            <div class="worklist-title add-wklt">
                <form id="addWorklistFrm" onsubmit="return false;">
                    <input type="text" name="worklistTitle" placeholder="업무리스트 이름" required/>
                    <div class="worklist-title-btn">
                        <button type="button" id="btn-addWorklist" class="btn-addWork">
                            <i class="fas fa-plus"></i>
                        </button>
                        <button type="button" id="btn-cancel-addWorklist" class="btn-removeWorklist">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </form>
                <div class="clear"></div>
            </div><!-- /.worklist-title -->
        </section><!-- /.worklist -->

        <div class="clear"></div>
        
        </div><!-- /.wlList-wrapper -->
        
    </div><!-- /.container-fluid -->
    </div><!-- /.content -->
</div>
<!-- /.content-wrapper -->

<!-- 업무 삭제 드롭다운 -->
<div id="menu-delWork" class="dropdown-menu dropdown-menu-right">
	<a id="dropdown-work-copy" class="dropdown-item dropdown-file-remove" data-toggle="modal" data-target="#modal-work-copy">업무 복사</a>
    <div class="dropdown-divider" style="margin:0;"></div>
	<c:if test="${isprojectManager || memberLoggedIn.memberId eq 'admin'}">
     <a href="#" id="dropdown-work-remove" class="dropdown-item dropdown-file-remove" data-toggle="modal" data-target="#modal-worklist-remove">업무 삭제</a>
	</c:if>
</div>
<!-- </div> -->

<!-- 업무리스트/업무삭제 모달 -->
<div class="modal fade" id="modal-worklist-remove">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            <h4 class="modal-title"><span class="modal-del-target"></span> 삭제</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
            </div>
            <div class="modal-body">
            <p>정말 삭제하시겠습니까? [<span id="modal-del-title"></span>] <span class="modal-del-target"></span>는 영구 삭제됩니다.</p>
            </div>
            <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">아니오, <span class="modal-del-target"></span>를 유지합니다.</button>
            <button type="button" id="btn-removeWorklist" class="btn btn-danger">네</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<!-- 업무 복사 모달 -->
<div class="modal fade" id="modal-work-copy">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
            <h4 class="modal-title">업무 복사</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
            </div>
             <div class="modal-body" style="padding:30px 30px 0px 30px;">
            	<div class="form-group">
                    <label for="myProjectList" class="col-form-label">프로젝트</label>
                    <select class="form-control" id="myProjectList">
                    	<option value="" selected>프로젝트를 선택하세요.</option>
                    </select>
                </div>
            	<div class="form-group">
                    <label for="myProjectWorklist" class="col-form-label">업무 리스트</label>
                    <select class="form-control" id="myProjectWorklist">
                    	<option value="" selected>업무리스트를 선택하세요.</option>
                    </select>
                    <input type="hidden" id="copyWorkNo" />
                </div>
            </div>
            <div class="modal-footer">
            	<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
            	<button type="button" class="btn btn-info" id="work-copy-btn">업무 복사하기</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<!-- 대화창에서 공지 올리기 모달 -->
<!-- 내가 속한 부서의 공지 추가 모달 -->
<!-- 관리자: 전체/부서별 공지 작성 가능 -->
<!-- 부서별: 자기 부서는 selected / 나머지 부서 disabled -->
<div class="modal fade" id="addNoticeForDeptModal" tabindex="-1" role="dialog" aria-labelledby="addNoticeForDeptModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 부서 게시글 작성</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form id="chatNoticeFrm"
      		method="post"
      		enctype="multipart/form-data">
        <div class="modal-body">
          <div class="addNotice" style="padding: 1rem;">
            <div class="form-group">
              <label for="inputDept">부서</label>
              <input type="text" class="form-control" value="${pmObj.deptTitle}" readonly/>
              <input type="hidden" name="deptCode" value="${pmObj.deptCode}" readonly/>
            </div>
            <div class="form-group" style="display:none;">
              <label for="inputWriter">작성자</label>
              <input type="text" name="noticeWriter" value="${memberLoggedIn.memberId}" class="form-control">
            </div>
            <div class="form-group">
              <label for="inputName">게시글 제목</label>
              <input type="text" name="noticeTitle" id="noticeTitle" class="form-control" required>
            </div>
            <div class="form-group">
              <label for="inputDescription">게시글 내용</label>
              <textarea class="textarea" name="noticeContent" id="noticeContent" required></textarea>
            </div>
            <div class="form-group">
              <label for="exampleFormControlFile1">파일 첨부</label>
              <input type="file" class="form-control-file" id="noticeFile" name="upFile">
            </div>
          </div><!-- /.card-body -->
        </div> <!--/.modal-body-->
        <div class="modal-footer">
          <button type="button" class="btn btn-outline-success" id="chatNtc-upload">작성</button>
          <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
        </div>
      </form>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
