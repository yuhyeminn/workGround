
//사이드바 활성화
function sidebarActive(){
	let navLinkArr = document.querySelectorAll(".sidebar .nav-link");
	
	navLinkArr.forEach((obj, idx)=>{
		let $obj = $(obj);
		if($obj.hasClass('active'))
			$obj.removeClass('active');
	});
	
	$("#sidebar-project").addClass("active");
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

    $("#tab-work").addClass("active");
}

//서브헤더 탭 페이지로 이동
function goTabMenu(info){
	let contentWrapper = document.querySelector(".content-wrapper");
	let btnWork = document.querySelector("#btn-tab-work");
	let btnTimeline = document.querySelector("#btn-tab-timeline");
	let btnAnalysis = document.querySelector("#btn-tab-analysis");
	let btnAttach = document.querySelector("#btn-tab-attach");
	
	//업무 탭 클릭
	btnWork.addEventListener('click', e=>{
		location.href = contextPath+"/project/projectView.do?projectNo="+info.projectNo;	
	});
	
	//나의 워크패드에서는 타임라인, 분석 보이지 않음
	if(info.privateYn==='N'){
		//타임라인 탭 클릭
		btnTimeline.addEventListener('click', e=>{
			closeSideBar();
			$.ajax({
				url: contextPath+"/project/projectView.do?projectNo="+info.projectNo+"&tab=timeline",
				type: "get",
				dataType: "html",
				success: data => {
					$(contentWrapper).html("");
					$(contentWrapper).html(data); 
					$(contentWrapper).removeAttr('id');
					$(contentWrapper).attr('class', 'content-wrapper navbar-light');
				},
				error: (x,s,e) => {
					console.log(x,s,e);
				}
			});
		});
		
		//분석 탭 클릭
		btnAnalysis.addEventListener('click', e=>{
			closeSideBar();
			$.ajax({
				url: contextPath+"/project/projectAnalysis.do?projectNo="+info.projectNo,
				type: "get",
				dataType: "html",
				success: data => {
					$(contentWrapper).html("");
					$(contentWrapper).html(data); 
					$(contentWrapper).removeAttr('id');
					$(contentWrapper).attr('class', 'content-wrapper navbar-light');
					
					$('.main-footer').css('width', 'inherit');
				},
				error: (x,s,e) => {
					console.log(x,s,e);
				}
			});
		}); 
	} //end of if
	
	//파일 탭 클릭
	btnAttach.addEventListener('click', e=>{
		closeSideBar();
		$.ajax({
			url: contextPath+"/project/projectView.do?projectNo="+info.projectNo+"&tab=attach",
			type: "get",
			dataType: "html",
			success: data => {
				$(contentWrapper).html("");
				$(contentWrapper).html(data); 
				$(contentWrapper).removeAttr('id');
				$(contentWrapper).attr('class', 'content-wrapper navbar-light');
				
				$('.main-footer').css('width', 'inherit');
			},
			error: (x,s,e) => {
				console.log(x,s,e);
			}
		});
	}); 
}

//설정창
function setting(info){
    var $side = $("#setting-sidebar");
    
    //설정 사이드바 열기
    $('#project-setting-toggle').on('click', function(){
        $.ajax({
			url: contextPath+"/project/projectSetting.do",
			type: "get",
			data:{projectNo:info.projectNo},
			dataType: "html",
			success: data => {
				
				$side.html("");
				$side.html(data); 
			},
			error: (x,s,e) => {
				console.log(x,s,e);
			}
		});
        
        $side.addClass('open');
        if($side.hasClass('open')) {
        	$side.stop(true).animate({right:'0px'});
        }
    });
    
    //업무 사이드바 열기
    $(document).on('click', '.work-item', function(){
    	var workNo = $(this).attr('id');
    	
    	//업무리스트 타이틀
        var worklistTitle = $(this).children("#hiddenworklistTitle").val();
    	
        $.ajax({
			url: contextPath+"/project/workSetting.do",
			type: "get",
			data:{workNo:workNo, worklistTitle:worklistTitle, projectNo:info.projectNo},
			dataType: "html",
			success: data => {
				
				$side.empty();
				$side.html(data); 
			},
			error: (x,s,e) => {
				console.log(x,s,e);
			}
		});
        
        $side.addClass('open');
        if($side.hasClass('open')) {
        	$side.stop(true).animate({right:'0px'});
        }
    });
    
    //대화 사이드바 열기
    $('#btn-openChatting').on('click', ()=>{
    	$.ajax({
			url: contextPath+"/chat/projectChatting.do",
			type: "get",
			data: {projectNo:info.projectNo},
			dataType: "html",
			success: data => {
				$side.html("");
				$side.html(data); 
				
				//스크롤 최하단 포커싱
				let section = document.querySelector('#chatSide-msg-wrapper');
				section.scrollTop = section.scrollHeight;
			},
			error: (x,s,e) => {
				console.log(x,s,e);
			}
		});
        
        $side.addClass('open');
        if($side.hasClass('open')) {
        	$side.stop(true).animate({right:'0px'});
        }
    });
    
    //활동로그 열기 
    $("#btn-projectLog").on('click', ()=>{
    	$.ajax({
			url: contextPath+"/project/projectSetting.do",
			type: "get",
			data:{projectNo:info.projectNo},
			dataType: "html",
			success: data => {
		    	
				$side.html("");
				$side.html(data); 
				
				let section = document.querySelector('#setting-sidebar>section');
				let tabHome = document.querySelector('#custom-content-above-home-tab');
		    	let tabLog = document.querySelector('#custom-content-above-log-tab');
		    	let contentHome = document.querySelector('#custom-content-above-home');
		    	let contentLog = document.querySelector('#custom-content-above-log');	
			
				//모든 활동탭 active하기
				$(tabHome).removeClass('active');
				$(tabLog).addClass('active');
				$(contentHome).removeClass('show active');
				$(contentLog).addClass('show active');
				
				//스크롤 최하단 포커싱
				section.scrollTop = section.scrollHeight;
				
			},
			error: (x,s,e) => {
				console.log(x,s,e);
			}
		});
        
        $side.addClass('open');
        if($side.hasClass('open')) {
        	$side.stop(true).animate({right:'0px'});
        }
    });
    
}

//사이드바 닫기
function closeSideBar(){
	var $side = $("#setting-sidebar");
    if($side.hasClass('open')) {
        $side.stop(true).animate({right:'-600px'});
        $side.removeClass('open');
    }
}

