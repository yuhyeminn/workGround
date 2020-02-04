package com.kh.workground.project.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.controller.ProjectController;
import com.kh.workground.project.model.dao.ProjectDAO;
import com.kh.workground.project.model.vo.Project;

@Service
public class ProjectServiceImpl implements ProjectService {
	
	private static final Logger logger = LoggerFactory.getLogger(ProjectServiceImpl.class);
	
	@Autowired
	ProjectDAO projectDAO;

	@Override
	public Member selectMemberOne(String string) {
		return projectDAO.selectMemberOne(string);
	}

	@Override
	public Map<String, List<Project>> selectProjectListAll(Member memberLoggedIn) {
		Map<String, List<Project>> map = new HashMap<>();
		
		//1. 부서 전체 프로젝트(최근 프로젝트) 조회
		List<Project> listByDept = projectDAO.selectListByDept(memberLoggedIn.getDeptCode());
		map.put("listByDept", listByDept);
		
		//2. 중요 표시된 프로젝트 조회
		//List<Project> listByImportant = projectDAO.selectListByImportant(memberLoggedIn.getMemberId());
		
		//3. 내가 속한 프로젝트(내 워크패드 포함) 조회
		//1번에서 구한 프로젝트 리스트에서 내가 포함된 리스트만 listByInclude에 추가하고
		//따로 조회해야될 건 내 워크패드!!?!
		//List<Project> listByInclude = projectDAO.selectListByInclude(memberLoggedIn.getMemberId());
		
		return map;
	}

}
