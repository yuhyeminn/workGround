package com.kh.workground.club.controller;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.JsonIOException;
import com.kh.workground.club.model.service.ClubService2;
import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubMember;
import com.kh.workground.club.model.vo.ClubNotice;
import com.kh.workground.club.model.vo.ClubNoticeComment;
import com.kh.workground.club.model.vo.ClubPhoto;
import com.kh.workground.club.model.vo.ClubPlan;
import com.kh.workground.club.model.vo.ClubPlanAttendee;
import com.kh.workground.member.model.vo.Member;

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
		List<ClubPhoto> clubPhotoList = clubService2.selectClubPhotoList(clubNo);
//		logger.debug("clubPhotoList={}", clubPhotoList);
		List<ClubNoticeComment> clubNoticeCommentList = clubService2.selectClubNoticeCommentList(clubNo);
//		logger.debug("clubNoticeCommentList={}", clubNoticeCommentList);
		
		mav.addObject("club", club);
		mav.addObject("clubPlanList", clubPlanList);
		mav.addObject("clubNoticeList", clubNoticeList);
		mav.addObject("clubPhotoList", clubPhotoList);
		mav.addObject("clubNoticeCommentList", clubNoticeCommentList);
		mav.addObject("clubPhotoCount", clubPhotoList.size());
		mav.addObject("clubPlanCount", clubPlanList.size());
		mav.addObject("clubNoticeCount", clubNoticeList.size());
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
//		logger.debug("clubPlan={}", clubPlan);
		
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
		
		Map<String, String> param = new HashMap<>();
		param.put("clubNo", clubNotice.getClubNo()+"");
		param.put("memberId", clubNotice.getMemberId());
		
		//memberLoggedIn.memberId와 clubNotice.clubNo으로 글 작성자(clubMemberNo) 넣어주기
		ClubMember clubMember = clubService2.selectOneClubMember(param);
		
		clubNotice.setClubMemberNo(clubMember.getClubMemberNo());
