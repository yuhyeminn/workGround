<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<link rel="stylesheet" property="stylesheet" href="${pageContext.request.contextPath}/resources/css/hyemin.css">

<script>
$(()=>{
	sidebarActive(); //사이드바 활성화
	projectStar(); //프로젝트 별 해제/등록
    addWork(); //새 업무 만들기
    checklist(); //체크리스트 체크
    addWorklist(); //새 업무리스트 만들기
    tabActive(); //서브헤더 탭 활성화
    goTabMenu(); //서브헤더 탭 링크 이동
    
    setting(); //설정창- 나중에 수정
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

//프로젝트 별 해제/등록
function projectStar(){
    let btnStar = document.querySelector("#btn-star .fa-star");

    btnStar.addEventListener('click', (e)=>{
        let $this = $(e.target);

        //프로젝트 중요표시 되어있는 경우
        if($this.hasClass('fas')){
            $this.removeClass('fas').addClass('far');
        }
        //프로젝트 중요표시 안되어있는 경우 
        else{
            $this.removeClass('far').addClass('fas');
        }
    });
}

//새 업무 만들기
function addWork(){
    //새 업무 만들기: +버튼 클릭
    $(".btn-addWork").on('click', e=>{
        let worklistTitle = e.target.parentNode.parentNode.parentNode;
        let $addWork = $(worklistTitle).find(".addWork-wrapper");
        $addWork.toggleClass("show");
    });

    //새 업무 만들기: 취소버튼 클릭
    $(".btn-addWork-cancel").on('click', ()=>{
        $(".addWork-wrapper").toggleClass("show");
    });

    //새업무 만들기: 날짜 설정
    $('.btn-setWorkDate').daterangepicker();
}

//체크리스트 체크
function checklist(){
    let $btnCheck = $(".btn-check");

    $(".btn-check").on('click', e=>{
        let checkbox = e.target;
        let $tr = $(checkbox.parentNode.parentNode.parentNode);
        let $tdChecklist = $(checkbox.parentNode.parentNode.nextSibling.nextSibling);

        //클릭한 대상이 i태그일 경우에만 적용
        if(checkbox.tagName==='I')
            $tr.toggleClass('completed');

        //완료된 체크리스트인 경우 
        if($tr.hasClass('completed')){
            //체크박스 변경
            $(checkbox).removeClass('far fa-square');
            $(checkbox).addClass('fas fa-check-square');

            //리스트에 줄 긋기
            $tdChecklist.css('text-decoration', 'line-through');
        }
        //미완료된 체크리스트인 경우
        else{
            if(checkbox.tagName=='I'){
                //체크박스 변경
                $(checkbox).removeClass('fas fa-check-square');
                $(checkbox).addClass('far fa-square');

                //리스트에 줄 해제
                $tdChecklist.css('text-decoration', 'none');
            }
        }

    }); //end of .btn-check click
}

//새 업무리스트 만들기
function addWorklist(){
    let addWklt = document.querySelector("#add-wklt-wrapper");
    let addWkltFrm = document.querySelector("#add-wkltfrm-wrapper");
    let btnAdd = document.querySelector("#btn-addWorklist");
    let btnCancel = document.querySelector("#btn-cancel-addWorklist");

    //업무리스트 추가 클릭시 입력폼 보이기
    addWklt.addEventListener('click', ()=>{
        $(addWklt).hide();
        $(addWkltFrm).show();
    });

    //x버튼 클릭시 다시 업무리스트 추가 보이기
    btnCancel.addEventListener('click', ()=>{
        $(addWklt).show();
        $(addWkltFrm).hide();
    });

    //+버튼 클릭시 업무리스트 추가
    btnAdd.addEventListener('click', ()=>{
        console.log(111111);
        //에이작스!? 
    });
}

//서브헤더 탭 active
function tabActive(){
    let tabArr = document.querySelectorAll("#navbar-tab li");

    tabArr.forEach((obj, idx)=>{
        let $obj = $(obj);
        if($obj.hasClass('active')){
            $obj.removeClass('active');
        }
    });

    $("#tab-work").addClass("active");
}

//서브헤더 탭 페이지로 이동
function goTabMenu(){
	let contentWrapper = document.querySelector(".content-wrapper");
	let btnWork = document.querySelector("#btn-tab-work");
	let btnTimeline = document.querySelector("#btn-tab-timeline");
	let btnAnalysis = document.querySelector("#btn-tab-analysis");
	let btnAttach = document.querySelector("#btn-tab-attach");
	
	btnWork.addEventListener('click', e=>{
		location.href = "${pageContext.request.contextPath}/project/projectView.do";	
	});
	
	btnAnalysis.addEventListener('click', e=>{
		location.href = "${pageContext.request.contextPath}/project/projectAnalysis.do";	
	});
	
	/* btnAttach.addEventListener('click', e=>{
		location.href = "${pageContext.request.contextPath}/project/projectAttachment.do";	
	}); */
	
	
	//파일 탭
	btnAttach.addEventListener('click', e=>{
		$.ajax({
			url: "${pageContext.request.contextPath}/project/projectAttachment.do",
			type: "get",
			dataType: "html",
			success: data => {
				console.log(data);
				
				$(contentWrapper).html("");
				$(contentWrapper).html(data); 
				
			},
			error: (x,s,e) => {
				console.log(x,s,e);
			}
		});
	}); 
}

function setting(){
    $("#workDate").daterangepicker({
    });

    $("#projectStartDate").datepicker({
        todayHighlight: true,
        format: 'yyyy/mm/dd',
        uiLibrary: 'bootstrap4'
        
        });
    $("#projectEndDate").datepicker({
        todayHighlight: true,
        format: 'yyyy/mm/dd',
        uiLibrary: 'bootstrap4'
        });
    $("#projectRealEndDate").datepicker({
        todayHighlight: true,
        format: 'yyyy/mm/dd',
        uiLibrary: 'bootstrap4'
        });
    $('#psidebar-toggle').on('expanded.controlsidebar', function(){
        var $side = $("#work-setting-sidebar");
        $side.stop(true).animate({right:'-520px'});
        });
    //업무 사이드바 닫기
    $(".div-close").on('click',()=>{
        var $side = $("#work-setting-sidebar");
        if($side.hasClass('open')) {
            $side.stop(true).animate({right:'-520px'});
            $side.removeClass('open');
        }
    });
    //업무 사이드바 열기
    $(".work-item").on('click', ()=>{
        var $side = $("#work-setting-sidebar");
        $side.addClass('open');
        if($side.hasClass('open')) {
        if($("body").hasClass('control-sidebar-slide-open')){
            $("#psidebar-toggle").click();
        }
        $side.stop(true).animate({right:'0px'});
        }
    });
    // 프로젝트 관리자(팀장) 해당 부서 팀원들
    var empData = [
                { id: '1', name:'이단비', dept: '개발팀', profile:'profile.jfif' },
                { id: '2', name:'유혜민', dept: '개발팀', profile: 'profile.jfif' },
                { id: '3', name:'이소현', dept: '개발팀', profile: 'profile.jfif' },
                { id: '4', name:'이주현', dept: '개발팀', profile: 'profile.jfif' },
                { id: '5', name:'주보라', dept: '개발팀', profile: 'profile.jfif' },
                { id: '6', name:'김효정', dept: '개발팀', profile: 'profile.jfif' },
                { id: '7', name:'임하라', dept: '개발팀', profile: 'profile.jfif' },
                { id: '8', name:'정영균', dept: '개발팀', profile: 'profile.jfif' },
                { id: '9', name:'장예찬', dept: '디자인팀', profile: 'profile.jfif' }
    ];

        // initialize MultiSelect component
        var listObj = new ej.dropdowns.MultiSelect({
            dataSource: empData,
            fields: { text: 'name', value: 'id' },
            itemTemplate: '<div><img class="empImage img-circle img-sm-profile" src="dist/img/${profile}" width="35px" height="35px" style="margin-right:0px;"/>' +
            '<div class="ename" style="font-weight:bold;"> ${name} </div><div class="job"> ${dept} </div></div>',
            valueTemplate: '<div style="width:100%;height:100%;">' +
                '<img class="value" src="dist/img/${profile}" height="26px" width="26px"/>' +
                '<div class="name"> ${name}</div></div>',
            value:['1','2','3'],
            mode: 'Box'
        });
        listObj.appendTo('#projectMember');

        // 각 부서별 팀장
        var empManagerData = [
                { id: '1', name:'이단비', dept: '개발팀', profile:'profile.jfif' },
                { id: '8', name:'정영균', dept: '개발팀', profile: 'profile.jfif' },
                { id: '9', name:'장예찬', dept: '디자인팀', profile: 'profile.jfif' },
                { id: '15', name:'유찬호', dept: '기획팀', profile: 'profile.jfif' }
    ];

        // initialize MultiSelect component
        var managerlistObj = new ej.dropdowns.MultiSelect({
            dataSource: empManagerData,
            fields: { text: 'name', value: 'id' },
            itemTemplate: '<div><img class="empImage img-circle img-sm-profile" src="dist/img/${profile}" width="35px" height="35px" style="margin-right:0px;"/>' +
            '<div class="ename" style="font-weight:bold;"> ${name} </div><div class="job"> ${dept} </div></div>',
            valueTemplate: '<div style="width:100%;height:100%;">' +
                '<img class="value" src="dist/img/${profile}" height="26px" width="26px"/>' +
                '<div class="name"> ${name}</div></div>',
            value:['1'],
            mode: 'Box'
        });
        managerlistObj.appendTo('#projectManager');

        // 해당 프로젝트 팀원
        var workMemberData = [
                { id: '1', name:'이단비', dept: '개발팀', profile:'profile.jfif' },
                { id: '2', name:'유혜민', dept: '개발팀', profile: 'profile.jfif' },
                { id: '3', name:'이소현', dept: '개발팀', profile: 'profile.jfif' },
                { id: '4', name:'이주현', dept: '개발팀', profile: 'profile.jfif' },
                { id: '5', name:'주보라', dept: '개발팀', profile: 'profile.jfif' },
                { id: '6', name:'김효정', dept: '개발팀', profile: 'profile.jfif' }
    ];

        // initialize MultiSelect component
        var workMemberlistObj = new ej.dropdowns.MultiSelect({
            dataSource: workMemberData,
            fields: { text: 'name', value: 'id' },
            itemTemplate: '<div><img class="empImage img-circle img-sm-profile" src="dist/img/${profile}" width="35px" height="35px" style="margin-right:0px;"/>' +
            '<div class="ename" style="font-weight:bold;"> ${name} </div><div class="job"> ${dept} </div></div>',
            valueTemplate: '<div style="width:100%;height:100%;">' +
                '<img class="value" src="dist/img/${profile}" height="26px" width="26px"/>' +
                '<div class="name"> ${name}</div></div>',
            value:['1'],
            mode: 'Box'
        });
        workMemberlistObj.appendTo('#workMember');
}
</script>		

<!-- Navbar Project -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light navbar-project navbar-projectView">
    <!-- Left navbar links -->
    <ul class="navbar-nav">
    <li id="go-back" class="nav-item text-center">
        <a class="nav-link" href=""><i class="fas fa-chevron-left"></i></a>
    </li>
    <li id="project-name" class="nav-item">
        <button type="button" id="btn-star"><i class="fas fa-star"></i></button>
        기획
    </li>
    </ul>

    <!-- Middle navbar links -->
    <ul id="navbar-tab" class="navbar-nav ml-auto">
        <li id="tab-work" class="nav-item"><button type="button" id="btn-tab-work">업무</button></li>
        <li id="tab-timeline" class="nav-item"><button type="button" id="btn-tab-timeline">타임라인</button></li>
        <li id="tab-analysis" class="nav-item"><button type="button" id="btn-tab-analysis">분석</button></li>
        <li id="tab-attachment" class="nav-item"><button type="button" id="btn-tab-attach">파일</button></li>
    </ul>

    <!-- Right navbar links -->
    <ul id="viewRightNavbar-wrapper" class="navbar-nav ml-auto">
        <!-- 프로젝트 대화 -->
        <li class="nav-item">
            <button type="button" class="btn btn-block btn-default btn-xs nav-link">
                <i class="far fa-comments"></i> 프로젝트 대화
            </button>
        </li>

        <!-- 프로젝트 멤버 -->
        <li id="nav-member" class="nav-item dropdown">
            <a class="nav-link" data-toggle="dropdown" href="#">
                <i class="far fa-user"></i> 6
            </a>
            <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
            <a href="#" class="dropdown-item">
                <!-- Message Start -->
                <div class="media">
                <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                <div class="media-body">
                    <p class="memberName">Brad Diesel</p>
                </div>
                </div>
                <!-- Message End -->
            </a>
            <a href="#" class="dropdown-item">
                <!-- Message Start -->
                <div class="media">
                <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                <div class="media-body">
                    <p class="memberName">Brad Diesel</p>
                </div>
                </div>
                <!-- Message End -->
            </a>
            <a href="#" class="dropdown-item">
                <!-- Message Start -->
                <div class="media">
                <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                <div class="media-body">
                    <p class="memberName">Brad Diesel</p>
                </div>
                </div>
                <!-- Message End -->
            </a>
            <a href="#" class="dropdown-item">
                <!-- Message Start -->
                <div class="media">
                <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                <div class="media-body">
                    <div class="media-body">
                    <p class="memberName">Brad Diesel</p>
                    </div>
                </div>
                </div>
                <!-- Message End -->
            </a>
            <a href="#" class="dropdown-item">
                <!-- Message Start -->
                <div class="media">
                <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                <div class="media-body">
                    <p class="memberName">Brad Diesel</p>
                </div>
                </div>
                <!-- Message End -->
            </a>
            </div>
        </li>

        <!-- 프로젝트 설정 -->
        <li class="nav-item">
            <button type="button" class="btn btn-block btn-default btn-xs nav-link" id="psidebar-toggle" data-widget="control-sidebar" data-slide="true">
            	<i class="fas fa-cog"></i>
            </button>
        </li>
    </ul>
</nav>
<!-- /.navbar -->

<!-- 프로젝트 설정 사이드 바-->
<aside class="control-sidebar project-setting" style="display: block;">
    
</aside> 

<!-- 업무 설정 사이드 바-->
<aside class="work-setting" id="work-setting-sidebar" style="display: block;">
    <div class="div-close" role="button" tabindex="0">
    <i class="fas fa-times close-sidebar"></i>
    </div>
    <!-- Control sidebar content goes here -->
    <div class="p-3">
    <i class="fas fa-star"></i>
    <span class="setting-side-title">업무1</span>
    <p class="setting-contents-inform">
        <span>#2</span>
        <span>작성자 이단비</span>
        <span class="setting-contents-date">작성일 2020-01-27</span>
    </p>
    </div>
    
    <ul class="nav work-setting-tabs nav-tabs" id="custom-content-above-tab" role="tablist">
        <li class="nav-item setting-navbar-tab">
        <button type="button" id="custom-content-work-setting-tab" data-toggle="pill" href="#custom-content-work-setting" role="tab" aria-controls="custom-content-work-setting" aria-selected="true">속성</button>
        </li>
        <li class="nav-item setting-navbar-tab">
        <button type="button" id="custom-content-above-comment-tab" data-toggle="pill" href="#custom-content-above-comment" role="tab" aria-controls="custom-content-above-comment" aria-selected="false">코멘트</button>
        </li>
        <li class="nav-item setting-navbar-tab">
        <button type="button" id="custom-content-above-file-tab" data-toggle="pill" href="#custom-content-above-file" role="tab" aria-controls="custom-content-file-comment" aria-selected="false">파일</button>
        </li>
    </ul>
    <div class="tab-content" id="custom-content-above-tabContent">
        <!-- 업무 속성 탭-->
        <div class="tab-pane fade show active p-setting-container" id="custom-content-work-setting" role="tabpanel" aria-labelledby="custom-content-work-setting-tab">
            <div class="row setting-row add-description">
            <span>설명 추가</span>
            </div>
            <hr/>
            <div class="setting-row">
            <!-- 업무 위치 -->
            <div class="row">
                <label class="setting-content-label"><span class="label-icon"><i class='far fa-folder-open' style="width:20px;"></i></span> 위치</label>
                
                <!-- plus 버튼 눌렀을 때 dropdown-->
                <div class="add-member-left dropdown">
                    <button class="plusBtn" data-toggle="dropdown"><i class="fas fa-pencil-alt"></i></button>
                    <div class="dropdown-menu location-dropdown"  aria-labelledby="dropdownMenuLink">
                    <span>업무리스트</span>  
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" tabindex="-1" href="#">해야할 일</a>
                    <a class="dropdown-item" tabindex="-1" href="#">진행중</a>
                    <a class="dropdown-item" tabindex="-1" href="#">완료됨 </a>
                    </div>
                </div>
                        <p class="setting-content-inform">
                            <span>기획</span> <i class="fa fa-angle-double-right"></i> <span>해야할 일</span>
                        </p>
            </div>
            <!-- 업무 날짜 -->
            <div class="row">
                <label class="setting-content-label"><span><i class="far fa-calendar-alt" style="width:20px;"></i></span> 날짜 설정</label>
                <div class="dropdown">
                    <button class="plusBtn" data-toggle="dropdown"><i class="fas fa-cog"></i></button>
                    <div class="dropdown-menu setting-date-dropdown work-date-dropdown">
                        <div class="form-group">
                        <div class="input-group" >
                            <input type="text" class="form-control float-right" id="workDate" name="workDate"> 
                        </div>
                        </div>
                        <button class="btn bg-info date-update" type="button">수정</button>
                        <button class="btn bg-secondary date-cancel">취소</button>
                </div>
                </div>
                    
                    <p class="setting-content-inform">
                        2020/01/15 - 2020/01/19
                    </p>
            </div>
            <!-- 배정된 멤버-->
            <div class="row">
                <label class="setting-content-label"><span><i class='fas fa-user-plus' style="width:20px;"></i></span> 배정된 멤버</label>
                <button class="plusBtn" id="add-work-member"><i class="fa fa-plus"></i></button>
                <div class='control-wrapper pv-multiselect-box'>
                    <div class="control-styles">
                        <input type="text" tabindex="1" id='workMember' name="workMember"/>
                </div>
                </div>
            </div>
            <!-- 태그 -->
            <div class="row">
                <label class="setting-content-label"><span><i class="fa fa-tag" style="width:20px;"></i></span> 태그</label>
                <button class="plusBtn" data-toggle="dropdown"><i class="fa fa-plus"></i></button>
                <div class="work-tag">
                    <span class="btn btn-xs bg-danger">priority</span>
                    <span class="btn btn-xs bg-primary">important</span>
                    <span class="btn btn-xs bg-warning">review</span>
                </div>
                <div class="dropdown-menu work-setting-tag">
                    <a class="dropdown-item" tabindex="-1" href="#"><span class="btn btn-xs bg-danger">priority</span></a>
                    <a class="dropdown-item" tabindex="-1" href="#"><span class="btn btn-xs bg-primary">important</span></a>
                    <a class="dropdown-item" tabindex="-1" href="#"><span class="btn btn-xs bg-warning">review</span></a>
                </div>
            </div>
            </div>
            <!-- 업무 포인트(중요도) -->
            <div class="row setting-row setting-point">
                <label class="setting-content-label"> <span><i class='fas fa-ellipsis-h' style="width:20px;"></i></span> 포인트</label>
                <div class="dropdown status-dropdown">
                    <button>
                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span>
                    </button>
                    <div class="icon-box"  data-toggle="dropdown">
                    <i class="fa fa-angle-down"></i>
                    </div>
                    <div class="dropdown-menu">
                    <div class="dropdown-item work-importances" tabindex="-1" href="#">
                        <span class="importance-dot checked"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span>
                    </div>
                    <div class="dropdown-item work-importances" tabindex="-1" href="#">
                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span>
                        </div>
                    <div class="dropdown-item work-importances" tabindex="-1" href="#">
                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot"></span> <span class="importance-dot"></span>
                    </div>
                    <div class="dropdown-item work-importances" tabindex="-1" href="#">
                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot"></span>
                        </div>
                    <div class="dropdown-item work-importances" tabindex="-1" href="#">
                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span>
                    </div>
                    </div>
                </div>
            </div>
            <!-- 체크리스트 -->
            <div class="row setting-row checklist-box-row">
            <div class="work-checklist">
                <table class="tbl-checklist">
                <tbody>
                    <tr>
                    <th><button type="button" class="btn-check"><i class="far fa-square"></i></button></th>
                    <td>
                        <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                        체크리스트1
                    </td>
                    </tr>
                    <tr>
                    <th><button type="button" class="btn-check"><i class="far fa-square"></i></button></th>
                    <td>
                        <div class="img-circle img-profile ico-profile" ><i class='fas fa-user-plus' style="width:15px;"></i></div>
                        체크리스트2
                    </td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr>
                    <th><button type="button" class="btn-add-checklist"><i class="fa fa-plus"></i></button></th>
                    <td>
                        <input type="text" name="checklist-content" id="checklist-content" placeholder="체크리스트 아이템 추가하기">
                    </td>
                    </tr>
                </tfoot>
                </table>                
            </div>
            </div>
        </div><!--/end 업무 속성 탭-->

        <!-- 코멘트 탭-->
        <div class="tab-pane fade" id="custom-content-above-comment" role="tabpanel" aria-labelledby="custom-content-above-comment-tab">
        <div class="comment-wrapper">
            <div class="comment-box">
            <div class="card-footer card-comments">
                <div class="card-comment">
                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Image">
                <div class="comment-text">
                    <span class="username">김효정<span class="text-muted float-right">2020-01-26</span></span>
                    <span>오오 감사합니당</span>
                    <button class="comment-delete float-right">삭제</button>
                    <button class="comment-reply float-right">답글</button>
                </div>
                </div>
                <div class="card-comment">
                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Image">
                <div class="comment-text">
                    <span class="username">주보라<span class="text-muted float-right">2020-01-27</span></span>
                    <span>괜찮은데요??</span>
                    <button class="comment-delete float-right">삭제</button>
                    <button class="comment-reply float-right">답글</button>
                </div>
                </div>
                <div class="card-comment comment-level2">
                    <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Image">
                    <div class="comment-text">
                    <span class="username">유혜민<span class="text-muted float-right">2020-01-26</span></span>
                    <span>넵! 알겠습니당</span>
                    <button class="comment-delete float-right">삭제</button>
                    </div>
                </div>
                <div class="card-comment comment-level2">
                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Image">
                <div class="comment-text">
                    <span class="username">이소현<span class="text-muted float-right">2020-01-27</span></span>
                    <span>훨씬 편하네요~</span>
                    <button class="comment-delete float-right">삭제</button>
                </div>
                </div>
            </div>
            </div>
            <!-- 댓글 작성 -->
            <div class="card-footer">
            <form action="#" method="post">
                <img class="img-fluid img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile.jfif">
                <div class="img-push">
                <input type="text" class="form-control form-control-sm comment-text-area" placeholder="댓글을 입력하세요.">
                <input class="comment-submit" type="submit" value="등록">
                </div>
            </form>
            </div> 
        </div> 
        <!--/. end comment-wrapper--> 
        </div>
        <!--/. end 코멘트 tab-->

        <!-- 파일 탭 -->
        <div class="tab-pane fade file-tab-pane " id="custom-content-above-file" role="tabpanel" aria-labelledby="custom-content-above-file-tab">
            <div class="file-wrapper">
            <div class="container-fluid"> 
                <!-- 파일 첨부 -->
                <form action="">
                <div class="input-group work-file-upload-box">
                    <div class="custom-file">
                    <input type="file" class="custom-file-input" id="workInputFile" aria-describedby="inputGroupFileAddon04">
                    <label class="custom-file-label" for="inputGroupFile04">Choose file</label>
                    </div>
                    <div class="input-group-append">
                    <button class="btn btn-outline-secondary" type="button" id="inputGroupFileAddon04">Button</button>
                    </div>
                </div>
                </form>
                <!-- 첨부파일 테이블 -->
                <div id="card-workAttach" class="card">
                <div class="card-body table-responsive p-0">
                    <table id="tbl-projectAttach" class="table table-hover text-nowrap">
                    <thead>
                        <tr>
                        <th>이름</th>
                        <th>공유한 날짜</th>
                        <th>공유한 사람</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                        <td>
                            <a href="">
                            <div class="img-wrapper">
                            <img src="${pageContext.request.contextPath}/resources/img/test.jpg" alt="첨부파일 미리보기 이미지">
                            </div>
                            <div class="imgInfo-wrapper">
                            <p class="filename">file.png</p>
                            <p class="filedir">33.8KB</p>
                            </div>
                            </a>
                        </td>
                        <td>2020년 1월 28일</td>
                        <td>
                            이단비
                            <!-- 첨부파일 옵션 버튼 -->
                            <div class="dropdown ">
                            <button type="button" class="btn-file" data-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></button>
                            <div class="dropdown-menu dropdown-menu-right">
                                <a href="#" class="dropdown-item">
                                다운로드
                                </a>
                                <div class="dropdown-divider"></div>
                                <a href="#" class="dropdown-item dropdown-file-remove">삭제</a>
                            </div>
                            </div>
                        </td>
                        </tr>
                        <tr>
                        <td>
                            <a href="">
                            <div class="img-wrapper">
                            <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="첨부파일 미리보기 이미지">
                            </div>
                            <span class="filename">file.png</span>
                            </a>
                        </td>
                        <td>2020년 1월 28일</td>
                        <td>
                            이단비
                            <!-- 첨부파일 옵션 버튼 -->
                            <div class="dropdown ">
                            <button type="button" class="btn-file" data-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></button>
                            <div class="dropdown-menu dropdown-menu-right">
                                <a href="#" class="dropdown-item">
                                다운로드
                                </a>
                                <div class="dropdown-divider"></div>
                                <a href="#" class="dropdown-item dropdown-file-remove">삭제</a>
                            </div>
                            </div>
                        </td>
                        </tr>
                    </tbody>
                    </table>
                </div>
                <!-- /.card-body -->
                </div>
                <!-- /.card -->
                </div>
                <!-- /.container-fluid -->
            </div> 
            <!--/. end file-wrapper--> 
            </div>

    </div>
</aside>

<!-- Content Wrapper. Contains page content -->
<div id="pjv-content-wrapper" class="content-wrapper projectView-wrapper navbar-light">
    <h2 class="sr-only">프로젝트 일정 상세보기</h2>
    <!-- Main content -->
    <div class="content view">
    <h3 class="sr-only">기획</h3>
    <div class="container-fluid">
        <h4 class="sr-only">업무</h4>
        <!-- SEARCH FORM -->
        <form id="workSearchFrm" class="form-inline">
	        <div class="input-group input-group-sm">
	            <input class="form-control form-control-navbar" type="search" placeholder="업무 검색" aria-label="Search">
	            <div class="input-group-append">
	            <button class="btn btn-navbar" type="submit">
	                <i class="fas fa-search"></i>
	            </button>
	            </div>
	        </div>
        </form>
        
        <!-- 업무리스트: 해야할 일 -->
        <section class="worklist">
            <!-- 업무리스트 타이틀 -->
            <div class="worklist-title">
                <h5>해야할 일</h5>
                <div class="worklist-title-btn">
	                <button type="button" class="btn-addWork" onclick=""><i class="fas fa-plus"></i></button>
	                <button type="button" class="btn-removeWorklist" data-toggle="modal" data-target="#modal-wroklist-remove"><i class="fas fa-times"></i></button>
                </div>

                <!-- 새 업무 만들기 -->
                <div class="addWork-wrapper">
	                <form action="" class="addWorkFrm">
	                    <!-- 업무 타이틀 작성 -->
	                    <textarea name="workTitle" class="addWork-textarea" placeholder="새 업무 만들기"></textarea>
	
	                    <!-- 하단부 버튼 모음 -->
	                    <div class="addWork-btnWrapper">
	                    <!-- 업무 설정 -->
	                    <div class="addWork-btnLeft">
	                        <!-- 업무 배정 -->
	                        <div class="add-tag dropdown">
	                        <a class="nav-link" data-toggle="dropdown" href="#">
	                            <i class="fas fa-user-plus"></i>
	                        </a>
	                        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
	                            <a href="#" class="dropdown-item">
	                            <!-- Message Start -->
	                            <div class="media">
	                                <img src="dist/img/user1-128x128.jpg" alt="User Avatar" class="img-size-50 mr-3 img-circle">
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
	                                <img src="dist/img/user8-128x128.jpg" alt="User Avatar" class="img-size-50 img-circle mr-3">
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
	                        </div>
	                        </div>
	
	                        <!-- 태그 설정 -->
	                        <div class="add-tag dropdown">
	                        <a class="nav-link" data-toggle="dropdown" href="#">
	                            <i class="fas fa-tag"></i>
	                        </a>
	                        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
	                            <a href="#" class="dropdown-item">
	                            <!-- Message Start -->
	                            <div class="media">
	                                <img src="dist/img/user1-128x128.jpg" alt="User Avatar" class="img-size-50 mr-3 img-circle">
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
	                                <img src="dist/img/user8-128x128.jpg" alt="User Avatar" class="img-size-50 img-circle mr-3">
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
	                        </div>
	                        </div>
	
	                        <!-- 날짜 설정 -->
	                        <button type="button" class="btn-setWorkDate"><i class="far fa-calendar-alt"></i></button>
	                    </div>
	
	                    <!-- 취소/만들기 버튼 -->
	                    <div class="addWork-btnRight">
	                        <button type="button" class="btn-addWork-cancel">취소</button>
	                        <button type="submit" class="btn-addWork-submit">만들기</button>
	                    </div>
	                    </div>
	                </form>
                </div>

                <!-- 진행 중인 업무 -->
                <div class="worklist-titleInfo">
                	<p>진행 중인 업무 7개</p>
                </div>
            </div><!-- /.worklist-title -->
            
            <!-- 업무리스트 컨텐츠 -->
            <!-- <div class="wl-contents-wrapper"> -->
            <div class="worklist-contents">
                <!-- 업무 -->
                <section class="work-item" role="button" tabindex="0">
                <!-- 태그 -->
                <div class="work-tag">
                    <span class="btn btn-xs bg-danger">priority</span>
                    <span class="btn btn-xs bg-primary">important</span>
                    <span class="btn btn-xs bg-warning">review</span>
                </div>

                <!-- 업무 타이틀 -->
                <div class="work-title">
                    <!-- <h6><i class="far fa-check-circle title-icon"></i>업무1</h6> -->
                    <h6>업무1</h6>
                    <div class="work-importances">
                    <span class="importance-dot checked"></span>
                    <span class="importance-dot"></span>
                    <span class="importance-dot"></span>
                    <span class="importance-dot"></span>
                    <span class="importance-dot"></span>
                    </div>
                </div>

                <!-- 체크리스트 -->
                <div class="work-checklist">
                    <table class="tbl-checklist">
                    <tbody>
                        <tr>
                        <th><button type="button" class="btn-check"><i class="far fa-square"></i></button></th>
                        <td>
                            <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                            체크리스트1
                        </td>
                        </tr>
                        <tr>
                        <th><button type="button" class="btn-check"><i class="far fa-square"></i></button></th>
                        <td>체크리스트2</td>
                        </tr>
                    </tbody>
                    </table>                
                </div>

                <!-- 날짜 설정 -->
                <div class="work-deadline">
                    <p>1월 23일 - 1월 29일</p>
                    <!-- <p class="over">마감일 3일 지남</p> -->
                    <!-- <p class="complete">1월 22일에 완료</p> -->
                </div>

                <!-- 기타 아이콘 모음 -->
                <div class="work-etc">
                    <span class="ico"><i class="far fa-list-alt"></i> 1/3</span>
                    <span class="ico"><i class="far fa-comment"></i> 0</span>
                    <span class="ico"><i class="fas fa-paperclip"></i> 0</span>
                    <div class="chared-member text-right">
                    <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                    <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                    </div>
                </div>

                <!-- 커버 이미지 -->
                <div class="work-coverImage">
                    <img src="${pageContext.request.contextPath}/resources/img/test.jpg" class="img-cover" alt="test image">
                </div>
                </section><!-- /.work-item -->

                <!-- 업무 -->
                <section class="work-item" role="button" tabindex="0">
                <!-- 태그 -->
                <div class="work-tag">
                    <span class="btn btn-xs bg-danger">priority</span>
                    <span class="btn btn-xs bg-primary">important</span>
                    <span class="btn btn-xs bg-warning">review</span>
                </div>

                <!-- 업무 타이틀 -->
                <div class="work-title">
                    <h6>업무1</h6>
                    <div class="work-importances">
                    <span class="importance-dot checked"></span>
                    <span class="importance-dot"></span>
                    <span class="importance-dot"></span>
                    <span class="importance-dot"></span>
                    <span class="importance-dot"></span>
                    </div>
                </div>

                <!-- 기타 아이콘 모음 -->
                <div class="work-etc">
                    <span class="ico"><i class="far fa-list-alt"></i> 1/3</span>
                    <span class="ico"><i class="far fa-comment"></i> 0</span>
                    <span class="ico"><i class="fas fa-paperclip"></i> 0</span>
                    <div class="chared-member text-right">
                    <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile ml-auto">
                    </div>
                </div>
                </section><!-- /.work-item -->

                <!-- 업무 -->
                <section class="work-item" role="button" tabindex="0">
                <!-- 업무 타이틀 -->
                <div class="work-title">
                    <h6>업무1</h6>
                    <div class="work-importances">
                    <span class="importance-dot checked"></span>
                    <span class="importance-dot"></span>
                    <span class="importance-dot"></span>
                    <span class="importance-dot"></span>
                    <span class="importance-dot"></span>
                    </div>
                </div>

                <!-- 기타 아이콘 모음 -->
                <div class="work-etc">
                    <div class="chared-member text-right">
                    <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile ml-auto">
                    </div>
                </div>
                </section><!-- /.work-item -->
            </div><!-- /.worklist-contents -->
            <!-- </div> -->
        </section><!-- /.worklist -->

        <!-- 업무리스트: 진행중 -->
        <section class="worklist">
            <!-- 업무리스트 타이틀 -->
            <div class="worklist-title">
                <h5>진행중</h5>
                <div class="worklist-title-btn">
                <button type="button" class="btn-addWork"><i class="fas fa-plus"></i></button>
                <button type="button" class="btn-removeWorklist" data-toggle="modal" data-target="#modal-wroklist-remove"><i class="fas fa-times"></i></button>
                </div>

                <!-- 새 업무 만들기 -->
                <div class="addWork-wrapper">
                <form action="" class="addWorkFrm">
                    <!-- 업무 타이틀 작성 -->
                    <textarea name="workTitle" class="addWork-textarea" placeholder="새 업무 만들기"></textarea>

                    <!-- 하단부 버튼 모음 -->
                    <div class="addWork-btnWrapper">
                    <!-- 업무 설정 -->
                    <div class="addWork-btnLeft">
                        <!-- 업무 배정 -->
                        <div class="add-tag dropdown">
                        <a class="nav-link" data-toggle="dropdown" href="#">
                            <i class="fas fa-user-plus"></i>
                        </a>
                        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
                            <a href="#" class="dropdown-item">
                            <!-- Message Start -->
                            <div class="media">
                                <img src="dist/img/user1-128x128.jpg" alt="User Avatar" class="img-size-50 mr-3 img-circle">
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
                                <img src="dist/img/user8-128x128.jpg" alt="User Avatar" class="img-size-50 img-circle mr-3">
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
                        </div>
                        </div>

                        <!-- 태그 설정 -->
                        <div class="add-tag dropdown">
                        <a class="nav-link" data-toggle="dropdown" href="#">
                            <i class="fas fa-tag"></i>
                        </a>
                        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
                            <a href="#" class="dropdown-item">
                            <!-- Message Start -->
                            <div class="media">
                                <img src="dist/img/user1-128x128.jpg" alt="User Avatar" class="img-size-50 mr-3 img-circle">
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
                                <img src="dist/img/user8-128x128.jpg" alt="User Avatar" class="img-size-50 img-circle mr-3">
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
                        </div>
                        </div>

                        <!-- 날짜 설정 -->
                        <button type="button" class="btn-setWorkDate"><i class="far fa-calendar-alt"></i></button>
                    </div>

                    <!-- 취소/만들기 버튼 -->
                    <div class="addWork-btnRight">
                        <button type="button" class="btn-addWork-cancel">취소</button>
                        <button type="submit" class="btn-addWork-submit">만들기</button>
                    </div>
                    </div>
                </form>
                </div>

                <!-- 진행 중인 업무 -->
                <div class="worklist-titleInfo">
                <p>진행 중인 업무 7개</p>
                </div>
            </div><!-- /.worklist-title -->
            
            <!-- 업무리스트 컨텐츠 -->
            <div class="worklist-contents">
                <!-- 업무 -->
                <section class="work-item" role="button" tabindex="0">
                <!-- 업무 타이틀 -->
                <div class="work-title">
                    <!-- <h6><i class="far fa-check-circle title-icon"></i>업무1</h6> -->
                    <h6>업무1</h6>
                    <div class="work-importances">
                    <span class="importance-dot checked"></span>
                    <span class="importance-dot"></span>
                    <span class="importance-dot"></span>
                    <span class="importance-dot"></span>
                    <span class="importance-dot"></span>
                    </div>
                </div>

                <!-- 기타 아이콘 모음 -->
                <div class="work-etc">
                    <div class="chared-member text-right">
                    <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile ml-auto">
                    </div>
                </div>
                </section><!-- /.work-item -->
            </div><!-- /.worklist-contents -->
        </section><!-- /.worklist -->
        
        <!-- 업무리스트: 완료 -->
        <section class="worklist">
            <!-- 업무리스트 타이틀 -->
            <div class="worklist-title">
                <h5>완료</h5>
                <div class="worklist-title-btn">
                <button type="button" class="btn-addWork"><i class="fas fa-plus"></i></button>
                <button type="button" class="btn-removeWorklist" data-toggle="modal" data-target="#modal-wroklist-remove"><i class="fas fa-times"></i></button>
                </div>

                <!-- 새 업무 만들기 -->
                <div class="addWork-wrapper">
                <form action="" class="addWorkFrm">
                    <!-- 업무 타이틀 작성 -->
                    <textarea name="workTitle" class="addWork-textarea" placeholder="새 업무 만들기"></textarea>

                    <!-- 하단부 버튼 모음 -->
                    <div class="addWork-btnWrapper">
                    <!-- 업무 설정 -->
                    <div class="addWork-btnLeft">
                        <!-- 업무 배정 -->
                        <div class="add-tag dropdown">
                        <a class="nav-link" data-toggle="dropdown" href="#">
                            <i class="fas fa-user-plus"></i>
                        </a>
                        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
                            <a href="#" class="dropdown-item">
                            <!-- Message Start -->
                            <div class="media">
                                <img src="dist/img/user1-128x128.jpg" alt="User Avatar" class="img-size-50 mr-3 img-circle">
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
                                <img src="dist/img/user8-128x128.jpg" alt="User Avatar" class="img-size-50 img-circle mr-3">
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
                        </div>
                        </div>

                        <!-- 태그 설정 -->
                        <div class="add-tag dropdown">
                        <a class="nav-link" data-toggle="dropdown" href="#">
                            <i class="fas fa-tag"></i>
                        </a>
                        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
                            <a href="#" class="dropdown-item">
                            <!-- Message Start -->
                            <div class="media">
                                <img src="dist/img/user1-128x128.jpg" alt="User Avatar" class="img-size-50 mr-3 img-circle">
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
                                <img src="dist/img/user8-128x128.jpg" alt="User Avatar" class="img-size-50 img-circle mr-3">
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
                        </div>
                        </div>

                        <!-- 날짜 설정 -->
                        <button type="button" class="btn-setWorkDate"><i class="far fa-calendar-alt"></i></button>
                    </div>

                    <!-- 취소/만들기 버튼 -->
                    <div class="addWork-btnRight">
                        <button type="button" class="btn-addWork-cancel">취소</button>
                        <button type="submit" class="btn-addWork-submit">만들기</button>
                    </div>
                    </div>
                </form>
                </div>

                <!-- 진행 중인 업무 -->
                <div class="worklist-titleInfo">
                	<p>완료된 업무 7개</p>
                </div>
            </div><!-- /.worklist-title -->
            
            <!-- 업무리스트 컨텐츠 -->
            <div class="worklist-contents">
                <!-- 업무 -->
                <section class="work-item" role="button" tabindex="0">
                <!-- 업무 타이틀 -->
                <div class="work-title">
                    <h6>업무1</h6>
                    <div class="work-importances">
                    <span class="importance-dot checked"></span>
                    <span class="importance-dot"></span>
                    <span class="importance-dot"></span>
                    <span class="importance-dot"></span>
                    <span class="importance-dot"></span>
                    </div>
                </div>

                <!-- 기타 아이콘 모음 -->
                <div class="work-etc">
                    <div class="chared-member text-right">
                    <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile ml-auto">
                    </div>
                </div>
                </section><!-- /.work-item -->
            </div><!-- /.worklist-contents -->
        </section><!-- /.worklist --> 

        <!-- 업무리스트 추가 -->
        <section id="add-wklt-wrapper" class="worklist add-worklist" role="button" tabindex="0">
            <!-- 타이틀 -->
            <div class="worklist-title">
                <h5><i class="fas fa-plus"></i> 업무리스트 추가</h5>
                <div class="clear"></div>
            </div><!-- /.worklist-title -->
        </section><!-- /.worklist -->

        <!-- 업무리스트 추가 폼 -->
        <section id="add-wkltfrm-wrapper" class="worklist add-worklist" role="button" tabindex="0">
            <!-- 타이틀 -->
            <div class="worklist-title">
                <form action="" id="addWorklistFrm">
                    <input type="text" name="worklistTitle" placeholder="업무리스트 이름">
                    <div class="worklist-title-btn">
                        <button type="submit" id="btn-addWorklist" class="btn-addWork">
                            <i class="fas fa-plus"></i>
                        </button>
                        <button type="button" id="btn-cancel-addWorklist" class="btn-removeWorklist">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </form>
                <div class="clear"></div>
            </div><!-- /.worklist-title -->
        </section><!-- /.worklist -->

        <div class="clear"></div>
    </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->

<!-- 업무리스트 삭제 모달 -->
<div class="modal fade" id="modal-wroklist-remove">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            <h4 class="modal-title">업무리스트 삭제</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
            </div>
            <div class="modal-body">
            <p>정말 삭제하시겠습니까? [] 업무리스트는 영구 삭제됩니다.</p>
            </div>
            <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">아니오, 업무리스트를 유지합니다.</button>
            <button type="button" class="btn btn-danger">네</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>