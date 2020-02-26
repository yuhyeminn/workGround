<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%

	String status = String.valueOf(response.getStatus());
	System.out.println("Status@errorPage="+status);
	
	String msg = exception!=null?exception.getMessage():status;
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Error</title>
 	<!-- Theme style -->
  	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminlte.min.css">
	<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/moonspam/NanumSquare@1.0/nanumsquare.css">
	<style>
 	body.hold-transition.login-page{background: #f8f9fa; font-family: 'NanumSquare', sans-serif;}
 	#error-container{max-width: 1100px; margin: 0 auto;}
	.bolder{font-weight: 800;}
	.text{text-align: left;}
	#text_area{display: inline-block; margin-top: 2rem;}
	.text_1{font-size: 2.3rem;}
	.text_2{font-size: 1.5rem; color: rgb(89, 89, 89); display: inline-block; margin-top: 2rem;}
	.text_3{margin-top: 20rem;}
	.text_3>a{color: rgb(68, 114, 196); text-decoration: none; font-size: 1.3em;}
	img{float: right;}
	</style>
</head>
<body class="hold-transition login-page">
	<div class="col-md-8" id="error-container">
		<div class="bolder text text_1"><%= msg %></div>
	    <div class="bolder text text_2">서비스 이용에 불편을 드려 죄송합니다.</div>
	    <img src="${pageContext.request.contextPath}/resources/img/error.png" alt="에러이미지">
	        <div class="home bolder text text_3"><a href="${pageContext.request.contextPath}/notice/noticeList.do">홈으로 돌아가기</a></div>
	</div>
</body>
</html>