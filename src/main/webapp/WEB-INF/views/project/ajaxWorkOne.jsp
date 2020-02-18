<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />

    <%--      <section class="work-item" role="button" tabindex="0" id="${w.workNo}"> --%>
               	<input type="hidden" id="hiddenworklistTitle" value="${worklistTitle}"/>
               	
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
                <c:if test="${w.workRealEndDate==null}">
                <c:if test="${w.workStartDate!=null}">
                <div class="work-deadline">
                    <p>
                    	<c:if test="${w.workEndDate!=null}">
                    		<fmt:formatDate value="${w.workStartDate}" type="date" pattern="MM월dd일" /> - 
                    		<fmt:formatDate value="${w.workEndDate}" type="date" pattern="MM월dd일" />
                    	</c:if>
                    	<c:if test="${w.workEndDate==null}">
                    		<fmt:formatDate value="${w.workStartDate}" type="date" pattern="MM월dd일" />에 시작
                    	</c:if>
                    </p>
                    <!-- 마감일 있는데 업무 완료되지 않은 경우 -->
                    <c:if test="${w.workEndDate!=null && w.workCompleteYn=='N'}">
                    	<c:set var="now" value="<%= new Date() %>"/>
                    	<fmt:formatDate var="nowStr" value="${now}" type="date" pattern="yyyy-MM-dd"/>
                    	<fmt:parseDate var="today" value="${nowStr}" type="date" pattern="yyyy-MM-dd"/>
                    	<fmt:parseNumber var="today_D" value="${today.time/(1000*60*60*24)}" integerOnly="true"/>
                    	<fmt:parseDate var="enddate" value="${w.workEndDate}" pattern="yyyy-MM-dd"/>
                    	<fmt:parseNumber var="enddate_D" value="${enddate.time/(1000*60*60*24)}" integerOnly="true"/>
                    	
						<c:if test="${today_D > enddate_D}">
							<p class="over">마감일 ${today_D - enddate_D}일 지남</p>
						</c:if>               	
                    </c:if>
                </div><!-- /.work-deadline -->
				</c:if>
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
                    	<span class="ico chklt-cnt">
                    		<i class="far fa-list-alt"></i> 
                    		<span class="chklt-cnt-completed">${chkCnt}</span>/<span class="chklt-cnt-total">${fn:length(w.checklistList)}</span>
                    	</span>
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
                  	 			<img src="${pageContext.request.contextPath}/resources/upload/project/${projectNo}/${w.attachmentList[0].renamedFilename}" class="img-cover" alt="커버이미지">
                  	 		</div>
                  	 		</c:if>
                  	 	</c:if>
                     </c:forTokens>
                </c:if>
