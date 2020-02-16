<%@page import="com.kh.workground.member.model.vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/* Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
	System.out.println("memberLoggedIn="+memberLoggedIn); */
	//application.setAttribute("memberLoggedIn", memberLoggedIn);
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>WORKGROUND</title>
  <!-- Font Awesome -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/fontawesome-free/css/all.min.css">
  <!-- Font Awesome Icons -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/fontawesome-free/css/all.min.css">
  <!-- Ionicons -->
  <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
  <!-- DataTables -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/datatables-bs4/css/dataTables.bootstrap4.css">
  <!-- summernote -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/summernote/summernote-bs4.css">
  <!-- iCheck for checkboxes and radio inputs -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/icheck-bootstrap/icheck-bootstrap.min.css">
  <!-- daterange picker -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/daterangepicker/daterangepicker.css">
  <!--datepicker-->
  <link href="https://unpkg.com/gijgo@1.9.13/css/gijgo.min.css" rel="stylesheet" type="text/css" />
  <!-- Select2 -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/select2/css/select2.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/select2-bootstrap4-theme/select2-bootstrap4.min.css">
  <!--Syncfusion multiselect-->
  <link href="https://cdn.syncfusion.com/ej2/ej2-base/styles/material.css" rel="stylesheet" type="text/css"/>
  <link href="https://cdn.syncfusion.com/ej2/ej2-inputs/styles/material.css" rel="stylesheet" type="text/css"/>
  <link href="https://cdn.syncfusion.com/ej2/ej2-dropdowns/styles/material.css" rel="stylesheet" type="text/css"/>
  <!-- Theme style -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminlte.min.css">
  <!-- WorkGround Custom Css -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/media.css">
  <!-- Google Font -->
  <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR:100,300,400,500,700,900&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Nunito:700&display=swap" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/moonspam/NanumSquare@1.0/nanumsquare.css">

  <!-- REQUIRED SCRIPTS -->
  <!-- jQuery -->
  <script src="${pageContext.request.contextPath}/resources/plugins/jquery/jquery.min.js"></script>
  <!-- Bootstrap 4 -->
  <script src="${pageContext.request.contextPath}/resources/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/plugins/select2/js/select2.full.min.js"></script>
  <!-- AdminLTE App -->
  <script src="${pageContext.request.contextPath}/resources/js/adminlte.min.js"></script>
  <!-- AdminLTE for demo purposes -->
  <script src="${pageContext.request.contextPath}/resources/js/demo.js"></script>
  <!-- bs-custom-file-input -->
  <script src="${pageContext.request.contextPath}/resources/plugins/bs-custom-file-input/bs-custom-file-input.min.js"></script>
  <!-- DataTables -->
  <script src="${pageContext.request.contextPath}/resources/plugins/datatables/jquery.dataTables.js"></script>
  <script src="${pageContext.request.contextPath}/resources/plugins/datatables-bs4/js/dataTables.bootstrap4.js"></script>
  <!-- Summernote -->
  <script src="${pageContext.request.contextPath}/resources/plugins/summernote/summernote-bs4.min.js"></script>
  <!-- Select2 -->
  <script src="${pageContext.request.contextPath}/resources/plugins/select2/js/select2.full.min.js"></script>
  <!-- InputMask -->
  <script src="${pageContext.request.contextPath}/resources/plugins/moment/moment.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/plugins/inputmask/min/jquery.inputmask.bundle.min.js"></script>
  <!-- date-range-picker -->
  <script src="${pageContext.request.contextPath}/resources/plugins/moment/moment.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/plugins/daterangepicker/daterangepicker.js"></script>
  <!-- date picker-->
  <script src="https://unpkg.com/gijgo@1.9.13/js/gijgo.min.js" type="text/javascript"></script>
  <!-- 차트 js-->
  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <!--Syncfusion MultiSelect-->
  <script src="https://cdn.syncfusion.com/ej2/ej2-buttons/dist/global/ej2-buttons.min.js" type="text/javascript"></script>
  <script src="https://cdn.syncfusion.com/ej2/ej2-base/dist/global/ej2-base.min.js" type="text/javascript"></script>
  <script src="https://cdn.syncfusion.com/ej2/ej2-data/dist/global/ej2-data.min.js" type="text/javascript"></script>
  <script src="https://cdn.syncfusion.com/ej2/ej2-inputs/dist/global/ej2-inputs.min.js" type="text/javascript"></script>
  <script src="https://cdn.syncfusion.com/ej2/ej2-lists/dist/global/ej2-lists.min.js" type="text/javascript"></script>
  <script src="https://cdn.syncfusion.com/ej2/ej2-popups/dist/global/ej2-popups.min.js" type="text/javascript"></script>
  <script src="https://cdn.syncfusion.com/ej2/ej2-dropdowns/dist/global/ej2-dropdowns.min.js" type="text/javascript"></script>
  
  <!-- Page Script -->
  <script>
  //목록 슬라이드토글
  function toggleList(obj){
    $(obj).next().slideToggle();
  } 
  </script>
</head>

