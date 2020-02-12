package com.kh.workground.notice.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.notice.model.service.NoticeService;
import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.CommunityComment;
import com.kh.workground.notice.model.vo.Notice;
import com.kh.workground.notice.model.vo.NoticeComment;

//Exception 던지기!!!!!

@Controller
public class NoticeController {
	
	private static final Logger logger = LoggerFactory.getLogger(NoticeController.class);
	
	@Autowired
	NoticeService noticeService;
	
	@RequestMapping("/notice/noticeList.do")
	public ModelAndView noticeList(ModelAndView mav) {
		
		//전체 공지
		List<Notice> noticeList = noticeService.selectNoticeList();
		//logger.debug("noticeList={}", noticeList);
		
		//D1: 기획부 공지
		List<Notice> planningDeptNoticeList = noticeService.selectPlanningDeptNoticeList();
		//logger.debug("planningDeptNoticeList={}", planningDeptNoticeList);
		
		//D2: 디자인부 공지
		List<Notice> designDeptNoticeList = noticeService.selectDesignDeptNoticeList();
		//logger.debug("designDeptNoticeList={}", designDeptNoticeList);
		
		//D3: 개발부 공지
		List<Notice> developmentDeptNoticeList = noticeService.selectDevelopmentDeptNoticeList();
		//logger.debug("developmentDeptNoticeList={}", developmentDeptNoticeList);	
		
		//자유게시판
		List<Community> communityList = noticeService.selectCommunityList();
		//logger.debug("communityList={}", communityList);	
		
		
		mav.addObject("noticeList", noticeList);
		mav.addObject("planningDeptNoticeList", planningDeptNoticeList);
		mav.addObject("designDeptNoticeList", designDeptNoticeList);
		mav.addObject("developmentDeptNoticeList", developmentDeptNoticeList);
		mav.addObject("communityList", communityList);
		
		mav.setViewName("/notice/noticeList");
		
		return mav;
	}
	
	
	@RequestMapping("/notice/noticeFormEnd.do")
	public ModelAndView boardFormEnd(ModelAndView mav,
									 Notice notice,
									 @RequestParam(value="upFile", required=false) MultipartFile upFile,
									 HttpServletRequest request) {
		//logger.debug("Notice={}", notice);
		//logger.debug("사용자입력 name={}", upFile.getName());
		//logger.debug("fileName={}", upFile.getOriginalFilename());
		//logger.debug("size={}", upFile.getSize());
		String saveDirectory = request.getSession()
									  .getServletContext()
									  .getRealPath("/resources/upload/notice");
	    File dir = new File(saveDirectory);
		if(dir.exists() == false)
			dir.mkdir();
		MultipartFile f = upFile;
		if(!f.isEmpty()) {
			String originalFileName = f.getOriginalFilename();
			String ext = originalFileName.substring(originalFileName.lastIndexOf("."));
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
			int rndNum = (int)(Math.random()*1000);
			String renamedFileName = sdf.format(new Date())+"_"+rndNum+ext;
			try {
				f.transferTo(new File(saveDirectory+"/"+renamedFileName));
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			notice.setNoticeOriginalFileName(originalFileName);
			notice.setNoticeRenamedFileName(renamedFileName);
		}
//		logger.debug("Notice={}", notice);	
		if(notice.getDeptCode().equals("all"))notice.setDeptCode(null);
		notice.setNoticeWriter("admin");
		int result = noticeService.insertNotice(notice);
		mav.addObject("msg", result>0?"게시물이 등록되었습니다.":"게시물 등록 실패! 깔깔깔");
		mav.addObject("loc", "/notice/noticeList.do");
		mav.setViewName("common/msg");
		return mav;
	}
	
	//공지 댓글 추가
	@PostMapping("/notice/noticeCommentInsert.do")
	public ModelAndView noticeCommentInsert(ModelAndView mav,
									  NoticeComment noticeComment) {
   		logger.debug("noticeComment={}",noticeComment);
   
   		Map<String, Object> noticeCommentMap = new HashMap<>();
   		noticeCommentMap.put("noticeRef", noticeComment.getNoticeRef());
   		noticeCommentMap.put("noticeCommentLevel", noticeComment.getNoticeCommentLevel());
   		noticeCommentMap.put("noticeCommentWriter", noticeComment.getNoticeCommentWriter());
   		noticeCommentMap.put("noticeCommentContent", noticeComment.getNoticeCommentContent());
   		noticeCommentMap.put("noticeCommentRef", noticeComment.getNoticeCommentRef()==0?null:noticeComment.getNoticeCommentRef());
   		
   		int result = noticeService.insertNoticeComment(noticeCommentMap);
   		
   		mav.addObject("msg", result>0?"댓글이 작성되었습니다.":"댓글 작성에 실패하셨습니다.");
   		mav.addObject("loc", "/notice/noticeList.do");
   		mav.setViewName("common/msg");
   		
   		return mav;
	}
	
	//공지 댓글 삭제
	@RequestMapping("/notice/noticeCommentDelete.do")
	public ModelAndView noticeCommentDelete(ModelAndView mav,
											@RequestParam("noticeCommentNo") int noticeCommentNo) {
		
		int result = noticeService.deleteNoticeComment(noticeCommentNo);
		
		mav.addObject("msg", result>0?"댓글이 삭제되었습니다.":"댓글 삭제가 실패되었습니다.");
		mav.addObject("loc", "/notice/noticeList.do");
		mav.setViewName("common/msg");
   		
   		return mav;
	}
	
	//자유게시판 댓글 등록
	@PostMapping("/community/communityCommentInsert.do")
	public ModelAndView communityCommentInsert(ModelAndView mav,
									  CommunityComment communityComment) {
   		logger.debug("communityComment={}",communityComment);
   
   		Map<String, Object> communityCommentMap = new HashMap<>();
   		communityCommentMap.put("commuRef", communityComment.getCommuRef());
   		communityCommentMap.put("commuCommentLevel", communityComment.getCommuCommentLevel());
   		communityCommentMap.put("commuCommentWriter", communityComment.getCommuCommentWriter());
   		communityCommentMap.put("commuCommentContent", communityComment.getCommuCommentContent());
   		communityCommentMap.put("commuCommentRef", communityComment.getCommuCommentRef()==0?null:communityComment.getCommuCommentRef());
   		
   		int result = noticeService.insertCommunityComment(communityCommentMap);
   		
   		mav.addObject("msg", result>0?"댓글이 작성되었습니다.":"댓글 작성에 실패하셨습니다.");
   		mav.addObject("loc", "/notice/noticeList.do");
   		mav.setViewName("common/msg");
   		
   		return mav;
	}
	
	//게시판 댓글 삭제
	@RequestMapping("/community/communityCommentDelete.do")
	public ModelAndView communityCommentDelete(ModelAndView mav,
												@RequestParam("communityCommentNo") int communityCommentNo) {
		
		int result = noticeService.deleteCommunityComment(communityCommentNo);
		
		mav.addObject("msg", result>0?"댓글이 삭제되었습니다.":"댓글 삭제가 실패되었습니다.");
		mav.addObject("loc", "/notice/noticeList.do");
		mav.setViewName("common/msg");
   		
   		return mav;
	}
	
	
	
}
