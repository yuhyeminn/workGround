package com.kh.workground.club.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.club.model.service.ClubService;

@Controller
public class ClubController {
	
	private static final Logger logger = LoggerFactory.getLogger(ClubController.class);
	
	@Autowired
	ClubService clubService;
	
	@RequestMapping("/club/clubList.do")
	public ModelAndView clubList(ModelAndView mav) {
		
		mav.setViewName("/club/clubList");
		
		return mav;
	}
	
	@RequestMapping("/club/clubView.do")
	public ModelAndView clubView(ModelAndView mav) {
		
		mav.setViewName("/club/clubView");
		
		return mav;
	}
	
	
}
