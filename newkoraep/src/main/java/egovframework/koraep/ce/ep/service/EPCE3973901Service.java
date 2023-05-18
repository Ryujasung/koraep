package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE3973901Mapper;

/**
 * API전송이력조회 Service
 * @author 김도연
 *
 */
@Service("epce3973901Service")
public class EPCE3973901Service {

	@Resource(name="epce3973901Mapper")
	private EPCE3973901Mapper epce3973901Mapper;  //API전송이력조회 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  // 공통 Mapper

	/**
	 * API전송이력 초기값 셋팅
	 * @param model
	 * @param request
	 * @return
	 * @
	 */ 
	public ModelMap epce3973901_select(ModelMap model, HttpServletRequest request) {
		
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);
		List<?> lk_api_cd_sel = commonceService.getCommonCdListNew("S003");//전송구분
		
		try {
			model.addAttribute("lk_api_cd_sel", util.mapToJson(lk_api_cd_sel));
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
	
		return model;
		
	}
	
	/**
	 * API전송이력 메뉴명조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public HashMap epce3973901_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
				rtnMap.put("menuNm", util.mapToJson(epce3973901Mapper.epce3973901_select(inputMap)));
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}    
			
			return rtnMap;    	
	    }
	  
	/**
	 * API전송이력 버튼명조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public HashMap epce3973901_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
				rtnMap.put("btnNm", util.mapToJson(epce3973901Mapper.epce3973901_select2(inputMap)));
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}    
			
			return rtnMap;    	
	    }
	 
	/**
	 * API전송이력조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public HashMap epce3973901_select4(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    //	List<?> menuList = epce3973901Mapper.epce3973901_select3(inputMap);
		//	rtnMap.put("execHistList", util.mapToJson(menuList));
	    	
	    	if(!"".equals(inputMap.get("START_DT"))){
	    		inputMap.put("START_DT", inputMap.get("START_DT").replace("-", ""));
			}  
	
			if(!"".equals(inputMap.get("END_DT"))){
				inputMap.put("END_DT", inputMap.get("END_DT").replace("-", ""));
			} 

	    	try {
				rtnMap.put("execHistList", util.mapToJson(epce3973901Mapper.epce3973901_select3(inputMap)));
				rtnMap.put("totalCnt", epce3973901Mapper.epce3973901_select3_cnt(inputMap));
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}    
	    	
			return rtnMap;    	
	    }
	
		/**
		 * API전송이력조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public HashMap epce3973901_select5(Map<String, String> inputMap, HttpServletRequest request) {
		    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		    	
		    	return epce3973901Mapper.epce3973901_select4(inputMap);    	
		  }

		public String epce3973901_excel(HashMap<String, String> data,HttpServletRequest request) {
			String errCd = "0000";
			
			if(!"".equals(data.get("START_DT"))){
				data.put("START_DT", data.get("START_DT").replace("-", ""));
			}
			
			if(!"".equals(data.get("END_DT"))){
				data.put("END_DT", data.get("END_DT").replace("-", ""));
			}
	    	
			
			try {
		
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
		
				if(vo != null){
					data.put("T_USER_ID", vo.getUSER_ID());
				}
		
				
				data.put("excelYn", "Y");
				List<?> list = epce3973901Mapper.epce3973901_excel(data);
		
				//엑셀파일 저장
				commonceService.excelSave(request, data, list);
		
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch(Exception e){
				return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		
			return errCd;
		}
}
