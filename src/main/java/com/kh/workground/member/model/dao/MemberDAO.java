package com.kh.workground.member.model.dao;

import java.util.List;

import com.kh.workground.member.model.vo.Member;

public interface MemberDAO {

	Member selectOneMember(String memberId);
	int updateRegister(Member member);
	List<Member> selectMemberListAll();

}