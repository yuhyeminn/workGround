<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />

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
	
	downloadFile(); //파일 다운로드하기
	delFile(); //파일 삭제하기
	
	tabActive(); //서브헤더 탭 활성화
});

//파일 다운로드하기
function downloadFile(){
	$(document).on('click', '.btn-down', e=>{
		let btnDown = e.target;
		let attachNo = btnDown.value;
		let $tr = $('#'+attachNo);
		let projectNo = '${project.projectNo}';
		let oName = $tr.find('.oName').val();
		let rName = $tr.find('.rName').val();
		
		location.href = "${pageContext.request.contextPath}/project/downloadFile.do?projectNo="+projectNo+"&oName="+oName+"&rName="+rName;
	});
}

//파일 삭제하기
function delFile(){
	let modal = document.querySelector("#modal-file-remove");
	let delFileName = document.querySelector("#del-fileName");
	let btnDel = document.querySelector("#btn-delFile");
	
	$(document).on('click', '.dropdown-file-remove', e=>{
		let btnRemove = e.target;
		let attachNo = btnRemove.value.split(',')[0];
		let oName = btnRemove.value.split(',')[1];
		let rName = btnRemove.value.split(',')[2];
		let projectNo = '${project.projectNo}';
		
		//삭제 모달창에 정보 뿌리기
		$(delFileName).text(oName);
		$(btnDel).val(btnRemove.value);
		
		let $tr = $('#'+attachNo);
		let data = {
				attachNo: attachNo*1,
				rName: rName,
				projectNo:projectNo
		};
		
		//삭제 클릭
		btnDel.addEventListener('click', ()=>{
			$.ajax({
				url: '${pageContext.request.contextPath}/project/deleteFile',
				data: data,
				dataType: 'json',
				type: 'POST',
				success: data=>{
					console.log(data);
					
					if(data.result==='success'){
						$tr.remove();
						$(modal).modal('hide');
					}
					else{
						alert("파일 삭제에 실패했습니다 :(");
					}
				},
				error: (x,s,e)=>{
					console.log(x,s,e);
				}
			});
		}); //end of 삭제클릭
		
	});
}

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

<!-- 프로젝트 관리자 -->
<c:set var="projectManager" value=""/>
<c:set var="pmObj" value=""/>
<c:set var="isprojectManager" value="false"/>
<c:forEach var="pm" items="${project.projectMemberList}">
	<c:if test="${pm.managerYn eq 'Y'}">
		<c:set var="projectManager" value="${projectManager=pm.memberId}" />
		<c:set var="pmObj" value="${pm}"/>
	</c:if>
	<c:if test="${pm.memberId eq memberLoggedIn.memberId }">
		<c:if test="${pm.managerYn eq 'Y'}"><c:set var="isprojectManager" value="true"/> </c:if>
	</c:if>
</c:forEach>
<!-- 나의 워크패드인 경우 -->
<c:if test="${project.privateYn=='Y'}">
	<c:set var="isprojectManager" value="true"/>
</c:if>


<!-- Content Wrapper. Contains page content -->
<!-- <div class="content-wrapper navbar-light"> -->
    <h2 class="sr-only">프로젝트 파일첨부</h2>
    <!-- Main content -->
    <div id="attachment-wrapper" class="content view">
        <h3 class="sr-only">파일첨부</h3>
        
        <!-- 첨부파일 테이블 -->
        <div id="card-projectAttach" class="table-responsive p-0">
            <table id="tbl-projectAttach" class="table table-hover text-nowrap">
                <thead>
                    <tr>
                        <th style="width: 50%">이름</th>
                        <th style="width: 30%">공유한 날짜</th>
                        <th style="width: 20%">공유한 사람</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach items="${wlList}" var="wl">
                <c:forEach items="${wl.workList}" var="w">
                	<c:forEach items="${w.attachmentList}" var="a">
                    <tr id="${a.attachmentNo}">
                     <input type="hidden" class="oName" value="${a.originalFilename}" />
                     <input type="hidden" class="rName" value="${a.renamedFilename}" />
                     <td>
                         <a href="">
                             <div class="img-wrapper">
                             	 <c:forTokens items="${fn:toLowerCase(a.renamedFilename)}" var="token" delims="." varStatus="vs">
                             	 <c:if test="${vs.last}">
                             	 	<c:choose>
                             	 		<c:when test="${token=='bmp' || token=='jpg' || token=='jpeg' || token=='gif' || token=='png' || token=='tif' || token=='tiff' || token=='jfif'}">
			                                 <img src="${pageContext.request.contextPath}/resources/upload/project/${project.projectNo}/${a.renamedFilename}" alt="첨부파일 미리보기 이미지">
                             	 		</c:when>
                             	 		<c:when test="${token!='bmp' && token!='jpg' && token!='jpeg' && token!='gif' && token!='png' && token!='tif' && token!='tiff' && token!='jfif'}">
			                                 <img src="${pageContext.request.contextPath}/resources/img/project/default-file.png" alt="첨부파일 미리보기 이미지">
                             	 		</c:when>
                             	 	</c:choose>
                             	 </c:if>
                             	 </c:forTokens>
                             </div>
                             <div class="imgInfo-wrapper">
                                 <p class="filename">${a.originalFilename}</p>
                                 <p class="filedir">${wl.worklistTitle} <i class="fas fa-chevron-right"></i> ${w.workTitle}</p>
                             </div>
                         </a>
                     </td>
                     <td>${a.attachmentEnrollDate}</td>
                     <td>
                         	${a.attachmentWriterMember.memberName}
                         <!-- 첨부파일 옵션 버튼 -->
                         <div class="dropdown ">
                             <button type="button" class="btn-file" data-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></button>
                             <div class="dropdown-menu dropdown-menu-right">
                                 <button type="button" class="dropdown-item btn-down" value="${a.attachmentNo}">다운로드</button>
                                 
                                 <!-- 파일삭제: 관리자, 프로젝트 팀장, 공유한 사람만 가능 -->
                                 <c:if test="${'admin'==memberLoggedIn.memberId || isprojectManager==true || a.attachmentWriterMember.memberId==memberLoggedIn.memberId}">
                                 <div class="dropdown-divider"></div>
                                 <button type="button" class="dropdown-item dropdown-file-remove" value="${a.attachmentNo},${a.originalFilename},${a.renamedFilename}" data-toggle="modal" data-target="#modal-file-remove">삭제</a>
                                 </c:if>
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
    <!-- /.content -->
<!-- /.content-wrapper -->

<!-- 파일 삭제 모달 -->
<div class="modal fade" id="modal-file-remove">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">파일 삭제</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>[<span id="del-fileName"></span>]파일을 정말 삭제하시겠습니까?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
                <button type="button" id="btn-delFile" class="btn btn-danger">삭제</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
