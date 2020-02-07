package com.kh.workground.club.controller;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.club.model.service.ClubService2;
import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubMember;
import com.kh.workground.club.model.vo.ClubNotice;
import com.kh.workground.club.model.vo.ClubPhoto;
import com.kh.workground.club.model.vo.ClubPlan;

@Controller
public class ClubController2 {
	
private static final Logger logger = LoggerFactory.getLogger(ClubController.class);
	
	@Autowired
	ClubService2 clubService2;
	
	
	@RequestMapping("/club/clubView.do")
	public ModelAndView clubView(ModelAndView mav,
								 @RequestParam("clubNo") int clubNo) {
		
//		logger.info("clubNo={}",clubNo);
		
		Club club = clubService2.selectClub(clubNo);
//		logger.info("club={}", club);
		
		List<ClubPlan> clubPlanList = clubService2.selectClubPlanList(clubNo);
//		logger.debug("clubPlanList={}", clubPlanList);
		List<ClubNotice> clubNoticeList = clubService2.selectClubNoticeList(clubNo);
//		logger.debug("clubNoticeList={}", clubNoticeList);
		
		mav.addObject("club", club);
		mav.addObject("clubPlanList", clubPlanList);
		mav.addObject("clubNoticeList", clubNoticeList);
		mav.setViewName("/club/clubView");
		
		return mav;
	}
	
	@RequestMapping("/club/clubIntroduceUpdate.do")
	public ModelAndView clubIntroduceUpdate(ModelAndView mav, 
											Club club) {
//		logger.debug("club={}", club);
		
		int result = clubService2.clubIntroduceUpdate(club);
		
		mav.addObject("msg", result>0?"동호회 소개를 성공적으로 수정하였습니다.":"동호회 소개를 수정하지 못했습니다.");
		mav.addObject("loc", "/club/clubView.do?clubNo="+club.getClubNo());
		mav.setViewName("common/msg");
		
		return mav;
	}
	
	@RequestMapping("/club/clubPlanUpdate.do")
	public ModelAndView clubPlanUpdate(ModelAndView mav, 
									   ClubPlan clubPlan, 
									   @RequestParam("clubPlanDate") String clubPlanDate) {
//		logger.debug("clubPlan={}", clubPlan);
//		logger.debug("clubPlanDate={}", clubPlanDate);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date utilDate = new Date();
		try {
			utilDate = sdf.parse(clubPlanDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		java.sql.Date clubPlanStart = new java.sql.Date(utilDate.getTime());
//		logger.debug("clubPlanStart={}", clubPlanStart);
		
		clubPlan.setClubPlanStart(clubPlanStart);
//		logger.debug("clubPlan={}", clubPlan);
		
		int result = clubService2.updateClubPlan(clubPlan);
		
		mav.addObject("msg", result>0?"일정 수정을 성공적으로 완료하였습니다.":"일정 수정을 하지 못했습니다.");
		mav.addObject("loc", "/club/clubView.do?clubNo="+clubPlan.getClubNo());
		mav.setViewName("common/msg");
		
		return mav;
	}
	
	@RequestMapping("/club/clubPlanInsert.do")
	public ModelAndView clubPlanInsert(ModelAndView mav, 
									   ClubPlan clubPlan, 
									   @RequestParam("clubPlanDate") String clubPlanDate) {
		logger.debug("clubPlan={}", clubPlan);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date utilDate = new Date();
		try {
			utilDate = sdf.parse(clubPlanDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		java.sql.Date clubPlanStart = new java.sql.Date(utilDate.getTime());
//		logger.debug("clubPlanStart={}", clubPlanStart);
		
		clubPlan.setClubPlanStart(clubPlanStart);
//		logger.debug("clubPlan={}", clubPlan);
		
		int result = clubService2.clubPlanInsert(clubPlan);
		
		mav.addObject("msg", result>0?"일정을 성공적으로 추가하였습니다.":"일정을 추가하지 못했습니다.");
		mav.addObject("loc", "/club/clubView.do?clubNo="+clubPlan.getClubNo());
		mav.setViewName("common/msg");
		
		return mav;
	}
	
	@RequestMapping("/club/clubNoticeUpdate.do")
	public ModelAndView clubNoticeUpdate(ModelAndView mav, 
										 ClubNotice clubNotice) {
//		logger.debug("clubNotice={}", clubNotice);
		
		int result = clubService2.clubNoticeUpdate(clubNotice);
		
		mav.addObject("msg", result>0?"공지사항을 성공적으로 수정하였습니다.":"공지사항을 수정하지 못했습니다.");
		mav.addObject("loc", "/club/clubView.do?clubNo="+clubNotice.getClubNo());
		mav.setViewName("common/msg");
		
		return mav;
	}
	
	@RequestMapping("/club/insertClubNotice.do")
	public ModelAndView clubNoticeInsert(ModelAndView mav, 
										 ClubNotice clubNotice) {
//		logger.debug("clubNotice={}", clubNotice);
		
		//memberLoggedIn.memberId와 clubNotice.clubNo으로 글 작성자(clubMemberNo) 넣어주기
		ClubMember clubMember = clubService2.selectOneClubMember(clubNotice);
		
		clubNotice.setClubMemberNo(clubMember.getClubMemberNo());
//		logger.debug("clubNotice={}", clubNotice);
		
		int result = clubService2.clubNoticeInsert(clubNotice);
		
		mav.addObject("msg", result>0?"공지사항을 성공적으로 추가하였습니다.":"공지사항을 추가하지 못했습니다.");
		mav.addObject("loc", "/club/clubView.do?clubNo="+clubNotice.getClubNo());
		mav.setViewName("common/msg");
		
		return mav;
	}
	
	@RequestMapping("/club/clubPhotoForm.do")
	public ModelAndView clubPhotoForm(ModelAndView mav, 
									  ClubPhoto clubPhoto, 
									  @RequestParam int clubNo, 
									  @RequestParam(value="upFile", required=false) MultipartFile upFile, 
									  HttpServletRequest request) {
		logger.debug("게시물 등록 요청!");
		logger.debug("clubPhoto={}", clubPhoto);
		
		String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/club");
		
		//동적으로 directory 생성하기
		File dir = new File(saveDirectory);
		if(dir.exists() == false)
			dir.mkdir();
		
		String clubPhotoOriginal = upFile.getOriginalFilename();
		String ext = clubPhotoOriginal.substring(clubPhotoOriginal.lastIndexOf("."));
		SimpleDateFormat sdf = new SimpleDateFormat();
		int rndNum = (int)(Math.random()*1000);
		String clubPhotoRenamed = sdf.format(new Date())+"_"+rndNum+ext;
		
		try {
			upFile.transferTo(new File(saveDirectory+"/"+clubPhotoRenamed));
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		clubPhoto.setClubNo(clubNo);
		clubPhoto.setClubPhotoOriginal(clubPhotoOriginal);
		clubPhoto.setClubPhotoRenamed(clubPhotoRenamed);
		
		logger.debug("clubPhoto={}", clubPhoto);
		
		int result = clubService2.insertClubPhoto(clubPhoto);
		
		mav.addObject("msg", result>0?"사진등록 성공!":"사진등록 실패!");
		mav.addObject("loc", "/club/clubList.do");
		mav.setViewName("common/msg");
		
		
		return mav;
	}
	

}
