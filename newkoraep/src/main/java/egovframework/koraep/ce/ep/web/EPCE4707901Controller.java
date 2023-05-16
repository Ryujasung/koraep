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
import egovframework.koraep.ce.ep.service.EPCE4707901Service;

/**
 * 교환연간조정 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE4707901Controller {

	@Resource(name="epce4707901Service")
	private EPCE4707901Service epce4707901Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 교환연간조정 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707901.do")
	public String epce4707901(ModelMap model, HttpServletRequest request) {
		model = epce4707901Service.epce4707901_select(model, request);
		
		return "/CE/EPCE4707901";
	}
	
	/**
	 * 교환연간조정 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707901_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0101801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4707901Service.epce4707901_select2(data)).toString();
	}		
	
	//---------------------------------------------------------------------------------------------------------------------
	//	조정수량관리
	//---------------------------------------------------------------------------------------------------------------------
	
	/**
	 * 조정수량관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707988.do")
	public String epce4707988(ModelMap model, HttpServletRequest request) {
		return "/CE/EPCE4707988";
	}
	
	/**
	 * 조정수량관리 초기값  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707988_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4707988_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4707901Service.epce4707988_select(inputMap, request)).toString();
	}	
	
	/**
	 * 조정수량관리 삭제전 데이터 검색
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707988_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4707988_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4707901Service.epce4707988_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 조정수량관리   등록
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707988_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4707988_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		String errCd = "";
		try{
			errCd = epce4707901Service.epce4707988_insert(inputMap, request);
			
		}catch(Exception e){
			errCd = e.getMessage();
		}
		   
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}	
	
	/**
	 * 조정수량관리   삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707988_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4707988_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		String errCd = "";
		try{
			errCd = epce4707901Service.epce4707988_delete(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		   
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}	
	
	
}
