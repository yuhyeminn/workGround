package com.kh.workground.project.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.vo.Project;

@Repository
public class ProjectDAOImpl implements ProjectDAO {

	@Autowired
	SqlSessionTemplate sqlSession;
	
	@Override
	public Member selectMemberOne(String string) {
		return sqlSession.selectOne("project.selectMemberOne", string);
	}

	@Override
	public List<Project> selectListByDept(String deptCode) {
		return sqlSession.selectList("project.selectListByDept", deptCode);
	}

	@Override
	public List<Project> selectListByImportant(String memberId) {
		return sqlSession.selectList("project.selectListByImportant", memberId);
	}

}
