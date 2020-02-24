<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<style>
.layout-navbar-fixed .wrapper .content-wrapper{margin-top: 46px;}
.card{cursor: auto;}
.chat-wrapper{height: 635px;}
.card-header{
    margin: 0;
    padding: .5rem .5rem .5rem 1rem;
border-bottom: 1px solid rgba(0,0,0,.125); 
height: 3.6rem;
}
.direct-chat-msg.right>.direct-chat-text{
float: right; margin:0 1rem 0 0;
}
.direct-chat-msg>.direct-chat-text{
float: left; margin:0.1px 0 0 1rem;
}
.user-block{margin: 0;}
.user-block>.username{
margin-top:0.6rem;
}
.direct-chat-infos.clearfix{
margin-top: solid 1px black;
}
.td>tr>td{
padding: .30rem;
border-top: none;
}
.td>tr>td:hover{
background: #d2d6de;
}
.h6{
position: relative; 
top:.5rem; 
left: .5rem;
}
.modal-body{padding: 1.8rem 1.3rem 0;}
.tab-content{background: inherit;}
</style>

<script type="text/javascript">
$(function () {
  // Summernote
  $('.textarea').summernote();
  
  sidebarActive(); //사이드바 활성화
  
});

//사이드바 활성화
function sidebarActive(){
	let navLinkArr = document.querySelectorAll(".sidebar .nav-link");
	
	navLinkArr.forEach((obj, idx)=>{
		let $obj = $(obj);
		if($obj.hasClass('active'))
			$obj.removeClass('active');
	});
	
	$("#sidebar-chat").addClass("active");
}
	
</script>


<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <section class="content">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-3">
                    <!-- About Me Box -->
                    <div class="card card-primary">
                        <div class="card-body">
                            <button type="button" class="btn btn-default" data-toggle="modal" data-target="#modal-default" style="width: 100%;">
                                채널 검색
                                <i class="fas fa-search" style="float: right; position: relative; top:.3rem;"></i>
                            </button>
                            <button type="button" class="btn btn-default" data-toggle="modal" data-target="#modal-default1" style="width: 100%; background: white; border-color: white; font-weight: bold; color:#17a2b8;">
                                <i class="fas fa-plus"></i>&nbsp;
                                새 대화 채널 추가
                            </button>
                        </div>
                        <div class="col-12">
                            <div class="card-body table-responsive p-0" style="height: 32.5rem;">
                                <table class="table table-head-fixed text-nowrap">
                                    <tbody class="td">
                                    <c:forEach items="${channelList }" var="channel">
                                        <tr onclick="loadChatList('${channel.channelNo }', '${channel.memberName }', '${channel.renamedFileName }');" >
                                            <td>
                                                <div class="col-9" style="width: 100%;"> 
                                                    <img class="direct-chat-img" src="${pageContext.request.contextPath }/resources/img/profile/${channel.renamedFileName}">
                                                    <h6 class="h6">${channel.memberName }</h6>
                                                </div> 
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <!-- /.card -->
                </div>
                <!-- /.col -->
                <div class="col-md-9">
                    <div class="card chat-wrapper">
                        <div class="card-header">
                            <div class="post">
                                <div class="user-block" id="chat_userName">
                                    
                                </div>
                            </div>
                        </div><!-- /.card-header -->
                        <div class="card-body">        
                            <!-- Conversations are loaded here -->
                            <div class="direct-chat-messages" id="chatArea" style="height:20.8rem">
                            </div><!-- /.direct-chat-messages -->
                        </div>
                        <!-- /.card-body -->
                        <div class="input-group mb-3" id="div_textarea">
                        </div>
                    </div>
                    <!-- /.card -->
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </div><!-- /.container-fluid -->
    </section>
</div>
<!-- /.content-wrapper -->

