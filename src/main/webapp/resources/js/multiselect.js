  	//프로젝트 멤버 추가
	function addMember(){
		  //프로젝트 추가는 팀장만 가능. 팀장의 아이디를 managerId로 갖고있는 멤버들 조회.
		  $.ajax({
				url:contextPath+"/project/projectTeamMember.do",
				dataType: "json",
				success: data => {
					var listObj = new ej.dropdowns.MultiSelect({
					      dataSource: data,
					      fields: { text: 'memberName', value: 'memberId' },
					      itemTemplate: '<div><img class="empImage img-circle img-sm-profile" src="'+contextPath+'/resources/img/profile/${renamedFileName}" width="35px" height="35px"/>' +
					      '<div class="ename">${memberName}</div><div class="job"> ${deptTitle} </div></div>',
					      valueTemplate: '<div style="width:100%;height:100%;">' +
					          '<img class="value" src="'+contextPath+'/resources/img/profile/${renamedFileName}" height="26px" width="26px"/>' +
					          '<div class="name">${memberName}</div></div>',
					      placeholder: 'Select Project member',
					      mode: 'Box'
					  });
					  listObj.appendTo('#projectMember');
				},
				error : (x,s,e) => {
					console.log(x,s,e);
				}
			});
	}
	function projectManager(projectManager){
		//json data => 현재 프로젝트작성자와 같은 부서 팀장 리스트, 현재 프로젝트 작성자(관리자)
		$.ajax({
			url:contextPath+"/project/projectManagerSetting.do",
			data:{projectManager:projectManager},
			dataType: "json",
			success: data => {
				var listObj = new ej.dropdowns.MultiSelect({
					dataSource: data,
				      fields: { text: 'memberName', value: 'memberId' },
				      itemTemplate: '<div><img class="empImage img-circle img-sm-profile" src="'+contextPath+'/resources/img/profile/${renamedFileName}" width="35px" height="35px"/>' +
				      '<div class="ename">${memberName}</div><div class="job"> ${deptTitle} </div></div>',
				      valueTemplate: '<div style="width:100%;height:100%;">' +
				          '<img class="value" src="'+contextPath+'/resources/img/profile/${renamedFileName}" height="26px" width="26px"/>' +
				          '<div class="name">${memberName}</div></div>',
				      mode: 'Box',
				      value:[projectManager]
				  });
				  listObj.appendTo('#projectManager');
			},
			error : (x,s,e) => {
				console.log(x,s,e);
			}
		});
	}
	function projectMember(projectNo){
		//json data => 현재 프로젝트 관리자와 같은 부서 멤버리스트, 현재 프로젝트 멤버 리스트
		$.ajax({
			url:contextPath+"/project/projectMemberSetting.do",
			data:{projectNo:projectNo},
			dataType: "json",
			success: data => {
				var memberArr = new Array();
				var i = 0;
				$.each(data.projectMemberList,(idx,list)=>{
					memberArr[i]= list.memberId
					i++;
				});
				var listObj = new ej.dropdowns.MultiSelect({
					dataSource: data.teamMemberList,
				      fields: { text: 'memberName', value: 'memberId' },
				      itemTemplate: '<div><img class="empImage img-circle img-sm-profile" src="'+contextPath+'/resources/img/profile/${renamedFileName}" width="35px" height="35px"/>' +
				      '<div class="ename">${memberName}</div><div class="job"> ${deptTitle} </div></div>',
				      valueTemplate: '<div style="width:100%;height:100%;">' +
				          '<img class="value" src="'+contextPath+'/resources/img/profile/${renamedFileName}" height="26px" width="26px"/>' +
				          '<div class="name">${memberName}</div></div>',
				      mode: 'Box', 
				      value: memberArr
				  });
				  listObj.appendTo('#projectMember');
			},
			error : (x,s,e) => {
				console.log(x,s,e);
			}
		});
	}
	
	function workMember(workNo,projectNo){
		//json data => 현재 프로젝트 멤버 리스트, 현재업무에 배정된 멤버 리스트
		$.ajax({
			url:contextPath+"/project/workChargedMemberSetting.do",
			data:{workNo:workNo,projectNo:projectNo},
			dataType: "json",
			success: data => {
				var memberArr = new Array();
				var i = 0;
				$.each(data.workChargedMemberList,(idx,list)=>{
					memberArr[i]= list.memberId
					i++;
				});
				console.log(memberArr);
				var listObj = new ej.dropdowns.MultiSelect({
					dataSource: data.projectMemberList,
				      fields: { text: 'memberName', value: 'memberId' },
				      itemTemplate: '<div><img class="empImage img-circle img-sm-profile" src="'+contextPath+'/resources/img/profile/${renamedFileName}" width="35px" height="35px"/>' +
				      '<div class="ename">${memberName}</div><div class="job"> ${deptTitle} </div></div>',
				      valueTemplate: '<div style="width:100%;height:100%;">' +
				          '<img class="value" src="'+contextPath+'/resources/img/profile/${renamedFileName}" height="26px" width="26px"/>' +
				          '<div class="name">${memberName}</div></div>',
				      mode: 'Box',
				      value: memberArr
				  });
				  listObj.appendTo('#workMember');
			},
			error : (x,s,e) => {
				console.log(x,s,e);
			}
		});
	}