//체크리스트 업무 배정
function updateChkChargedMember(){
	  $(document).on('click', ".chk-charge-member", function(){
		 var workNo = $("#settingWorkNo").val();
		 
		 var $this = $(this);
		 var memberId = $(this).attr('id');
		 var checklistNo = $(this).closest("tr").attr('id');
		 $.ajax({
			 url:contextPath+"/project/updateChkChargedMember.do",
			 data: {checklistNo:checklistNo, memberId:memberId, workNo:workNo},
			 dataType:"json",
			 success: data=>{
				 if(data.isUpdated){
						 var originImg = $this.closest("td").children(".update-chk-charge");
						 originImg.remove();
					 //멤버 수정할 때
					 if(memberId != '' && memberId != null){
						 var member = data.member;
						 $this.closest("td").find(".del-chk-charge-member").show();
						 var profile = '<img src="'+contextPath+'/resources/img/profile/'+member.renamedFileName+'" data-toggle="dropdown" alt="User Avatar" class="img-circle img-profile ico-profile update-chk-charge" title="'+member.memberName+'">';
						 $this.closest("td").prepend(profile);
					 }
					 //멤버 없앨 때
					 else{
						 $this.closest("td").find(".del-chk-charge-member").hide();
						 var profile = '<div class="img-circle img-profile ico-profile update-chk-charge" data-toggle="dropdown" ><i class="fas fa-user-plus" style="width:15px;margin-top: 5px;"></i></div>';
						 $this.closest("td").prepend(profile);
					 }
					 resetWorkView(); //업무 새로고침
				 }
			 },
			 error:(jqxhr, textStatus, errorThrown)=>{
				 console.log(jqxhr, textStatus, errorThrown);
			 } 
		 })
	 })
}

function deleteChecklist(){
	 $(document).on('click', ".delete-checklist", function(){
		 var workNo = $("#settingWorkNo").val();
		 var checklistNo = $(this).attr("id");
		 var isCompleted = $(this).closest("tr").hasClass("completed");
		 $.ajax({
			 url:contextPath+"/project/deleteChecklist.do",
			 data: {checklistNo:checklistNo},
			 dataType:"json",
			 success: data=>{
				 if(data.isUpdated){
				 	$(".tbl-checklist tr#"+checklistNo).remove();
				 	$(".work-item#"+workNo+" .work-checklist tbody tr#"+checklistNo).remove();
				 	
				 	//체크리스트 숫자 삭감
				 	var cnt = Number($(".work-item#"+workNo+" .work-etc .chklt-cnt-total").text());
					$(".work-item#"+workNo+" .work-etc span.chklt-cnt-total").text(cnt-1);
				 	if(isCompleted){
				 		var completecnt = Number($(".work-item#"+workNo+" .work-etc .chklt-cnt-completed").text());
				 		$(".work-item#"+workNo+" .work-etc span.chklt-cnt-completed").text(completecnt-1);
				 	}
					
					//체크리스트 테이블 없을 경우
				 	if($(".work-item#"+workNo+" .work-checklist tbody>tr").length == 0){
				 		$("section#"+workNo+".work-item .work-checklist table").remove();
				 		console.log(workNo);
				 		$("section#"+workNo+".work-item .work-etc").children(".chklt-cnt").eq(0).remove();
						var cnthtml='<span class="ico"><i class="far fa-list-alt "></i> 0</span>'
						$("section#"+workNo+".work-item .work-etc").prepend(cnthtml);
				 	}
				 }
			 },
			 error:(jqxhr, textStatus, errorThrown)=>{
				 console.log(jqxhr, textStatus, errorThrown);
			 } 
		 })
	 })
}

function deleteWorkComment(){
	 $(document).on('click',".work-comment-delete", function(){
		 var workNo = $("#settingWorkNo").val();
		 var commentNo = $(this).val();
		 $.ajax({
			 url:contextPath+"/project/deleteWorkComment.do",
			 data: {commentNo:commentNo},
			 dataType:"json",
			 success: data=>{
				 if(data.isUpdated){
					 $(".work-comments-box .work-comment#"+commentNo).remove();
					 //코멘트 숫자 1 삭감
		             var cnt = Number($("section#"+workNo+".work-item .work-etc .comment-cnt").text());
					 console.log($("section#"+workNo+".work-item .work-etc .comment-cnt"));
					 console.log(workNo);
				 	 $("section#"+workNo+".work-item .work-etc span.comment-cnt").text(cnt-1);
				 	 
					 if($(".work-ref-"+commentNo).length>0){
						 var refcnt = Number($(".work-ref-"+commentNo).length);
						 $("section#"+workNo+".work-item .work-etc .comment-cnt").text(cnt-refcnt-1); 
						 
						 $(".work-ref-"+commentNo).remove();
					 }
					 if($(".work-comments-box .card-comment").length==0){
						 $(".work-comments-box").remove();
						 var html ='<div id="null-comment-box" style="text-align:center;margin-top: 106px;"><img src="https://d30795irbdecem.cloudfront.net/assets/comment-empty-state@2x-d1554722.png" style="width:20rem;">'
						 			+'<p style="font-size:10px; color:lightgray;">Comments are great for focusing conversation on the task at hand.</p></div>';
						 $(".work-comment-box").append(html);
					 }
				 } 
			 },
			 error:(jqxhr, textStatus, errorThrown)=>{
				 console.log(jqxhr, textStatus, errorThrown);
			 } 
		 });
	 });
}
function delWorkFile(){
$(document).on('click', '.work-file-remove', e=>{
		let btnRemove = e.target;
		let attachNo = Number(btnRemove.value.split(',')[0]);
		let rName = btnRemove.value.split(',')[1];
		let projectNo = $("#settingProjectNo").val();
		
		if(confirm("파일을 삭제하시겠습니까?")){
			$.ajax({
				url: contextPath+'/project/deleteFile',
				data: {attachNo:attachNo,rName:rName,projectNo:projectNo},
				dataType: 'json',
				type: 'POST',
				success: data=>{
					if(data.result==='success'){
						$(".work-attachment-tbl tr#"+attachNo).remove();
						if($(".work-attachment-tbl tbody>tr").length==0){
							var html = '<tr id="no-exist-file" style="text-align:center;"><td colspan="3" style="padding:1rem;">파일이 존재하지 않습니다.</td></tr>';
							$(".work-attachment-tbl tbody").append(html);
						}
						resetWorkView(); //업무 새로고침
					}
					else{
						alert("파일 삭제에 실패했습니다 :(");
					}
				},
				error: (x,s,e)=>{
					console.log(x,s,e);
				}
			});
		}
	});
}
//프로젝트 설명 수정, 업무 설명 수정
function updateDesc(){
  	 $(document).on('click',".add-description",function(){
  		 $(this).hide();
  		 $(".edit-description").show();
  		 $("#desc").focus();
  	 });
  	 $(document).on('click',".update-description",function(){
  		 var desc = $("#desc").val();
  		 var no = $(this).attr("id");
  		 var type;
  		 if($(this).hasClass('wr-desc')) type = 'work';
  		 else type= 'project';
  		 
  		 $.ajax({
  			
  			 url:contextPath+"/project/updateDesc.do",
  			 data: {desc:desc,no:no,type:type},
  			 dataType:"json",
  			 success: data=>{
  				 if(data.isUpdated){
 					 $(".edit-description").hide();
 					 if(desc != '' && desc != null){
 						var html = '<div class="row setting-row add-description"><span style="color:#696f7a">'+desc+'</span></div>';
 					 }
 					 else{
 						var html = '<div class="row setting-row add-description"><span>설명 추가</span></div>';
 					 }
 					 $(".add-description").remove();
 					 $(".p-setting-container").prepend(html);
 				 }
  			 },
  			 error:(jqxhr, textStatus, errorThrown)=>{
  				 console.log(jqxhr, textStatus, errorThrown);
  			 } 
  		 }) 
  	 })
   }
