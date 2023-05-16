package egovframework.koraep.mf.ep.web;

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
import egovframework.koraep.mf.ep.service.EPMF0130101Service;
import net.sf.json.JSONObject;

/**
 * 지급관리시스템입고정보
 * @author 유병승
 *
 */
@Controller
public class EPMF0130101Controller {

	@Resource(name = "epmf0130101Service")
	private  EPMF0130101Service epmf0130101Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService;//공통  service

	
	/**
	 * 지급관리시스템입고정보 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF0130101.do", produces = "application/text; charset=utf8")
	public String epmf0130101(HttpServletRequest request, ModelMap model) {
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);
		return "/MF/EPMF0130101";
	}
	
	/**
	 * 지급관리시스템입고정보  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0130101_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf0130101_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf0130101Service.epmf0130101_select(inputMap, request)).toString();
	}	
	
}
