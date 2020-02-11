package com.kh.workground.project.model.service;

import java.util.List;
import java.util.Map;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.vo.Project;

public interface ProjectService {

	Map<String, List<Project>> selectProjectListAll(Member memberLoggedIn);

	List<Member> selectMemberListByDept(String deptCode);

	Project selectProjectWorklistAll(int projectNo, String memberId);

	Map<String, Object> selectProjectImportantOne(Map<String, Object> param);

	int insertProjectImportant(Map<String, Object> param);

	int deleteProjectImportant(int projectImportantNo);

	int insertWorklist(Map<String, Object> param);

	int deleteWorklist(int worklistNo);

	int insertWork(Map<String, Object> param);
}