function updateTitle(){
	$(document).on('click',".update-side-title",function(){
 		 $(this).hide();
 		 $(".edit-side-title").show();
 		 $("#title").focus();
 	 });
	$(document).on('click',".update-title-btn",function(){
 		 var title = $("#title").val();
 		 var no = $(this).attr("id");
 		 var type;
 		 if($(this).hasClass('wr-title')) type = 'work';
 		 else type= 'project';
 		 
 		 if(title == '' || title == null){alert('제목을 입력하세요.');return;}
 		 
 		 $.ajax({
 			 url:contextPath+"/project/updateTitle.do",
 			 data: {title:title,no:no,type:type},
 			 dataType:"json",
 			 success: data=>{
 				if(data.isUpdated){
 					 $(".edit-side-title").hide();
 					 var html = '<p class="setting-side-title update-side-title">'+title+'<button class="update-title"><i class="fas fa-pencil-alt"></i></button></p>';
 					 
 					 $(".update-side-title").remove();
 					 $("div.p-3").prepend(html);
 					 if(type=='project'){
 						$("#header-project-title").text(title);
 					 }
 					 else{
 						$(".work-item#"+no+" .work-title h6>span").text(title);
 					 }
 				 }
 			 },
 			 error:(jqxhr, textStatus, errorThrown)=>{
 				 console.log(jqxhr, textStatus, errorThrown);
 			 } 
 		 }) 
 	 })
}
//파일 다운로드
function downloadWorkFile(){
	$(document).on('click', '.btn-work-file-down', e=>{
		let btnDown = e.target;
		let attachNo = btnDown.value;
		let $tr = $('.work-attachment-tbl tr#'+attachNo);
		let projectNo = $("#settingProjectNo").val();
		let oName = $tr.find('.oName').val();
		let rName = $tr.find('.rName').val();
		
		location.href = contextPath+"/project/downloadFile.do?projectNo="+projectNo+"&oName="+oName+"&rName="+rName;
	});
}

function updateChklist(){
	$(document).on('click',".edit-checklist",function(){
		//다른 체크리스트들 초기화
		var $tbody = $(this).closest("tbody");
		var trArr = $tbody.children("tr").not("#chk-add-tr");
		trArr.each(function(){
			var $this = $(this);
			var $chkspan = $this.find(".checklistContent");
			var $chkinput = $chkspan.next();
			$this.css("background","white");
			$this.find(".update-checklist-btn").removeClass("update-checklist-btn").addClass("edit-checklist");
			$chkinput.hide();
			$chkinput.val($chkspan.text());
			$chkspan.show();
		})
		
		var $chkspan = $(this).parent().find(".checklistContent");
		var $chkinput = $chkspan.next();
		var $tr = $(this).closest("tr");
		
		$chkspan.hide();
		$chkinput.show();
		$chkinput.focus();
		$tr.css("background","rgb(239, 239, 239)");
		
		$(this).removeClass("edit-checklist");
		$(this).addClass("update-checklist-btn");
	 });
	
	$(document).on('click',".update-checklist-btn",function(){
		 var workNo = $("#settingWorkNo").val();
		 var $td = $(this).parent();
		 var $tr = $td.parent("tr");
		 var chkContent = $td.find(".currentChecklistContent").val();
		 var chkNo = $tr.attr("id");
		 
		 if(chkContent == '' || chkContent == null){alert('내용을 입력하세요.');return;}
		
		 $.ajax({
			 url:contextPath+"/project/updateChklist.do",
			 data: {chkContent:chkContent,chkNo:chkNo},
			 dataType:"json",
			 success: data=>{
				if(data.isUpdated){
					var $chkspan = $tr.find(".checklistContent");
					var $chkinput = $chkspan.next();
					
					$("section#"+workNo+".work-item .work-checklist tr#"+chkNo+" .checklistContent").text(chkContent);
					$(this).removeClass("update-checklist-btn").addClass("edit-checklist");
					
					$chkspan.text(chkContent);
					$chkinput.val($chkspan.text());
					
					$tr.css("background","white");
					$chkinput.hide();
					$chkspan.show();
				}
			 },
			 error:(jqxhr, textStatus, errorThrown)=>{
				 console.log(jqxhr, textStatus, errorThrown);
			 } 
		 }) 
	 })
}
function workCopy(){
	//모달 띄워질 때 로그인한 회원이 매니저로 있는 프로젝트 리스트 가져오기
	$("#modal-work-copy").on('show.bs.modal',function(){
		//모달창 초기화
		$("#myProjectList option").not("[value='']").remove();
		$("#myProjectWorklist option").not("[value='']").remove();
		
		$.ajax({
			url: contextPath+"/project/getMyManagingProjectList.do",
			type: "get",
			dataType: "json",
			success: data => {
				if(data != null){
					$.each(data,(idx,p)=>{
						var option = "<option value='"+p.projectNo+"' style='color:black'>"+p.projectTitle+"</option>";
						$("#myProjectList").append(option);
					});
				}
			},
			error: (x,s,e) => {
				console.log(x,s,e);
			}
		});
	})
	
	//선택한 프로젝트의 업무리스트의 리스트 가져오기
	$("#myProjectList").on('change',function(){
		var projectNo = Number($(this).val());
		//업무리스트 리스트 초기화
		$("#myProjectWorklist option").not("[value='']").remove();
		//'프로젝트를 선택하세요' 선택되어있을 경우 return
		if(projectNo == '' || projectNo ==null) return;
		
		$.ajax({
			url: contextPath+"/project/getWorklistByProjectNo.do",
			type: "get",
			data:{projectNo:projectNo},
			dataType: "json",
			success: data => {
				if(data != null){
					$.each(data,(idx,wl)=>{
						var option = "<option value='"+wl.worklistNo+"' style='color:black'>"+wl.worklistTitle+"</option>";
						$("#myProjectWorklist").append(option);
					});
				}
			},
			error: (x,s,e) => {
				console.log(x,s,e);
			}
		});
	})
	
	$("#work-copy-btn").on('click',function(){
		var projectNo = $("#myProjectList").val();
		var worklistNo = Number($("#myProjectWorklist").val());
		var workNo = Number($("#copyWorkNo").val());
		var currentProjectNo = $("#hiddenProjectNo").val();
		
		if(projectNo == '' || projectNo == null) {alert("프로젝트를 선택하세요.");return;}
		if(worklistNo == '' || worklistNo == null) {alert("업무 리스트를 선택하세요");return;}
		
		$('#modal-work-copy').modal('hide');
		
		$.ajax({
			url: contextPath+"/project/copyWork.do",
			type: "get",
			data:{worklistNo:worklistNo, workNo:workNo},
			dataType: "json",
			success: data => {
				if(data.isComplete){
					alert("업무 복사가 완료되었습니다.");
					if(projectNo == currentProjectNo){
						resetWorklist(worklistNo); //worklist새로고침
					}
				}else{
					alert("업무 복사에 실패하였습니다.");
				}
			},
			error: (x,s,e) => {
				console.log(x,s,e);
			}
		});
	})
}

