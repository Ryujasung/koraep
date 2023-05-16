package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.mapper.ce.ep.EPCE3961341Mapper;

/**
 * API전송상세이력 Service
 * @author 유병승
 *
 */
@Service("epce3961341Service")
public class EPCE3961341Service {

	
	
	@Resource(name="epce3961341Mapper")
	private EPCE3961341Mapper epce3961341Mapper;  //API전송상세이력조회 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  // 공통 Mapper
		
	/**
	 * API전송상세이력 버튼명조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public HashMap epce3961341_select4(Map<String, String> inputMap, HttpServletRequest request) {
		  HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		  inputMap.put("REG_DT", inputMap.get("REG_DT").replace("-", ""));
		  
		  return epce3961341Mapper.epce3961341_select4(inputMap);    	
	  }
	
	/**
	 * API전송상세이력조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public HashMap epce3961341_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	if(!"".equals(inputMap.get("START_DT"))){
	    		inputMap.put("START_DT", inputMap.get("START_DT").replace("-", ""));
			}
			
			if(!"".equals(inputMap.get("END_DT"))){
				inputMap.put("END_DT", inputMap.get("END_DT").replace("-", ""));
			}

	    	try {
				rtnMap.put("execHistList", util.mapToJson(epce3961341Mapper.epce3961341_select3(inputMap)));
				rtnMap.put("totalCnt", epce3961341Mapper.epce3961341_select3_cnt(inputMap));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}    
			
			return rtnMap;    	
	  }
	
}
