package egovframework.koraep.mf.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.mf.ep.EPMF0130201Mapper;

/**
 * 생산자ERP입고정보 Service
 * @author 유병승
 *
 */
@Service("epmf0130201Service")
public class EPMF0130201Service {  
	
	@Resource(name="epmf0130201Mapper")
	private EPMF0130201Mapper epmf0130201Mapper;  //입고관리 Mapper
	
	/**
	 * 생산자ERP입고정보  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epmf0130201_select(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		try {
			if(uvo != null){
				if(uvo.getBIZR_TP_CD().equals("T1")){
					inputMap.put("T_USER_ID", uvo.getUSER_ID());
				}
				inputMap.put("MFC_BIZRID", uvo.getBIZRID());  			
				inputMap.put("MFC_BIZRNO", uvo.getBIZRNO_ORI());  	
				
				if(!uvo.getBRCH_NO().equals("9999999999")){
					inputMap.put("MFC_BIZRID", uvo.getBRCH_ID());  		
					inputMap.put("MFC_BIZRNO", uvo.getBRCH_NO());
				}
			}
			
			rtnMap.put("selList", util.mapToJson(epmf0130201Mapper.epmf0130201_select(inputMap)));
			rtnMap.put("totalList", util.mapToJson(epmf0130201Mapper.epmf0130201_select_cnt(inputMap)));
		} catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch (Exception e) {
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
	public String epmf0130201_delete(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		String errCd = "0000";
		
		try {
			epmf0130201Mapper.epmf0130201_delete(data);
			
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
}