//프로젝트 별 해제/등록
function projectStar(info){
    let btnStar = document.querySelector("#btn-star .fa-star");
    
    btnStar.addEventListener('click', (e)=>{
        let $this = $(e.target);

        $.ajax({
        	url: contextPath+'/project/projectStarCheck.do',
        	data: {memberId: info.memberId,
        		   projectNo: info.projectNo},
        	dataType: 'json',
        	type: 'POST',
        	success: data=>{
        		//중요표시 해제한 경우
        		if(data.result === 'delete')
        			$this.removeClass('fas').addClass('far');
        		//중요표시 한 경우
        		else
        			$this.removeClass('far').addClass('fas');
        	},
        	error: (x,s,e) => {
				console.log(x,s,e);
			}
        });
        
    });
} 

//업무 검색
function searchWork(info){
	let wrapper = document.querySelector(".container-fluid");
	let url = contextPath+'/project/searchWork';
	let input;
	let keyword; 
	
	//엔터키
 	$(document).on('keydown', '#workSearchFrm input', (e)=>{
 		input = document.querySelector("input[name=searchWorkKeyword]");
 		keyword = $(input).val().trim(); 
 		
		if(e.which==13){
			//유효성 검사
			if(keyword==""){
				alert("검색 키워드를 입력해 주세요!");
			}
			
			let data = {
					projectNo: info.projectNo,
					keyword: keyword,
					isProjectManager: info.isProjectManager
			};
			
			ajax(data);
		}
		
	}); 
	
	//검색버튼 클릭
	$(document).on('click', '#btn-searchWork', (e)=>{
		input = document.querySelector("input[name=searchWorkKeyword]");
		keyword = $(input).val().trim();

		//유효성 검사
		if(keyword==""){
			alert("검색 키워드를 입력해 주세요!");
		}
		
		let data = {
				projectNo: info.projectNo,
				keyword: keyword,
				isProjectManager: info.isProjectManager
		};
		
		ajax(data);
	});
		
	function ajax(data){
		$.ajax({
			url: url,
			data: data,
			dataType: 'html',
			type: 'GET',
			success: data=>{
				if(data!=null){
					$(wrapper).html("");
					$(wrapper).html(data);
				}
				else{
					alert("업무 검색에 실패했습니다 :(");
				}
			},
			error: (x,s,e) => {
				console.log(x,s,e);
			}
		}); 
	}	
}

//새 업무리스트 만들기
function addWorklist(info){
	let addWklt = document.querySelector("#add-wklt-wrapper");
	let addWkltFrm;
	let inputTitle;
	
	let btnAdd = document.querySelector("#btn-addWorklist");
	let btnCancel = document.querySelector("#btn-cancel-addWorklist");
	let url = contextPath+'/project/addWorklist.do';

    //프로젝트 팀원들에게는 업무리스트 추가가 보이지 않음!
    if(addWklt!==null){
	    //업무리스트 추가 클릭시 입력폼 보이기
    	$(document).on('click', '#add-wklt-wrapper', ()=>{
    		addWklt = document.querySelector("#add-wklt-wrapper");
    		addWkltFrm = document.querySelector("#add-wkltfrm-wrapper");
    		inputTitle = document.querySelector("input[name=worklistTitle]");
    		
	        $(addWklt).hide();
	        $(addWkltFrm).show();
	        $(inputTitle).focus();
    		
	        //x버튼 클릭시 다시 업무리스트 추가 보이기
	        $(document).on('click', '#btn-cancel-addWorklist', ()=>{
	        	$(addWkltFrm).hide();
	        	$(inputTitle).val("");
	        	$(addWklt).show();
	        });
	        
	    }); //end of 업무리스트 추가 클릭
    	
    	//엔터키 입력시 업무리스트 추가
    	$(document).on('keydown', 'input[name=worklistTitle]', (key)=>{
    		if(key.keyCode==13){
    			let val = $(inputTitle).val().trim();
    			
    			//유효성 검사
    			if(val===""){
    				alert("추가할 업무리스트의 이름을 입력해 주세요!");
    				return;
    			}
    			
    			let data = {
    					projectNo: info.projectNo,
    					isProjectManager: info.isProjectManager,
    					worklistTitle: val
    			};
    			
    			ajax(data);
    		}
    	});
    	
    	//+버튼 클릭시 업무리스트 추가
    	$(document).on('click', '#btn-addWorklist', ()=>{
    		let val = $(inputTitle).val().trim();
    		
    		//유효성 검사
    		if(val===""){
    			alert("추가할 업무리스트의 이름을 입력해 주세요!");
    			return;
    		}
    		
    		let data = {
    				projectNo: info.projectNo,
    				isProjectManager: info.isProjectManager,
    				worklistTitle: val
    		};
    		
    		ajax(data);
    		
    	}); //end of +버튼 클릭
    	
    	function ajax(data) {
    		$.ajax({
    			url: url,
    			data: data,
    			dataType: 'html',
    			type: 'POST',
    			success: data=>{
    				if(data!=null){
    					//초기화
    					$(inputTitle).val("");
    					$(addWkltFrm).hide();
    					$(addWklt).show();
    					
    					//업무리스트 추가
    					$(addWklt).before(data);
    				}
    				else{
    					alert("새 업무리스트 추가에 실패했습니다 :(");
    				}
    			},
    			error: (x,s,e) => {
    				console.log(x,s,e);
    			}
    		}); 
    	}
    	
    } //end of if
}


