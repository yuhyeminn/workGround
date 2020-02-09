package com.kh.workground.member.model.service;

import com.kh.workground.member.model.vo.Member;

public interface MemberService {

	Member selectOneMember(String memberId);

	int updateRegister(Member member);

}

