<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<style>
.e-input-group:not(.e-float-icon-left), .e-input-group.e-success:not(.e-float-icon-left), .e-input-group.e-warning:not(.e-float-icon-left), .e-input-group.e-error:not(.e-float-icon-left), .e-input-group.e-control-wrapper:not(.e-float-icon-left), .e-input-group.e-control-wrapper.e-success:not(.e-float-icon-left), .e-input-group.e-control-wrapper.e-warning:not(.e-float-icon-left), .e-input-group.e-control-wrapper.e-error:not(.e-float-icon-left) {
    border: none;
}
.update-chk-charge{cursor:pointer}
</style>
<!-- 프로젝트 관리자 확인 -->
<c:set var="projectManager" value=""/>
<c:set var="isprojectManager" value="false"/>
<c:forEach var="pm" items="${project.projectMemberList}">
	<c:if test="${pm.managerYn eq 'Y'}">
		<c:set var="projectManager" value="${pm.memberId}" />
	</c:if>
	<c:if test="${pm.memberId eq memberLoggedIn.memberId }">
		<c:if test="${pm.managerYn eq 'Y'}"><c:set var="isprojectManager" value="true"/> </c:if>
	</c:if>
</c:forEach>

<!-- 현재 로그인 한 회원이 업무에 배정되어있는 멤버인지 확인 -->
<c:set var="isChargedMember" value="false" />
<c:forEach var="wcm" items="${work.workChargedMemberList}">
	<c:if test="${memberLoggedIn.memberId eq wcm.memberId}">
		<c:set var="isChargedMember" value="true" />
	</c:if>
</c:forEach>
					      
<!-- 현재 로그인 한 회원이 프로젝트 멤버인지 확인 -->
<c:set var="isProjectMember" value="false" />
<c:forEach var="pm" items="${project.projectMemberList}">
	<c:if test="${memberLoggedIn.memberId eq pm.memberId}">
		<c:set var="isProjectMember" value="true" />
	</c:if>
</c:forEach>

<!-- 날짜 유효성 검사를 위한 프로젝트 시작일 -->
<input type="hidden" id="hiddenProjectStartDate" value="${project.projectStartDate}" />
<input type="hidden" id="settingWorkNo" value="${work.workNo}" />
<input type="hidden" id="settingProjectNo" value="${project.projectNo}" />

