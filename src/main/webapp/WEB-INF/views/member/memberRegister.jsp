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
  <!-- Font Awesome -->
  <script src="https://kit.fontawesome.com/acb5cef700.js" crossorigin="anonymous"></script>
</head>
<style>
body{font-family: 'Noto Sans KR', 'Source Sans Pro',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif,'Apple Color Emoji','Segoe UI Emoji','Segoe UI Symbol';}
#main{background-image:url(//t1.daumcdn.net/tistory_admin/static/top/pc/bg_login_white.png); position: absolute; top: 0; left: 0; right: 0; bottom: 0; background-repeat: no-repeat; background-position: 50% 0; background-size: cover; background-attachment: scroll;}
#content-signUp{position: relative; width: 712px; margin: 0 auto; padding: 59px 0 20px;}
.cont-data{overflow: hidden; width: 100%; margin: 0 auto; display: block;}
.cont-data dl:first-child{border-top: 1px solid #ddd; border-top-left-radius: 3px; border-top-right-radius: 3px;float: left;}
.cont-data dl{float: left; width: 100%; font-size: 0; border: 1px solid #ddd; border-top: 0; box-sizing: border-box; display: block; margin-block-start: 1em; margin-block-end: 1em; margin-inline-start: 0px; margin-inline-end: 0px;}
.cont-data dt{float: left; width: 141px; padding: 18px 0 16px 19px; font-size: 13px; color: #333;}
.cont-data dd{overflow: hidden; position: relative; min-height: 22px; padding: 18px 0 16px 0;}
input{width: 440px; display: inline-block; height: 100%; font-size: 13px; color: #000; border: none; outline: 0; -webkit-appearance: none; background-color: transparent;}
button{background-color: white; margin: 0 4px; display: inline-block; min-width: 120px; height: 40px; padding: 0 23px; border-radius: 20px; border: 1px solid #e0e0e0; font-size: 13px; box-sizing: border-box; text-align: center;}
.span-error{display: none; padding: 3px 0; font-size: 13px; line-height: 19px; color: red;}
#wrap-btn{padding: 40px 0 0; font-size: 0;line-height: 0;text-align: center;}
#a-login{min-width: 120px; height: 40px; padding: 0 23px; border-radius: 20px; border: 1px solid #e0e0e0; font-size: 13px; color: #000; line-height: 38px; box-sizing: border-box; text-align: center; background-color: #fff}
button:hover{color: #fff; background-color: #007bff; border: 1px solid #007bff; text-decoration: none;}
</style>
<body class="hold-transition register-page">
<div id="main">
	<div id="content-signUp">
		<p>회원가입</p>
		<form action="${pageContext.request.contextPath}/member/memberRegisterEnd.do" method="post" onsubmit="return checkValidate();">
			<div class="cont-data">
				<dl class="dl">
					<dt><label for="">아이디</label></dt>
					<dd><input type="text" id="memberId_" name="memberId" placeholder="아이디를 입력해주세요." required value=${member.memberId}>
						<button type="button" onclick="checkIdExistence();">확인</button>
					</dd>
				</dl>
				<dl>
					<dt><label for="">이름</label></dt>
					<dd><input type="text" name="memberName" readOnly required value=${member.memberName}></dd>
				</dl>
				<dl id="dl-password">
					<dt><label for="">비밀번호</label></dt>
					<dd><input type="password" name="password" id="password_" placeholder="비밀번호는 8~15자리 숫자/문자/특수문자를 포함해야합니다." required>
						<span id="warningPwd" class="span-error">비밀번호는 8~15자리 숫자/문자/특수문자를 포함해야합니다.</span>
					</dd>
				</dl>
				<dl id="dl-passwordChk">
					<dt><label for="">비밀번호 확인</label></dt>
					<dd><input type="password" id="passwordChk_" placeholder="비밀번호를 한번 더 입력해 주세요." required>
						<span id="warningPwdChk" class="span-error">비밀번호와 일치하지 않습니다.</span>
					</dd>
				</dl>
				<dl id="dl-email">
					<dt><label for="">이메일</label></dt>
					<dd><input type="email" name="email" id="email_" placeholder="이메일주소를 입력해 주세요." required value=${member.email }>
						<span id="warningEmail" class="span-error">이메일 형식에 맞지 않습니다.</span>
					</dd>
				</dl>
				<dl id="dl-phone">
					<dt><label for="">전화번호</label></dt>
					<dd><input type="tel" name="phone" id="phone_" placeholder="전화번호를 입력해주세요.('-'제외)" required value=${member.phone }>
						<span id="warningPhone" class="span-error">전화번호 형식에 맞지 않습니다.('-' 제외)</span>
					</dd>
				</dl>
				<dl>
					<dt><label for="">생년월일</label></dt>
					<dd><input type="text" name="dateOfBirth" id="dateOfBirth_" readOnly value=${member.dateOfBirth}></dd>
				</dl>
			</div>
			<div id="wrap-btn">
				<button onclick="goLogin();">이전</button>
				<button type="submit">가입하기</button>
			</div>
		</form>
	</div>
</div>

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
	else if(idValid == 1){alert("아이디를 확인해주세요."); return false;}
	return true;
	
}
function goLogin(){
	location.href="${pageContext.request.contextPath}/";
}
</script>
<script>
$("#password_").keyup(function(){
	var password = $(this).val().trim();
	var regPassword = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
	
	$("#passwordChk_").val('');
	
	if(!regPassword.test(password)){
		$("#dl-password").css("border", "1px solid red");
		$("#warningPwd").css("display", "block");
	}else{
		$("#dl-password").css("border", "1px solid #ddd")
						 .css("border-top", "0px");
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
		$("#dl-passwordChk").css("border", "1px solid red");
		$("#warningPwdChk").css("display", "block");
	}
	else{
		$("#dl-passwordChk").css("border", "1px solid #ddd")
		   			   	  	.css("border-top", "0px");
		$("#warningPwdChk").css("display", "none");
	} 
});

$("#email_").keyup(function(){
	var email = $(this).val().trim();
	var regEmail = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
	
	if(!regEmail.test(email)){
		$("#dl-email").css("border", "1px solid red");
		$("#warningEmail").css("display", "block");
	}
	else{
		$("#dl-email").css("border", "1px solid #ddd")
					  .css("border-top", "0px");
		$("#warningEmail").css("display", "none");
	}
});

$("#phone_").keyup(function(){
	var phone = $(this).val().trim();
	var regPhone = /^[0-9]{10,11}$/;
	
	if(!regPhone.test(phone)){
		$("#dl-phone").css("border", "1px solid red");
		$("#warningPhone").css("display", "block");
	}
	else{
		$("#dl-phone").css("border", "1px solid #ddd")
		   			  .css("border-top", "0px");
		$("#warningPhone").css("display", "none");
	}
});

$("#memberId_").keyup(function(){
	$("#idValid").val(0);
})


</script>
</body>
</html>