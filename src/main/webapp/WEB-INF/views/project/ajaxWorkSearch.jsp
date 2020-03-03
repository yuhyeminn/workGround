<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />

<!-- 프로젝트 관리자 -->
<c:set var="projectManager" value=""/>
<c:set var="pmObj" value=""/>
<c:set var="isprojectManager" value="false"/>
<c:forEach var="pm" items="${project.projectMemberList}">
	<c:if test="${pm.managerYn eq 'Y'}">
		<c:set var="projectManager" value="${projectManager=pm.memberId}" />
		<c:set var="pmObj" value="${pm}"/>
	</c:if>
	<c:if test="${pm.memberId eq memberLoggedIn.memberId }">
		<c:if test="${pm.managerYn eq 'Y'}"><c:set var="isprojectManager" value="true"/> </c:if>
	</c:if>
</c:forEach>
<!-- 나의 워크패드인 경우 -->
<c:if test="${project.privateYn=='Y'}">
	<c:set var="isprojectManager" value="true"/>
</c:if>

<script>
$(function(){
	let btn = document.querySelector("#btn-cancelSearch");
	btn.addEventListener('click', ()=>{
		location.href = '${pageContext.request.contextPath}/project/projectView.do?projectNo=${project.projectNo}';
	});
}());
</script>

		<!-- SEARCH FORM -->
        <form id="workSearchFrm" class="form-inline" onsubmit="return false;">
	        <div class="input-group input-group-sm">
	            <input class="form-control form-control-navbar" name="searchWorkKeyword" type="search" placeholder="업무 검색" value="${keywordBefore}" aria-label="Search">
	            <div class="input-group-append">
	            <button class="btn btn-navbar" type="button" id="btn-searchWork">
	                <i class="fas fa-search"></i>
	            </button>
	            </div>
	        </div>
	        <button type="button" id="btn-cancelSearch"><i class="fas fa-window-close"></i></button>
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
	                <c:if test="${'admin'==memberLoggedIn.memberId || isProjectManager==true}">
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
		                    
		                    	<c:if test="${project.privateYn == 'N'}">
		                        <!-- 업무 멤버 배정 -->
		                        <div class="add-member dropdown">
		                        	<span class="badge navbar-badge addMem-badge"></span>
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
		                        </c:if>
		
		                        <!-- 태그 설정 -->
		                        <div class="add-tag dropdown">
		                        	<span class="badge navbar-badge addTag-badge"></span>
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
	
		                <!-- 체크리스트 -->
		                <div class="work-checklist">
		                <c:if test="${w.checklistList!=null && !empty w.checklistList}">
		                <c:set var="clList" value="${w.checklistList}" />
		                    <table class="tbl-checklist">
			                    <tbody>
				                	<c:forEach items="${clList}" var="chk">
					                	<c:set var="m" value="${chk.checklistChargedMember}"/>
					                	<!-- 체크리스트 배정된 멤버 구하기 -->
					                    <c:set var="chkChargedMemId" value="${m.memberId}"/>
					                    
					                	<c:if test="${chk.completeYn=='Y'}">
				                        <tr class="completed">
					                		<th>
					                			<button type="button" class="btn-check" value="${w.workNo},${chk.checklistNo}"><i class="fas fa-check-square"></i></button>
					                			<input type="hidden" class="hiddenChkChargedMemId" value="${chkChargedMemId}"/>	
					                		</th>
					                        <td style="text-decoration:line-through;">
					                    </c:if>
					                    <c:if test="${chk.completeYn=='N'}">
				                        <tr>
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
		                    	<span class="ico"><i class="far fa-list-alt"></i> ${chkCnt}/${fn:length(w.checklistList)}</span>
		                    </c:if>
		                    <span class="ico"><i class="far fa-comment"></i> ${fn:length(w.workCommentList)}</span>
		                    <span class="ico"><i class="fas fa-paperclip"></i> ${fn:length(w.attachmentList)}</span>
		                    
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
		                <c:if test="${w.workTagCode!=null}">
		                <div class="work-tag">
		                	<span class="btn btn-xs bg-${w.workTagColor}">${w.workTagTitle}</span>
		                </div>
		                </c:if>
	
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
				                        <tr class="completed">
					                		<th>
					                			<button type="button" class="btn-check" value="${w.workNo},${chk.checklistNo}"><i class="fas fa-check-square"></i></button>
					                			<input type="hidden" class="hiddenChkChargedMemId" value="${chkChargedMemId}"/>	
					                		</th>
					                        <td style="text-decoration:line-through;">
					                    </c:if>
					                    <c:if test="${chk.completeYn=='N'}">
				                        <tr>
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
		                    	<span class="ico"><i class="far fa-list-alt"></i> 0</span>
		                    </c:if>
		                    <c:if test="${fn:length(w.checklistList)>0}">
		                    	<span class="ico"><i class="far fa-list-alt"></i> ${chkCnt}/${fn:length(w.checklistList)}</span>
		                    </c:if>
		                    <span class="ico"><i class="far fa-comment"></i> ${fn:length(w.workCommentList)}</span>
		                    <span class="ico"><i class="fas fa-paperclip"></i> ${fn:length(w.attachmentList)}</span>
		                    
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
<c:if test="${'Y'==project.privateYn || ('N'==project.privateYn && ('admin'==memberLoggedIn.memberId || isProjectManager==true)) }">
<section id="add-wklt-wrapper" class="worklist add-worklist" role="button" tabindex="0">
    <!-- 타이틀 -->
    <div class="worklist-title">
        <h5><i class="fas fa-plus"></i> 업무리스트 추가</h5>
        <div class="clear"></div>
    </div><!-- /.worklist-title -->
</section><!-- /.worklist -->
</c:if>
		
<!-- 업무리스트 추가 폼 -->
<section id="add-wkltfrm-wrapper" class="worklist add-worklist" role="button" tabindex="0">
    <!-- 타이틀 -->
    <div class="worklist-title">
        <form id="addWorklistFrm">
        	<input type="hidden" name="projectNo" value="${project.projectNo}" required/>
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