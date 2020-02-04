package com.kh.workground.project.controller;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.service.ProjectService;

@Controller
public class ProjectController {
	
	private static final Logger logger = LoggerFactory.getLogger(ProjectController.class);
	
	@Autowired
	ProjectService projectService;
	
	@RequestMapping("/project/projectList.do")
	public ModelAndView projectList(ModelAndView mav, HttpSession session) {
		Member memberLoggedIn = projectService.selectMemberOne("kh2020122");
		
		logger.debug("memberId={}", memberLoggedIn.getMemberId());
		
		mav.setViewName("/project/projectList");
		
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
