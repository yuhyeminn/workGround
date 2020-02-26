package com.kh.workground.project.model.service;

import java.util.List;
import java.util.Map;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.vo.Attachment;
import com.kh.workground.project.model.vo.Checklist;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;
import com.kh.workground.project.model.vo.WorkComment;

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

	int deleteWorkMember(Map<String, String> param);

	int updateWorkTag(Map<String, Object> param);

	int updateWorkPoint(Map<String, Integer> param);

	int updateWorkDate(Map<String, String> param);

	Checklist insertCheckList(Checklist chk);

	int updateWorkLocation(Map<String, Integer> param);

	int updateChkChargedMember(Map<String, String> param);

	int deleteChecklist(int checklistNo);

	int updateDesc(Map<String, String> param);

	int updateTitle(Map<String, String> param);

	Map<String, Object> insertWorkComment(WorkComment wc);

	int deleteWorkComment(int commentNo);

	Map<String, Object> insertWorkFile(Attachment attach);

	List<Work> selectMyWorkList(int projectNo, String memberId);

	Map<String, Integer> selectMyActivity(int projectNo, String memberId);

	int updateChklist(Map<String, String> param);

}
