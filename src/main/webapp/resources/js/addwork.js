/*

//업무상태태그 클릭
    		dropWorkTag.forEach((obj, idx)=>{
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
    				
    			}); //end of 업무태그 click
    		}); //업무태그 끝
    		
    		
    		//날짜버튼 클릭
    		dropDate.forEach((obj, idx)=>{
    			obj.addEventListener('click', ()=>{
    				let dp; //선택된 데이트피커
    				
    				dPicker.forEach((obj, idx)=>{
    					if(obj.style.display==='block'){
    						dp = obj;
    					}
    				});
    				
    				//데이트피커 요소들
    				let $btnApply = $(dp).find('.applyBtn');
    				let selectedVal;
    				let addDate; //추가될 버튼 담길 요소
    				
    				//적용버튼 클릭 시
    				$btnApply.on('click', ()=>{
    					//날짜 뽑아내기
    					selectedVal = $(dp).find('.drp-selected').text();
    					let start = selectedVal.split(' - ')[0];
    					let end = selectedVal.split(' - ')[1];
    					let startArr = start.split('/');
    					let endArr = end.split('/');
    					start = startArr[0]+"월 "+startArr[1]+"일";
    					end = endArr[0]+"월 "+endArr[1]+"일";
    					
    					//배열에 담기
    					addDateArr.push(start);
    					addDateArr.push(end);
    					
	    				//추가될 버튼 요소
	    				addDate = obj.parentNode;
	    				let dateHtml = '<button type="button" class="btn-cancelDate">'+start+' - '+end+'<i class="fas fa-times"></i></button>';
	    				
	    				//데이트피커버튼 지우고  
	    				$(obj).remove();
	    				$(addDate).append(dateHtml);
	    				
	    				let $btnCancelDate = $(addDate).find('.btn-cancelDate');
	    				
	    				//날짜 지우기
	    				$btnCancelDate.on('click', ()=>{
	    					$btnCancelDate.remove();
	    					addDateArr.length = 0; //배열 초기화
	    					
		    				console.log(addDateArr);
	    				});
	    				
    				}); //end of click $btnApply
    				
    			}); //end of click 날짜 버튼
    		}); //날짜 끝



 */
