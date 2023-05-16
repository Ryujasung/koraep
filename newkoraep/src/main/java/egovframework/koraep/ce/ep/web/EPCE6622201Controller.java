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
import egovframework.koraep.ce.ep.service.EPCE6622201Service;

/**
 *  입고확인취소요청조회 Controller
 * @author 양성수
 *
 */
@Controller
public class EPCE6622201Controller {
	
	
	@Resource(name = "epce6622201Service")
	private EPCE6622201Service epce6622201Service; 	//실행이력조회 service

	/**
	 * 실행이력조회 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE6622201.do", produces = "application/text; charset=utf8")
	public String epce6622201(HttpServletRequest request, ModelMap model) {

		//언어구분 리스트 , 용어구분 리스트 
		model =epce6622201Service.epce6622201_select(model,request);
		
		
	return "/CE/EPCE6622201";
	}
	
	/**
	 * 입고확인취소요청조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6622201_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6622201_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce6622201Service.epce6622201_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 입고확인취소요청조회 상세조회
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE6622288.do", produces = "application/text; charset=utf8")
	public String epceEPCE3961264(HttpServletRequest request, ModelMap model) {
		return "/CE/EPCE6622288";
	}
	
	/**
	 * 입고확인취소요청조회 사유 팝업
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6622201_191.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6622201_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce6622201Service.epce6622201_select3(inputMap, request)).toString();
	}	
	
	
}
