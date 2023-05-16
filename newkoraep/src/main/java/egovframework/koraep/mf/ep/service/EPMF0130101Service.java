package egovframework.koraep.mf.ep.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.mf.ep.EPMF0130101Mapper;

/**
 * 지급관리시스템입고정보 Service
 * @author 유병승
 *
 */
@Service("epmf0130101Service")
public class EPMF0130101Service {  
	
	
	@Resource(name="epmf0130101Mapper")
	private EPMF0130101Mapper epmf0130101Mapper;
	
	/**
	 * 지급관리시스템입고정보  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epmf0130101_select(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");

		if(vo != null ){
			inputMap.put("T_USER_ID", vo.getUSER_ID());
		}
    	
		try {
			rtnMap.put("selList", util.mapToJson(epmf0130101Mapper.epmf0130101_select(inputMap)));
			rtnMap.put("totalList", util.mapToJson(epmf0130101Mapper.epmf0130101_select_cnt(inputMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	  
    	return rtnMap;    	
    }
		
		
}

