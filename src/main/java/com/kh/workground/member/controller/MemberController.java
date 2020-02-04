package com.kh.workground.member.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class MemberController {
	
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);
	
//	@Autowired
//	MemberService memberSerivce;
	
	@RequestMapping("/member/memberRegister.do")
	public void memberRegister() {}
		
	@RequestMapping("/member/memberList.do")
	public ModelAndView memberList(ModelAndView mav) {
		
		mav.setViewName("/member/memberList");
		
		return mav;
	}
	
}
