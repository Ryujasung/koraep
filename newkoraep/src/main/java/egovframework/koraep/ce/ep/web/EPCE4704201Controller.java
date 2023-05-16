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
import egovframework.koraep.ce.ep.service.EPCE2910101Service;
import egovframework.koraep.ce.ep.service.EPCE4704201Service;
import egovframework.koraep.ce.ep.service.EPCE2983901Service;


/**
 * 입고정정 확인
 * @author 양성수
 *
 */
@Controller
public class EPCE4704201Controller {  

	@Resource(name = "epce4704201Service")
	private  EPCE4704201Service epce4704201Service; 	// 입고정정 확인 service
	
	@Resource(name = "epce2983901Service")
	private  EPCE2983901Service epce2983901Service; 	//입고관리 service
	
	@Resource(name = "epce2910101Service")
	private  EPCE2910101Service epce2910101Service; 	//반환관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 *  입고정정 확인 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE4704201.do", produces = "application/text; charset=utf8")
	public String epce4704201(HttpServletRequest request, ModelMap model) {

		model =epce4704201Service.epce4704201_select(model, request);
		return "/CE/EPCE4704201";
	}
	
	/**
	 *  입고정정  생산자에 따른 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4704201_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4704201_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4704201Service.epce4704201_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 입고정정 생산자 직매장/공장 선택시  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4704201_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4704201_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4704201Service.epce4704201_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 입고정정 확인  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4704201_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4704201_select3(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4704201Service.epce4704201_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 입고정정 확인  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4704201_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce4704201_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce4704201Service.epce4704201_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	/**
	 * 입고정정 확인요청취소
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4704201_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4704201_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce4704201Service.epce4704201_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
}
