package com.kh.workground.project.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.vo.Project;

public interface ProjectDAO2 {

	int insertProject(Project p);

	int insertProjectManager(Project p);

	int insertProjectMember(Map<String, String> param);

	List<Member> selectMemberListByDeptCode(Member memberLoggedIn);

	int insertDefaultWorkList(Map<String, Object> param);

	List<Project> selectListByDeptAndStatusCode(Map<String, Object> param);

	List<Project> selectListByImportantAndStatusCode(Map<String, Object> param);

}
