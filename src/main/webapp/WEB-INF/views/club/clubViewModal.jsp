<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- insertPhoto Modal -->
<form method="POST">
	<div class="modal fade cd-example-modal-lg" id="insertPhoto" tabindex="-1" role="dialog"
	    aria-labelledby="myLargeModalLabel" aria-hidden="true" data-backdrop="static">
	    <div class="modal-dialog modal-dialog-centered modal-lg">
	    <div class="modal-content card card-outline card-info">
	        <div class="modal-header col-12">
		        <input type="text" class="form-control" placeholder="제목을 입력하세요.">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		            <span aria-hidden="true">&times;</span>
		        </button>
	        </div>
	        <div class="form-group">
              <label for="exampleInputFile">사진파일</label>
              <div class="input-group">
                <div class="custom-file">
                  <input type="file" class="custom-file-input" id="exampleInputFile">
                  <label class="custom-file-label" for="exampleInputFile">Choose file</label>
                </div>
                <!-- <div class="input-group-append">
                  <span class="input-group-text" id="">Upload</span>
                </div> -->
              </div>
            </div>
	        <div class="modal-footer">
		        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
		        <button type="button" class="btn btn-primary"
		            style="background-color: #17a2b8; border-color: #17a2b8;">추가</button>
	        </div>
	    </div>
	    </div>
	</div>
</form>

<!-- Image Modal -->
<div class="modal fade cd-example-modal-lg" id="exampleModalCenter" tabindex="-1" role="dialog"
aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
<div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content card card-outline card-info">
    <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">연탄봉사활동</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <div class="modal-body">
        <img src="${pageContext.request.contextPath}/resources/img/club/volunteer1.jpg" alt="..." class="img-thumbnail" data-toggle="modal"
        data-target="#exampleModalCenter">
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" data-toggle="modal"
        style="background-color: #17a2b8; border-color: #17a2b8;">수정</button>
    </div>
    </div>
</div>
</div>


<!-- info Modal -->
<div class="modal fade" id="info" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle"
aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
	    <div class="modal-content card card-outline card-info">
	    <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLongTitle">봉사동아리</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	        <span aria-hidden="true">&times;</span>
	        </button>
	    </div>
	    <div class="modal-body">
		<br>
	            봉사활동을 하고싶으신 분들을 위해 모이기 시작한 동호회입니다.
	    <br>
	            한 달에 두 번 토요일에 봉사활동을 하는 정기모임을 갖습니다.
	    </div>
	    <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
	        <button type="button" class="btn btn-primary" data-dismiss="modal" data-toggle="modal"
	        style="background-color: #17a2b8; border-color: #17a2b8;">수정</button>
	    </div>
	    </div>
	</div>
</div>