<section id="${work.workNo }" style="height:100%;overflow-y:scroll">
	<!-- 업무배정된 멤버아이디 구하기 -->
	<c:set var="workCharedMemId" value=""/>
	<c:forEach items="${work.workChargedMemberList}" var="m" varStatus="wcmVs">
	<c:set var="workCharedMemId" value="${wcmVs.last?workCharedMemId.concat(m.memberId):workCharedMemId.concat(m.memberId).concat(',')}"/>
	</c:forEach>
	<input type="hidden" class="hiddenWorkChargedMemId" value="${workCharedMemId}"/>
	
	<div class="div-close" role="button" tabindex="0">
    	<i class="fas fa-times close-sidebar"></i>
    </div>
    <!-- Control sidebar content goes here -->
    <div class="side-header">
    <div class="p-3">
    <c:if test="${ work.workCompleteYn eq 'Y'}">
    	<p style="font-size:12px;text-align:center;background:#f3f4f5">
    		<i class="far fa-calendar-alt" style="width:20px;margin-bottom: 5px;"></i><span>완료됨 : </span><span>${work.workRealEndDate }</span>
    	</p>
    </c:if>
    	<c:if test="${isprojectManager || memberLoggedIn.memberId eq 'admin' || isChargedMember}">
		    <p class="setting-side-title update-side-title">
		    ${work.workTitle}
		      <button class="update-title"><i class="fas fa-pencil-alt"></i></button>
		    </p>
		    <p class="setting-side-title edit-side-title">
		   	  <input type="text" value="${work.workTitle}" placeholder="업무 제목을 입력하세요." id="title"/>
		      <button class="update-title-btn wr-title" id="${work.workNo }"><i class="fas fa-pencil-alt"></i></button>
		    </p>
	    </c:if>
	    <c:if test="${!isprojectManager && memberLoggedIn.memberId ne 'admin' && !isChargedMember}">
		    <p class="setting-side-title">
		    ${work.workTitle}
		    </p>
	    </c:if>
    <p class="setting-contents-inform">
        <span>#${work.workNo }</span>
        <span class="setting-contents-date">작성일 ${work.workStartDate }</span>
    </p>
    </div>
    
    <ul class="nav work-setting-tabs setting-tabs nav-tabs" id="work-setting-tabs" role="tablist">
        <li class="nav-item setting-navbar-tab">
        <button type="button" class="nav-link active" id="custom-content-work-setting-tab" data-toggle="pill" href="#custom-content-work-setting" role="tab" aria-controls="custom-content-work-setting" aria-selected="true">속성</button>
        </li>
        <li class="nav-item setting-navbar-tab">
        <button type="button" class="nav-link" id="custom-content-above-comment-tab" data-toggle="pill" href="#custom-content-above-comment" role="tab" aria-controls="custom-content-above-comment" aria-selected="false">코멘트</button>
        </li>
        <li class="nav-item setting-navbar-tab">
        <button type="button" class="nav-link" id="custom-content-above-file-tab" data-toggle="pill" href="#custom-content-above-file" role="tab" aria-controls="custom-content-file-comment" aria-selected="false">파일</button>
        </li>
    </ul>
    </div>
    <div class="tab-content" id="custom-content-above-tabContent">
        <!-- 업무 속성 탭-->
        <div class="tab-pane fade show active p-setting-container" id="custom-content-work-setting" role="tabpanel" aria-labelledby="custom-content-work-setting-tab">
           		<!-- 권한 있을 때 -->
            	<c:if test="${isprojectManager || memberLoggedIn.memberId eq 'admin' || isChargedMember}">
            	  <c:if test="${work.workDesc == null or work.workDesc == ''}">
			            <div class="row setting-row add-description">
			            	<span>설명 추가</span>
			            </div>
		          </c:if>
		          <c:if test="${work.workDesc != null and work.workDesc != ''}">
			            <div class="row setting-row add-description">
			            	<span style='color:#696f7a'>${work.workDesc }</span>
			            </div>
		          </c:if>
		          		<div class="row setting-row edit-description">
			            	<input type="text" value="${work.workDesc}" placeholder="업무 설명을 입력하세요." id="desc"/>
			            	<button class="update-description wr-desc" id="${work.workNo }"><i class="fas fa-pencil-alt"></i></button>
			            </div>
	           	</c:if>
	           	<!-- 권한 없을 때 -->
	           	<c:if test="${!isprojectManager && memberLoggedIn.memberId ne 'admin' && !isChargedMember}">
	           	  <c:if test="${work.workDesc == null or work.workDesc == ''}">
			             <div class="row setting-row work-description">
			            	<span>설명 없음</span>
			             </div>
		          </c:if>
		           <c:if test="${work.workDesc != null and work.workDesc != ''}">
			            <div class="row setting-row work-description">
			            	<span>${work.workDesc }</span>
			            </div>
		          </c:if>
	           	</c:if>
            <hr/>
            
            <div class="setting-row">
            <!-- 업무 위치 -->
            <div class="row">
                <label class="setting-content-label"><span class="label-icon"><i class='far fa-folder-open' style="width:20px;"></i></span> 위치</label>
                
                <!-- plus 버튼 눌렀을 때 dropdown-->
                <div class="add-member-left dropdown">
                	<c:if test="${isprojectManager || memberLoggedIn.memberId eq 'admin' || isChargedMember}">
                   		 <button class="setting-icon" data-toggle="dropdown"><i class="fas fa-pencil-alt"></i></button>
                    </c:if>
                    <div class="dropdown-menu location-dropdown"  aria-labelledby="dropdownMenuLink">
                    <span>업무리스트</span> 
                    <div class="dropdown-divider"></div>
                    <c:if test="${project.worklistList!=null and !empty project.worklistList }">
	                    <c:forEach var="worklist" items="${project.worklistList }">
		                    <a class="dropdown-item work-location" tabindex="-1" id="${worklist.worklistNo}">${worklist.worklistTitle }</a>
	                    </c:forEach>
                    </c:if>
                    </div>
                    
                </div>
                        <p class="setting-content-inform">
                            <span>${project.projectTitle }</span> <i class="fa fa-angle-double-right"></i> <span id="current-worklist">${worklistTitle }</span>
                        </p>
            </div>
            <!-- 시작일 -->
            <div class="row">
                <label class="setting-content-label"><span><i class="far fa-calendar-alt" style="width:20px;"></i></span> 시작일</label>
                <div class="dropdown">
                   <c:if test="${isprojectManager || memberLoggedIn.memberId eq 'admin' || isChargedMember}">
                     <button class="setting-icon" data-toggle="dropdown"><i class="fas fa-cog"></i></button>
                   </c:if>
                    <div class="dropdown-menu setting-date-dropdown">
                        <div class="form-group">
                        <div class="input-group" >
                            <input type="text" class="form-control float-right" id="work_startdate" data-provide='datepicker' value="${work.workStartDate}"> 
                            <input type="hidden" id="workStartDate"  value="${work.workStartDate}"> 
                        </div>
                        </div>
                        <button class="btn bg-info date-update" type="button">수정</button>
                        <button class="btn bg-secondary date-update date-cancel">없음</button>
                </div>
                </div>
                    <c:if test="${work.workStartDate != null and work.workStartDate != '' }">
                     <p class="setting-content-inform">
	                      <fmt:formatDate value="${work.workStartDate}" type="date" pattern="MM월 dd일" />
                     </p>
                    </c:if>
            </div>
            
            <!-- 마감일 -->
			<div class="row">
                <label class="setting-content-label"><span><i class="far fa-calendar-alt" style="width:20px;"></i></span> 마감일</label>
                <div class="dropdown">
                   <c:if test="${isprojectManager || memberLoggedIn.memberId eq 'admin' || isChargedMember}">
                     <button class="setting-icon" data-toggle="dropdown"><i class="fas fa-cog"></i></button>
                   </c:if>
                   <div class="dropdown-menu setting-date-dropdown">
                        <div class="form-group">
	                        <div class="input-group">
	                            <input type="text" class="form-control float-right" id="work_enddate" data-provide='datepicker' value="${work.workEndDate}"> 
	                        	<input type="hidden" id="workEndDate"  value="${work.workEndDate}"> 
	                        </div>
                        </div>
                        <button class="btn bg-info date-update">수정</button>
                        <button class="btn bg-secondary date-update date-cancel">없음</button>
                	</div>
                </div>
                    <c:if test="${work.workEndDate != null and work.workEndDate != '' }">
                     <p class="setting-content-inform">
	                        <fmt:formatDate value="${work.workEndDate}" type="date" pattern="MM월 dd일" /> 
                     </p>
                    </c:if>
            </div>
            <!-- 배정된 멤버-->
            <c:if test="${project.privateYn=='N'}">
            <div class="row">
                <label class="setting-content-label"><span><i class='fas fa-user-plus' style="width:20px;"></i></span> 배정된 멤버</label>
                <div class='control-wrapper pv-multiselect-box'>
                    <div class="control-styles">
                        <input type="text" tabindex="1" id='workMember' name="workMember"/>
                        <c:if test="${isprojectManager || memberLoggedIn.memberId eq 'admin' }">
		               		<button type="button" class="sign-out-project" id="updateWorkMember">배정된 멤버 수정</button>
		            	</c:if>
                </div>
                </div>
            </div>
            </c:if>
            <!-- 태그 -->
            <div class="row">
                <label class="setting-content-label"><span><i class="fa fa-tag" style="width:20px;"></i></span> 태그</label>
                <c:if test="${isprojectManager || memberLoggedIn.memberId eq 'admin' || isChargedMember}">
                	<button class="setting-icon" data-toggle="dropdown"><i class="fa fa-plus"></i></button>
                </c:if>
                <div class="work-tag" id="current-workTag">
                	<c:if test="${work.workTagTitle != null and work.workTagTitle != ''}">
                    	<span class="btn btn-xs bg-${work.workTagColor}">${work.workTagTitle }</span>
                    </c:if>
                </div>
                <div class="dropdown-menu work-setting-tag">
                    <a class="dropdown-item update-work-tag" tabindex="-1" id="WT1"><span class="btn btn-xs bg-danger">priority</span></a>
                    <a class="dropdown-item update-work-tag" tabindex="-1" id="WT2"><span class="btn btn-xs bg-primary">important</span></a>
                    <a class="dropdown-item update-work-tag" tabindex="-1" id="WT3"><span class="btn btn-xs bg-warning">review</span></a>
                    <a class="dropdown-item update-work-tag" tabindex="-1" id=""><span class="btn btn-xs bg-secondary">태그없음</span></a>
                </div>
            </div>
            </div>
            <!-- 업무 포인트(중요도) -->
            <div class="row setting-row setting-point">
                <label class="setting-content-label"> <span><i class='fas fa-ellipsis-h' style="width:20px;"></i></span> 포인트</label>
                <div class="dropdown status-dropdown">
                    <button id="current-work-point">
                        <c:set var="point" value="${work.workPoint}" />
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
                    </button>
                    <c:if test="${isprojectManager || memberLoggedIn.memberId eq 'admin' || isChargedMember}">
	                    <div class="icon-box"  data-toggle="dropdown">
	                    <i class="fa fa-angle-down"></i>
	                    </div>
                	</c:if>
                    
                    <div class="dropdown-menu">
	                    <a class="dropdown-item work-importances" tabindex="-1" id="1">
	                        <span class="importance-dot checked"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span>
	                    </a>
	                    <a class="dropdown-item work-importances" tabindex="-1" id="2">
	                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span>
	                    </a>
	                    <a class="dropdown-item work-importances" tabindex="-1" id="3">
	                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot"></span> <span class="importance-dot"></span>
	                    </a>
	                    <a class="dropdown-item work-importances" tabindex="-1" id="4">
	                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot"></span>
	                    </a>
	                    <a class="dropdown-item work-importances" tabindex="-1" id="5">
	                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span>
	                    </a>
	                    <a class="dropdown-item work-importances" tabindex="-1" id="0">
	                        <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span>
	                    </a>
                    </div>
                </div>
            </div>
            <!-- 체크리스트 -->
            <div class="row setting-row checklist-box-row">
            
              <div class="work-checklist">
                <table class="tbl-checklist" style="border:none;">
                <tbody>
                <c:if test="${work.checklistList!=null && !empty work.checklistList}">
                 <c:forEach items="${work.checklistList}" var="chk">
                 <c:set var="m" value="${chk.checklistChargedMember}"/>
                    <c:if test="${chk.completeYn=='Y'}">
			              <tr class="completed" id="${chk.checklistNo}">
				             <th>
				             <button type="button" class="btn-check" value="${work.workNo},${chk.checklistNo}"><i class="fas fa-check-square"></i></button>         
				             <input type="hidden" class="hiddenChkChargedMemId" value="${m.memberId}"/>
				             </th>
				                <td style="text-decoration:line-through;width:100%">
			        </c:if>
                    <c:if test="${chk.completeYn=='N'}">
			           <tr id="${chk.checklistNo}">
			             <th>
			             <button type="button" class="btn-check" value="${work.workNo},${chk.checklistNo}"><i class="far fa-square"></i></button>               
			             <input type="hidden" class="hiddenChkChargedMemId" value="${m.memberId}"/>
			             </th>
				            <td style="width:100%">
				    </c:if>        
				               <c:if test="${chk.checklistChargedMemberId!=null}">
				                 <img src="${pageContext.request.contextPath}/resources/img/profile/default.jpg" data-toggle="dropdown" alt="User Avatar" class="img-circle img-profile ico-profile update-chk-charge" title="${m.memberName}">
				               </c:if>
				               <c:if test="${chk.checklistChargedMemberId==null}">
				               	<div class="img-circle img-profile ico-profile update-chk-charge" data-toggle="dropdown" ><i class='fas fa-user-plus' style="width:15px;margin-top: 5px;"></i></div>
				               </c:if>
				               <span class="checklistContent">${chk.checklistContent}</span>
				               <input type="text" class="currentChecklistContent" value="${chk.checklistContent}" style="display:none;width:80%;"/>
				               
				               <div class="dropdown-menu dropdown-menu" >
				               		<c:if test="${work.workChargedMemberList != null and !empty work.workChargedMemberList }">
								    <c:forEach items="${work.workChargedMemberList}" var="m">
								         <div class="media dropdown-item chk-charge-member" id="${m.memberId}" >
									         <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile">
									         <div class="media-body">
									             <p class="memberName">${m.memberName}</p>
									         </div>
								         </div>
								    </c:forEach>
								     
								    	<div class="dropdown-item chk-charge-member del-chk-charge-member" id="" <c:if test="${chk.checklistChargedMemberId==null}">style="display:none"</c:if>>
									         <p style="color:red;font-size:14px;">배정 멤버 삭제</p>
								        </div>
								        
								    </c:if>
								    <c:if test="${work.workChargedMemberList == null or empty work.workChargedMemberList }">
								    	<span style="margin-left:10px;">없음</span>
								    </c:if>
								</div>
								<c:if test="${chk.checklistChargedMemberId eq memberLoggedIn.memberId || isprojectManager || memberLoggedIn.memberId eq 'admin' || isChargedMember}">
								 <button class="delete-checklist" id="${chk.checklistNo}" style="float:right;"><i class="fas fa-times"></i></button>
								 <button class="edit-checklist" id="${chk.checklistNo}" style="float:right;"><i class="fas fa-pencil-alt"></i></button>
								</c:if>
				         	</td>
			           </tr>
                  </c:forEach>
                  </c:if>
                  <c:if test="${isprojectManager || memberLoggedIn.memberId eq 'admin' || isChargedMember}">
	                    <tr id="chk-add-tr">
	                    <th><button type="button" class="btn-add-checklist"><i class="fa fa-plus"></i></button></th>
	                    <td>
	                        <input type="text" name="checklist-content" id="checklist-content" placeholder="체크리스트 아이템 추가하기">
	                    </td>
	                    </tr>
                </c:if>
                </tbody>
                <tfoot>
                
                </tfoot>
                </table>                
              </div>
            
            </div>
        </div><!--/end 업무 속성 탭-->

        <!-- #####################################################코멘트 탭-->
        <div class="tab-pane fade" id="custom-content-above-comment" role="tabpanel" aria-labelledby="custom-content-above-comment-tab">
        <div class="comment-wrapper">
            <div class="comment-box work-comment-box">
            <c:if test="${work.workCommentList!=null && !empty work.workCommentList}">
            <div class="card-footer card-comments work-comments-box">
            
              <c:forEach items="${work.workCommentList}" var="wc">
              <c:set var="writer" value="${wc.workCommentWriterMember}" />
              
              <c:if test="${wc.workCommentLevel == 2 }"> 
              	<div class="card-comment comment-level2 work-ref-${wc.workCommentRef}" id="${wc.workCommentNo}">
              </c:if>
              <c:if test="${wc.workCommentLevel == 1 }">
              	<div class="card-comment work-comment" id="${wc.workCommentNo}">
              </c:if>
                
                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${writer.renamedFileName}" alt="User Image">
                <div class="comment-text">
                    <span class="username"><span class="comment-writer">${writer.memberName}</span><span class="text-muted float-right">${wc.workCommentEnrollDate }</span></span>
                    <div style="word-wrap:break-word;"><span class="comment-content">${wc.workCommentContent}</span></div>
                    <c:if test="${memberLoggedIn.memberId eq writer.memberId || memberLoggedIn.memberId eq project.projectWriter || memberLoggedIn.memberId eq 'admin'}">
                    <button class="comment-delete work-comment-delete float-right" value="${wc.workCommentNo}">삭제</button>
                    </c:if>
                    <c:if test="${memberLoggedIn.memberId eq 'adim' || isProjectMember}">
                    <c:if test="${wc.workCommentLevel == 1 }">
                      <button class="comment-reply work-comment-reply float-right" value="${wc.workCommentNo}">답글</button>
                    </c:if>
                    </c:if>
                </div>
                </div>
              </c:forEach>
            </div>
            </c:if>
            <c:if test="${work.workCommentList==null || empty work.workCommentList}">
           		<div id="null-comment-box" style="text-align:center;margin-top: 106px;">
	           		<img src="https://d30795irbdecem.cloudfront.net/assets/comment-empty-state@2x-d1554722.png" style="width:20rem;">
	           		<p style="font-size:10px; color:lightgray;">Comments are great for focusing conversation on the task at hand.</p>
           		</div>
            </c:if>
            </div>
            <!-- 댓글 작성 -->
            <div class="card-footer enroll-comment">
            	<div class="reply-work-ref-wrapper">
	            	<i class="fa fa-reply fa-flip-horizontal"></i>
	                <div class="reply-work-ref">
	                	<button class="cancel-comment-ref" style="float:right;color:#696f7a;"><i class="fas fa-times"></i></button>
	                	<span class="reply-work-ref-writer"></span>
	                	<span class="reply-work-ref-content"></span>
	                </div>
             	</div>
             <div class="enroll-comment-inform">
                <img class="img-fluid img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${memberLoggedIn.renamedFileName}">
                <div class="img-push">
                <textarea class="form-control form-control-sm comment-text-area" id=""  placeholder="코멘트를 입력하세요."></textarea>
                <input type="hidden" id="comment-writer" value="${memberLoggedIn.memberId}"/>
                <input type="hidden" id="comment-level" value="1"/>
                <input type="hidden" id="comment-ref" value="" />
                <button class="comment-submit">등록</button>
                </div>
              </div>
            </div> 
        </div> 
        <!--/. end comment-wrapper--> 
        </div>
        <!--/. end 코멘트 tab-->


        <!-- #########################################################파일 탭 -->
        <div class="tab-pane fade file-tab-pane " id="custom-content-above-file" role="tabpanel" aria-labelledby="custom-content-above-file-tab">
            <div class="file-wrapper">
            <div class="container-fluid"> 
                <!-- 파일 첨부 -->
                <form id="workFileForm" method="post" enctype="multipart/form-data">
                <div class="input-group work-file-upload-box">
                	<input type="hidden" name="projectNo" value="${project.projectNo }" />
                	<input type="hidden" name="workNo" value="${work.workNo }" />
                	<input type="hidden" name="memberId" value="${memberLoggedIn.memberId}" />
                    <div class="custom-file work-custom-file">
                    <input type="file" class="custom-file-input" id="workInputFile" name="workFile" aria-describedby="inputGroupFileAddon04">
                    <label class="custom-file-label" for="inputGroupFile04">파일을 선택하세요.</label>
                    </div>
                    <div class="input-group-append">
                    <button class="btn btn-outline-secondary" type="button" id="upload-file-btn" style="font-size:12px;">파일 첨부</button>
                    </div>
                </div>
                </form>
                <!-- 첨부파일 테이블 -->
            <div id="card-projectAttach" class="table-responsive p-0">
            <table id="tbl-projectAttach" class="table table-hover text-nowrap work-attachment-tbl">
                <thead>
                    <tr>
                        <th style="width:42%;">이름</th>
                        <th style="width:23%;">공유한 날짜</th>
                        <th style="width:30%;">공유한 사람</th>
                    </tr>
                </thead>
                <tbody>
                <c:if test="${work.attachmentList!=null && !empty work.attachmentList}">
                  <c:forEach items="${work.attachmentList}" var="a">
                    <tr id="${a.attachmentNo}">
                     <input type="hidden" class="oName" value="${a.originalFilename}" />
                     <input type="hidden" class="rName" value="${a.renamedFilename}" />
                     <td>
                             <div class="img-wrapper">
                             	 <c:forTokens items="${fn:toLowerCase(a.renamedFilename)}" var="token" delims="." varStatus="vs">
                             	 <c:if test="${vs.last}">
                             	 	<c:choose>
                             	 		<c:when test="${token=='bmp' || token=='jpg' || token=='jpeg' || token=='gif' || token=='png' || token=='tif' || token=='tiff' || token=='jfif'}">
			                                 <img src="${pageContext.request.contextPath}/resources/upload/project/${project.projectNo}/${a.renamedFilename}" alt="첨부파일 미리보기 이미지">
                             	 		</c:when>
                             	 		<c:when test="${token!='bmp' && token!='jpg' && token!='jpeg' && token!='gif' && token!='png' && token!='tif' && token!='tiff' && token!='jfif'}">
			                                 <img src="${pageContext.request.contextPath}/resources/img/project/default-file.png" alt="첨부파일 미리보기 이미지">
                             	 		</c:when>
                             	 	</c:choose>
                             	 </c:if>
                             	 </c:forTokens>
                             </div>
                             <div class="imgInfo-wrapper">
                                 <p class="filename">${a.originalFilename}</p>
                             </div>
                     </td>
                     <td>${a.attachmentEnrollDate}</td>
                     <td>
                        <span>${a.attachmentWriterMember.memberName}</span>
                         <!-- 첨부파일 옵션 버튼 -->
                         <div class="dropdown ">
                             <button type="button" class="btn-file" data-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></button>
                             <div class="dropdown-menu dropdown-menu-right">
                                 <button type="button" class="dropdown-item btn-work-file-down" value="${a.attachmentNo}">다운로드</button>
                                 
                                 <!-- 파일삭제: 관리자, 프로젝트 팀장, 공유한 사람만 가능 -->
                                 <c:if test="${'admin'==memberLoggedIn.memberId || projectManager==memberLoggedIn.memberId || a.attachmentWriterMember.memberId==memberLoggedIn.memberId}">
                                 <div class="dropdown-divider"></div>
                                 <button type="button" class="dropdown-item work-file-remove" value="${a.attachmentNo},${a.renamedFilename}" data-toggle="modal" data-target="#modal-file-remove">삭제</button>
                                 </c:if>
                             </div>
                         </div>
                     </td>
                    </tr>
                    </c:forEach>
		    </c:if>
		    <c:if test="${work.attachmentList==null || empty work.attachmentList}">
		    <tr id="no-exist-file" style="text-align:center;">
		    	<td colspan="3" style="padding:1rem;">파일이 존재하지 않습니다.</td>
            </tr>
		    </c:if>
          </tbody>
    </table>
