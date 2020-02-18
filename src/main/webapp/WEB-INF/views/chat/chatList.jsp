<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<style>
.layout-navbar-fixed .wrapper .content-wrapper{margin-top: 46px;}
.card{cursor: auto;}
.chat-wrapper{height: 635px;}
.card-header{
    margin: 0;
    padding: .5rem .5rem .5rem 1rem;
border-bottom: 1px solid rgba(0,0,0,.125); 
height: 3.6rem;
}
.direct-chat-msg.right>.direct-chat-text{
float: right; margin:0 1rem 0 0;
}
.direct-chat-msg>.direct-chat-text{
float: left; margin:0.1px 0 0 1rem;
}
.user-block{margin: 0;}
.user-block>.username{
margin-top:0.6rem;
}
.direct-chat-infos.clearfix{
margin-top: solid 1px black;
}
.td>tr>td{
padding: .30rem;
border-top: none;
}
.td>tr>td:hover{
background: #d2d6de;
}
.h6{
position: relative; 
top:.5rem; 
left: .5rem;
}
.modal-body{padding: 1.8rem 1.3rem 0;}
.tab-content{background: inherit;}
</style>

<script type="text/javascript">
$(function () {
  // Summernote
  $('.textarea').summernote();
  
  sidebarActive(); //사이드바 활성화
});

//사이드바 활성화
function sidebarActive(){
	let navLinkArr = document.querySelectorAll(".sidebar .nav-link");
	
	navLinkArr.forEach((obj, idx)=>{
		let $obj = $(obj);
		if($obj.hasClass('active'))
			$obj.removeClass('active');
	});
	
	$("#sidebar-chat").addClass("active");
}
	

//대화상대찾기 ajax
$(()=> {
	$("#plusChannel").click(function() {
		console.log("왜 안먹져...?");
	});
	
	$("#btn-findMember").on("click", function() {
		var keyword = $(this).val().trim();
		console.log(keyword);
		
		$.ajax({
			url: '${pageContext.request.contextPath}/chat/findMember.do', 
			data: {keyword:keyword}, 
			dataType: 'json', 
			success: data=> {
				console.log(data);
				
			}, 
			error: (x, s, e)=> {
				console.log("ajax실행오류!!", x, s, e);
			}
		});
	});
});

</script>


