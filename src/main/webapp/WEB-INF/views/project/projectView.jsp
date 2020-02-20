<%@page import="com.kh.workground.project.model.vo.Project"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.kh.workground.member.model.vo.Member"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />

<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<link rel="stylesheet" property="stylesheet" href="${pageContext.request.contextPath}/resources/css/hyemin.css">
<script src="${pageContext.request.contextPath}/resources/js/projectView.js"></script>

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


<script>
$(()=>{
	sidebarActive(); //사이드바 활성화
	
	if('${project.privateYn}'==='N')
		projectStar(); //프로젝트 별 해제/등록
	searchWork(); //업무검색
	
    addWorklist(); //새 업무리스트 만들기
    deleteWorklist(); //업무리스트 삭제하기
    
    addWork(); //새 업무 만들기
    deleteWork(); //업무 삭제하기

    workComplete(); //업무 완료하기
    checklist(); //체크리스트 체크
    openCompletedWork(); //완료된 업무 펼쳐보기
    
    tabActive(); //서브헤더 탭 활성화
    goTabMenu(); //서브헤더 탭 링크 이동
    
    setting(); //설정창
    updateDesc(); //업무, 프로젝트 설명 수정
    updateTitle(); //업무, 프로젝트 제목 수정
});

//multiselect.js파일에서 사용할 contextPath 전역변수
var contextPath = "${pageContext.request.contextPath}";

