package egovframework.koraep.ce.ep.web;

import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE4718501Service;

/**
 * 연간출고량조정 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE4718501Controller {

	@Resource(name="epce4718501Service")
	private EPCE4718501Service epce4718501Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 연간출고량조정 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4718501.do")
	public String epce4718501(ModelMap model, HttpServletRequest request) {
		
		model = epce4718501Service.epce4718501_select(model, request);
		
		return "/CE/EPCE4718501";
	}
	
	/**
	 * 연간출고량조정 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4718501_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0101801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4718501Service.epce4718501_select2(data)).toString();
	}
	
}
