package com.kh.workground.project.controller;


import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.exception.ProjectException;
import com.kh.workground.project.model.service.ProjectService2;
import com.kh.workground.project.model.service.ProjectServiceImpl;
import com.kh.workground.project.model.vo.Project;

@Controller
public class ProjectController2 {
	// 혜민 컨트롤러
	private static final Logger logger = LoggerFactory.getLogger(ProjectController2.class);
	
	@Autowired
	ProjectService2 projectService;
	
	@RequestMapping("/project/addProject.do")
	public ModelAndView addProject(@RequestParam String projectTitle, @RequestParam(value="projectDesc", required=false) String projectDesc, @RequestParam String projectMember, HttpSession session
			,ModelAndView mav) {
		try {
			Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
			
			Project p = new Project();
			p.setProjectTitle(projectTitle);
			p.setProjectWriter(memberLoggedIn.getMemberId());
			p.setProjectDesc(projectDesc);
			
			String[] memberArr = projectMember.split(",");
			List<String> projectMemberList = new ArrayList<>(Arrays.asList(memberArr));
			
			//project 생성
			int result = projectService.insertProject(p, projectMemberList);
			
//			logger.debug("memberArr@Controller2={}",Arrays.toString(memberArr));
//			logger.debug("projectMemberList@Controller2={}",projectMemberList);
			
			mav.addObject("msg", result>0?"프로젝트 등록 성공!":"프로젝트 등록 실패!");
			mav.addObject("loc","/project/projectList.do");
			mav.setViewName("common/msg");
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 생성 오류!");
		}
		
		return mav;
	}
	
	@RequestMapping("/project/projectDeptMember.do")
	@ResponseBody
	public List<Member> projectDeptMember(HttpSession session){
		List<Member> list = null;
		try {
			Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
			list = projectService.selectMemberListByDept(memberLoggedIn.getDeptCode());
			
			logger.debug("list@controller2={}",list);
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("부서별 프로젝트 멤버 조회 오류!");
		}
		
		return list;
	}
}
