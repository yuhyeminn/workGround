<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<script>
$(function(){
	$(".club").click(function(){
	  $("#modal-club").modal();
	});
	
	$("#new-club-card").click(function(){
	  $("#modal-new-club").modal();
	});
	
	$("#nav-new-club").click(function(){
	  $("#modal-new-club").modal();
	});
	
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
	
	$("#sidebar-club").addClass("active");
}
</script>

<style>
/*card*/
.card-club-image img{
  margin-top: 0.5rem;
  width: 100%;
  height: 200px;
}
.card-enroll-date{
  margin-top: 0.5rem;
  float: right;
}
.card-stand{
  margin-top: 0.5rem;
}

/*modal*/
.modal-club-info{
  color: gray;
}
#modal-image-slider img{
  width: 70%;
  height: 300px;
  margin-bottom: 2rem;
}
#up-btn{
  margin-top: 0.5rem;
  color: #464c59;
}
/*club-form*/
.form-check{
  margin: 0.7rem;
}
#btn-sub{
  margin: 1rem 0 2rem;
  text-align: center;
}
/* nav new club */
#nav-new-club{color:white;border:none;padding:0.35rem 0.5rem;margin-right:1rem;border-radius: 0.25rem;}
/* new club card */
#new-club-card{height: 298x; text-align: center; padding: 6rem 0rem;}
#new-club-card .card-body{color: #17a2b8;}
#new-club-card i{margin-bottom: .7rem; font-size:30px;}
#new-club-card:hover {background: #17a2b8;}
#new-club-card:hover .card-body{color: #fff;}
</style>

<!-- Navbar Club -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
    <!-- Left navbar links -->
    <ul class="navbar-nav">
        <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#">
            모임주기 <span class="caret"></span>
        </a>
        <div class="dropdown-menu">
            <a class="dropdown-item" tabindex="-1" href="#">매주</a>
            <a class="dropdown-item" tabindex="-1" href="#">격주</a>
            <a class="dropdown-item" tabindex="-1" href="#">매달</a>
            <a class="dropdown-item" tabindex="-1" href="#">3개월</a>
        </div>
        </li>
    </ul>

    <!-- Right navbar links -->
    <ul class="navbar-nav ml-auto navbar-nav-sort">
        <li class="nav-item dropdown">
            정렬
            <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#">
            이름순 <span class="caret"></span>
            </a>
            <div class="dropdown-menu">
            <a class="dropdown-item" tabindex="-1" href="#">등록일순</a>
            <a class="dropdown-item" tabindex="-1" href="#">이름순</a>
            </div>
        </li>
        <!-- 새 동호회 만들기 -->
        <li class="nav-item">
        <button id="nav-new-club" class="bg-info" style="font-size:0.85rem;" data-toggle="modal" data-target="#add-project-modal">
            <i class="fa fa-plus"></i>
            <span>새 동호회</span>
        </button>  
        </li>
    </ul>