//		logger.debug("clubNotice={}", clubNotice);
		
		int result = clubService2.clubNoticeInsert(clubNotice);
		
		mav.addObject("msg", result>0?"공지사항을 성공적으로 추가하였습니다.":"공지사항을 추가하지 못했습니다.");
		mav.addObject("loc", "/club/clubView.do?clubNo="+clubNotice.getClubNo());
		mav.setViewName("common/msg");
		
		return mav;
	}
	
	@PostMapping("/club/deleteClubNotice.do")
	public ModelAndView deleteClubNotice(ModelAndView mav, 
										 @RequestParam("clubNoticeNo") int clubNoticeNo, 
										 @RequestParam("clubNo") int clubNo) {
//		logger.debug("clubNoticeNo={}", clubNoticeNo);
//		logger.debug("clubNo={}", clubNo);
		
		int result = clubService2.deleteClubNotice(clubNoticeNo);
		
		mav.addObject("msg", result>0?"공지사항을 성공적으로 삭제하였습니다.":"공지사항을 삭제하지 못했습니다.");
		mav.addObject("loc", "/club/clubView.do?clubNo="+clubNo);
		mav.setViewName("common/msg");
		
		return mav;
	}
	
	@RequestMapping("/club/clubPhotoForm.do")
	public ModelAndView clubPhotoForm(ModelAndView mav, 
									  ClubPhoto clubPhoto, 
									  @RequestParam(value="upFile", required=false) MultipartFile upFile, 
									  HttpServletRequest request) {
//		logger.debug("게시물 등록 요청!");
//		logger.debug("clubPhoto={}", clubPhoto);
//		logger.debug("사용자입력 name={}", upFile.getName());
//		logger.debug("fileName={}", upFile.getOriginalFilename());
//		logger.debug("size={}", upFile.getSize());
		
		Map<String, String> param = new HashMap<>();
		param.put("clubNo", clubPhoto.getClubNo()+"");
		param.put("memberId", clubPhoto.getMemberId());
		
		//memberLoggedIn.memberId와 clubNotice.clubNo으로 글 작성자(clubMemberNo) 넣어주기
		ClubMember clubMember = clubService2.selectOneClubMember(param);
		
		clubPhoto.setClubMemberNo(clubMember.getClubMemberNo());
		
		String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/club/"+clubPhoto.getClubNo());
		
		//동적으로 directory 생성하기
		File dir = new File(saveDirectory);
		if(dir.exists() == false)
			dir.mkdir();
		
		String clubPhotoOriginal = upFile.getOriginalFilename();
		String ext = clubPhotoOriginal.substring(clubPhotoOriginal.lastIndexOf("."));
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
		int rndNum = (int)(Math.random()*1000);
		String clubPhotoRenamed = sdf.format(new Date())+"_"+rndNum+ext;
		
		try {
			upFile.transferTo(new File(saveDirectory+"/"+clubPhotoRenamed));
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		clubPhoto.setClubPhotoOriginal(clubPhotoOriginal);
		clubPhoto.setClubPhotoRenamed(clubPhotoRenamed);
		
//		logger.debug("clubPhoto={}", clubPhoto);
		
		int result = clubService2.insertClubPhoto(clubPhoto);
		
		mav.addObject("msg", result>0?"사진등록 성공!":"사진등록 실패!");
		mav.addObject("loc", "/club/clubView.do?clubNo="+clubPhoto.getClubNo());
		mav.setViewName("common/msg");
		
		return mav;
	}
	
	@PostMapping("/club/deleteClubPhoto.do")
	public ModelAndView deleteClubPhoto(ModelAndView mav, 
										ClubPhoto clubPhoto, 
										HttpServletRequest request) {
//		logger.debug("clubPhoto={}", clubPhoto);
		
		int result = clubService2.deleteClubPhoto(clubPhoto);
		
		if(result>0 && !"".equals(clubPhoto.getClubPhotoRenamed())) {
			String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/club/"+clubPhoto.getClubNo());
			
			//1. 파일 삭제처리
			File delFile = new File(saveDirectory, clubPhoto.getClubPhotoRenamed());
			boolean bool = delFile.delete();
//			logger.debug("bool={}", bool?"파일삭제처리성공":"파일삭제처리실패");
			
			//2.파일 이동처리
//			String delDirectory = request.getSession().getServletContext().getRealPath("/resources/delete/club/"+clubPhoto.getClubNo());
//			File delFileTo = new File(delDirectory,  clubPhoto.getClubPhotoRenamed());
//			boolean bool = delFile.renameTo(delFileTo);
//			logger.debug("bool={}", bool?"파일삭제이동처리성공":"파일삭제이동처리실패");
		}
		
		mav.addObject("msg", result>0?"사진을 성공적으로 삭제하였습니다.":"사진을 삭제하지 못했습니다.");
		mav.addObject("loc", "/club/clubView.do?clubNo="+clubPhoto.getClubNo());
		mav.setViewName("common/msg");
		
		return mav;
	}
	
	@RequestMapping("/club/insertClubPlanAttendee.do")
	public ModelAndView insertClubPlanAttendee(ModelAndView mav, 
											   ClubPlanAttendee clubPlanAttendee, 
											   @RequestParam("clubNo") int clubNo) {
		logger.debug("clubPlanAttendee={}", clubPlanAttendee);
		
		Map<String, String> param = new HashMap<>();
		param.put("clubNo", clubNo+"");
		param.put("memberId", clubPlanAttendee.getMemberId());
		
		ClubMember clubMember = clubService2.selectOneClubMember(param);
		
		clubPlanAttendee.setClubMemberNo(clubMember.getClubMemberNo());
//		logger.debug("clubPlanAttendee={}", clubPlanAttendee);
		
		List<ClubPlanAttendee> clubPlanAttendeeList = clubService2.selectClubPlanAttendeeList(clubPlanAttendee.getClubPlanNo());
//		logger.debug("clubPlanAttendeeList={}", clubPlanAttendeeList);
		
		List<Integer> clubMemberNoList = new ArrayList<>();
		for(ClubPlanAttendee a : clubPlanAttendeeList) {
			clubMemberNoList.add(a.getClubMemberNo());			
		}
//		logger.debug("clubPlanNoList={}", clubMemberNoList);
		
		mav.addObject("loc", "/club/clubView.do?clubNo="+clubNo);
		mav.setViewName("common/msg");
		
		if(clubMemberNoList.contains(clubPlanAttendee.getClubMemberNo())) {
			mav.addObject("msg", "이미 참석 예약 되어있습니다.");
			return mav;
		}
		else {
			int result = clubService2.insertClubPlanAttendee(clubPlanAttendee);
			mav.addObject("msg", result>0?"참석 예약 되었습니다.":"참석예약이 되지 않았습니다.");
		}
		
		return mav;
	}
	
	@RequestMapping(value="/club/selectClubPlanList.do", method=RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public void selectClubPlanList(ModelAndView mav, 
										   @RequestParam("clubPlanNo") int clubPlanNo, 
										   HttpServletResponse response) throws JsonIOException, IOException {
//		logger.debug("clubPlanNo={}", clubPlanNo);
		
		List<ClubPlanAttendee> clubPlanAttendeeList = clubService2.selectClubPlanAttendeeList(clubPlanNo);
//		logger.debug("clubPlanAttendeeList={}", clubPlanAttendeeList);
		
		response.setContentType("text/html;charset=UTF-8"); 

		new Gson().toJson(clubPlanAttendeeList, response.getWriter());
		
	}
	
	@PostMapping("/club/deleteClubPlanAttendee.do")
	public ModelAndView deleteClubPlanAttendee(ModelAndView mav, 
											   ClubPlanAttendee clubPlanAttendee, 
											   @RequestParam("clubNo") int clubNo, 
											   HttpServletRequest request) {
//		logger.debug("clubPlanAttendee={}", clubPlanAttendee);
//		logger.debug("clubNo={}", clubNo);
		Member memberLoggedIn = (Member) request.getSession().getAttribute("memberLoggedIn");
//		logger.debug("memberLoggedIn={}", memberLoggedIn);
		
		mav.addObject("loc", "/club/clubView.do?clubNo="+clubNo);
		
		if(memberLoggedIn==null || !clubPlanAttendee.getMemberId().equals(memberLoggedIn.getMemberId())) {
			mav.addObject("msg", "본인의 일정만 취소할 수 있습니다.");
		}
		else {
			int result = clubService2.deleteClubPlanAttendee(clubPlanAttendee);
			
			mav.addObject("msg", result>0?"일정을 취소하였습니다.":"일정을 취소하지 못했습니다.");
		}
		
		mav.setViewName("common/msg");
		
		return mav;
	}
	
	@PostMapping("/club/insertClubNoticeComment.do")
	public ModelAndView insertClubNoticeComment(ModelAndView mav, 
												ClubNoticeComment clubNoticeComment) {
		logger.debug("clubNoticeComment={}", clubNoticeComment);
		
		int result = clubService2.insertClubNoticeComment(clubNoticeComment);
		
		mav.setViewName("redirect:/club/clubView.do?clubNo="+clubNoticeComment.getClubNo());
		
		return mav;
	}

}
