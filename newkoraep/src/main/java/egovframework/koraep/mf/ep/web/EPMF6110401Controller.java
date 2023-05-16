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
import egovframework.koraep.mf.ep.service.EPMF6110401Service;


/**
 * 입고현황
 * @author 양성수
 *
 */
@Controller
public class EPMF6110401Controller {  

	@Resource(name = "epmf6110401Service")
	private  EPMF6110401Service epmf6110401Service; 	//입고현황 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 입고현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/MF/EPMF6110401.do", produces = "application/text; charset=utf8")
	public String epmf6110401(HttpServletRequest request, ModelMap model) {

		model =epmf6110401Service.epmf6110401_select(model, request);
		return "/MF/EPMF6110401";
	}
	
	/**
	 *  입고현황  생산자에 따른 도매업자 업체명 조회, 빈용기조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6110401_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6110401_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf6110401Service.epmf6110401_select2(inputMap, request)).toString();
	}	
	
	/**
	 *  입고현황  생산자에 따른 도매업자 빈용기조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6110401_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6110401_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf6110401Service.epmf6110401_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 입고현황  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6110401_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6110401_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf6110401Service.epmf6110401_select4(inputMap, request)).toString();
	}															   
	
	/**
	 * 입고현황  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6110401_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf6110401_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf6110401Service.epmf6110401_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
}
