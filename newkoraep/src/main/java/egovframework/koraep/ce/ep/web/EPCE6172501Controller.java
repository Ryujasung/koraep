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
import egovframework.koraep.ce.ep.service.EPCE6172501Service;

/**
 * 회수대비반환 통계현황
 * @author 이근표
 *
 */
@Controller
public class EPCE6172501Controller {  

	@Resource(name = "epce6172501Service")
	private  EPCE6172501Service epce6172501Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService;

	
	/**
	 * 회수대비반환 통계현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE6172501.do", produces = "application/text; charset=utf8")
	public String epce6172501(HttpServletRequest request, ModelMap model) {

		model = epce6172501Service.epce6172501_select(model, request);
		
		return "/CE/EPCE6172501";
	}

	
	/**
	 * 회수대비반환 통계현황 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6172501_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6172501_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce6172501Service.epce6172501_select2(data)).toString();
	}

	
	/**
	 * 회수대비반환 통계현황  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6172501_05.do")
	@ResponseBody
	public String epce6172501_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce6172501Service.epce6172501_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}


	/**
	 * 회수대비반환 통계현황 - 상세정보 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE6172542.do", produces = "application/text; charset=utf8")
	public String epce6172542(HttpServletRequest request, ModelMap model) {

		model = epce6172501Service.epce6172542_select(model, request);
		
		return "/CE/EPCE6172542";
	}

	
	/**
	 * 회수대비반환 통계현황 - 회수량조정 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE6172588.do")
	public String epce6172588(HttpServletRequest request, ModelMap model) {

		model = epce6172501Service.epce6172588_select(model, request);
		
		return "/CE/EPCE6172588";
	}

	
	/**
	 * 상세정보 저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6172542_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6172521_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epce6172501Service.epce6172542_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
		
	}
	
	
	/**
	 * 회수량조정 저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6172588_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6172588_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epce6172501Service.epce6172588_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
		
	}
}
