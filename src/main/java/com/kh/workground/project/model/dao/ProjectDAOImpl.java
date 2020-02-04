package com.kh.workground.project.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.member.model.vo.Member;

@Repository
public class ProjectDAOImpl implements ProjectDAO {

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	@Override
	public Member selectMemberOne(String string) {
		return sqlSessionTemplate.selectOne("project.selectMemberOne", string);
	}
	
	
}
