package com.kh.workground.project.controller;


import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.project.model.service.ProjectService;

@Controller
public class ProjectController2 {
	// 혜민 컨트롤러
	private static final Logger logger = LoggerFactory.getLogger(ProjectController2.class);
	
	@Autowired
	ProjectService projectService;
	
	@RequestMapping("/project/addProject.do")
	public ModelAndView addProject(@RequestParam String projectTitle, @RequestParam(value="projectDesc", required=false) String projectDesc, HttpServletRequest request
			,ModelAndView mav) {
		logger.debug("projectTitle={}",projectTitle);
		logger.debug("projectDesc={}",projectDesc);
		String[] projectMember = request.getParameterValues("projectMember");
		logger.debug("projectMember={}",projectMember);
		return mav;
	}
}
