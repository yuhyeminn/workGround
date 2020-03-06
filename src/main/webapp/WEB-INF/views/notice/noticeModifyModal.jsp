<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 

<!-- 공지수정 모달 -->
<!-- 관리자: 전체공지만 수정 / 부서별공지는 내가속한 부서에서 수정 -->
<!-- 부서별 옵션: 내가속한 부서만 selected 그 외엔 disabled -->
<c:if test="${boardType=='total' || boardType=='dept'}">
<c:if test="${boardType == 'total'}">
<div class="modal fade" id="updateNoticeModal${n.noticeNo}" tabindex="-1" role="dialog" aria-labelledby="updateNoticeModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 공지 수정</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
</c:if>
<!-- 내가 속한 부서 공지 수정 모달 -->
<c:if test="${boardType == 'dept'}">
<div class="modal fade" id="updateDeptNoticeModal${n.noticeNo}" tabindex="-1" role="dialog" aria-labelledby="updateNoticeModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 부서 게시글 수정</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
</c:if>
      <form action="${pageContext.request.contextPath}/notice/updateNotice.do?noticeNo=${n.noticeNo}"
     			method="post"
     			enctype="multipart/form-data">
        <div class="modal-body">
            <div class="addNotice" style="padding: 1rem;">
              <div class="form-group">
                <label for="inputDept">부서</label>
                <select class="form-control custom-select" name="deptCode">
                 	<option value="all" selected>전체</option>
					<option value="D1" ${n.deptCode=='D1'?'selected="selected"':''}>기획부</option>
	                <option value="D2" ${n.deptCode=='D2'?'selected="selected"':'' }>디자인부</option>
	                <option value="D3" ${n.deptCode=='D3'?'selected="selected"':''}>개발부</option>
             	  	</select>
              </div>
              
              <c:if test="${boardType == 'dept'}">
              <input type="text" class="form-control"
		              	   ${memberLoggedIn.jobTitle=='관리자'?"style=display:none;":"style=display:block;"} 
		              	   value="${memberLoggedIn.deptCode=='D1'?'기획부':memberLoggedIn.deptCode=='D2'?'디자인부':'개발부'}"
		              	   readonly/>
		      </c:if>
		      
              <div class="form-group">
                <label for="inputName">공지 제목</label>
                <input type="text" id="inputName" class="form-control" value="${n.noticeTitle}" name="noticeTitle" required>
              </div>
              <div class="form-group" style="display:none;">
	              <label for="inputWriter">글쓴이</label>
	              <input type="text" id="inputName" name="noticeWriter" value="${memberLoggedIn.memberId}" class="form-control">
           	  </div>
              <div class="form-group">
                <label for="inputDescription">공지 내용</label>
                <textarea class="textarea" name="noticeContent" required>${n.noticeContent}</textarea>
              </div>
              <div class="form-group">
                <label for="exampleFormControlFile1">파일 첨부</label>
                <input type="file" class="form-control-file" id="exampleFormControlFile1" name="updateFile">
                <span class="fname">${n.noticeOriginalFileName!=null?n.noticeOriginalFileName:""}</span>
                <input type="hidden" name="noticeOriginalFileName" value="${n.noticeOriginalFileName!=null?n.noticeOriginalFileName:""} "/>
                <input type="hidden" name="noticeRenamedFileName" value="${n.noticeRenamedFileName!=null?n.noticeRenamedFileName:""} "/>
               	<c:if test="${n.noticeOriginalFileName!=null}">
               		<span class="deleteFileSpan">
	               		<input type="checkbox" name="delFileChk" id="delFileChk" />
	               		<label for="delFileChk">첨부파일삭제</label>	               		
               		</span>
               	</c:if>
              </div>
            </div><!-- /.card-body -->
        </div> <!--/.modal-body-->
        <div class="modal-footer">
          <button type="submit" class="btn btn-outline-success">수정</button>
          <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
        </div>
      </form>
    </div>
  </div>
</div>
</c:if>
	

<!-- 게시판 수정 모달 -->
<c:if test="${boardType=='community'}">
<div class="modal fade" id="updateCommuModal${c.commuNo}" tabindex="-1" role="dialog" aria-labelledby="updateBoardModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 커뮤니티 게시글 수정</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
       <form action="${pageContext.request.contextPath}/notice/updateCommunity.do?commuNo=${c.commuNo}"
     			method="post"
     			enctype="multipart/form-data">
        <div class="modal-body">
            <div class="addNotice" style="padding: 1rem;">
              <div class="form-group">
                 	<label for="inputName">게시글 제목</label>
                 	<input type="text" id="inputName" name="commuTitle" value="${c.commuTitle}" class="form-control" maxlength="15" placeholder="15자 이내로 입력하세요." required>
                 </div>
                 <div class="form-group" style="display:none;">
            		<label for="inputWriter">글쓴이</label>
             		<input type="text" id="inputName" name="commuWriter" value="${memberLoggedIn.memberId}" class="form-control">
           	  </div>
                 <div class="form-group">
                   <label for="inputDescription">게시글 내용</label>
                   <textarea class="textarea" name="commuContent" required>${c.commuContent}</textarea>
                 </div>
                 <div class="form-group">
                   <label for="exampleFormControlFile1">파일 첨부</label>
                   <input type="file" class="form-control-file" id="exampleFormControlFile1" name="updateFile">
                <span class="fname">${c.commuOriginalFileName!=null?c.commuOriginalFileName:""}</span>
                <input type="hidden" name="commuOriginalFileName" value="${c.commuOriginalFileName!=null?c.commuOriginalFileName:""} "/>
                <input type="hidden" name="commuRenamedFileName" value="${c.commuRenamedFileName!=null?c.commuRenamedFileName:""} "/>
               	<c:if test="${c.commuOriginalFileName!=null}">
               		<span class="deleteFileSpan">
	               		<input type="checkbox" name="delFileChk" id="delFileChk" />
	               		<label for="delFileChk">첨부파일삭제</label>	               		
               		</span>
               	</c:if>
                 </div>
            </div><!-- /.card-body -->
        </div> <!--/.modal-body-->
        <div class="modal-footer">
          <button type="submit" class="btn btn-outline-success">수정</button>
          <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
        </div>
      </form>
    </div>
  </div>
</div>
</c:if>