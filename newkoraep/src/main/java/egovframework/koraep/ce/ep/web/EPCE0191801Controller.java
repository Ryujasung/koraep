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
import egovframework.koraep.ce.ep.service.EPCE0191801Service;

/**
 * 기준취급수수료관리 Controller
 * @author 양성수
 *
 */
@Controller
public class EPCE0191801Controller{

	@Resource(name = "epce0191801Service")
	private  EPCE0191801Service epce0191801Service; 	//기준취급수수료관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 *기준취급수수료관리 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0191801.do", produces = "application/text; charset=utf8")
	public String epce0191801(HttpServletRequest request, ModelMap model) {
		
		model=   epce0191801Service.epce0191801_select(model, request);

	return "/CE/EPCE0191801";
	}
	
	/**
	 * 기준취급수수료관리 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0191801_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0191801_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0191801Service.epce0191801_delete(inputMap, request)).toString();
	}	
	
	
	/**
	 *기준취급수수료등록 초기화면     
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0191831.do", produces = "application/text; charset=utf8")
	public String epce0191831(HttpServletRequest request, ModelMap model) {
		model=   epce0191801Service.epce0191831_select(model, request);

	return "/CE/EPCE0191831";
	}
	
	/**
	 * 기준취급수수료등록 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0191831_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0191831_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0191801Service.epce0191831_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	
	
	
	/**
	 *  기준취급수수료변경 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0191842.do", produces = "application/text; charset=utf8")
	public String epce0191842(HttpServletRequest request, ModelMap model) {
		model=   epce0191801Service.epce0191842_select(model, request);

	return "/CE/EPCE0191842";
	}
	
	
	/**
	 * 기준취급수수료변경 변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0191842_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0191842_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0191801Service.epce0191842_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	
}
