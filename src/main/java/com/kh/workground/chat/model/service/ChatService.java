package com.kh.workground.chat.model.service;

import java.util.List;
import java.util.Map;

import com.kh.workground.chat.model.vo.Channel;
import com.kh.workground.chat.model.vo.ChannelMember;
import com.kh.workground.chat.model.vo.Chat;
import com.kh.workground.member.model.vo.Member;

public interface ChatService {

	List<Channel> findChannelNoListByMemberId(String memberId);

	List<Member> selectMemberList(String keyword);

	Member selectOneMember(String memberId);

	List<String> findChannelByMemberId(Map<String, String> param);

	int insertChannel(Channel channel);

	int insertChannelMember(List<ChannelMember> channelMemberList);

	List<Chat> findChatRoomByChannelNo(String channelNo);

	List<ChannelMember> selectChannelMemberList(String channelNo);
	
	int updateLastCheck(Chat fromMessage);
	
	int insertChatLog(Chat fromMessage);

}
