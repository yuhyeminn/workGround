<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<script>
var sort; 
var category;

$( document ).ready(function() {
	sort = $("#drop-sort a").html();
	category = $("#drop-category a").html();
	clubFunc();
});

$(document).on('click', '#drop-sort a', function() {
	$("#drop-sort-name").text($(this).text());
	sort = $(this).text();
    clubFunc();
}); 

$(document).on('click', '#drop-category a', function() {
	$("#drop-sort-category").text($(this).text());
	category = $(this).text();
    clubFunc();
}); 


$(function(){
 
	$("#new-club-card").click(function(){
	  $("#modal-new-club").modal();
	});
	
	$("#nav-new-club").click(function(){
	  $("#modal-new-club").modal();
	});
	
	// Summernote
	$('.textarea-intro').summernote({
        focus: true,
        lang: 'ko-KR',
        height: 150,
        toolbar: [
            ['style', ['bold', 'italic', 'underline', 'strikethrough']],
            ['para', ['ul', 'ol']],
            ['insert', ['picture', 'link']]
        ]
    });
	
	sidebarActive(); //사이드바 활성화
	
});

// 새 동호회 클릭시
function modal(){
	$("#modal-new-club").modal();
}

//delete함수
function delClubFunc(clubNo){
	if(!confirm("동호회를 삭제하시겠습니까?")) return false;
	else {
		location.href = "${pageContext.request.contextPath}/club/deleteClub.do?clubNo="+clubNo;
	}
}

//동호회 소개 모달
function clubModalView(clubNo){
	$("#modal-club-"+clubNo).modal();
}

// 동호회 수정 모달
function updateClubModal(clubNo){
	$("#modal-update-"+clubNo).modal();
}

// 동호회 페이지 이동(가입시)
function clubView(clubNo){
	$("#introduce").text('');
	location.href = "${pageContext.request.contextPath}/club/clubView.do?clubNo="+clubNo;
}



//사이드바 활성화
function sidebarActive(){
	let navLinkArr = document.querySelectorAll(".sidebar .nav-link");
	
	navLinkArr.forEach((obj, idx)=>{
		let $obj = $(obj);
		if($obj.hasClass('active'))
			$obj.removeClass('active');
	});
	
	$("#sidebar-club").addClass("active");
}

