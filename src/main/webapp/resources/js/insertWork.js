
//새 업무 만들기
function addWork(){
	//날짜 설정
    $('.btn-addWorkDate').daterangepicker();
	
	let $btnAddArr = $('.btn-addWork').not('#btn-addWorklist');
    let chkHtml = '<i class="fas fa-check"></i>'; //체크 아이콘 
	
	let addTag;
	let addDateArr = [];
	let addMemberArr = [];
	
	//업무추가 +버튼 클릭
	$(document).on('click', '.btn-addWork:not(#btn-addWorklist)', (e)=>{
		let btnPlus;		
		if(e.target.tagName==='I') btnPlus = e.target.parentNode;	
		else btnPlus = e.target;
		
		let worklistNo = btnPlus.value;
    	let btnCancel = document.querySelector('#worklist-'+worklistNo+' .btn-addWork-cancel');
    	let btnSubmit = document.querySelector('#worklist-'+worklistNo+' .btn-addWork-submit');
   		let addWorkWrapper = document.querySelector('#worklist-'+worklistNo+' .addWork-wrapper');
   		let workTitle = document.querySelector('#worklist-'+worklistNo+' textarea[name=workTitle]');
   		
   		//설정 버튼: 멤버, 태그, 날짜 
   		let btnAddMem = document.querySelector('#worklist-'+worklistNo+' .btn-addWorkMember');
   		let btnAddTag = document.querySelector('#worklist-'+worklistNo+' .btn-addWorkTag');
   		let btnAddDate = document.querySelector('#worklist-'+worklistNo+' .btn-addWorkDate'); 
   		
   		let memTagArr = document.querySelectorAll('#worklist-'+worklistNo+' .drop-memTag');
		let workTagArr = document.querySelectorAll('#worklist-'+worklistNo+' .drop-workTag');
		let dPickerArr = document.querySelectorAll('.daterangepicker');
		
		//입력창 열기
		$('.addWork-wrapper').removeClass('show');
		$(addWorkWrapper).addClass("show");
		$(workTitle).focus();
		
		//취소버튼에 worklistNo 담기
		btnCancel.value = worklistNo;
		
		
		//멤버버튼 클릭
		memTagArr.forEach((obj, idx)=>{
			obj.addEventListener('click', e=>{
				let className = obj.className;
				let classArr = className.split(" ");
				let memberId = classArr[2];
				
				let idx = addMemberArr.indexOf(memberId);
				let $hasCheck = $(obj).find('.media-body'); //체크아이콘 들어갈 태그
				
				//addMemberArr에 선택한 memberId 담기
				//배열에 아이디가 존재하지 않는 경우
				if(idx === -1) {
					$(obj).addClass('checked');
					$hasCheck.append(chkHtml);
					addMemberArr.push(memberId);
				}
				//배열에 이미 존재하는 경우
				else {
					$(obj).removeClass('checked');
					let $check = $hasCheck.find('.fa-check'); 
					$check.remove();
					addMemberArr.splice(idx, 1);
				}
			}); 
			
		}); //end of 멤버태그 클릭
		
		
		//업무상태태그 클릭
		workTagArr.forEach((obj, idx)=>{
			obj.addEventListener('click', e=>{
				let $this = $(e.target);
				let $check = $('.drop-workTag .fa-check');
	    		
	    		//addTag변수에 선택한 태그코드 담기
				if($this.hasClass('WT1')) {
					//이미 선택된 태그가 아닌 경우에는 체크
					if(!$this.hasClass('checked')){
    					$this.addClass('checked');
    					$check.remove(); //다른 태그에 체크 아이콘 더해져있으면 지우기
    					$this.append(chkHtml); //체크 아이콘 추가 
    					addTag = "WT1";
					}
					//이미 선택된 태그는 체크 해제
					else{
						$this.removeClass('checked');
						$this.find('.fa-check').remove();
						addTag = "";
					}
				}
				else if($this.hasClass('WT2')) {
					if(!$this.hasClass('checked')){
    					$this.addClass('checked');
    					$check.remove();
    					$this.append(chkHtml);
    					addTag = "WT2";
					}
					else{
						$this.removeClass('checked');
						$this.find('.fa-check').remove();
						addTag = "";
					}
				}
				else if($this.hasClass('WT3')) {
					if(!$this.hasClass('checked')){
    					$this.addClass('checked');
    					$check.remove();
    					$this.append(chkHtml);
    					addTag = "WT3";
					}
					else{
						$this.removeClass('checked');
						$this.find('.fa-check').remove();
						addTag = "";
					}
				} //end of else if
			});
		}); //end of 업무상태태그 클릭
		
		
		//날짜버튼 클릭
		btnAddDate.addEventListener('click', e=>{
			let btnAddDate = e.target.parentNode;
			let dp; //선택된 데이트피커
			
			dPickerArr.forEach((obj, idx)=>{
				if(obj.style.display==='block'){
					dp = obj;
				}
			});
			
			//데이트피커 요소들
			let $btnApply = $(dp).find('.applyBtn');
			let selectedVal;
			let addDate = e.target.parentNode.parentNode; //추가될 버튼 담길 요소
				
			//적용버튼 클릭 시
			$btnApply.on('click', ()=>{
					//날짜 뽑아내기
					selectedVal = $(dp).find('.drp-selected').text();
					let startArr = selectedVal.split(' - ')[0].split('/');
					let endArr = selectedVal.split(' - ')[1].split('/');
					
					let startDate = startArr[0]+"월 "+startArr[1]+"일";
					let endDate = endArr[0]+"월 "+endArr[1]+"일";
					
					let startSql = startArr[2]+"-"+startArr[0]+"-"+startArr[1];
					let endSql = endArr[2]+"-"+endArr[0]+"-"+endArr[1];
					
					//배열에 담기
					addDateArr.push(startSql);
					addDateArr.push(endSql);
					
				//추가될 버튼 요소
				let dateHtml = '<button type="button" class="btn-cancelDate">'+startDate+' - '+endDate+'<i class="fas fa-times"></i></button>';
				
				//데이트피커버튼 지우고  
				$(btnAddDate).remove();
				$(addDate).append(dateHtml);
				
				let $btnCancelDate = $(addDate).find('.btn-cancelDate');
				
				//날짜 지우기
				$btnCancelDate.on('click', ()=>{
					addDateArr.length = 0; //배열 초기화
					$btnCancelDate.remove();
					$(addDate).append(btnAddDate);
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
						//입력창 닫기
			    		$(workTitle).val("");
			    		$(addWorkWrapper).removeClass("show");
			    		
						$(wlSection).html(data);
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
			$(workTitle).val("");
			addTag = "";
			addMemberArr.length = 0; 
			addDateArr.length = 0; 
			
			
			//날짜 선택한 경우
			//$btnCancelDate.remove();
			//$(addDate).append(btnAddDate);
			
			$(addWorkWrapper).removeClass("show");
			
		}); 
		
	}); //end of 업무추가 +버튼 클릭
	
	
	//취소버튼 클릭
	/* $(document).on('click', '.btn-addWork-cancel', (e)=>{
		let btnCancel;		
		if(e.target.tagName==='I') btnCancel = e.target.parentNode;	
		else btnCancel = e.target;
		console.log(btnCancel);
		
		let worklistNo = btnCancel.value;
		let workTitle = document.querySelector('#worklist-'+worklistNo+' textarea[name=workTitle]');
		let addWorkWrapper = document.querySelector('#worklist-'+worklistNo+' .addWork-wrapper');
		
		$(workTitle).val("");
		addTag = "";
		addMemberArr.length = 0; 
		addDateArr.length = 0; 
		
		$(addWorkWrapper).removeClass("show");
	}); */
}