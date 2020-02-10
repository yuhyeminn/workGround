package com.kh.workground.member.model.service;

import java.util.List;

import com.kh.workground.member.model.vo.Member;

public interface MemberService {

	Member selectOneMember(String memberId);

	int updateRegister(Member member);

	List<Member> selectMemberListAll();

}