<!-- planView Modal -->
            <form action="" method="post">
            <div class="modal fade cd-example-modal-lg" id="planView" tabindex="-1" role="dialog"
                aria-labelledby="exampleModalCenterTitle" aria-hidden="true" data-backdrop="static">
                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                <div class="modal-content card card-outline card-info">
                    <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">일정확인하기</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    </div>
                    <div class="modal-body">
                    <div class="form-group">
                        <label for="inputName">일정</label>
                        <p style="margin-left: 10px;">보육원 봉사</p>
                    </div>
                    <div class="form-group">
                        <div class="mb-3">
                        <label for="inputDescription">일정 내용</label>
                        <div style="margin-left: 10px;">
                            희망보육원에서 오전 11시부터 오후 4시까지 봉사활동을 할 예정입니다.
                            <br>
                            많은 참석 부탁드립니다.
                        </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputStatus">상태</label>
                        <span class="btn btn-block btn-sm bg-success" style="margin-left: 10px; width: 70px;">예정</span>
                    </div>
                    <div class="form-group">
                        <label for="inputClientCompany">장소</label>
                        <p style="margin-left: 10px;">희망보육원</p>
                    </div>
                    <div class="form-group">
                        <label for="inputProjectLeader">담당진행자</label>
                        <p style="margin-left: 10px;">봉동회장</p>
                    </div>
                    <div class="form-group">
                        <label for="inputProjectLeader">참석자</label>
                        <p>
                        <!-- 프로필 사진 -->
                        <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile"
                            style="width: 50px; margin-left: 10px;">
                        </p>
                    </div>
                    </div>
                    <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-primary" data-target="#plan-modify" data-dismiss="modal"
                        data-toggle="modal" style="background-color: #17a2b8; border-color: #17a2b8;">수정</button>
                    <button type="button" class="btn btn-info float-right"><i class="fas fa-plus"></i></button>
                    </div>
                </div>
                </div>
            </div>
            </form>
            <!-- insertPlan Modal -->
            <form action="" method="post">
            <div class="modal fade cd-example-modal-lg" id="insertPlan" tabindex="-1" role="dialog"
                aria-labelledby="exampleModalCenterTitle" aria-hidden="true" data-backdrop="static">
                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                <div class="modal-content card card-outline card-info">
                    <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">일정추가하기</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    </div>
                    <div class="modal-body">
                    <div class="form-group">
                        <label for="inputName">일정</label>
                        <input type="text" id="inputName" class="form-control" placeholder="일정을 입력하세요.">
                    </div>
                    <!-- <div class="form-group">
                        <label for="inputDescription">일정 내용</label>
                        <textarea id="inputDescription" class="form-control" rows="4"></textarea>
                    </div> -->
                    <div class="form-group">
                        <div class="mb-3">
                        <label for="inputDescription">일정 내용</label>
                        <textarea id="inputDescription" class="textarea"
                            style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;"></textarea>
                        </div>
                    </div>
                    <!-- Date picker -->
                    <div class="form-group">
                        <label for="">날짜</label>
                        <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="far fa-calendar-alt"></i></span>
                        </div>
                        <input type="text" class="form-control float-right" id="reservation">
                        </div>
                        <!-- /.input group -->
                    </div>
                    <!-- /.form group -->
                    <div class="form-group">
                        <label for="inputStatus">상태</label>
                        <select class="form-control custom-select">
                        <option selected disabled>선택하세요.</option>
                        <option selected>예정</option>
                        <option>완료</option>
                        <option>취소</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="inputClientCompany">장소</label>
                        <input type="text" id="inputClientCompany" class="form-control" placeholder="장소를 입력하세요.">
                    </div>
                    <div class="form-group">
                        <label for="inputProjectLeader">담당진행자</label>
                        <input type="text" id="inputProjectLeader" class="form-control" placeholder="담당진행자를 입력하세요.">
                    </div>
                    </div>
                    <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-primary" data-target="#notice-modify"
                        style="background-color: #17a2b8; border-color: #17a2b8;">추가</button>
                    </div>
                </div>
                </div>
            </div>
            </form>
            <!-- plan-modify Modal -->
            <form action="" method="post">
            <div class="modal fade cd-example-modal-lg" id="plan-modify" tabindex="-1" role="dialog"
                aria-labelledby="exampleModalCenterTitle" aria-hidden="true" data-backdrop="static"
                style="overflow-y: auto;">
                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                <div class="modal-content card card-outline card-info">
                    <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">일정수정하기</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    </div>
                    <div class="modal-body">
                    <div class="form-group">
                        <label for="inputName">일정</label>
                        <input type="text" id="inputName" class="form-control" placeholder="일정을 입력하세요." value="보육원 봉사">
                    </div>
                    <!-- <div class="form-group">
                        <label for="inputDescription">일정 내용</label>
                        <textarea id="inputDescription" class="form-control" rows="4"></textarea>
                    </div> -->
                    <div class="form-group">
                        <div class="mb-3">
                        <label for="inputDescription">일정 내용</label>
                        <textarea id="inputDescription" class="textarea"
                            style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;">희망보육원에서 오전 11시부터 오후 4시까지 봉사활동을 할 예정입니다.
                            <br>
                            많은 참석 부탁드립니다.</textarea>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputStatus">상태</label>
                        <select class="form-control custom-select">
                        <option selected disabled>선택하세요.</option>
                        <option selected>예정</option>
                        <option>완료</option>
                        <option>취소</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="inputClientCompany">장소</label>
                        <input type="text" id="inputClientCompany" class="form-control" placeholder="장소를 입력하세요."
                        value="희망보육원">
                    </div>
                    <div class="form-group">
                        <label for="inputProjectLeader">담당진행자</label>
                        <input type="text" id="inputProjectLeader" class="form-control" placeholder="담당진행자를 입력하세요."
                        value="봉동회장">
                    </div>
                    </div>
                    <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-primary" data-target="#notice-modify"
                        style="background-color: #17a2b8; border-color: #17a2b8;">추가</button>
                    </div>
                </div>
                </div>
            </div>
            </form>
            
            <!-- notice Modal -->
            <div class="modal fade cd-example-modal-lg" id="notice" tabindex="-1" role="dialog"
            aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                <div class="modal-content card card-outline card-info">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">2월 14일 신입회원 환영회 있습니다.</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    2월 14일 신입회원 환영회식 있습니다.
                    <br>
                    장소는 진씨화로이며 시간은 퇴근 후 7시 30분입니다.
                    <br><br>
                    새로 들어오신 신입회원분들과 친해지기 위해서 모두 늦지않게 도착해주시기 바랍니다.
                    <br><br>
                    항상 열심히 해주시는 모든 회원분들께 감사드립니다.
                    <br>
                    좋은하루 보내시기 바랍니다.
                </div>
                <div class="card-footer card-comments">
                    <div class="card-comment">
                    <!-- User image -->
                    <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/user3-128x128.jpg" alt="User Image">

                    <div class="comment-text">
                        <span class="username">
                        Maria Gonzales
                        <span class="text-muted float-right">8:03 PM Today</span>
                        </span><!-- /.username -->
                        It is a long established fact that a reader will be distracted
                        by the readable content of a page when looking at its layout.
                    </div>
                    <!-- /.comment-text -->
                    </div>
                    <!-- /.card-comment -->
                    <div class="card-comment">
                    <!-- User image -->
                    <img class="img-circle img-sm" src="../dist/img/user4-128x128.jpg" alt="User Image">

                    <div class="comment-text">
                        <span class="username">
                        Luna Stark
                        <span class="text-muted float-right">8:03 PM Today</span>
                        </span><!-- /.username -->
                        It is a long established fact that a reader will be distracted
                        by the readable content of a page when looking at its layout.
                    </div>
                    <!-- /.comment-text -->
                    </div>
                    <!-- /.card-comment -->
                </div>
                <!-- /.card-footer -->
                <div class="card-footer">
                    <form action="#" method="post">
                    <img class="img-fluid img-circle img-sm" src="../dist/img/user4-128x128.jpg" alt="Alt Text">
                    <!-- .img-push is used to add margin to elements next to floating images -->
                    <div class="img-push">
                        <input type="text" class="form-control form-control-sm" placeholder="Press enter to post comment">
                    </div>
                    </form>
                </div>
                <!-- /.card-footer -->
                <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" data-toggle="modal"
                    data-target="#notice-modify" style="background-color: #17a2b8; border-color: #17a2b8;">수정</button>
                </div>
            </div>
            </div>
        </div>
        
        <!-- #notice-modify modal -->
