package com.kh.workground.project.model.service;

import java.util.List;
import java.util.Map;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;

public interface ProjectService2 {

	int insertProject(Project p, List<String> projectMemberList);

	List<Member> selectMemberListByManagerId(String projectWriter);

	Map<String, List<Project>> selectProjectListByStatusCode(Map<String, Object> param);

	Project selectProjectOneForSetting(int projectNo, boolean isIncludeManager);

	List<Member> selectProjectManagerByDept(String projectManager);

	Work selectOneWorkForSetting(int workNo);

	Member selectMemberOneByMemberId(String memberId);

	int updateStatusCode(Map<String, Object> param);

	int updateProjectDate(Map<String, String> param);

	int updateProjectMember(String updateMemberStr, int projectNo);

	int updateProjectManager(Map<String, String> param);

	int updateProjectQuit(Map<String, String> param);

	int updateWorkMember(String updateWorkMemberStr, int workNo);

}