//업무리스트 제목 수정하기
function updateWorklistTitle(){
	let worklistNo;
	let wlTitle;
	let wlInner;
	let updateTitleWrapper;
	let input;
	let btnUpdate;
	let url = contextPath+'/project/updateWorklistTitle.do';
	
	$(document).on('click', '.btn-showUpdateFrm', (e)=>{
		let btnShow;		
		if(e.target.tagName==='I') btnShow = e.target.parentNode;	
		else btnShow = e.target;
		
		worklistNo = btnShow.value*1;
		wlTitle = document.querySelector("#worklist-"+worklistNo+' h5').innerText;
		wlInner = document.querySelector("#worklist-"+worklistNo+' .wlTitle-inner');
		updateTitleWrapper = document.querySelector('#worklist-'+worklistNo+' .update-wlTitle-wrapper');
		input = document.querySelector("#worklist-"+worklistNo+' input[name=newWorklistTitle]');
		btnUpdate = document.querySelector('#worklist-'+worklistNo+' .btn-updateWlTitle');
		
		//수정폼 보이기 		
		$(wlInner).hide();
		$(updateTitleWrapper).show();
		$(input).val(wlTitle);
		$(input).focus();
		
		//x버튼 클릭시 되돌리기
	    $(document).on('click', '#worklist-'+worklistNo+' .btn-cancel-updateWlTitle', ()=>{
	    	$(wlInner).show();
			$(updateTitleWrapper).hide();
			$(input).val("");
	    });
	    
	}); //end of click .btn-showUpdateFrm
	
	//엔터키 입력시 제목 수정
	$(document).on('keydown', 'input[name=newWorklistTitle]', (key)=>{
    	if(key.keyCode==13){
			let val = $(input).val().trim();
    		
    		//유효성 검사
            if(val===""){
            	alert("추가할 업무리스트의 이름을 입력해 주세요!");
            	return;
            }
    		
            let data = {
            	worklistNo: worklistNo,
            	worklistTitle: val
            };
            
            ajax(data);
    	}
    });
    
    //연필버튼 클릭시 제목 수정
    $(document).on('click', '.btn-updateWlTitle', (e)=>{
		let val = $(input).val().trim();
        
        //유효성 검사
        if(val===""){
        	alert("추가할 업무리스트의 이름을 입력해 주세요!");
        	return;
        }
        
        let data = {
        	worklistNo: worklistNo,
        	worklistTitle: val
        };
        
        ajax(data);
        
    }); //end of +버튼 클릭
	
    function ajax(data) {
		let $wlTitle = $('#worklist-'+worklistNo+' h5');
		let newWlTitle = data.worklistTitle;
		
    	$.ajax({
        	url: url,
        	data: data,
        	dataType: 'html',
        	type: 'POST',
        	success: data=>{
        		console.log(data);
        		
        		if(data.result!=0){
        			$wlTitle.text(newWlTitle);
        			
        			//되돌리기
        			$(wlInner).show();
        			$(updateTitleWrapper).hide();
        			$(input).val("");
        		}
        		else{
        			alert("업무리스트 제목 수정에 실패했습니다 :(");
        		}
        	},
        	error: (x,s,e) => {
				console.log(x,s,e);
			}
        }); 
    }
}

//업무리스트 삭제하기
function deleteWorklist(){
	let modal = document.querySelector("#modal-worklist-remove");
	let delTitle = document.querySelector("#modal-del-title");
	let btnDel = document.querySelector("#btn-removeWorklist");
	let title;
	let worklistNo;
	
	//업무리스트 x버튼 클릭
	$(document).on('click', '.btn-removeWorklist-modal', (e)=>{
		let btnX;		
		if(e.target.tagName==='I') btnX = e.target.parentNode;	
		else btnX = e.target;
		
		let val = btnX.value;
		let valArr = val.split(',');
		title = valArr[1];
		worklistNo = valArr[0];
		
		//모달창에 업무리스트 정보 뿌리기
		$(".modal-del-target").text("업무리스트");
		$(delTitle).text(title); //업무리스트 타이틀 
		$(btnDel).val('worklist-'+worklistNo); //업무리스트 번호  
	});
	
	
	//삭제버튼 클릭시
	btnDel.addEventListener('click', e=>{
		let val = e.target.value
		let worklistNo = val.split('-')[1]*1;
		let delwl = document.querySelector("#worklist-"+worklistNo);
		
		//업무 삭제와 구분하기
		if(val.split('-')[0] == 'worklist'){
			$.ajax({
	        	url: contextPath+'/project/deleteWorklist.do',
	        	data: {
	        		worklistNo: worklistNo,
	        		worklistTitle: $(delTitle).text()
	        	},
	        	dataType: 'json',
	        	type: 'POST',
	        	success: data=>{
	        		//삭제 성공시 모달창 닫기
	        		if(data.result===1){
	        			$(modal).modal('hide');
	        			
		        		//해당 요소 지우기
		        		delwl.remove();
	        		}
	        	},
	        	error: (x,s,e) => {
					console.log(x,s,e);
				}
	        }); 
		} 
		
	}); //end of btnDel click 
}

