package com.kh.workground.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.exception.ProjectException;
import com.kh.workground.project.model.service.ProjectService;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Worklist;

@Controller
public class ProjectController {
	
	private static final Logger logger = LoggerFactory.getLogger(ProjectController.class);
	
	@Autowired
	ProjectService projectService;
	
	@RequestMapping("/project/projectList.do")
	public ModelAndView projectList(ModelAndView mav, HttpSession session) {
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		List<Member> memberListByDept = null; //부서 사람들 담는 리스트
		Map<String, List<Project>> projectMap = null; //조회한 프로젝트 리스트 담는 맵
		Map<String, Integer> statusCntMap = new HashMap<>(); //부서 전체 프로젝트의 상태별 카운트 담는 맵
		int ps1 = 0; //계획됨
		int ps2 = 0; //진행중
		int ps3 = 0; //완료됨
		int ps4 = 0; //상태없음
		
		
		try {
			//1.업무로직
			//1-1.부서 사람들 조회
			memberListByDept = projectService.selectMemberListByDept(memberLoggedIn.getDeptCode());
			
			//1-2.부서 전체 프로젝트/중요 표시된 프로젝트/내가 속한 프로젝트(내 워크패드 포함)
			projectMap = projectService.selectProjectListAll(memberLoggedIn);
			
			//1-3.부서 전체 프로젝트 상태 카운트
			List<Project> listByDept = projectMap.get("listByDept");
			
			for(Project p: listByDept) {
				String statusCode = p.getProjectStatusCode();
				
				if("PS1".equals(statusCode)) ps1++;
				else if("PS2".equals(statusCode)) ps2++;
				else if("PS3".equals(statusCode)) ps3++;
				else ps4++;
			}
			statusCntMap.put("계획됨", ps1);
			statusCntMap.put("진행중", ps2);
			statusCntMap.put("완료됨", ps3);
			statusCntMap.put("상태없음", ps4);
			
			
			//2.뷰모델 처리
			mav.addObject("projectMap", projectMap);
			mav.addObject("statusCntMap", statusCntMap);
			mav.addObject("memberListByDept", memberListByDept);
			mav.setViewName("/project/projectList"); 
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 목록 조회 오류!");
		}
		
		return mav;
	}
	
	@RequestMapping("/project/projectView.do")
	public ModelAndView projectView(ModelAndView mav, @RequestParam int projectNo) {
		
		try {
			//1. 업무로직
			Project p = projectService.selectProjectWorklistAll(projectNo);
			
			//2. 뷰모델 처리
			mav.addObject("project", p);
			mav.addObject("pMemList", p.getProjectMemberList());
			mav.addObject("wlList", p.getWorklistList());
			mav.setViewName("/project/projectView");
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 상세 조회 오류!");
		}
		
		
		
		return mav;
	}
	
	@RequestMapping("/project/projectAttachment.do")
	public ModelAndView projectAttachment(ModelAndView mav) {
		
		mav.setViewName("/project/projectAttachmentAjax");
		
		return mav;
	}
	
	@RequestMapping("/project/projectAnalysis.do")
	public ModelAndView projectAnalysis(ModelAndView mav) {
		
		mav.setViewName("/project/projectAnalysis");
		
		return mav;
	}
	
}
