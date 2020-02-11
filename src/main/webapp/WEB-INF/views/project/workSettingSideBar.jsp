<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<style>
.e-input-group:not(.e-float-icon-left), .e-input-group.e-success:not(.e-float-icon-left), .e-input-group.e-warning:not(.e-float-icon-left), .e-input-group.e-error:not(.e-float-icon-left), .e-input-group.e-control-wrapper:not(.e-float-icon-left), .e-input-group.e-control-wrapper.e-success:not(.e-float-icon-left), .e-input-group.e-control-wrapper.e-warning:not(.e-float-icon-left), .e-input-group.e-control-wrapper.e-error:not(.e-float-icon-left) {
    border: none;
}
</style>
<!-- 현재 로그인 한 회원이 업무에 배정되어있는 멤버인지 확인 -->
<c:set var="isChargedMember" value="false" />
<c:forEach var="wcm" items="${work.workChargedMemberList}">
	<c:if test="${memberLoggedIn.memberId eq wcm.memberId}">
		<c:set var="isChargedMember" value="true" />
	</c:if>
</c:forEach>
	
	<div class="div-close" role="button" tabindex="0">
    	<i class="fas fa-times close-sidebar"></i>
    </div>
    <!-- Control sidebar content goes here -->
    <div class="p-3">
    <i class="fas fa-star"></i>
    <span class="setting-side-title">${work.workTitle}</span>
    <p class="setting-contents-inform">
        <span>#${work.workNo }</span>
        <span class="setting-contents-date">작성일 ${work.workStartDate }</span>
    </p>
    </div>
    
    <ul class="nav work-setting-tabs nav-tabs" id="custom-content-above-tab" role="tablist">
        <li class="nav-item setting-navbar-tab">
        <button type="button" id="custom-content-work-setting-tab" data-toggle="pill" href="#custom-content-work-setting" role="tab" aria-controls="custom-content-work-setting" aria-selected="true">속성</button>
        </li>
        <li class="nav-item setting-navbar-tab">
        <button type="button" id="custom-content-above-comment-tab" data-toggle="pill" href="#custom-content-above-comment" role="tab" aria-controls="custom-content-above-comment" aria-selected="false">코멘트</button>
        </li>
        <li class="nav-item setting-navbar-tab">
        <button type="button" id="custom-content-above-file-tab" data-toggle="pill" href="#custom-content-above-file" role="tab" aria-controls="custom-content-file-comment" aria-selected="false">파일</button>
        </li>
    </ul>
    <div class="tab-content" id="custom-content-above-tabContent">
        <!-- 업무 속성 탭-->
        <div class="tab-pane fade show active p-setting-container" id="custom-content-work-setting" role="tabpanel" aria-labelledby="custom-content-work-setting-tab">
           		<!-- 권한 있을 때 -->
            	<c:if test="${memberLoggedIn.memberId eq project.projectWriter || memberLoggedIn.memberId eq 'admin' || isChargedMember}">
            	  <c:if test="${work.workDesc == null or work.workDesc == ''}">
			            <div class="row setting-row add-description">
			            	<span>설명 추가</span>
			            </div>
		          </c:if>
		          <c:if test="${work.workDesc != null and work.workDesc != ''}">
			            <div class="row setting-row add-description">
			            	<span style='color:#696f7a'>${work.workDesc }</span>
			            </div>
		          </c:if>
	           	</c:if>
	           	<!-- 권한 없을 때 -->
	           	<c:if test="${memberLoggedIn.memberId ne project.projectWriter && memberLoggedIn.memberId ne 'admin' && !isChargedMember}">
	           	  <c:if test="${work.workDesc == null or work.workDesc == ''}">
			             <div class="row setting-row work-description">
			            	<span>설명 없음</span>
			             </div>
		          </c:if>
		           <c:if test="${work.workDesc != null and work.workDesc != ''}">
			            <div class="row setting-row work-description">
			            	<span>${work.workDesc }</span>
			            </div>
		          </c:if>
	           	</c:if>
            <hr/>
            
            <div class="setting-row">
            <!-- 업무 위치 -->
            <div class="row">
                <label class="setting-content-label"><span class="label-icon"><i class='far fa-folder-open' style="width:20px;"></i></span> 위치</label>
                
                <!-- plus 버튼 눌렀을 때 dropdown-->
                <div class="add-member-left dropdown">
                	<c:if test="${memberLoggedIn.memberId eq project.projectWriter || memberLoggedIn.memberId eq 'admin' || isChargedMember}">
                   		 <button class="plusBtn" data-toggle="dropdown"><i class="fas fa-pencil-alt"></i></button>
                    </c:if>
                    <div class="dropdown-menu location-dropdown"  aria-labelledby="dropdownMenuLink">
                    <span>업무리스트</span> 
                    <div class="dropdown-divider"></div>
                    <c:if test="${project.worklistList!=null and !empty project.worklistList }">
	                    <c:forEach var="worklist" items="${project.worklistList }">
		                    <a class="dropdown-item" tabindex="-1" href="#">${worklist.worklistTitle }</a>
	                    </c:forEach>
                    </c:if>
                    </div>
                    
                </div>
                        <p class="setting-content-inform">
                            <span>${project.projectTitle }</span> <i class="fa fa-angle-double-right"></i> <span>${worklistTitle }</span>
                            <%-- <c:forEach var="worklist" items="${project.worklistList }">
	                    		<c:if test="${worklist.worklistNo eq work.worklistNo }">
	                    			<span>${worklist.worklistTitle }</span>
	                    		</c:if>
                    		</c:forEach> --%>
                        </p>
            </div>
            <!-- 업무 날짜 -->
            <div class="row">
                <label class="setting-content-label"><span><i class="far fa-calendar-alt" style="width:20px;"></i></span> 날짜 설정</label>
                <div class="dropdown">
                   <c:if test="${memberLoggedIn.memberId eq project.projectWriter || memberLoggedIn.memberId eq 'admin' || isChargedMember}">
                     <button class="plusBtn" data-toggle="dropdown"><i class="fas fa-cog"></i></button>
                   </c:if>
                    <div class="dropdown-menu setting-date-dropdown work-date-dropdown">
                        <div class="form-group">
                        <div class="input-group" >
                            <input type="text" class="form-control float-right" id="workDate" name="workDate"> 
                        </div>
                        </div>
                        <button class="btn bg-info date-update" type="button">수정</button>
                        <button class="btn bg-secondary date-cancel">취소</button>
                </div>
                </div>
                    
                    <p class="setting-content-inform">
                        <fmt:formatDate value="${work.workStartDate}" type="date" pattern="MM월dd일" /> - 
                        <c:if test="${work.workEndDate == null or work.workEndDate ==''}">마감일 없음</c:if>
                        <c:if test="${work.workEndDate != null and work.workEndDate !=''}"><fmt:formatDate value="${work.workEndDate}" type="date" pattern="MM월dd일" /></c:if>
                    </p>
            </div>
            <!-- 배정된 멤버-->
            <div class="row">
                <label class="setting-content-label"><span><i class='fas fa-user-plus' style="width:20px;"></i></span> 배정된 멤버</label>
                <c:if test="${memberLoggedIn.memberId eq project.projectWriter || memberLoggedIn.memberId eq 'admin'}">
                <button class="plusBtn" id="add-work-member"><i class="fa fa-plus"></i></button>
                </c:if>
                <div class='control-wrapper pv-multiselect-box'>
                    <div class="control-styles">
                        <input type="text" tabindex="1" id='workMember' name="workMember"/>
                </div>
                </div>
            </div>
            <!-- 태그 -->
            <div class="row">
                <label class="setting-content-label"><span><i class="fa fa-tag" style="width:20px;"></i></span> 태그</label>
                <c:if test="${memberLoggedIn.memberId eq project.projectWriter || memberLoggedIn.memberId eq 'admin' || isChargedMember}">
                	<button class="plusBtn" data-toggle="dropdown"><i class="fa fa-plus"></i></button>
                </c:if>
                <div class="work-tag">
                	<c:if test="${work.workTagTitle != null and work.workTagTitle != ''}">
                    	<span class="btn btn-xs bg-${work.workTagColor}">${work.workTagTitle }</span>
                    </c:if>
                </div>
                <div class="dropdown-menu work-setting-tag">
                    <a class="dropdown-item" tabindex="-1" href="#"><span class="btn btn-xs bg-danger">priority</span></a>
                    <a class="dropdown-item" tabindex="-1" href="#"><span class="btn btn-xs bg-primary">important</span></a>
                    <a class="dropdown-item" tabindex="-1" href="#"><span class="btn btn-xs bg-warning">review</span></a>
                </div>
            </div>
            </div>
            <!-- 업무 포인트(중요도) -->
            <div class="row setting-row setting-point">
                <label class="setting-content-label"> <span><i class='fas fa-ellipsis-h' style="width:20px;"></i></span> 포인트</label>
                <div class="dropdown status-dropdown">
                    <button data-toggle="dropdown">
                        <c:set var="point" value="${work.workPoint}" />
	                    <c:if test="${point>0}">
		                    <c:forEach var="i" begin="1" end="${point}">
		                    <span class="importance-dot checked"></span>
		                    </c:forEach>
		                    <c:forEach var="i" begin="1" end="${5-point}">
		                    <span class="importance-dot"></span>
		                    </c:forEach>
	                    </c:if>
	                    <c:if test="${point==0}">
	                    	<c:forEach var="i" begin="1" end="5">
		                    <span class="importance-dot"></span>
		                    </c:forEach>
	                    </c:if>
                    </button>
                    
                    <div class="icon-box"  data-toggle="dropdown">
                    <i class="fa fa-angle-down"></i>
                    </div>
                    <div class="dropdown-menu">
	                    <a class="dropdown-item work-importances" tabindex="-1" href="#">
	                        <span class="importance-dot checked"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span>
	                    </a>
	                    <a class="dropdown-item work-importances" tabindex="-1" href="#">
	                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot"></span> <span class="importance-dot"></span> <span class="importance-dot"></span>
	                    </a>
	                    <a class="dropdown-item work-importances" tabindex="-1" href="#">
	                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot"></span> <span class="importance-dot"></span>
	                    </a>
	                    <a class="dropdown-item work-importances" tabindex="-1" href="#">
	                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot"></span>
	                    </a>
	                    <a class="dropdown-item work-importances" tabindex="-1" href="#">
	                        <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span> <span class="importance-dot checked"></span>
	                    </a>
                    </div>
                </div>
            </div>
            <!-- 체크리스트 -->
            <div class="row setting-row checklist-box-row">
            
              <div class="work-checklist">
                <table class="tbl-checklist">
                <tbody>
                <c:if test="${work.checklistList!=null && !empty work.checklistList}">
                 <c:forEach items="${work.checklistList}" var="chk">
                 <c:set var="m" value="${chk.checklistChargedMember}"/>
                    <c:if test="${chk.completeYn=='Y'}">
			              <tr class="completed">
				             <th><button type="button" class="btn-check"><i class="fas fa-check-square"></i></button></th>
				                <td style="text-decoration:line-through;">
				                   <c:if test="${chk.checklistChargedMemberId!=null}">
				                      <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile" title="${m.memberName}">
				                   </c:if>
				          		   ${chk.checklistContent}
				                </td>
			              </tr>
			        </c:if>
                    <c:if test="${chk.completeYn=='N'}">
			           <tr>
			             <th><button type="button" class="btn-check"><i class="far fa-square"></i></button></th>
				            <td>
				               <c:if test="${chk.checklistChargedMemberId!=null}">
				                 <img src="${pageContext.request.contextPath}/resources/img/profile/default.jpg" alt="User Avatar" class="img-circle img-profile ico-profile" title="${m.memberName}">
				               </c:if>
				               ${chk.checklistContent}
				         	</td>
			           </tr>
			        </c:if>
                  </c:forEach>
                  </c:if>
                </tbody>
                <c:if test="${memberLoggedIn.memberId eq project.projectWriter || memberLoggedIn.memberId eq 'admin' || isChargedMember}">
	                <tfoot>
	                    <tr id="chk-add-tr">
	                    <th><button type="button" class="btn-add-checklist"><i class="fa fa-plus"></i></button></th>
	                    <td>
	                        <input type="text" name="checklist-content" id="checklist-content" placeholder="체크리스트 아이템 추가하기">
	                    </td>
	                    </tr>
	                </tfoot>
                </c:if>
                </table>                
              </div>
            
            </div>
        </div><!--/end 업무 속성 탭-->

        <!-- 코멘트 탭-->
        <div class="tab-pane fade" id="custom-content-above-comment" role="tabpanel" aria-labelledby="custom-content-above-comment-tab">
        <div class="comment-wrapper">
            <div class="comment-box">
            <div class="card-footer card-comments">
                <div class="card-comment">
                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/default.jpg" alt="User Image">
                <div class="comment-text">
                    <span class="username">김효정<span class="text-muted float-right">2020-01-26</span></span>
                    <span>오오 감사합니당</span>
                    <button class="comment-delete float-right">삭제</button>
                    <button class="comment-reply float-right">답글</button>
                </div>
                </div>
                <div class="card-comment">
                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/default.jpg" alt="User Image">
                <div class="comment-text">
                    <span class="username">주보라<span class="text-muted float-right">2020-01-27</span></span>
                    <span>괜찮은데요??</span>
                    <button class="comment-delete float-right">삭제</button>
                    <button class="comment-reply float-right">답글</button>
                </div>
                </div>
                <div class="card-comment comment-level2">
                    <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/default.jpg" alt="User Image">
                    <div class="comment-text">
                    <span class="username">유혜민<span class="text-muted float-right">2020-01-26</span></span>
                    <span>넵! 알겠습니당</span>
                    <button class="comment-delete float-right">삭제</button>
                    </div>
                </div>
                <div class="card-comment comment-level2">
                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/default.jpg" alt="User Image">
                <div class="comment-text">
                    <span class="username">이소현<span class="text-muted float-right">2020-01-27</span></span>
                    <span>훨씬 편하네요~</span>
                    <button class="comment-delete float-right">삭제</button>
                </div>
                </div>
            </div>
            </div>
            <!-- 댓글 작성 -->
            <div class="card-footer">
            <form action="#" method="post">
                <img class="img-fluid img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/default.jpg">
                <div class="img-push">
                <input type="text" class="form-control form-control-sm comment-text-area" placeholder="댓글을 입력하세요.">
                <input class="comment-submit" type="submit" value="등록">
                </div>
            </form>
            </div> 
        </div> 
        <!--/. end comment-wrapper--> 
        </div>
        <!--/. end 코멘트 tab-->

        <!-- 파일 탭 -->
        <div class="tab-pane fade file-tab-pane " id="custom-content-above-file" role="tabpanel" aria-labelledby="custom-content-above-file-tab">
            <div class="file-wrapper">
            <div class="container-fluid"> 
                <!-- 파일 첨부 -->
                <form action="">
                <div class="input-group work-file-upload-box">
                    <div class="custom-file">
                    <input type="file" class="custom-file-input" id="workInputFile" aria-describedby="inputGroupFileAddon04">
                    <label class="custom-file-label" for="inputGroupFile04">Choose file</label>
                    </div>
                    <div class="input-group-append">
                    <button class="btn btn-outline-secondary" type="button" id="inputGroupFileAddon04">Button</button>
                    </div>
                </div>
                </form>
                <!-- 첨부파일 테이블 -->
                <div id="card-workAttach" class="card">
                <div class="card-body table-responsive p-0">
                    <table id="tbl-projectAttach" class="table table-hover text-nowrap">
                    <thead>
                        <tr>
                        <th>이름</th>
                        <th>공유한 날짜</th>
                        <th>공유한 사람</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                        <td>
                            <a href="">
                            <div class="img-wrapper">
                            <img src="${pageContext.request.contextPath}/resources/img/test.jpg" alt="첨부파일 미리보기 이미지">
                            </div>
                            <div class="imgInfo-wrapper">
                            <p class="filename">file.png</p>
                            <p class="filedir">33.8KB</p>
                            </div>
                            </a>
                        </td>
                        <td>2020년 1월 28일</td>
                        <td>
                            이단비
                            <!-- 첨부파일 옵션 버튼 -->
                            <div class="dropdown ">
                            <button type="button" class="btn-file" data-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></button>
                            <div class="dropdown-menu dropdown-menu-right">
                                <a href="#" class="dropdown-item">
                                다운로드
                                </a>
                                <div class="dropdown-divider"></div>
                                <a href="#" class="dropdown-item dropdown-file-remove">삭제</a>
                            </div>
                            </div>
                        </td>
                        </tr>
                        <tr>
                        <td>
                            <a href="#">
                            	<div class="img-wrapper">
                            		<img src="${pageContext.request.contextPath}/resources/img/profile/default.jpg" alt="첨부파일 미리보기 이미지">
                            	</div>
                            <span class="filename">file.png</span>
                            </a>
                        </td>
                        <td>2020년 1월 28일</td>
                        <td>
                            이단비
                            <!-- 첨부파일 옵션 버튼 -->
                            <div class="dropdown ">
                            <button type="button" class="btn-file" data-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></button>
                            <div class="dropdown-menu dropdown-menu-right">
                                <a href="#" class="dropdown-item">
                                다운로드
                                </a>
                                <div class="dropdown-divider"></div>
                                <a href="#" class="dropdown-item dropdown-file-remove">삭제</a>
                            </div>
                            </div>
                        </td>
                        </tr>
                    </tbody>
                    </table>
                </div>
                <!-- /.card-body -->
                </div>
                <!-- /.card -->
                </div>
                <!-- /.container-fluid -->
            </div> 
            <!--/. end file-wrapper--> 
            </div>

    </div>
    
 <script>
 $(()=>{
	var workNo = '${work.workNo}';
	var projectNo = '${project.projectNo}';
	workMember(workNo,projectNo);
	sidechecklist(); 
	workDateRangePicker();
	sideClose();
	
 });
 
 function workDateRangePicker(){
	 $("#workDate").daterangepicker({
		 locale: {
	         format: 'YYYY/MM/DD'
	     }
	 });
 }
 
