<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />

<section class="work-item" role="button" tabindex="0">
	<!-- 태그 -->
	<c:if test="${w.workTagCode!=null}">
		<div class="work-tag">
			<span class="btn btn-xs bg-${w.workTagColor}">${w.workTagTitle}</span>
		</div>
	</c:if>

	<!-- 업무 타이틀 -->
	<div class="work-title">
	    <h6>${w.workTitle}</h6>
	    <div class="work-importances">
	    <c:set var="point" value="${w.workPoint}" />
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
	    </div>
	</div>

	<!-- 날짜 설정 -->
	<c:if test="${w.workStartDate!=null}">
		<div class="work-deadline">
		    <p>
		    	<c:if test="${w.workEndDate!=null}">
		    		<fmt:formatDate value="${w.workStartDate}" type="date" pattern="MM월dd일" /> - 
		    		<fmt:formatDate value="${w.workEndDate}" type="date" pattern="MM월dd일" />
		    	</c:if>
		    	<c:if test="${w.workEndDate==null}">
		    		<fmt:formatDate value="${w.workStartDate}" type="date" pattern="MM월dd일" />에 시작
		    	</c:if>
		    </p>
		    
	    	<c:set var="now" value="<%= new Date() %>"/>
	    	<fmt:formatDate var="nowStr" value="${now}" type="date" pattern="yyyy-MM-dd"/>
	    	<fmt:parseDate var="today" value="${nowStr}" type="date" pattern="yyyy-MM-dd"/>
	    	<fmt:parseNumber var="today_D" value="${today.time/(1000*60*60*24)}" integerOnly="true"/>
	    	<fmt:parseDate var="enddate" value="${w.workEndDate}" pattern="yyyy-MM-dd"/>
	    	<fmt:parseNumber var="enddate_D" value="${enddate.time/(1000*60*60*24)}" integerOnly="true"/>
	    	
			<c:if test="${today_D > enddate_D}">
			<p class="over">마감일 ${today_D - enddate_D}일 지남</p>
			</c:if>               	
		</div><!-- /.work-deadline -->
	</c:if>

	<!-- 기타 아이콘 모음 -->
	<div class="work-etc">
		<!-- 체크리스트/코멘트/첨부파일 수 -->
	    <span class="ico"><i class="far fa-list-alt"></i> 0</span>
	    <span class="ico"><i class="far fa-comment"></i> 0</span>
	    <span class="ico"><i class="fas fa-paperclip"></i> 0</span>
	    
	    <!-- 업무 배정된 멤버 -->
	    <c:if test="${w.workChargedMemberList!=null && !empty w.workChargedMemberList}">
	    <div class="chared-member text-right">
		    <c:forEach items="${w.workChargedMemberList}" var="m">
		    <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile" title="${m.memberName}">
		    </c:forEach>
	    </div>
	    </c:if>
	</div>

</section><!-- /.work-item -->