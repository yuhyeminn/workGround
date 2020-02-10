package com.kh.workground.club.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.club.model.service.ClubService;
import com.kh.workground.club.model.vo.Club;
import com.kh.workground.member.model.vo.Member;

@RestController
public class ClubController {

	private static final Logger logger = LoggerFactory.getLogger(ClubController.class);

	@Autowired
	ClubService clubService;

	@RequestMapping("/club/clubList.do")
	public ModelAndView clubList(ModelAndView mav, HttpSession session) {
		
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId();
		Map map = new HashMap<>();
		map.put("memberId", memberId);
		map.put("sort", "club_enroll_date");
		
		// 모달창을 띄우기 위해 정보를 보낸다.
		List<Club> clubList = clubService.selectAllClubList(map); //전체 동호회
		
		mav.addObject("clubList", clubList);
		mav.setViewName("/club/clubList");

		return mav;
	}
	
	@GetMapping("/club/clubListBySort.do")
	public Map<String,List> clubListBySortAndCategroy(@RequestParam("sort") String sort, HttpSession session){
		Map<String,List> map = new HashMap<>();
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId();
		
		Map param = new HashMap<>();
		param.put("memberId", memberId);
		
		if(sort.equals("이름순")) {
			param.put("sort", "club_name");
		}else {
			param.put("sort", "club_enroll_date");
		}
		
		List<Club> clubList = clubService.selectAllClubList(param); //전체 동호회
		List<Club> myClubList = clubService.selectAllMyClubList(param); //가입한 동호회
		List<Club> standByClubList = clubService.selectAllStandByClubList(param); //승인 대기중인 동호회
		
		map.put("clubList", clubList);
		map.put("myClubList", myClubList);
		map.put("standByClubList", standByClubList);
		
		return map;
		
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

	@RequestMapping(value="/club/deleteClub.do")
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
