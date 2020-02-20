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
.direct-chat-infos.clearfix{
margin-top: solid 1px black;
}
.td>tr>td{
padding: .6rem .8rem .4rem;
border-top: none;
border-radius: 2px;
}
.td>tr>td:hover, .td>tr>td:active, .td>tr>td:focus{
background: #e6e8ec;
cursor: pointer;
}
.modal-body{padding: 1.8rem 1.3rem 0;}
.tab-content{background: inherit;}
</style>

<script type="text/javascript">
$(function () {
	// Summernote
	$('#div_textarea').summernote({
        focus: true,
        lang: 'ko-KR',
        height: 120,
        toolbar: [
            ['style', ['bold', 'italic', 'underline', 'strikethrough']],
            ['para', ['ul', 'ol']],
            ['insert', ['picture', 'link']]
        ],
        placeholder: '내 메시지...'
    });
  
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
    <section id="chatList-wrapper" class="content">
            
	    <!-- 채팅 사이드바 -->
	    <aside id="channel-aside-wrapper">
	    	<!-- 채널 검색, 추가 -->
	    	<div id="aside-top">
	            <button type="button" id="btn-searchChannel" class="btn btn-default" data-toggle="modal" data-target="#modal-default" style="width: 100%;">
	                <i class="fas fa-search"></i> 채널 검색
	            </button>
	            <button type="button" id="btn-addChannel" class="btn btn-default" data-toggle="modal" data-target="#modal-default1" style="width: 100%; background: white; border-color: white; font-weight: bold;">
	                <i class="fas fa-plus"></i>&nbsp;새 대화 채널 만들기
	            </button>
	         </div><!-- /#aside-top -->       
	         
	         <!-- 채널 목록 --> 
	         <div id="aside-bottom">
	         	<h5>최근 메시지</h5>	
	             <table id="dmList" class="table table-head-fixed text-nowrap">
	                 <tbody class="td">
	                 <c:forEach items="${channelList }" var="channel" varStatus="vs">
	                 <tr onclick="loadChatList('${channel.channelNo }', '${channel.memberName }', '${channel.renamedFileName }', '${vs.index }');">
	                     <td>
	                         <form name="loadChatListFrm">
							     <input type="hidden" name="channelNo" value="" />
							     <input type="hidden" name="index" value="" />
					  	     </form>
		                     <img class="direct-chat-img" src="${pageContext.request.contextPath }/resources/img/profile/${channel.renamedFileName}">
		                     <h6 class="h6">${channel.memberName }</h6>
	                     </td>
	                 </tr>
	                 </c:forEach>
	                 </tbody>
	             </table>
	          </div><!-- /#aside-bottom -->      
	    </aside><!-- /#aside-channel -->  
	    
                
        <!-- 채팅 컨텐츠 -->    
        <div id="chatContent" class="chat-wrapper">
           	<!-- 채널 제목 -->
            <div class="user-block" id="chat_userName">
              <img class="img-circle" src="${pageContext.request.contextPath}/resources/img/profile/${channelList[index].renamedFileName}" alt="user image">
              <span class="username">${channelList[index].memberName }</span> 
            </div>
            
            
            <!-- 날짜 구분선 -->
	        <!-- <div class="chat-date-wrapper">
	            <div class="divider"></div>
	            <span class="date">2월 12일</span>
	        </div> -->
                
            <!-- 채팅 내용 -->
            <div class="direct-chat-messages" id="chatSide-msg-wrapper">
	            <c:forEach items="${chatList }" var="chat">
	            <c:if test="${channelList[index].channelNo eq chat.channelNo }">
	            
	            <!-- 내 메시지 -->
	            <c:if test="${chat.sender eq memberLoggedIn.memberId }">
	            <div class="direct-chat-msg right">
					<img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/${chat.renamedFileName }">
					<div class="chat-text">
						<div class="direct-chat-infos">
							<span class="chat-name">${chat.memberName }</span>
							<span class="chat-time">${chat.sendDate } &nbsp;&nbsp;</span>
						</div>
						<p>${chat.msg }</p>
					</div>
					<!-- <button type="button" class="btn-copyToNtc" title="개발부 게시글로 올리기"><i class="far fa-clipboard"></i></button> -->
				</div>
	            </c:if>
            
	            <!-- 상대방 메시지 -->
	            <c:if test="${chat.sender != memberLoggedIn.memberId }">
	            <div class="direct-chat-msg">
		            <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/${chat.renamedFileName }">
					<div class="chat-text">
						<div class="direct-chat-infos">
							<span class="chat-name">${chat.memberName }</span>
							<span class="chat-time">${chat.sendDate } &nbsp;&nbsp;</span>
						</div>
						<p>${chat.msg }</p>
					</div>
					<!-- <button type="button" class="btn-copyToNtc" title="개발부 게시글로 올리기"><i class="far fa-clipboard"></i></button> -->
				</div>
	            </c:if>
	            </c:if>
	            </c:forEach>
            </div><!-- /.direct-chat-messages -->
                
            <!-- 텍스트 에디터 -->
            <!-- <div class="input-group mb-3" id="div_textarea">
              <input type="text" id="message" class="form-control" placeholder="Message to "><div class="input-group-append" style="padding: 0px;"><button id="sendBtn" class="btn btn-outline-secondary" type="button">Send</button></div>
            </div> -->
            <input type="text" class="input-group mb-3" id="div_textarea">
        </div><!-- /#chatContent -->
            
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
	let $note = $(".note-editor .note-editable");
	$note.attr('role', 'input');
	
	$note.on('keydown', (key)=>{
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

function loadChatList(channelNo, memberName, renamedFileName, index) {
	console.log(channelNo);
	console.log(index);
	//$("#chatContent").children().remove();
	// name이 loadChatListFrm인 태그
      var f = document.loadChatListFrm;
		console.log(f);
      // form 태그의 하위 태그 값 매개 변수로 대입
      f[index].channelNo.value = channelNo;
      f[index].index.value = index;

      // input태그의 값들을 전송하는 주소
      f[index].action = "${pageContext.request.contextPath}/chat/loadChatList.do";

      // 전송 방식 : post
      f[index].method = "post";
      f[index].submit();
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
	stompClient.subscribe('/chat/${channelNo}', function(message) {
		console.log("receive from subscribe /chat/${channelNo} : ", message);
		let messageBody = JSON.parse(message.body);
		
		let html = '';
		if(messageBody.sender == '${memberLoggedIn.memberId}') {
        
       		html += '<div class="direct-chat-msg right"><img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/'+messageBody.renamedFileName+'">';
       		html += '<div class="chat-text"><div class="chat-infos">';
       		html += '<span class="chat-name">'+messageBody.memberName+'</span>';
       		html += '<div class="chat-time">'+messageBody.sendDate+'</div></div>';
       		html += '<p>'+messageBody.msg+'</p></div>';
       		/* <button type="button" class="btn-copyToNtc" title="개발부 게시글로 올리기"><i class="far fa-clipboard"></i></button> */
       		html += '</div>';
		}
		else {
			html += '<div class="direct-chat-msg right"><img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/'+messageBody.renamedFileName+'">';
       		html += '<div class="chat-text"><div class="chat-infos">';
       		html += '<span class="chat-name">'+messageBody.memberName+'</span>';
       		html += '<div class="chat-time">'+messageBody.sendDate+'</div></div>';
       		html += '<p>'+messageBody.msg+'</p></div>';
       		/* <button type="button" class="btn-copyToNtc" title="개발부 게시글로 올리기"><i class="far fa-clipboard"></i></button> */
       		html += '</div>';
		}
		
		$("#chatSide-msg-wrapper").append(html);
	});
});


function sendMessage() {
	let $note = $(".note-editor .note-editable");
	
	let data = {
		channelNo : "${channelNo}", 
		sender : "${memberLoggedIn.memberId }", 
		msg: $note.text(), 
		sendDate : new Date().getTime(), 
		type : "MESSAGE", 
		memberName : "${memberLoggedIn.memberName}", 
		renamedFileName : "${memberLoggedIn.renamedFileName}"
	}
	console.log(data);
	
	//채팅메세지: 1대1채팅을 위해 고유한 channelNo을 서버측에서 발급해 관리한다.
	stompClient.send('<c:url value="/chat/${channelNo}" />', {}, JSON.stringify(data));
	//message창 초기화
	$note.text('');
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