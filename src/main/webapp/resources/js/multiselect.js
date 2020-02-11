  	//프로젝트 멤버 추가
	function addMember(){
		  $.ajax({
				url:"../project/projectDeptMember.do",
				dataType: "json",
				success: data => {
					console.log(data);
					var listObj = new ej.dropdowns.MultiSelect({
					      dataSource: data,
					      fields: { text: 'memberName', value: 'memberId' },
					      itemTemplate: '<div><img class="empImage img-circle img-sm-profile" src="'+contextPath+'/resources/img/profile/default.jpg" width="35px" height="35px"/>' +
					      '<div class="ename">${memberName}</div><div class="job"> ${deptTitle} </div></div>',
					      valueTemplate: '<div style="width:100%;height:100%;">' +
					          '<img class="value" src="'+contextPath+'/resources/img/profile/default.jpg" height="26px" width="26px"/>' +
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
