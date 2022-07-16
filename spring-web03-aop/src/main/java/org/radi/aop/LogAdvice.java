package org.radi.aop;

import java.util.Arrays;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Aspect
@Log4j
@Component
public class LogAdvice {

	// org.radi.service.SampleService로 시작하며 파라미터가 없는 모든 메서드
	@Before("execution(* org.radi.service.SampleService*.*(..))")
	public void logBefore() {
		
		log.info("===========================");
	}
	
	@Before("execution(* org.radi.service.SampleService*.doAdd(String, String)) && args(str1, str2)")
	public void logBeforeWithParam(String str1, String str2) {
		
		log.info("str1: " + str1);
		log.info("str2: " + str2);
	}
	
	@AfterThrowing(pointcut = "execution(* org.radi.service.SampleService*.*(..))", throwing = "exception")
	public void logException(Exception exception) {
		
		log.info("Exception....");
		log.info("exception : " + exception);
	}
	
	@Around("execution(* org.radi.service.SampleService*.*(..))")
	public Object logTime(ProceedingJoinPoint joinPoint) {
		
		long start = System.currentTimeMillis();
		
		log.info("Target: " + joinPoint.getTarget());
		log.info("Param: " + Arrays.toString(joinPoint.getArgs()));
		
		// invoke method
		Object result = null;
		
		try {
			result = joinPoint.proceed();
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		long end = System.currentTimeMillis();
		
		log.info("TIME: " + (end - start));
		log.info("result: " + result);
		
		return result;
	}
}
