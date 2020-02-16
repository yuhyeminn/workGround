package com.kh.workground.member.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.member.model.vo.Member;

@Repository
public class MemberDAOImpl implements MemberDAO {
	//
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public Member selectOneMember(String memberId) {
		return sqlSession.selectOne("member.selectOneMember",memberId);
	}

	@Override
	public int updateRegister(Member member) {
		return sqlSession.update("member.updateRegister", member);
	}
}
