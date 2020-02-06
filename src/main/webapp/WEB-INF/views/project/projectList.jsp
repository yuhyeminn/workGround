<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.kh.workground.project.model.vo.*, com.kh.workground.member.model.vo.* " %>
<%
	Map<String, List<Project>> projectMap = (Map<String, List<Project>>)request.getAttribute("projectMap");
	
	pageContext.setAttribute("listByDept", projectMap.get("listByDept")); //부서 전체 프로젝트(최근 프로젝트)
	pageContext.setAttribute("listByImportant", projectMap.get("listByImportant")); //중요 표시된 프로젝트 조회
	pageContext.setAttribute("listByInclude", projectMap.get("listByInclude")); //내가 속한 프로젝트
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<link rel="stylesheet" property="stylesheet" href="${pageContext.request.contextPath}/resources/css/hyemin.css">

<script>
$(function(){
	sidebarActive(); //사이드바 활성화
	addMember(); //프로젝트 팀원 추가
});

//사이드바 활성화
function sidebarActive(){
	let navLinkArr = document.querySelectorAll(".sidebar .nav-link");
	
	navLinkArr.forEach((obj, idx)=>{
		let $obj = $(obj);
		if($obj.hasClass('active'))
			$obj.removeClass('active');
	});
	
	$("#sidebar-project").addClass("active");
}

//프로젝트 팀원 추가
function addMember(){
	var empData = [
		<c:forEach items="${memberListByDept}" var="m" varStatus="vs">
	  		{id: '${m.memberId}', name:'${m.memberName}', dept: '${m.deptTitle}', profile: 'profile.jfif'}${vs.last?"":","}
        </c:forEach>
  ] 
  // initialize MultiSelect component
  var listObj = new ej.dropdowns.MultiSelect({
      dataSource: empData,
      fields: { text: 'name', value: 'id' },
      itemTemplate: '<div><img class="empImage img-circle img-sm-profile" src="${pageContext.request.contextPath}/resources/img/profile.jfif" width="35px" height="35px"/>' +
      '<div class="ename"> ${name} </div><div class="job"> ${dept} </div></div>',
      valueTemplate: '<div style="width:100%;height:100%;">' +
          '<img class="value" src="${pageContext.request.contextPath}/resources/img/${profile}" height="26px" width="26px"/>' +
          '<div class="name"> ${name}</div></div>',
      placeholder: 'Select Project member',
      mode: 'Box'
  });
  listObj.appendTo('#addMember');
}
</script>

<!-- Navbar Project -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
    <!-- Left navbar links -->
    <ul class="navbar-nav">
        <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#">
            전체 프로젝트 (${fn:length(listByDept)}) <span class="caret"></span>
        </a>
        <div class="dropdown-menu">
            <a class="dropdown-item" tabindex="-1" href="#">전체 프로젝트 (${fn:length(listByDept)})</a>
            <a class="dropdown-item" tabindex="-1" href="#">계획됨 (${statusCntMap['계획됨']}) <span class="status-dot bg-warning"></span></a>
            <a class="dropdown-item" tabindex="-1" href="#">진행중 (${statusCntMap['진행중']}) <span class="status-dot bg-success"></span></a>
            <a class="dropdown-item" tabindex="-1" href="#">완료됨 (${statusCntMap['완료됨']}) <span class="status-dot bg-info"></span></a>
            <a class="dropdown-item" tabindex="-1" href="#">상태없음 (${statusCntMap['상태없음']})</a>
        </div>
        </li>
    </ul>

    <!-- Right navbar links -->
    <ul class="navbar-nav ml-auto navbar-nav-sort">
        <!-- 정렬 -->
        <li class="nav-item dropdown">
        정렬
        <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#">
            이름순 <span class="caret"></span>
        </a>
        <div class="dropdown-menu">
            <a class="dropdown-item" tabindex="-1" href="#">업데이트순</a>
            <a class="dropdown-item" tabindex="-1" href="#">이름순</a>
        </div>
        </li>
        <!-- 새 프로젝트 만들기 -->
        <li class="nav-item add-project">
        <button id="add-project" class="bg-info" style="font-size:0.85rem;" data-toggle="modal" data-target="#add-project-modal">
            <i class="fa fa-plus"></i>
            <span>새 프로젝트</span>
        </button>  
        </li>	
    </ul>
