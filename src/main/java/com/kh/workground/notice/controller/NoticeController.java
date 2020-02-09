package com.kh.workground.notice.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
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

import com.kh.workground.notice.model.service.NoticeService;
import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.Notice;

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
		//logger.debug("Notice={}", notice);	
		if(notice.getDeptCode().equals("all"))notice.setDeptCode(null);
		notice.setNoticeWriter("admin");
		int result = noticeService.insertNotice(notice);
		mav.addObject("msg", result>0?"게시물이 등록되었습니다.":"게시물 등록 실패! 깔깔깔");
		mav.addObject("loc", "/notice/noticeList.do");
		mav.setViewName("common/msg");
		return mav;
	}
	
	
}
