<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/club/clubViewModal.jsp"></jsp:include>

<style>

</style>

<script>
$(function(){
	
	$('.textarea').summernote();
	
	//Date range picker
	$('#reservation').daterangepicker({
	    singleDatePicker: true,
	    showDropdowns: true,
	    locale: {
		    format: 'YYYY-MM-DD'
	    }
	  });

	
	sidebarActive(); //사이드바 활성화
	tabActive(); //서브헤더 탭 활성화
	

	
});

$( document ).ready(function() {
	
/* 	var clubNo = "${clubNo}";
	$.ajax({
		url: "${pageContext.request.contextPath}/club/selectClubPlan.do",
		dataType: "json",
		data:{"clubNo" : clubNo},
		type: "GET",
		success: data => {
			
			console.log(data);
			
		},
		error: (x,s,e)=> {
			console.log(x,s,e);
		}
	}); */
});


	
$(function () {

    /* initialize the external events
     -----------------------------------------------------------------*/
/*     function ini_events(ele) {
      ele.each(function () {

        // create an Event Object (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
        // it doesn't need to have a start or end
        var eventObject = {
          title: $.trim($(this).text()) // use the element's text as the event title
        }

        // store the Event Object in the DOM element so we can get to it later
        $(this).data('eventObject', eventObject)

        // make the event draggable using jQuery UI
        $(this).draggable({
          zIndex        : 1070,
          revert        : true, // will cause the event to go back to its
          revertDuration: 0  //  original position after the drag
        })

      })
    }

    ini_events($('#external-events div.external-event')) */

    /* initialize the calendar
     -----------------------------------------------------------------*/
    //Date for the calendar events (dummy data)
    var date = new Date()
    var d    = date.getDate(),
        m    = date.getMonth(),
        y    = date.getFullYear()

    var Calendar = FullCalendar.Calendar;
    var Draggable = FullCalendarInteraction.Draggable;

    var containerEl = document.getElementById('external-events');
    //var checkbox = document.getElementById('drop-remove');
    var calendarEl = document.getElementById('calendar');

    // initialize the external events
    // -----------------------------------------------------------------

/*     new Draggable(containerEl, {
      itemSelector: '.external-event',
      eventData: function(eventEl) {
        console.log(eventEl);
        return {
          title: eventEl.innerText,
          backgroundColor: window.getComputedStyle( eventEl ,null).getPropertyValue('background-color'),
          borderColor: window.getComputedStyle( eventEl ,null).getPropertyValue('background-color'),
          textColor: window.getComputedStyle( eventEl ,null).getPropertyValue('color'),
        };
      }
    }); */
	var clubPlanList = "${clubPlanList}"; //자바스크립트 변수로 선언.
	
    var calendar = new Calendar(calendarEl, {
      plugins: [ 'bootstrap', 'interaction', 'dayGrid', 'timeGrid' ],
      header    : {
        left  : 'prev,next today',
        center: 'title',
        right : 'dayGridMonth'
      },
      //Random default events
      ${calString},
      editable  : true,
      droppable : true, // this allows things to be dropped onto the calendar !!!
      drop      : function(info) {
        // is the "remove after drop" checkbox checked?
        if (checkbox.checked) {
          // if so, remove the element from the "Draggable Events" list
          info.draggedEl.parentNode.removeChild(info.draggedEl);
        }
      }, 
      
      eventClick(info) {
    	  
    	  var noAndTitle = info.event.title;
    	  var arr = noAndTitle.split(",");
    	  var clubPlanNo = arr[0];
    	  $.ajax({
    		  
    		  url: "${pageContext.request.contextPath}/club/selectOneClubPlan.do?",
    			dataType: "json",
    			data:{"clubPlanNo" : clubPlanNo},
    			type: "GET",
    			success: data => {
    				console.log(data);
    				
    				//동호회 PlanView
    				let clubPlanViewModal = '';
    				
    				clubPlanViewModal += '<div class="modal fade cd-example-modal-lg"id="clubPlanView'+data.clubPlan.clubPlanNo+'" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true" data-backdrop="static">'
									  +'<div class="modal-dialog modal-dialog-centered modal-lg" role="document">'
									  +'<div class="modal-content card card-outline card-info" style="max-heigth: 100%; height: auto;">'
									  +'<div class="modal-header"><h5 class="modal-title" id="exampleModalLongTitle">일정확인하기</h5>'
									  +'<button type="button" class="close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button></div>';
					//modal body부분
					clubPlanViewModal += '<div class="modal-body"> <div class="form-group"> <label for="inputName">일정</label> <p style="margin-left: 10px;">'+data.clubPlan.clubPlanTitle+'</p></div>'
									  +'<div class="form-group"><div class="mb-3"><label for="inputDescription">일정 내용</label><div style="margin-left: 10px;">'+data.clubPlan.clubPlanContent+'</div></div></div>'
									  +'<div class="form-group"><label for="inputStatus">날짜</label><div style="margin-left: 10px;">'+data.clubPlan.clubPlanStart+ '</div></div>'
									  +'<div class="form-group"><label for="inputStatus">상태</label> <span class="btn btn-block btn-sm bg-'+data.clubPlan.clubPlanColor+ '"style="margin-left: 10px; width: 70px;">'+data.clubPlan.clubPlanState+'</span></div>'
									  +'<div class="form-group"><label for="inputClientCompany">장소</label><p style="margin-left: 10px;">'+data.clubPlan.clubPlanPlace+ '</p></div>'
									  +'<div class="form-group"><label for="inputProjectLeader">담당진행자</label><p style="margin-left: 10px;">'+data.clubPlan.clubPlanManager+ '</p></div>';
					//참석자 부분
					clubPlanViewModal +='<div class="form-group"><label for="inputProjectLeader">참석자</label><div class="attendeeList" id="attendeeList'+data.clubPlan.clubPlanNo+'"></div>'
					//참석자가 있을때
					if(data.clubPlan.planAttendeeList != null){
						$.each(data.clubPlan.planAttendeeList,(idx,list)=>{
							
							if(list.clubPlanNo == data.clubPlan.clubPlanNo){
								clubPlanViewModal +='<div class="card card-success" style="width: 8rem; height: 3rem; padding-top: .2rem; margin-top: 1rem; display: inline-block;">'
												  +'<div class="col-12"><img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/'+list.renamedFileName+'" alt="Message User Image">'
		                            			  +'<h6 class="h6">'+list.memberName+'</h6>'
		                            			  +'<div class="card-tools" style="position: relative; bottom: 1.4rem; left: 3.5rem; display: inline-block;">'
		                            			  +'<form name="deleteClubPlanAttendeeFrm" action="${pageContext.request.contextPath}/club/deleteClubPlanAttendee.do" method="POST">'
									    		  +'<input type="hidden" name="memberId" value="'+list.memberId+'">'
									    		  +'<input type="hidden" name="clubPlanAttendeeNo" value="'+list.clubPlanAttendeeNo+'">'
									    		  +'<input type="hidden" name="clubNo" value="'+data.clubPlan.clubNo+'">'
									    		  +'<button type="submit" class="btn btn-tool"><i class="fas fa-times" style="color: black;"></i></button>'
									    		  +' </form> </div></div> </div>';
							}
							
							
						});
						
					}
					clubPlanViewModal+='</div></div>'
									 +'<div class="modal-footer"><form name="insertClubPlanAttendanceFrm" action="${pageContext.request.contextPath }/club/insertClubPlanAttendee.do" method="POST">'
									 +'<input type="hidden" name="clubPlanNo" value='+data.clubPlan.clubPlanNo+' />'
									 +'<input type="hidden" name="memberId" value='+'${memberLoggedIn.memberId}'+ ' />'
									 +'<input type="hidden" name="clubNo" value='+data.clubPlan.clubNo+' />'
									 +'<button type="submit" class="btn btn-info float-right">\<i class="fas fa-plus"></i>\</button>\</form>';
					
					alert(data.clubPlan.memberId);
					if('${memberLoggedIn}' != null && data.clubPlan.memberId=='${memberLoggedIn.memberId}'){
					clubPlanViewModal+='<button type="button" class="btn btn-info" data-target="#plan-modify'+data.clubPlan.clubPlanNo+'" data-dismiss="modal" data-toggle="modal">수정</button>'
									 +'<form name="deleteClubPlanFrm" action="${pageContext.request.contextPath }/club/deleteClubPlan.do" method="POST">'
									 +'<input type="hidden" name="clubPlanNo" value="'+data.clubPlan.clubPlanNo+ '" />'
									 +'<input type="hidden" name="clubNo" value="'+data.clubPlan.clubNo+ '" />'
									 +'<button type="submit" class="btn btn-danger" onclick="return confirmDelete();">삭제</button></form>';
					}
					clubPlanViewModal+='<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>'
									 +'</div></div></div></div>';
									 
									 
					$("#club-plan-modal-content").html(clubPlanViewModal);
				
					$("#clubPlanView"+data.clubPlan.clubPlanNo).modal();
					
    				//동호회 일정 수정 view
    				let clubPlanModifyModal ='';
    				clubPlanModifyModal+='<div class="modal fade cd-example-modal-lg" id="plan-modify'+data.clubPlan.clubPlanNo+'"tabindex="-1" role="dialog"'
									   +'aria-labelledby="exampleModalCenterTitle" aria-hidden="true" data-backdrop="static" style="overflow-y: auto;">'
									   +'<div class="modal-dialog modal-dialog-centered modal-lg" role="document">'
									   +'<div class="modal-content card card-outline card-info" style="max-heigth: 100%; height: auto;">'
									   +'<div class="modal-header"><h5 class="modal-title" id="exampleModalLongTitle">일정수정하기</h5>'
									   +'<button type="button" class="close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span></button></div>';
					
					clubPlanModifyModal+='<form name="clubPlanUpdateFrm" action="${pageContext.request.contextPath }/club/clubPlanUpdate.do" method="post">'
									   +'<input type="hidden" name="clubPlanNo" value="'+data.clubPlan.clubPlanNo +'" />'
									   +'<input type="hidden" name="clubNo" value="'+data.clubPlan.clubNo+'" />'
									   +'<div class="modal-body"> <div class="form-group"> <label for="inputName">일정</label> '
									   +'<input type="text" id="inputName" class="form-control" name="clubPlanTitle" placeholder="일정을 입력하세요." value="'+data.clubPlan.clubPlanTitle+'" /></div>'
									   +'<div class="form-group"><div class="mb-3"><label for="inputDescription">일정 내용</label>'
									   +'<textarea id="inputDescription" class="textarea" name="clubPlanContent" style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;">'+data.clubPlan.clubPlanContent +'</textarea>'
									   +'</div></div>'
									   +'<div class="form-group"><label for="">날짜</label><div class="input-group"><div class="input-group-prepend">'
									   +'<span class="input-group-text"><i class="far fa-calendar-alt"></i></span></div>'
									   +'<input type="text" class="form-control float-right" name="clubPlanDate" id="clubPlanUpdateDate'+data.clubPlan.clubPlanNo+'" />'
									   +'</div>';
										
									 
										$(()=> {
											$("#clubPlanUpdateDate"+data.clubPlan.clubPlanNo).daterangepicker({
												startDate: data.clubPlan.clubPlanStart, 
												singleDatePicker: true,
											    showDropdowns: true, 
											    locale: {
												    format: 'YYYY-MM-DD'
											    }
											  });
										});
										
					clubPlanModifyModal+='</div><div class="form-group"><label for="inputStatus">상태</label>'
									   +'<select name="clubPlanState" class="form-control custom-select">'
									   +'<option selected disabled>선택하세요.</option>'
									   +'<option '+data.clubPlan.clubPlanState+'=="예정"?selected:"" }>예정</option>'
									   +'<option '+data.clubPlan.clubPlanState+'=="완료"?selected:"" }>완료</option>'
									   +'<option '+data.clubPlan.clubPlanState+'=="취소"?selected:"" }>취소</option></select></div>'
									   +'<div class="form-group"><label for="inputClientCompany">장소</label>'
									   +'<input type="text" id="inputClientCompany" class="form-control" name="clubPlanPlace" placeholder="장소를 입력하세요." value="'+data.clubPlan.clubPlanPlace +'" /></div>'
									   +'<div class="form-group"><label for="inputProjectLeader">담당진행자</label>' 
									   +'<input type="text" id="inputProjectLeader" class="form-control" name="clubPlanManager" placeholder="담당진행자를 입력하세요." value="'+data.clubPlan.clubPlanManager +'"></div></div>'
									   +'<div class= modal-footer" style="padding: 20px; text-align: right;"><button type="submit" class="btn btn-info" style="margin-right: 10px;">수정</button>'
									   +'<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button></div>'
									   +'</form></div></div></div>';
		
					$("#club-plan-modify-modal-content").html(clubPlanModifyModal);

    				
					$('.textarea').summernote();
    				
    				
    			    
    			},
    			error: (x,s,e)=> {
    				console.log(x,s,e);
    			}
    		  
    	  });

      }

    });

    calendar.render();
    //$('#calendar').fullCalendar()

    /* ADDING EVENTS */
    var currColor = '#3c8dbc' //Red by default
    //Color chooser button
    var colorChooser = $('#color-chooser-btn')
    $('#color-chooser > li > a').click(function (e) {
      e.preventDefault()
      //Save color
      currColor = $(this).css('color')
      //Add color effect to button
      $('#add-new-event').css({	
        'background-color': currColor,
        'border-color'    : currColor
      })
    })
    
    $('#add-new-event').click(function (e) {
      e.preventDefault()
      //Get value and make sure it is not null
      var val = $('#new-event').val()
      if (val.length == 0) {
        return
      }

  /*     //Create events
      var event = $('<div />')
      event.css({
        'background-color': currColor,
        'border-color'    : currColor,
        'color'           : '#fff'
      }).addClass('external-event')
      event.html(val) */
      $('#external-events').prepend(event)

      //Add draggable funtionality
      ini_events(event)

      //Remove event from text input
     // $('#new-event').val('')
    })
  })


