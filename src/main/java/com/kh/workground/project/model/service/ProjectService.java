package com.kh.workground.project.model.service;

import java.util.List;
import java.util.Map;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.vo.Project;

public interface ProjectService {

	Member selectMemberOne(String string);

	Map<String, List<Project>> selectProjectListAll(Member memberLoggedIn);

	List<Member> selectMemberListByDept(String deptCode);

	Map<String, Object> selectProjectWorklistAll(int projectNo);
}
