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
	<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/moonspam/NanumSquare@1.0/nanumsquare.css">
	<style>
	body{background: rgb(242, 242, 242); font-family: 'NanumSquare', sans-serif;}
	.bolder{font-weight: 800;}
	.errorPage{text-align: center;}
	.errorPage div{display: inline-block; position: relative;}
	.text_area{text-align: left; top: -6rem; margin-top: 7rem;}
	.text_area h1{font-size: 2.3rem;}
	.errorPage h2{color: rgb(89, 89, 89)}
	.errorPage a{color: rgb(68, 114, 196); text-decoration: none; font-size: 1.2em; position: relative; bottom: -13rem;}
	img{position: relative; top: 13rem; margin-right: -5rem;}
	</style>
</head>
<body>
	<div id="error-container" class="errorPage">
        <div class="text_area">
            <h1 class="bolder"><%= msg %></h1>
            <h2 class="bolder">서비스 이용에 불편을 드려 죄송합니다.</h2>
            <h3 class="home bolder"><a href="${pageContext.request.contextPath}/notice/noticeList.do">홈으로 돌아가기</a></h3>
        </div>
        <img src="${pageContext.request.contextPath}/resources/img/error.png" alt="에러이미지">
    </div>
</body>
</html>