
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

/*//업무리스트 제목 수정하기
function updateWorklistTitle(){
	let worklistNo;
	let wlTitle;
	let $wlInner;
	let $updateTitleWrapper;
	let input;
	let $btnUpdate;
	let url = '${pageContext.request.contextPath}/project/updateWorklistTitle.do';
	
	$(document).on('click', '.btn-showUpdateFrm', (e)=>{
		let btnShow;		
		if(e.target.tagName==='I') btnShow = e.target.parentNode;	
		else btnShow = e.target;
		
		worklistNo = btnShow.value*1;
		wlTitle = $('#worklist-'+worklistNo+' h5').text();
		$wlInner = $('#worklist-'+worklistNo+' .wlTitle-inner');
		$updateTitleWrapper = $('#worklist-'+worklistNo+' .update-wlTitle-wrapper');
		input = document.querySelector("#worklist-"+worklistNo+' input[name=newWorklistTitle]');
		$btnUpdate = $('#worklist-'+worklistNo+' .btn-updateWlTitle');
		
		//수정폼 보이기 		
		$wlInner.hide();
		$updateTitleWrapper.show();
		$(input).val(wlTitle);
		$(input).focus();
		
		console.log(input);
		
		//엔터키 입력시 제목 수정
	    $(input).on('keydown', key=>{
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
	    $btnUpdate.on('click', ()=>{
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
		
		
		//x버튼 클릭시 되돌리기
	    $(document).on('click', '#worklist-'+worklistNo+' .btn-cancel-updateWlTitle', (e)=>{
	    	$wlInner.show();
			$updateTitleWrapper.hide();
			$(input).val("");
	    });
	    
		function ajax(data) {
			let $wlTitle = $('#worklist-'+worklistNo+' h5');
			let newWlTitle = data.worklistTitle;
			
	    	$.ajax({
	        	url: url,
	        	data: data,
	        	dataType: 'html',
	        	type: 'POST',
	        	success: data=>{
	        		if(data.result!=0){
	        			$wlTitle.text(newWlTitle);
	        			
	        			//되돌리기
	        			$wlInner.show();
	        			$updateTitleWrapper.hide();
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
	}); //end of click .btn-showUpdateFrm
	
}*/

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