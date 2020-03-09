<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script>
$(function(){
	 

	
	// Summernote
	$('.textarea-intro').summernote({
        focus: true,
        lang: 'ko-KR',
        height: 150,
        toolbar: [
            ['style', ['bold', 'italic', 'underline', 'strikethrough']],
            ['para', ['ul', 'ol']],
            ['insert', ['picture', 'link']]
        ]
    });
	

	
});
</script>

				<c:forEach items="${clubList }" var="club">
 					<!-- modal Club 부분 -->
					<div class="modal fade" id="modal-club-${club.clubNo }">
						<div class="modal-dialog modal-lg">
							<div class="modal-content">
								<div class="modal-header">
									<h4 class="modal-title">${club.clubName }</h4>

									<button type="button" class="close" data-dismiss="modal"
										aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
								</div>
								<div class="modal-body">

									<div id="modal-image-slider-${club.clubNo }" class="carousel slide"
										data-ride="carousel">

										<div class="carousel-inner">
	
												<c:if
													test="${not empty club.clubPhotoList[0].clubPhotoRenamed}">

													<div class="carousel-item active">
														<img class="d-block w-100"
															src="${pageContext.request.contextPath}/resources/upload/club/${club.clubNo }/${club.clubPhotoList[0].clubPhotoRenamed}"
															alt="First slide">
													</div>
												</c:if>

												<c:if test="${empty club.clubPhotoList[0].clubPhotoRenamed}">
													<div class="carousel-item active">
														<img class="d-block w-100"
															src="${pageContext.request.contextPath}/resources/img/club/clubAll.JPG"
															alt="First slide">
													</div>

												</c:if>
											<c:if
												test="${not empty club.clubPhotoList[1].clubPhotoRenamed}">
												<div class="carousel-item">
													<img class="d-block w-100"
														src="${pageContext.request.contextPath}/resources/upload/club/${club.clubNo }/${club.clubPhotoList[1].clubPhotoRenamed}"
														alt="Second slide">
												</div>
											</c:if>
											<c:if
												test="${not empty club.clubPhotoList[2].clubPhotoRenamed}">
												<div class="carousel-item">
													<img class="d-block w-100"
														src="${pageContext.request.contextPath}/resources/upload/club/${club.clubNo }/${club.clubPhotoList[2].clubPhotoRenamed}"
														alt="Third slide">
												</div>
											</c:if>
										</div>

										<a class="carousel-control-prev" href="#modal-image-slider-${club.clubNo }"
											role="button" data-slide="prev"> <span
											class="carousel-control-prev-icon" aria-hidden="true"></span>
											<span class="sr-only">Previous</span>
										</a> <a class="carousel-control-next" href="#modal-image-slider-${club.clubNo }"
											role="button" data-slide="next"> <span
											class="carousel-control-next-icon" aria-hidden="true"></span>
											<span class="sr-only">Next</span>
										</a>

									</div>



									<span class="modal-text">${club.clubIntroduce }</span>

									<hr>
									<div class="modal-club-info">
										<span>담당대표 사번 - </span>&nbsp; <span>${club.clubManagerId }</span>
										<br> <span>모임주기 - </span>&nbsp; <span>${club.clubMeetingCycle}</span>
										<br> <span>모임날짜 - </span>&nbsp; <span>${club.clubMeetingDate}</span>
										<br> <span>개설일 - </span>&nbsp; <span>${club.clubEnrollDate }</span>
									</div>

								</div>

								<div class="modal-footer justify-content-between">
									<button type="button" class="btn btn-default"
										data-dismiss="modal">Close</button>
									<c:set var="approve" value="${club.clubApproveYN}"></c:set>

									<c:choose>
										<c:when test="${fn:contains(approve,'Y')}"></c:when>
										<c:when test="${fn:contains(approve,'N')}"></c:when>
										<c:otherwise>

											<form role="form"
												action="${pageContext.request.contextPath}/club/insertClubMember.do"
												method="post" enctype="multipart/form-data">
												<input type="hidden" name="clubNo" value="${club.clubNo }" />
												<input type="hidden" name="memberId"
													value="${memberLoggedIn.memberId }" />


												<button type="submit" class="btn btn-primary" id="join">가입하기</button>


											</form>
										</c:otherwise>
									</c:choose>


								</div>
							</div>
							<!-- /.modal-content -->
						</div>
						<!-- /.modal-dialog -->
					</div>
					<!-- /.modal -->


					<!-- new Club modal -->
					<!-- modal 부분 -->
					<div class="modal fade" id="modal-new-club" data-backdrop="static">
						<div class="modal-dialog modal-lg">
							<div class="modal-content">
								<div class="modal-header">
									<h4 class="modal-title">동호회 개설</h4>

									<button type="button" class="close" data-dismiss="modal"
										aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>

								</div>
								<div class="modal-body">
									<div>
										<!-- form start -->
										<form role="form" id="new-club-form"
											action="${pageContext.request.contextPath}/club/insertNewClub.do"
											method="post" enctype="multipart/form-data">

											<!-- 아이디값 히든으로 넘겨주기  -->
											<input type="hidden" name="clubManagerId"
												value="${memberLoggedIn.memberId}" />

											<div class="form-group">
												<label>이름</label> <input type="text" name="clubName"
													class="form-control" required>
											</div>
											<div class="form-group">
												<div class="mb-3">
													<label for="introduce">소개</label>
													<textarea id="introduce" name="clubIntroduce"
														class="textarea textarea-intro"
														style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;"
														placeholder="소개글을 작성해주세요" required></textarea>
												</div>
											</div>


											<div class="form-group">
												<label>모임주기</label> <select class="form-control"
													name="clubMeetingCycle">
													<option>매주</option>
													<option>격주</option>
												</select>
											</div>
											<label for="check-week">모임 요일</label>
											<div id="check-week" class="input-group">
												<div class="form-check">
													<input type="checkbox" class="form-check-input"
														name="clubMeetingDate" id="meetingDate0" value="월" checked>
													<label class="form-check-label" for="meetingDate0">월</label>
												</div>
												<div class="form-check">
													<input type="checkbox" class="form-check-input"
														name="clubMeetingDate" id="meetingDate1" value="화">
													<label class="form-check-label" for="meetingDate1">화</label>
												</div>
												<div class="form-check">
													<input type="checkbox" class="form-check-input"
														name="clubMeetingDate" id="meetingDate2" value="수">
													<label class="form-check-label" for="meetingDate2">수</label>
												</div>
												<div class="form-check">
													<input type="checkbox" class="form-check-input"
														name="clubMeetingDate" id="meetingDate3" value="목">
													<label class="form-check-label" for="meetingDate3">목</label>
												</div>
												<div class="form-check">
													<input type="checkbox" class="form-check-input"
														name="clubMeetingDate" id="meetingDate4" value="금">
													<label class="form-check-label" for="meetingDate4">금</label>
												</div>
												<div class="form-check">
													<input type="checkbox" class="form-check-input"
														name="clubMeetingDate" id="meetingDate5" value="토">
													<label class="form-check-label" for="meetingDate5">토</label>
												</div>
												<div class="form-check">
													<input type="checkbox" class="form-check-input"
														name="clubMeetingDate" id="meetingDate6" value="일">
													<label class="form-check-label" for="meetingDate6">일</label>
												</div>
											</div>
											<!-- /.input-group -->

											<label for="radio-category">카테고리</label>
											<div id="radio-category" class="input-group">
												<div class="form-check">
													<input class="form-check-input" type="radio"
														name="clubCategory" id="clubCategory0" value="사회" checked>
													<label class="form-check-label" for="clubCategory0">사회</label>
												</div>
												<div class="form-check">
													<input class="form-check-input" type="radio"
														name="clubCategory" id="clubCategory1" value="취미">
													<label class="form-check-label" for="clubCategory1">취미</label>
												</div>
												<div class="form-check">
													<input class="form-check-input" type="radio"
														name="clubCategory" id="clubCategory2" value="음식">
													<label class="form-check-label" for="clubCategory2">음식</label>
												</div>
												<div class="form-check">
													<input class="form-check-input" type="radio"
														name="clubCategory" id="clubCategory3" value="운동">
													<label class="form-check-label" for="clubCategory3">운동</label>
												</div>
												<div class="form-check">
													<input class="form-check-input" type="radio"
														name="clubCategory" id="clubCategory4" value="문학">
													<label class="form-check-label" for="clubCategory4">문학</label>
												</div>
												<div class="form-check">
													<input class="form-check-input" type="radio"
														name="clubCategory" id="clubCategory5" value="기타">
													<label class="form-check-label" for="clubCategory5">기타</label>
												</div>

											</div>

											<div id="btn-sub">
												<button type="submit" id="join-btn" class="btn btn-primary">생성하기</button>
											</div>
										</form>
										<!-- form end -->
									</div>
								</div>
								<!-- /.modal-body -->
							</div>
							<!-- /.modal-content -->
						</div>
						<!-- /.modal-dialog -->
					</div>
					<!-- /.modal -->



					<!--  modal 수정 -->
					<!-- modal 부분 -->
					<div class="modal fade" id="modal-update-${club.clubNo }"
						data-backdrop="static">
						<div class="modal-dialog modal-lg">
							<div class="modal-content">
								<div class="modal-header">
									<h4 class="modal-title">동호회 정보 수정</h4>

									<button type="button" class="close" data-dismiss="modal"
										aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>

								</div>
								<div class="modal-body">
									<div>
										<!-- form start -->
										<form role="form" id="update-club-form"
											action="${pageContext.request.contextPath}/club/updateClub.do"
											method="post" enctype="multipart/form-data">

											<!-- clubNo 값 히든으로 넘겨주기  -->
											<input type="hidden" name="clubNo" value="${club.clubNo}" />

											<div class="form-group">
												<label>이름</label> <input type="text" name="clubName"
													class="form-control" value="${club.clubName }" required>
											</div>
											<div class="form-group">
												<div class="mb-3">
													<label for="introduce">소개</label>
													<textarea id="introduce" name="clubIntroduce"
														class="textarea textarea-intro"
														style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;">${club.clubIntroduce }</textarea>
												</div>
											</div>



											<div class="form-group">
												<label>모임주기</label> <select class="form-control"
													name="meetingCycle">
													<option
														<c:if test="${club.clubMeetingCycle eq '매주'}">selected</c:if>>매주</option>
													<option
														<c:if test="${club.clubMeetingCycle eq '격주'}">selected</c:if>>격주</option>
												</select>
											</div>


											<c:set var="dateStr" value="${club.clubMeetingDate }"></c:set>
											<label for="check-week">모임 요일</label>
											<div id="check-week" class="input-group">
												<div class="form-check">
													<input type="checkbox" class="form-check-input"
														name="meetingDate" id="meetingDate0" value="월"
														<c:if test="${fn:contains(dateStr,'월') }">checked</c:if>>
													<label class="form-check-label" for="meetingDate0">월</label>
												</div>
												<div class="form-check">
													<input type="checkbox" class="form-check-input"
														name="meetingDate" id="meetingDate1" value="화"
														<c:if test="${fn:contains(dateStr,'화') }">checked</c:if>>
													<label class="form-check-label" for="meetingDate1">화</label>
												</div>
												<div class="form-check">
													<input type="checkbox" class="form-check-input"
														name="meetingDate" id="meetingDate2" value="수"
														<c:if test="${fn:contains(dateStr,'수') }">checked</c:if>>
													<label class="form-check-label" for="meetingDate2">수</label>
												</div>
												<div class="form-check">
													<input type="checkbox" class="form-check-input"
														name="meetingDate" id="meetingDate3" value="목"
														<c:if test="${fn:contains(dateStr,'목') }">checked</c:if>>
													<label class="form-check-label" for="meetingDate3">목</label>
												</div>
												<div class="form-check">
													<input type="checkbox" class="form-check-input"
														name="meetingDate" id="meetingDate4" value="금"
														<c:if test="${fn:contains(dateStr,'금') }">checked</c:if>>
													<label class="form-check-label" for="meetingDate4">금</label>
												</div>
												<div class="form-check">
													<input type="checkbox" class="form-check-input"
														name="meetingDate" id="meetingDate5" value="토"
														<c:if test="${fn:contains(dateStr,'토') }">checked</c:if>>
													<label class="form-check-label" for="meetingDate5">토</label>
												</div>
												<div class="form-check">
													<input type="checkbox" class="form-check-input"
														name="meetingDate" id="meetingDate6" value="일"
														<c:if test="${fn:contains(dateStr,'일') }">checked</c:if>>
													<label class="form-check-label" for="meetingDate6">일</label>
												</div>
											</div>
											<!-- /.input-group -->

											<label for="radio-category">카테고리</label>
											<div id="radio-category" class="input-group">

												<div class="form-check">
													<input class="form-check-input" type="radio"
														name="clubCategory" id="clubCategory1" value="사회"
														<c:if test="${club.clubCategory eq '사회'}">checked</c:if>>
													<label class="form-check-label" for="clubCategory1">사회</label>
												</div>
												<div class="form-check">
													<input class="form-check-input" type="radio"
														name="clubCategory" id="clubCategory2" value="음식"
														<c:if test="${club.clubCategory eq '음식'}">checked</c:if>>
													<label class="form-check-label" for="clubCategory2">음식</label>
												</div>
												<div class="form-check">
													<input class="form-check-input" type="radio"
														name="clubCategory" id="clubCategory3" value="운동"
														<c:if test="${club.clubCategory eq '운동'}">checked</c:if>>
													<label class="form-check-label" for="clubCategory3">운동</label>
												</div>
												<div class="form-check">
													<input class="form-check-input" type="radio"
														name="clubCategory" id="clubCategory4" value="문학"
														<c:if test="${club.clubCategory eq '문학'}">checked</c:if>>
													<label class="form-check-label" for="clubCategory4">문학</label>
												</div>
												<div class="form-check">
													<input class="form-check-input" type="radio"
														name="clubCategory" id="clubCategory5" value="기타"
														<c:if test="${club.clubCategory eq '기타'}">checked</c:if>>
													<label class="form-check-label" for="clubCategory5">기타</label>
												</div>

											</div>

											<div id="btn-sub">
												<button type="submit" id="update-btn"
													class="btn btn-primary">수정하기</button>
											</div>
										</form>
										<!-- form end -->
									</div>
								</div>
								<!-- /.modal-body -->
							</div>
							<!-- /.modal-content -->
						</div>
						<!-- /.modal-dialog -->
					</div>
					<!-- /.modal -->
				</c:forEach>