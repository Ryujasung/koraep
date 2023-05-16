package egovframework.koraep.ce.ep.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;








import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE3944888Service;
import egovframework.koraep.ce.ep.service.EPCE3944801Service;
import egovframework.koraep.ce.ep.service.EPCE3968101Service;

/**
 *  기타코드관리 Controller
 * @author 양성수
 *
 */
@Controller
public class EPCE3968101Controller {

	
	@Resource(name = "epce3968101Service")
	private EPCE3968101Service epce3968101Service;  //기타코드관리 service
	
	@Resource(name = "epce3944888Service")
	private EPCE3944888Service epce3944888Service; //언어구분관리 service
	
	@Resource(name = "epce3944801Service")
	private EPCE3944801Service epce3944801Service; 	//다국어관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; //공통 service

	private static final Logger log = LoggerFactory.getLogger(EPCE3944801Controller.class);

	/**
	 * 기타코드관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */                                         
	@RequestMapping(value = "/CE/EPCE3968101.do", produces = "application/text; charset=utf8")
	public String epce3968101(HttpServletRequest request, ModelMap model) {

		
		//언어구분 리스트 , 용어구분 리스트 
		model =epce3968101Service.epce3968101_select(model,request);
		
		return "/CE/EPCE3968101";
	}
	
	/**
	 * 기타코드관리  그룹코드 저장여부 수정 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3968101_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3968101_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {

	    String errCd = "";
		try{
			errCd =epce3968101Service.epce3968101_select2(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 기타코드관리  그룹코드  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3968101_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3968101_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3968101Service.epce3968101_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 기타코드관리 상세코드 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3968101_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3968101_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3968101Service.epce3968101_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 기타코드관리  상세코드 저장여부 수정 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3968101_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3968101_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {

	    String errCd = "";
		try{
			errCd =epce3968101Service.epce3968101_select5(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	/**
	 * 기타코드관리 그룹코드 저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3968101_09.do", produces="application/text; charset=utf8")
	@ResponseBody
    @Transactional
	public String epce3968101_insert(@RequestParam Map<String, String> data, HttpServletRequest request)  {
	
	    String errCd = "";
		try{
			errCd = epce3968101Service. epce3968101_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 기타코드관리 상세코드 저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3968101_092.do", produces="application/text; charset=utf8")
	@ResponseBody
    @Transactional
	public String epce3968101_insert2(@RequestParam Map<String, String> data, HttpServletRequest request)  {
	
	    String errCd = "";
		try{
			errCd = epce3968101Service. epce3968101_insert2(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
}
