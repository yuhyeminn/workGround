package com.kh.workground.common.aop;

import java.util.Map;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

@Component
@Aspect
public class ProjectLoggerAspect {
	
	static final Logger logger = LoggerFactory.getLogger(ProjectLoggerAspect.class);
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController.insertWorklist(..))", 
					returning="returnObj")
	public void afterReturning(JoinPoint joinPoint, Object returnObj) {
		logger.debug("//////////////////////////////////////////////////////////");
		logger.debug("returnObj={}", returnObj);
		
		ModelAndView mav = (ModelAndView)returnObj;
		Map<String, Object> map = mav.getModel();
		
		logger.debug("map={}", map.toString());
		
		/*if(map.containsKey("memberLoggedIn")) {
			Member memberLoggedIn = (Member)map.get("memberLoggedIn");
			logger.info("[{}]님이 로그인하셨습니다.", memberLoggedIn.getMemberId());
		}*/
	}
	
}
