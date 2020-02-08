package com.kh.workground.project.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.controller.ProjectController2;
import com.kh.workground.project.model.dao.ProjectDAO2;
import com.kh.workground.project.model.exception.ProjectException;
import com.kh.workground.project.model.vo.Project;
@Service
public class ProjectServiceImpl2 implements ProjectService2 {
	@Autowired
	ProjectDAO2 projectDAO;
	private static final Logger logger = LoggerFactory.getLogger(ProjectController2.class);
	
	@Override
	public int insertProject(Project p, List<String> projectMemberList) {
		int result = 0;
		//1.프로젝트 생성
		result = projectDAO.insertProject(p);
		if(result == 0)
			throw new ProjectException("프로젝트 생성 오류!");
		
		//2.프로젝트 팀장 추가(memberLoggedIn)
		//selectKey로 p에 projectNo 추가됨
		result = projectDAO.insertProjectManager(p);
		if(result == 0)
			throw new ProjectException("프로젝트 팀장 추가 오류!");
		
		//3.프로젝트 멤버 추가
		for(String memberId:projectMemberList) {
			Map<String, String> param = new HashMap<>();
			param.put("projectNo", Integer.toString(p.getProjectNo()));
			param.put("projectMember", memberId);
			result = projectDAO.insertProjectMember(param);
			
			if(result == 0)
				throw new ProjectException("팀원 추가 오류!");
		}
		
		//4.업무리스트 기본 3 개 생성(해야할 일, 진행중, 완료됨)
		List<String> worklistTitle = new ArrayList<>();
		Map<String, Object> param = new HashMap<>();
		param.put("projectNo", p.getProjectNo());
		worklistTitle.add("해야할 일");
		worklistTitle.add("진행중");
		worklistTitle.add("완료됨");
		param.put("worklistTitle", worklistTitle);
		result = projectDAO.insertDefaultWorkList(param);
		
		return result;
	}

	@Override
	public List<Member> selectMemberListByDept(String deptCode) {
		List<Member> list = projectDAO.selectMemberListByDept(deptCode);
		logger.debug("list={}", list);
		
		if(list==null) 
			throw new ProjectException("부서 멤버 조회 오류!");
		
		return list;
	}

}