function sideClose(){
	//업무 사이드바 닫기
	 $(".div-close").on('click',()=>{
	     var $side = $("#setting-sidebar");
	     if($side.hasClass('open')) {
	         $side.stop(true).animate({right:'-520px'});
	         $side.removeClass('open');
	     }
	 });
}
 
 function sidechecklist(){
	    let $btnCheck = $(".btn-check");

	    $(".btn-check").on('click', e=>{
	        let checkbox = e.target;
	        let $tr = $(checkbox.parentNode.parentNode.parentNode);
	        let $tdChecklist = $(checkbox.parentNode.parentNode.nextSibling.nextSibling);

	        //클릭한 대상이 i태그일 경우에만 적용
	        if(checkbox.tagName==='I')
	            $tr.toggleClass('completed');

	        //완료된 체크리스트인 경우 
	        if($tr.hasClass('completed')){
	            //체크박스 변경
	            $(checkbox).removeClass('far fa-square');
	            $(checkbox).addClass('fas fa-check-square');

	            //리스트에 줄 긋기
	            $tdChecklist.css('text-decoration', 'line-through');
	        }
	        //미완료된 체크리스트인 경우
	        else{
	            if(checkbox.tagName=='I'){
	                //체크박스 변경
	                $(checkbox).removeClass('fas fa-check-square');
	                $(checkbox).addClass('far fa-square');

	                //리스트에 줄 해제
	                $tdChecklist.css('text-decoration', 'none');
	            }
	        }

	    }); //end of .btn-check click
	}
 </script>
 <script src="${pageContext.request.contextPath }/resources/js/multiselect.js"></script>