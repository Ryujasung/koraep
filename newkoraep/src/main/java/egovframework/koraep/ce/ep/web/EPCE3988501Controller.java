
package egovframework.koraep.ce.ep.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE3988501Service;

/**
 * 등록일자제한설정  
 * @author 양성수
 *
 */   
@Controller  
public class EPCE3988501Controller {  

	@Resource(name = "epce3988501Service")
	private  EPCE3988501Service epce3988501Service; 	//등록일자제한설정 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service
	
	/**
	 * 등록일자제한설정 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE3988501.do", produces = "application/text; charset=utf8")
	public String epce3988501(HttpServletRequest request, ModelMap model) {
		model =epce3988501Service.epce3988501_select(model, request);
		return "/CE/EPCE3988501";
	}
	
	/**
	 * 등록일자제한설정 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3988501_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3988501_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3988501Service.epce3988501_select2(inputMap, request)).toString();
	}	    
	
	/**
	 * 등록일자제한설정  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */									
	@RequestMapping(value="/CE/EPCE3988501_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3988501_insert(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = epce3988501Service.epce3988501_insert(data, request);
			
		}catch(Exception e){
			errCd = e.getMessage();
		}
		   
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
}