</nav>
<!-- /.navbar -->

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
  <!-- Main content -->
  <div class="content">
    <div class="container-fluid">
      
      <!-- 동호회 목록 -->
      <section class="club-all-list">
          <div class="card-header" role="button" onclick="toggleList(this);">
            <h3><i class="fas fa-chevron-down"></i> 동호회 목록 <span class="header-count">(1)</span></h3>
          </div><!-- /.card-header -->
          
          <div class="row card-content">
            <div class="col-12 col-sm-6 col-md-3">
              <div class="card club card-hover">
                <div class="card-body">
                  <div class="card-title">
                    <h5>Eat Together</h5>
                  </div>

                    <!-- 삭제 버튼 -->
                    <div class="card-tools text-right">
                      <button type="button" class="btn btn-tool" data-card-widget="remove"><i class="fas fa-times"></i>
                      </button>
                    </div>
                
                  <div class="card-club-image"><img src="${pageContext.request.contextPath}/resources/img/food1.JPG" alt=""></div>
                  <div class="card-enroll-date">
                    <span class="enroll-date">2019/03/20</span>
                  </div>
                </div>
              </div><!-- /.card -->
            </div>
            <div class="col-12 col-sm-6 col-md-3">
              <div class="card club card-hover">
                <div class="card-body">
                  <div class="card-title">
                    <h5>여행여행</h5>
                  </div>
                   <!-- 삭제 버튼 -->
                   <div class="card-tools text-right">
                    <button type="button" class="btn btn-tool" data-card-widget="remove"><i class="fas fa-times"></i>
                    </button>
                  </div>
                  <div class="card-club-image"><img src="${pageContext.request.contextPath}/resources/img/travel1.JPG" alt=""></div>
                  <div class="card-enroll-date">
                    <span class="enroll-date">2019/03/20</span>
                  </div>
                </div>
              </div><!-- /.card -->
            </div>

            <div class="col-12 col-sm-6 col-md-3">
              <div class="card club card-hover">
                <div class="card-body">
                  <div class="card-title">
                    <h5>사진동호회</h5>
                  </div>
                 <!-- 삭제 버튼 -->
                 <div class="card-tools text-right">
                  <button type="button" class="btn btn-tool" data-card-widget="remove"><i class="fas fa-times"></i>
                  </button>
                </div>
                  <div class="card-club-image"><img src="${pageContext.request.contextPath}/resources/img/dd.JPG" alt=""></div>
                  <div class="card-enroll-date">
                    <span class="enroll-date">2019/03/20</span>
                  </div>
                </div>
              </div><!-- /.card -->
            </div>

        
            <div class="col-12 col-sm-6 col-md-3">
              <div class="card club card-hover">
                <div class="card-body">
                  <div class="card-title">
                    <h5>애니메이션</h5>
                  </div>
                <!-- 삭제 버튼 -->
                <div class="card-tools text-right">
                  <button type="button" class="btn btn-tool" data-card-widget="remove"><i class="fas fa-times"></i>
                  </button>
                </div>
                  <div class="card-club-image"><img src="${pageContext.request.contextPath}/resources/img/ff.JPG" alt=""></div>
                  <div class="card-enroll-date">
                    <span class="enroll-date">2019/03/20</span>
                  </div>
                </div>
              </div><!-- /.card -->
            </div>

            <div class="col-12 col-sm-6 col-md-3">
              <div class="card club card-hover">
                <div class="card-body">
                  <div class="card-title">
                    <h5>애니메이션</h5>
                  </div>
                    <!-- 삭제 버튼 -->
                    <div class="card-tools text-right">
                      <button type="button" class="btn btn-tool" data-card-widget="remove"><i class="fas fa-times"></i>
                      </button>
                    </div>
                  <div class="card-club-image"><img src="${pageContext.request.contextPath}/resources/img/aa.JPG" alt=""></div>
                  <div class="card-enroll-date">
                    <span class="enroll-date">2019/03/20</span>
                  </div>
                </div>
              </div><!-- /.card -->
            </div>

            <div class="col-12 col-sm-6 col-md-3">
              <div class="card club card-hover">
                <div class="card-body">
                  <div class="card-title">
                    <h5>야구</h5>
                  </div>
                  
               
                  <!-- 삭제 버튼 -->
                  <div class="card-tools text-right">
                      
                    <button type="button" class="btn btn-tool" data-card-widget="remove"><i class="fas fa-times"></i>
                    </button>
                  </div>

                  <div class="card-club-image"><img src="${pageContext.request.contextPath}/resources/img/fs.JPG" alt=""></div>
                   <!-- 수정 버튼 -->
                   <button type="button" id="up-btn"><i class="fas fa-edit"></i></button>
                  <div class="card-enroll-date">
                    <span class="enroll-date">2019/03/20</span>
                  </div>
                </div>
              </div><!-- /.card -->
            </div>

            <div class="col-12 col-sm-6 col-md-3">
              <div class="card new" id="new-club-card">
                <div class="card-body">
                  <i class="fas fa-plus"></i>
                  <h6>새 동호회</h6>
                </div>
              </div><!-- /.card -->
            </div>
    
          </div>
      </section>

      <!-- 내가 가입한 동호회 목록 -->
      <section class="my-club">
          <div class="card-header" role="button" onclick="toggleList(this);">
            <h3><i class="fas fa-chevron-down"></i> 내가 가입한 동호회 <span class="header-count">(1)</span></h3>
          </div><!-- /.card-header -->
          <div class="row card-content">
            <div class="col-12 col-sm-6 col-md-3">
              <div class="card club card-hover">
              	<a href="${pageContext.request.contextPath}/club/clubView.do">
	                <div class="card-body">
	                    <div class="card-title">
	                    	<h5>야구</h5>
	                    </div>
	                    <!-- 삭제 버튼 -->
	                    <div class="card-tools text-right">
	                      <button type="button" class="btn btn-tool" data-card-widget="remove"><i class="fas fa-times"></i>
	                      </button>
	                    </div>
	                    <div class="card-club-image"><img src="${pageContext.request.contextPath}/resources/img/fs.JPG" alt=""></div>
	                    <div class="card-enroll-date">
	                    	<span class="enroll-date">2019/03/20</span>
	                    </div>
	                </div>
                </a>
              </div><!-- /.card -->
            </div>
          </div>
      </section>

      <!-- 승인 대기중인 동아리 목록 -->
      <section class="stand-by-club">
        <div class="card-header" role="button" onclick="toggleList(this);">
          <h3><i class="fas fa-chevron-down"></i> 승인 대기중인 동호회 <span class="header-count">(1)</span></h3>
        </div><!-- /.card-header -->
        
        <div class="row card-content">
          <div class="col-12 col-sm-6 col-md-3">
              <div class="card club card-hover">
                <div class="card-body">
                  <!-- 타이틀 -->
                  <div class="card-title">
                    <h5>애니메이션</h5>
                  </div>
                     <!-- 삭제 버튼 -->
                     <div class="card-tools text-right">
                      <button type="button" class="btn btn-tool" data-card-widget="remove"><i class="fas fa-times"></i>
                      </button>
                    </div>
                  <div class="card-club-image"><img src="${pageContext.request.contextPath}/resources/img/dd.JPG" alt=""></div>
                  <!-- 프로젝트 상태 / 마감일 -->
                  
                  <div class="card-stand"><span>승인대기</span></div>
                
                  <div class="card-enroll-date">
                    <span class="enroll-date">2019/03/20</span>
                  </div>
                </div>
              </div><!-- /.card -->
          </div>
        </div>
      </section>

    </div><!-- /.container-fluid -->
  </div>
  <!-- /.content -->
