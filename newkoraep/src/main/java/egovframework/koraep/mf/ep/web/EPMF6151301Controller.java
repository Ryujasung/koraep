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
import egovframework.koraep.mf.ep.service.EPMF6151301Service;


/**
 * 상세직접회수현황
 * @author 이내희
 *
 */
@Controller
public class EPMF6151301Controller {  

	@Resource(name = "epmf6151301Service")
	private  EPMF6151301Service epmf6151301Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 상세직접회수현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/MF/EPMF6151301.do", produces = "application/text; charset=utf8")
	public String epmf6151301(HttpServletRequest request, ModelMap model) {
		model =epmf6151301Service.epmf6151301_select(model, request);
		return "/MF/EPMF6151301";
	}
	
	/**
	 * 상세직접회수현황 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6151301_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf6151301_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf6151301Service.epmf6151301_select2(data, request)).toString();
	}
	
	/**
	 * 생산자변경시 생산자에맞는 빈용기명, 직매장 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6151301_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6151301_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf6151301Service.epmf6151301_select3(inputMap, request)).toString();
	}
	
	/**
	 * 상세직접회수현황  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6151301_05.do")
	@ResponseBody
	public String epmf6151301_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf6151301Service.epmf6151301_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
}