</div>
                
                
                <!-- /.card -->
                </div>
                <!-- /.container-fluid -->
            </div> 
            <!--/. end file-wrapper--> 
            </div>
    </div>
    </section>	
 <script>

 $(()=>{
	var workNo = '${work.workNo}';
	var projectNo = '${project.projectNo}';
	workMember(workNo,projectNo);
	sideClose();
	workDatePicker();
	updateWorkDate();
	updateWorkMember();
	updateWorkTag();
	updateWorkPoint();
	insertCheckList();
	updateWorkLocation();
	/* updateChkChargedMember(); */
	/* deleteChecklist(); */
	insertWorkComment();
	/* deleteWorkComment(); */
	uploadWorkFile();
	downloadWorkFile();
	/* delWorkFile(); */
 });
 
 
 function workDatePicker(){
	 $("#work_startdate").daterangepicker({
		    singleDatePicker: true,
		    showDropdowns: true,
		    locale: {
			    format: 'YYYY-MM-DD',
			    cancelLabel: 'Clear'
		    }
	});
	 $("#work_enddate").daterangepicker({
		    singleDatePicker: true,
		    showDropdowns: true,
		    locale: {
			    format: 'YYYY-MM-DD',
			    cancelLabel: 'Clear'
		    }
	});
 }
 
