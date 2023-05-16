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
import egovframework.koraep.ce.ep.service.EPCE0122701Service;

/**
 * 기준보증금관리 Controller
 * @author 양성수
 *
 */
@Controller
public class EPCE0122701Controller {

	@Resource(name = "epce0122701Service")
	private  EPCE0122701Service epce0122701Service; 	//기준보증금관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 *기준보증금관리 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0122701.do", produces = "application/text; charset=utf8")
	public String epce0122701(HttpServletRequest request, ModelMap model) {
		
		model=   epce0122701Service.epce0122701_select(model, request);

	return "/CE/EPCE0122701";
	}
	
	/**
	 * 기준보증금관리 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0122701_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0122701_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0122701Service.epce0122701_delete(inputMap, request)).toString();
	}	
	
	
	/**
	 *기준보증금등록 초기화면     
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0122731.do", produces = "application/text; charset=utf8")
	public String epce0122731(HttpServletRequest request, ModelMap model) {
		model=   epce0122701Service.epce0122731_select(model, request);

	return "/CE/EPCE0122731";
	}
	
	/**
	 * 기준보증금등록 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0122731_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0122731_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0122701Service.epce0122731_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	
	
	
	/**
	 *기준보증금변경 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0122742.do", produces = "application/text; charset=utf8")
	public String epce0122742(HttpServletRequest request, ModelMap model) {
		model=   epce0122701Service.epce0122742_select(model, request);

	return "/CE/EPCE0122742";
	}
	
	
	/**
	 * 기준보증금변경 변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0122742_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0122742_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0122701Service.epce0122742_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	
}
