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
import egovframework.koraep.wh.ep.service.EPWH0121801Service;

/**
 * 소매거래처관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPWH0121801Controller {

	
	@Resource(name="epwh0121801Service")
	private EPWH0121801Service epwh0121801Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 소매거래처관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0121801.do")
	public String epwh0121801(ModelMap model, HttpServletRequest request) {
		
		model = epwh0121801Service.epwh0121801_select(model, request);
		System.out.println("model = "+model);
		return "/WH/EPWH0121801";
	}
	
	/**
	 * 소매거래처관리  조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0121801_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0121801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epwh0121801Service.epwh0121801_select2(data, request)).toString();
	}
	
	/**
	 * 소매거래처관리 등록 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0121831.do")
	public String epwh0120631(ModelMap model, HttpServletRequest request) {
		
		model = epwh0121801Service.epwh0121831_select(model, request);
		
		return "/WH/EPWH0121831";
	}
	
	/**
	 * 거래처 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0121831_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0121831_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh0121801Service.epwh0121831_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}  
	
	/**
	 * 소매거래처관리 데이터 체크
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0121831_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0121831_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";
		
		try{
			errCd = epwh0121801Service.epwh0121831_select2(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		if(!errCd.equals("0000")){
			rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		}else{
			rtnObj.put("RSLT_MSG","");
		}
		return rtnObj.toString();
	}
	
	/**
	 * 소매거래처관리 데이터 체크 (엑셀저장용)
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0121831_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0121831_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epwh0121801Service.epwh0121831_select3(data, request)).toString();
	}
	
	/**
	 * 거래상태 변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0121801_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0120601_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh0121801Service.epwh0121801_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}  
	
	/**
	 * 소매거래처 변경 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0121888.do")
	public String epwh0140188(ModelMap model, HttpServletRequest request) {
		
		model = epwh0121801Service.epwh0121888_select(model);
		
		return "/WH/EPWH0121888";
	}
	
	/**
	 * 소매거래처 정보 변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0121888_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0121888_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh0121801Service.epwh0121888_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0121801_05.do")
	@ResponseBody
	public String epwh0121801_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh0121801Service.epwh0121801_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
}
