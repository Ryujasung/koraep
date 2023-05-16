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
import egovframework.koraep.ce.ep.service.EPCE9000401Service;


/**
 * 지역별출고회수현황
 * @author 양성수
 *
 */
@Controller
public class EPCE9000401Controller {

	@Resource(name = "epce9000401Service")
	private  EPCE9000401Service epce9000401Service; 	//지역별출고회수현황 service

	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	/**
	 * 지역별출고회수현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000401.do", produces = "application/text; charset=utf8")
	public String epce9000401(HttpServletRequest request, ModelMap model) {
		model =epce9000401Service.epce9000401_select(model, request);
		return "/CE/EPCE9000401";
	}

	/**
	 * 지역별출고회수현황  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000401_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000401_select2(@RequestParam Map<String, Object> inputMap, HttpServletRequest request){
		return util.mapToJson(epce9000401Service.epce9000401_select2(inputMap, request)).toString();
	}

}