function clubFunc(){
	$("#all-club-intro").html(''); //데이터 없을 경우 비우기 위함.
	$("#my-club-list").html(''); //데이터 없을 경우 비우기 위함.
	$("#stand-by-club-list").html(''); //데이터 없을 경우 비우기 위함.
	
	$.ajax({
		
		url: "${pageContext.request.contextPath}/club/clubListBySort.do",
		dataType: "json",
		data:{"sort" : sort,
			  "category" : category},
		type: "GET",
		success: data => {
			console.log(data);

			//all club
			//AllClubCountHeader수
			$("#allClubCountHeader").text('('+Object.keys(data.clubList).length+')');
			
			let allClubHtml='';
			$.each(data.clubList,(idx,list)=>{
							
		    	allClubHtml+='<div class="col-12 col-sm-6 col-md-3"><div class="card club card-hover"><div class="card-body"><div class="card-title">'+list.clubName
		    				+'</div>';
		    	
		    	//삭제하기 버튼
		    	if( (list.clubManagerYN != null && list.clubManagerYN.charAt(0) == 'Y')||'${memberLoggedIn.memberId}' == 'admin')
		    	{
			    	allClubHtml+='<div class="card-tools text-right"><button type="button" class="btn btn-tool" data-card-widget="remove"'
		    			   	   +'onclick="delClubFunc('+list.clubNo+')">'
		    			   	   +'<i class="fas fa-times"></i></button></div>';
		    	}
		    	
		    	allClubHtml+='<div class="card-club-image">';		
		    	//이미지
		    	if('${memberLoggedIn.memberId}' == 'admin'){
	
		    	   	if(list.clubPhotoList[0].clubPhotoRenamed!=null){
		    	   		allClubHtml+='<img src="'
			    						+'${pageContext.request.contextPath}/resources/upload/club/'+list.clubNo+'/'+list.clubPhotoList[0].clubPhotoRenamed+'"'
			    						+'onclick="clubView('+list.clubNo+')">';
			    	}
			    	else{
			    		allClubHtml+='<img src="'
			    					+'${pageContext.request.contextPath}/resources/img/club/clubAll.JPG"'
			    					+'onclick="clubView('+list.clubNo+')">';
		    			}
		    	}
		    	
		    	else{
		    	   	if(list.clubPhotoList[0].clubPhotoRenamed!=null){
		    			allClubHtml+='<img src="'
		    						+'${pageContext.request.contextPath}/resources/upload/club/'+list.clubNo+'/'+list.clubPhotoList[0].clubPhotoRenamed+'"'
		    						+'onclick="clubModalView('+list.clubNo+')">';
			    	}
			    	else{
			    		allClubHtml+='<img src="'
			    					+'${pageContext.request.contextPath}/resources/img/club/clubAll.JPG"'
			    					+'onclick="clubModalView('+list.clubNo+')">';
		    		}    	
		    	 	
		    	}
		 
		    	allClubHtml+='</div>';
		    	//동호회 수정
		    	if((list.clubManagerYN != null && list.clubManagerYN.charAt(0) == 'Y')||'${memberLoggedIn.memberId}' == 'admin')
		    	{	
		    		allClubHtml+='<button type="button" id="up-btn" onclick="updateClubModal('+list.clubNo+')">'
    				+'<i class="fas fa-edit"></i></button>';
		    		
		    	}
		    	
		    	allClubHtml+='<div class="category">'
		    				+'<span class="club-category">'+list.clubCategory+'</span></div></div></div></div>';
		    				

	
		    });
			//새 동호회 부분
			allClubHtml+='<div class="col-12 col-sm-6 col-md-3"><div class="card new" id="new-club-card" onclick="modal();"><div class="card-body">'
					   +'<i class="fas fa-plus"></i><h6>새 동호회</h6></div></div></div>';
					   
			// 나의 동호회 부분
			//AllMyClubCount
			$("#myclub-header-count").text('('+Object.keys(data.myClubList).length+')');
			let myClubHtml='';
			
			$.each(data.myClubList,(idx,list)=>{
				
				myClubHtml+='<div class="col-12 col-sm-6 col-md-3"><div class="card club card-hover"><div class="card-body">'
						  +'<div class="card-title">'+list.clubName+'</div>';
						
				//삭제버튼 부분
				if((list.clubManagerYN != null && list.clubManagerYN.charAt(0) == 'Y')||'${memberLoggedIn.memberId}' == 'admin'){

					myClubHtml+='<div class="card-tools text-right"><button type="button" class="btn btn-tool" data-card-widget="remove"'
	    			   	   	  +'onclick="delClubFunc('+list.clubNo+')">'
	    			   	      +'<i class="fas fa-times"></i></button></div>';	
				}
				
				myClubHtml+='<div class="card-club-image">';		
		    	//이미지
		    	if(list.clubPhotoList[0].clubPhotoRenamed!=null){
		    		myClubHtml+='<img src="'
		    						+'${pageContext.request.contextPath}/resources/upload/club/'+list.clubNo+'/'+list.clubPhotoList[0].clubPhotoRenamed+'"'
		    						+'onclick="clubView('+list.clubNo+')">';
		    	}
		    	else{
		    		myClubHtml+='<img src="'
		    					+'${pageContext.request.contextPath}/resources/img/club/clubAll.JPG"'
		    					+'onclick="clubView('+list.clubNo+')">';
		    	}
		    	myClubHtml+='</div>';
		    	
		    	//수정버튼
		    	if((list.clubManagerYN != null && list.clubManagerYN.charAt(0) == 'Y')||'${memberLoggedIn.memberId}' == 'admin')
		    	{	
		    		myClubHtml+='<button type="button" id="up-btn" onclick="updateClubModal('+list.clubNo+')">'
    				+'<i class="fas fa-edit"></i></button>';
		    		
		    	}
		    	
		    	myClubHtml+='<div class="category">'
		    				+'<span class="club-category">'+list.clubCategory+'</span></div></div></div></div>';
		
				
				
				
			});
			
			$("#standBy-header-count").text('('+Object.keys(data.standByClubList).length+')');
			
			//대기 목록 동호회
			let standByClubHtml='';
			$.each(data.standByClubList,(idx,list)=>{
				
				standByClubHtml+='<div class="col-12 col-sm-6 col-md-3"><div class="card club card-hover"><div class="card-body"><div class="card-title">'+list.clubName
		    				+'</div>';
		    	
		    	//삭제하기 버튼
		    	if((list.clubManagerYN != null && list.clubManagerYN.charAt(0) == 'Y')||'${memberLoggedIn.memberId}' == 'admin')
		    	{
		    		standByClubHtml+='<div class="card-tools text-right"><button type="button" class="btn btn-tool" data-card-widget="remove"'
		    			   	   +'onclick="delClubFunc('+list.clubNo+')">'
		    			   	   +'<i class="fas fa-times"></i></button></div>';
		    	}
		    	
		    	standByClubHtml+='<div class="card-club-image">';		
		    	//이미지
		    	if(list.clubPhotoList[0].clubPhotoRenamed!=null){
		    		standByClubHtml+='<img src="'
		    						+'${pageContext.request.contextPath}/resources/upload/club/'+list.clubNo+'/'+list.clubPhotoList[0].clubPhotoRenamed+'"'
		    						+'onclick="clubModalView('+list.clubNo+')">';
		    	}
		    	else{
		    		standByClubHtml+='<img src="'
		    					+'${pageContext.request.contextPath}/resources/img/club/clubAll.JPG"'
		    					+'onclick="clubModalView('+list.clubNo+')">';
		    	}
		    	standByClubHtml+='</div>';
		    	//동호회 수정
		    	if((list.clubManagerYN != null && list.clubManagerYN.charAt(0) == 'Y')||'${memberLoggedIn.memberId}' == 'admin')
		    	{	
		    		standByClubHtml+='<button type="button" id="up-btn" onclick="updateClubModal('+list.clubNo+')">'
    				+'<i class="fas fa-edit"></i></button>';
		    		
		    	}
		    	
		    	standByClubHtml+='<div class="category">'
		    				+'<span class="club-category">'+list.clubCategory+'</span></div></div></div></div>';
	
		    });

			
			
			
			$("#all-club-intro").html(allClubHtml);
			$("#my-club-list").html(myClubHtml);
			$("#stand-by-club-list").html(standByClubHtml);

			
            
		},
		error: (x,s,e)=> {
			console.log(x,s,e);
		}
		
		
		
		
	});
	
	
}