//새 업무 만들기
function addWork(info){
	let $btnAddArr = $('.btn-addWork').not('#btn-addWorklist');
    let chkHtml = '<i class="fas fa-check"></i>'; //체크 아이콘 
	
	let addTag;
	let addDateArr = [];
	let addMemberArr = [];
	
	let wlSection;
	let workTitle;
	let btnSubmit;
	let addWorkWrapper;
	let btnRWrapper; 
	let dateWrapper
	
	let worklistNo;
	let btnCancel;
	
	//업무추가 +버튼 클릭
	$(document).on('click', '.btn-addWork:not(#btn-addWorklist)', (e)=>{
		let btnPlus;		
		if(e.target.tagName==='I') btnPlus = e.target.parentNode;	
		else btnPlus = e.target;
		
		worklistNo = btnPlus.value*1;
    	btnCancel = document.querySelector('#worklist-'+worklistNo+' .btn-addWork-cancel');
    	
		wlSection = document.querySelector('#worklist-'+worklistNo);
		workTitle = document.querySelector('#worklist-'+worklistNo+' textarea[name=workTitle]');
    	btnSubmit = document.querySelector('#worklist-'+worklistNo+' .btn-addWork-submit');
   		addWorkWrapper = document.querySelector('#worklist-'+worklistNo+' .addWork-wrapper');
   		btnRWrapper = document.querySelector('#worklist-'+worklistNo+' .addWork-btnRight'); 
		dateWrapper = document.querySelector('#worklist-'+worklistNo+' .add-date'); 
   		
   		//설정 버튼: 멤버, 태그, 날짜 
   		let btnAddMem = document.querySelector('#worklist-'+worklistNo+' .btn-addWorkMember');
   		let btnAddTag = document.querySelector('#worklist-'+worklistNo+' .btn-addWorkTag');
   		let btnAddDate = document.querySelector('#worklist-'+worklistNo+' .btn-addWorkDate'); 
   		$(btnAddDate).daterangepicker();//날짜 설정
   		let btnCancelDate;
   		
   		let memTagArr = document.querySelectorAll('#worklist-'+worklistNo+' .drop-memTag');
		let workTagArr = document.querySelectorAll('#worklist-'+worklistNo+' .drop-workTag');
   		let badgeAddMem = document.querySelector('#worklist-'+worklistNo+' .addMem-badge');
   		let badgeAddTag = document.querySelector('#worklist-'+worklistNo+' .addTag-badge');
   		let colorArr = ['badge-danger', 'badge-primary', 'badge-warning'];
		
		//입력창 열기
		$('.addWork-wrapper').removeClass('show');
		$(addWorkWrapper).addClass("show");
		$(workTitle).focus();
		
		
		//멤버버튼 클릭
		memTagArr.forEach((obj, idx)=>{
			obj.addEventListener('click', e=>{
				let className = obj.className;
				let classArr = className.split(" ");
				let memberId = classArr[2];
				
				let idx = addMemberArr.indexOf(memberId);
				let $hasCheck = $(obj).find('.media-body'); //체크아이콘 들어갈 태그
				let cnt = $(badgeAddMem).text()*1; //선택된 멤버 카운트
				
				//addMemberArr에 선택한 memberId 담기
				//배열에 아이디가 존재하지 않는 경우
				if(idx === -1) {
					$(obj).addClass('checked');
					$hasCheck.append(chkHtml);
					addMemberArr.push(memberId);
					cnt++;
					$(badgeAddMem).text(cnt);
				}
				//배열에 이미 존재하는 경우
				else {
					$(obj).removeClass('checked');
					let $check = $hasCheck.find('.fa-check'); 
					$check.remove();
					addMemberArr.splice(idx, 1);
					cnt--;
					if(cnt===0)
						$(badgeAddMem).text("");
					else
						$(badgeAddMem).text(cnt);
						
				}
			}); 
			
		}); //end of 멤버태그 클릭
		
		
		//업무상태태그 클릭
		workTagArr.forEach((obj, idx)=>{
			obj.addEventListener('click', e=>{
				let $this = $(obj);
				let $check = $('.drop-workTag .fa-check');
				let strIdx = obj.className.indexOf('W');
				let status = obj.className.substr(strIdx, 3);
				let color;
				
				if(status==='WT1') color = 'badge-danger';
				else if(status==='WT2') color = 'badge-primary';
				else color = 'badge-warning';
				
				//이미 선택된 태그가 아닌 경우에는 체크
				if(status!==addTag){
					addTag = "";
					addTag = status;
					$check.remove(); //다른 태그 체크 아이콘 지우기
					$this.append(chkHtml); //체크 아이콘 추가 
					$(badgeAddTag).text(1);
					
					for(let i in colorArr){
						let c = colorArr[i];
						if($(badgeAddTag).hasClass(c))
							$(badgeAddTag).removeClass(c);
					}
					
					$(badgeAddTag).addClass(color);
				}
				//이미 선택된 태그는 체크 해제
				else{
					addTag = "";
					$this.find('.fa-check').remove();
					$(badgeAddTag).text("");
					$(badgeAddTag).removeClass(color);
					
				}
			});
		}); //end of 업무상태태그 클릭
		
		
		//날짜버튼 클릭
		btnAddDate.addEventListener('click', e=>{
			let dPicker = document.querySelector('.daterangepicker');
			dPicker.style.display = 'block';
			
			//데이트피커 요소들
			let $btnApply = $(dPicker).find('.applyBtn');
			let $btnCancel = $(dPicker).find('.cancelBtn');
			
			
			//취소버튼 클릭 시
			$btnCancel.on('click', ()=>{
				dPicker.style.display = 'none';
				$('.daterangepicker').remove();
			});
			
			//적용버튼 클릭 시
			$btnApply.on('click', ()=>{
				dPicker.style.display = 'none';
				$(dPicker).find('.active').removeClass().addClass('available');
				$(dPicker).find('.start-date').removeClass().addClass('available');
				$(dPicker).find('.end-date').removeClass().addClass('available');
				$(dPicker).find('.in-range').removeClass().addClass('available');
				
				//날짜 뽑아내기
				let selectedVal = $(dPicker).find('.drp-selected').text();
				let startArr = selectedVal.split(' - ')[0].split('/');
				let endArr = selectedVal.split(' - ')[1].split('/');
				
				let startDate = startArr[0]+"월 "+startArr[1]+"일"; //html용
				let endDate = endArr[0]+"월 "+endArr[1]+"일";
				
				let startSql = startArr[2]+"-"+startArr[0]+"-"+startArr[1]; //db용
				let endSql = endArr[2]+"-"+endArr[0]+"-"+endArr[1];
				
				//업무 시작일 유효성 검사
				let pStart = '${project.projectStartDate}'.split('-');
				if(startArr[2]*1 < pStart[0]*1 || startArr[0]*1 < pStart[1]*1 || startArr[1]*1 < pStart[2]*1){
					alert("업무 시작일은 프로젝트 시작일보다 빠를 수 없습니다 :(");
					return;
				}
				
				
				addDateArr.length = 0;
				let btnHtml; //추가될 버튼 요소
				//시작일과 마감일이 같은 경우 시작일만 적용
				if(startSql===endSql){
					btnHtml = '<button type="button" class="btn-cancelDate">'+startDate+'<i class="fas fa-times"></i></button>';
					addDateArr.push(endSql);
				}
				else{
					btnHtml = '<button type="button" class="btn-cancelDate">'+startDate+' - '+endDate+'<i class="fas fa-times"></i></button>';
					addDateArr.push(startSql);
					addDateArr.push(endSql);
				}
				
				//데이트피커버튼 지우고 선택한 날짜버튼 추가 
				$(btnAddDate).remove();
				$(dateWrapper).html(btnHtml);
				//취소,만들기버튼 css 수정
				$(btnRWrapper).css('display', 'block').css('float', 'none').css('margin-bottom', '.3rem').css('text-align', 'right');
				
				btnCancelDate = document.querySelector('#worklist-'+worklistNo+' .btn-cancelDate'); 
				
				//날짜 지우기
				$(btnCancelDate).on('click', ()=>{
					addDateArr.length = 0; //배열 초기화
					$(btnCancelDate).remove();
					$(dateWrapper).html(btnAddDate);
					$(btnRWrapper).css('display', 'inline-block').css('float', 'right');
				});
				
			}); //end of click $btnApply
		}); //end of 날짜버튼 클릭
		
		
		//취소버튼 클릭
		btnCancel.addEventListener('click', e=>{
			let check = document.querySelectorAll('#worklist-'+worklistNo+' .fa-check');
			$(check).remove();
			
			$(workTitle).val("");
			
			addMemberArr.length = 0; 
			$(badgeAddMem).text("");
			
			addTag = "";
			$(badgeAddTag).text("");
			for(let i in colorArr){
				let c = colorArr[i];
				if($(badgeAddTag).hasClass(c))
					$(badgeAddTag).removeClass(c);
			}
			
			addDateArr.length = 0; 
			$(btnCancelDate).remove();
			$(dateWrapper).append(btnAddDate);
			$(btnRWrapper).css('display', 'inline-block').css('float', 'right');
			$('.daterangepicker').remove();
			
			$(addWorkWrapper).removeClass("show");
			return;
		}); 
		
	}); //end of 업무추가 +버튼 클릭
	
	//엔터키 입력
	$(document).on('keydown', 'textarea[name=workTitle]', (e)=>{
		if(e.which==13){
			let title = $(workTitle).val().trim();
			
			//유효성 검사
			if(title===""){
				alert("새 업무의 이름을 입력해 주세요!");
				return;
			}
				
			let data = {
					isProjectManager: info.isProjectManager,
					projectNo: info.projectNo,
					worklistNo: worklistNo,
					workTitle: title,
					workChargedMember: addMemberArr,
					workTag: addTag,
					workDate: addDateArr
			}
			
			ajax(data);
		}
	});
	
	//만들기버튼 클릭
	$(document).on('click', '.btn-addWork-submit', (e)=>{
		let title = $(workTitle).val().trim();
		
		//유효성 검사
		if(title===""){
			alert("새 업무의 이름을 입력해 주세요!");
			return;
		}
			
		let data = {
				isProjectManager: info.isProjectManager,
				projectNo: info.projectNo,
				worklistNo: worklistNo,
				workTitle: title,
				workChargedMember: addMemberArr,
				workTag: addTag,
				workDate: addDateArr
		}
		
		ajax(data);
		
	}) //end of 만들기 버튼클릭
	
	function ajax(data) {
		let wlSection = document.querySelector('#worklist-'+worklistNo);
		
		$.ajax({
			url: contextPath+'/project/insertWork.do',
			data: data,
			dataType: 'html',
			type: 'POST',
			success: data=>{
				if(data!=null){
					$(wlSection).html(data);
					
					addTag = "";
					addMemberArr.length = 0;
					addDateArr.length = 0;
					$('.daterangepicker').remove();
				}
				else{
					alert("새 업무 만들기에 실패했습니다 :(");
				}
			},
			error: (x,s,e) => {
				console.log(x,s,e);
			}
		}); 
	}
}

