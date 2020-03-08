package com.kh.workground.common.aop;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
@Aspect
public class LoggerAspect {
	
	static final Logger logger = LoggerFactory.getLogger(LoggerAspect.class);
	
	/*@Pointcut("execution(* com.kh.workground..*(..))")
	public void pointcut() {}
	
	@Around("pointcut()")
	public Object loggerAdvice(ProceedingJoinPoint joinPoint) throws Throwable {
		Signature signature = joinPoint.getSignature(); 
		String type = signature.getDeclaringTypeName();
		String methodName = signature.getName();
		
		//joinPoint 전에 실행
		logger.debug("[Before] {}.{}", type, methodName);
		
		//joinPoint 실행(주업무)
		Object obj = joinPoint.proceed();
		
		//joinPoint 후에 실행
		logger.debug("[After] {}.{}", type, methodName);
		
		return obj;
	}*/
}
