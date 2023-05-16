package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE3961201Mapper;


/**
 * 실행이력조회 Service
 * @author 양성수
 *
 */
@Service("epce3961201Service")
public class EPCE3961201Service {

	@Resource(name="epce3961201Mapper")
	private EPCE3961201Mapper epce3961201Mapper;  //실행이력조회 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  // 공통 Mapper

	/**
	 * 실행이력 초기값 셋팅
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3961201_select(ModelMap model, HttpServletRequest request) {
		
		String  GRP_CD ="M002";
		List<?> workSeList  = commonceService.getCommonCdListNew(GRP_CD);   // 업무구분리스트
		List<?> menuSetList = commonceService.getCommonCdListNew("M001");	//메뉴SET
		
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);
		try {
			model.addAttribute("workSeList", util.mapToJson(workSeList));  
			model.addAttribute("menuSetList", util.mapToJson(menuSetList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		return model;
		
	}
	
	/**
	 * 실행이력 메뉴명조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public HashMap epce3961201_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
				rtnMap.put("menuNm", util.mapToJson(epce3961201Mapper.epce3961201_select(inputMap)));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}    
			
			return rtnMap;    	
	    }
	  
	/**
	 * 실행이력 버튼명조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public HashMap epce3961201_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
				rtnMap.put("btnNm", util.mapToJson(epce3961201Mapper.epce3961201_select2(inputMap)));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}    
			
			return rtnMap;    	
	    }
	
	/**
	 * 실행이력조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public HashMap epce3961201_select4(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	if(!"".equals(inputMap.get("START_DT"))){
	    		inputMap.put("START_DT", inputMap.get("START_DT").replace("-", ""));
			}
			
			if(!"".equals(inputMap.get("END_DT"))){
				inputMap.put("END_DT", inputMap.get("END_DT").replace("-", ""));
			}

	    	try {
				rtnMap.put("execHistList", util.mapToJson(epce3961201Mapper.epce3961201_select3(inputMap)));
				rtnMap.put("totalCnt", epce3961201Mapper.epce3961201_select3_cnt(inputMap));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}    
			
			return rtnMap;    	
	    }
	
		/**
		 * 실행이력조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public HashMap epce3961201_select5(Map<String, String> inputMap, HttpServletRequest request) {
			  
		    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		    	rtnMap.put("execHistPram", epce3961201Mapper.epce3961201_select4(inputMap));    
		    	return rtnMap;    	
		  }

		public String epce3961201_excel(HashMap<String, String> data,HttpServletRequest request) {
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
				List<?> list = epce3961201Mapper.epce3961201_excel(data);
		
				//엑셀파일 저장
				commonceService.excelSave(request, data, list);
		
			}catch(Exception e){
				return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		
			return errCd;
		}
	
}
