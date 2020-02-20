<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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
</c:forEach>