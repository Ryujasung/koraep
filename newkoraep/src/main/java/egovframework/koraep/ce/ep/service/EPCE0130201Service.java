package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import egovframework.common.util;
import egovframework.mapper.ce.ep.EPCE0130201Mapper;

/**
 * 생산자ERP입고정보 Service
 * @author 유병승
 *
 */
@Service("epce0130201Service")
public class EPCE0130201Service {  
	
	@Resource(name="epce0130201Mapper")
	private EPCE0130201Mapper epce0130201Mapper;  //입고관리 Mapper
	
	/**
	 * 생산자ERP입고정보  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce0130201_select(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
		try {
			rtnMap.put("selList", util.mapToJson(epce0130201Mapper.epce0130201_select(inputMap)));
			rtnMap.put("totalList", util.mapToJson(epce0130201Mapper.epce0130201_select_cnt(inputMap)));
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
		
	/**
	 * 생산자ERP입고정보 삭제
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce0130201_delete(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		String errCd = "0000";
		
		try {
			epce0130201Mapper.epce0130201_delete(data);
			
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
}