//업무 삭제하기
function deleteWork(info){
	let menu = document.querySelector("#menu-delWork");
	let workDelBtn = document.querySelector("#dropdown-work-remove")
	let modal = document.querySelector("#modal-worklist-remove");
	let delTitle = document.querySelector("#modal-del-title");
	let btnDel = document.querySelector("#btn-removeWorklist");
	
	let work; 
	
	//업무 우클릭시 삭제 드롭다운 메뉴 열기
	$(document).on('contextmenu', '.work-item', e=>{
		e.preventDefault();
		
		let x = e.pageX + 'px';
		let y = (e.pageY-100) + 'px';
		
		menu.style.display = 'block';
		menu.style.left = x;
		menu.style.top = y;	
		
		//내가 클릭한 업무
		work = e.currentTarget; 
		$("#copyWorkNo").val(work.id*1);
	});

	document.addEventListener('click', ()=>{
		menu.style.display = 'none';
	});
	
	if(workDelBtn == null) return;
	
	let workNo;
	let title;
	let cntChk;
	let cntComment;
	let cntFile;
	
	//업무 삭제 클릭: 모달에 정보 뿌리기 
	workDelBtn.addEventListener('click', (e)=>{
		workNo = work.id*1;
		title = $('section#'+workNo+".work-item").find('h6').text();
		cntChk = $(work).find('.chklt-cnt-total').text()*1;
		cntComment = $(work).find('.comment-cnt').text()*1;
		cntFile = $(work).find('.attach-cnt').text()*1;
		
		$(".modal-del-target").text("업무");
		$(delTitle).text(title); //업무 타이틀 
		$(btnDel).val('work');
	});
	
	//삭제버튼 클릭시
	btnDel.addEventListener('click', e=>{
		//업무리스트와 구분
		if(btnDel.value==='work'){
			let title = e.target.value;
			let wlSection = work.parentNode.parentNode.parentNode;
	 		let worklistNo = wlSection.id.split('-')[1]*1; 
	 		
			let data = {
				projectNo: info.projectNo,
				worklistNo: worklistNo,
				workNo: workNo,
				workTitle: $(delTitle).text().trim(),
				cntChk: cntChk,
				cntComment: cntComment,
				cntFile: cntFile,
				isProjectManager: info.isProjectManager
			}
			
			//업무리스트와 구분
			if(title==='work'){
				$.ajax({
		        	url: '${pageContext.request.contextPath}/project/deleteWork.do',
		        	data: data,
		        	dataType: 'html',
		        	type: 'POST',
		        	success: data=>{
		        		if(data!=null){
			        		$(wlSection).html(data);
			        		$(modal).modal('hide');
		        		}
		        		else{
							alert("업무 삭제에 실패했습니다 :(");	        			
		        		}
		        	},
		        	error: (x,s,e) => {
						console.log(x,s,e);
					}
		        }); 
			} 
		}
	}); //end of btnDel click 
}

