package com.kh.workground.chat.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.chat.model.vo.Channel;
import com.kh.workground.chat.model.vo.Chat;
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

	@Override
	public Member selectOneMember(String memberId) {
		return sqlSession.selectOne("chat.selectOneMember", memberId);
	}

	@Override
	public String findChannelNoListByMemberId(Map<String, String> param) {
		return sqlSession.selectOne("chat.findChannelByMemberId", param);
	}

	@Override
	public int insertChatLog(Chat fromMessage) {
		return sqlSession.insert("chat.insertChatLog", fromMessage);
	}

	@Override
	public Channel selectChannel(String channelNo) {

		return sqlSession.selectOne("chat.selectChannel", channelNo);
	}

	@Override
	public List<Chat> getClubChatList(String channelNo) {

		return sqlSession.selectList("chat.getClubChatList", channelNo);
	}
	
}
