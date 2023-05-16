/**
 * 
 */
package egovframework.koraep.auth.service;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;

import javax.annotation.Resource;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.auth.AuthMapper;
import egovframework.mapper.ce.ep.CommonCeMapper;

/**
 * @author kwon
 *
 */
@Service("userAuthCheckService")
public class UserAuthCheckService implements UserDetailsService{
	
	@Resource(name="authMapper")
	private AuthMapper authMapper;
	
	@Resource(name="commonceMapper")
	private CommonCeMapper commonceMapper;
	
	@Override
	public UserDetails loadUserByUsername(String USER_ID) throws UsernameNotFoundException {
		System.out.println("loadUserByUsername");
		HashMap<String, String> map = new HashMap<String, String>();
		try {
			map.put("USER_ID", URLDecoder.decode(USER_ID,"utf-8"));
		} catch (UnsupportedEncodingException e) {
			throw new UsernameNotFoundException("url decoder unsupported exception");
		}
		map.put("UPD_PRSN_ID", USER_ID);
		
		UserVO userVO = authMapper.selectAuthCheckInfo(map);
		if (userVO == null){
			throw new UsernameNotFoundException("No user found with username");
		}
		
		//패스워드 오류 횟수 증가 - 정상로그인 시 초기화
		commonceMapper.UPDATE_PW_ERR_ADD(map);
		
		Collection<SimpleGrantedAuthority> roles = new ArrayList<SimpleGrantedAuthority>();
		roles.add(new SimpleGrantedAuthority("ROLE_USER"));
		
		UserDetails user = new User(USER_ID, userVO.getUSER_PWD(), roles);
		return user;
	}
	
}