<!-- Modal -->
<div class="modal fade" id="modal-default">
    <div class="modal-dialog modal-default">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">채널 검색</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>

        <div class="modal-body">
          <!-- <p>One fine body&hellip;</p> -->
          <div class="card-tools" style="margin-bottom:2rem">
              <div class="input-group input-group-sm" style="width: 20rem; margin: 0 auto;">
                <input type="text" name="table_search" class="form-control float-right" placeholder="Search">

                <div class="input-group-append">
                  <button type="submit" class="btn btn-default"><i class="fas fa-search"></i></button>
                </div>
              </div>
            </div>
          <div class="col-9" style="margin: 0 auto;"> 
              <ul class="nav nav-pills" style="padding-left:2.5rem;">
                <li class="nav-item"><a class="nav-link active" href="#activity" data-toggle="tab">전체</a></li>
                <li class="nav-item"><a class="nav-link" href="#timeline" data-toggle="tab">채널</a></li>
                <li class="nav-item"><a class="nav-link" href="#settings" data-toggle="tab">다이렉트 메시지</a></li>
              </ul>
          </div>
            <div class="card-body">
                <div class="tab-content">
                  <div class="active tab-pane" id="activity">
                      <div class="post">
                          <div class="row">
                              <div class="col-12">
                                  <!-- /.card-header -->
                                  <div class="card-body table-responsive p-0" style="height: 300px;">
                                    <table class="table table-head-fixed text-nowrap">
                                      <tbody class="td">
                                        <tr>
                                          <td>
                                            <div class="col-9"> 
                                              <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="Message User Image">
                                              <h6 class="h6">이주현</h6>
                                            </div> 
                                          </td>
                                        </tr>
                                        <tr>
                                            <td>
                                              <div class="col-9"> 
                                                <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="Message User Image">
                                                <h6 class="h6">개발</h6>
                                              </div> 
                                            </td>
                                          </tr>
                                      </tbody>
                                    </table>
                                  </div>
                                  <!-- /.card-body -->
                                <!-- </div> -->
                                <!-- /.card -->
                              </div>
                            </div>
                            <!-- /.row -->
                        </div>
                    </div>
                    <div class="tab-pane" id="timeline">
                        <div class="post">
                            <div class="row">
                                <div class="col-12">
                                    <!-- /.card-header -->
                                    <div class="card-body table-responsive p-0" style="height: 300px;">
                                      <table class="table table-head-fixed text-nowrap">
                                        <tbody class="td">
                                          <tr>
                                            <td>
                                              <div class="col-9"> 
                                                <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/userimage.jpg" alt="Message User Image">
                                                <h6 class="h6">개발</h6>
                                              </div> 
                                            </td>
                                          </tr>
                                        </tbody>
                                      </table>
                                    </div>
                                    <!-- /.card-body -->
                                  <!-- </div> -->
                                  <!-- /.card -->
                                </div>
                              </div>
                              <!-- /.row -->
                          </div>
                    </div>
                    <div class="tab-pane" id="settings">
                        <div class="post">
                            <div class="row">
                                <div class="col-12">
                                    <!-- /.card-header -->
                                    <div class="card-body table-responsive p-0" style="height: 300px;">
                                      <table class="table table-head-fixed text-nowrap">
                                        <tbody class="td">
                                          <tr>
                                            <td>
                                              <div class="col-9"> 
                                                <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="Message User Image">
                                                <h6 class="h6">이주현</h6>
                                              </div> 
                                            </td>
                                          </tr>
                                        </tbody>
                                      </table>
                                    </div>
                                    <!-- /.card-body -->
                                  <!-- </div> -->
                                  <!-- /.card -->
                                </div>
                              </div>
                              <!-- /.row -->
                          </div>
                    </div>
                </div>
            </div>
        </div>
      </div>
      <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<div class="modal fade" id="modal-default1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title">새 대화 채널 추가</h4>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form name="insertChannelFrm" action="${pageContext.request.contextPath }/chat/insertChannel.do" method="POST">
      <div class="modal-body">
        <div class="col-sm-12" style="float: right; padding: 1rem;">
            <div class="form-group">
                <label>채널 이름</label>
                <input type="text" class="form-control" name="channelTitle" id="channelTitle">
            </div>
        </div>
        <div class="col-sm-12" style="float: right; padding: 1rem;">
            <div class="form-group" id="div-plusMember">
                <label>채널 멤버 찾기</label>
                <button type="button" id="plusChannel" class="btn btn-default" data-toggle="modal" data-target="#modal-sm">
                    <i class="fas fa-plus"></i>
                </button>
            </div>
        </div>
      </div>
      <div class="modal-footer justify-content-between">
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
        <button type="submit" class="btn btn-primary">추가하기</button>
      </div>
    </form>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<div class="modal fade" id="modal-sm">
    <div class="modal-dialog modal-sm">
      <div class="modal-content" style="max-heigth: 100%; height: 35rem;">
        <div class="modal-header">
          <h4 class="modal-title" style="font-size: 1rem;">멤버</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
            <div class="card-tools" style="margin-bottom:2rem">
	                <div class="input-group input-group-sm" style="width: 100%; margin: 0 auto;">
	                  <input type="text" id="findMember" name="keyword" class="form-control float-right" placeholder="이름 혹은 이메일로 찾기">
	                </div>
            </div>
            <div class="card-body table-responsive p-0" style="height: 14rem;">
                <table class="table table-head-fixed text-nowrap">
                  <tbody class="td" id="findMemberList">
                  </tbody>
                </table>
            </div>
        </div>
      </div>
      <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
		
