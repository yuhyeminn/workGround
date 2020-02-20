package com.kh.workground.chat.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.chat.model.vo.Channel;
import com.kh.workground.chat.model.vo.ChannelMember;
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
	public List<Channel> findChannelNoListByMemberId(Map<String, String> param) {
		return sqlSession.selectList("chat.findChannelByMemberId", param);
	}

	@Override
	public int insertChannel(Channel channel) {
		return sqlSession.insert("chat.insertChannel", channel);
	}

	@Override
	public int insertChannelMember(ChannelMember channelMember) {
		return sqlSession.insert("chat.insertChannelMember", channelMember);
	}

	@Override
	public List<Chat> findChatRoomByChannelNo(String channelNo) {
		return sqlSession.selectList("chat.findChatRoomByChannelNo", channelNo);
	}

	@Override
	public List<ChannelMember> selectChannelMemberList(String channelNo) {
		return sqlSession.selectList("chat.selectChannelMemberList", channelNo);
	}

	@Override
	public int updateLastCheck(Chat fromMessage) {
		return sqlSession.update("chat.updateLastCheck", fromMessage);
	}

	@Override
	public int insertChatLog(Chat fromMessage) {
		return sqlSession.insert("chat.insertChatLog", fromMessage);
	}

	@Override
	public List<Chat> selectChatList() {
		return sqlSession.selectList("chat.selectChatList");
	}
	
}
