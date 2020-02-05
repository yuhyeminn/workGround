package com.kh.workground.member.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
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
	
	@Autowired
	BCryptPasswordEncoder bcryptPasswordEncoder;
	
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
		int idValid = 1;
		if(member == null) {
			String msg = "존재하지 않는 회원입니다.";
			String loc = "/member/memberRegister.do";
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
		}
		else {
			mav.addObject("idValid", idValid);
			mav.addObject("member", member);
			mav.setViewName("member/memberRegister");		
		}
		
		return mav;
	}
	
	@PostMapping("/member/memberRegisterEnd.do")
	public String memberRegisterEnd(Member member, Model model) {
		String rawPassword = member.getPassword();
		String encryptedPassword = bcryptPasswordEncoder.encode(rawPassword);
		
		//logger.debug("rawPassword={}", rawPassword);
		//logger.debug("encryptPassword={}", encryptedPassword);
		
		//비밀번호 암호화 처리
		member.setPassword(encryptedPassword);
		logger.debug("member={}", member);
		
		int result = memberService.updateRegister(member);
		
		String loc = "/";
		String msg ="";
		if(result>0) msg="환영합니다 :) "+member.getMemberName()+"님, WORKGROUND의 회원이 되셨습니다.";
		else msg="회원가입에 실패하셨습니다. 깔깔깔";
		
		model.addAttribute("loc", loc);
		model.addAttribute("msg", msg);
		
		return  "common/msg";
	}
	
	
}