<script type="text/javascript">

$(document).ready(function() {
	$(document).on("click", "#sendBtn", function() {
		console.log("#sendBtn 실행성공");
		console.log($(this).val());
		sendMessage();
	});
	$(document).on("keydown", "#message", function(key) {
		if (key.keyCode == 13) {// 엔터
			sendMessage();
		}
	});

	//window focus이벤트핸들러 등록
	$(window).on("focus", function() {
		console.log("focus");
		//lastCheck();
	});
});


//대화상대찾기 ajax
$("#findMember").keyup(function() {
	var keyword = $("#findMember").val().trim();
	if(keyword == '') return;
	console.log(keyword);
	
	$.ajax({
		url: '${pageContext.request.contextPath}/chat/findMember.do', 
		data: {keyword:keyword}, 
		dataType: 'json', 
		success: data=> {
			console.log(data.memberList);
			$("#findMemberList").children().remove();
			
			if(data.memberList != null) {
				let html = '';
				$.each(data.memberList, (idx, list)=> {
					html += '<tr onclick="plusMember(\''+list.memberId+'\');" data-dismiss="modal"><td><div class="col-9">';
					html += '<img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/'+list.renamedFileName+'">'
	                html += '<h6 class="h6">'+list.memberName+'</h6>';
	                html += '</div></td><tr>';
	                
				});
				
				$("#findMemberList").append(html);
			}
		}, 
		error: (x, s, e)=> {
			console.log("ajax실행오류!!", x, s, e);
		}
	});
});

function plusMember(memberId) {
	//console.log(memberId);
	
	$.ajax({
		url: '${pageContext.request.contextPath}/chat/plusMember.do', 
		data: {memberId:memberId}, 
		dataType: 'json', 
		success: data=> {
			console.log(data.member.memberName);
			console.log(plusMember);
			
			let html = '<div class="card card-success" style="width: 8rem; height: 3rem; padding-top: .2rem; margin-top: 1rem;">';
	        html += '<div class="col-12">';
	        html += '<input type="hidden" name="memberId" value="'+data.member.memberId+'">';
	        html += '<img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/'+data.member.renamedFileName+'">';
            html += '<h6 class="h6">'+data.member.memberName+'</h6>';
            html += '<div class="card-tools" style="position: relative; bottom: 1.4rem; left: 3.5rem; display: inline-block;"><button type="button" class="btn btn-tool" data-card-widget="remove"><i class="fas fa-times" style="color: black;"></i></button></div></div></div>';
			
			$("#div-plusMember").append(html);
			
			if($("#channelTitle").val().trim().length==0) {
				$("#channelTitle").val(data.member.memberId+", ${memberLoggedIn.memberId}");
			}
			else {
				$("#channelTitle").val($("#channelTitle").val()+", "+data.member.memberName);
			}
		}, 
		error: (x, s, e)=> {
			console.log("ajax실행오류!!", x, s, e);
		}
	});
	
}

