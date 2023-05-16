package egovframework.koraep.ce.ep.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE6150601Service;


/**
 * 직접회수현황
 * @author 이내희
 *
 */
@Controller
public class EPCE6150601Controller {  

	@Resource(name = "epce6150601Service")
	private  EPCE6150601Service epce6150601Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 직접회수현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE6150601.do", produces = "application/text; charset=utf8")
	public String epce6150601(HttpServletRequest request, ModelMap model) {
		model =epce6150601Service.epce6150601_select(model, request);
		return "/CE/EPCE6150601";
	}
	
	/**
	 * 직접회수현황 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6150601_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6150601_select(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce6150601Service.epce6150601_select2(data)).toString();
	}
	
	/**
	 * 생산자변경시 직매장 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6150601_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6150601_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce6150601Service.epce6150601_select3(inputMap, request)).toString();
	}
	
	/**
	 * 직접회수현황  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6150601_05.do")
	@ResponseBody
	public String epce6150601_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce6150601Service.epce6150601_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
}
