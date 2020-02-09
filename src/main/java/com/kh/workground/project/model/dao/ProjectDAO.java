package com.kh.workground.project.model.dao;

import java.util.List;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.vo.Attachment;
import com.kh.workground.project.model.vo.Checklist;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;
import com.kh.workground.project.model.vo.WorkComment;
import com.kh.workground.project.model.vo.Worklist;

public interface ProjectDAO {

	List<Project> selectListByDept(String deptCode);

	List<Project> selectListByImportant(String memberId);

	Project selectMyProject(String memberId);

	List<Member> selectMemberListByDept(String deptCode);

	Project selectProjectOne(int projectNo);

	List<Worklist> selectWorklistListByProjectNo(int projectNo);

	List<Work> selectWorkListByWorklistNo(int worklistNo);

	List<Checklist> selectChklstListByWorkNo(int workNo);

	List<Attachment> selectAttachListByWorkNo(int workNo);

	List<WorkComment> selectCommentListByWorkNo(int workNo);

	Member selectMemberOneByMemberId(String memberId);

	int selectTotalWorkCompleteYn(int worklistNo);


}
