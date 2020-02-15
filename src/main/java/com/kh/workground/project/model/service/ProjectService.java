package com.kh.workground.project.model.service;

import java.util.List;
import java.util.Map;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.vo.Checklist;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;
import com.kh.workground.project.model.vo.Worklist;

public interface ProjectService {

	Map<String, List<Project>> selectProjectListAll(Member memberLoggedIn);

	List<Member> selectMemberListByDept(String deptCode);

	Project selectProjectWorklistAll(int projectNo, String memberId);

	Map<String, Object> selectProjectImportantOne(Map<String, Object> param);

	int insertProjectImportant(Map<String, Object> param);

	int deleteProjectImportant(int projectImportantNo);

	Worklist insertWorklist(Map<String, Object> param);

	int deleteWorklist(int worklistNo);

	int insertWork(Map<String, Object> param);

	Work selectWorkOne();

	int updateChklistCompleteYn(Map<String, Object> param);

	Project searchWork(int projectNo, String keyword);

	int deleteWork(int workNo);

	String selectProjectWriter(int projectNo);

	Worklist selectWorklistOne(int projectNo, int worklistNo);

	int updateWorkCompleteYn(Map<String, Object> param);

	int deleteFile(int attachNo);

	int deleteChecklistByWorkNo(int workNo, int cntChk);

	int deleteCommentByWorkNo(int workNo, int cntComment);

	int deleteAttachByWorkNo(int workNo, int cntFile);

}
