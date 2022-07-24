package org.radi.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import lombok.extern.log4j.Log4j;

// 로그인 성공 시 처리
@Log4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler{@Override
	
	public void onAuthenticationSuccess(
		HttpServletRequest request, HttpServletResponse response,
		Authentication auth) throws IOException, ServletException {

		log.warn("Login Success");
		
		List<String> roleNames = new ArrayList<>();
		
		// 사용자가 가진 모든 권한을 List에 추가
		auth.getAuthorities().forEach(authority -> {
			
			roleNames.add(authority.getAuthority());
		});
		
		log.warn("ROLE NAMES: " + roleNames);
		
		if(roleNames.contains("ROLE_ADMIN")) {
			response.sendRedirect("/sample/admin");
			return;
		}
		
		if(roleNames.contains("ROLE_MEMBER")) {
			response.sendRedirect("/sample/member");
			return;
		}
		
		response.sendRedirect("/");
	}

}
