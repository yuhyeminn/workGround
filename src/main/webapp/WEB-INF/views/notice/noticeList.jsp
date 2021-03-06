<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
<link rel="stylesheet" property="stylesheet" href="${pageContext.request.contextPath}/resources/css/notice.css">
<style>
.navbar-project .dropdown-menu{min-width: 8rem;}
.btn-showAll{float: right; margin-right: 1rem; border: 1.2px solid lightgray; border-radius: 3px; padding: .4rem; font-size: .88rem; color: #8d919a;}
.btn-showAll:hover{color: #464c59;}
.card .dropdown-menu{padding: 0;}
.card .dropdown-item{padding: 0 0 0 1rem; line-height: 40px; color: #464c59;}
.card .dropdown-item.delete{border-top: 1px solid #e9ecef; color: #dc3545;}
.card .dropdown-item.delete:hover, .card .dropdown-item.delete:active, .card .dropdown-item.delete:focus{background-color: #dc3545; color: #fff; border-radius: .25rem;}
.img-circle{object-fit: cover;}
/* 검색 결과 없음 이미지 */
#empty-wrapper{width: 800px; height: 450px; margin: 1rem auto 0; padding: 3rem; background: #fff; border: 1px solid rgba(29,34,43,.1); border-radius: 2px; margin-top: 3rem;}
#empty-wrapper img{display: block; width: 30%; margin: 0 auto;}
#empty-wrapper p{margin-top: 1rem; color: #464c59; font-weigth: bold; text-align: center;}
</style>

<script>
var nowSearchKeyword = '';
var keyword = '';

$(function(){
  	sidebarActive(); //사이드바 활성화
  
  	//첨부파일 수정 시
	$("[name=updateFile]").change(function(){
		console.log($(this).val());
		console.log($(".fname"));
		var filename = $(this).val();
		if($(this).val() != ""){
			console.log("zz");
	 		//$(".fname").hide();
	 		$(".fname").html(filename.substring(filename.lastIndexOf("\\")+1));
			$("#delFileChk").hide().next().hide();
		}else{
			$(".fname").show();
			console.log("aa");
			$("#delFileChk").show().next().show();
		}
	})
	
 	var sortMenu = $("#sort-now").text().trim();
  	sortByMenu(sortMenu);
	
	//정렬(업데이트순/이름순) 클릭 시
	$("#sort-menu a").click(function(){
		$("#sort-now").text($(this).text());
		
		//검색어가 있다면 noticeSearch에서 정렬까지 처리
		if(nowSearchKeyword != ''){
			noticeSearch(nowSearchKeyword);			
		} else {
			sortByMenu($(this).text());
		}
	});
	
	showModal(); //모달 띄우기
});

//사이드바 활성화
function sidebarActive(){
	let navLinkArr = document.querySelectorAll(".sidebar .nav-link");
	
	navLinkArr.forEach((obj, idx)=>{
		let $obj = $(obj);
		if($obj.hasClass('active'))
			$obj.removeClass('active');
	});
	
	$("#sidebar-notice").addClass("active");
}

//모두보기 버튼 클릭
function showAll(type){
	keyword = nowSearchKeyword;
	location.href="${pageContext.request.contextPath}/notice/noticeShowAll.do?keyword="+keyword+"&type="+type;
}

//정렬
function sortByMenu(sortMenu){

	$.ajax({
		url: "${pageContext.request.contextPath}/notice/noticeListBySort.do",
		data: {sortMenu : sortMenu},
		dataType: "json",
		type: "GET",
		success: data => {
			console.log(data);

			listAjax(data);
		},
		error: (x,s,e)=> {
			console.log(x,s,e);
		}
		
	}); //ajax
	
}

//공지 및 게시글 검색
function noticeSearch(searchKeyword){
	
	if(searchKeyword.trim().length == 0){
		alert("검색어를 입력하지 않으셨습니다.");
		return;
	}

	//검색창 초기화
	$("#noticeSearchKeyword").val('');
	//검색어 변수에 검색어 저장(정렬 시 검색어 있는지 구분하기 위해)
	nowSearchKeyword = searchKeyword;
	//현재 정렬 메뉴
	var sortMenu = $("#sort-now").text().trim();
	
	//검색 결과 수 표시
	$("#searchLine").css("display", "block");
	$("#searchLine>h6").css("display", "inline");
	$("#searchLine>h6").text("'"+searchKeyword+"' 검색결과 ");
	
	$.ajax({ 
		url: "${pageContext.request.contextPath}/notice/searchNoticeList.do",
		data: {searchKeyword : searchKeyword, sortMenu : sortMenu},
		dataType: "json",
		type: "GET",
		success: data => {
			console.log(data);
			
			var searchCount = Object.keys(data.noticeList).length + Object.keys(data.deptNoticeList).length + Object.keys(data.communityList).length;
			$("#searchCount").text('총 '+searchCount+'건');
			
			listAjax(data);
			$(".btn-add").css("display", "none"); //추가 버튼 없애기
			
			//검색 결과 없을 경우
			if(Object.keys(data.noticeList).length + Object.keys(data.deptNoticeList).length + Object.keys(data.communityList).length == 0){
				let emptyHtml = '';
				emptyHtml += '<div id="empty-wrapper"><img src="${pageContext.request.contextPath}/resources/img/search-empty-state.png" alt="검색결과 없음" />'
						  + '<p>검색 결과가 없습니다.</p></div>';
				$(".notice-area").html(emptyHtml);
			}
			
		},
		error: (x,s,e) => {
			console.log(x,s,e);
		}
	});
	
}

//리스트 ajax 처리
function listAjax(data){
	
	$(".notice-area").html('');		
	$(".myDeptNotice-area").html('');
	$(".board-area").html('');	
	
	$(".notice-area").css("margin-bottom", "0");
	$(".myDeptNotice-area").css("margin-bottom", "0");
	$(".board-area").css("margin-bottom", "0");
	
	//#1 전체공지(noticeList)
	//$(".notice-area").html
	let noticeHtml = '';
	
	//헤더
	noticeHtml += '<div class="header-line"><h6><i class="fas fa-exclamation-circle"></i>&nbsp; 전체 공지 '
					+'<span class="header-count">('+Object.keys(data.noticeList).length+')</span>'
					+'<i class="fas fa-plus-square btn-add float-right" data-toggle="modal" data-target="#addNoticeModal"';	
	if('${memberLoggedIn.jobTitle}' == '관리자'){
		noticeHtml += 'style = "display:block";></i>';
	}
	else{
		noticeHtml += 'style = "display:none";></i>';
	}
	
	if(Object.keys(data.noticeList).length > 12){
		noticeHtml += '<button class="btn-showAll" onclick=showAll("total");>모두보기</button>';
	}
	noticeHtml += '</h6></div>';
	
	//슬라이드 바
	noticeHtml += '<div id="notice_indicators" class="carousel slide" data-ride="carousel" data-interval="false">'
					+'<ol class="carousel-indicators">';
	//리스트 null 아닐 시 첫 번째 바는 무조건 나옴
	if(data.noticeList != null){
		noticeHtml += '<li data-target="#notice_indicators" data-slide-to="0" class="active"></li>';
	}
	
 	for(var i=1; i< Math.ceil(Object.keys(data.noticeList).length/4) && i<3; i++){
		noticeHtml += '<li data-target="#notice_indicators" data-slide-to="'+i+'"></li>';
	}
	
	noticeHtml += '</ol><div class="carousel-inner">';
	
	$.each(data.noticeList, (idx, list)=>{
		
		if(idx < 12){
			if(idx+1 == 1){
				noticeHtml += '<div class="row card-content carousel-item active">'; 
			}
			
			if((idx+1)%4 == 1 && (idx+1) != 1){
				noticeHtml += '<div class="row card-content carousel-item">'; 
			}
			
			//카드부분
			noticeHtml += '<div class="col-12 col-sm-6 col-md-3"><div class="card">';
			//: 버튼
			noticeHtml += '<div class="dropleft">'
							+'<button class="btn-moreMenu" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"';
			if('${memberLoggedIn.memberId}' == 'admin'){
				noticeHtml += 'style = "display:block";>';
			}
			else{
				noticeHtml += 'style = "display:none";>';
			}
			noticeHtml += '<i class="fas fa-ellipsis-v"></i></button>';
	
			//수정, 삭제 메뉴
			noticeHtml += '<div class="dropdown-menu">'
							+'<a href="#" class="dropdown-item" data-toggle="modal" data-target="#updateNoticeModal'+list.noticeNo+'">공지 수정</a>'
							+'<a href="javascript:void(0)" onclick="deleteChk('+list.noticeNo+')" class="dropdown-item delete">공지 삭제</a>'
							+'</div></div>';
			
			//카드 바디
			noticeHtml += '<div class="card-body" data-toggle="modal" data-target="#noticeViewModal'+list.noticeNo+'">';
			//이미지
			if(list.noticeRenamedFileName != null && list.noticeRenamedFileName.trim().length != 0){
				noticeHtml += '<img src="${pageContext.request.contextPath}/resources/upload/notice/'+list.noticeRenamedFileName+'" class="card-img-top">';
			}
			
			//카드 제목, 내용
			noticeHtml += '<h5 class="card-title">'+list.noticeTitle+'</h5>'
							+'<p class="card-text">'+list.noticeContent+'</p></div></div></div>';
			
			if((idx+1)%4 == 0 || (idx+1) == Object.keys(data.noticeList).length){
				noticeHtml += '</div>';
			}
			
		}
		
		
	});//$.each(noticeList)
	
	//슬라이드 화살표
	noticeHtml += '</div><i class="fas fa-angle-left slide-arrow slide-arrow-left" data-target="#notice_indicators" data-slide="prev"></i>';
	noticeHtml += '<i class="fas fa-angle-right slide-arrow slide-arrow-right" data-target="#notice_indicators" data-slide="next"></i></div>';
	
	
	//#2 부서 게시글(deptNoticeList)
	//$(".myDeptNotice-area").html
	let deptNoticeHtml = '';
	
	//헤더
	deptNoticeHtml += '<div class="header-line"><h6><span id="myDept"><i class="fas fa-user"></i> &nbsp;'
	if('${memberLoggedIn.deptCode}' == 'D1'){
		deptNoticeHtml += '기획</span>&nbsp; 기획부 게시글 ';
	} else if('${memberLoggedIn.deptCode}' == 'D2'){
		deptNoticeHtml += '디자인</span>&nbsp; 디자인부 게시글 ';
	} else {
		deptNoticeHtml += '개발</span>&nbsp; 개발부 게시글 ';
	}
	
	deptNoticeHtml += '<span class="header-count">('+Object.keys(data.deptNoticeList).length+')</span>'
				   + '<i class="fas fa-plus-square btn-add" data-toggle="modal" data-target="#addNoticeForDeptModal"></i>';
				   
	if(Object.keys(data.deptNoticeList).length > 12){
		deptNoticeHtml += '<button class="btn-showAll" onclick=showAll("dept");>모두보기</button></h6></div>';
	}
	deptNoticeHtml += '</h6></div>';
	
	
	//슬라이드 바
	deptNoticeHtml += '<div id="myDeptNotice_indicators" class="carousel slide" data-ride="carousel" data-interval="false">'
					+'<ol class="carousel-indicators">';
	//리스트 null 아닐 시 첫 번째 바는 무조건 나옴
	if(data.deptNoticeList != null && Object.keys(data.deptNoticeList).length != 0){
		deptNoticeHtml += '<li data-target="#myDeptNotice_indicators" data-slide-to="0" class="active"></li>';
	}

 	for(var i=1; i< Math.ceil(Object.keys(data.deptNoticeList).length/4) && i<3; i++){ 
		deptNoticeHtml += '<li data-target="#myDeptNotice_indicators" data-slide-to="'+i+'"></li>';
	}
	
	deptNoticeHtml += '</ol><div class="carousel-inner">';
	
	
	$.each(data.deptNoticeList, (idx, list)=>{
		
		if(idx < 12){
			if(idx+1 == 1){
				deptNoticeHtml += '<div class="row card-content carousel-item active">'; 
			}
			
			if((idx+1)%4 == 1 && (idx+1) != 1){
				deptNoticeHtml += '<div class="row card-content carousel-item">'; 
			}	
	
			//카드부분
			deptNoticeHtml += '<div class="col-12 col-sm-6 col-md-3"><div class="card">';
			//: 버튼
			deptNoticeHtml += '<div class="dropleft">'
							+'<button class="btn-moreMenu" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"';
			if('${memberLoggedIn.memberId}' == list.noticeWriter || '${memberLoggedIn.memberId}' == 'admin'){
				deptNoticeHtml += 'style = "display:block";>';
			}
			else{
				deptNoticeHtml += 'style = "display:none";>';
			}
			
			deptNoticeHtml += '<i class="fas fa-ellipsis-v"></i></button>';
	
	 		//수정, 삭제 메뉴
			deptNoticeHtml += '<div class="dropdown-menu">'
							+'<a href="#" class="dropdown-item" data-toggle="modal" data-target="#updateDeptNoticeModal'+list.noticeNo+'">게시글 수정</a>'
							+'<a href="javascript:void(0)" onclick="deleteChk('+list.noticeNo+')" class="dropdown-item delete">게시글 삭제</a>'
							+'</div></div>';
			
			//카드 바디
			deptNoticeHtml += '<div class="card-body" data-toggle="modal" data-target="#myDeptNoticeViewModal'+list.noticeNo+'">';
			//이미지
			if(list.noticeRenamedFileName != null && list.noticeRenamedFileName.trim().length != 0){
				deptNoticeHtml += '<img src="${pageContext.request.contextPath}/resources/upload/notice/'+list.noticeRenamedFileName+'" class="card-img-top">';
			}
			
			//카드 제목, 내용
			deptNoticeHtml += '<h5 class="card-title">'+list.noticeTitle+'</h5>'
							+'<p class="card-text">'+list.noticeContent+'</p></div></div></div>';
			
			if((idx+1)%4 == 0 || (idx+1) == Object.keys(data.deptNoticeList).length){
				deptNoticeHtml += '</div>';
			}
		}
		
	}); //$.each(deptNoticeList)
	
	//슬라이드 화살표
	deptNoticeHtml += '</div><i class="fas fa-angle-left slide-arrow slide-arrow-left" data-target="#myDeptNotice_indicators" data-slide="prev"></i>';
	deptNoticeHtml += '<i class="fas fa-angle-right slide-arrow slide-arrow-right" data-target="#myDeptNotice_indicators" data-slide="next"></i></div>';

	

	//#3 커뮤니티(communityList)
	//$(".board-area").html
	let communityHtml = '';
	
	//헤더
	communityHtml += '<div class="header-line"><h6><i class="fas fa-sticky-note"></i>&nbsp; 커뮤니티 '
					+ '<span class="header-count">('+Object.keys(data.communityList).length+')</span>'
					+ '<i class="fas fa-plus-square btn-add" data-toggle="modal" data-target="#addBoardModal"></i>';
	if(Object.keys(data.communityList).length > 12){
		communityHtml += '<button class="btn-showAll" onclick=showAll("commu");>모두보기</button>';
	}
					
	communityHtml += '</h6></div>';
						
	//슬라이드 바
	communityHtml += '<div id="board_indicators" class="carousel slide" data-ride="carousel" data-interval="false">'
					+'<ol class="carousel-indicators">';
	//리스트 null 아닐 시 첫 번째 바는 무조건 나옴
	if(data.communityList != null){
		communityHtml += '<li data-target="#board_indicators" data-slide-to="0" class="active"></li>';
	}
	
 	for(var i=1; i< Math.ceil(Object.keys(data.communityList).length/4) && i<3; i++){ 
		communityHtml += '<li data-target="#board_indicators" data-slide-to="'+i+'"></li>';
	}
	
	communityHtml += '</ol><div class="carousel-inner">';
	
	$.each(data.communityList, (idx, list)=>{
		if(idx < 12){
			
			if(idx+1 == 1){
				communityHtml += '<div class="row card-content carousel-item active">'; 
			}
			
			if((idx+1)%4 == 1 && (idx+1) != 1){
				communityHtml += '<div class="row card-content carousel-item">'; 
			}	
	
			//카드부분
			communityHtml += '<div class="col-12 col-sm-6 col-md-3"><div class="card">';
			//: 버튼
			communityHtml += '<div class="dropleft">'
							+'<button class="btn-moreMenu" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"';
			if('${memberLoggedIn.memberId}' == list.commuWriter || '${memberLoggedIn.memberId}' == 'admin'){
				communityHtml += 'style = "display:block";>';
			}
			else{
				communityHtml += 'style = "display:none";>';
			}
			
			communityHtml += '<i class="fas fa-ellipsis-v"></i></button>';
	
	 		//수정, 삭제 메뉴
			communityHtml += '<div class="dropdown-menu">'
							+'<a href="#" class="dropdown-item" data-toggle="modal" data-target="#updateCommuModal'+list.commuNo+'">게시글 수정</a>'
							+'<a href="javascript:void(0)" onclick="deleteChkforCommu('+list.commuNo+')" class="dropdown-item delete">게시글 삭제</a>'
							+'</div></div>';
			
			//카드 바디
			communityHtml += '<div class="card-body" data-toggle="modal" data-target="#boardViewModal'+list.commuNo+'">';
			//이미지
			if(list.commuRenamedFileName != null && list.commuRenamedFileName.trim().length != 0){
				communityHtml += '<img src="${pageContext.request.contextPath}/resources/upload/community/'+list.commuRenamedFileName+'" class="card-img-top">';
			}
			
			//카드 제목, 내용
			communityHtml += '<h5 class="card-title">'+list.commuTitle+'</h5>'
							+'<p class="card-text">'+list.commuContent+'</p></div></div></div>';
			
			if((idx+1)%4 == 0 || (idx+1) == Object.keys(data.communityList).length){
				communityHtml += '</div>';
			}
		}
		
	}); //$.each(communityList)
	
	//슬라이드 화살표
	communityHtml += '</div><i class="fas fa-angle-left slide-arrow slide-arrow-left" data-target="#board_indicators" data-slide="prev"></i>';
	communityHtml += '<i class="fas fa-angle-right slide-arrow slide-arrow-right" data-target="#board_indicators" data-slide="next"></i></div>';

	if(Object.keys(data.noticeList).length != 0){
		$(".notice-area").html(noticeHtml);		
		$(".notice-area").css("margin-bottom", "3rem");
	}
	
	if(Object.keys(data.deptNoticeList).length != 0){
		$(".myDeptNotice-area").html(deptNoticeHtml);
		$(".myDeptNotice-area").css("margin-bottom", "3rem");
	}
	
	if(Object.keys(data.communityList).length != 0){
		$(".board-area").html(communityHtml);	
		$(".board-area").css("margin-bottom", "3rem");
	}
	
}


function deleteChk(noticeNo){
	var result = confirm("게시글을 삭제하시겠습니까?"); 
	if(result == true){
		location.href = "${pageContext.request.contextPath}/notice/deleteNotice.do?noticeNo="+noticeNo;
	}
}

function deleteChkforCommu(commuNo){
	var result = confirm("게시글을 삭제하시겠습니까?"); 
	if(result == true){
		location.href = "${pageContext.request.contextPath}/notice/deleteCommunity.do?commuNo="+commuNo;
	}
}

//답글 클릭 시
/* function addLevel2(level1_id){
	var area_level1 = level1_id;
	alert(area_level1);
} */


//공지 댓글 삭제
function deleteNoticeComment(noticeCommentNo){
	if(!confirm("댓글을 삭제하시겠습니까?"))
		return;
	location.href = "${pageContext.request.contextPath}/notice/noticeCommentDelete.do?noticeCommentNo="+noticeCommentNo;
}

//게시판 댓글 삭제
function deleteCommunityComment(communityCommentNo){
	if(!confirm("댓글을 삭제하시겠습니까?"))
		return;
	location.href = "${pageContext.request.contextPath}/community/communityCommentDelete.do?communityCommentNo="+communityCommentNo;

}

//댓글 유효성 검사
function checkComment(commentContent){
	if(commentContent.trim() == 0){
		alert("댓글을 입력하지 않으셨습니다!");
		return false;
	}
	return true;
} 

//모달 띄우기
function showModal(){
	//상세보기, 수정 모달
	$(document).on('click', '.card', (e)=>{
		let obj;
		let wrapper;
		if(e.target.tagName==='H5' || e.target.tagName==='P' || e.target.tagName==='IMG') {
			obj = e.target.parentNode;
			wrapper = e.target.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
		}
		else {
			obj = e.target;
			wrapper = e.target.parentNode.parentNode.parentNode.parentNode.parentNode;
		}
		
		let no = $(obj).attr('data-target').split('Modal')[1]*1;
		let boardType;
		
		//게시글 상세보기인 경우
		if(obj.className !== 'dropdown-item'){
			//게시글 타입 설정
			if(wrapper.id==='notice_indicators') boardType = 'total';
			else if(wrapper.id==='myDeptNotice_indicators') boardType = 'dept';
			else boardType = 'community';
			
			let data = {
				modalType: 'show',
				boardType: boardType,
				no: no
			};
			
			ajax(data);
		} 
		//게시글 수정인 경우
		else{
			let target = $(obj).attr('data-target').split('Modal');
			
			//게시글 타입 설정
			if(target[0]==='#updateDeptNotice') boardType = 'dept';
			else boardType = 'community';
			
			let data = {
				modalType: 'modify',
				boardType: boardType,
				no: no
			};
			
			ajax(data);
		} //end of else
			
	});
	
	//추가 모달
	$(document).on('click', '.btn-add', (e)=>{
		let btn = e.target;
		let target = $(btn).attr('data-target').split('Modal')[0];
		let boardType;
		
		//게시글 타입 설정
		if(target==='#addNoticeForDept') boardType = 'dept';
		else boardType = 'community';
		
		let data = {
			modalType: 'add',
			boardType: boardType
		};
		
		ajax(data);
	});
	
	function ajax(data){
		$.ajax({
			url: '${pageContext.request.contextPath}/notice/selectBoardModalOne.do',
			data: data,
			dataTyp: 'html',
			type: 'GET',
			success: data=>{
				$('.modal').remove();
				$('.modal-backdrop').remove();
				$('.content-wrapper').append(data);
				$('.modal').modal();
			},
			error: (x,s,e)=>{
				console.log(x,s,e);
			}
		});
	}
}

</script>

<!-- Navbar NoticeList -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
  <!-- Left navbar links -->
  <!-- SEARCH FORM -->
  <form id="noticeSearchFrm" class="form-inline">
    <div class="input-group input-group-sm">
      <input id="noticeSearchKeyword" class="form-control form-control-navbar" type="search" placeholder="게시판 검색" aria-label="Search"
      	     onkeypress="if(event.keyCode==13) {noticeSearch(noticeSearchKeyword.value); return false;}">
      <div class="input-group-append">
        <button class="btn btn-navbar" type="button" onclick="noticeSearch(noticeSearchKeyword.value)">
          <i class="fas fa-search"></i>
        </button>
      </div>
    </div>
  </form>

  <!-- Right navbar links -->
  <ul class="navbar-nav ml-auto navbar-nav-sort" id="sortUl">
    <li class="nav-item dropdown">
      정렬
      <a id="sort-now" class="nav-link dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
        업데이트순 <span class="caret"></span>
      </a>
      <div id="sort-menu" class="dropdown-menu">
        <a class="dropdown-item" tabindex="-1" href="javascript:void(0)">업데이트순</a>
        <a class="dropdown-item" tabindex="-1" href="javascript:void(0)">제목순</a>
      </div>
    </li>
  </ul>
</nav>
<!-- /.navbar -->		

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
  <h2 class="sr-only">공지 목록</h2>
  <!-- Main content -->
  <div class="content">
    <div class="container-fluid">
     <div id="searchLine">
     	  <h6></h6><span id="searchCount"></span>
     </div>
	  <!-- 전체공지 -->
	  <section class="notice-area"></section>

      <!-- 내가 속한 부서 공지 -->
      <section class="myDeptNotice-area"></section>

      <!-- 자유게시판 -->
      <section class="board-area"></section>

    </div><!-- /.container-fluid -->
  </div><!-- /.content -->
</div>
<!-- /.content-wrapper -->

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>