<body class="hold-transition sidebar-mini sidebar-collapse layout-fixed layout-navbar-fixed">
<div class="wrapper">
  <!-- Navbar Workspace -->
  <nav class="main-header navbar navbar-expand navbar-white navbar-light navbar-workspace">
    <!-- Left navbar links -->
    <ul class="navbar-nav media-nav">
      <li class="nav-item">
        <a class="nav-link" data-widget="pushmenu" href="#"><i class="fas fa-bars"></i></a>
      </li>
    </ul>

    <!-- SEARCH FORM -->
    <form class="form-inline ml-3">
      <div class="input-group input-group-sm">
        <input class="form-control form-control-navbar" type="search" placeholder="KHJAVA Co. 검색" aria-label="Search">
        <div class="input-group-append">
          <!-- <button class="btn btn-navbar" type="submit"> -->
          <button class="btn btn-navbar" type="button" onclick="location.href='${pageContext.request.contextPath}/search/searchList.do'">
            <i class="fas fa-search"></i>
          </button>
        </div>
      </div>
    </form>

    <!-- Right navbar links -->
    <ul class="navbar-nav ml-auto">
      <!-- 알림 -->
      <li id="notice-panel" class="nav-item dropdown">
        <a class="nav-link" data-toggle="dropdown" href="#">
            <i class="far fa-comments"></i>
            <span class="badge badge-danger navbar-badge">3</span>
        </a>
        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
          <a href="#" class="dropdown-item">
            <!-- Message Start -->
            <div class="media">
              <img src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="User Avatar" class="img-size-50 mr-3 img-circle">
              <div class="media-body">
                <h3 class="dropdown-item-title">
                  Brad Diesel
                </h3>
                <p class="text-sm">Call me whenever you can...</p>
                <p class="text-sm text-muted"><i class="far fa-clock mr-1"></i> 1월 21일</p>
              </div>
            </div>
            <!-- Message End -->
          </a>
          <div class="dropdown-divider"></div>
          <a href="#" class="dropdown-item">
            <!-- Message Start -->
            <div class="media">
              <img src="${pageContext.request.contextPath}/resources/img/user8-128x128.jpg" alt="User Avatar" class="img-size-50 img-circle mr-3">
              <div class="media-body">
                <h3 class="dropdown-item-title">
                  John Pierce
                </h3>
                <p class="text-sm">I got your message bro</p>
                <p class="text-sm text-muted"><i class="far fa-clock mr-1"></i> 1월 21일</p>
              </div>
            </div>
            <!-- Message End -->
          </a>
          <div class="dropdown-divider"></div>
          <a href="#" class="dropdown-item">
            <!-- Message Start -->
            <div class="media">
              <img src="${pageContext.request.contextPath}/resources/img/user3-128x128.jpg" alt="User Avatar" class="img-size-50 img-circle mr-3">
              <div class="media-body">
                <h3 class="dropdown-item-title">
                  Nora Silvester
                </h3>
                <p class="text-sm">The subject goes here</p>
                <p class="text-sm text-muted"><i class="far fa-clock mr-1"></i> 1월 21일</p>
              </div>
            </div>
            <!-- Message End -->
          </a>
          <div class="dropdown-divider"></div>
          <a href="#" class="dropdown-item dropdown-footer">대화창으로 이동</a>
        </div>
      </li>
      
      <!-- 회사명 -->
      <li class="nav-co">
        <p>KHJAVA Co.</p>
      </li>

      <!-- 프로필 -->
      <li id="user-panel" class="nav-item dropdown">
        <a href="" class="d-block image" data-toggle="dropdown"><img src="${pageContext.request.contextPath }/resources/img/profile/${memberLoggedIn.renamedFileName}" alt="User Image"></a>
        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
          <a href="${pageContext.request.contextPath}/member/memberView.do?memberId=${memberLoggedIn.memberId}" id="user-profile" class="dropdown-item">
            <img src="${pageContext.request.contextPath}/resources/img/profile/${memberLoggedIn.renamedFileName}" alt="User Image">
            <div id="user-info">
              <p>${memberLoggedIn.memberName}</p>
              <p>${memberLoggedIn.email}</p>
            </div>
          </a>
          <div class="dropdown-divider"></div>
          <a href="${pageContext.request.contextPath}/member/memberView.do?memberId=${memberLoggedIn.memberId}&active=setting" id="user-settings" class="dropdown-item ">
            <span>계정설정</span>
            프로필, 이메일, 비밀번호, 그 외 더보기... 
          </a>
          <div class="dropdown-divider"></div>
          <a href="${pageContext.request.contextPath}/member/memberLogOut.do" id="logout" class="dropdown-item">로그아웃</a>
        </div> 
      </li>
    </ul>
  </nav>
  
  <!-- Main Sidebar Container -->
  <aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
    <a href="${pageContext.request.contextPath}/notice/noticeList.do" class="brand-link">
      <i class="fas fa-dice-d20 brand-image img-circle elevation-3"></i>
      <span id="logo" class="brand-text font-weight-light">WORKGROUND</span>
    </a>

    <!-- Sidebar -->
    <div class="sidebar">
      <!-- Sidebar Menu -->
      <nav class="mt-2">
        <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/notice/noticeList.do" id="sidebar-notice" class="nav-link active">
              <i class="nav-icon far fa-sticky-note"></i>
              <p>공지</p>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/project/projectList.do"id="sidebar-project" class="nav-link">
              <i class="nav-icon far fa-calendar-check"></i>
              <p>프로젝트</p>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/club/clubList.do" id="sidebar-club" class="nav-link">
              <i class="nav-icon fas fa-snowboarding"></i>
              <p>동호회</p>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/member/memberList.do" id="sidebar-member" class="nav-link">
              <i class="nav-icon fas fa-users"></i>
              <p>멤버</p>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/chat/chatList.do" id="sidebar-chat" class="nav-link">
              <i class="nav-icon far fa-comments"></i>
              <p>대화</p>
            </a>
          </li>
        </ul>
      </nav>
      <!-- /.sidebar-menu -->
    </div>
    <!-- /.sidebar -->
  </aside>
  