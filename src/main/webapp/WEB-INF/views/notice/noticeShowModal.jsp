<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 

<c:if test="${boardType=='total' || boardType=='dept'}">
<c:if test="${boardType == 'total'}">
<%-- 전체 공지 상세보기 모달 --%>
<div class="modal fade" id="noticeViewModal${n.noticeNo}" tabindex="-1" role="dialog" aria-labelledby="noticeViewModal${n.noticeNo}" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-exclamation-circle"></i>&nbsp; 전체 공지</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
</c:if>
<c:if test="${boardType == 'dept'}">
<%-- 부서 게시글 상세보기 모달 --%>
<div class="modal fade" id="myDeptNoticeViewModal${n.noticeNo}" tabindex="-1" role="dialog" aria-labelledby="myDeptNoticeViewModal${n.noticeNo}" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><span id="myDept"><i class="fas fa-user"></i> &nbsp;${memberLoggedIn.deptCode=='D1'?"기획":memberLoggedIn.deptCode=='D2'?"디자인":"개발" }</span>&nbsp; 부서 게시글</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
</c:if>
      <div class="modal-body">
        <div class="noticeView">
          <p class="view-title">${n.noticeTitle}</p>
          <div class="user-block" style="margin-bottom: .5rem;">
            <img class="img-circle" src="${pageContext.request.contextPath}/resources/img/profile/${n.renamedFileName}" alt="User Image">
            <span class="username"><a href="#" style="color: black;">작성자 ${n.memberName}</a></span>
            <span class="description">게시일 ${n.noticeDate}</span>
          </div>
            <div class="view-body">
				<c:set var="nFileNameCnt" value="${fn:trim(n.noticeRenamedFileName)}"/>
		   	    <c:if test="${n.noticeRenamedFileName != null && fn:length(nFileNameCnt) != 0}">
   	              <img class="view-img" src="${pageContext.request.contextPath}/resources/upload/notice/${n.noticeRenamedFileName}">
   	            </c:if>
              <p class="view-content">${n.noticeContent}</p>
            </div>
            <!-- /.view-body -->
            <div class="comment-count"><i class="fas fa-comments"></i>&nbsp; 댓글 <span>(${fn:length(n.noticeCommentList)})</span></div>
            <div class="card-footer card-comments">
	            	<c:forEach items="${n.noticeCommentList}" var="nc">
            		<c:if test="${nc.noticeCommentLevel == 1}">
		              <div class="card-comment comment-level1">
		                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${nc.commentWriterProfile}" alt="User Image">
		                <div class="comment-text">
		                  <span class="username">${nc.commentWriterName}<span class="text-muted float-right">${nc.noticeCommentDate}</span></span>
		                  <span>${nc.noticeCommentContent}</span>
		                  <c:if test="${memberLoggedIn.memberId == 'admin' || memberLoggedIn.memberId == nc.noticeCommentWriter}">
			                  <button class="comment-delete float-right" onclick="deleteNoticeComment(${nc.noticeCommentNo});">삭제</button>
		                  </c:if>
		                </div>
		              </div>
		        
		              <c:forEach items="${n.noticeCommentList}" var="nc2">
		              	<c:if test="${nc2.noticeCommentLevel == 2 && nc2.noticeCommentRef == nc.noticeCommentNo}">
			              <div class="card-comment comment-level2">
			                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${nc2.commentWriterProfile}" alt="User Image">
			                <div class="comment-text">
			                  <span class="username">${nc2.commentWriterName}<span class="text-muted float-right">${nc2.noticeCommentDate}</span></span>
			                  <span>${nc2.noticeCommentContent}</span>
			                  <c:if test="${memberLoggedIn.memberId == 'admin' || memberLoggedIn.memberId == nc2.noticeCommentWriter}">
				                  <button class="comment-delete float-right" onclick="deleteNoticeComment(${nc2.noticeCommentNo});">삭제</button>
				              </c:if>
			                </div>
			              </div>
		              	</c:if>
		              </c:forEach>
            		</c:if>
                </c:forEach>
            </div>
             <div class="card-footer">
	              <form action="${pageContext.request.contextPath}/notice/noticeCommentInsert.do" 
              		method="post"
              		onsubmit="return checkComment(noticeCommentContent.value);">
                <img class="img-fluid img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${memberLoggedIn.renamedFileName}">
                <div class="img-push">
                  <input type="hidden" name="noticeRef" value="${n.noticeNo}" />
                  <input type="hidden" name="noticeCommentWriter" value="${memberLoggedIn.memberId}"/>
                  <input type="hidden" name="noticeCommentLevel" value="1" />
                  <input type="hidden" name="noticeCommentRef" value="0" />
                  <input type="text" name="noticeCommentContent" class="form-control form-control-sm comment-text-area" placeholder="댓글을 입력하세요."/>
                  <input class="comment-submit" type="submit" value="등록" />
                </div>
              </form>
            </div> <!-- /.card-footer -->
          </div> <!-- /.card -->
      </div>
    </div>
  </div>
