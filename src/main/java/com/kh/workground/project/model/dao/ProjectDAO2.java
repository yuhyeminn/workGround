package com.kh.workground.project.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.vo.Checklist;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;
import com.kh.workground.project.model.vo.Worklist;

public interface ProjectDAO2 {

	int insertProject(Project p);

	int insertProjectManager(Project p);

	int insertProjectMember(Map<String, String> param);

	List<Member> selectMemberListByDeptCode(Member memberLoggedIn);

	int insertDefaultWorkList(Map<String, Object> param);

	List<Project> selectListByDeptAndStatusCode(Map<String, Object> param);

	List<Project> selectListByImportantAndStatusCode(Map<String, Object> param);

	Project selectProjectOneForSetting(int projectNo);

	Member selectOneProjectManager(String projectWriter);

	List<Member> selectProjectManagerByDept(String projectWriter);

	Work selectOneWorkForSetting(int workNo);

	List<Checklist> selectChklstListByWorkNo(int workNo); //언니꺼

	Member selectMemberOneByMemberId(String memberId); //언니꺼

	List<Worklist> selectWorklistListByProjectNo(int projectNo);

	int updateStatusCode(Map<String, Object> param);

}
