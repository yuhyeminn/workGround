package com.kh.workground.chat.model.dao;

import java.util.List;

import com.kh.workground.chat.model.vo.Channel;
import com.kh.workground.member.model.vo.Member;

public interface ChatDAO {

	List<Channel> findChannelNoListByMemberId(String memberId);

	List<Member> selectMemberList(String keyword);

}
