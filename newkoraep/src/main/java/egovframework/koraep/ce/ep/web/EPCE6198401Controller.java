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
import egovframework.koraep.ce.ep.service.EPCE6198401Service;


/**
 * 출고대비초과회수현황
 * @author 양성수
 *
 */
@Controller
public class EPCE6198401Controller {  

	@Resource(name = "epce6198401Service")
	private  EPCE6198401Service epce6198401Service; 	//출고대비초과회수현황 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 출고대비초과회수현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE6198401.do", produces = "application/text; charset=utf8")
	public String epce6198401(HttpServletRequest request, ModelMap model) {

		model =epce6198401Service.epce6198401_select(model, request);
		return "/CE/EPCE6198401";
	}      
	
	/**
	 *  직매장 조회 ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6198401_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6198401_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce6198401Service.epce6198401_select2(inputMap, request)).toString();
	}	
	
	/**
	 *  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6198401_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6198401_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce6198401Service.epce6198401_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 출고대비초과회수현황  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6198401_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6198401_select3(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce6198401Service.epce6198401_select4(inputMap, request)).toString();
	}															   
	
	/**
	 * 출고대비초과회수현황  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6198401_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6198401_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = epce6198401Service.epce6198401_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
}