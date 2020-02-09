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
<body class="hold-transition register-page" style="background: white;">
<div class="register-box">
  <div class="register-logo">
      <b>COMPANY NAME</b>
  </div>

  <div class="card">
    <div class="card-body register-card-body">
      <p class="login-box-msg" style="font-weight: 700; font-size: 22px;">회원가입</p>

      <form action="${pageContext.request.contextPath}/member/memberRegisterEnd.do" method="post" onsubmit="return checkValidate();">
        <div class="input-group mb-3">
          <input type="text" class="form-control" id="memberId_" name="memberId" placeholder="아이디"  required value=${member.memberId}>
          <div class="input-group-append">
            <div class="input-group-text">
            </div>
            <button type="button" class="btn btn-block btn-outline-primary" 
            		onclick="checkIdExistence();">확인</button>
          </div>
        </div>
        <input type="hidden" id="idValid" value=${idValid} />
        <div class="input-group mb-3">
          <input type="text" class="form-control" name="memberName" placeholder="이름"  readOnly required value=${member.memberName}>
          <div class="input-group-append">
            <div class="input-group-text">
              <span class="fas fa-user"></span>
            </div>
          </div>
        </div>
        <div class="input-group mb-3">
          <input type="password" class="form-control" name="password" id="password_" placeholder="비밀번호" required>
          <div class="input-group-append">
            <div class="input-group-text" id="passwordDiv">
              <span class="fas fa-lock"></span>
            </div>
          </div>
        </div>
        <p id="warningPwd" style="font-size:.7rem; position:relative; top:-.5rem; margin-bottom:.2rem; margin-left:.4rem; display:none;">
        	비밀번호는 8~15자리 숫자/문자/특수문자를 포함해야합니다.
        </p>
        <div class="input-group mb-3">
          <input type="password" class="form-control" id="passwordChk_" placeholder="비밀번호 확인" required>
          <div class="input-group-append">
            <div class="input-group-text" id="passwordChkDiv">
              <span class="fas fa-lock"></span>
            </div>
          </div>
        </div>
        <p id="warningPwdChk" style="font-size:.7rem; position:relative; top:-.5rem; margin-bottom:.2rem; margin-left:.4rem; display:none;">
        	비밀번호와 일치하지 않습니다.
        </p>
        <div class="input-group mb-3">
          <input type="email" class="form-control" name="email" id="email_" placeholder="이메일" required value=${member.email }>
          <div class="input-group-append">
            <div class="input-group-text" id="emailDiv">
              <span class="fas fa-envelope"></span>
            </div>
          </div>
        </div>
        <p id="warningEmail" style="font-size:.7rem; position:relative; top:-.5rem; margin-bottom:.2rem; margin-left:.4rem; display:none;">
        	이메일 형식에 맞지 않습니다.
        </p>
        <div class="input-group mb-3">
          <input type="tel" class="form-control" name="phone" id="phone_" placeholder="전화번호" required value=${member.phone }>
          <div class="input-group-append">
            <div class="input-group-text" id="phoneDiv">
              <i class="fas fa-phone"></i>
            </div>
          </div>
        </div>
        <p id="warningPhone" style="font-size:.7rem; position:relative; top:-.5rem; margin-bottom:.2rem; margin-left:.4rem; display:none;">
        	전화번호 형식에 맞지 않습니다.('-' 제외) 
        </p>
        <div class="input-group mb-3">
          <input type="text" class="form-control" name="dateOfBirth" id="dateOfBirth_" placeholder="생년월일" readOnly value=${member.dateOfBirth}>
          <div class="input-group-append">
            <div class="input-group-text" id="dateOfBirthDiv">
              <i class="far fa-calendar-alt"></i>
            </div>
          </div>
        </div>
        <div class="row">
          <!-- /.col -->
         <div class="col-4" style="margin-left: 14rem;"> 
            <button type="submit" class="btn btn-primary btn-block" style="float: right;">가입하기</button>
          </div>
          <!-- /.col -->
        </div>
      </form>
      <p class="mb-0">이미 회원이신가요?&nbsp;&nbsp;<a href="login.html" class="text-center">로그인</a>
    </div>
    <!-- /.form-box -->
  </div><!-- /.card -->
</div>
<!-- /.register-box -->

<!-- jQuery -->
<script src="${pageContext.request.contextPath}/resources/plugins/jquery/jquery.min.js"></script>
<!-- Bootstrap 4 -->
<script src="${pageContext.request.contextPath}/resources/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- AdminLTE App -->
<script src="${pageContext.request.contextPath}/resources/js/adminlte.min.js"></script>

