<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 

<!-- 공지 추가 모달 -->
<!-- 관리자: 전체/부서별 공지 작성 가능 -->
<!-- 부서별: 자기 부서는 selected / 나머지 부서 disabled -->
<div class="modal fade" id="addNoticeModal" tabindex="-1" role="dialog" aria-labelledby="addNoticeModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 공지 작성</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form action="${pageContext.request.contextPath}/notice/noticeFormEnd.do"
      		method="post"
      		enctype="multipart/form-data">
        <div class="modal-body">
          <div class="addNotice" style="padding: 1rem;">
            <div class="form-group">
              <label for="inputDept">부서</label>
              <select class="form-control custom-select" name="deptCode">
                 <option value="all" selected>전체</option>
				<option value="D1">기획부</option>
                <option value="D2">디자인부</option>
                <option value="D3">개발부</option>
              </select>
            </div>
            <div class="form-group">
              <label for="inputName">공지 제목</label>
              <input type="text" id="inputName" name="noticeTitle" class="form-control" required>
            </div>
            <div class="form-group" style="display:none;">
              <label for="inputName">글쓴이</label>
              <input type="text" id="inputName" name="noticeWriter" value="${memberLoggedIn.memberId}" class="form-control">
            </div>
            <!-- <div class="form-group">
              <label for="inputDescription">공지 카드 내용</label>
              <input type="text" class="form-control" maxlength="35" placeholder="35자 이내로 입력하세요.">
            </div> -->
            <div class="form-group">
              <label for="inputDescription">공지 내용</label>
              <textarea class="textarea" name="noticeContent" required></textarea>
            </div>
            <div class="form-group">
              <label for="exampleFormControlFile1">파일 첨부</label>
              <input type="file" class="form-control-file" id="exampleFormControlFile1" name="upFile">
            </div>
          </div><!-- /.card-body -->
        </div> <!--/.modal-body-->
        <div class="modal-footer">
          <button type="submit" class="btn btn-outline-success">작성</button>
          <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 내가 속한 부서의 공지 추가 모달 -->
<!-- 관리자: 전체/부서별 공지 작성 가능 -->
<!-- 부서별: 자기 부서는 selected / 나머지 부서 disabled -->
<div class="modal fade" id="addNoticeForDeptModal" tabindex="-1" role="dialog" aria-labelledby="addNoticeForDeptModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 부서 게시글 작성</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form action="${pageContext.request.contextPath}/notice/noticeFormEnd.do"
      		method="post"
      		enctype="multipart/form-data">
        <div class="modal-body">
          <div class="addNotice" style="padding: 1rem;">
            <div class="form-group">
              <label for="inputDept">부서</label>
              <select class="form-control custom-select" name="deptCode" ${memberLoggedIn.jobTitle=='관리자'?'"style=display:block;"':"style=display:none;"}>
                <option value="all" selected>전체</option>
				<option value="D1" ${memberLoggedIn.deptCode=='D1'?'selected="selected"':''}>기획부</option>
                <option value="D2" ${memberLoggedIn.deptCode=='D2'?'selected="selected"':''}>디자인부</option>
                <option value="D3" ${memberLoggedIn.deptCode=='D3'?'selected="selected"':''}>개발부</option>
              </select>
              <input type="text" class="form-control"
              		 ${memberLoggedIn.jobTitle=='관리자'?"style=display:none;":"style=display:block;"} 
              		 value="${memberLoggedIn.deptCode=='D1'?'기획부':memberLoggedIn.deptCode=='D2'?'디자인부':'개발부'}"
              		 readonly/>
            </div>
            <div class="form-group">
              <label for="inputName">게시글 제목</label>
              <input type="text" id="inputName" name="noticeTitle" class="form-control" required>
            </div>
            <div class="form-group" style="display:none;">
              <label for="inputWriter">글쓴이</label>
              <input type="text" id="inputName" name="noticeWriter" value="${memberLoggedIn.memberId}" class="form-control">
            </div>
            <!-- <div class="form-group">
              <label for="inputDescription">공지 카드 내용</label>
              <input type="text" class="form-control" maxlength="35" placeholder="35자 이내로 입력하세요.">
            </div> -->
            <div class="form-group">
              <label for="inputDescription">게시글 내용</label>
              <textarea class="textarea" name="noticeContent" required></textarea>
            </div>
            <div class="form-group">
              <label for="exampleFormControlFile1">파일 첨부</label>
              <input type="file" class="form-control-file" id="exampleFormControlFile1" name="upFile">
            </div>
          </div><!-- /.card-body -->
        </div> <!--/.modal-body-->
        <div class="modal-footer">
          <button type="submit" class="btn btn-outline-success">작성</button>
          <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 게시판 추가 모달 -->
<div class="modal fade" id="addBoardModal" tabindex="-1" role="dialog" aria-labelledby="addBoardModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 커뮤니티 게시글 작성</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <form action="${pageContext.request.contextPath}/notice/communityFormEnd.do"
      		method="post"
      		enctype="multipart/form-data">
          <div class="modal-body">
              <div class="addNotice" style="padding: 1rem;">
                <div class="form-group">
                  <label for="inputName">게시글 제목</label>
                  <input type="text" id="inputName" name="commuTitle" class="form-control" maxlength="15" placeholder="15자 이내로 입력하세요." required>
                </div>
                <div class="form-group" style="display:none;">
             		<label for="inputWriter">글쓴이</label>
              		<input type="text" id="inputName" name="commuWriter" value="${memberLoggedIn.memberId}" class="form-control">
            	</div>
                <div class="form-group">
                  <label for="inputDescription">게시글 내용</label>
                  <textarea class="textarea" name="commuContent" required></textarea>
                </div>
                <div class="form-group">
                  <label for="exampleFormControlFile1">파일 첨부</label>
                  <input type="file" class="form-control-file" id="exampleFormControlFile1" name="upFile">
                </div>
              </div><!-- /.card-body -->
          </div> <!--/.modal-body-->
          <div class="modal-footer">
            <button type="submit" class="btn btn-outline-success">작성</button>
            <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
          </div>
        </form>
      </div>
    </div>
</div>