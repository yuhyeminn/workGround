package com.kh.workground.chat.model.service;

import java.util.List;

import com.kh.workground.chat.model.vo.Channel;
import com.kh.workground.member.model.vo.Member;

public interface ChatService {

	List<Channel> findChannelNoListByMemberId(String memberId);

	List<Member> selectMemberList(String keyword);

}
