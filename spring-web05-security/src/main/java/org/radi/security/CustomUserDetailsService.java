package org.radi.security;

import org.radi.domain.MemberVO;
import org.radi.mapper.MemberMapper;
import org.radi.security.domain.CustomUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import lombok.extern.log4j.Log4j;

// 원하는 객체의 인증과 권한 체크 가능
@Log4j
public class CustomUserDetailsService implements UserDetailsService {

	@Autowired
	private MemberMapper memberMapper;
	
	@Override
	public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
		
		log.warn("Load User by UserName : " + userName);
		
		// userName은 id를 의미
		MemberVO vo = memberMapper.read(userName);
		log.warn("vo is Enabled: " + vo.isEnabled());
		log.warn("queried by member mapper: " + vo);
		
		return vo == null ? null : new CustomUser(vo);
	}
	
}