function sideClose(){
	//업무 사이드바 닫기
	 $(".div-close").on('click',(e)=>{
	     var $side = $("#setting-sidebar");
	     if($side.hasClass('open')) {
	         $side.stop(true).animate({right:'-600px'});
	         $side.removeClass('open');
	     }
	     $side.empty();
	     $('.daterangepicker').remove();
	 });
}

 function updateWorkDate(){
	 $(".date-update").on('click',function(){
			var $this = $(this);
			var workNo = '${work.workNo}';
			var input = $this.parent(".setting-date-dropdown").find("input");
			var date = input.eq(0).val();	//수정할 날짜
			if($this.hasClass('date-cancel')){
				input.eq(0).val('');
				date = '';
			}
			var dateType = input.eq(0).attr('id');  //수정할 날짜 종류(work_startdate,work_enddate)
			
			var bool = workDateValidation(date,dateType); //유효성 검사
			if(bool){
				$.ajax({
					url: "${pageContext.request.contextPath}/project/updateWorkDate.do",
					data: {workNo:workNo, date:date, dateType:dateType},
					dataType:"json",
					success: data =>{
						var dateArr = date.split('-');
						var dateView = $this.closest(".row").find("p.setting-content-inform");
						if(data.isUpdated){
							if(date == null || date ==''){
								var dateTypeName = $this.closest(".row").find("label").text();
								dateView.text(dateTypeName+" 없음");
							}else{
								if(dateView.length == 0){
									$this.closest(".row").append("<p class='setting-content-inform'>"+(dateArr[1]+'월 '+dateArr[2] +'일')+"<p>");
								}else{
									dateView.text(dateArr[1]+'월 '+dateArr[2] +'일');
								}
							}
							input.eq(1).val(date);
							resetWorkView(); //업무 새로고침
						}
						else{
							alert("날짜 변경에 실패하였습니다. :()");
						}
					},
					error:(jqxhr, textStatus, errorThrown) =>{
						console.log(jqxhr, textStatus, errorThrown);
					}
				});
			}
	})
 }
 

