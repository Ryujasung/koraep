package egovframework.koraep.mf.ep.web;

import java.util.HashMap;
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
import egovframework.koraep.mf.ep.service.EPMF0130201Service;
import net.sf.json.JSONObject;

/**
 * 생산자ERP입고정보
 * @author 유병승
 *
 */
@Controller
public class EPMF0130201Controller {

	@Resource(name = "epmf0130201Service")
	private  EPMF0130201Service epmf0130201Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;//공통 service

	/**
	 * 생산자ERP입고정보 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF0130201.do", produces = "application/text; charset=utf8")
	public String epmf0130201(HttpServletRequest request, ModelMap model) {
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);
		return "/MF/EPMF0130201";
	}

	/**
	 * 생산자ERP입고정보  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0130201_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf0130201_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf0130201Service.epmf0130201_select(inputMap, request)).toString();
	}

	/**
	 * 생산자ERP입고정보 삭제
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0130201_04.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf3960201_delete(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = epmf0130201Service.epmf0130201_delete(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}

}
