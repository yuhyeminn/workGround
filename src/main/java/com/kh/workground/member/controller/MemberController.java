
package com.kh.workground.member.controller;

import java.util.Arrays;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.member.model.exception.MemberException;
import com.kh.workground.member.model.service.MemberService;
import com.kh.workground.member.model.vo.Member;

@SessionAttributes(value={"memberLoggedIn"})
@Controller
public class MemberController {

	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);

	@Autowired
	MemberService memberSerivce;

	@Autowired
	BCryptPasswordEncoder bcryptPasswordEncoder;
	
	@RequestMapping("/member/memberRegister.do")
	public void memberRegister() {
	}

	@RequestMapping("/member/memberList.do")
	public ModelAndView memberList(ModelAndView mav) {

		mav.setViewName("/member/memberList");

		return mav;
	}

	/*@PostMapping("/member/memberLogin.do")
	public ModelAndView memberLogin(@RequestParam String memberId, @RequestParam String password, ModelAndView mav,
			HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		try {
			// 1. 업무로직
			Member m = memberSerivce.selectOneMember(memberId);
			logger.debug("m@controller={}", m);

			String msg = "";
			String loc = "/";
			String viewName = "common/msg";
			
			String encryptedPassword = bcryptPasswordEncoder.encode(password);
			
			logger.debug("rawPassword={}",password);
			logger.debug("encryptedPassword={}",encryptedPassword);

			// 로그인
			if (m == null) {
				msg = "존재하지 않는 아이디 입니다.";
			} else {
				//로그인 한 경우
				if (bcryptPasswordEncoder.matches(password, m.getPassword())) {
					mav.addObject("memberLoggedIn", m);
					viewName="notice/noticeList";
					String saveId = request.getParameter("saveId");
					//체크한경우
					if(saveId != null) {
						Cookie c = new Cookie("saveId", memberId);
						c.setMaxAge(7*24*60*60);//7일후 소멸
						c.setPath("/");//쿠키사용디렉토리. 도메인 전역에서 사용함.
						response.addCookie(c);
					}
					//체크하지 않은 경우
					else {
						Cookie c = new Cookie("saveId", memberId);
						c.setMaxAge(0);//삭제를 위해 유효기간을 0으로 설정
						c.setPath("/");
						response.addCookie(c);
					}
				} else {
					msg = "비밀번호가 틀렸습니다.";
				}
			}

			// 2. view모델 처리
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);

			// viewName 지정
			mav.setViewName(viewName);

		} catch (Exception e) {
			logger.error("로그인 오류", e);
			throw new MemberException("회원 관리 오류!", e);
		}

		return mav;
	}*/
	@PostMapping("/member/memberLogin.do")
	public ModelAndView memberLogin(@RequestParam String memberId, ModelAndView mav,
			HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		try {
			// 1. 업무로직
			Member m = memberSerivce.selectOneMember(memberId);
			logger.debug("m@controller={}", m);

			String msg = "";
			String loc = "/";
			String viewName = "common/msg";

			// 로그인
			if (m == null) {
				msg = "존재하지 않는 아이디 입니다.";
			} else {
				//로그인 한 경우
				mav.addObject("memberLoggedIn", m);
				viewName="notice/noticeList";
			}

			// 2. view모델 처리
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);

			// viewName 지정
			mav.setViewName(viewName);

		} catch (Exception e) {
			logger.error("로그인 오류", e);
			throw new MemberException("회원 관리 오류!", e);
		}

		return mav;
	}
	
	@RequestMapping("/member/memberLogOut.do")
	public String memberLogout(SessionStatus sessionStatus) {
		
		//setComplete 메소드 호출로 해당 세션 폐기
		if(!sessionStatus.isComplete()) {
			sessionStatus.setComplete();
		}
		
		return "redirect:/"; // /spring 으로 리다이렉트
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
		
		int result = memberSerivce.updateRegister(member);
		
		String loc = "/";
		String msg ="";
		if(result>0) msg="환영합니다 :) "+member.getMemberName()+"님, WORKGROUND의 회원이 되셨습니다.";
		else msg="회원가입에 실패하셨습니다. 깔깔깔";
		
		model.addAttribute("loc", loc);
		model.addAttribute("msg", msg);
		
		return  "common/msg";
	}
	@RequestMapping("/member/checkIdExistence.do")
	public ModelAndView checkIdExistence(@RequestParam("memberId") String memberId,
										 ModelAndView mav) {
		
		//logger.debug("memberId={}", memberId);
		Member member = memberSerivce.selectOneMember(memberId);
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
	
}

