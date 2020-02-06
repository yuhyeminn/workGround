package com.kh.workground.club.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
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
		int clubCount = clubService.selectCountClub();
		// logger.info("clubList{}",clubList);

		mav.addObject("clubList", clubList);
		mav.addObject("clubCount", clubCount);
		mav.setViewName("/club/clubList");

		return mav;
	}

	@PostMapping("/club/insertNewClub.do")
	public ModelAndView insertNewClub(ModelAndView mav, Club club) {

		logger.info("club={}",club);

		int result = clubService.insertNewClub(club);

		// logger.info("result={}",result);
		mav.addObject("msg", result > 0 ? "동호회 개설 성공!" : "동호회 개설 실패");
		mav.addObject("loc", "/club/clubList.do");
		mav.setViewName("common/msg");

		return mav;

	}

	@RequestMapping(value="/club/deleteClub.do",method= {RequestMethod.POST,RequestMethod.GET})
	public ModelAndView deleteClub(ModelAndView mav, @RequestParam(value = "clubNo") int clubNo) {

		//logger.info("clubNo={}", clubNo);
		int result = clubService.deleteClub(clubNo);
		//logger.info("result={}", result);
		mav.addObject("msg", result > 0 ? "동호회 삭제 성공!" : "동호회 삭제 실패");
		mav.addObject("loc", "/club/clubList.do");
		mav.setViewName("common/msg");

		return mav;

	}
	
	@RequestMapping("/club/updateClub.do")
	public ModelAndView updateClub(ModelAndView mav, Club club) {
		
		//logger.info("club={}",club);
		int result = clubService.updateClub(club);
		//logger.info("result={}",result);
		
		mav.addObject("msg", result > 0 ? "동호회 수정 성공":"동호회 수정 실패");
		mav.addObject("loc", "/club/clubList.do");
		mav.setViewName("common/msg");
		
		return mav;
	}
	
	@PostMapping("/club/insertClubMember.do")
	public ModelAndView insertClubMember(ModelAndView mav,
										 @RequestParam(value = "clubNo") int clubNo,
										 @RequestParam(value = "memberId") String memberId) {
		
		//logger.info("clubNo={}",clubNo);
		//logger.info("memberId={}",memberId);
		
		Map map = new HashMap<>();
		map.put("clubNo", clubNo);
		map.put("memberId", memberId);
		
		int result = clubService.insertClubMember(map);
		
		mav.addObject("msg", result > 0 ? "동호회 가입 성공":"동호회 가입 실패");
		mav.addObject("loc", "/club/clubList.do");
		mav.setViewName("common/msg");
		
		return mav;
	}

}