function loadChatList(channelNo, memberName, renamedFileName) {
	<c:set var="channelNo" value="" />
	<c:forEach items="${channelList}" var="channel" varStatus="vs">
		if("${channel.channelNo}" == channelNo) {
			<c:set var="index" value="${vs.index}" />
		}
			console.log("${channelList[vs.index].channelNo}");
	</c:forEach>
	//console.log("1", memberName);
	$.ajax({
		url: '${pageContext.request.contextPath}/chat/loadChatList.do', 
		data: {channelNo : channelNo}, 
		dataType: 'json', 
		type: 'POST', 
		success: data=> {
			//console.log(data.chatList);
			//console.log(data.chatMemberId);
			//console.log(data.channelNo);
			
			$("#chatArea").children().remove();
			$("#chat_userName").children().remove();
			$("#chat_userName").append('<img class="img-circle" src="${pageContext.request.contextPath}/resources/img/profile/'+renamedFileName+'" alt="user image"><span class="username"><h3>'+memberName+'</h3></span>');
			$("#div_textarea").children().remove();
			//console.log("1");
			if(data.chatList != null) {
				let html = '';
				$.each(data.chatList, (idx, list)=> {
					if(list.sender != data.chatMemberId) {
						html += '<div class="direct-chat-msg right"><div class="direct-chat-infos clearfix">';
						html += '<span class="direct-chat-name float-right">'+list.memberName+'</span>';
						html += '<span class="direct-chat-timestamp float-right">'+list.sendDate+' &nbsp;&nbsp;</span></div>';
						html += '<img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/'+list.renamedFileName+'">';
						html += '<div class="direct-chat-text">'+list.msg+'</div>';
						html += '</div>';
					}
					else {
						html += '<div class="direct-chat-msg"><div class="direct-chat-infos clearfix">';
						html += '<span class="direct-chat-name float-left">'+list.memberName+'</span>';
						html += '<span class="direct-chat-timestamp float-left"> &nbsp;&nbsp;'+list.sendDate+'</span></div>';
						html += '<img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/'+list.renamedFileName+'">';
						html += '<div class="direct-chat-text">'+list.msg+'</div>';
						html += '</div>';
					}
				});
				//console.log("2");
				$("#chatArea").append(html);
				//console.log("3");
			}
			//console.log(data.channelNo);
			//let textarea = '<div class="mb-3"><textarea class="textarea" placeholder="Message" id="message" style="width: 100%; height: 200px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;"></textarea></div>';
			let textarea = '<input type="text" id="message" class="form-control" placeholder="Message to '+memberName+'"><div class="input-group-append" style="padding: 0px;"><button id="sendBtn" class="btn btn-outline-secondary" type="button">Send</button></div>';
			//$("#div_textarea").append(textarea);
			$("#div_textarea").append(textarea);
		}, 
		error: (x, s, e)=> {
			console.log("ajax실행오류!!", x, s, e);
		}
	});

}
//웹소켓 선언
//1.최초 웹소켓 생성 url: /chat
let socket = new SockJS('<c:url value="/stomp" />');
let stompClient = Stomp.over(socket);

//connection이 맺어지면, 콜백함수가 호출된다.
stompClient.connect({}, function(frame) {
	console.log("connected stomp over sockjs");
	console.log(frame);
	//사용자 확인
	//lastCheck();
	
	//stomp에서는 구독개념으로 세션을 관리한다. 핸들러 메소드의 @SendTo어노테이션과 상응한다.
	stompClient.subscribe('/chat/${channelList[index].channelNo}', function(message) {
		console.log("receive from subscribe /chat/channelList[index].channelNo : ", message);
		let messageBody = JSON.parse(message.body);
		//console.log(messageBody);
		
		let html = '';
		if(messageBody.sender == '${memberLoggedIn.memberId}') {
			html += '<div class="direct-chat-msg right"><div class="direct-chat-infos clearfix">';
			html += '<span class="direct-chat-name float-right">'+messageBody.memberName+'</span>';
			html += '<span class="direct-chat-timestamp float-right">'+messageBody.sendDate+' &nbsp;&nbsp;</span></div>';
			html += '<img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/'+messageBody.renamedFileName+'">';
			html += '<div class="direct-chat-text">'+messageBody.msg+'</div>';
			html += '</div>';
		}
		else {
			html += '<div class="direct-chat-msg"><div class="direct-chat-infos clearfix">';
			html += '<span class="direct-chat-name float-left">'+messageBody.memberName+'</span>';
			html += '<span class="direct-chat-timestamp float-left"> &nbsp;&nbsp;'+messageBody.sendDate+'</span></div>';
			html += '<img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/'+messageBody.renamedFileName+'">';
			html += '<div class="direct-chat-text">'+messageBody.msg+'</div>';
			html += '</div>';
		}
		//console.log(html);
		$("#chatArea").append(html);
	});
});

function sendMessage() {
	let data = {
		channelNo : "${channelList[index].channelNo}", 
		sender : "${memberLoggedIn.memberId }", 
		msg: $("#message").val(), 
		sendDate : new Date().getTime(), 
		type : "MESSAGE", 
		memberName : "${memberLoggedIn.memberName}", 
		renamedFileName : "${memberLoggedIn.renamedFileName}"
	}
	//console.log(data);
	
	//채팅메세지: 1대1채팅을 위해 고유한 channelNo을 서버측에서 발급해 관리한다.
	stompClient.send('<c:url value="/chat/channelList[index].channelNo" />', {}, JSON.stringify(data));
	
	//message창 초기화
	$('#message').val('');
}

/*
 * 윈도우가 활성화 되었을때, chatroom테이블의 lastcheck(number)컬럼을 갱신한다.
 * 안읽은 메세지 읽음 처리
 */ 
function lastCheck() {
	console.log("lastCheck()실행확인");
	let data = {
		channelNo : "${channelNo}", 
		memberId : "${memberLoggedIn.memberId}", 
		time : new Date().getTime()
	}
	stompClient.send('<c:url value="/lastCheck" />', {}, JSON.stringity(data));
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>