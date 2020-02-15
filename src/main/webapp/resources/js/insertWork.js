btnCheckArr.forEach((obj, idx)=>{
    	obj.addEventListener('click', ()=>{
    		let workNo = obj.value.split(",")[0];
    		let chkNo = obj.value.split(",")[1];
    		
    		let $workSection = $("section#"+workNo);
    		let $tr = $(obj.parentNode.parentNode);
    		let $tdChecklist = $(obj.parentNode.nextSibling.nextSibling);
    		let $icoChk = $(obj.firstChild);
    		
    		let workChargedMemIdArr = $workSection.find('.hiddenWorkChargedMemId').val().split(',');
    		let chkChargedMemId = obj.nextSibling.nextSibling.value;
    		let isValid = false;
    		
    		
    		//1.유효성 검사
    		//체크리스트에 배정된 멤버가 있다면
    		if(chkChargedMemId!==""){
    			//체크리스트에 배정된 멤버, 프로젝트 팀장, admin만 클릭 가능
    			if(loggedInMemberId===chkChargedMemId || loggedInMemberId===projectManager || loggedInMemberId==='admin'){
    				isValid = true;
    			}
    			else{
    				alert(loggedInMemberName+"님은 이 체크리스트에 대한 권한이 없습니다 :(");
    				return;
    			}
    		}
    		//체크리스트에 배정된 멤버가 없다면, 업무에 배정된 멤버인지
    		else{
    			let chkbool = false;
    			workChargedMemIdArr.forEach(id=>{
    				if(loggedInMemberId===id) chkbool = true;
    			});
    			
    			if(chkbool===true || loggedInMemberId===projectManager || loggedInMemberId==='admin'){
    				isValid = true;
    			}
    			else{
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
	    					$tr.toggleClass('completed');
	    					
	    					//완료된 체크리스트인 경우 
	    					if($tr.hasClass('completed')){
	    				        //체크박스 변경
	    				        $icoChk.removeClass('far fa-square');
	    				        $icoChk.addClass('fas fa-check-square');
	
	    				        //리스트에 줄 긋기
	    				        $tdChecklist.css('text-decoration', 'line-through');
	    				    }
	    					//미완료된 체크리스트인 경우
	    				    else{
	   				           //체크박스 변경
	   				           $icoChk.removeClass('fas fa-check-square');
	   				        	$icoChk.addClass('far fa-square');
	
	   				           //리스트에 줄 해제
	   				           $tdChecklist.css('text-decoration', 'none');
	    				    }
    					}
    					
    				},
    				error: (x,s,e) => {
   						console.log(x,s,e);
   					}
    			});
    	        
    		}
    	}); //end of .btn-check click
    }); //end of btnCheckArr.forEach