function workDateValidation(date,dateType){
		var projectEndDate = $("#hiddenProjectStartDate").val();
		var projectEndDateArr = projectEndDate.split('-');
		var projectEndDateCompare = new Date(projectEndDateArr[0], parseInt(projectEndDateArr[1])-1, projectEndDateArr[2]);
		
		var dateArr = date.split('-');
		var dateCompare = new Date(dateArr[0], parseInt(dateArr[1])-1, dateArr[2]);
		
		if(projectEndDateCompare.getTime() > dateCompare.getTime()){alert("프로젝트 시작일을 확인 해 주세요.");return false;}
			
	 	if(dateType == 'work_startdate'){
			var endDate = $("#workEndDate").val();
			var endDateArr = endDate.split('-');
			
			if(endDate != null && endDate != ''){
		        var endDateCompare = new Date(endDateArr[0], parseInt(endDateArr[1])-1, endDateArr[2]);
		        if(dateCompare.getTime() > endDateCompare.getTime()) {alert("시작일과 마감일을 확인 해 주세요.");return false;}
			}
		}
		if(dateType== 'work_enddate'){
			var startDate = $("#workStartDate").val();
			var startDateArr = startDate.split('-');
			
			if(startDate != null && startDate != ''){
				var startDateCompare = new Date(startDateArr[0], parseInt(startDateArr[1])-1, startDateArr[2]);
		        if(startDateCompare.getTime() > dateCompare.getTime()) {alert("시작일과 마감일을 확인 해 주세요.");return false;}
			}
		}
		return true;
}
 
