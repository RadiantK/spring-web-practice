package org.radi.config;

import javax.servlet.ServletRegistration.Dynamic;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class WebConfig extends AbstractAnnotationConfigDispatcherServletInitializer{

	@Override
	protected Class<?>[] getRootConfigClasses() {
		return new Class[] {RootConfig.class};
	}

	@Override
	protected Class<?>[] getServletConfigClasses() {
		return new Class[] {ServletConfig.class};
	}

	@Override
	protected String[] getServletMappings() {
 		return new String[] {"/"};
	}
	
	// 요청에 맞는 핸들러를 찾지 못했을 때의 처리를 위한 메소드
	@Override
	protected void customizeRegistration(Dynamic registration) {
		registration.setInitParameter(
				"throwExceptionIfNoHandlerFound", "true");
	}
}
