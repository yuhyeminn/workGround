<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>WorkGround</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/fontawesome-free/css/all.min.css">
  <!-- Ionicons -->
  <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
  <!-- icheck bootstrap -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/icheck-bootstrap/icheck-bootstrap.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminlte.min.css">
  <!-- Google Font: Source Sans Pro -->
  <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR:100,300,400,500,700,900&display=swap" rel="stylesheet">
</head>
<body class="hold-transition login-page"  style="background: white;">
<%
//쿠키관련
	boolean saveId = false;
	String memberId = "";
	Cookie[] cookies = request.getCookies();
	if(cookies != null){
		for(Cookie c : cookies){
			String k = c.getName();
			String v = c.getValue();
			if("saveId".equals(k)){
				saveId = true;
				memberId = v;
			}
		}
	}
%>
<div class="col-md-8">
  <div class="login-logo">
    <b>COMPANY NAME</b>
  </div>
  <!-- /.login-logo -->
  <!-- <div class="card">  -->
    <div class="col-sm-6" style="display:inline-block; padding: 60px; box-shadow: 0 0 1px rgba(0,0,0,.125), 0 1px 3px rgba(0,0,0,.2); height: 23rem;">
      <p class="login-box-msg" style="font-weight: 700; font-size: 22px;">로그인</p>
      <form action="${pageContext.request.contextPath}/member/memberLogin.do" method="post">
        <div class="input-group mb-3">
          <input type="text" class="form-control" name="memberId" placeholder="아이디" value="<%=saveId?memberId:""%>" required>
          <div class="input-group-append">
            <div class="input-group-text" style="background: white;">
              <span class="fas fa-user"></span>
            </div>
          </div>
        </div>
        <div class="input-group mb-3">
          <input type="password" class="form-control" name="password" placeholder="비밀번호" required>
          <div class="input-group-append">
            <div class="input-group-text" style="background: white;">
              <span class="fas fa-lock"></span>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-8">
            <div class="icheck-primary">
              <input type="checkbox" name="saveId" id="remember" <%=saveId?"checked":""%>>
              <label for="remember">
                아이디 저장
              </label>
            </div>
          </div>
          <!-- /.col -->
          <div class="col-4">
            <button type="submit" class="btn btn-primary btn-block">로그인</button>
          </div>
          <!-- /.col -->
        </div>
      </form>
      <!-- /.social-auth-links -->

      <p class="mb-1">
        <a href="forgot-password.html">비밀번호를 잊으셨나요?</a>
      </p>
    </div>
    <!-- /.login-card-body -->
    <div class="col-sm-6" style="display: inline-block; float: right; padding: 40px; background: rgb(220, 234, 247); box-shadow: 0 0 1px rgba(0,0,0,.125), 0 1px 3px rgba(0,0,0,.2); height: 23rem;">
      <h2 style="font-weight:700; font-size:3rem; color: #2d235f;">WorkGround</h2>
      <p>Lorem ipsum dolor, sit amet consectetur adipisicing elit. Quam autem quo magni et reiciendis, nam, alias impedit corporis, molestiae omnis tempore iure dolor ea ullam fugit facere vel repellat! Earum!</p>
      <p class="mb-0">아직 계정이 없으신가요?&nbsp;&nbsp;<a href="${pageContext.request.contextPath}/member/memberRegister.do" class="text-center">가입하기</a></p>
    </div>
  </div>
<!-- </div> -->
<!-- /.login-box -->

<!-- jQuery -->
<script src="${pageContext.request.contextPath}/resources/plugins/jquery/jquery.min.js"></script>
<!-- Bootstrap 4 -->
<script src="${pageContext.request.contextPath}/resources/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- AdminLTE App -->
<script src="${pageContext.request.contextPath}/resources/js/adminlte.min.js"></script>

<script>

</script>
</body>
</html>