function updateWorkMember(){
	 var workNo = '${work.workNo}';
	 $("#updateWorkMember").on('click',function(){
		 var updateWorkMemberArr = $("select[name=workMember]").val();
		 var updateWorkMemberStr = updateWorkMemberArr.join(",");
			$.ajax({
				url: "${pageContext.request.contextPath}/project/updateWorkMember.do",
				data: {updateWorkMemberStr:updateWorkMemberStr, workNo:workNo},
				dataType:"json",
				success: data =>{
					if(data.isUpdated){
						 resetWorkView(); //업무 새로고침
						 $("section#"+workNo+".work-item").click(); //체크리스트 배정멤버 드롭다운을 위한..설정창 새로고침,,?
					}else{
						alert("업무 배정에 실패하였습니다. :(");
					}
				},
				error:(jqxhr, textStatus, errorThrown) =>{
					console.log(jqxhr, textStatus, errorThrown);
				}
		  });
	 })
 }
 
 function updateWorkTag(){
	 var workNo = '${work.workNo}';
	 $(".update-work-tag").on('click',function(){
		 var workTag = $(this).attr('id');
		 $.ajax({
			url: "${pageContext.request.contextPath}/project/updateWorkTag.do",
			data: {workNo:workNo, workTag:workTag},
			dataType:"json",
			success: data =>{
				if(data.isUpdated){
					var currentWorkTag = $(this).html();
					var view = $(".work-item#"+workNo+" div.work-tag");
					if(workTag !='' && workTag != null){
						$("#current-workTag").html(currentWorkTag);
						
						if(view.length==0){
							var html = "<div class='work-tag'>"+currentWorkTag+"</div>";
							$(".work-item#"+workNo+" .work-title").before(html);
						}
						else{
							view.html(currentWorkTag);
						}
					}else{
						$("#current-workTag").html('');
						view.html('');
					}
				}
			},
			error:(jqxhr, textStatus, errorThrown)=>{
				console.log(jqxhr, textStatus, errorThrown);
			}
		 });
	 })
 }
 
 function updateWorkPoint(){
	 var workNo = '${work.workNo}';
	 $(".work-importances").on('click',function(){
		 var workPoint = $(this).attr('id');
		 $.ajax({
			 url:"${pageContext.request.contextPath}/project/updateWorkPoint.do",
			 data: {workNo:workNo, workPoint:workPoint},
			 dataType:"json",
			 success: data=>{
				 if(data.isUpdated){
					 var currentWorkPoint = $(this).html();
					 $("#current-work-point").html(currentWorkPoint);
					 $(".work-item#"+workNo+" div.work-importances").html(currentWorkPoint);
				 }
			 },
			 error:(jqxhr, textStatus, errorThrown)=>{
				 console.log(jqxhr, textStatus, errorThrown);
			 }
		 })
	 })
 }
 
 function insertCheckList(){
	 var workNo = '${work.workNo}';
	 $(".btn-add-checklist").on('click',function(){
		 var chkWriter = '${memberLoggedIn.memberId}';
		 var chkContent = $("#checklist-content").val();
		 if(chkContent == null || chkContent ==''){
			 alert('체크리스트 내용을 입력하세요.');
			 return;
		 }
		 $.ajax({
			 url:"${pageContext.request.contextPath}/project/insertCheckList.do",
			 data: {workNo:workNo, chkWriter:chkWriter, chkContent:chkContent},
			 dataType:"json",
			 success: data=>{
				 var chk = data.checklist
				 let html = '<tr id="'+chk.checklistNo+'"><th><button type="button" class="btn-check" value="'+chk.workNo+','+chk.checklistNo+'"><i class="far fa-square"></i></button>        '
					      +'<input type="hidden" class="hiddenChkChargedMemId" value=""/></th><td style="width:100%">'
					      +'<div class="img-circle img-profile ico-profile update-chk-charge" data-toggle="dropdown"><i class="fas fa-user-plus" style="width:15px;margin-top: 5px;"></i></div><span class="checklistContent">'
	             		  + chk.checklistContent +'</span><input type="text" class="currentChecklistContent" value="'+chk.checklistContent+'" style="display:none;width:80%;"/>'
	             		  +'<button class="delete-checklist" id="'+chk.checklistNo+'" style="float:right;"><i class="fas fa-times"></i></button>'
	             		 +'<button class="edit-checklist" id="'+chk.checklistNo+'" style="float:right;"><i class="fas fa-pencil-alt"></i></button>';
	             //멤버 배정 위한 드롭다운 메뉴 추가
	             html += '<div class="dropdown-menu dropdown-menu" >';
	             <c:if test="${work.workChargedMemberList != null and !empty work.workChargedMemberList }">
	             	<c:forEach items="${work.workChargedMemberList}" var="m">
	              		html +='<div class="media dropdown-item chk-charge-member" id="${m.memberId}">'		 
		               		+'<img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile">'	
		               		+'<div class="media-body"><p class="memberName">${m.memberName}</p></div></div>';
				    </c:forEach> 
 		          	html +='<div class="media dropdown-item chk-charge-member del-chk-charge-member" id="" style="display:none"><p style="color:red;font-size:14px;">배정 멤버 삭제</p></div>';
 		         </c:if>	
		         <c:if test="${work.workChargedMemberList == null or empty work.workChargedMemberList }">
			    	html += '<span style="margin-left:10px;">없음</span>';
			   	 </c:if>
					html+='</div></td></tr>';
					
		         var viewhtml = '<tr id="'+chk.checklistNo+'"><th><button type="button" class="btn-check" value="'+chk.workNo+','+chk.checklistNo+'"><i class="far fa-square"></i></button>      '
		   			      	  +'<input type="hidden" class="hiddenChkChargedMemId" value=""/></th><td><span class="checklistContent">'+ chk.checklistContent +'</span></td></tr>';
		          		 	  
				 $("#chk-add-tr").before(html); 
				 
				 if ( $(".work-item#"+workNo+" .work-checklist table").length > 0 ) {
						$(".work-item#"+workNo+" .work-checklist tbody").append(viewhtml);
						var cnt = Number($(".work-item#"+workNo+" .work-etc .chklt-cnt-total").text());
						$(".work-item#"+workNo+" .work-etc span.chklt-cnt-total").text(cnt+1);
				 }
				 else{
					//테이블이 없을 경우
					 $(".work-item#"+workNo+" .work-etc").children("span.ico").eq(0).remove();
					 var cnthtml='<span class="ico chklt-cnt"><i class="far fa-list-alt"></i><span class="chklt-cnt-completed"> 0</span>/<span class="chklt-cnt-total">1</span></span>'
					 $(".work-item#"+workNo+" .work-etc").prepend(cnthtml);
				 		var tablehtml = '<table class="tbl-checklist"><tbody>'+viewhtml+'</tbody></table>'
				 		$(".work-item#"+workNo+" .work-checklist").append(tablehtml);
				 }
				 $("#checklist-content").val('');
				
			 },
			 error:(jqxhr, textStatus, errorThrown)=>{
				 console.log(jqxhr, textStatus, errorThrown);
			 }
		 })
	 })
 }
 
 function updateWorkLocation(){
	 var workNo = '${work.workNo}';
	 $(".work-location").on('click',function(){
		 var worklistNo = $(this).attr('id');
		 var worklistTitle = $(this).text();
		 $.ajax({
			 url:"${pageContext.request.contextPath}/project/updateWorkLocation.do",
			 data: {workNo:workNo, worklistNo:worklistNo},
			 dataType:"json",
			 success: data=>{
				 var $workSection = $("section.work-item#"+workNo+" .work-title").parent();
				 $workSection.remove();
				 $("#current-worklist").text(worklistTitle);
				 //해당 worklist 새로고침
				 resetWorklist(worklistNo);
			 },
			 error:(jqxhr, textStatus, errorThrown)=>{
				 console.log(jqxhr, textStatus, errorThrown);
			 } 
		 })
	 })
 }
