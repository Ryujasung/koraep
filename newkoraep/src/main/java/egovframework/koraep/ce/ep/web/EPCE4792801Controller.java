package egovframework.koraep.ce.ep.web;

import java.util.HashMap;
import java.util.Map;

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
import egovframework.koraep.ce.ep.service.EPCE4792801Service;

/**
 * 도매업자정산발급 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE4792801Controller {

	@Resource(name="epce4792801Service")
	private EPCE4792801Service epce4792801Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 도매업자정산발급 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4792801.do")
	public String epce4792801(ModelMap model, HttpServletRequest request) {
		model = epce4792801Service.epce4792801_select(model, request);
		
		return "/CE/EPCE4792801";
	}
	
	/**
	 * 도매업자정산내역 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4792864.do")
	public String epce4792864(ModelMap model, HttpServletRequest request) {
		model = epce4792801Service.epce4792864_select(model, request);
		
		return "/CE/EPCE4792864";
	}
	
	/**
	 * 도매업자정산발급 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4792801_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0101801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4792801Service.epce4792801_select2(data)).toString();
	}
	
	/**
	 * 도매업자 정산서발급 
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4792801_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4792801_insert(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epce4792801Service.epce4792801_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
		
	}
}
