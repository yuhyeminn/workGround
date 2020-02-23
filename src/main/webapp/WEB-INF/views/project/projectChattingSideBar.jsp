<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />

<style>
#setting-sidebar{height: 100%; background: #fff;}
</style>

<!-- 대화 사이드 바-->
    <div class="div-close" role="button" tabindex="0">
        <i class="fas fa-times close-sidebar"></i>
    </div>
    <div id="chat-memList">
        <ul>
        	<c:forEach items="${projectMemberList}" var="mem">
        		<li class="chared-member"><img src="${pageContext.request.contextPath}/resources/img/profile/${mem.renamedFileName}" class="img-circle img-profile ico-profile" title="${mem.memberName }"></li>
        	</c:forEach>
           
        </ul>
    </div>
    <!-- Conversations are loaded here -->
    <div id="chatSide-msg-wrapper" class="direct-chat-messages" style="height:20.8rem">
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
				           <button type="button" class="btn-copyToNtc" title="개발부 게시글로 올리기" data-toggle="modal" data-target="#addNoticeForDeptModal"><i class="far fa-clipboard"></i></button>
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
				            <button type="button" class="btn-copyToNtc" title="개발부 게시글로 올리기" data-toggle="modal" data-target="#addNoticeForDeptModal"><i class="far fa-clipboard"></i></button>
				        </div>
	     			
	     			</c:otherwise>
     		</c:choose>
        </c:forEach>
    </div>
    <!-- /#chatSide-msg-wrapper -->
    <input type="text" id="text-message" style="width:80%"/>
    <button id="send-Btn" class="btn btn-info">send</button>
    

<script type="text/javascript">
$(document).ready(function() {
	$(document).on("click", "#send-Btn", function() {
		console.log("#send-msg-Btn 실행성공");
		sendMessage();
	});
	$(document).on("keydown", "#text-message", function(key) {
		if (key.keyCode == 13) {// 엔터
			sendMessage();
		}
	});
	
	//window focus이벤트핸들러 등록
	$(window).on("focus", function() {
		console.log("focus");
		//lastCheck();
	});
	
	uploadNotice();
	
	//업무 사이드바 닫기
	$(".div-close").on('click',()=>{
	    var $side = $("#setting-sidebar");
	    if($side.hasClass('open')) {
	        $side.stop(true).animate({right:'-520px'});
	        $side.removeClass('open');
	    }
	});
	
	/* 	$('#summernote').summernote({
    focus: true,
    lang: 'ko-KR',
    height: 120,
    toolbar: [
        ['style', ['bold', 'italic', 'underline', 'strikethrough']],
        ['para', ['ul', 'ol']],
        ['insert', ['picture', 'link']]
    ],
    placeholder: '내 메시지...'
}); */
});



//웹소켓 선언
//1.최초 웹소켓 생성 url: /stomp
let socket = new SockJS('<c:url value="/chat" />');
let stompClient = Stomp.over(socket);

//connection이 맺어지면, 콜백함수가 호출된다.
stompClient.connect({}, function(frame) {
	console.log("connected stomp over sockjs");
	console.log(frame);
	

	//stomp에서는 구독개념으로 세션을 관리한다. 핸들러 메소드의 @SendTo어노테이션과 상응한다.
	stompClient.subscribe('/chat/${channelNo}', function(message) {
		console.log("receive from subscribe /chat/${channelNo} :", message);
		let messsageBody = JSON.parse(message.body);
		console.log("message="+messsageBody.sender);
		let myMsgInfoHtml = '';
		let otherMsg = '';

		if(messsageBody.sender == '${memberLoggedIn.memberId}'){

			myMsgInfoHtml +='<div class="direct-chat-msg right">'
						  + '<img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/'+messsageBody.renamedFileName+'" alt="Message User Image">'
						  + '<div class="chat-text">'
						  + '<div class="chat-infos">'
						  + '<span class="chat-name">'+messsageBody.memberName+'</span>'
						  + '<div class="chat-time">'+messsageBody.sendDate+'</div></div>'
						  + '<p>'+messsageBody.msg+'</p></div>'
						  +'<button type="button" class="btn-copyToNtc" title="개발부 게시글로 올리기" data-toggle="modal" data-target="#addNoticeForDeptModal"><i class="far fa-clipboard"></i></button></div>';
						  
		
			$("#chatSide-msg-wrapper").append(myMsgInfoHtml);
			
			
		}
		else{
			otherMsg  +='<div class="direct-chat-msg">'
					  + '<img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/'+messsageBody.renamedFileName+'" alt="Message User Image">'
					  + '<div class="chat-text">'
					  + '<div class="chat-infos">'
					  + '<span class="chat-name">'+messsageBody.memberName+'</span>'
					  + '<div class="chat-time">'+messsageBody.sendDate+'</div></div>'
					  + '<p>'+messsageBody.msg+'</p></div>'
					  +'<button type="button" class="btn-copyToNtc" title="게시글로 올리기" data-toggle="modal" data-target="#addNoticeForDeptModal"><i class="far fa-clipboard"></i></button></div>';	
			
			
			$("#chatSide-msg-wrapper").append(otherMsg);
		} 
		
	});
});

function sendMessage() {
	let data = {
			channelNo : "${channelNo}",
			sender : "${memberLoggedIn.memberId}",
			msg : $("#text-message").val(),
			sendDate : new Date().getTime(),
			memberName : '${memberLoggedIn.memberName}',
			renamedFileName:'${memberLoggedIn.renamedFileName}',
			type: "MESSAGE"
		}
	
		//채팅메세지: 1:1채팅을 위해 고유한 chatId를 서버측에서 발급해 관리한다.
		stompClient.send('<c:url value="/chat/${channelNo}" />',{}, JSON.stringify(data));
		
		//message창 초기화
		$('#text-message').val('');
}

function uploadNotice(){
	//summernote 설정
	$('#noticeContent').summernote({
	    lang: 'ko-KR',
	    height: 120,
	    toolbar: [
	        ['style', ['bold', 'italic', 'underline', 'strikethrough']],
	        ['color', ['color']],
	        ['fontsize', ['fontsize']],
	        ['para', ['ul', 'ol']],
	        ['table', ['table']]
	    ],
	});
	/* $('#noticeContent').summernote('insertText','채팅내용'); */
	
	$(document).on('click','.btn-copyToNtc',function(){
		//form 내용 초기화
		$("#addNoticeForDeptModal #noticeTitle").val('');
		$("#addNoticeForDeptModal #noticeFile").val('');
		
		var $msg = $(this).parent();
		var chatContent = $msg.children(".chat-text").children("p").text();
		
		$("#chatNoticeFrm .note-editable").text(chatContent);
		$("#noticeContent").val(chatContent)
	})
	
	$("#chatNtc-upload").on('click',function(){
		var formData = new FormData($('#chatNoticeFrm')[0]);
		$('#addNoticeForDeptModal').modal('hide');
		$.ajax({
			 type: "POST", 
			 enctype: 'multipart/form-data', // 필수 
			 url: "${pageContext.request.contextPath}/notice/uploadChatNotice.do",
			 data: formData,
			 processData: false, // 필수 
			 contentType: false, // 필수
			 cache: false, 
			 success: data=>{
				 if(data.isUploaded){
					 alert("성공적으로 등록되었습니다");
				 }else{
					 alert("공지 등록에 실패했습니다.");
				 }
			 },
			 error:(jqxhr, textStatus, errorThrown)=>{
				 console.log(jqxhr, textStatus, errorThrown);
			 } 
		 });
	})
}

</script>