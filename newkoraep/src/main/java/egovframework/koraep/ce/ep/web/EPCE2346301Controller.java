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
import egovframework.koraep.ce.ep.service.EPCE2346301Service;

/**
 * 수납확인 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE2346301Controller {

	@Resource(name="epce2346301Service")
	private EPCE2346301Service epce2346301Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 수납확인 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2346301.do")
	public String epce2346301(ModelMap model, HttpServletRequest request) {
		
		model = epce2346301Service.epce2346301_select(model, request);
		
		return "/CE/EPCE2346301";
	}

	/**
	 * 고지서 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2346301_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2346301_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce2346301Service.epce2346301_select2(data)).toString();
	}
	
	/**
	 * 가상계좌수납 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2346301_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2346301_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce2346301Service.epce2346301_select3(data)).toString();
	}
	
	/**
	 * 가상계좌번호 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2346301_193.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2346301_select3(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce2346301Service.epce2346301_select4(data)).toString();
	}
	
	/**
	 * 수납확인 저장
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2346301_09.do", produces="application/text; charset=UTF-8")
	@ResponseBody
	public String epce2346301_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		String errCd = "";
		
		try{
			errCd = epce2346301Service.epce2346301_insert(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
		
	}
	
	/**
	 * 착오수납처리
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2346301_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2346301_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce2346301Service.epce2346301_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
}