</nav>
<!-- /.navbar -->

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <h2 class="sr-only">프로젝트 목록</h2>
    <!-- Main content -->
    <div class="content">
        <div class="container-fluid">
        <!-- 최근 프로젝트 -->
        <section id="project-recent">
            <div class="card-header" role="button" tabindex="0" onclick="toggleList(this);">
                <h3><i class="fas fa-chevron-down"></i> 최근 프로젝트</h3>
            </div><!-- /.card-header -->
            <div class="row card-content">
            
            <c:forEach items="${listByDept}" var="p">
	            <div class="col-12 col-sm-6 col-md-3">
	                <div class="card card-hover">
	                <a href="${pageContext.request.contextPath}/project/projectView.do?projectNo=${p.projectNo}">
	                <%-- <a href="${pageContext.request.contextPath}/project/projectView.do"> --%>
	                    <div class="card-body">
	                    <div class="card-title">
	                        <h5>${p.projectTitle}</h5>
	                    </div>
	                    </div>
	                </a>
	                </div><!-- /.card -->
	            </div>
	        </c:forEach> 
	        
	        </div><!-- /.card-content -->
        </section>

        <!-- 중요 표시된 프로젝트 -->
        <section id="project-important">
            <div class="card-header" role="button" tabindex="0" onclick="toggleList(this);">
            <h3><i class="fas fa-chevron-down"></i> <i class="fas fa-star"></i> 중요 표시된 프로젝트 <span class="header-count">(${fn:length(listByImportant)})</span></h3>
            </div><!-- /.card-header -->
            <div class="row card-content">
            
            <c:forEach items="${listByImportant}" var="p">
            <div class="col-12 col-sm-6 col-md-3">
                <div class="card card-hover">
                    <a href="${pageContext.request.contextPath}/project/projectView.do?projectNo=${p.projectNo}">
                    <div class="card-body">
                        <!-- 타이틀 -->
                        <div class="card-title">
                        <h5>${p.projectTitle}</h5>
                        </div>
                        <!-- 중요표시 -->
                        <div class="card-star text-right">
                        <i class="fas fa-star"></i>
                        </div>
                        <!-- 프로젝트 상태 / 마감일 -->
                        <div class="card-status">
                        <span class="btn btn-block btn-sm bg-${p.projectStatusColor}">${p.projectStatusTitle}</span>
                        <span class="end-date">
                        	<c:if test="${p.projectEndDate!=null}">
                        	<i class="far fa-calendar-alt"></i> 
                        	</c:if>
                        	${p.projectEndDate}
                        </span>
                        </div>
                        <div class="progress-group card-progress">
                        <span class="progress-title"><span class="percent">11%</span> 완료</span>
                        <span class="progress-title float-right"><span>1</span>/<span>9</span> 개 업무</span>
                        <div class="progress progress-sm">
                            <div class="progress-bar bg-info" style="width: 11%"></div>
                        </div>
                        </div>
                    </div>
                    </a>
                </div><!-- /.card -->
            </div>
            </c:forEach>
            
            </div><!-- /.card-content -->
        </section>
        
        <!-- 내가 속한 프로젝트 -->
        <section id="project-in">
            <div class="card-header" role="button" tabindex="0" onclick="toggleList(this);">
            <h3><i class="fas fa-chevron-down"></i> 내가 속한 프로젝트 <span class="header-count">(${fn:length(listByInclude)})</span></h3>
            </div><!-- /.card-header -->
            <div class="row card-content">
            <!-- 내 업무 -->
            <div class="col-12 col-sm-6 col-md-3">
                <div class="card card-hover mywork">
                    <a href="${pageContext.request.contextPath}/project/projectView.do?projectNo=${listByInclude[0].projectNo}">
                    <div class="card-body">
                        <!-- 프로필 사진 -->
                        <%-- <c:if test="${listByInclude[0].originalFileName==null}">
                        <img src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="User Avatar" class="img-circle img-profile">
                        </c:if>
                        <c:if test="${listByInclude[0].originalFileName!=null}"> --%>
                        <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile">
                        <%-- </c:if> --%>
                        <!-- 타이틀 -->
                        <div class="card-title text-center"><h5>${listByInclude[0].projectTitle}</h5></div>
                        <!-- 프로젝트 상태  -->
                        <div class="progress-group card-progress">
	                        <span class="progress-title"><span class="percent">11%</span> 완료</span>
	                        <span class="progress-title float-right"><span>1</span>/<span>9</span> 개 업무</span>
	                        <div class="progress progress-sm">
	                            <div class="progress-bar bg-info" style="width: 11%"></div>
	                        </div>
                        </div>
                    </div>
                    </a>
                </div><!-- /.card -->
            </div>
            
            <!-- 프로젝트 -->
			<c:forEach items="${listByInclude}" begin="1" var="p">
            <div class="col-12 col-sm-6 col-md-3">
                <div class="card card-hover">
                <a href="${pageContext.request.contextPath}/project/projectView.do?projectNo=${p.projectNo}">
                    <div class="card-body">
                    <!-- 타이틀 -->
                    <div class="card-title">
                        <h5>${p.projectTitle}</h5>
                    </div>

                    <!-- 중요표시 -->
                    <div class="card-star text-right">
                    </div>

                    <!-- 프로젝트 상태 / 마감일 -->
                    <div class="card-status">
                        <span class="btn btn-block btn-sm bg-${p.projectStatusColor}">${p.projectStatusTitle}</span>
                        <span class="end-date">
                        	<c:if test="${p.projectEndDate!=null}">
                        	<i class="far fa-calendar-alt"></i> 
                        	</c:if>
                        	${p.projectEndDate}
                        	</span>
                    </div>
                    <div class="progress-group card-progress">
                        <span class="progress-title"><span class="percent">11%</span> 완료</span>
                        <span class="progress-title float-right"><span>1</span>/<span>9</span> 개 업무</span>
                        <div class="progress progress-sm">
                        <div class="progress-bar bg-info" style="width: 11%"></div>
                        </div>
                    </div>
                    </div><!-- /.card-body -->
                </a>
                </div><!-- /.card -->
            </div>
            </c:forEach> 
            
            <!-- 새 프로젝트 추가 -->
            <div class="col-12 col-sm-6 col-md-3">
                <div class="card addpr-hover" data-toggle="modal" data-target="#add-project-modal">
                <div class="card-body addpr-center">
                    <i class="fa fa-plus" style="font-size:30px;"></i>
                    <h6>새 프로젝트</h6>
                </div>
                </div><!-- /.card -->
            </div>
            </div><!-- /.card-content -->
        </section>
        </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->
		
<!-- 새 프로젝트 모달창 -->
<div class="modal fade" id="add-project-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">새 프로젝트</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <!-- modal body -->
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/project/addProject.do" id="addProjectFrm" method="POST">
                <div class="form-group">
                    <label for="projectTitle" class="col-form-label">제목</label>
                    <input type="text" class="form-control" id="projectTitle" name="projectTitle">
                </div>
                <div class="form-group">
                    <label for="projectDescribe" class="col-form-label">설명(선택사항)</label>
                    <input type="text" class="form-control" id="projectDescribe" name="projectDesc">
                </div>
                <div class="form-group">
                    <label for="projectMember">프로젝트 멤버(선택사항)</label>
                    <div class='control-wrapper'>
                        <div class="control-styles">
                            <input type="text" tabindex="1" id='addMember' name="projectMember"/>
                        </div>
                    </div>
                    <div class="row justify-content-md-center">
                    <button type="submit" class="btn bg-info add-submit">프로젝트 만들기</button>
                    </div>
                </div>
                </form>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>		

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>