<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <section class="content">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-3">
                    <!-- About Me Box -->
                    <div class="card card-primary">
                        <div class="card-body">
                            <button type="button" class="btn btn-default" data-toggle="modal" data-target="#modal-default" style="width: 100%;">
                                채널 검색
                                <i class="fas fa-search" style="float: right; position: relative; top:.3rem;"></i>
                            </button>
                            <button type="button" id="plusChannel" class="btn btn-default" data-toggle="modal" data-target="#modal-default1" style="width: 100%; background: white; border-color: white; font-weight: bold; color:#17a2b8;">
                                <i class="fas fa-plus"></i>&nbsp;
                                새 대화 채널 추가
                            </button>
                        </div>
                        <div class="col-12">
                            <div class="card-body table-responsive p-0" style="height: 32.5rem;">
                                <table class="table table-head-fixed text-nowrap">
                                    <tbody class="td">
                                    <c:forEach items="${channelList }" var="channel">
                                        <tr>
                                            <td>
                                                <div class="col-9" style="width: 100%;"> 
                                                    <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="Message User Image">
                                                    <h6 class="h6">${channel.channelTitle }</h6>
                                                </div> 
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <!-- /.card -->
                </div>
                <!-- /.col -->
                <div class="col-md-9">
                    <div class="card chat-wrapper">
                        <div class="card-header">
                            <div class="post">
                                <div class="user-block">
                                    <img class="img-circle" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="user image">
                                    <span class="username">
                                        <h3>이주현</h3>
                                    </span>
                                </div>
                            </div>
                        </div><!-- /.card-header -->
                        <div class="card-body">        
                            <!-- Conversations are loaded here -->
                            <div class="direct-chat-messages" style="height:20.8rem">
                            <!-- Message. Default to the left -->
                                <div class="direct-chat-msg">
                                    <div class="direct-chat-infos clearfix">
                                        <span class="direct-chat-name float-left">이주현&nbsp;&nbsp;</span>
                                        <span class="direct-chat-timestamp float-left">2:00 pm</span>
                                    </div>
                                    <!-- /.direct-chat-infos -->
                                    <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="Message User Image">
                                    <!-- /.direct-chat-img -->
                                    <div class="direct-chat-text">
                                        Is this template really for free? That's unbelievable!
                                    </div>
                                    <!-- /.direct-chat-text -->
                                </div>
                                <!-- /.direct-chat-msg -->
                        
                                <!-- Message to the right -->
                                <div class="direct-chat-msg right">
                                    <div class="direct-chat-infos clearfix">
                                        <span class="direct-chat-name float-right">김효정</span>
                                        <span class="direct-chat-timestamp float-right">2:05 pm &nbsp;&nbsp;</span>
                                    </div>
                                    <!-- /.direct-chat-infos -->
                                    <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user2-160x160.jpg" alt="Message User Image">
                                    <!-- /.direct-chat-img -->
                                    <div class="direct-chat-text">
                                        You better believe it!
                                    </div>
                                    <!-- /.direct-chat-text -->
                                </div> 

                                <div class="direct-chat-msg">
                                    <div class="direct-chat-infos clearfix">
                                        <span class="direct-chat-name float-left">이주현&nbsp;&nbsp;</span>
                                        <span class="direct-chat-timestamp float-left">2:00 pm</span>
                                    </div>
                                    <!-- /.direct-chat-infos -->
                                    <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="Message User Image">
                                    <!-- /.direct-chat-img -->
                                    <div class="direct-chat-text">
                                        Is this template really for free? That's unbelievable!
                                    </div>
                                    <!-- /.direct-chat-text -->
                                </div>

                                <div class="direct-chat-msg right">
                                    <div class="direct-chat-infos clearfix">
                                        <span class="direct-chat-name float-right">김효정</span>
                                        <span class="direct-chat-timestamp float-right">2:05 pm &nbsp;&nbsp;</span>
                                    </div>
                                    <!-- /.direct-chat-infos -->
                                    <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user2-160x160.jpg" alt="Message User Image">
                                    <!-- /.direct-chat-img -->
                                    <div class="direct-chat-text">
                                        You better believe it!
                                    </div>
                                    <!-- /.direct-chat-text -->
                                </div> 

                                <div class="direct-chat-msg">
                                    <div class="direct-chat-infos clearfix">
                                        <span class="direct-chat-name float-left">이주현&nbsp;&nbsp;</span>
                                        <span class="direct-chat-timestamp float-left">2:00 pm</span>
                                    </div>
                                    <!-- /.direct-chat-infos -->
                                    <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="Message User Image">
                                    <!-- /.direct-chat-img -->
                                    <div class="direct-chat-text">
                                        Is this template really for free? That's unbelievable!
                                    </div>
                                    <!-- /.direct-chat-text -->
                                </div>
                                <!-- /.direct-chat-msg -->
                            </div><!-- /.direct-chat-messages -->
                        </div>
                        <!-- /.card-body -->
                        <div class="card-body pad">
                            <div class="mb-3">
                                <textarea class="textarea" placeholder="Place some text here"
                                        style="width: 100%; height: 200px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;"></textarea>
                            </div>
                        </div>
                    </div>
                    <!-- /.card -->
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </div><!-- /.container-fluid -->
    </section>
</div>
<!-- /.content-wrapper -->

