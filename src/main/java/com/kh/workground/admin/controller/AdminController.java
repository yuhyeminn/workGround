package com.kh.workground.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.admin.model.service.AdminService;
import com.kh.workground.admin.model.vo.AdminClub;
import com.kh.workground.admin.model.vo.AdminProject;
import com.kh.workground.member.model.vo.Member;
import com.kh.workground.notice.model.service.NoticeService;
import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.Notice;

@Controller
public class AdminController {
	
	private static final Logger logger = LoggerFactory.getLogger(AdminController.class);
	
	@Autowired
	NoticeService noticeService;
	@Autowired
	AdminService adminService;

	@RequestMapping("/admin/adminAllNoticesList.do")
	public ModelAndView adminAllNoticesList(ModelAndView mav) {
		Map<String, String> noticeMap = new HashMap<>();
		noticeMap.put("sort", "notice_no desc");
		List<Notice> noticeList = noticeService.selectNoticeList(noticeMap);
		mav.addObject("noticeList", noticeList);
		mav.setViewName("/admin/adminAllNoticesList");
		return mav;
	}
	
	@RequestMapping("/admin/adminPostsByDepartment.do")
	public void adminPostsByDepartment() {

	}
	
	@GetMapping(value="/admin/{dept}/selectDepartment.do")
	public ModelAndView selectDepartment(@PathVariable("dept") String dept, ModelAndView mav) {
		logger.debug("dept={}", dept);
		
		Map<String, String> noticeMap = new HashMap<>();
		noticeMap.put("sort", "notice_no desc");
		List<Notice> list = null;
		
		if(dept.equals("D1")) {
			list = noticeService.selectPlanningDeptNoticeList(noticeMap);
		}
		else if(dept.equals("D2")) {
			list = noticeService.selectDesignDeptNoticeList(noticeMap);
		}
		else {
			list = noticeService.selectDevelopmentDeptNoticeList(noticeMap);			
		}
		
		mav.addObject("dept", dept);
		mav.addObject("noticeList", list);
		mav.setViewName("/admin/adminPostsByDepartment");
		return mav;
	}
	
	@RequestMapping("/admin/adminCommunityList.do")
	public ModelAndView adminCommunityList(ModelAndView mav) {
		Map<String, String> commuMap = new HashMap<>();
		commuMap.put("sort", "commu_no desc");
		List<Community> commuList = noticeService.selectCommunityList(commuMap);
		mav.addObject("communityList", commuList);
		mav.setViewName("/admin/adminCommunityList");
		return mav;
	}
	
	@RequestMapping("/admin/adminClubList.do")
	public ModelAndView adminClubList(ModelAndView mav) {
		List<AdminClub> list = adminService.selectAdminClubList();
		logger.debug(list.toString());
		mav.addObject("clubList", list);
		mav.setViewName("/admin/adminClubList");
		return mav;
	}
	
	@RequestMapping("/admin/adminProjectList.do")
	public ModelAndView adminProjectList(ModelAndView mav) {
		List<AdminProject> list = adminService.selectAdminProjectList();
		logger.debug(list.toString());
		mav.addObject("projectList", list);
		mav.setViewName("/admin/adminProjectList");
		return mav;
	}
	
}
