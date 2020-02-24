package com.kh.workground.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.kh.workground.member.model.vo.Member;

public class LoginInterceptor extends HandlerInterceptorAdapter {
	
	final static Logger logger = LoggerFactory.getLogger(LoginInterceptor.class);
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		Member memberLoggedIn = (Member)request.getSession().getAttribute("memberLoggedIn");
		
		if(memberLoggedIn==null) {
			request.setAttribute("msg", "로그인 후 이용하세요.");
			request.setAttribute("loc", "/");
			request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp").forward(request, response);
			
			return false;
		}
		
		return super.preHandle(request, response, handler);
	}

	
}