<script>
function checkIdExistence() {
	var memberId = $("#memberId_").val();
	if(memberId == '' || memberId == null){
		alert("아이디를 입력해주세요");
		console.log(${member.dateOfBirth});
	}
	else{
		location.href='${pageContext.request.contextPath}/member/checkIdExistence.do?memberId='+memberId;
	}
}
function checkValidate(){
	var regPassword = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
	var regEmail = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
	var regPhone = /^[0-9]{10,11}$/;
	var password = $("#password_").val();
	var passwordChk = $("#passwordChk_").val();
	var idValid = $("#idValid").val();
	console.log(idValid);
	
	if(!regPassword.test(password)){return false;}
	else if(password != passwordChk){return false;}
	else if(!regEmail.test($("#email_").val())){return false;}
	else if(!regPhone.test($("#phone_").val())){return false;}
	else if(idValid != 1){alert("아이디를 확인해주세요."); return false;}
	return true;
	
}
</script>
<script>
$("#password_").keyup(function(){
	var password = $(this).val().trim();
	var regPassword = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
	
	$("#passwordChk_").val('');
	
	if(!regPassword.test(password)){
		$("#password_").css("border-left", "1px solid red")
					   .css("border-top", "1px solid red")
					   .css("border-bottom", "1px solid red");
		$("#passwordDiv").css("border-right", "1px solid red")
						 .css("border-top", "1px solid red")
						 .css("border-bottom", "1px solid red");
		$("#warningPwd").css("display", "block");
	}else{
		$("#password_").css("border-left", "1px solid #ced4da")
		  			   .css("border-top", "1px solid #ced4da")
		               .css("border-bottom", "1px solid #ced4da");
		$("#passwordDiv").css("border-right", "1px solid #ced4da")
			             .css("border-top", "1px solid #ced4da")
			             .css("border-bottom", "1px solid #ced4da");
		$("#warningPwd").css("display", "none");
	}
});

$("#passwordChk_").keyup(function(){
	var password = $("#password_").val();
	var passwordchk = $(this).val().trim();
	
	if(password == ''){
		alert("비밀번호를 입력해주세요");
		$("#passwordChk_").val('');
		$("#password_").focus();
	}
	else if(password != passwordchk){
		$("#passwordChk_").css("border-left", "1px solid red")
		   				  .css("border-top", "1px solid red")
		  				  .css("border-bottom", "1px solid red");
		$("#passwordChkDiv").css("border-right", "1px solid red")
			 			 .css("border-top", "1px solid red")
			 			 .css("border-bottom", "1px solid red");
		$("#warningPwdChk").css("display", "block");
	}
	else{
		$("#passwordChk_").css("border-left", "1px solid #ced4da")
		   			   	  .css("border-top", "1px solid #ced4da")
        			      .css("border-bottom", "1px solid #ced4da");
		$("#passwordChkDiv").css("border-right", "1px solid #ced4da")
          				 .css("border-top", "1px solid #ced4da")
          				 .css("border-bottom", "1px solid #ced4da");
		$("#warningPwdChk").css("display", "none");
	} 
});

$("#email_").keyup(function(){
	var email = $(this).val().trim();
	var regEmail = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
	
	if(!regEmail.test(email)){
		$("#email_").css("border-left", "1px solid red")
		   				  .css("border-top", "1px solid red")
		  				  .css("border-bottom", "1px solid red");
		$("#emailDiv").css("border-right", "1px solid red")
			 			 .css("border-top", "1px solid red")
			 			 .css("border-bottom", "1px solid red");
		$("#warningEmail").css("display", "block");
	}
	else{
		$("#email_").css("border-left", "1px solid #ced4da")
		   			   	  .css("border-top", "1px solid #ced4da")
        			      .css("border-bottom", "1px solid #ced4da");
		$("#emailDiv").css("border-right", "1px solid #ced4da")
          				 .css("border-top", "1px solid #ced4da")
          				 .css("border-bottom", "1px solid #ced4da");
		$("#warningEmail").css("display", "none");
	}
});

$("#phone_").keyup(function(){
	var phone = $(this).val().trim();
	var regPhone = /^[0-9]{10,11}$/;
	
	if(!regPhone.test(phone)){
		$("#phone_").css("border-left", "1px solid red")
		   				  .css("border-top", "1px solid red")
		  				  .css("border-bottom", "1px solid red");
		$("#phoneDiv").css("border-right", "1px solid red")
			 			 .css("border-top", "1px solid red")
			 			 .css("border-bottom", "1px solid red");
		$("#warningPhone").css("display", "block");
	}
	else{
		$("#phone_").css("border-left", "1px solid #ced4da")
		   			   	  .css("border-top", "1px solid #ced4da")
        			      .css("border-bottom", "1px solid #ced4da");
		$("#phoneDiv").css("border-right", "1px solid #ced4da")
          				 .css("border-top", "1px solid #ced4da")
          				 .css("border-bottom", "1px solid #ced4da");
		$("#warningPhone").css("display", "none");
	}
});

$("#memberId_").keyup(function(){
	$("#idValid").val(0);
})


</script>
</body>
</html>