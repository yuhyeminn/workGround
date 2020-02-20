<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />

<style>
#setting-sidebar{height: 100%; background: #fff;}
</style>

<script>
$(()=>{
	//업무 사이드바 닫기
	$(".div-close").on('click',()=>{
	    var $side = $("#setting-sidebar");
	    if($side.hasClass('open')) {
	        $side.stop(true).animate({right:'-520px'});
	        $side.removeClass('open');
	    }
	});
	
	$('#summernote').summernote({
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
});

</script>

<!-- 대화 사이드 바-->
    <div class="div-close" role="button" tabindex="0">
        <i class="fas fa-times close-sidebar"></i>
    </div>
    <div id="chat-memList">
        <ul>
            <li class="chared-member"><img src="${pageContext.request.contextPath}/resources/img/profile/default.jpg" alt="User Avatar" class="img-circle img-profile ico-profile" title="이름"></li>
            <li class="chared-member"><img src="${pageContext.request.contextPath}/resources/img/profile/default.jpg" alt="User Avatar" class="img-circle img-profile ico-profile" title="이름"></li>
        </ul>
    </div>
    <!-- Conversations are loaded here -->
    <div id="chatSide-msg-wrapper" class="direct-chat-messages" style="height:20.8rem">
        <!-- 날짜 구분선 -->
        <div class="chat-date-wrapper">
            <div class="divider"></div>
            <span class="date">2월 12일</span>
        </div>

        <div class="direct-chat-msg">
            <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/default.jpg" alt="Message User Image">
            <div class="chat-text">
                <div class="chat-infos">
                    <span class="chat-name">이주현</span>
                    <div class="chat-time">오후 2:00</div>
                </div>
                <p>아아아아ㅏㅇ아아아아아아아아아아아아아ㅏㅇ아ㅏ아아아아아앙아아아아아아아아아ㅏㅇ아아아아아아아아아아아아아ㅏㅇ아ㅏ아아아아아앙아아아아아</p>
            </div>
            <button type="button" class="btn-copyToNtc" title="개발부 게시글로 올리기"><i class="far fa-clipboard"></i></button>
        </div>
        
        <!-- 내 메시지 -->
        <div class="direct-chat-msg right">
            <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/default.jpg" alt="Message User Image">
            <div class="chat-text">
                <div class="chat-infos">
                    <span class="chat-name">이주현</span>
                    <div class="chat-time">오후 2:00</div>
                </div>
                <p>Is this template really for free? That's unbelievable!</p>
            </div>
            <button type="button" class="btn-copyToNtc" title="개발부 게시글로 올리기"><i class="far fa-clipboard"></i></button>
        </div>

        <!-- 날짜 구분선 -->
        <div class="chat-date-wrapper">
            <div class="divider"></div>
            <span class="date">오늘</span>
        </div>

        <div class="direct-chat-msg">
            <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/default.jpg" alt="Message User Image">
            <div class="chat-text">
                <div class="chat-infos">
                    <span class="chat-name">이주현</span>
                    <div class="chat-time">오후 2:00</div>
                </div>
                <p>아아아아ㅏㅇ아아아아아아아아아아아아아ㅏㅇ아ㅏ아아아아아앙아아아아아아아아아ㅏㅇ아아아아아아아아아아아아아ㅏㅇ아ㅏ아아아아아앙아아아아아</p>
            </div>
            <button type="button" class="btn-copyToNtc" title="개발부 게시글로 올리기"><i class="far fa-clipboard"></i></button>
        </div>
        
        <!-- 내 메시지 -->
        <div class="direct-chat-msg right">
            <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/default.jpg" alt="Message User Image">
            <div class="chat-text">
                <div class="chat-infos">
                    <span class="chat-name">이주현</span>
                    <div class="chat-time">오후 2:00</div>
                </div>
                <p>Is this template really for free? That's unbelievable!</p>
            </div>
            <button type="button" class="btn-copyToNtc" title="개발부 게시글로 올리기"><i class="far fa-clipboard"></i></button>
        </div>

    </div><!-- /#chatSide-msg-wrapper -->
    <div id="summernote"></div>