</script>
<body class="hold-transition sidebar-mini">
	<!-- Navbar ClubView -->
	<nav id="navbar-club"
		class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
		<!-- Left navbar links -->
		<!-- SEARCH FORM -->
		<form id="noticeSearchFrm" class="form-inline">
			<div class="input-group input-group-sm">
				<input class="form-control form-control-navbar" type="search"
					placeholder="oo동호회 검색" aria-label="Search">
				<div class="input-group-append">
					<button class="btn btn-navbar" type="submit">
						<i class="fas fa-search"></i>
					</button>
				</div>
			</div>
		</form>

		<!-- Middle navbar links -->
		<ul id="navbar-tab" class="navbar-nav ml-auto">
			<li id="tab-club" class="nav-item"><button type="button">동호회</button></li>
			<li id="tab-calendar" class="nav-item"><button type="button">일정</button></li>
			<c:if
				test="${memberLoggedIn.memberId == 'admin' or club.clubManagerId == memberLoggedIn.memberId}">
				<li id="tab-member" class="nav-item">
					<button type="button" onclick="memberList('${club.clubNo}');">동호회멤버</button>
				</li>
			</c:if>
			<li id="tab-attachment" class="nav-item"><button type="button">파일</button></li>
		</ul>

		<!-- Right navbar links -->
		<ul id="viewRightNavbar-wrapper" class="navbar-nav ml-auto">
			<!-- 동호회 대화 -->
			<li class="nav-item">
				<button type="button"
					class="btn btn-block btn-default btn-xs nav-link">
					<i class="far fa-comments"></i> 동호회 대화
				</button>
			</li>

			<!-- 동호회 멤버 -->
			<li id="nav-member" class="nav-item dropdown"><a
				class="nav-link" data-toggle="dropdown" href="#"> <i
					class="far fa-user"></i> 6
			</a>
				<div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
					<a href="#" class="dropdown-item"> <!-- Message Start -->
						<div class="media">
							<img
								src="${pageContext.request.contextPath}/resources/img/profile.jfif"
								alt="User Avatar" class="img-circle img-profile ico-profile" />
							<div class="media-body">
								<p class="memberName">Brad Diesel</p>
							</div>
						</div> <!-- Message End -->
					</a> <a href="#" class="dropdown-item"> <!-- Message Start -->
						<div class="media">
							<img
								src="${pageContext.request.contextPath}/resources/img/profile.jfif"
								alt="User Avatar" class="img-circle img-profile ico-profile">
							<div class="media-body">
								<p class="memberName">Brad Diesel</p>
							</div>
						</div> <!-- Message End -->
					</a> <a href="#" class="dropdown-item"> <!-- Message Start -->
						<div class="media">
							<img
								src="${pageContext.request.contextPath}/resources/img/profile.jfif"
								alt="User Avatar" class="img-circle img-profile ico-profile">
							<div class="media-body">
								<p class="memberName">Brad Diesel</p>
							</div>
						</div> <!-- Message End -->
					</a> <a href="#" class="dropdown-item"> <!-- Message Start -->
						<div class="media">
							<img
								src="${pageContext.request.contextPath}/resources/img/profile.jfif"
								alt="User Avatar" class="img-circle img-profile ico-profile">
							<div class="media-body">
								<div class="media-body">
									<p class="memberName">Brad Diesel</p>
								</div>
							</div>
						</div> <!-- Message End -->
					</a> <a href="#" class="dropdown-item"> <!-- Message Start -->
						<div class="media">
							<img
								src="${pageContext.request.contextPath}/resources/img/profile.jfif"
								alt="User Avatar" class="img-circle img-profile ico-profile">
							<div class="media-body">
								<p class="memberName">Brad Diesel</p>
							</div>
						</div> <!-- Message End -->
					</a>
				</div></li>

			<!-- 동호회 설정 -->
			<li class="nav-item">
				<button type="button"
					class="btn btn-block btn-default btn-xs nav-link">
					<i class="fas fa-cog"></i>
				</button>
			</li>
		</ul>
	</nav>
	<!-- /.navbar -->

	<!-- Content Wrapper. Contains page content -->
	<div class="content-wrapper">
		<!-- Content Header (Page header) -->
		<section class="content-header">
			<div class="container-fluid">
				<div class="row mb-2"></div>
			</div>
			<!-- /.container-fluid -->
		</section>

		<!-- Main content -->
		<section class="content">
			<div class="container-fluid">

				<div class="col-md-9" style="margin: 0 auto">
					<div class="card">

						<div class="card-body">
							<!-- the events -->
							<div id="external-events">
								<div id="calendar"></div>
							</div>
						</div>
						<!-- /.card-body -->
					</div>
					<!-- /.card -->

				</div>
			</div>
			<!-- /.container-fluid -->
		</section>
		
		
		<div id="club-plan-modal-content"></div>
		<div id="club-plan-modify-modal-content"></div>
		
		
		

		<!-- /.content -->
	</div>
	<!-- div content wrapper -->

</body>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>