</div>
</c:if>

<c:if test="${boardType=='community'}">
<%-- 게시판 상세보기 모달 --%>
<div class="modal fade" id="boardViewModal${c.commuNo}" tabindex="-1" role="dialog" aria-labelledby="boardViewModal${c.commuNo}" aria-hidden="true">
<div class="modal-dialog" role="document">
  <div class="modal-content">
    <div class="modal-header">
      <h5 class="modal-title"><i class="fas fa-sticky-note"></i>&nbsp; 커뮤니티</h5>
      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <div class="modal-body">
      <div class="boardView">
        <p class="view-title">${c.commuTitle }</p>
        <div class="user-block" style="margin-bottom: .5rem;">
        	<img class="img-circle" src="${pageContext.request.contextPath}/resources/img/profile/${c.renamedFileName}" alt="User Image">
          <span class="username"><a href="#" style="color: black;">작성자 ${c.memberName }</a></span>
          <span class="description">게시일 ${c.commuDate }</span>
        </div>
          <div class="view-body">
 	           	<c:set var="cFileNameCnt" value="${fn:trim(c.commuRenamedFileName)}"/>
  	        <c:if test="${c.commuRenamedFileName != null && fn:length(cFileNameCnt) != 0}">
  	          <img class="view-img" src="${pageContext.request.contextPath}/resources/upload/community/${c.commuRenamedFileName}" alt="">
		</c:if>
            <p class="view-content">${c.commuContent }</p>
          </div>
          <!-- /.view-body -->
          <div class="comment-count"><i class="fas fa-comments"></i>&nbsp; 댓글 <span>(${fn:length(c.communityCommentList)})</span></div>
          <div class="card-footer card-comments">
           	<c:forEach items="${c.communityCommentList}" var="cc">
          		<c:if test="${cc.commuCommentLevel == 1}">
              <div class="card-comment comment-level1">
                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${cc.commentWriterProfile}" alt="User Image">
                <div class="comment-text">
                  <span class="username">${cc.commentWriterName}<span class="text-muted float-right">${cc.commuCommentDate}</span></span>
                  <span>${cc.commuCommentContent}</span>
                  <c:if test="${memberLoggedIn.memberId == 'admin' || memberLoggedIn.memberId == cc.commuCommentWriter}">
	                  <button class="comment-delete float-right" onclick="deleteCommunityComment(${cc.commuCommentNo});">삭제</button>
                  </c:if>
                  <!-- <button class="comment-reply float-right">답글</button> -->
                </div>
              </div>
              <c:forEach items="${c.communityCommentList}" var="cc2">
              	<c:if test="${cc2.commuCommentLevel == 2 && cc2.commuCommentRef == cc.commuCommentNo}">
	              <div class="card-comment comment-level2">
	                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${cc2.commentWriterProfile}" alt="User Image">
	                <div class="comment-text">
	                  <span class="username">${cc2.commentWriterName}<span class="text-muted float-right">${cc2.commuCommentDate}</span></span>
	                  <span>${cc2.commuCommentContent}</span>
	                  <c:if test="${memberLoggedIn.memberId == 'admin' || memberLoggedIn.memberId == cc2.commuCommentWriter}">
		                  <button class="comment-delete float-right" onclick="deleteCommunityComment(${cc2.commuCommentNo});">삭제</button>
		              </c:if>
	                </div>
	              </div>
              	</c:if>
              </c:forEach>
          		</c:if>
          	</c:forEach>
          </div>
           <div class="card-footer">
             <form action="${pageContext.request.contextPath}/community/communityCommentInsert.do" 
            		method="post"
            		onsubmit="return checkComment(commuCommentContent.value);">
              <img class="img-fluid img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${memberLoggedIn.renamedFileName}">
              <div class="img-push">
                <input type="hidden" name="commuRef" value="${c.commuNo}" />
                <input type="hidden" name="commuCommentWriter" value="${memberLoggedIn.memberId }"/>
                <input type="hidden" name="commuCommentLevel" value="1" />
                <input type="hidden" name="commuCommentRef" value="0" />
                <input type="text" name="commuCommentContent" class="form-control form-control-sm comment-text-area" placeholder="댓글을 입력하세요."/>
                <input class="comment-submit" type="submit" value="등록" />
              </div>
            </form>
          </div> <!-- /.card-footer -->
        </div> <!-- /.card -->
      </div>
    </div>
  </div>
</div>
</c:if>