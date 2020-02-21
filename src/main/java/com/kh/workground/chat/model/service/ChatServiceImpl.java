package com.kh.workground.chat.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.chat.model.dao.ChatDAO;
import com.kh.workground.chat.model.dao.ChatDAOImpl;
import com.kh.workground.chat.model.vo.Channel;
import com.kh.workground.chat.model.vo.Chat;
import com.kh.workground.club.model.vo.ClubMember;
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
	public String findChannelByMemberId(Map<String, String> param) {
		return chatDAO.findChannelNoListByMemberId(param);
	}

	@Override
	public int insertChatLog(Chat fromMessage) {
		return chatDAO.insertChatLog(fromMessage);
	}

	@Override
	public Channel selectChannel(String channelNo) {

		return chatDAO.selectChannel(channelNo);
	}

	@Override
	public List<Chat> getClubChatList(String channelNo) {
		return chatDAO.getClubChatList(channelNo);
	}


}