</div>
<!-- /.content-wrapper -->

<!-- modal Club 부분 -->
<div class="modal fade" id="modal-club">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title">여행여행</h4>
      
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <!-- image -->
        <div id="modal-image-slider" class="carousel slide" data-ride="carousel">
          <ol class="carousel-indicators">
            <li data-target="#modal-image-slider" data-slide-to="0" class="active"></li>
            <li data-target="#modal-image-slider" data-slide-to="1"></li>
            <li data-target="#modal-image-slider" data-slide-to="2"></li>
          </ol>
          <div class="carousel-inner">
            <div class="carousel-item active">
              <img class="d-block w-100" src="${pageContext.request.contextPath}/resources/img/dd.JPG" alt="First slide">
            </div>
            <div class="carousel-item">
              <img class="d-block w-100" src="${pageContext.request.contextPath}/resources/img/dd.JPG" alt="Second slide">
            </div>
            <div class="carousel-item">
              <img class="d-block w-100" src="${pageContext.request.contextPath}/resources/img/dd.JPG" alt="Third slide">
            </div>
          </div>
          <a class="carousel-control-prev" href="#modal-image-slider" role="button" data-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
          </a>
          <a class="carousel-control-next" href="#modal-image-slider" role="button" data-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="sr-only">Next</span>
          </a>
        </div>

        <span class="modal-text">국내여행.해외여행.정기모임.트레킹(산행).섬여행. 명승지관광. 정모를 통하여 친목을 다지며 국내여행과 더존나라 해외여행으로 견문을 넓히며 보다 건강하고 즐겁게 삶의 여유를 가지고 살아가는 회원들이 주최인 여행동호회 입니다.</span>
        <hr>
        <div class="modal-club-info">
          <span>회원 - </span>&nbsp;
          <span>10명</span>
          <br>
          <span>담당대표 - </span>&nbsp;
          <span>박보검</span>
          <br>
          <span>모임날짜 - </span>&nbsp;
          <span>월, 금</span>
          <br>
          <span>등록일 - </span>&nbsp;
          <span>2019/03/20</span>
        </div>
        
      </div>
      <div class="modal-footer justify-content-between">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary" id="join">가입하기</button>
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
        <h4 class="modal-title">Let's Be</h4>
      
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div>
          <!-- form start -->
          <form role="form" id="new-club-form">
              <div class="form-group">
                <label>이름</label>
                <input type="text" class="form-control">
              </div><!--  /.form-group -->
              <div class="form-group">
                <label>소개</label>
                <textarea class="form-control" rows="7" placeholder="소개글을 작성해주세요"></textarea>
              </div><!--  /.form-group -->
              <div class="form-group">
                <label>사진파일</label>
                <div class="input-group">
                  <div class="custom-file col-lg-6">
                      <input type="file" class="custom-file-input" id="file1">
                      <label class="custom-file-label" for="exampleInputFile">Choose file</label>
                  </div>
                  <div class="custom-file col-lg-6">
                    <input type="file" class="custom-file-input" id="file2">
                    <label class="custom-file-label" for="exampleInputFile">Choose file</label>
                  </div>
                </div>
                <div class="input-group">
                  <div class="custom-file col-lg-6">
                    <input type="file" class="custom-file-input" id="file3">
                    <label class="custom-file-label" for="exampleInputFile">Choose file</label>
                  </div>
                  <div class="custom-file col-lg-6">
                    <input type="file" class="custom-file-input" id="file4">
                    <label class="custom-file-label" for="exampleInputFile">Choose file</label>
                  </div>
                </div>
                <div class="input-group">
                  <div class="custom-file col-lg-6">
                    <input type="file" class="custom-file-input" id="file5">
                    <label class="custom-file-label" for="exampleInputFile">Choose file</label>
                  </div>
                  <div class="custom-file col-lg-6">
                    <input type="file" class="custom-file-input" id="file6">
                    <label class="custom-file-label" for="exampleInputFile">Choose file</label>
                  </div>
                </div>
                <div class="input-group">
                  <div class="custom-file col-lg-6">
                    <input type="file" class="custom-file-input" id="file7">
                    <label class="custom-file-label" for="exampleInputFile">Choose file</label>
                  </div>
                  <div class="custom-file col-lg-6">
                    <input type="file" class="custom-file-input" id="file8">
                    <label class="custom-file-label" for="exampleInputFile">Choose file</label>
                  </div>
                </div>
              </div><!--  /.form-group -->
                
              <label for="check-week">모임 요일</label>
              <div id="check-week" class="input-group">
                <div class="form-check">
                  <input type="checkbox" class="form-check-input" id="mon">
                  <label class="form-check-label" for="mon">월</label>
                </div>
                <div class="form-check">
                  <input type="checkbox" class="form-check-input" id="tue">
                  <label class="form-check-label" for="tue">화</label>
                </div>
                <div class="form-check">
                  <input type="checkbox" class="form-check-input" id="wed">
                  <label class="form-check-label" for="wed">수</label>
                </div>
                <div class="form-check">
                  <input type="checkbox" class="form-check-input" id="thu">
                  <label class="form-check-label" for="thu">목</label>
                </div>
                <div class="form-check">
                  <input type="checkbox" class="form-check-input" id="fri">
                  <label class="form-check-label" for="fri">금</label>
                </div>
                <div class="form-check">
                  <input type="checkbox" class="form-check-input" id="sat">
                  <label class="form-check-label" for="sat">토</label>
                </div>
                <div class="form-check">
                  <input type="checkbox" class="form-check-input" id="sun">
                  <label class="form-check-label" for="sun">일</label>
                </div>
              </div><!-- /.input-group -->
            
              <div id="btn-sub">
                <button type="submit" id="join-btn" class="btn btn-primary">가입하기</button>
              </div>
          </form>
          <!-- form end -->
        </div>
      </div><!-- /.modal-body -->
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<!-- /.modal -->

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>