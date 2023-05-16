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
import egovframework.koraep.ce.ep.service.EPCE2351901Service;

/**
 * 보증금고지서 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE2351901Controller {

	@Resource(name="epce2351901Service")
	private EPCE2351901Service epce2351901Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 보증금고지서 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2351901.do")
	public String epce2351901(ModelMap model, HttpServletRequest request) {
		
		model = epce2351901Service.epce2351901_select(model, request);
		
		return "/CE/EPCE2351901";
	}
	
	/**
	 * 보증금고지서 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2351901_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0101801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce2351901Service.epce2351901_select2(data)).toString();
	}
	
	/**
	 * 보증금고지서 발급
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2351901_09.do", produces="application/text; charset=UTF-8")
	@ResponseBody
	public String epce2371201_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		String errCd = "";
		
		try{
			errCd = epce2351901Service.epce2351901_insert(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
		
	}
	
	/**
	 * 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2351901_05.do")
	@ResponseBody
	public String epce2351901_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce2351901Service.epce2351901_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
}
