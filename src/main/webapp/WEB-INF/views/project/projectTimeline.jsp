<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script>
$(function(){
	console.log("1111");
	drawChart(); //차트
	tabActive(); //서브헤더 탭 활성화
});

//간트차트
function drawChart(){
	google.charts.load('current', {'packages':['timeline']});
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
      var data = new google.visualization.DataTable();
      data.addColumn('string', 'Team');
      data.addColumn('date', 'Season Start Date');
      data.addColumn('date', 'Season End Date');

      data.addRows([
        ['Baltimore Ravens',     new Date(2014, 8, 5), new Date(2014, 8, 10)],
        ['New England Patriots', new Date(2014, 8, 5), new Date(2014, 8, 5)],
      ]);
      

      var options = {
      	hAxis: {
        	textStyle: { fontSize: 10, color: '#999999' },
          gridlines:{ color: '#eee' },
          textPosition: 'in',
          baselineColor: '#eee',
          format: 'MM-dd'
        },
        height: 450,
        timeline: {
          groupByRowLabel: true
        }
      };
        
        var chart = new google.visualization.Timeline(document.getElementById('timeline-wrapper'));

        chart.draw(data, options);
    }
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

    $("#tab-timeline").addClass("active");
}
</script>		

<!-- 프로젝트 관리자 -->
<c:set var="projectManager" value=""/>
<c:set var="isprojectManager" value="false"/>
<c:forEach var="pm" items="${project.projectMemberList}">
	<c:if test="${pm.managerYn eq 'Y'}">
		<c:set var="projectManager" value="${projectManager=pm.memberId}" />
	</c:if>
	<c:if test="${pm.memberId eq memberLoggedIn.memberId }">
		<c:if test="${pm.managerYn eq 'Y'}"><c:set var="isprojectManager" value="true"/> </c:if>
	</c:if>
</c:forEach>
<!-- 나의 워크패드인 경우 -->
<c:if test="${project.privateYn=='Y'}">
	<c:set var="projectManager" value="${projectManager=project.projectWriter}" />
</c:if>


<!-- Content Wrapper. Contains page content -->
<!-- <div class="content-wrapper navbar-light"> -->
    <h2 class="sr-only">프로젝트 타임라인</h2>
    <!-- Main content -->
    <div id="timeline-wrapper" class="content view col-sm-12">
    </div>
    <!-- /.content -->
<!-- /.content-wrapper -->

