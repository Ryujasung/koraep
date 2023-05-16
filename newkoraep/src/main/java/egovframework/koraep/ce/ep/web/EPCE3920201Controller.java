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
import egovframework.koraep.ce.ep.service.EPCE3920201Service;

@Controller
public class EPCE3920201Controller {

	@Resource(name = "epce3920201Service")
	private  EPCE3920201Service epce3920201Service; 	//실행이력조회 service

	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 로그인이력조회 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE3920201.do", produces = "application/text; charset=utf8")
	public String epce3961201(HttpServletRequest request, ModelMap model) {
		
		model = epce3920201Service.epce3920201_select1(model, request);

	return "/CE/EPCE3920201";
	}
	
	/**
	 * 로그인이력 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3920201_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3961201_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3920201Service.epce3920201_select(inputMap, request)).toString();
		
	}	
	
	
	
	/**
	 * 로그인이력조회 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3920201_05.do")
	@ResponseBody
	public String epce2308801_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce3920201Service.epce3920201_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	
	
	
}
