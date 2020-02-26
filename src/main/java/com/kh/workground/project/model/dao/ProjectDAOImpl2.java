package com.kh.workground.project.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.controller.ProjectController2;
import com.kh.workground.project.model.vo.Attachment;
import com.kh.workground.project.model.vo.Checklist;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;
import com.kh.workground.project.model.vo.WorkComment;
import com.kh.workground.project.model.vo.Worklist;

@Repository
public class ProjectDAOImpl2 implements ProjectDAO2 {

	@Autowired
	SqlSessionTemplate sqlSession;
	public void setSqlSessionTemplate(SqlSessionTemplate sqlSession) {
		this.sqlSession = sqlSession;
	}
	private static final Logger logger = LoggerFactory.getLogger(ProjectController2.class);
	
	@Override
	public int insertProject(Project p) {
		logger.debug("sqlSession={}",sqlSession);
		logger.debug("sqlSession실행 전");
		return sqlSession.insert("project.insertProject",p);
	}

	@Override
	public int insertProjectManager(Project p) {
		return sqlSession.insert("project.insertProjectManager",p);
	}

	@Override
	public int insertProjectMember(Map<String, String> param) {
		return sqlSession.insert("project.insertProjectMember",param);
	}

	@Override
	public List<Member> selectMemberListByManagerId(String projectWriter) {
		return sqlSession.selectList("project.selectMemberListByManagerId", projectWriter);
	}

	@Override
	public int insertDefaultWorkList(Map<String, Object> param) {
		return sqlSession.insert("project.insertDefaultWorkList",param);
	}

	@Override
	public List<Project> selectListByDeptAndStatusCode(Map<String, Object> param) {
		return sqlSession.selectList("project.selectListByDeptAndStatusCode",param);
	}

	@Override
	public List<Project> selectListByImportantAndStatusCode(Map<String, Object> param) {
		return sqlSession.selectList("project.selectListByImportantAndStatusCode",param);
	}

	@Override
	public Project selectProjectOneForSetting(int projectNo) {
		return sqlSession.selectOne("project.selectProjectOneForSetting",projectNo);
	}

	@Override
	public Member selectOneProjectManager(String projectWriter) {
		return sqlSession.selectOne("member.selectOneMember",projectWriter);
	}

	@Override
	public List<Member> selectProjectManagerByDept(String projectManager) {
		return sqlSession.selectList("project.selectProjectManagerByDept",projectManager);
	}

	@Override
	public Work selectOneWorkForSetting(int workNo) {
		return sqlSession.selectOne("project.selectOneWorkForSetting",workNo);
	}
	
	//언니꺼
	@Override
	public List<Checklist> selectChklstListByWorkNo(int workNo) {
		return sqlSession.selectList("project.selectChklstListByWorkNo", workNo);
	}
	
	//언니꺼
	@Override
	public Member selectMemberOneByMemberId(String memberId) {
		return sqlSession.selectOne("project.selectMemberOneByMemberId", memberId);
	}
	
	//언니꺼
	@Override
	public List<Worklist> selectWorklistListByProjectNo(int projectNo) {
		return sqlSession.selectList("project.selectWorklistListbyProjectNo", projectNo);
	}

	@Override
	public int updateStatusCode(Map<String, Object> param) {
		return sqlSession.update("project.updateStatusCode", param);
	}

	@Override
	public List<Attachment> selectAttachmentListByWorkNo(int workNo) {
		return sqlSession.selectList("project.selectAttachmentListByWorkNo",workNo);
	}

	@Override
	public List<WorkComment> selectWorkCommentListByWorkNo(int workNo) {
		return sqlSession.selectList("project.selectWorkCommentListByWorkNo",workNo);
	}

	@Override
	public int updateProjectDate(Map<String, String> param) {
		return sqlSession.update("project.updateProjectDate", param);
	}

	@Override
	public List<Member> selectProjectMemberIdList(int projectNo) {
		return sqlSession.selectList("project.selectProjectMemberIdList", projectNo);
	}

	@Override
	public int updateProjectQuit(Map<String, String> param) {
		return sqlSession.update("project.updateProjectQuit", param);
	}

	@Override
	public int updateProjectManager(Map<String, String> param) {
		return sqlSession.update("project.updateProjectManager",param);
	}

	@Override
	public int insertWorkMember(Map<String, String> param) {
		return sqlSession.insert("project.insertWorkMember",param);
	}

	@Override
	public int deleteWorkMember(Map<String, String> param) {
		return sqlSession.delete("project.deleteWorkMember",param);
	}

	@Override
	public int updateWorkTag(Map<String, Object> param) {
		return sqlSession.update("project.updateWorkTag",param);
	}

	@Override
	public int updateWorkPoint(Map<String, Integer> param) {
		return sqlSession.update("project.updateWorkPoint",param);
	}

	@Override
	public int updateWorkDate(Map<String, String> param) {
		return sqlSession.update("project.updateWorkDate",param);
	}

	@Override
	public int insertCheckList(Checklist chk) {
		return sqlSession.insert("project.insertCheckList",chk);
	}

	@Override
	public Checklist selectOneChecklist(int checklistNo) {
		return sqlSession.selectOne("project.selectOneChecklist",checklistNo);
	}

	@Override
	public int updateWorkLocation(Map<String, Integer> param) {
		return sqlSession.update("project.updateWorkLocation",param);
	}

	@Override
	public int updateChkChargedMember(Map<String, String> param) {
		return sqlSession.update("project.updateChkChargedMember",param);
	}

	@Override
	public int deleteChecklist(int checklistNo) {
		return sqlSession.delete("project.deleteChecklist",checklistNo);
	}

	@Override
	public int updateDesc(Map<String, String> param) {
		return sqlSession.update("project.updateDesc",param);
	}

	@Override
	public int updateTitle(Map<String, String> param) {
		return sqlSession.update("project.updateTitle",param);
	}

	@Override
	public int insertWorkComment(WorkComment wc) {
		return sqlSession.insert("project.insertWorkComment",wc);
	}

	@Override
	public int selectProjectMemberNo(Map<String, String> param) {
		return sqlSession.selectOne("project.selectProjectMemberNo",param);
	}

	@Override
	public int deleteWorkComment(int commentNo) {
		return sqlSession.delete("project.deleteWorkComment",commentNo);
	}

	@Override
	public int insertWorkFile(Attachment attach) {
		return sqlSession.insert("project.insertWorkFile",attach);
	}

	@Override
	public Attachment selectAttachmentOne(int attachmentNo) {
		return sqlSession.selectOne("project.selectAttachmentOne",attachmentNo);
	}

	@Override
	public List<Work> selectWorkListByWorklistNo(int worklistNo) {
		return sqlSession.selectList("project.selectWorkListByWorklistNo", worklistNo);
	}

	@Override
	public List<Work> selectMyWorkList(Map<String, String> param) {
		return sqlSession.selectList("project.selectMyWorkList", param);
	}

	@Override
	public int selectMyChecklistCnt(Map<String, String> param) {
		return sqlSession.selectOne("project.selectMyChecklistCnt",param);
	}

	@Override
	public int selectMyAttachCommentCnt(Map<String, String> param) {
		return sqlSession.selectOne("project.selectMyAttachCommentCnt",param);
	}

	@Override
	public int updateChklist(Map<String, String> param) {
		return sqlSession.update("project.updateChklist",param);
	}
	
	@Override
	public List<Map<String, Object>> selectProjectLogList(int projectNo) {
		return sqlSession.selectList("project.selectProjectLogList", projectNo);
	}

}
