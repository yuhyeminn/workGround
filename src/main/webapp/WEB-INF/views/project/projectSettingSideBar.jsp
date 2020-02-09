<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<div class="p-3">
	    <i class="fas fa-star"></i>
	    <span class="setting-side-title">기획</span>
	    <p class="setting-contents-inform">
	        <span>#2</span>
	        <span>작성자 이단비</span>
	        <span class="setting-contents-date">작성일 2020-01-27</span>
	    </p>
    </div>
    
    <ul class="nav project-setting-tabs" id="custom-content-above-tab" role="tablist">
        <li class="nav-item setting-navbar-tab">
        	<button type="button" id="custom-content-above-home-tab" data-toggle="pill" href="#custom-content-above-home" role="tab" aria-controls="custom-content-above-home" aria-selected="true">설정</button>
        </li>
    </ul>
    <div class="tab-content" id="custom-content-above-tabContent">
        <div class="tab-pane fade show active p-setting-container" id="custom-content-above-home" role="tabpanel" aria-labelledby="custom-content-above-home-tab">
            <div class="row setting-row add-description">
            	<span>설명 추가</span>
            </div>
            <hr/>
            <div class="row setting-row">
            <label class="setting-content-label col-md-4">프로젝트 상태</label>
            <div class="dropdown status-dropdown">
                <button>
                계획됨 
                <span class="status-dot bg-warning"></span>
                </button>
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
                    <div class="setting-icon" data-toggle="dropdown">
                    <i class="fas fa-cog"></i>
                    </div>
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
                <p class="setting-content-inform">
                <i class="far fa-calendar-alt"></i>
                <span>2020/01/28</span>
                </p>
            </div>
                
            <div class="row">
                <label class="setting-content-label">마감일</label>
                <div class="dropdown">
                    <div class="setting-icon" data-toggle="dropdown">
                    <i class="fas fa-cog"></i>
                    </div>
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
                <p class="setting-content-inform">
                    <i class="far fa-calendar-alt"></i>
                    <span>2020/01/30</span>
                </p>
            </div>
            <div class="row">
                <label class="setting-content-label">실제 완료일</label>
                <div class="dropdown">
                    <div class="setting-icon" data-toggle="dropdown">
                    <i class="fas fa-cog"></i>
                    </div>
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
                <p class="setting-content-inform">
                    <i class="far fa-calendar-alt"></i>
                    <span>2020/02/01</span>
                </p>
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
            <hr/>
            <div class="row setting-row">
                <label class="setting-content-label">프로젝트 나가기</label>
                <div>
                <button type="button" class="sign-out-project">프로젝트 나가기</button>
                <p>더 이상 이 프로젝트의 팀원이 아닙니다.</p>
            </div>
            </div>
        </div>
        </div>