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
		logger.debug("NoticeList={}", noticeList);
		mav.addObject("noticeList", noticeList);
		
		mav.setViewName("/notice/noticeList");
		
		return mav;
	}
	
	
}
