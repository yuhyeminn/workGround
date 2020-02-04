package com.kh.workground.project.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.exception.ProjectException;
import com.kh.workground.project.model.service.ProjectService;
import com.kh.workground.project.model.vo.Project;

@Controller
public class ProjectController {
	
	private static final Logger logger = LoggerFactory.getLogger(ProjectController.class);
	
	@Autowired
	ProjectService projectService;
	
	@RequestMapping("/project/projectList.do")
	public ModelAndView projectList(ModelAndView mav, HttpSession session) {
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		
		try {
			//1.업무로직
			//부서 전체 프로젝트/중요 표시된 프로젝트/내가 속한 프로젝트(내 워크패드 포함)
			Map<String, List<Project>> map = projectService.selectProjectListAll(memberLoggedIn);
			
			//뷰모델 처리
			mav.setViewName("/project/projectList");
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 리스트 조회 오류!");
		}
		
		return mav;
	}
	
	@RequestMapping("/project/projectView.do")
	public ModelAndView projectView(ModelAndView mav) {
		
		mav.setViewName("/project/projectView");
		
		return mav;
	}
	
	@RequestMapping("/project/projectAttachment.do")
	public ModelAndView projectAttachment(ModelAndView mav) {
		
		mav.setViewName("/project/projectAttachment");
		
		return mav;
	}
	
	@RequestMapping("/project/projectAnalysis.do")
	public ModelAndView projectAnalysis(ModelAndView mav) {
		
		mav.setViewName("/project/projectAnalysis");
		
		return mav;
	}
	
}
