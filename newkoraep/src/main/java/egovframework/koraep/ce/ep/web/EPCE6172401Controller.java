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
import egovframework.koraep.ce.ep.service.EPCE6172401Service;

/**
 * 신구병 통계현황
 * @author 이내희
 *
 */
@Controller
public class EPCE6172401Controller {  

	@Resource(name = "epce6172401Service")
	private  EPCE6172401Service epce6172401Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService;

	
	/**
	 * 신구병 통계현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE6172401.do", produces = "application/text; charset=utf8")
	public String epce6172401(HttpServletRequest request, ModelMap model) {

		model = epce6172401Service.epce6172401_select(model, request);
		
		return "/CE/EPCE6172401";
	}
	
	/**
	 * 신구병 통계현황 - 생산자 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE61724012.do", produces = "application/text; charset=utf8")
	public String epce61724012(HttpServletRequest request, ModelMap model) {

		model = epce6172401Service.epce61724012_select(model, request);
		
		return "/CE/EPCE61724012";
	}
	
	/**
	 * 신구병 통계현황 - 상세정보 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE6172442.do", produces = "application/text; charset=utf8")
	public String epce6172442(HttpServletRequest request, ModelMap model) {

		model = epce6172401Service.epce6172442_select(model, request);
		
		return "/CE/EPCE6172442";
	}
	
	/**
	 * 상세정보 저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6172442_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6172421_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epce6172401Service.epce6172442_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
		
	}
	
	/**
	 * 신구병 통계현황 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6172401_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6172401_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce6172401Service.epce6172401_select2(data)).toString();
	}
	
	/**
	 * 신구병 통계현황  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6172401_05.do")
	@ResponseBody
	public String epce6172401_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce6172401Service.epce6172401_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 신구병 통계현황 - 생산자 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE61724012_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce61724012_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce6172401Service.epce61724012_select2(data)).toString();
	}
	
	/**
	 * 신구병 통계현황 - 생산자  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE61724012_05.do")
	@ResponseBody
	public String epce61724012_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce6172401Service.epce61724012_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 반환량조정 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6172488.do")
	public String epce6172488(ModelMap model, HttpServletRequest request) {
		model = epce6172401Service.epce6172488_select(model, request);
		
		return "/CE/EPCE6172488";
	}
	
	/**
	 * 반환량조정 저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6172488_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6172488_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epce6172401Service.epce6172488_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
		
	}
	
}
