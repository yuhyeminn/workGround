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
  <!-- Ionicons -->
  <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
  <!-- icheck bootstrap -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/icheck-bootstrap/icheck-bootstrap.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminlte.min.css">
  <!-- Google Font: Source Sans Pro -->
  <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR:100,300,400,500,700,900&display=swap" rel="stylesheet">
  <!-- jQuery -->
  <script src="${pageContext.request.contextPath}/resources/plugins/jquery/jquery.min.js"></script>
  <!-- Bootstrap 4 -->
  <script src="${pageContext.request.contextPath}/resources/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
  <!-- AdminLTE App -->
  <script src="${pageContext.request.contextPath}/resources/js/adminlte.min.js"></script>
  <!-- Font Awesome -->
  <script src="https://kit.fontawesome.com/acb5cef700.js" crossorigin="anonymous"></script>
</head>
<style>
body{font-family: 'Noto Sans KR', 'Source Sans Pro',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif,'Apple Color Emoji','Segoe UI Emoji','Segoe UI Symbol';}
#head{position: absolute; top: 0; left: 0; z-index: 1; width: 100%; height: 72px;}
#div-register{padding: 32px 60px 0 0; text-align: right;}
#a-register{min-width: 120px; height: 40px; padding: 0 23px; border-radius: 20px; border: 1px solid #e0e0e0; font-size: 13px; color: #000; line-height: 38px; box-sizing: border-box; text-align: center; background-color: #fff}
#a-register:hover{color: #fff; background-color: #007bff; border: 1px solid #007bff; text-decoration: none;}
#main{background-image:url(//t1.daumcdn.net/tistory_admin/static/top/pc/bg_login_white.png); position: fixed; top: 0; left: 0; right: 0; bottom: 0; background-repeat: no-repeat; background-position: 50% 0; background-size: cover;}
.login-box{position: absolute; left: 50%; top: 50%; margin: -145px 0 0 -160px;"}
</style>
<body class="hold-transition login-page">
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
<div id="head"> 
    <h1 style="float: left; margin: 40px 0 0 60px; width: 24px; height: 24px;">
	    <span style="display: block; position: relative; width: 24px; height: 24px;">
	    	<i class="fas fa-dice-d20" style="display: block; position: relative; font-size: 24px; width:200px;">
	    		<span class="brand-text font-weight-light" style="font-family: 'Nunito', sans-serif; font-size: .9rem; margin-left: .1rem; letter-spacing: .1rem; font-weight: 300!important; ">WORKGROUND</span>
	    	</i>
	    </span>
    </h1>
    <div style="position: absolute; top: 0; right: 0;">
	    <div id="div-register">
	    	 <a href="${pageContext.request.contextPath}/member/memberRegister.do" class="text-center" id="a-register" style="display: inline-block; margin-left: 22px;">회원가입</a>
	    </div>
    </div>
</div>
<div id="main">
	<div class="login-box">

	  <div class="login-logo">
	    <b>KHJAVA Co.</b>
	  </div>	
      <form action="${pageContext.request.contextPath}/member/memberLogin.do" method="post">
	       <div style="margin: 35px 0 0; border: 1px solid #ddd; border-radius: 3px; background-color: #fff; box-sizing: border-box">
	          <input type="text" class="form-control" name="memberId" placeholder="아이디" value="<%=saveId?memberId:""%>" required
	          		 style="display: block; width: 100%; height: 100%; font-size: 13px; color: #000; border: none; outline: 0; -webkit-appearance: none; background-color: transparent; width: 100%; margin: 0; padding: 18px 19px 19px; box-sizing: border-box;">
	          <input type="password" class="form-control" name="password" placeholder="비밀번호" 
	          		 style="display: block; width: 100%; height: 100%; font-size: 13px; color: #000; border: none; outline: 0; -webkit-appearance: none; background-color: transparent; width: 100%; margin: 0; padding: 18px 19px 19px; box-sizing: border-box; border-top: 1px solid #ddd">  
	      </div>
	      <button type="submit" class="btn btn-primary btn-block" style="margin: 20px 0 0; width: 100%; height: 48px; border-radius: 3px;">로그인</button>
	 </form>
	 <div style="overflow: hidden; padding: 15px 0 0;">
	 	<div style="float:left; display: inline-block; position: relative;margin-bottom: -1px;">
	    	<div class="icheck-primary" style="margin:0px!important;">
	      		<input type="checkbox" name="saveId" id="remember" <%=saveId?"checked":""%>>
	            <label for="remember" style="font-size: 13px; font-weight:0!important;">아이디 저장</label>
	        </div>
	    </div>
		<span style="float: right; color: #777;">
	    	<a href="forgot-password.html" data-toggle="modal" data-target="#modal-default" 
	           style="font-size: 13px;font-family: 'Noto Sans KR', 'Source Sans Pro',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif,'Apple Color Emoji','Segoe UI Emoji','Segoe UI Symbol';">비밀번호 찾기</a>
    	</span>      
	</div>
  </div>
</div>
<div class="modal fade" id="modal-default">
	<div class="modal-dialog">
		<div class="modal-content">
	    	<div class="modal-header">
	        	<h4 class="modal-title">비밀번호 찾기</h4>
	            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	            	<span aria-hidden="true">&times;</span>
	            </button>
	        </div>
	        <form action="${pageContext.request.contextPath}/member/forgotPassword.do" method="post">
	        	<div class="modal-body">
	            	<div class="input-wrapper" style="padding:2rem;">
	                	<div id="inputDiv">
		                    <label for="chk-id">아이디</label>
		                    <p style="font-size: .8rem; padding-left: .5rem;">비밀번호를 찾고자 하는 아이디를 입력해 주세요.</p>
		                    <input type="text" id="chk-id" name="memberId" class="form-control">                     
	                 	</div>
	                	<div id="successDiv" style="text-align: center"></div>
	                	<div id="failDiv"></div>
	                </div>
	            </div>
		        <div class="modal-footer justify-content-between">
		        	<button type="button" class="btn btn-default" data-dismiss="modal" id="closeButton">Close</button>
		            <button type="submit" class="btn btn-primary" id="nextButton">다음</button>
		        </div>
	       </form>
	   </div>
	</div>
</div>
   
    <!-- /.login-card-body -->
 <!--  </div> -->
<!--  </div> -->
<%-- <div class="col-md-10" style="background-image:url(${pageContext.request.contextPath}/resources/img/bg_login_white.png);">
  <div class="login-logo">
    <b>COMPANY NAME</b>
  </div>
  <!-- /.login-logo -->
  <!-- <div class="card">  -->
    <div class="col-sm-6" style="display:inline-block; padding: 60px; box-shadow: 0 0 1px rgba(0,0,0,.125), 0 1px 3px rgba(0,0,0,.2); height: 23rem;background-image:url(${pageContext.request.contextPath}/resources/img/bg_login_white.png);">
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
          <input type="password" class="form-control" name="password" placeholder="비밀번호">
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
        <a href="forgot-password.html" data-toggle="modal" data-target="#modal-default">비밀번호를 잊으셨나요?</a>
      </p>
        <div class="modal fade" id="modal-default">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">비밀번호 찾기</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form action="${pageContext.request.contextPath}/member/forgotPassword.do" method="post">
            	<div class="modal-body">
                 <div class="input-wrapper" style="padding:2rem;">
                 	<div id="inputDiv">
	                    <label for="chk-id">아이디</label>
	                    <p style="font-size: .8rem; padding-left: .5rem;">비밀번호를 찾고자 하는 아이디를 입력해 주세요.</p>
	                    <input type="text" id="chk-id" name="memberId" class="form-control">                     
                 	</div>
                 	<div id="successDiv" style="text-align: center"></div>
                 	<div id="failDiv"></div>
                 </div>
            	</div>
	            <div class="modal-footer justify-content-between">
	              <button type="button" class="btn btn-default" data-dismiss="modal" id="closeButton">Close</button>
	              <button type="submit" class="btn btn-primary" id="nextButton">다음</button>
	            </div>
            </form>
          </div>
          <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
      </div>
      <!-- /.modal -->
    </div>
    <!-- /.login-card-body -->
    <div class="col-sm-6" style="display: inline-block; float: right; padding: 40px; background: rgb(220, 234, 247); box-shadow: 0 0 1px rgba(0,0,0,.125), 0 1px 3px rgba(0,0,0,.2); height: 23rem;">
      <h2 style="font-weight:700; font-size:3rem; color: #2d235f;">WorkGround</h2>
      <p>
		비밀번호 없이 바로 사번 복사해서 로그인하세요~<br>
		이미 로그인 한 후에 로그인 페이지로 가는거 막게하는건 아직 못했어요<br>
		admin 관리자<br>
		kh2020122 이단비(팀장)<br>
		kh2020123 유혜민<br>
		kh2020124 주보라<br>
		kh2020125 이소현<br>
		kh2020126 김효정<br>
		kh2020127 이주현
		</p>
      <p class="mb-0">아직 계정이 없으신가요?&nbsp;&nbsp;<a href="${pageContext.request.contextPath}/member/memberRegister.do" class="text-center">가입하기</a></p>
    </div> 
  </div>  --%>
<!-- </div> -->
<!-- /.login-box -->
</body>
</html>