function insertWorkComment(){
	 $(document).on('click',".work-comment-reply", function(){
		 var refNo = $(this).val();
		 var refWriter = $(".work-comment#"+refNo+" span.comment-writer").text();
		 var refContent = $(".work-comment#"+refNo+" span.comment-content").text();
		 
		 $(".reply-work-ref-writer").text(refWriter);
		 $(".reply-work-ref-content").text(refContent);
		 
		 $(".enroll-comment-inform #comment-level").val('2');
		 $(".enroll-comment-inform #comment-ref").val(refNo);
		 
		 $(".reply-work-ref-wrapper").show();
	 });
	 
	 $(document).on('click','.cancel-comment-ref', function(){
		 $(".reply-work-ref-wrapper").hide();
		 $(".enroll-comment-inform #comment-level").val('1');
		 $(".enroll-comment-inform #comment-ref").val('');
	 })
	 
	 $(".comment-submit").on('click', function(){
		 var workNo = '${work.workNo}';
		 var commentContent = $("div.enroll-comment-inform textarea").val();
		 var commentWriter = $("#comment-writer").val();
		 var commentLevel = $("#comment-level").val();
		 var commentRef = $("#comment-ref").val();

		 $.ajax({
			 url:"${pageContext.request.contextPath}/project/insertWorkComment.do",
			 data: {workNo:workNo,commentContent:commentContent,commentWriter:commentWriter,commentLevel:commentLevel,commentRef:commentRef},
			 type:"POST",
			 dataType:"json",
			 success: data=>{
				 if(data.isUpdated){
					 var comment = data.comment;
					 var member = data.member;
					 var html;
					 if(comment.workCommentLevel == 2){
						 html ='<div class="card-comment work-comment comment-level2 work-ref-'+comment.workCommentRef+'" id="' + comment.workCommentNo + '">';
					 }else{
						 html ='<div class="card-comment work-comment" id="'+comment.workCommentNo+'">';
					 }
					 
					 html +='<img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/'+member.renamedFileName+'" alt="User Image">'
		                  +'<div class="comment-text"><span class="username"><span class="comment-writer">'+member.memberName+'</span><span class="text-muted float-right">'+getToday()+'</span></span>'
		                  +'<div style="word-wrap:break-word;"><span class="comment-content">'+comment.workCommentContent+'</span></div>'
		                  +'<button class="comment-delete work-comment-delete float-right" value="'+comment.workCommentNo+'">삭제</button>';
		             
		             if(comment.workCommentLevel == 1) html +='<button class="comment-reply work-comment-reply float-right" value="'+comment.workCommentNo+'">답글</button>';   
		             html+='</div></div>';
		             
		             if($(".work-comments-box").length>0){
		            	 if(comment.workCommentLevel == 1){
			            	 $(".work-comments-box").append(html);
			             }
			             else{
			            	 if($(".work-ref-"+comment.workCommentRef).length>0) $(".work-ref-"+comment.workCommentRef+":last").after(html);
			            	 else $(".work-comment#"+comment.workCommentRef).after(html);
			             }
		             }else{
		            	 $("#null-comment-box").remove();
		            	 var chtml='<div class="card-footer card-comments work-comments-box">'+html+'</div>';
		            	 $(".work-comment-box").html(chtml);
		             }
		             
		             //코멘트 숫자 증가
		             var cnt = Number($(".work-item#"+workNo+" .work-etc .comment-cnt").text());
				 	 $("section#"+workNo+".work-item .work-etc span.comment-cnt").text(cnt+1);
		               
				 }
				 $("div.enroll-comment-inform textarea").val('');
				 $(".cancel-comment-ref").click();
				 
			 },
			 error:(jqxhr, textStatus, errorThrown)=>{
				 console.log(jqxhr, textStatus, errorThrown);
			 } 
		 });
	 })
 }
 
 
 
 function uploadWorkFile(){
	 $("#upload-file-btn").on('click',function(){
		 event.preventDefault();
		 var formData = new FormData($('#workFileForm')[0]);
		 var projectNo = '${project.projectNo}';
		 $.ajax({
			 type: "POST", 
			 enctype: 'multipart/form-data', // 필수 
			 url: "${pageContext.request.contextPath}/project/uploadWorkFile.do",
			 data: formData,
			 processData: false, // 필수 
			 contentType: false, // 필수
			 cache: false, 
			 success: data=>{
				 var a = data.attachment;
				 var rArr = (a.renamedFilename).split(".");
				 var ext = rArr[rArr.length-1].toLowerCase();
				 
				 if(data.isUpdated){
					 if($("#no-exist-file").length != 0){
						 $("#no-exist-file").remove()
					 }
						 
					 var html = '<tr id="'+a.attachmentNo+'"><input type="hidden" class="oName" value="'+a.originalFilename+'" />'
					 		  +'<input type="hidden" class="rName" value="'+a.renamedFilename+'" /><td><a href=""><div class="img-wrapper">';
					 if(ext =='bmp' || ext =='jpg' || ext=='jpeg' || ext =='gif' || ext=='png' || ext=='tif' || ext=='tiff' || ext=='jfif'){
						 html += '<img src="${pageContext.request.contextPath}/resources/upload/project/'+projectNo+'/'+a.renamedFilename+'" alt="첨부파일 미리보기 이미지">';
					 }
					 else{
						 html += '<img src="${pageContext.request.contextPath}/resources/img/project/default-file.png" alt="첨부파일 미리보기 이미지">';
					 }
					 html+='</div><div class="imgInfo-wrapper"><p class="filename">'+a.originalFilename+'</p></div></a></td>'
					 	 +'<td>'+getToday()+'</td>'
					 	 +'<td> <span>'+a.attachmentWriterMember.memberName+'</span>'
					 	 +'<div class="dropdown "><button type="button" class="btn-file" data-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></button>'
					 	 +'<div class="dropdown-menu dropdown-menu-right"><button type="button" class="dropdown-item btn-work-file-down" value="'+a.attachmentNo+'">다운로드</button>'
					 	 +'<div class="dropdown-divider"></div><button type="button" class="dropdown-item work-file-remove" value="'+a.attachmentNo+','+a.renamedFilename+'" data-toggle="modal" data-target="#modal-file-remove">삭제</a>'
				 		 +'</div></div></td></tr>';
				 	 $(".custom-file-label").html("파일을 선택하세요.");
				 	 $("#tbl-projectAttach tbody").append(html);
				 	 resetWorkView(); //업무 새로고침
				 }
			 },
			 error:(jqxhr, textStatus, errorThrown)=>{
				 console.log(jqxhr, textStatus, errorThrown);
			 } 
		 });
	 });
 }

 $("[name=workFile]").on("change",function(){
		//	파일 입력 취소
		if($(this).prop("files")[0] === undefined){
			$(this).next(".custom-file-label").html("파일을 선택하세요.");
			return;
		}
		var fileName = $(this).prop('files')[0].name; 
		//var fileName = $(this).val(); //크롬/Firefox 실제 컴퓨터의 경로를 노출하지 않는다.
		$(this).next(".custom-file-label").html(fileName);
 });
 function getToday(){
	//오늘 날짜 뿌려질 것..
	 var now = new Date();
     var year= now.getFullYear();
     var mon = (now.getMonth()+1)>9 ? ''+(now.getMonth()+1) : '0'+(now.getMonth()+1);
     var day = now.getDate()>9 ? ''+now.getDate() : '0'+now.getDate();
     var today = year + '-' + mon + '-' + day;
     
     return today;
 }
 
 function resetWorkView(){
	 var workNo = '${work.workNo}';
	 var worklistTitle='${worklistTitle}';
	 var projectNo = '${project.projectNo}';
	 let $workSection = $("section.work-item#"+workNo+" .work-title").parent();
	 
	 $.ajax({
			url: "${pageContext.request.contextPath}/project/resetWorkOne.do",
			type: "get",
			data:{workNo:workNo, worklistTitle:worklistTitle,projectNo:projectNo},
			dataType: "html",
			success: data => {
				$workSection.html("");
				$workSection.html(data);
			},
			error: (x,s,e) => {
				console.log(x,s,e);
			}
	 });
 }
 function resetWorklist(worklistNo){
		$.ajax({
			url: '${pageContext.request.contextPath}/project/resetWorklist.do',
			data: {projectManager: '${projectManager}',projectNo: ${project.projectNo},worklistNo: worklistNo},
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
 <script src="${pageContext.request.contextPath }/resources/js/multiselect.js"></script>
