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
import org.springframework.web.servlet.ModelAndView;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE0150201Service;


/**
 * 직매장/공장관리
 * @author 양성수
 *
 */
@Controller
public class EPCE0150201Controller {  

	@Resource(name = "epce0150201Service")
	private  EPCE0150201Service epce0150201Service; 	// 직매장/공장관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 *  직매장/공장관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE0150201.do", produces = "application/text; charset=utf8")
	public String epce0150201(HttpServletRequest request, ModelMap model) {

		model =epce0150201Service.epce0150201_select(model, request);
		return "/CE/EPCE0150201";
	}
	
	/**
	 *  총괄직매장 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0150201_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0150201_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0150201Service.epce0150201_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0150201_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0150201_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0150201Service.epce0150201_select3(inputMap, request)).toString();
	}	
	
	
	/**
	 * 직매장/공장관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0150201_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0150201_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0150201Service.epce0150201_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	/**
	 * 활동/비활동
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0150201_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0150201_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce0150201Service.epce0150201_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
/***************************************************************************************************************************************************************************************
 * 		직매장/공장관리 저장/ 수정
 ****************************************************************************************************************************************************************************************/
	
	/**
	 *  직매장/공장관리 등록 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE0150231.do", produces = "application/text; charset=utf8")
	public String epce0150231(HttpServletRequest request, ModelMap model) {
		
		model = epce0150201Service.epce0150231_select(model, request);
		
		return "/CE/EPCE0150231";
	}
	
	/**
	 *  직매장/공장관리 변경 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE0150242.do", produces = "application/text; charset=utf8")
	public String epce0150242(HttpServletRequest request, ModelMap model) {
		
		model = epce0150201Service.epce0150242_select(model, request);
		
		return "/CE/EPCE0150242";
	}
		
	
	/**
	 * 직매장구분 변경시
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0150231_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0150231_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce0150201Service.epce0150231_select(data)).toString();
	}
	
	/**
	 * 직매장 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0150231_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0150231_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0150201Service.epce0150231_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 직매장 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0150242_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0150242_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0150201Service.epce0150242_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	

	/***************************************************************************************************************************************************************************************
	 * 					지역 일괄 설정
	 ****************************************************************************************************************************************************************************************/
	
	/**
	 *  지역 일괄 설정 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE0150288.do", produces = "application/text; charset=utf8")
	public String epce0150288(HttpServletRequest request, ModelMap model) {
		model =epce0150201Service.epce0150288_select(model, request);
		return "/CE/EPCE0150288";
	}
	
	/**
	 * 지역 일괄 설정 저장/수정
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0150288_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0150288_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce0150201Service.epce0150288_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 사업자번호 중복체크
	 * @param param
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0150231_3.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0150231_3_CHECK(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		String ableYn = epce0150201Service.epce0150231_3_check(data);
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("USE_ABLE_YN", ableYn);
		
		return util.mapToJson(map).toString();
	}
}
