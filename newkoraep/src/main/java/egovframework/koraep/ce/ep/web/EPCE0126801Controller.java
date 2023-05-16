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
import org.springframework.web.servlet.ModelAndView;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE0126801Service;


/**
 * 소매 직매장/공장관리
 * @author 양성수
 *
 */
@Controller
public class EPCE0126801Controller {  

	@Resource(name = "epce0126801Service")
	private  EPCE0126801Service epce0126801Service; 	// 직매장/공장관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 *  직매장/공장관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE0126801.do", produces = "application/text; charset=utf8")
	public String epce0126801(HttpServletRequest request, ModelMap model) {

		model =epce0126801Service.epce0126801_select(model, request);
		return "/CE/EPCE0126801";
	}
	
	/**
	 *   소매업자 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0126801_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0126801_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0126801Service.epce0126801_select4(inputMap, request)).toString();
	}	
	
	
	/**
	 *  총괄직매장 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0126801_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0126801_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0126801Service.epce0126801_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0126801_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0126801_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0126801Service.epce0126801_select3(inputMap, request)).toString();
	}	
	
	
	/**
	 * 직매장/공장관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0126801_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0126801_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0126801Service.epce0126801_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	/**
	 * 활동/비활동
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0126801_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0126801_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce0126801Service.epce0126801_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
/***************************************************************************************************************************************************************************************
 * 		직매장/공장관리 저장/ 수정
 ****************************************************************************************************************************************************************************************/
	
	/**
	 *  직매장/공장관리 등록 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE0126831.do", produces = "application/text; charset=utf8")
	public String epce0126831(HttpServletRequest request, ModelMap model) {
		
		model = epce0126801Service.epce0126831_select(model, request);
		
		return "/CE/EPCE0126831";
	}
	
	/**
	 *  직매장/공장관리 변경 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE0126842.do", produces = "application/text; charset=utf8")
	public String epce0126842(HttpServletRequest request, ModelMap model) {
		
		model = epce0126801Service.epce0126842_select(model, request);
		
		return "/CE/EPCE0126842";
	}
		
	
	/**
	 * 그룹여부 변경시 총괄지점 검색
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0126831_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0126831_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce0126801Service.epce0126831_select(data)).toString();
	}
	
	/**
	 * 직매장 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0126831_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0126831_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0126801Service.epce0126831_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 직매장 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0126842_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0126842_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0126801Service.epce0126842_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	

	/***************************************************************************************************************************************************************************************
	 * 					지역 일괄 설정
	 ****************************************************************************************************************************************************************************************/
	
	/**
	 *  지역 일괄 설정 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE0126888.do", produces = "application/text; charset=utf8")
	public String epce0126888(HttpServletRequest request, ModelMap model) {
		model =epce0126801Service.epce0126888_select(model, request);
		return "/CE/EPCE0126888";
	}
	
	/**
	 * 지역 일괄 설정 저장/수정
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0126888_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0126888_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce0126801Service.epce0126888_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/***************************************************************************************************************************************************************************************
	 * 				단체 설정
	 ****************************************************************************************************************************************************************************************/
	
	/**
	 *  단체 설정 설정 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE01268882.do", produces = "application/text; charset=utf8")
	public String epce01268882(HttpServletRequest request, ModelMap model) {
		model =epce0126801Service.epce01268882_select(model, request);
		return "/CE/EPCE01268882";
	}
	
	/**
	 * 단체 설정 저장/수정
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE01268882_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce01268882_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce0126801Service.epce01268882_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	
	
	
}
