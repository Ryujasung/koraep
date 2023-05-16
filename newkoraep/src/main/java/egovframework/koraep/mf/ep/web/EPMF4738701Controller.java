package egovframework.koraep.mf.ep.web;

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
import egovframework.koraep.mf.ep.service.EPMF2910101Service;
import egovframework.koraep.mf.ep.service.EPMF4738701Service;
import egovframework.koraep.mf.ep.service.EPMF2983901Service;


/**
 * 입고정정 
 * @author 양성수
 *
 */
@Controller
public class EPMF4738701Controller {  

	@Resource(name = "epmf4738701Service")
	private  EPMF4738701Service epmf4738701Service; 	// 입고정정 service
	
	@Resource(name = "epmf2983901Service")
	private  EPMF2983901Service epmf2983901Service; 	//입고관리 service
	
	@Resource(name = "epmf2910101Service")
	private  EPMF2910101Service epmf2910101Service; 	//반환관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 *  입고정정  페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/MF/EPMF4738701.do", produces = "application/text; charset=utf8")
	public String epmf4738701(HttpServletRequest request, ModelMap model) {

		model =epmf4738701Service.epmf4738701_select(model, request);
		return "/MF/EPMF4738701";
	}
	
	/**
	 *  입고정정 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4738701_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4738701_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf4738701Service.epmf4738701_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 입고정정 도매업자 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4738701_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4738701_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf4738701Service.epmf4738701_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 입고정정   조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4738701_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4738701_select3(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf4738701Service.epmf4738701_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 입고정정 생산자 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4738701_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4738701_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf4738701Service.epmf4738701_select5(inputMap, request)).toString();
	}	
	
	/**
	 * 입고정정   엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4738701_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf4738701_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf4738701Service.epmf4738701_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 입고정정 정정확인 정정반려 확인취소 상태 변경
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4738701_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4738701_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epmf4738701Service.epmf4738701_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	

	//---------------------------------------------------------------------------------------------------------------------
	//	입고정정 내역조회
	//---------------------------------------------------------------------------------------------------------------------
		
	/**
	 * 입고정정 내역조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/MF/EPMF4738764.do", produces = "application/text; charset=utf8")
	public String epmf4738764(HttpServletRequest request, ModelMap model) {

		model =epmf4738701Service.epmf4738764_select(model, request);
		return "/MF/EPMF4738764";
	}
	

	/**
	 * 입고정정내역조회 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4738764_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4738764_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epmf4738701Service.epmf4738764_delete(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	
}
