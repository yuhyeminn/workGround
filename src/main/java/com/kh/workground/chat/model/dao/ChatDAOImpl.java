package com.kh.workground.chat.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.chat.model.vo.Channel;
import com.kh.workground.member.model.vo.Member;

@Repository
public class ChatDAOImpl implements ChatDAO {
	
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public List<Channel> findChannelNoListByMemberId(String memberId) {
		return sqlSession.selectList("chat.findChannelNoListByMemberId", memberId);
	}

	@Override
	public List<Member> selectMemberList(String keyword) {
		return sqlSession.selectList("chat.selectMemberList", keyword);
	}
	
}
