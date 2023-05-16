package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE3988501Mapper;

/**
 * 등록일자제한설정 Service
 * @author 양성수
 *
 */
@Service("epce3988501Service")
public class EPCE3988501Service {
	
	
	@Resource(name="epce3988501Mapper")
	private EPCE3988501Mapper epce3988501Mapper;  //등록일자제한설정 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 입고정정 확인 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce3988501_select(ModelMap model, HttpServletRequest request) {
			try { 
					model.addAttribute("work_se_list", util.mapToJson(commonceService.getCommonCdListNew("S016")));  	//업무구분
					model.addAttribute("rtc_dt_se_list", util.mapToJson(commonceService.getCommonCdListNew("S018"))); //제한일자구분
					model.addAttribute("selList", util.mapToJson(epce3988501Mapper.epce3988501_select()));    
			} catch (Exception e) {             
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}   	          
			return model;         	
	  }
	  /**
		 * 등록일자제한설정 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
	  public HashMap epce3988501_select2(Map<String, String> inputMap, HttpServletRequest request) {
			HashMap<String, Object> rtnMap = new HashMap<String, Object>();
			try {
					rtnMap.put("selList", util.mapToJson(epce3988501Mapper.epce3988501_select()));
			} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	  
			return rtnMap;    	
	  }
		
		/**
		 * 등록일자제한설정 저장
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epce3988501_insert(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			try {
				
						
						inputMap.put("REG_PRSN_ID", vo.getUSER_ID());				//등록자
						 epce3988501Mapper.epce3988501_insert(inputMap);		
			}catch (Exception e) {
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return errCd;    	
	    }
}
