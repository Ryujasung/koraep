package egovframework.koraep.wh.ep.web;

import java.util.HashMap;

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
import egovframework.koraep.wh.ep.service.EPWH0129801Service;

/**
 * 부서관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPWH0129801Controller {

	
	@Resource(name="epwh0129801Service")
	private EPWH0129801Service epwh0129801Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 부서관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0129801.do")
	public String epwh0129801_select(ModelMap model, HttpServletRequest request) {
		
		model = epwh0129801Service.epwh0129801_select(model, request);
		
		return "/WH/EPWH0129801";
	}
	
	/**
	 * 부서관리 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH012980119.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0129801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epwh0129801Service.epwh0129801_select2(data, request)).toString();
	}
	
	/**
	 * 부서관리 등록 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0129831.do")
	public String epwh0129831_select(ModelMap model, HttpServletRequest request) {
		
		model = epwh0129801Service.epwh0129831_select(model, request);
		
		return "/WH/EPWH0129831";
	}
	
	/**
	 * 업체명 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0129831_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0129831_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epwh0129801Service.epwh0129831_select2(data)).toString();
	}
	
	/**
	 * 상위부서코드 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0129831_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0129831_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epwh0129801Service.epwh0129831_select3(data, request)).toString();
	}
	
	/**
	 * 변경페이지
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0129842.do")
	public String epwh0129842_select(ModelMap model, HttpServletRequest request) {
		
		model = epwh0129801Service.epwh0129842_select(model, request);
		
		return "/WH/EPWH0129842";
	}
	/**
	 * 부서코드 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0129831_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0129831_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh0129801Service.epwh0129831_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 부서코드 수정
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0129842_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0129842_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh0129801Service.epwh0129842_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}

	/**
	 * 활동상태 변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0129801_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0129801_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh0129801Service.epwh0129801_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}

}
