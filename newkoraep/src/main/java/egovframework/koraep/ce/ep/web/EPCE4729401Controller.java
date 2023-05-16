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
import egovframework.koraep.ce.ep.service.EPCE4729401Service;

/**
 * 생산자정산 수납확인 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE4729401Controller {

	@Resource(name="epce4729401Service")
	private EPCE4729401Service epce4729401Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 생산자정산 수납확인 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4729401.do")
	public String epce4729401(ModelMap model, HttpServletRequest request) {
		
		model = epce4729401Service.epce4729401_select(model, request);
		
		return "/CE/EPCE4729401";
	}

	/**
	 * 고지서 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4729401_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce4729401_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4729401Service.epce4729401_select2(data)).toString();
	}
	
	/**
	 * 가상계좌수납 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4729401_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce4729401_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4729401Service.epce4729401_select3(data)).toString();
	}
	
	/**
	 * 가상계좌번호 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4729401_193.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce4729401_select3(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4729401Service.epce4729401_select4(data)).toString();
	}
	
	/**
	 * 생산자정산 수납확인 저장
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4729401_09.do", produces="application/text; charset=UTF-8")
	@ResponseBody
	public String epce4729401_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		String errCd = "";
		
		try{
			errCd = epce4729401Service.epce4729401_insert(inputMap, request);
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
	@RequestMapping(value="/CE/EPCE4729401_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce4729401_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce4729401Service.epce4729401_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
}
