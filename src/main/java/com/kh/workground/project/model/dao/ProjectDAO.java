package com.kh.workground.project.model.dao;

import java.util.List;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;
import com.kh.workground.project.model.vo.Worklist;

public interface ProjectDAO {

	Member selectMemberOne(String string);

	List<Project> selectListByDept(String deptCode);

	List<Project> selectListByImportant(String memberId);

	Project selectMyProject(String memberId);

	List<Member> selectMemberListByDept(String deptCode);

	Project selectProjectOne(int projectNo);

	List<Worklist> selectWorklistListByProjectNo(int projectNo);

	List<Work> selectWorkListByWorklistNo(int worklistNo);

}