<form method="POST">
	<div class="modal fade cd-example-modal-lg" id="notice-modify" tabindex="-1" role="dialog"
	    aria-labelledby="myLargeModalLabel" aria-hidden="true" data-backdrop="static">
	    <div class="modal-dialog modal-dialog-centered modal-lg">
	    <div class="modal-content card card-outline card-info">
	        <div class="modal-header col-12">
	        <input type="text" class="form-control" value="2월 14일 신입회원 환영회 있습니다.">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	            <span aria-hidden="true">&times;</span>
	        </button>
	        </div>
	        <div class="card-body pad">
	        <div class="mb-3">
	            <textarea class="textarea"
	            style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;">2월 14일 신입회원 환영회식 있습니다.
	            <br>
	            장소는 진씨화로이며 시간은 퇴근 후 7시 30분입니다.
	            <br><br>
	            새로 들어오신 신입회원분들과 친해지기 위해서 모두 늦지않게 도착해주시기 바랍니다.
	            <br><br>
	            항상 열심히 해주시는 모든 회원분들께 감사드립니다.
	            <br>
	            좋은하루 보내시기 바랍니다.</textarea>
	        </div>
	        </div>
	        <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
	        <button type="button" class="btn btn-primary"
	            style="background-color: #17a2b8; border-color: #17a2b8;">수정</button>
	        </div>
	    </div>
	    </div>
	</div>
</form>

<!-- #notice-input modal -->
<form method="POST">
	<div class="modal fade cd-example-modal-lg" id="insertNotice" tabindex="-1" role="dialog"
	    aria-labelledby="myLargeModalLabel" aria-hidden="true" data-backdrop="static">
	    <div class="modal-dialog modal-dialog-centered modal-lg">
	    <div class="modal-content card card-outline card-info">
	        <div class="modal-header col-12">
	        <input type="text" class="form-control" placeholder="제목을 입력하세요.">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	            <span aria-hidden="true">&times;</span>
	        </button>
	        </div>
	        <div class="card-body pad">
	        <div class="mb-3">
	            <textarea class="textarea"
	            style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;"></textarea>
	        </div>
	        </div>
	        <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
	        <button type="button" class="btn btn-primary"
	            style="background-color: #17a2b8; border-color: #17a2b8;">추가</button>
	        </div>
	    </div>
	    </div>
	</div>
</form>		
        