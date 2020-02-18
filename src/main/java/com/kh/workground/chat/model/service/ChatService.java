package com.kh.workground.chat.model.service;

import java.util.List;
import java.util.Map;

import com.kh.workground.chat.model.vo.Channel;
import com.kh.workground.chat.model.vo.Chat;
import com.kh.workground.member.model.vo.Member;

public interface ChatService {

	List<Channel> findChannelNoListByMemberId(String memberId);

	List<Member> selectMemberList(String keyword);

	Member selectOneMember(String memberId);

	String findChannelByMemberId(Map<String, String> param);

	void insertChannel(List<Channel> channelList);

	List<Chat> findChatListByChannelNo(String channelNo);

}
