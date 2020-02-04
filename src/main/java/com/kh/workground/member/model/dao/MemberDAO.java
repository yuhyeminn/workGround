package com.kh.workground.member.model.dao;

import com.kh.workground.member.model.vo.Member;

public interface MemberDAO {

	Member selectOneMember(String memberId);

}