<!-- Modal -->
<div class="modal fade" id="modal-default">
    <div class="modal-dialog modal-default">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">채널 검색</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>

        <div class="modal-body">
          <!-- <p>One fine body&hellip;</p> -->
          <div class="card-tools" style="margin-bottom:2rem">
              <div class="input-group input-group-sm" style="width: 20rem; margin: 0 auto;">
                <input type="text" name="table_search" class="form-control float-right" placeholder="Search">

                <div class="input-group-append">
                  <button type="submit" class="btn btn-default"><i class="fas fa-search"></i></button>
                </div>
              </div>
            </div>
          <div class="col-9" style="margin: 0 auto;"> 
              <ul class="nav nav-pills" style="padding-left:2.5rem;">
                <li class="nav-item"><a class="nav-link active" href="#activity" data-toggle="tab">전체</a></li>
                <li class="nav-item"><a class="nav-link" href="#timeline" data-toggle="tab">채널</a></li>
                <li class="nav-item"><a class="nav-link" href="#settings" data-toggle="tab">다이렉트 메시지</a></li>
              </ul>
          </div>
            <div class="card-body">
                <div class="tab-content">
                  <div class="active tab-pane" id="activity">
                      <div class="post">
                          <div class="row">
                              <div class="col-12">
                                  <!-- /.card-header -->
                                  <div class="card-body table-responsive p-0" style="height: 300px;">
                                    <table class="table table-head-fixed text-nowrap">
                                      <tbody class="td">
                                        <tr>
                                          <td>
                                            <div class="col-9"> 
                                              <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="Message User Image">
                                              <h6 class="h6">이주현</h6>
                                            </div> 
                                          </td>
                                        </tr>
                                        <tr>
                                            <td>
                                              <div class="col-9"> 
                                                <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="Message User Image">
                                                <h6 class="h6">개발</h6>
                                              </div> 
                                            </td>
                                          </tr>
                                      </tbody>
                                    </table>
                                  </div>
                                  <!-- /.card-body -->
                                <!-- </div> -->
                                <!-- /.card -->
                              </div>
                            </div>
                            <!-- /.row -->
                        </div>
                    </div>
                    <div class="tab-pane" id="timeline">
                        <div class="post">
                            <div class="row">
                                <div class="col-12">
                                    <!-- /.card-header -->
                                    <div class="card-body table-responsive p-0" style="height: 300px;">
                                      <table class="table table-head-fixed text-nowrap">
                                        <tbody class="td">
                                          <tr>
                                            <td>
                                              <div class="col-9"> 
                                                <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/userimage.jpg" alt="Message User Image">
                                                <h6 class="h6">개발</h6>
                                              </div> 
                                            </td>
                                          </tr>
                                        </tbody>
                                      </table>
                                    </div>
                                    <!-- /.card-body -->
                                  <!-- </div> -->
                                  <!-- /.card -->
                                </div>
                              </div>
                              <!-- /.row -->
                          </div>
                    </div>
                    <div class="tab-pane" id="settings">
                        <div class="post">
                            <div class="row">
                                <div class="col-12">
                                    <!-- /.card-header -->
                                    <div class="card-body table-responsive p-0" style="height: 300px;">
                                      <table class="table table-head-fixed text-nowrap">
                                        <tbody class="td">
                                          <tr>
                                            <td>
                                              <div class="col-9"> 
                                                <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="Message User Image">
                                                <h6 class="h6">이주현</h6>
                                              </div> 
                                            </td>
                                          </tr>
                                        </tbody>
                                      </table>
                                    </div>
                                    <!-- /.card-body -->
                                  <!-- </div> -->
                                  <!-- /.card -->
                                </div>
                              </div>
                              <!-- /.row -->
                          </div>
                    </div>
                </div>
            </div>
        </div>
      </div>
      <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<div class="modal fade" id="modal-default1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title">새 대화 채널 추가</h4>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form role="form">
      <div class="modal-body">
        <div class="col-sm-12" style="float: right; padding: 1rem;">
            <div class="form-group">
                <label>채널 이름</label>
                <input type="text" class="form-control" name="channelTitle">
            </div>
        </div>
        <div class="col-sm-12" style="float: right; padding: 1rem;">
            <div class="form-group">
                <label>채널 멤버 찾기</label>
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#modal-sm">
                    <i class="fas fa-plus"></i>
                </button>
                <div class="card card-success" style="width: 8rem; height: 3rem; padding-top: .2rem; margin-top: 1rem;">
                  <!-- <div class="card-header" style="height: 1rem;"> -->
                    <div class="col-12"> 
                        <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="Message User Image">
                        <h6 class="h6">이주현</h6>
                        <div class="card-tools" style="position: relative; bottom: 1.4rem; left: 3.5rem; display: inline-block;">
                          <button type="button" class="btn btn-tool" data-card-widget="remove"><i class="fas fa-times" style="color: black;"></i></button>
                        </div>
                    </div> 
                  <!-- </div> -->
                </div>
            </div>
        </div>
      </div>
      <div class="modal-footer justify-content-between">
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
        <button type="submit" class="btn btn-primary">추가하기</button>
      </div>
    </form>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<div class="modal fade" id="modal-sm">
    <div class="modal-dialog modal-sm">
      <div class="modal-content">
        <div class="modal-header" style="height: 3rem;">
          <h4 class="modal-title" style="font-size: 1rem;">멤버</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
            <div class="card-tools" style="margin-bottom:2rem">
                <div class="input-group input-group-sm" style="width: 100%; margin: 0 auto;">
                  <input type="text" name="keyword" class="form-control float-right" id="findMember" placeholder="이름 혹은 이메일로 찾기">
                </div>
                
                <div class="input-group-append">
                  <button type="button" id="btn-findMember" class="btn btn-default"><i class="fas fa-search"></i></button>
                </div>
            </div>
            <div class="card-body table-responsive p-0" style="height: 14rem;">
                <table class="table table-head-fixed text-nowrap">
                  <tbody class="td">
                      <tr>
                        <td>
                          <div class="col-9"> 
                            <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="Message User Image">
                            <h6 class="h6">이주현</h6>
                          </div> 
                        </td>
                      </tr>
                  </tbody>
                </table>
            </div>
        </div>
      </div>
      <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
		

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>