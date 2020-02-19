package com.kh.workground.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.kh.workground.member.model.vo.Member;

public class LoginAlreadyInterceptor extends HandlerInterceptorAdapter {
	
	final static Logger logger = LoggerFactory.getLogger(LoggerInterceptor.class);
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		Member memberLoggedIn = (Member)request.getSession().getAttribute("memberLoggedIn");
		String[] urlArr = request.getHeader("referer").split("/");
		logger.debug("urlArr={}", urlArr);
		
		if(memberLoggedIn!=null) {
			request.setAttribute("msg", "이미 로그인 하셨습니다.");
			request.setAttribute("loc", "/"+urlArr[4]+"/"+urlArr[5]);
			request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp").forward(request, response);
			
			return false;
		}
		
		return super.preHandle(request, response, handler);
	}

	
}
