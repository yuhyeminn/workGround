package com.kh.workground.notice.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.notice.model.service.NoticeService;
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
		logger.debug("noticeList={}", noticeList);
		//D1: 기획부 공지
		List<Notice> planningDeptNoticeList = noticeService.selectPlanningDeptNoticeList();
		logger.debug("planningDeptNoticeList={}", planningDeptNoticeList);
		//D2: 디자인부 공지
		List<Notice> designDeptNoticeList = noticeService.selectDesignDeptNoticeList();
		logger.debug("designDeptNoticeList={}", designDeptNoticeList);
		//D3: 개발부 공지
		List<Notice> developmentDeptNoticeList = noticeService.selectDevelopmentDeptNoticeList();
		logger.debug("developmentDeptNoticeList={}", developmentDeptNoticeList);	
		
		mav.addObject("noticeList", noticeList);
		mav.addObject("planningDeptNoticeList", planningDeptNoticeList);
		mav.addObject("designDeptNoticeList", designDeptNoticeList);
		mav.addObject("developmentDeptNoticeList", developmentDeptNoticeList);
		
		mav.setViewName("/notice/noticeList");
		
		return mav;
	}
	
	
}
