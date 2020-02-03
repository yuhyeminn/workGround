package com.kh.workground.common.aop;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * Aspect = Pointcut + Advice
 * 
 * Advice의 종류 
	1. Before Advice : Joinpoint 전에 실행
	2. Around Advice : Joinpoint 앞과 뒤에서 실행
	3. After Returning Advice : Joinpoint 메소드가 리턴될시 실행. Return된 object에 접근가능
	4. After Advice : Joinpoint후에 무조건 실행됨(예외발생시에도 실행. finally와 유사함.)
	5. After Throwing Advice : Jointpoint 메소드 실행중 예외발생시 실행
 *
 */
@Component
@Aspect
public class LoggerAspect {
	
	static final Logger logger = LoggerFactory.getLogger(LoggerAspect.class);
	
	@Pointcut("execution(* com.kh.workground..*(..))")
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
	}
}
