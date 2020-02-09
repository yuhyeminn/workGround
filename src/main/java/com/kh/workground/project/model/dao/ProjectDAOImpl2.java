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
import com.kh.workground.project.model.vo.Project;

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
	public List<Member> selectMemberListByDeptCode(Member memberLoggedIn) {
		return sqlSession.selectList("project.selectMemberListByDeptCode", memberLoggedIn);
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
	

}
