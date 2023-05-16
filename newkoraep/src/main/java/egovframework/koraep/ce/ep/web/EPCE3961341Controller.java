package egovframework.koraep.ce.ep.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.EPCE3961341Service;

/**
 *  API전송상세이력 Controller
 * @author 유병승
 *
 */
@Controller
public class EPCE3961341Controller {
	
	@Resource(name = "epce3961341Service")
	private EPCE3961341Service epce3961341Service; 	//오류이력조회 service

	/**
	 * API전송상세이력 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE3961341.do", produces = "application/text; charset=utf8")
	public String epce3961341(HttpServletRequest request, ModelMap model) {
		return "/CE/EPCE3961341";
	}
	
	/**
	 * API전송상세이력 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3961341_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3961341_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3961341Service.epce3961341_select3(inputMap, request)).toString();
		
	}	

	/**
	 * 오류이력조회 상세조회 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE3961366.do", produces = "application/text; charset=utf8")
	public String epceEPCE3961364(HttpServletRequest request, ModelMap model) {
		return "/CE/EPCE3961366";
	}
	
	/**
	 * 오류이력조회 조회 PRAM
	 * @param inputMap
	 * @param request
	 * @return
	 *  
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3961366_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE39613412_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3961341Service.epce3961341_select4(inputMap, request)).toString();
		
	}	

}
