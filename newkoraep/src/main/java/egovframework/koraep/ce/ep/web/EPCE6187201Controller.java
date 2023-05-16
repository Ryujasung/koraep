package egovframework.koraep.ce.ep.web;

import java.io.File;
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
import egovframework.koraep.ce.ep.service.EPCE6187201Service;

/**
 * 기간별 대비 현황
 * @author 이근표
 *
 */
@Controller
public class EPCE6187201Controller {  

	@Resource(name = "epce6187201Service")
	private  EPCE6187201Service epce6187201Service; 	//출고대비초과회수현황 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	/**
	 * 기간별 대비 현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE6187201.do", produces = "application/text; charset=utf8")
	public String epce6187201(HttpServletRequest request, ModelMap model){

		model = epce6187201Service.epce6187201_select(model, request);
		return "/CE/EPCE6187201";
	}

	/**
	 * 기간별 대비 현황 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6187201_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6187201_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request){
		return util.mapToJson(epce6187201Service.epce6187201_select2(inputMap, request)).toString();
	}		
	
	/**
	 * 기간별 대비 현황 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6187201_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6187201_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce6187201Service.epce6187201_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 기간별 대비 현황 팝업조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6187261.do")
	public String epce6187261(ModelMap model, HttpServletRequest request){
		model = epce6187201Service.epce6187261_select(model, request);
		System.out.println("model"+model);
		return "/CE/EPCE6187261";
	}	
}