//업무 완료하기
function workComplete(info){
	$(document).on('click', '.btn-checkWork', (e)=>{
		e.stopPropagation(); 
		
		let btnChk;		
		if(e.target.tagName==='I') btnChk = e.target.parentNode;	
		else btnChk = e.target;
		
		let workNo = btnChk.value;
		let $workSection = $(btnChk.parentNode.parentNode.parentNode);
		let workChargedMemIdArr = $workSection.find('.hiddenWorkChargedMemId').val().split(',');
		let isValid = false;
		
		
		//1.유효성 검사
		//1-1.업무 배정된 멤버가 있는 경우
		if(workChargedMemIdArr[0]!==""){
			workChargedMemIdArr.forEach(id=>{
				if(info.memberId===id) isValid = true;
			});
			if(info.memberId==='admin' || info.isProjectManager) 
				isValid = true;
		}
		//1-1.업무 배정된 멤버가 없는 경우
		else{
			if(info.memberId==='admin' || info.isProjectManager) 
				isValid = true;
		}
		
		//2.업무 완료 여부
		let yn = "N";
		if(isValid){
			//완료된 업무인 경우 
			if($workSection.hasClass('completed')) yn = "Y";
			
			let $wlSection = $workSection.parent().parent().parent();
			let worklistNo = $wlSection.attr('id').split('-')[1];
			
			let data = {
				isProjectManager: info.isProjectManager,
				completeYn: yn,
				projectNo: info.projectNo,
				worklistNo: worklistNo*1,
				workNo: workNo*1
			};
			
			$.ajax({
				url: contextPath+'/project/updateWorkCompleteYn.do',
				data: data,
				dataTyp: 'html',
				type: 'POST',
				success: data=>{
					if(data!=null){
						$wlSection.html(data);
					}
					else{
						if(yn==='N')
							alert("업무 완료에 실패했습니다 :(");
						else
							alert("업무완료 해제에 실패했습니다 :(");
					}
				},
				error: (x,s,e)=>{
					console.log(x,s,e);
				}
			});
		}
		else{
			alert(info.memberName+"님은 이 업무에 권한이 없습니다 :( ");
		}//end of if	
		
	}); //end of 업무완료버튼 클릭
}

//체크리스트 체크
function checklist(info){
    $(document).on('click', '.btn-check:not(.btn-checkWork)', (e)=>{
    	e.stopPropagation(); 
    	
    	let btnChk;		
		if(e.target.tagName==='I') btnChk = e.target.parentNode;	
		else btnChk = e.target;
		
		let val = btnChk.value;
		let workNo = val.split(",")[0];
		let chkNo = val.split(",")[1];
		
		let $workSection = $("section#"+workNo+".work-item");
		let $tr = $(btnChk.parentNode.parentNode);
		let $tdChecklist = $(btnChk.parentNode.nextSibling.nextSibling);
		let $icoChk = $(btnChk.firstChild);
		let $spanCntComp = $workSection.find('.chklt-cnt-completed');
		
		let hiddenChargedMemIdVal = $workSection.find('.hiddenWorkChargedMemId').val();
		let workChargedMemIdArr = null;
		
		if($workSection.find('.hiddenWorkChargedMemId').val() != null && $workSection.find('.hiddenWorkChargedMemId').val() !=''){
			workChargedMemIdArr = $workSection.find('.hiddenWorkChargedMemId').val().split(',');
		}
		if($tdChecklist.length==0){
			$tdChecklist = $(btnChk.parentNode.nextSibling);
		}
		
		let chkChargedMemId = btnChk.nextSibling.nextSibling.value;
		let isValid = false;
		
		//1.유효성 검사
		//체크리스트에 배정된 멤버가 있다면
		if(chkChargedMemId!=""){
			//체크리스트에 배정된 멤버, 프로젝트 팀장, admin만 클릭 가능
			if(info.memberId===chkChargedMemId || info.isProjectManager || info.memberId==='admin'){
				isValid = true;
			}
			else{
				alert(info.memberName+"님은 이 체크리스트에 대한 권한이 없습니다 :(");
				return;
			}
		}
		//체크리스트에 배정된 멤버가 없다면, 업무에 배정된 멤버인지
		else{
			let chkbool = false;
			if(workChargedMemIdArr !=null){
				workChargedMemIdArr.forEach(id=>{
					if(info.memberId===id) chkbool = true;
				});
			}
			
			if(chkbool===true || info.isProjectManager || info.memberId==='admin'){
				isValid = true;
			}
			else{
				alert(info.memberName+"님은 이 체크리스트에 대한 권한이 없습니다 :(");
				return;
			}
		}
		
		
		//2.체크리스트 완료 여부
		let yn = "N";
		if(isValid){
			//완료된 체크리스트인 경우 
			if($tr.hasClass('completed')) yn = "Y";
			
			let data = {
				completeYn: yn,
				checklistNo: chkNo
			};
			
			$.ajax({
				url: contextPath+'/project/updateChklistCompleteYn.do',
				data: data,
				dataType: 'json',
				type: 'POST',
				success: data=>{
					//업데이트 성공한 경우
					if(data.result===1){
						let cntComp = $spanCntComp.text()*1;
    					$tr.toggleClass('completed');
    					
    					//체크리스트 완료한 경우
    					if($tr.hasClass('completed')){
    				        //체크박스 변경
    				        $icoChk.removeClass('far fa-square');
    				        $icoChk.addClass('fas fa-check-square');

    				        //리스트에 줄 긋기
    				        $tdChecklist.css('text-decoration', 'line-through');
    				        
    				        //체크리스트 완료 카운트 변경
    				        cntComp += 1;
    				        $spanCntComp.text(cntComp);
    				    }
    					//체크리스트 완료 해제한 경우
    				    else{
   				           //체크박스 변경
   				           $icoChk.removeClass('fas fa-check-square');
   				           $icoChk.addClass('far fa-square');

   				           //리스트에 줄 해제
   				           $tdChecklist.css('text-decoration', 'none');
   				           
	   				      	//체크리스트 완료 카운트 변경
	   				      	cntComp -= 1;
	   				        $spanCntComp.text(cntComp);
    				    }
					}
				},
				error: (x,s,e) => {
						console.log(x,s,e);
				}
			});
		} //end of if 
		
    }); //end of $(document).on('click', '.btn-check'
}

//완료된 업무 펼쳐보기
function openCompletedWork(){
	let $btnShow = $(".btn-showCompletedWork");
	
	$(document).on('click', '.btn-showCompletedWork', e=>{
		let btnShow;		
		if(e.target.tagName==='I') btnShow = e.target.parentNode;	
		else btnShow = e.target;
		
		let worklistNo = btnShow.value;
		let wlSection = document.querySelector("#worklist-"+worklistNo);
		let completed = $(wlSection).find('.workCompleted-wrapper');
		
		$(completed).toggleClass('hide');
	});
}