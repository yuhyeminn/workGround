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
</style>
<div class="div-close" role="button" tabindex="0">
    <i class="fas fa-times close-sidebar"></i>
</div>
<div class="p-3">
	    <i class="fas fa-star"></i>
	    <span class="setting-side-title">${project.projectTitle}</span>
	    <p class="setting-contents-inform">
	        <span>#${project.projectNo}</span>
	        <span>작성자 ${projectManager.memberName }</span>
	        <span class="setting-contents-date">시작일 ${project.projectStartDate }</span>
	    </p>
    </div>
    
    <ul class="nav project-setting-tabs" id="custom-content-above-tab" role="tablist">
        <li class="nav-item setting-navbar-tab">
        	<button type="button" id="custom-content-above-home-tab" data-toggle="pill" href="#custom-content-above-home" role="tab" aria-controls="custom-content-above-home" aria-selected="true">설정</button>
        </li>
    </ul>
    <div class="tab-content" id="custom-content-above-tabContent">
        <div class="tab-pane fade show active p-setting-container" id="custom-content-above-home" role="tabpanel" aria-labelledby="custom-content-above-home-tab">
            <c:if test="${project.projectDesc == null or project.projectDesc == ''}">
	            <div class="row setting-row add-description">
	            	<span>설명 추가</span>
	            </div>
            </c:if>
            <c:if test="${project.projectDesc != null and project.projectDesc != '' }">
	            <div class="row setting-row project-description">
	            	<span>${project.projectDesc }</span>
	            </div>
            </c:if>
            <hr/>
            <div class="row setting-row">
            <label class="setting-content-label col-md-4">프로젝트 상태</label>
            <div class="dropdown status-dropdown">
            <c:if test="${project.projectStatusTitle !=null and project.projectStatusTitle != ''}">
                <button>
                	${project.projectStatusTitle }<span class="status-dot bg-${project.projectStatusColor }"></span>
                </button>
            </c:if>
            <c:if  test="${project.projectStatusTitle ==null or project.projectStatusTitle == ''}">
             	<button>
                	상태없음 <span class="status-dot bg-secondary"></span>
                </button>
            </c:if>
                <div class="icon-box"  data-toggle="dropdown">
                <i class="fa fa-angle-down"></i>
                </div>
                <div class="dropdown-menu">
                <a class="dropdown-item" tabindex="-1" href="#">계획됨 <span class="status-dot bg-warning"></span></a>
                <a class="dropdown-item" tabindex="-1" href="#">진행중 <span class="status-dot bg-success"></span></a>
                <a class="dropdown-item" tabindex="-1" href="#">완료됨 <span class="status-dot bg-info"></span></a>
                <a class="dropdown-item" tabindex="-1" href="#">상태없음 <span class="status-dot bg-secondary"></span></a>
                </div>
            </div>
            </div>
            <hr/>
            <div class="setting-row">
            <div class="row">
                <label class="setting-content-label">시작일</label>

                <div class="dropdown">
                  <c:if test="${project.projectWriter eq memberLoggedIn.memberId }">
                    <div class="setting-icon" data-toggle="dropdown">
                    <i class="fas fa-cog"></i>
                    </div>
                  </c:if>
                    <div class="dropdown-menu setting-date-dropdown">
                        <div class="form-group">
                        <div class="input-group" >
                            <input type="text" class="form-control float-right" id="projectStartDate" name="projectStartDate" data-provide='datepicker'> 
                        </div>
                        </div>
                        <button class="btn bg-info date-update">수정</button>
                        <button class="btn bg-secondary date-cancel">취소</button>
                </div>
                </div>
                <c:if test="${project.projectStartDate != null and project.projectStartDate != '' }">
	                <p class="setting-content-inform">
	                <i class="far fa-calendar-alt"></i>
	                <span>${project.projectStartDate }</span>
	                </p>
                </c:if>
                <c:if test="${project.projectStartDate == null or project.projectStartDate == '' }">
	                <p class="setting-content-inform">
	                <span>시작일 없음</span>
	                </p>
                </c:if>
            </div>
                
            <div class="row">
                <label class="setting-content-label">마감일</label>
                <div class="dropdown">
                  <c:if test="${project.projectWriter eq memberLoggedIn.memberId }">
                    <div class="setting-icon" data-toggle="dropdown">
                    <i class="fas fa-cog"></i>
                    </div>
                  </c:if>
                    <div class="dropdown-menu setting-date-dropdown">
                        <div class="form-group">
                        <div class="input-group" >
                            <input type="text" class="form-control float-right" id="projectEndDate" name="projectEndDate" data-provide='datepicker'> 
                        </div>
                        </div>
                        <button class="btn bg-info date-update">수정</button>
                        <button class="btn bg-secondary date-cancel">취소</button>
                </div>
                </div>
                <c:if test="${project.projectEndDate != null and project.projectEndDate != '' }">
	               <p class="setting-content-inform">
                    <i class="far fa-calendar-alt"></i>
                    <span>${project.projectEndDate }</span>
                </p>
                </c:if>
                <c:if test="${project.projectEndDate == null or project.projectEndDate == '' }">
	                <p class="setting-content-inform">
	                <span>마감일 없음</span>
	                </p>
                </c:if>
            </div>
            <div class="row">
                <label class="setting-content-label">실제 완료일</label>
                <div class="dropdown">
                  <c:if test="${project.projectWriter eq memberLoggedIn.memberId }">
                    <div class="setting-icon" data-toggle="dropdown">
                    <i class="fas fa-cog"></i>
                    </div>
                  </c:if>
                    <div class="dropdown-menu setting-date-dropdown">
                        <div class="form-group">
                        <div class="input-group" >
                            <input type="text" class="form-control float-right" id="projectRealEndDate" name="projectRealEndtDate" data-provide='datepicker'> 
                        </div>
                        </div>
                        <button class="btn bg-info date-update">수정</button>
                        <button class="btn bg-secondary date-cancel">취소</button>
                </div>
                </div>
                <c:if test="${project.projectRealEndDate != null and project.projectRealEndDate != '' }">
	               <p class="setting-content-inform">
                    <i class="far fa-calendar-alt"></i>
                    <span>${project.projectRealEndDate }</span>
                   </p>
                </c:if>
                <c:if test="${project.projectRealEndDate == null or project.projectRealEndDate == '' }">
	                <p class="setting-content-inform">
	                 <span>완료일 없음</span>
	                </p>
                </c:if>
            </div>
            </div>
            <hr/>
            <div class="row setting-row">
                <label class="setting-content-label">프로젝트 관리자</label>
                <div class='control-wrapper pv-multiselect-box'>
                <div class="control-styles">
                    <input type="text" tabindex="1" id='projectManager' name="projectManager"/>
                </div>
                </div>
            </div>
            <hr/>
            <div class="row setting-row">
                <label class="setting-content-label">프로젝트 팀원</label>
                <div class='control-wrapper pv-multiselect-box'>
                <div class="control-styles">
                    <input type="text" tabindex="1" id='projectMember' name="projectMember"/>
                </div>
            </div>
            </div>
            <c:if test="${!empty project.projectMemberList}">
            	<c:forEach var="member" items="${project.projectMemberList}" varStatus="vs">
            		<c:if test="${member.memberId eq memberLoggedIn.memberId }">
            		<hr/>
		            <div class="row setting-row">
		                <label class="setting-content-label">프로젝트 나가기</label>
		              <div>
		                <button type="button" class="sign-out-project">프로젝트 나가기</button>
		                <p>더 이상 이 프로젝트의 팀원이 아닙니다.</p>
		              </div>
		            </div>
            		</c:if>
            	</c:forEach>
            </c:if>
            
        </div>
        </div>
        
<script>
$(()=>{
	var projectNo = '${project.projectNo}';
	var projectWriter = '${project.projectWriter}';
	projectManager(projectWriter);
	projectMember(projectNo);
});

//업무 사이드바 닫기
$(".div-close").on('click',()=>{
    var $side = $("#setting-sidebar");
    if($side.hasClass('open')) {
        $side.stop(true).animate({right:'-520px'});
        $side.removeClass('open');
    }
});

$("#projectStartDate").datepicker({
    todayHighlight: true,
    format: 'yyyy/mm/dd',
    uiLibrary: 'bootstrap4'
    
    });
$("#projectEndDate").datepicker({
    todayHighlight: true,
    format: 'yyyy/mm/dd',
    uiLibrary: 'bootstrap4'
    });
$("#projectRealEndDate").datepicker({
    todayHighlight: true,
    format: 'yyyy/mm/dd',
    uiLibrary: 'bootstrap4'
});

</script>
<script src="${pageContext.request.contextPath }/resources/js/multiselect.js"></script>