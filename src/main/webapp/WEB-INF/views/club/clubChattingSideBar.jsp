<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />

<style>
#setting-sidebar{height: 100%; background: #fff;}
.note-editor.note-frame{border: 0; border-radius: 0;}
</style>

<!-- 대화 사이드 바-->
    <div class="div-close" role="button" tabindex="0">
        <i class="fas fa-times close-sidebar"></i>
    </div>
    <div id="chat-memList">
        <ul>
        	<c:forEach items="${memberList}" var="mem">
        		<li class="chared-member"><img src="${pageContext.request.contextPath}/resources/img/profile/${mem.clubMemberList[0].renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile" title="${mem.clubMemberList[0].memberName }"></li>
        	</c:forEach>
           
        </ul>
    </div>
    <!-- Conversations are loaded here -->
    <div id="chatSide-msg-wrapper" class="direct-chat-messages">
    	<c:forEach items="${chatList}" var="chat">
        		<c:choose>
	     			<c:when test="${chat.sender eq memberLoggedIn.memberId }">
	     				<!-- 내 메시지 -->
				        <div class="direct-chat-msg right">
				            <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/${chat.renamedFileName}" alt="Message User Image">
				            <div class="chat-text">
				                <div class="chat-infos">
				                    <span class="chat-name">${chat.memberName }</span>
				                    <div class="chat-time">${chat.sendDate }</div>
				                </div>
				                <p>${chat.msg }</p>
				            </div>
				        </div>
	     				
	     			
	     			</c:when>
	     			
	     			<c:otherwise>
		     			<div class="direct-chat-msg">
				            <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/${chat.renamedFileName}" alt="Message User Image">
				            <div class="chat-text">
				                <div class="chat-infos">
				                    <span class="chat-name">${chat.memberName }</span>
				                    <div class="chat-time">${chat.sendDate }</div>
				                </div>
				                <p>${chat.msg }</p>
				            </div>
				        </div>
	     			
	     			</c:otherwise>
     		</c:choose>
        </c:forEach>
    </div>
    <!-- /#chatSide-msg-wrapper -->
    
    <!-- 텍스트 에디터 -->
    <input type="text" class="input-group mb-3" id="div_textarea">
    <div id="typing${channelNo}"></div>
    
<script type="text/javascript">
$(document).ready(function() {
	//소켓 생성
	let stompClient = createSocket();
	
	let $note = $("#setting-sidebar .note-editor .note-editable");
	$note.attr('role', 'input');
	
	$(document).on("keydown", "#setting-sidebar .note-editor .note-editable", function(key) {
		if (key.keyCode == 13) {// 엔터
			sendMessage(stompClient);
		}
	});
	
	//window focus이벤트핸들러 등록
	$(window).on("focus", function() {
		console.log("focus");
		//lastCheck();
	});
	
	//업무 사이드바 닫기
	$(".div-close").on('click',()=>{
	    var $side = $("#setting-sidebar");
	    if($side.hasClass('open')) {
	        $side.stop(true).animate({right:'-600px'});
	        $side.removeClass('open');
	    }
	    $side.empty();
	});
	
	$('#div_textarea').summernote({
	    focus: true,
	    lang: 'ko-KR',
	    height: 80,
	    toolbar: [
	        ['style', ['bold', 'italic', 'underline', 'strikethrough']],
	        ['color', ['color']],
	        ['para', ['ul', 'ol']],
	        ['insert', ['picture', 'link']]
	    ],
	    placeholder: '내 메시지'
	}); 
});


//소켓 생성
function createSocket(){
	//웹소켓 선언
	//1.최초 웹소켓 생성 url: /stomp
	let socket = new SockJS('<c:url value="/stomp" />');
	let stompClient = Stomp.over(socket);
	
	//connection이 맺어지면, 콜백함수가 호출된다.
	stompClient.connect({}, function(frame) {
		console.log("connected stomp over sockjs");
		console.log(frame);
		
	
		//stomp에서는 구독개념으로 세션을 관리한다. 핸들러 메소드의 @SendTo어노테이션과 상응한다.
		stompClient.subscribe('/chat/${channelNo}', function(message) {
			let section = document.querySelector('#chatSide-msg-wrapper');
			let messsageBody = JSON.parse(message.body);
			let myMsgInfoHtml = '';
			let otherMsg = '';
			console.log("receive from subscribe /chat/${channelNo} :", message);
			console.log("message="+messsageBody.sender);
	
			if(messsageBody.sender == '${memberLoggedIn.memberId}'){
	
				myMsgInfoHtml +='<div class="direct-chat-msg right">'
							  + '<img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/'+messsageBody.renamedFileName+'" alt="Message User Image">'
							  + '<div class="chat-text">'
							  + '<div class="chat-infos">'
							  + '<span class="chat-name">'+messsageBody.memberName+'</span>'
							  + '<div class="chat-time">'+messsageBody.sendDate+'</div></div>'
							  + '<p>'+messsageBody.msg+'</p></div></div>';
							  
			
				$("#chatSide-msg-wrapper").append(myMsgInfoHtml);
				
				
			}
			else{
				
				otherMsg  +='<div class="direct-chat-msg">'
						  + '<img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/'+messsageBody.renamedFileName+'" alt="Message User Image">'
						  + '<div class="chat-text">'
						  + '<div class="chat-infos">'
						  + '<span class="chat-name">'+messsageBody.memberName+'</span>'
						  + '<div class="chat-time">'+messsageBody.sendDate+'</div></div>'
						  + '<p>'+messsageBody.msg+'</p></div></div>';	
				
				
				$("#chatSide-msg-wrapper").append(otherMsg);
			} 
			
			stompClient.subscribe('/chat/typing', function(message) {
				console.log("receive from subscribe /chat/typing : ", message);
				let messageBody = JSON.parse(message.body);
				
				$("#whoIsTyping").remove();
				if("${channelNo}" == messageBody.channelNo && "${memberLoggedIn.memberId}" != messageBody.memberId) {
					$("#typing${channelNo}").append('<span id="whoIsTyping" style="padding-left: 10px; font-size: 15px; color: gray;">'+messageBody.memberName+' is typing...</span>');
				}
				setTimeout(function() {
					$("#whoIsTyping").remove();
					}, 1800);
			});
			
			//스크롤 최하단 포커싱
			section.scrollTop = section.scrollHeight;
		});
	});
	
	return stompClient;
}

function sendMessage(stompClient) {
	let $note = $("#setting-sidebar .note-editor .note-editable");
	
	let data = {
			channelNo : "${channelNo}",
			sender : "${memberLoggedIn.memberId}",
			msg : $note.text(),
			sendDate : new Date().getTime(),
			memberName : '${memberLoggedIn.memberName}',
			renamedFileName:'${memberLoggedIn.renamedFileName}',
			type: "MESSAGE"
		}
	

		//채팅메세지: 1:1채팅을 위해 고유한 chatId를 서버측에서 발급해 관리한다.
		stompClient.send('<c:url value="/chat/${channelNo}" />',{}, JSON.stringify(data));
		
		//message창 초기화
		$note.text('');
}
</script>