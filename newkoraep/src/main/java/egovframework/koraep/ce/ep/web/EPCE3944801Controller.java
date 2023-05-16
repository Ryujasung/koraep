package egovframework.koraep.ce.ep.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE3944801Service;
import egovframework.koraep.ce.ep.service.EPCE3944888Service;

/**
 * 다국어관리 Controller
 * 
 * @author 양성수
 * 
 */
@Controller
public class EPCE3944801Controller {


	@Resource(name = "epce3944801Service")
	private EPCE3944801Service epce3944801Service; 	//다국어관리 service

	@Resource(name="epce3944888Service")
	private EPCE3944888Service epce3944888Service; //언어구분관리 service
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	private static final Logger log = LoggerFactory.getLogger(EPCE3944801Controller.class);

	/**
	 * 다국어관리 페이지 호출
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/CE/EPCE3944801.do", produces = "application/text; charset=utf8")
	public String epce3944801(HttpServletRequest request, ModelMap model) {

		
		//언어구분 리스트 , 용어구분 리스트 
		model =epce3944801Service.epce3944801_select(model,request);
		
		return "/CE/EPCE3944801";
	}
	
	/**
	 * 다국어관리 용어구분 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @ek
	 */
	@RequestMapping(value="/CE/EPCE3944801_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3944801_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3944801Service.epce3944801_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 다국어관리 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */                                 
	//관리지  다국어   기본페이지   검색    2번째 조회 function
	@RequestMapping(value="/CE/EPCE3944801_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3944801_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3944801Service.epce3944801_select3(inputMap, request)).toString();
	}	
	
	/**
	 *  다국어관리 저장 수정 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3944801_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3944801_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {

	    String errCd = "";
		try{
			errCd = epce3944801Service.epce3944801_select4(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
		
	
	/**
	 * 다국어관리 저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3944801_09.do", produces="application/text; charset=utf8")
	@ResponseBody
    @Transactional
	public String epce3944801_insert(@RequestParam Map<String, String> data, HttpServletRequest request)  {
	
	    String errCd = "";
		
		try{
			errCd = epce3944801Service.epce3944801_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 다국어관리 수정
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3944801_21.do", produces="application/text; charset=utf8")
	@ResponseBody
    @Transactional
	public String epce3944801_update(@RequestParam Map<String, String> data, HttpServletRequest request)  {

	    String errCd = "";
		
		try{
			errCd = epce3944801Service.epce3944801_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	

}