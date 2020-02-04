package com.kh.workground.member.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.member.model.service.MemberService;
import com.kh.workground.member.model.vo.Member;

@Controller
public class MemberController {
	
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);
	
	@Autowired
	MemberService memberService;
	
	@RequestMapping("/member/memberRegister.do")
	public void memberRegister() {}
		
	@RequestMapping("/member/memberList.do")
	public ModelAndView memberList(ModelAndView mav) {
		
		mav.setViewName("/member/memberList");
		
		return mav;
	}
	
	@RequestMapping("/member/checkIdExistence.do")
	public ModelAndView checkIdExistence(@RequestParam("memberId") String memberId,
										 ModelAndView mav) {
		
		//logger.debug("memberId={}", memberId);
		Member member = memberService.selectOneMember(memberId);
		
		if(member == null) {
			String msg = "존재하지 않는 회원입니다.";
			String loc = "/member/memberRegister";
			mav.setViewName("common/msg");
		}
		else {
			mav.addObject("member", member);
			mav.setViewName("member/memberRegister");		
		}
		
		return mav;
	}
	
	
}
