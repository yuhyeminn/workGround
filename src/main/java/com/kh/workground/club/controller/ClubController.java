package com.kh.workground.club.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
		// logger.info("clubList{}",clubList);

		mav.addObject("clubList", clubList);
		mav.setViewName("/club/clubList");

		return mav;
	}

	@PostMapping("/club/insertNewClub.do")
	public ModelAndView insertNewClub(ModelAndView mav, Club club,
			@RequestParam(value = "meetingCycle") String meetingCycle,
			@RequestParam(value = "meetingDate") String[] meetingDate) {

		// logger.info("club={}",club);
		// logger.info("mettingCycle={}",meetingCycle);
		String meetingDateStr = String.join(",", meetingDate);
		String clubMeetingDate = meetingCycle + " ," + meetingDateStr;
		// logger.info(clubMeetingDate);
		club.setClubMeetingDate(clubMeetingDate);

		int result = clubService.insertNewClub(club);

		// logger.info("result={}",result);
		mav.addObject("msg", result > 0 ? "동호회 개설 성공!" : "동호회 개설 실패");
		mav.addObject("loc", "/club/clubList.do");
		mav.setViewName("common/msg");

		return mav;

	}

	@DeleteMapping("/club/deleteClub.do")
	public ModelAndView deleteClub(ModelAndView mav, @RequestParam(value = "clubNo") int clubNo) {

		int result = clubService.deleteClub(clubNo);
		logger.info("result={}", result);
		mav.addObject("msg", result > 0 ? "동호회 삭제 성공!" : "동호회 삭제 실패");
		mav.addObject("loc", "/club/clubList.do");
		mav.setViewName("common/msg");

		return mav;

	}

}
