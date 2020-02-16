<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<script src="${pageContext.request.contextPath}/resources/plugins/datatables/jquery.dataTables.js"></script>
<script src="${pageContext.request.contextPath}/resources/plugins/datatables-bs4/js/dataTables.bootstrap4.js"></script>
<script>
$(function(){
	//데이터 테이블 설정
	$('#tbl-projectAttach').DataTable({
        "paging": true,
        "lengthChange": false,
        "searching": false,
        "ordering": true,
        "info": false,
        "autoWidth": false,
    });
	
	tabActive(); //서브헤더 탭 활성화
});

//서브헤더 탭 active
function tabActive(){
    let tabArr = document.querySelectorAll("#navbar-tab li");

    tabArr.forEach((obj, idx)=>{
        let $obj = $(obj);
        if($obj.hasClass('active')){
            $obj.removeClass('active');
        }
    });

    $("#tab-attachment").addClass("active");
}
</script>		

<!-- Content Wrapper. Contains page content -->
<!-- <div class="content-wrapper navbar-light"> -->
    <h2 class="sr-only">프로젝트 파일첨부</h2>
    <!-- Main content -->
    <div id="attachment-wrapper" class="content view">
        <h3 class="sr-only">파일첨부</h3>
        <div class="container-fluid"> 
            <!-- 첨부파일 테이블 -->
            <div id="card-projectAttach" class="card">
                <div class="card-body table-responsive p-0">
                    <table id="tbl-projectAttach" class="table table-hover text-nowrap">
                        <thead>
                            <tr>
                                <th style="width: 35%">이름</th>
                                <th style="width: 20%">크기</th>
                                <th style="width: 20%">공유한 날짜</th>
                                <th style="width: 25%">공유한 사람</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${wlList}" var="wl">
                        <c:forEach items="${wl.workList}" var="w">
                        	<c:forEach items="${w.attachmentList}" var="a">
                            <tr>
	                            <td>
	                                <a href="">
	                                    <div class="img-wrapper">
	                                        <img src="${pageContext.request.contextPath}/resources/img/project/${a.renamedFilename}" alt="첨부파일 미리보기 이미지">
	                                    </div>
	                                    <div class="imgInfo-wrapper">
	                                        <p class="filename">${a.originalFilename}</p>
	                                        <p class="filedir">${wl.worklistTitle} <i class="fas fa-chevron-right"></i> ${w.workTitle}</p>
	                                    </div>
	                                </a>
	                            </td>
	                            <td>${a.attachmentSize} KB</td>
	                            <td>${a.attachmentEnrollDate}</td>
	                            <td>
	                                	${a.attachmentWriterMember.memberName}
	                                <!-- 첨부파일 옵션 버튼 -->
	                                <div class="dropdown ">
	                                    <button type="button" class="btn-file" data-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></button>
	                                    <div class="dropdown-menu dropdown-menu-right">
	                                        <a href="#" class="dropdown-item">다운로드</a>
	                                        <div class="dropdown-divider"></div>
	                                        <a href="#" class="dropdown-item dropdown-file-remove" data-toggle="modal" data-target="#modal-file-remove">삭제</a>
	                                    </div>
	                                </div>
	                            </td>
                            </tr>
                            </c:forEach>
                        </c:forEach>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <!-- /.card-body -->
            </div>
            <!-- /.card -->
        </div>
        <!-- /.container-fluid -->
    </div>
    <!-- /.content -->
<!-- </div> -->
<!-- /.content-wrapper -->

<!-- 파일 삭제 모달 -->
<div class="modal fade" id="modal-file-remove">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">링크 삭제</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>[]파일을 정말 삭제하시겠습니까?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
                <button type="button" class="btn btn-danger">삭제</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