</script>

<style>
/*card*/
.card-club-image img {
	margin-top: 0.5rem;
	width: 100%;
	height: 200px;
	object-fit: cover;
}

.category {
	margin-top: 0.5rem;
	float: right;
}

.card-stand {
	margin-top: 0.5rem;
}

/*modal*/
.modal-club-info {
	color: gray;
}

#modal-image-slider img {
	width: 70%;
	height: 300px;
	margin-bottom: 2rem;
}

#up-btn {
	margin-top: 0.5rem;
	color: #464c59;
}
/*club-form*/
.form-check {
	margin: 0.7rem;
}

#btn-sub {
	margin: 1rem 0 2rem;
	text-align: center;
}
/* nav new club */
#nav-new-club {
	color: white;
	border: none;
	padding: 0.35rem 0.5rem;
	margin-right: 1rem;
	border-radius: 0.25rem;
}
/* new club card */
#new-club-card {
	height: 298x;
	text-align: center;
	padding: 6rem 0rem;
}

#new-club-card .card-body {
	color: #17a2b8;
}

#new-club-card i {
	margin-bottom: .7rem;
	font-size: 30px;
}

#new-club-card:hover {
	background: #17a2b8;
}

#new-club-card:hover .card-body {
	color: #fff;
}

/*meeting-cycle*/
#meeting-cycle {
	width: 20%;
}
.note-editor.note-frame{border: 1px solid #ced4da; border-radius: .25rem;}
</style>

<!-- Navbar Club -->
<nav
	class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
		<ul class="navbar-nav" > 
        <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" data-toggle="dropdown" id="drop-sort-category">
            	전체<span class="caret"></span>
        </a>
        <div class="dropdown-menu" id="drop-category">
            <a class="dropdown-item sort-by-category"  tabindex="-1" ">전체</a>
            <a class="dropdown-item sort-by-category"  tabindex="-1" ">사회</a>
            <a class="dropdown-item sort-by-category"  tabindex="-1" ">문학</a>
            <a class="dropdown-item sort-by-category"  tabindex="-1" ">음식</a>
            <a class="dropdown-item sort-by-category"  tabindex="-1" ">취미</a>
        </div>
        </li>
    </ul>
	<!-- Left navbar links -->


	<!-- Right navbar links -->
	<ul class="navbar-nav ml-auto navbar-nav-sort">
		<li class="nav-item dropdown">정렬 <a
			class="nav-link dropdown-toggle" id="drop-sort-name"
			data-toggle="dropdown" href="#"> 등록일순 <span class="caret"></span>
		</a>
			<div class="dropdown-menu" id="drop-sort">
				<a class="dropdown-item" tabindex="-1" href="#">등록일순</a> <a
					class="dropdown-item" tabindex="-1" href="#">이름순</a>
			</div>
		</li>
		<!-- 새 동호회 만들기 -->
		<li class="nav-item">
			<button id="nav-new-club" class="bg-info" style="font-size: 0.85rem;"
				data-toggle="modal" data-target="#add-project-modal">
				<i class="fa fa-plus"></i> <span>새 동호회</span>
			</button>
		</li>
	</ul>
</nav>
<!-- /.navbar -->

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
	<!-- Main content -->
	<div class="content">
		<div class="container-fluid">

			<!-- 동호회 목록 -->
			<section class="club-all-list">
				<div class="card-header" role="button" onclick="toggleList(this);">
					<h3>
						<i class="fas fa-chevron-down"></i> 동호회 목록 <span
							class="header-count" id="allClubCountHeader"></span>
					</h3>
				</div>
				<!-- /.card-header -->

				<!-- All Club -->
				<div class="row card-content" id="all-club-intro"></div>

			</section>

			<!-- 내가 가입한 동호회 목록 -->
			<section class="my-club">
				<div class="card-header" role="button" onclick="toggleList(this);">
					<h3>
						<i class="fas fa-chevron-down"></i> 내가 가입한 동호회 <span
							class="header-count" id="myclub-header-count"></span>
					</h3>
				</div>

				<!-- /.card-header -->
				<div class="row card-content" id="my-club-list"></div>
			</section>

			<!-- 승인 대기중인 동아리 목록 -->
			<section class="stand-by-club">
				<div class="card-header" role="button" onclick="toggleList(this);">
					<h3>
						<i class="fas fa-chevron-down"></i> 승인 대기중인 동호회 <span
							class="header-count" id="standBy-header-count"></span>
					</h3>
				</div>
				<!-- /.card-header -->

				<div class="row card-content" id="stand-by-club-list"></div>
			</section>

		</div>
		<!-- /.container-fluid -->

		<!-- /.content -->
	</div>
	<!-- /.content-wrapper -->


	<jsp:include page="/WEB-INF/views/club/clubListModal.jsp"></jsp:include>	
	<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>