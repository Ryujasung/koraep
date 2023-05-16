package egovframework.koraep.ce.ep.web;

import java.util.HashMap;

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
import egovframework.koraep.ce.ep.service.EPCE3991801Service;

/**
 * 버튼권한관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE3991801Controller {

	
	@Resource(name="epce3991801Service")
	private EPCE3991801Service epce3991801Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 버튼권한관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3991801.do")
	public String epce3991801(ModelMap model, HttpServletRequest request) {
		
		model = epce3991801Service.epce3991801_select(model, request);
		
		return "/CE/EPCE3991801";
	}
	
	/**
	 * 버튼 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3991801_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3991801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce3991801Service.epce3991801_select2(data)).toString();
	}

	/**
	 * 권한저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3991801_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3991801_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce3991801Service.epce3991801_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 버튼일괄적용 팝업호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3991888.do")
	public String epce3991888(ModelMap model, HttpServletRequest request) {

		model = epce3991801Service.epce3991888_select(model, request);
		
		return "/CE/EPCE3991888";
	}
	
	/**
	 * 버튼일괄적용 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3991888_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3991888_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce3991801Service.epce3991888_select2(data)).toString();
	}
	
	/**
	 * 버튼권한 일괄저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3991888_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3991888_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce3991801Service.epce3991888_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
}
