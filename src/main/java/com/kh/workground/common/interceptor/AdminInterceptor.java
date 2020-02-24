package com.kh.workground.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.kh.workground.member.model.vo.Member;

public class AdminInterceptor extends HandlerInterceptorAdapter {
	
	final static Logger logger = LoggerFactory.getLogger(AdminInterceptor.class);
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		Member memberLoggedIn = (Member)request.getSession().getAttribute("memberLoggedIn");
		
		if(!"admin".equals(memberLoggedIn.getMemberId())) {
			request.setAttribute("msg", "이 페이지는 관리자만 접근할 수 있습니다.");
			request.setAttribute("loc", "/");
			request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp").forward(request, response);
			
			return false;
		}
		
		return super.preHandle(request, response, handler);
	}

	
}
