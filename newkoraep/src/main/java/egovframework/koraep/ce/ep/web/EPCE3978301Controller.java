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
import egovframework.koraep.ce.ep.service.EPCE3978301Service;

/**
 * 메뉴권한관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE3978301Controller {

	
	@Resource(name="epce3978301Service")
	private EPCE3978301Service epce3978301Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 메뉴권한관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3978301.do")
	public String epce3978301(ModelMap model, HttpServletRequest request) {
		
		model = epce3978301Service.epce3978301_select(model, request);
		
		return "/CE/EPCE3978301";
	}
	
	/**
	 * 권한그룹 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3978301_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3978301_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce3978301Service.epce3978301_select2(data)).toString();
	}
	
	/**
	 * 메뉴 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3978301_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3978301_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce3978301Service.epce3978301_select3(data)).toString();
	}
	
	/**
	 * 권한저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3978301_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3978301_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce3978301Service.epce3978301_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
}
