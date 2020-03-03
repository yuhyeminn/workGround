package com.kh.workground.project.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.vo.Attachment;
import com.kh.workground.project.model.vo.Checklist;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;
import com.kh.workground.project.model.vo.WorkComment;
import com.kh.workground.project.model.vo.Worklist;

public interface ProjectDAO2 {

	int insertProject(Project p);

	int insertProjectManager(Project p);

	int insertProjectMember(Map<String, String> param);

	List<Member> selectMemberListByManagerId(String projectWriter);

	int insertDefaultWorkList(Map<String, Object> param);

	Project selectProjectOneForSetting(int projectNo);

	Member selectOneProjectManager(String projectWriter);

	List<Member> selectProjectManagerByDept(String projectManager);

	Work selectOneWorkForSetting(int workNo);

	List<Checklist> selectChklstListByWorkNo(int workNo); //언니꺼

	Member selectMemberOneByMemberId(String memberId); //언니꺼

	List<Worklist> selectWorklistListByProjectNo(int projectNo);

	int updateStatusCode(Map<String, Object> param);

	List<Attachment> selectAttachmentListByWorkNo(int workNo);

	List<WorkComment> selectWorkCommentListByWorkNo(int workNo);

	int updateProjectDate(Map<String, String> param);

	List<Member> selectProjectMemberIdList(int projectNo);

	int updateProjectQuit(Map<String, String> param);

	int updateProjectManager(Map<String, String> param);

	int insertWorkMember(Map<String, String> param);

	int deleteWorkMember(Map<String, String> param);

	int updateWorkTag(Map<String, Object> param);

	int updateWorkPoint(Map<String, Integer> param);

	int updateWorkDate(Map<String, String> param);

	int insertCheckList(Checklist chk);

	Checklist selectOneChecklist(int checklistNo);

	int updateWorkLocation(Map<String, Integer> param);

	int updateChkChargedMember(Map<String, String> param);

	int deleteChecklist(int checklistNo);

	int updateDesc(Map<String, String> param);

	int updateTitle(Map<String, String> param);

	int insertWorkComment(WorkComment wc);

	int selectProjectMemberNo(Map<String, String> param);

	int deleteWorkComment(int commentNo);

	int insertWorkFile(Attachment attach);

	Attachment selectAttachmentOne(int attachmentNo);

	List<Work> selectWorkListByWorklistNo(int worklistNo); //언니꺼

	List<Work> selectMyWorkList(Map<String, String> param);

	int selectMyChecklistCnt(Map<String, String> param);

	int selectMyAttachCommentCnt(Map<String, String> param);

	int updateChklist(Map<String, String> param);
	
	List<Map<String, Object>> selectProjectLogList(int projectNo);

	List<Member> selectMemberListByDeptCode(Map<String, String> param);

	List<Member> selectProjectMemberList(int projectNo);

	int updateProjectManagerYn(Map<String, Object> param);

	List<Project> selectMyManagingProjectList(String memberId);

	List<Worklist> selectWorklistByProjectNo(int projectNo);

	int insertCopyWork(Work work);

	int insertCopyChkList(Map<String, Object> param);

}
