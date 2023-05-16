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
import egovframework.koraep.ce.ep.service.EPCE6190101Service;


/**
 * 지역별출고회수현황
 * @author 양성수
 *
 */
@Controller
public class EPCE6190101Controller {

	@Resource(name = "epce6190101Service")
	private  EPCE6190101Service epce6190101Service; 	//지역별출고회수현황 service

	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	/**
	 * 지역별출고회수현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE6190101.do", produces = "application/text; charset=utf8")
	public String epce6190101(HttpServletRequest request, ModelMap model) {
		model =epce6190101Service.epce6190101_select(model, request);
		return "/CE/EPCE6190101";
	}

	/**
	 * 지역별출고회수현황  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6190101_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6190101_select2(@RequestParam Map<String, Object> inputMap, HttpServletRequest request){
		return util.mapToJson(epce6190101Service.epce6190101_select2(inputMap, request)).toString();
	}

}
