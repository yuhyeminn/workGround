<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<script>
$(function(){
	bsCustomFileInput.init();
});

//설정 내용 슬라이드토글
function toggleContent(obj){
    $('.setting-option-content').slideUp();
    $('.fa-chevron-down').css('transform', 'none');

    if(!$(obj).next().is(":visible")){
        $(obj).next().slideDown();
        $(obj).find('.fa-chevron-down:eq(0)').css('transform', 'rotate(180deg)');
    }
}
</script>

<!-- Content Wrapper. Contains page content -->
<div id="user-settings" class="content-wrapper">
    <section class="content">
        <h2>계정 설정</h2>
        <div class="container-fluid">
            <!-- 탭 -->
            <ul class="nav nav-tabs" id="custom-content-below-tab" role="tablist">
            	<!-- 설정탭은 본인만 볼 수 있도록 -->
            	<c:if test="${memberId == memberLoggedIn.memberId}">
                <li class="nav-item">
                	<c:if test="${active=='setting'}">
                    <a class="nav-link active" id="custom-content-below-setting-tab" data-toggle="pill" href="#custom-content-below-setting" role="tab" aria-controls="custom-content-below-setting" aria-selected="true">설정</a>
                    </c:if>
                    <c:if test="${active!='setting'}">
                    <a class="nav-link" id="custom-content-below-setting-tab" data-toggle="pill" href="#custom-content-below-setting" role="tab" aria-controls="custom-content-below-setting" aria-selected="true">설정</a>
                    </c:if>
                </li>
                </c:if>
                <li class="nav-item">
                	<c:if test="${active=='profile'}">
                    <a class="nav-link active" id="custom-content-below-profile-tab" data-toggle="pill" href="#custom-content-below-profile" role="tab" aria-controls="custom-content-below-profile" aria-selected="false">프로필</a>
                    </c:if>
                    <c:if test="${active!='profile'}">
                    <a class="nav-link" id="custom-content-below-profile-tab" data-toggle="pill" href="#custom-content-below-profile" role="tab" aria-controls="custom-content-below-profile" aria-selected="false">프로필</a>
                    </c:if>
                </li>
            </ul>
            <!-- 탭-컨텐츠 -->
            <div class="tab-content" id="custom-content-below-tabContent">
                <!-- 설정 -->
                <!-- 설정탭은 본인만 볼 수 있도록 -->
            <c:if test="${memberId == memberLoggedIn.memberId}">
            <c:if test="${active=='setting'}">
                <div class="tab-pane fade show active" id="custom-content-below-setting" role="tabpanel" aria-labelledby="custom-content-below-setting-tab">
            </c:if>
            <c:if test="${active!='setting'}">
                <div class="tab-pane fade" id="custom-content-below-setting" role="tabpanel" aria-labelledby="custom-content-below-setting-tab">
            </c:if>
                    <div id="setting-inner">
                        <!-- 이메일 변경 -->
                        <div class="setting-option">
                            <div class="setting-option-header" onclick="toggleContent(this);">
                                <h3>이메일 변경</h3>
                                <i class="fas fa-chevron-down"></i>
                            </div>
                            <div class="setting-option-content">
                                <form action="">
                                    <div class="input-wrapper">
                                        <label for="email-now">현재 이메일 주소</label>
                                        <input type="email" id="email-now" value="eeeeeeeee" class="form-control" disabled>
                                    </div>
                                    <div class="input-wrapper">
                                        <label for="email-new">새 이메일 주소</label>
                                        <input type="email" name="" id="email-new" class="form-control" required>
                                    </div>
                                    <button type="submit" class="btn-update">이메일 업데이트</button>
                                </form>                                
                            </div>
                        </div>

                        <!-- 전화번호 변경 -->
                        <div class="setting-option">
                            <div class="setting-option-header" onclick="toggleContent(this);">
                                <h3>전화번호 변경</h3>
                                <i class="fas fa-chevron-down"></i>
                            </div>
                            <div class="setting-option-content">
                                <form action="">
                                    <div class="input-wrapper">
                                        <label for="phone-now">현재 전화번호</label>
                                        <input type="tel" id="phone-now" value="eeeeeeeee" class="form-control" disabled>
                                    </div>
                                    <div class="input-wrapper">
                                        <label for="phone-new">새 전화번호</label>
                                        <input type="tel" name="" id="phone-new" class="form-control" required>
                                    </div>
                                    <button type="submit" class="btn-update">전화번호 업데이트</button>
                                </form>                                
                            </div>
                        </div>

                        <!-- 비밀번호 변경 -->
                        <div class="setting-option">
                            <div class="setting-option-header" onclick="toggleContent(this);">
                                <h3>비밀번호 변경</h3>
                                <i class="fas fa-chevron-down"></i>
                            </div>
                            <div class="setting-option-content">
                                <form action="">
                                    <div class="input-wrapper">
                                        <label for="pwd-now">현재 비밀번호</label>
                                        <input type="password" id="pwd-now" class="form-control">
                                    </div>
                                    <div class="input-wrapper">
                                        <label for="pwd-new">새 비밀번호</label>
                                        <input type="password" name="" id="pwd-new" class="form-control">
                                    </div>
                                    <div class="input-wrapper">
                                        <label for="pwd-new-chk">새 비밀번호 확인</label>
                                        <input type="password" name="" id="pwd-new-chk" class="form-control">
                                    </div>
                                    <button type="submit" class="btn-update">비밀번호 업데이트</button>
                                </form>                                
                            </div>
                        </div>

                        <!-- 계정 삭제 -->
                        <div class="setting-option">
                            <div class="setting-option-header" onclick="toggleContent(this);">
                                <h3>계정 삭제</h3>
                                <i class="fas fa-chevron-down"></i>
                            </div>
                            <div class="setting-option-content">
                                <p>한 번 삭제된 계정은 다시 복구할 수 없습니다. 계정이 삭제되면, 현재 계정에서 생성된 모든 데이터에 더이상 엑세스할 수 없습니다. 삭제 후, Workground를 다시 이용하고자 한다면, 새로 가입해주셔야합니다.</p>
                                <form action="">
                                    <button type="submit" class="btn-update delete">계정 삭제하기</button>
                                </form>                                
                            </div>
                        </div>
                    </div>
                </div>
			</c:if>
				
                <!-- 프로필 -->
            <c:if test="${active=='profile'}">
                <div class="tab-pane fade show active" id="custom-content-below-profile" role="tabpanel" aria-labelledby="custom-content-below-profile-tab">
            </c:if>
            <c:if test="${active!='profile'}">
                <div class="tab-pane fade" id="custom-content-below-profile" role="tabpanel" aria-labelledby="custom-content-below-profile-tab">
            </c:if>
                    <div id="profile-inner" style="background: white;">
                        <div class="card-body" style="padding: 2rem 1.25rem;">
                            <div class="active tab-pane" id="activity">
                                <!-- Post -->
                                <div class="post">
	                                <form role="form">
		                                <div id="custom-file-wrapper" style="float: left; margin-left: 1.5rem;">
		                                    <img class="img-fluid" src="dist/img/user2-160x160.jpg" alt="user image">
		                                    
		                                    <!-- 사진 업데이트는 본인만 볼 수 있도록 -->
		    								<c:if test="${memberId == memberLoggedIn.memberId}">
		                                    <div class="custom-file" style="background: black; opacity: 0.7; position: relative; bottom: 2.3rem; text-align: center; transition: .08s">
		                                        <label for="customFile" style="color: white; padding-top: 0.5rem; font-size: .75rem; cursor: pointer;">
		                                            <i class="fas fa-camera-retro" style="margin-right: .3rem;"></i>사진 업데이트
		                                        </label>
		                                    </div>
		                                    <div class="form-group" style="display: none;">
		                                        <div class="custom-file">
			                                        <label class="custom-file-label" for="customFile">Choose file</label>
			                                        <input type="file" class="custom-file-input" id="customFile">
		                                        </div>
		                                    </div>
		                                    </c:if>
		                                </div><!-- /.col -->
		                                <div class="col-sm-6" style="float: left; margin-left: 3rem;">
                                            <!-- text input -->
                                            <div class="form-group">
                                                <label>사번</label>
                                                <input type="text" class="form-control">
                                            </div>
                                            <div class="form-group">
                                                <label>이름</label>
                                                <input type="text" class="form-control">
                                            </div>
                                            <div class="form-group">
                                                <label>부서</label>
                                                <input type="text" class="form-control">
                                            </div>
                                            <div class="form-group">
                                                <label>직함</label>
                                                <input type="text" class="form-control">
                                            </div>
                                            <div class="form-group">
                                                <label>이메일</label>
                                                <input type="email" class="form-control">
                                            </div>
                                            <div class="form-group">
                                                <label>전화번호</label>
                                                <input type="tel" class="form-control">
                                            </div>
                                            <div class="form-group">
                                                <label>생년월일</label>
                                                <input type="date" class="form-control">
                                            </div>
                                        </div><!-- /.col -->
	                                </form>
                                </div>
                                <!-- /.post -->
                            </div>
                        </div><!-- /.card-body -->
                    </div>
                </div><!-- /.프로필 -->
            </div>
        </div><!-- /.container-fluid -->
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->		

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>