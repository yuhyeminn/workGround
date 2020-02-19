package com.kh.workground.chat.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.chat.model.dao.ChatDAO;
import com.kh.workground.chat.model.dao.ChatDAOImpl;
import com.kh.workground.chat.model.vo.Channel;
import com.kh.workground.chat.model.vo.ChannelMember;
import com.kh.workground.chat.model.vo.Chat;
import com.kh.workground.member.model.vo.Member;

@Service
public class ChatServiceImpl implements ChatService {
	
	@Autowired
	ChatDAO chatDAO;

	@Override
	public List<Channel> findChannelNoListByMemberId(String memberId) {
		return chatDAO.findChannelNoListByMemberId(memberId);
	}

	@Override
	public List<Member> selectMemberList(String keyword) {
		return chatDAO.selectMemberList(keyword);
	}

	@Override
	public Member selectOneMember(String memberId) {
		return chatDAO.selectOneMember(memberId);
	}

	@Override
	public List<Channel> findChannelByMemberId(Map<String, String> param) {
		return chatDAO.findChannelNoListByMemberId(param);
	}

	@Override
	public int insertChannel(Channel channel) {
		return chatDAO.insertChannel(channel);
	}

	@Override
	public int insertChannelMember(List<ChannelMember> channelMemberList) {
		int result = 0;
		for(ChannelMember channelMember : channelMemberList)
			result += chatDAO.insertChannelMember(channelMember);
		return result;
	}

	@Override
	public List<Chat> findChatRoomByChannelNo(String channelNo) {
		return chatDAO.findChatRoomByChannelNo(channelNo);
	}

	@Override
	public List<ChannelMember> selectChannelMemberList(String channelNo) {
		return chatDAO.selectChannelMemberList(channelNo);
	}
	
	@Override
	public int updateLastCheck(Chat fromMessage) {
		return chatDAO.updateLastCheck(fromMessage);
	}
	
	@Override
	public int insertChatLog(Chat fromMessage) {
//		updateLastCheck(fromMessage);
		return chatDAO.insertChatLog(fromMessage);
	}
}
