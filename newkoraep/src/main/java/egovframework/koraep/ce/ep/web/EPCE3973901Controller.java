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
import egovframework.koraep.ce.ep.service.EPCE3973901Service;

/**
 *  API전송이력조회 Controller
 * @author 김도연
 *
 */
@Controller
public class EPCE3973901Controller {
	
	
	@Resource(name = "epce3973901Service")
	private EPCE3973901Service epce3973901Service; 	//API전송이력조회 service

	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * API전송이력조회 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE3973901.do", produces = "application/text; charset=utf8")
	public String epce3973901(HttpServletRequest request, ModelMap model) {

		//언어구분 리스트 , 용어구분 리스트 
		model =epce3973901Service.epce3973901_select(model,request);
		
		
	return "/CE/EPCE3973901";
	}
	
	
	/**
	 * API전송이력조회 메뉴명조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3973901_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3973901_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3973901Service.epce3973901_select2(inputMap, request)).toString();
	}	
	
	/**
	 * API전송이력조회 버튼명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3973901_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3973901_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3973901Service.epce3973901_select3(inputMap, request)).toString();
	}	
	
	/**
	 * API전송이력조회 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3973901_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3973901_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3973901Service.epce3973901_select4(inputMap, request)).toString();
		
		
		
	}	

	/**
	 * API전송이력조회 조회 PRAM
	 * @param inputMap
	 * @param request
	 * @return
	 *  
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3973901_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3973901_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3973901Service.epce3973901_select5(inputMap, request)).toString();
		
	}	
	
	/**
	 * API전송이력조회 상세조회 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE3973964.do", produces = "application/text; charset=utf8")
	public String epceEPCE3973964(HttpServletRequest request, ModelMap model) {
		    
	return "/CE/EPCE3973964";
	}

	
	/**
	 * API 전송이력조회 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3973901_05.do")
	@ResponseBody
	public String epce397390_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce3973901Service.epce3973901_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	

}