//프로젝트 별 해제/등록
function projectStar(){
    let btnStar = document.querySelector("#btn-star .fa-star");
    let projectNo = document.querySelector("#project-name #hiddenProjectNo").value;
    
    btnStar.addEventListener('click', (e)=>{
        let $this = $(e.target);

        $.ajax({
        	url: '${pageContext.request.contextPath}/project/projectStarCheck.do',
        	data: {memberId: '${memberLoggedIn.memberId}',
        		   projectNo: projectNo},
        	dataType: 'json',
        	type: 'POST',
        	success: data=>{
        		console.log(data);
        		
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
function searchWork(){
	
	$(document).on('click', '#btn-searchWork', (e)=>{
		let wrapper = document.querySelector(".container-fluid");
		let frm = document.querySelector("#workSearchFrm");
		let input = document.querySelector("input[name=searchWorkKeyword]");
		let btn = document.querySelector("#btn-searchWork");
		let keyword = $(input).val().trim();

		//유효성 검사
		if(keyword==""){
			alert("검색 키워드를 입력해 주세요!");
		}
		
		let data = {
				projectNo: ${project.projectNo},
				keyword: keyword,
				memberId: '${memberLoggedIn.memberId}'
		};
		$.ajax({
			url: '${pageContext.request.contextPath}/project/searchWork',
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
		
	});
}

//새 업무리스트 만들기
function addWorklist(){
    let addWklt = document.querySelector("#add-wklt-wrapper");
    let addWkltFrm = document.querySelector("#add-wkltfrm-wrapper");
    
    let inputTitle = document.querySelector("input[name=worklistTitle]");
    let frm = document.querySelector("#addWorklistFrm");
    
    let btnAdd = document.querySelector("#btn-addWorklist");
    let btnCancel = document.querySelector("#btn-cancel-addWorklist");
	
    //프로젝트 팀원들에게는 업무리스트 추가가 보이지 않음!
    if(addWklt!==null){
	    //업무리스트 추가 클릭시 입력폼 보이기
	    addWklt.addEventListener('click', ()=>{
	        $(addWklt).hide();
	        $(addWkltFrm).show();
	        $(inputTitle).focus();
	    });
    }
    //x버튼 클릭시 다시 업무리스트 추가 보이기
    btnCancel.addEventListener('click', ()=>{
        $(addWkltFrm).hide();
        $(inputTitle).val("");
        $(addWklt).show();
    });

    //+버튼 클릭시 업무리스트 추가
    btnAdd.addEventListener('click', ()=>{
        let title = document.querySelector("input[name=worklistTitle]");
        
        //유효성 검사
        if($(title).val().trim()==""){
        	alert("추가할 업무리스트의 이름을 입력해 주세요!");
        	return;
        }
        
        let data = {
        		projectNo: ${project.projectNo},
        		projectManager: '${projectManager}',
        		worklistTitle: $(title).val().trim()
        };
        
        console.log(data);
        
        $.ajax({
        	url: '${pageContext.request.contextPath}/project/addWorklist.do',
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
    }); //end of +버튼 클릭
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
	        	url: '${pageContext.request.contextPath}/project/deleteWorklist.do',
	        	data: {worklistNo: worklistNo},
	        	dataType: 'json',
	        	type: 'POST',
	        	success: data=>{
	        		console.log(data);
	        		
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
function addWork(){
	let $btnAddArr = $('.btn-addWork').not('#btn-addWorklist');
    let chkHtml = '<i class="fas fa-check"></i>'; //체크 아이콘 
	
	let addTag;
	let addDateArr = [];
	let addMemberArr = [];
	
	let worklistNo;
	let btnCancel;
	
	//업무추가 +버튼 클릭
	$(document).on('click', '.btn-addWork:not(#btn-addWorklist)', (e)=>{
		let btnPlus;		
		if(e.target.tagName==='I') btnPlus = e.target.parentNode;	
		else btnPlus = e.target;
		
		worklistNo = btnPlus.value*1;
    	btnCancel = document.querySelector('#worklist-'+worklistNo+' .btn-addWork-cancel');
    	
    	let btnSubmit = document.querySelector('#worklist-'+worklistNo+' .btn-addWork-submit');
   		let addWorkWrapper = document.querySelector('#worklist-'+worklistNo+' .addWork-wrapper');
   		let btnRWrapper = document.querySelector('#worklist-'+worklistNo+' .addWork-btnRight'); 
		let dateWrapper = document.querySelector('#worklist-'+worklistNo+' .add-date'); 
   		let workTitle = document.querySelector('#worklist-'+worklistNo+' textarea[name=workTitle]');
   		
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
				console.log(addDateArr); //취소하고 만드는 만큼 반복됨
				
				//날짜 지우기
				$(btnCancelDate).on('click', ()=>{
					addDateArr.length = 0; //배열 초기화
					$(btnCancelDate).remove();
					$(dateWrapper).html(btnAddDate);
					$(btnRWrapper).css('display', 'inline-block').css('float', 'right');
				});
				
			}); //end of click $btnApply
		}); //end of 날짜버튼 클릭
		
		
		//만들기버튼 클릭
		btnSubmit.addEventListener('click', e=>{
			let workTitle = document.querySelector('#worklist-'+worklistNo+' textarea[name=workTitle]');
			let wlSection = document.querySelector('#worklist-'+worklistNo);
			
			//유효성 검사
			if($(workTitle).val().trim()==""){
				alert("새 업무의 이름을 입력해 주세요!");
				return;
			}
				
			let data = {
					projectManager: '${projectManager}',
					projectNo: ${project.projectNo},
					worklistNo: worklistNo,
					workTitle: $(workTitle).val().trim(),
					workChargedMember: addMemberArr,
					workTag: addTag,
					workDate: addDateArr
			}
			console.log(data);
			
			$.ajax({
				url: '${pageContext.request.contextPath}/project/insertWork.do',
				data: data,
				dataType: 'html',
				type: 'POST',
				success: data=>{
					if(data!=null){
						$(wlSection).html(data);
						
						addTag = "";
						addMemberArr.length = 0;
						addDateArr.length = 0;
					}
					else{
						alert("새 업무 만들기에 실패했습니다 :(");
					}
				},
				error: (x,s,e) => {
					console.log(x,s,e);
				}
			}); 
		}) //end of 만들기 버튼클릭
		
		
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
			
			$(addWorkWrapper).removeClass("show");
			
		}); 
		
	}); //end of 업무추가 +버튼 클릭
	
}

//업무 삭제하기
function deleteWork(){
	let loggedInMemberId = '${memberLoggedIn.memberId}';
	let projectManager = '${projectManager}';
	
	let menu = document.querySelector("#menu-delWork");
	let modal = document.querySelector("#modal-worklist-remove");
	let delTitle = document.querySelector("#modal-del-title");
	let btnDel = document.querySelector("#btn-removeWorklist");
	
	let work; 
	
	//업무 우클릭시 삭제 드롭다운 메뉴 열기: 관리자, 프로젝트팀장만 가능
	if(loggedInMemberId=='admin' || loggedInMemberId==projectManager){
		$(document).on('contextmenu', '.work-item', e=>{
			e.preventDefault();
			
			let x = e.pageX + 'px';
			let y = (e.pageY-100) + 'px';
			
			menu.style.display = 'block';
			menu.style.left = x;
			menu.style.top = y;	
			
			//내가 클릭한 업무
			work = e.currentTarget; 
		});
	}
	
	let workNo;
	let title;
	let cntChk;
	let cntComment;
	let cntFile;
	
	//업무 삭제 클릭: 모달에 정보 뿌리기 
	menu.addEventListener('click', (e)=>{
		workNo = work.id*1;
		title = $('#'+workNo).find('h6').text();
		cntChk = $(work).find('.chklt-cnt-total').text()*1;
		cntComment = $(work).find('.comment-cnt').text()*1;
		cntFile = $(work).find('.attach-cnt').text()*1;
		
		$(".modal-del-target").text("업무");
		$(delTitle).text(title); //업무 타이틀 
		$(btnDel).val('work');
	});
	
	//삭제버튼 클릭시
	btnDel.addEventListener('click', e=>{
		let title = e.target.value;
		let wlSection = work.parentNode.parentNode.parentNode;
 		let worklistNo = wlSection.id.split('-')[1]*1; 
 		
		let data = {
			projectNo: ${project.projectNo},
			worklistNo: worklistNo,
			workNo: workNo,
			cntChk: cntChk,
			cntComment: cntComment,
			cntFile: cntFile,
			projectManager: '${projectManager}'
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
		
	}); //end of btnDel click 
	
	document.addEventListener('click', ()=>{
		menu.style.display = 'none';
	});
}

//업무 완료하기
function workComplete(){
	let loggedInMemberId = '${memberLoggedIn.memberId}';
	let loggedInMemberName = '${memberLoggedIn.memberName}';
	let projectManager = '${projectManager}';
	
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
				if(loggedInMemberId===id) isValid = true;
			});
			if(loggedInMemberId==='admin' || loggedInMemberId===projectManager) 
				isValid = true;
		}
		//1-1.업무 배정된 멤버가 없는 경우
		else{
			if(loggedInMemberId==='admin' || loggedInMemberId===projectManager) 
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
				projectManager: projectManager,
				completeYn: yn,
				projectNo: ${project.projectNo},
				worklistNo: worklistNo*1,
				workNo: workNo*1
			};
			
			$.ajax({
				url: '${pageContext.request.contextPath}/project/updateWorkCompleteYn.do',
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
			alert(loggedInMemberName+"님은 이 업무에 권한이 없습니다 :( ");
		}//end of if	
		
	}); //end of 업무완료버튼 클릭
}

//체크리스트 체크
function checklist(){
	let loggedInMemberId = '${memberLoggedIn.memberId}';
	let loggedInMemberName = '${memberLoggedIn.memberName}';
	let projectManager = '${projectManager}';

    $(document).on('click', '.btn-check:not(.btn-checkWork)', (e)=>{
    	e.stopPropagation(); 
    	let btnChk;		
		if(e.target.tagName==='I') btnChk = e.target.parentNode;	
		else btnChk = e.target;
		
		let val = btnChk.value;
		let workNo = val.split(",")[0];
		let chkNo = val.split(",")[1];
		
		let $workSection = $(btnChk.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode);
		let $tr = $(btnChk.parentNode.parentNode);
		let $tdChecklist = $(btnChk.parentNode.nextSibling.nextSibling);
		let $icoChk = $(btnChk.firstChild);
		let $spanCntComp = $workSection.find('.chklt-cnt-completed');
		
		let hiddenChargedMemIdVal = $workSection.find('.hiddenWorkChargedMemId').val();
		let workChargedMemIdArr = null;
		
		console.log("$workSection="+$workSection);
		console.log("input:hiddenWorkChargedMemId="+$workSection.find('.hiddenWorkChargedMemId'));
		console.log("hiddenChargedMemIdVal="+hiddenChargedMemIdVal);
		
		if(hiddenChargedMemIdVal !==''){
			workChargedMemIdArr = hiddenChargedMemIdVal.split(',');
		}
		console.log("workChargedMemIdArr="+workChargedMemIdArr);
		
		console.log($tdChecklist);		
		/* if($tdChecklist.length==0){
			$tdChecklist = $(btnChk.parentNode.nextSibling);
		} */
		
		let chkChargedMemId = btnChk.nextSibling.nextSibling.value;
		let isValid = false;
		
		console.log("chkChargedMemId="+chkChargedMemId);
		
		//1.유효성 검사
		//체크리스트에 배정된 멤버가 있다면
		if(chkChargedMemId!=""){
			//체크리스트에 배정된 멤버, 프로젝트 팀장, admin만 클릭 가능
			if(loggedInMemberId===chkChargedMemId || loggedInMemberId===projectManager || loggedInMemberId==='admin'){
				console.log("체크리스트 배정된 멤버 있고 그게 나야");
				isValid = true;
			}
			else{
				console.log("체크리스트 배정된 멤버 있는데 그게 난 아님");
				alert(loggedInMemberName+"님은 이 체크리스트에 대한 권한이 없습니다 :(");
				return;
			}
		}
		//체크리스트에 배정된 멤버가 없다면, 업무에 배정된 멤버인지
		else{
			let chkbool = false;
			if(workChargedMemIdArr !=null){
				workChargedMemIdArr.forEach(id=>{
					if(loggedInMemberId===id) chkbool = true;
				});
			}
			
			if(chkbool===true || loggedInMemberId===projectManager || loggedInMemberId==='admin'){
				console.log("체크리스트 배정된 멤버 없고 업무배정된 멤버는 있는데 그게 나야");
				isValid = true;
			}
			else{
				console.log("체크리스트 배정된 멤버 없고 업무배정된 멤버도 없으니까 난 안돼");
				alert(loggedInMemberName+"님은 이 체크리스트에 대한 권한이 없습니다 :(");
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
				url: '${pageContext.request.contextPath}/project/updateChklistCompleteYn.do',
				data: data,
				dataType: 'json',
				type: 'POST',
				success: data=>{
					console.log(data);	
					
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
function goTabMenu(){
	let contentWrapper = document.querySelector(".content-wrapper");
	let btnWork = document.querySelector("#btn-tab-work");
	let btnTimeline = document.querySelector("#btn-tab-timeline");
	let btnAnalysis = document.querySelector("#btn-tab-analysis");
	let btnAttach = document.querySelector("#btn-tab-attach");
	
	//업무 탭 클릭
	btnWork.addEventListener('click', e=>{
		location.href = "${pageContext.request.contextPath}/project/projectView.do?projectNo=${project.projectNo}";	
	});
	
	//나의 워크패드에서는 타임라인, 분석 보이지 않음
	if('${project.privateYn}'==='N'){
	//타임라인 탭 클릭
	btnTimeline.addEventListener('click', e=>{
		closeSideBar();
		$.ajax({
			url: "${pageContext.request.contextPath}/project/projectView.do?projectNo=${project.projectNo}&tab=timeline",
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
			url: "${pageContext.request.contextPath}/project/projectAnalysis.do?projectNo=${project.projectNo}",
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
	} //end of if
	
	//파일 탭 클릭
	btnAttach.addEventListener('click', e=>{
		closeSideBar();
		$.ajax({
			url: "${pageContext.request.contextPath}/project/projectView.do?projectNo=${project.projectNo}&tab=attach",
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
}

function setting(){
    var $side = $("#setting-sidebar");
    var projectNo = ${project.projectNo}; 
    
    //설정 사이드바 열기
    $('#project-setting-toggle').on('click', function(){
        $.ajax({
			url: "${pageContext.request.contextPath}/project/projectSetting.do",
			type: "get",
			data:{projectNo:projectNo},
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
    /* $(".work-item").on('click', function(){ */
    $(document).on('click', '.work-item', function(){
    	var workNo = $(this).attr('id');
    	
    	//업무리스트 타이틀
        var worklistTitle = $(this).children("#hiddenworklistTitle").val();
    	
        $.ajax({
			url: "${pageContext.request.contextPath}/project/workSetting.do",
			type: "get",
			data:{workNo:workNo, worklistTitle:worklistTitle, projectNo:projectNo},
			dataType: "html",
			success: data => {
				console.log(data);
				
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
    
    //대화 사이드바 열기
    $('#btn-openChatting').on('click', ()=>{
    	$.ajax({
			url: "${pageContext.request.contextPath}/project/projectChatting.do",
			type: "get",
			data: {projectNo:projectNo},
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
  			
  			 url:"${pageContext.request.contextPath}/project/updateDesc.do",
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
 			 url:"${pageContext.request.contextPath}/project/updateTitle.do",
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
//사이드바 닫기
function closeSideBar(){
	var $side = $("#setting-sidebar");
    if($side.hasClass('open')) {
        $side.stop(true).animate({right:'-520px'});
        $side.removeClass('open');
    }
}
</script>		

<!-- Navbar Project -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light navbar-project navbar-projectView">
    <!-- Left navbar links -->
    <ul class="navbar-nav">
    
    <!-- 뒤로가기 -->
    <c:if test="${project.privateYn=='N'}">
    <li id="go-back" class="nav-item text-center">
    </c:if>
    <c:if test="${project.privateYn=='Y'}">
    <li id="go-back" class="nav-item text-center private-y">
    </c:if>
        <a class="nav-link" href="${pageContext.request.contextPath}/project/projectList.do"><i class="fas fa-chevron-left"></i></a>
    </li>
    
    <!-- 프로젝트 중요표시, 이름 -->
    <li id="project-name" class="nav-item">
		<input type="hidden" id="hiddenProjectNo" value="${project.projectNo}"/>
        <c:if test="${project.privateYn=='N'}">
        <button type="button" id="btn-star">
        	<c:if test="${project.projectStarYn=='Y'}">
        	<i class="fas fa-star"></i>
        	</c:if>
        	<c:if test="${project.projectStarYn=='N'}">
        	<i class="far fa-star"></i>
        	</c:if>
        </button>
        </c:if> 
        <span id="header-project-title">${project.projectTitle}</span>
    </li>
    </ul>

    <!-- Middle navbar links -->
    <ul id="navbar-tab" class="navbar-nav ml-auto">
        <li id="tab-work" class="nav-item"><button type="button" id="btn-tab-work">업무</button></li>
        <c:if test="${project.privateYn=='N'}">
        <li id="tab-timeline" class="nav-item"><button type="button" id="btn-tab-timeline">타임라인</button></li>
        <li id="tab-analysis" class="nav-item"><button type="button" id="btn-tab-analysis">분석</button></li>
        </c:if>
        <li id="tab-attachment" class="nav-item"><button type="button" id="btn-tab-attach">파일</button></li>
    </ul>
	
    <!-- Right navbar links -->
    <ul id="viewRightNavbar-wrapper" class="navbar-nav ml-auto">
	<c:if test="${project.privateYn=='N'}">
        <!-- 프로젝트 대화 -->
        <li class="nav-item">
            <button type="button" id="btn-openChatting" class="btn btn-block btn-default btn-xs nav-link">
                <i class="far fa-comments"></i> 프로젝트 대화
            </button>
        </li>
	
        <!-- 프로젝트 멤버 -->
        <li id="nav-member" class="nav-item dropdown">
            <a class="nav-link" data-toggle="dropdown" href="#">
                <i class="far fa-user"></i> ${fn:length(inMemList)}
            </a>
            <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
            <c:forEach items="${inMemList}" var="m">
            <a href="${pageContext.request.contextPath}/member/memberView.do?memberId=${m.memberId}" class="dropdown-item">
                <div class="media">
	                <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile">
	                <div class="media-body">
	                    <p class="memberName">${m.memberName}</p>
	                </div>
                </div>
            </a>
            </c:forEach>
            </div>
        </li>

        <!-- 프로젝트 설정 -->
        <li class="nav-item">
            <button type="button" class="btn btn-block btn-default btn-xs nav-link" id="project-setting-toggle">
            	<i class="fas fa-cog"></i>
            </button>
        </li>
    </c:if>
    </ul>
</nav>
<!-- /.navbar -->

<!-- 오른쪽 프로젝트/업무 설정 사이드 바-->
<aside class="work-setting" id="setting-sidebar" style="display: block;">
</aside>

<!-- Content Wrapper. Contains page content -->
<div id="pjv-content-wrapper" class="content-wrapper projectView-wrapper navbar-light">
    <h2 class="sr-only">프로젝트 일정 상세보기</h2>
    <!-- Main content -->
    <div class="content view">
    <h3 class="sr-only">${project.projectTitle}</h3>
    <div class="container-fluid">
        <h4 class="sr-only">업무</h4>
        
        <!-- SEARCH FORM -->
        <form id="workSearchFrm" class="form-inline">
	        <div class="input-group input-group-sm">
	            <input class="form-control form-control-navbar" name="searchWorkKeyword" type="search" placeholder="업무 검색" aria-label="Search">
	            <div class="input-group-append">
	            <button class="btn btn-navbar" type="button" id="btn-searchWork">
	                <i class="fas fa-search"></i>
	            </button>
	            </div>
	        </div>
        </form>
        
        <div id="wlList-wrapper">
        <!-- 업무리스트 -->
        <c:forEach items="${wlList}" var="wl" varStatus="wlVs">
        <section class="worklist" id="worklist-${wl.worklistNo}">
            <!-- 업무리스트 타이틀 -->
            <div class="worklist-title">
                <h5>${wl.worklistTitle}</h5>
                
                <!-- 업무 생성/업무리스트 삭제: admin, 프로젝트 팀장에게만 보임 -->
                <c:if test="${'admin'==memberLoggedIn.memberId || projectManager==memberLoggedIn.memberId}">
                <div class="worklist-title-btn">
	                <button type="button" class="btn-addWork" value="${wl.worklistNo}"><i class="fas fa-plus"></i></button>
	                <button type="button" class="btn-removeWorklist-modal" value="${wl.worklistNo},${wl.worklistTitle}" data-toggle="modal" data-target="#modal-worklist-remove"><i class="fas fa-times"></i></button>
                </div>
                </c:if>
                
                <!-- 새 업무 만들기 -->
                <div class="addWork-wrapper">
	                <form class="addWorkFrm">
	                    <!-- 업무 타이틀 작성 -->
	                    <textarea name="workTitle" class="addWork-textarea" placeholder="새 업무 만들기"></textarea>
	
	                    <!-- 하단부 버튼 모음 -->
	                    <div class="addWork-btnWrapper">
		                    <!-- 업무 설정 -->
		                    <div class="addWork-btnLeft">
		                    	
		                    	<c:if test="${project.privateYn == 'N'}">
		                        <!-- 업무 멤버 배정 -->
		                        <div class="add-member dropdown">
		                        	<span class="badge navbar-badge addMem-badge"></span>
			                        <button type="button" class="nav-link btn-addWorkMember" data-toggle="dropdown"><i class="fas fa-user-plus"></i></button>
			                        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right" id="test-member-ajax">
			                            <c:forEach items="${inMemList}" var="m">
							            <a href="javascript:void(0)" class="dropdown-item drop-memTag ${m.memberId}">
							                <div class="media">
								                <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile">
								                <div class="media-body">
								                    <p class="memberName">${m.memberName}</p>
								                </div>
							                </div>
							            </a>
							            </c:forEach>
		                        	</div>
		                        </div>
		                        </c:if>
		
		                        <!-- 태그 설정 -->
		                        <div class="add-tag dropdown">
		                        	<span class="badge navbar-badge addTag-badge"></span>
			                        <button type="button" class="nav-link btn-addWorkTag" data-toggle="dropdown"><i class="fas fa-tag"></i></button>
			                        <div class="dropdown-menu dropdown-menu-right">
			                            <a href="javascript:void(0)" class="dropdown-item work-tag drop-workTag WT1">
			                            	<span class="btn btn-xs bg-danger WT1">priority</span>
			                            </a>
			                            <a href="javascript:void(0)" class="dropdown-item work-tag drop-workTag WT2">
			                            	<span class="btn btn-xs bg-primary WT2">important</span>
			                            </a>
			                            <a href="javascript:void(0)" class="dropdown-item work-tag drop-workTag WT3">
			                            	<span class="btn btn-xs bg-warning WT3">review</span>
			                            </a>
			                        </div>
		                        </div>
		
		                        <!-- 날짜 설정 -->
		                        <div class="add-date">
			                        <button type="button" class="btn-addWorkDate"><i class="far fa-calendar-alt"></i></button>
		                        </div>
		                    </div>
	
		                    <!-- 취소/만들기 버튼 -->
		                    <div class="addWork-btnRight">
		                        <button type="button" class="btn-addWork-cancel" value="${wl.worklistNo}">취소</button>
		                        <button type="button" class="btn-addWork-submit">만들기</button>
		                    </div>
	                    </div>
	                </form>
                </div>

            	<!-- 진행 중인 업무 -->
                <div class="worklist-titleInfo-top">
                    <p>진행 중인 업무 ${fn:length(wl.workList)-wl.completedWorkCnt}개</p>
                </div>
            </div><!-- /.worklist-title -->
            
            <!-- 업무리스트 컨텐츠 -->
            <div class="worklist-contents">
            	<c:set var="workList" value="${wl.workList}"/>
            	
            	<!-- 진행중인 업무 -->
                <div class="workIng-wrapper">
	            	<c:forEach items="${workList}" var="w" varStatus="wVs">
	            	<c:if test="${w.workCompleteYn=='N'}">
	                <!-- 업무 -->
	                <section class="work-item" role="button" tabindex="0" id="${w.workNo}">
	                	<input type="hidden" id="hiddenworklistTitle" value="${wl.worklistTitle}"/>
	                	
						<!-- 업무배정된 멤버아이디 구하기 -->
						<c:set var="workCharedMemId" value=""/>
						<c:forEach items="${w.workChargedMemberList}" var="m" varStatus="wcmVs">
							<c:set var="workCharedMemId" value="${wcmVs.last?workCharedMemId.concat(m.memberId):workCharedMemId.concat(m.memberId).concat(',')}"/>
						</c:forEach>
	                	<input type="hidden" class="hiddenWorkChargedMemId" value="${workCharedMemId}"/>
						            	
		                <!-- 태그 -->
		                <c:if test="${w.workTagCode!=null}">
		                <div class="work-tag">
		                	<span class="btn btn-xs bg-${w.workTagColor}">${w.workTagTitle}</span>
		                </div>
		                </c:if>
	
		                <!-- 업무 타이틀 -->
		                <div class="work-title">
		                    <h6>
		                    	<button type="button" class="btn-check btn-checkWork" value="${w.workNo}"><i class="far fa-square"></i></button>
		                    	<span id="work-workTitle">${w.workTitle}</span>
		                    </h6>
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
	
		                <div class="work-checklist">
		                <!-- 체크리스트 -->
		                <c:if test="${w.checklistList!=null && !empty w.checklistList}">
		                <c:set var="clList" value="${w.checklistList}" />
		                    <table class="tbl-checklist">
			                    <tbody>
				                	<c:forEach items="${clList}" var="chk">
					                	<c:set var="m" value="${chk.checklistChargedMember}"/>
					                	<!-- 체크리스트 배정된 멤버 구하기 -->
					                    <c:set var="chkChargedMemId" value="${m.memberId}"/>
					                    
					                	<c:if test="${chk.completeYn=='Y'}">
				                        <tr class="completed" id="${chk.checklistNo}">
					                		<th>
					                			<button type="button" class="btn-check" value="${w.workNo},${chk.checklistNo}"><i class="fas fa-check-square"></i></button>
					                			<input type="hidden" class="hiddenChkChargedMemId" value="${chkChargedMemId}"/>	
					                		</th>
					                        <td style="text-decoration:line-through;">
					                    </c:if>
					                    <c:if test="${chk.completeYn=='N'}">
				                        <tr id="${chk.checklistNo}">
				                        	<th>
				                        		<button type="button" class="btn-check" value="${w.workNo},${chk.checklistNo}"><i class="far fa-square"></i></button>
				                        		<input type="hidden" class="hiddenChkChargedMemId" value="${chkChargedMemId}"/>
				                        	</th>
					                        <td>
					                    </c:if>
					                        	<c:if test="${chk.checklistChargedMemberId!=null}">
					                            <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile" title="${m.memberName}">
					                            </c:if>
					                            ${chk.checklistContent}
					                        </td>
				                        </tr>
			                        </c:forEach>
			                    </tbody>
		                    </table>                
						</c:if>
	                	</div><!-- /.work-checklist -->
						
		                <!-- 날짜 설정 -->
		                <div class="work-deadline">
		                <!-- 마감일 없고 시작일만 있는 경우 -->
		                <c:if test="${w.workEndDate==null && w.workStartDate!=null}">
		                	<p>
		                	<fmt:formatDate value="${w.workStartDate}" type="date" pattern="MM월dd일" />에 시작
		                	</p>
		                </c:if>
		                <!-- 마감일 있는 경우 -->
		                <c:if test="${w.workEndDate!=null}">
		                	<c:set var="now" value="<%= new Date() %>"/>
	                    	<fmt:formatDate var="nowStr" value="${now}" type="date" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseDate var="today" value="${nowStr}" type="date" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseNumber var="today_D" value="${today.time/(1000*60*60*24)}" integerOnly="true"/>
	                    	<fmt:parseDate var="enddate" value="${w.workEndDate}" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseNumber var="enddate_D" value="${enddate.time/(1000*60*60*24)}" integerOnly="true"/>
	                    	
		                	<!-- 시작일 있는 경우 -->
		                	<c:if test="${w.workStartDate!=null}">
		                		<p>
			                	<!-- 마감일 안 지난 경우 -->
			                	<c:if test="${today_D < enddate_D}">
			                		<fmt:formatDate value="${w.workStartDate}" type="date" pattern="MM월dd일" /> - 
		                    		<fmt:formatDate value="${w.workEndDate}" type="date" pattern="MM월dd일" />
								</c:if> 
			                	<!-- 마감일 지난 경우 -->
			                	<c:if test="${today_D > enddate_D}">
									<p class="over">마감일 ${today_D - enddate_D}일 지남</p>
								</c:if>      
		                		</p>
		                	</c:if>
		                	
		                	<!-- 시작일 없는 경우 -->
		                	<c:if test="${w.workStartDate==null}">
		                		<p>
			                	<!-- 마감일 안 지난 경우 -->
			                	<c:if test="${today_D < enddate_D}">
			                		<fmt:formatDate value="${w.workEndDate}" type="date" pattern="MM월dd일" />에 마감
								</c:if> 
			                	<!-- 마감일 지난 경우 -->
			                	<c:if test="${today_D > enddate_D}">
									<p class="over">마감일 ${today_D - enddate_D}일 지남</p>
								</c:if>
								</p>
		                	</c:if>
		                </c:if>
		                </div><!-- /.work-deadline -->
		                
						<!-- 완료 체크리스트 수 구하기 -->
						<c:set var="chkCnt" value="0"/>
						<c:forEach items="${w.checklistList}" var="chk">
							<c:if test="${chk.completeYn=='Y'}">
								<c:set var="chkCnt" value="${chkCnt+1}"/>
							</c:if>
						</c:forEach>
						
		                <!-- 기타 아이콘 모음 -->
		                <div class="work-etc">
		                    <!-- 체크리스트/코멘트/첨부파일 수 -->
		                	<c:if test="${fn:length(w.checklistList)==0}">
		                    	<span class="ico"><i class="far fa-list-alt"></i> 0</span>
		                    </c:if>
		                    <c:if test="${fn:length(w.checklistList)>0}">
		                    	<span class="ico chklt-cnt">
		                    		<i class="far fa-list-alt"></i> 
		                    		<span class="chklt-cnt-completed">${chkCnt}</span>/<span class="chklt-cnt-total">${fn:length(w.checklistList)}</span>
		                    	</span>
		                    </c:if>
		                    <span class="ico"><i class="far fa-comment"></i> ${fn:length(w.workCommentList)}</span>
		                    <span class="ico"><i class="fas fa-paperclip"></i> ${fn:length(w.attachmentList)}</span>
		                    
		                    <!-- 업무 배정된 멤버 -->
		                    <c:if test="${w.workChargedMemberList!=null && !empty w.workChargedMemberList}">
		                    <div class="chared-member text-right">
		                    <c:forEach items="${w.workChargedMemberList}" var="m">
			                    <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile" title="${m.memberName}">
		                    </c:forEach>
		                    </div>
		                    </c:if>
		                </div>
	
		                <!-- 커버 이미지 -->
		                <c:if test="${w.attachmentList!=null && !empty w.attachmentList}">
			                <c:forTokens items="${fn:toLowerCase(w.attachmentList[0].renamedFilename)}" var="token" delims="." varStatus="vs">
	                        <c:if test="${vs.last}">
	                   	 		<c:if test="${token=='bmp' || token=='jpg' || token=='jpeg' || token=='gif' || token=='png' || token=='tif' || token=='tiff' || token=='jfif'}">
	                   	 		<div class="work-coverImage">
	                   	 			<img src="${pageContext.request.contextPath}/resources/upload/project/${project.projectNo}/${w.attachmentList[0].renamedFilename}" class="img-cover" alt="커버이미지">
	                   	 		</div>
	                   	 		</c:if>
	                   	 	</c:if>
	                        </c:forTokens>
		                </c:if>
		                
	                </section><!-- /.work-item -->
	            	</c:if>	
	                </c:forEach>
                </div><!-- /.workIng-wrapper -->
                
                <!-- 완료된 업무 -->
                <div class="workCompleted-wrapper hide">
                	<c:forEach items="${workList}" var="w" varStatus="wVs">
            		<c:if test="${w.workCompleteYn=='Y'}">
                	<!-- 업무 -->
	                <section class="work-item completed" role="button" tabindex="0" id="${w.workNo}">
	                	<input type="hidden" id="hiddenworklistTitle" value="${wl.worklistTitle}"/>
	                	
						<!-- 업무배정된 멤버아이디 구하기 -->
						<c:set var="workCharedMemId" value=""/>
						<c:forEach items="${w.workChargedMemberList}" var="m" varStatus="wcmVs">
							<c:set var="workCharedMemId" value="${wcmVs.last?workCharedMemId.concat(m.memberId):workCharedMemId.concat(m.memberId).concat(',')}"/>
						</c:forEach>
	                	<input type="hidden" class="hiddenWorkChargedMemId" value="${workCharedMemId}"/>
						            	
		                <!-- 태그 -->
		                <div class="work-tag">
		                <c:if test="${w.workTagCode!=null}">
		                	<span class="btn btn-xs bg-${w.workTagColor}">${w.workTagTitle}</span>
		                </c:if>
		                </div>
	
		                <!-- 업무 타이틀 -->
		                <div class="work-title">
		                    <h6>
		                    	<button type="button" class="btn-check btn-checkWork" value="${w.workNo}"><i class="fas fa-check-square"></i></button>
		                    	${w.workTitle}
		                    </h6>
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
	
		                <!-- 체크리스트 -->
		                <c:if test="${w.checklistList!=null && !empty w.checklistList}">
		                <c:set var="clList" value="${w.checklistList}" />
		                <div class="work-checklist">
		                    <table class="tbl-checklist">
			                    <tbody>
				                	<c:forEach items="${clList}" var="chk">
					                	<c:set var="m" value="${chk.checklistChargedMember}"/>
					                	<!-- 체크리스트 배정된 멤버 구하기 -->
					                    <c:set var="chkChargedMemId" value="${m.memberId}"/>
					                    
					                	<c:if test="${chk.completeYn=='Y'}">
				                        <tr class="completed" id="${chk.checklistNo }">
					                		<th>
					                			<button type="button" class="btn-check" value="${w.workNo},${chk.checklistNo}"><i class="fas fa-check-square"></i></button>
					                			<input type="hidden" class="hiddenChkChargedMemId" value="${chkChargedMemId}"/>	
					                		</th>
					                        <td style="text-decoration:line-through;">
					                    </c:if>
					                    <c:if test="${chk.completeYn=='N'}">
				                        <tr id="${chk.checklistNo}">
				                        	<th>
				                        		<button type="button" class="btn-check" value="${w.workNo},${chk.checklistNo}"><i class="far fa-square"></i></button>
				                        		<input type="hidden" class="hiddenChkChargedMemId" value="${chkChargedMemId}"/>
				                        	</th>
					                        <td>
					                    </c:if>
					                        	<c:if test="${chk.checklistChargedMemberId!=null}">
					                            <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile" title="${m.memberName}">
					                            </c:if>
					                            ${chk.checklistContent}
					                        </td>
				                        </tr>
			                        </c:forEach>
			                    </tbody>
		                    </table>                
	                	</div><!-- /.work-checklist -->
						</c:if>
						
		                <!-- 날짜 설정 -->
		                <c:if test="${w.workRealEndDate!=null}">
		                <div class="work-deadline">
		                    <p class="complete"><fmt:formatDate value="${w.workRealEndDate}" type="date" pattern="MM월dd일"/>에 완료</p>
		                </div><!-- /.work-deadline -->
						</c:if>
						
						<!-- 완료 체크리스트 수 구하기 -->
						<c:set var="chkCnt" value="0"/>
						<c:forEach items="${w.checklistList}" var="chk">
							<c:if test="${chk.completeYn=='Y'}">
								<c:set var="chkCnt" value="${chkCnt+1}"/>
							</c:if>
						</c:forEach>
						
		                <!-- 기타 아이콘 모음 -->
		                <div class="work-etc">
		                	<!-- 체크리스트/코멘트/첨부파일 수 -->
		                	<c:if test="${fn:length(w.checklistList)==0}">
		                    	<span class="ico"><i class="far fa-list-alt "></i> 0</span>
		                    </c:if>
		                    <c:if test="${fn:length(w.checklistList)>0}">
		                    	<span class="ico chklt-cnt">
		                    		<i class="far fa-list-alt"></i> 
		                    		<span class="chklt-cnt-completed">${chkCnt}</span>/<span class="chklt-cnt-total">${fn:length(w.checklistList)}</span>
		                    	</span>
		                    </c:if>
		                    <span class="ico"><i class="far fa-comment"></i> <span class="comment-cnt">${fn:length(w.workCommentList)}</span></span>
		                    <span class="ico"><i class="fas fa-paperclip"></i> <span class="attach-cnt">${fn:length(w.attachmentList)}</span></span>
		                    
		                    <!-- 업무 배정된 멤버 -->
		                    <c:if test="${w.workChargedMemberList!=null && !empty w.workChargedMemberList}">
		                    <div class="chared-member text-right">
		                    <c:forEach items="${w.workChargedMemberList}" var="m">
			                    <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile" title="${m.memberName}">
		                    </c:forEach>
		                    </div>
		                    </c:if>
		                </div>
	
		                <!-- 커버 이미지 -->
		                <c:if test="${w.attachmentList!=null && !empty w.attachmentList}">
			                <c:forTokens items="${fn:toLowerCase(w.attachmentList[0].renamedFilename)}" var="token" delims="." varStatus="vs">
	                        <c:if test="${vs.last}">
	                   	 		<c:if test="${token=='bmp' || token=='jpg' || token=='jpeg' || token=='gif' || token=='png' || token=='tif' || token=='tiff' || token=='jfif'}">
	                   	 		<div class="work-coverImage">
	                   	 			<img src="${pageContext.request.contextPath}/resources/upload/project/${project.projectNo}/${w.attachmentList[0].renamedFilename}" class="img-cover" alt="커버이미지">
	                   	 		</div>
	                   	 		</c:if>
	                   	 	</c:if>
	                        </c:forTokens>
		                </c:if>
		                
	                </section><!-- /.work-item -->
                	</c:if>	
                	</c:forEach>
                </div><!-- /.workCompleted-wrapper -->
                
            </div><!-- /.worklist-contents -->
            
            <!-- 진행 중인 업무 -->
            <div class="worklist-titleInfo-bottom">
                <button type="button" class="btn-showCompletedWork" value="${wl.worklistNo}">완료된 업무 ${wl.completedWorkCnt}개 보기</button>
            </div>
        </section><!-- /.worklist -->
        </c:forEach>
        
        
        <!-- 업무리스트 추가: 내워크패드인 경우 / 아닌 경우는 admin, 대표, 프로젝트 팀장에게만 보임 -->
        <c:if test="${'Y'==project.privateYn || ('N'==project.privateYn && ('admin'==memberLoggedIn.memberId || '대표'==memberLoggedIn.jobTitle || project.projectWriter==memberLoggedIn.memberId)) }">
        <section id="add-wklt-wrapper" class="worklist add-worklist" role="button" tabindex="0">
            <!-- 타이틀 -->
            <div class="worklist-title add-wklt">
                <h5><i class="fas fa-plus"></i> 업무리스트 추가</h5>
                <div class="clear"></div>
            </div><!-- /.worklist-title -->
        </section><!-- /.worklist -->
		</c:if>
		
        <!-- 업무리스트 추가 폼 -->
        <section id="add-wkltfrm-wrapper" class="worklist add-worklist" role="button" tabindex="0">
            <!-- 타이틀 -->
            <div class="worklist-title add-wklt">
                <form id="addWorklistFrm">
                    <input type="text" name="worklistTitle" placeholder="업무리스트 이름" required/>
                    <div class="worklist-title-btn">
                        <button type="button" id="btn-addWorklist" class="btn-addWork">
                            <i class="fas fa-plus"></i>
                        </button>
                        <button type="button" id="btn-cancel-addWorklist" class="btn-removeWorklist">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </form>
                <div class="clear"></div>
            </div><!-- /.worklist-title -->
        </section><!-- /.worklist -->

        <div class="clear"></div>
        
        </div><!-- /.wlList-wrapper -->
        
    </div><!-- /.container-fluid -->
    </div><!-- /.content -->
</div>
<!-- /.content-wrapper -->

<!-- 업무 삭제 드롭다운 -->
<div id="menu-delWork" class="dropdown-menu dropdown-menu-right">
    <a href="#" id="dropdown-work-remove" class="dropdown-item dropdown-file-remove" data-toggle="modal" data-target="#modal-worklist-remove">업무 삭제</a>
</div>
<!-- </div> -->

<!-- 업무리스트/업무삭제 모달 -->
<div class="modal fade" id="modal-worklist-remove">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            <h4 class="modal-title"><span class="modal-del-target"></span> 삭제</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
            </div>
            <div class="modal-body">
            <p>정말 삭제하시겠습니까? [<span id="modal-del-title"></span>] <span class="modal-del-target"></span>는 영구 삭제됩니다.</p>
            </div>
            <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">아니오, <span class="modal-del-target"></span>를 유지합니다.</button>
            <button type="button" id="btn-removeWorklist" class="btn btn-danger">네</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
