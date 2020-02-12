package com.kh.workground.project.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.service.ProjectServiceImpl;
import com.kh.workground.project.model.vo.Attachment;
import com.kh.workground.project.model.vo.Checklist;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;
import com.kh.workground.project.model.vo.WorkComment;
import com.kh.workground.project.model.vo.Worklist;

@Repository
public class ProjectDAOImpl implements ProjectDAO {

	private static final Logger logger = LoggerFactory.getLogger(ProjectDAOImpl.class);
	
	@Autowired
	SqlSessionTemplate sqlSession;
	
	@Override
	public List<Project> selectListByDept(String deptCode) {
		return sqlSession.selectList("project.selectListByDept", deptCode);
	}

	@Override
	public List<Project> selectListByImportant(String memberId) {
		return sqlSession.selectList("project.selectListByImportant", memberId);
	}

	@Override
	public Project selectMyProject(String memberId) {
		return sqlSession.selectOne("project.selectMyProject", memberId);
	}

	@Override
	public List<Member> selectMemberListByDept(String deptCode) {
		return sqlSession.selectList("project.selectMemberListByDept", deptCode);
	}

	@Override
	public Project selectProjectOne(int projectNo) {
		return sqlSession.selectOne("project.selectProjectOne", projectNo);
	}

	@Override
	public List<Worklist> selectWorklistListByProjectNo(int projectNo) {
		return sqlSession.selectList("project.selectWorklistListbyProjectNo", projectNo);
	}

	@Override
	public List<Work> selectWorkListByWorklistNo(int worklistNo) {
		return sqlSession.selectList("project.selectWorkListByWorklistNo", worklistNo);
	}

	@Override
	public List<Checklist> selectChklstListByWorkNo(int workNo) {
		return sqlSession.selectList("project.selectChklstListByWorkNo", workNo);
	}

	@Override
	public List<Attachment> selectAttachListByWorkNo(int workNo) {
		return sqlSession.selectList("project.selectAttachListByWorkNo", workNo);
	}

	@Override
	public List<WorkComment> selectCommentListByWorkNo(int workNo) {
		return sqlSession.selectList("project.selectCommentListByWorkNo", workNo);
	}

	@Override
	public Member selectMemberOneByMemberId(String memberId) {
		return sqlSession.selectOne("project.selectMemberOneByMemberId", memberId);
	}

	@Override
	public int selectTotalWorkCompleteYn(int worklistNo) {
		return sqlSession.selectOne("project.selectTotalWorkCompleteYn", worklistNo);
	}

	@Override
	public List<Integer> selectListByImportantProjectNo(String memberId) {
		return sqlSession.selectList("project.selectImportantProjectNo", memberId);
	}

	@Override
	public Map<String, Object> selectProjectImportantOne(Map<String, Object> param) {
		return sqlSession.selectOne("project.selectProjectImportantOne", param);
	}

	@Override
	public int insertProjectImportant(Map<String, Object> param) {
		return sqlSession.insert("project.insertProjectImportant", param);
	}

	@Override
	public int deleteProjectImportant(int projectImportantNo) {
		return sqlSession.delete("project.deleteProjectImportant", projectImportantNo);
	}

	@Override
	public int insertWorklist(Map<String, Object> param) {
		return sqlSession.insert("project.insertWorklist", param);
	}

	@Override
	public int deleteWorklist(int worklistNo) {
		return sqlSession.delete("project.deleteWorklist", worklistNo);
	}

	@Override
	public int insertWork(Work work) {
		return sqlSession.insert("project.insertWork", work);
	}

	@Override
	public int insertWorkChargedMember(Map<String, Object> chargedParam) {
		return sqlSession.insert("project.insertWorkChargedMember", chargedParam);
	}

	@Override
	public Work selectWorkOne() {
		return sqlSession.selectOne("project.selectWorkOne");
	}



}
