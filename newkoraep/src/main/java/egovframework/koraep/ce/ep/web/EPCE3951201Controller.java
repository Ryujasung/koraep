package egovframework.koraep.ce.ep.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;


import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE3951201Service;



/**
 * 표준용기코드관리 Controller
 * @author 양성수
 *
 */
@Controller
public class EPCE3951201Controller {

	@Resource(name = "epce3951201Service")
	private EPCE3951201Service epce3951201Service; 	//표준용기코드관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 표준용기코드관리 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE3951201.do", produces = "application/text; charset=utf8")
	public String epce3951201(HttpServletRequest request, ModelMap model) {

		model =epce3951201Service.epce3951201_select(model,request);
		
	return "/CE/EPCE3951201";
	}
	
	/**
	 * 표준용기코드관리 리스트 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3951201_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3951201_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3951201Service.epce3951201_select2(inputMap, request)).toString();
	}	
	
	
	/**
	 * 표준용기코드관리 저장 수정 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3951201_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3951201_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
        
	    String errCd = "";
		try{
			errCd = epce3951201Service.epce3951201_select3(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}

	/**
	 * 표준용기코드관리 저장,수정
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3951201_09.do", produces="application/text; charset=utf8")
	@ResponseBody
    @Transactional
	public String epce3951201_insert(@RequestParam Map<String, String> data, HttpServletRequest request)  {
	
	    String errCd = "";
		try{
	
			errCd = epce3951201Service. epce3951201_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	
	
	
	
	
}
