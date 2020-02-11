<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />

<!-- Control sidebar content goes here -->
    <div class="p-3">
    <i class="fas fa-star"></i>
    <span class="setting-side-title">업무1</span>
    <p class="setting-contents-inform">
        <span>#2</span>
        <span>작성자 이단비</span>
        <span class="setting-contents-date">작성일 2020-01-27</span>
    </p>
    </div>
    
    <ul class="nav work-setting-tabs nav-tabs" id="custom-content-above-tab" role="tablist">
        <li class="nav-item setting-navbar-tab">
        <button type="button" id="custom-content-work-setting-tab" data-toggle="pill" href="#custom-content-work-setting" role="tab" aria-controls="custom-content-work-setting" aria-selected="true">속성</button>
        </li>
        <li class="nav-item setting-navbar-tab">
        <button type="button" id="custom-content-above-comment-tab" data-toggle="pill" href="#custom-content-above-comment" role="tab" aria-controls="custom-content-above-comment" aria-selected="false">코멘트</button>
        </li>
        <li class="nav-item setting-navbar-tab">
        <button type="button" id="custom-content-above-file-tab" data-toggle="pill" href="#custom-content-above-file" role="tab" aria-controls="custom-content-file-comment" aria-selected="false">파일</button>
        </li>
    </ul>
    <div class="tab-content" id="custom-content-above-tabContent">
        <!-- 업무 속성 탭-->
        <div class="tab-pane fade show active p-setting-container" id="custom-content-work-setting" role="tabpanel" aria-labelledby="custom-content-work-setting-tab">
            <div class="row setting-row add-description">
            <span>설명 추가</span>
            </div>
            <hr/>
            <div class="setting-row">
            <!-- 업무 위치 -->
            <div class="row">
                <label class="setting-content-label"><span class="label-icon"><i class='far fa-folder-open' style="width:20px;"></i></span> 위치</label>
                
                <!-- plus 버튼 눌렀을 때 dropdown-->
                <div class="add-member-left dropdown">
                    <button class="plusBtn" data-toggle="dropdown"><i class="fas fa-pencil-alt"></i></button>
                    <div class="dropdown-menu location-dropdown"  aria-labelledby="dropdownMenuLink">
                    <span>업무리스트</span>  
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" tabindex="-1" href="#">해야할 일</a>
                    <a class="dropdown-item" tabindex="-1" href="#">진행중</a>
                    <a class="dropdown-item" tabindex="-1" href="#">완료됨 </a>
                    </div>
                </div>
                        <p class="setting-content-inform">
                            <span>기획</span> <i class="fa fa-angle-double-right"></i> <span>해야할 일</span>
                        </p>
            </div>
            <!-- 업무 날짜 -->
            <div class="row">
                <label class="setting-content-label"><span><i class="far fa-calendar-alt" style="width:20px;"></i></span> 날짜 설정</label>
                <div class="dropdown">
                    <button class="plusBtn" data-toggle="dropdown"><i class="fas fa-cog"></i></button>
                    <div class="dropdown-menu setting-date-dropdown work-date-dropdown">
                        <div class="form-group">
                        <div class="input-group" >
                            <input type="text" class="form-control float-right" id="workDate" name="workDate"> 
                        </div>
                        </div>
                        <button class="btn bg-info date-update" type="button">수정</button>
                        <button class="btn bg-secondary date-cancel">취소</button>
                </div>
                </div>
                    
                    <p class="setting-content-inform">
                        2020/01/15 - 2020/01/19
                    </p>
            </div>
            <!-- 배정된 멤버-->
            <div class="row">
                <label class="setting-content-label"><span><i class='fas fa-user-plus' style="width:20px;"></i></span> 배정된 멤버</label>
                <button class="plusBtn" id="add-work-member"><i class="fa fa-plus"></i></button>
                <div class='control-wrapper pv-multiselect-box'>
                    <div class="control-styles">
                        <input type="text" tabindex="1" id='workMember' name="workMember"/>
                </div>
                </div>
            </div>
            <!-- 태그 -->
            <div class="row">
                <label class="setting-content-label"><span><i class="fa fa-tag" style="width:20px;"></i></span> 태그</label>
                <button class="plusBtn" data-toggle="dropdown"><i class="fa fa-plus"></i></button>
                <div class="work-tag">
                    <span class="btn btn-xs bg-danger">priority</span>
                    <span class="btn btn-xs bg-primary">important</span>
                    <span class="btn btn-xs bg-warning">review</span>
                </div>
                <div class="dropdown-menu work-setting-tag">
                    <a class="dropdown-item" tabindex="-1" href="#"><span class="btn btn-xs bg-danger">priority</span></a>
                    <a class="dropdown-item" tabindex="-1" href="#"><span class="btn btn-xs bg-primary">important</span></a>
                    <a class="dropdown-item" tabindex="-1" href="#"><span class="btn btn-xs bg-warning">review</span></a>
                </div>
            </div>
            </div>
            <!-- 업무 포인트(중요도) -->
            <div class="row setting-row setting-point">
                <label class="setting-content-label"> <span><i class='fas fa-ellipsis-h' style="width:20px;"></i></span> 포인트</label>
                <div class="dropdown status-dropdown">
                    <button>
                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span>
                    </button>
                    <div class="icon-box"  data-toggle="dropdown">
                    <i class="fa fa-angle-down"></i>
                    </div>
                    <div class="dropdown-menu">
                    <div class="dropdown-item work-importances" tabindex="-1" href="#">
                        <span class="importance-dot checked"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span>
                    </div>
                    <div class="dropdown-item work-importances" tabindex="-1" href="#">
                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span>
                        </div>
                    <div class="dropdown-item work-importances" tabindex="-1" href="#">
                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot"></span> <span class="importance-dot"></span>
                    </div>
                    <div class="dropdown-item work-importances" tabindex="-1" href="#">
                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot"></span>
                        </div>
                    <div class="dropdown-item work-importances" tabindex="-1" href="#">
                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span>
                    </div>
                    </div>
                </div>
            </div>
            <!-- 체크리스트 -->
            <div class="row setting-row checklist-box-row">
            <div class="work-checklist">
                <table class="tbl-checklist">
                <tbody>
                    <tr>
                    <th><button type="button" class="btn-check"><i class="far fa-square"></i></button></th>
                    <td>
                        <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                        체크리스트1
                    </td>
                    </tr>
                    <tr>
                    <th><button type="button" class="btn-check"><i class="far fa-square"></i></button></th>
                    <td>
                        <div class="img-circle img-profile ico-profile" ><i class='fas fa-user-plus' style="width:15px;"></i></div>
                        체크리스트2
                    </td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr>
                    <th><button type="button" class="btn-add-checklist"><i class="fa fa-plus"></i></button></th>
                    <td>
                        <input type="text" name="checklist-content" id="checklist-content" placeholder="체크리스트 아이템 추가하기">
                    </td>
                    </tr>
                </tfoot>
                </table>                
            </div>
            </div>
        </div><!--/end 업무 속성 탭-->

        <!-- 코멘트 탭-->
        <div class="tab-pane fade" id="custom-content-above-comment" role="tabpanel" aria-labelledby="custom-content-above-comment-tab">
        <div class="comment-wrapper">
            <div class="comment-box">
            <div class="card-footer card-comments">
                <div class="card-comment">
                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Image">
                <div class="comment-text">
                    <span class="username">김효정<span class="text-muted float-right">2020-01-26</span></span>
                    <span>오오 감사합니당</span>
                    <button class="comment-delete float-right">삭제</button>
                    <button class="comment-reply float-right">답글</button>
                </div>
                </div>
                <div class="card-comment">
                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Image">
                <div class="comment-text">
                    <span class="username">주보라<span class="text-muted float-right">2020-01-27</span></span>
                    <span>괜찮은데요??</span>
                    <button class="comment-delete float-right">삭제</button>
                    <button class="comment-reply float-right">답글</button>
                </div>
                </div>
                <div class="card-comment comment-level2">
                    <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Image">
                    <div class="comment-text">
                    <span class="username">유혜민<span class="text-muted float-right">2020-01-26</span></span>
                    <span>넵! 알겠습니당</span>
                    <button class="comment-delete float-right">삭제</button>
                    </div>
                </div>
                <div class="card-comment comment-level2">
                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Image">
                <div class="comment-text">
                    <span class="username">이소현<span class="text-muted float-right">2020-01-27</span></span>
                    <span>훨씬 편하네요~</span>
                    <button class="comment-delete float-right">삭제</button>
                </div>
                </div>
            </div>
            </div>
            <!-- 댓글 작성 -->
            <div class="card-footer">
            <form action="#" method="post">
                <img class="img-fluid img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile.jfif">
                <div class="img-push">
                <input type="text" class="form-control form-control-sm comment-text-area" placeholder="댓글을 입력하세요.">
                <input class="comment-submit" type="submit" value="등록">
                </div>
            </form>
            </div> 
        </div> 
        <!--/. end comment-wrapper--> 
        </div>
        <!--/. end 코멘트 tab-->

        <!-- 파일 탭 -->
        <div class="tab-pane fade file-tab-pane " id="custom-content-above-file" role="tabpanel" aria-labelledby="custom-content-above-file-tab">
            <div class="file-wrapper">
            <div class="container-fluid"> 
                <!-- 파일 첨부 -->
                <form action="">
                <div class="input-group work-file-upload-box">
                    <div class="custom-file">
                    <input type="file" class="custom-file-input" id="workInputFile" aria-describedby="inputGroupFileAddon04">
                    <label class="custom-file-label" for="inputGroupFile04">Choose file</label>
                    </div>
                    <div class="input-group-append">
                    <button class="btn btn-outline-secondary" type="button" id="inputGroupFileAddon04">Button</button>
                    </div>
                </div>
                </form>
                <!-- 첨부파일 테이블 -->
                <div id="card-workAttach" class="card">
                <div class="card-body table-responsive p-0">
                    <table id="tbl-projectAttach" class="table table-hover text-nowrap">
                    <thead>
                        <tr>
                        <th>이름</th>
                        <th>공유한 날짜</th>
                        <th>공유한 사람</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                        <td>
                            <a href="">
                            <div class="img-wrapper">
                            <img src="${pageContext.request.contextPath}/resources/img/test.jpg" alt="첨부파일 미리보기 이미지">
                            </div>
                            <div class="imgInfo-wrapper">
                            <p class="filename">file.png</p>
                            <p class="filedir">33.8KB</p>
                            </div>
                            </a>
                        </td>
                        <td>2020년 1월 28일</td>
                        <td>
                            이단비
                            <!-- 첨부파일 옵션 버튼 -->
                            <div class="dropdown ">
                            <button type="button" class="btn-file" data-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></button>
                            <div class="dropdown-menu dropdown-menu-right">
                                <a href="#" class="dropdown-item">
                                다운로드
                                </a>
                                <div class="dropdown-divider"></div>
                                <a href="#" class="dropdown-item dropdown-file-remove">삭제</a>
                            </div>
                            </div>
                        </td>
                        </tr>
                        <tr>
                        <td>
                            <a href="">
                            <div class="img-wrapper">
                            <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="첨부파일 미리보기 이미지">
                            </div>
                            <span class="filename">file.png</span>
                            </a>
                        </td>
                        <td>2020년 1월 28일</td>
                        <td>
                            이단비
                            <!-- 첨부파일 옵션 버튼 -->
                            <div class="dropdown ">
                            <button type="button" class="btn-file" data-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></button>
                            <div class="dropdown-menu dropdown-menu-right">
                                <a href="#" class="dropdown-item">
                                다운로드
                                </a>
                                <div class="dropdown-divider"></div>
                                <a href="#" class="dropdown-item dropdown-file-remove">삭제</a>
                            </div>
                            </div>
                        </td>
                        </tr>
                    </tbody>
                    </table>
                </div>
                <!-- /.card-body -->
                </div>
                <!-- /.card -->
                </div>
                <!-- /.container-fluid -->
            </div> 
            <!--/. end file-wrapper--> 
            </div>

    </div>