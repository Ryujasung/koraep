package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE0130101Mapper;

/**
 * 지급관리시스템입고정보 Service
 * @author 유병승
 *
 */
@Service("epce0130101Service")
public class EPCE0130101Service {  
	
	
	@Resource(name="epce0130101Mapper")
	private EPCE0130101Mapper epce0130101Mapper;
	
	/**
	 * 지급관리시스템입고정보  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce0130101_select(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");

		if(vo != null ){
			inputMap.put("T_USER_ID", vo.getUSER_ID());
		}
    	
		try {
			rtnMap.put("selList", util.mapToJson(epce0130101Mapper.epce0130101_select(inputMap)));
			rtnMap.put("totalList", util.mapToJson(epce0130101Mapper.epce0130101_select_cnt(inputMap)));
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	  
    	return rtnMap;    	
    }
		
		
}

