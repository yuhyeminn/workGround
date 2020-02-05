package com.kh.workground.club.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.club.model.service.ClubService;
import com.kh.workground.club.model.vo.Club;

@Controller
public class ClubController {
	
	private static final Logger logger = LoggerFactory.getLogger(ClubController.class);
	
	@Autowired
	ClubService clubService;
	
	@RequestMapping("/club/clubList.do")
	public ModelAndView clubList(ModelAndView mav) {
		
		List<Club> clubList = clubService.selectAllClubList();
		logger.info("clubList{}",clubList);
		
		mav.addObject("clubList",clubList);
		mav.setViewName("/club/clubList");
		
		return mav;
	}

}
