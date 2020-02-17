package com.kh.workground.admin.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.notice.controller.NoticeController;
import com.kh.workground.notice.model.service.NoticeService;
import com.kh.workground.notice.model.vo.Notice;

@Controller
public class AdminController {
	
	private static final Logger logger = LoggerFactory.getLogger(NoticeController.class);
	
	@Autowired
	NoticeService noticeService;

	@RequestMapping("/admin/adminNoticeList.do")
	public ModelAndView adminNoticeAllList(ModelAndView mav) {
		/*List<Notice> noticeList = noticeService.selectNoticeList();*/
		/*mav.addObject("noticeList", noticeList);
		mav.setViewName("/admin/adminNoticeList");*/
		return mav;
	}


}
