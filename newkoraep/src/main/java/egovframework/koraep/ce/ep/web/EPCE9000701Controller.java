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
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE9000701Service;


/**
 * 지역별무인회수기현황
 * @author 양성수
 *
 */
@Controller
public class EPCE9000701Controller {

	@Resource(name = "epce9000701Service")
	private  EPCE9000701Service epce9000701Service; 	//지역별출고회수현황 service

	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service
	
	/**
	 * 지역별무인회수기현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000701.do", produces = "application/text; charset=utf8")
	public String epce9000701(HttpServletRequest request, ModelMap model) {
		model =epce9000701Service.epce9000701_select(model, request);
		return "/CE/EPCE9000701";
	}

	/**
	 * 지역별무인회수기현황  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000701_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000701_select2(@RequestParam Map<String, Object> inputMap, HttpServletRequest request){
		return util.mapToJson(epce9000701Service.epce9000701_select2(inputMap, request)).toString();
	}
	
	/**
	 * 월별 회수량 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000761.do")
	public String epce6187261(ModelMap model, HttpServletRequest request){
		model = epce9000701Service.epce9000761_select(model, request);
		System.out.println("model"+model);
		return "/CE/EPCE9000761";
	}	
	
	

}
