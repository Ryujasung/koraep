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
import egovframework.koraep.ce.ep.service.EPCE9001001Service;


/**
 * 회수대비초과반환현황
 * @author 양성수
 *
 */
@Controller
public class EPCE9001001Controller {  

	@Resource(name = "EPCE9001001Service")
	private  EPCE9001001Service EPCE9001001Service; 	//회수대비초과반환현황 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 회수대비초과반환현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE9001001.do", produces = "application/text; charset=utf8")
	public String EPCE9001001(HttpServletRequest request, ModelMap model) {

		model =EPCE9001001Service.EPCE9001001_select(model, request);
		return "/CE/EPCE9001001";
	}
	
	/**
	 *  회수대비초과반환현황 도매업자 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9001001_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE9001001_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(EPCE9001001Service.EPCE9001001_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 회수대비초과반환현황  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9001001_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE9001001_select2(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		System.out.println("HI EPCE9001001");
		return util.mapToJson(EPCE9001001Service.EPCE9001001_select3(inputMap, request)).toString();
	}															   
	
	/**
	 * 회수대비초과반환현황  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9001001_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String EPCE9001001_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = EPCE9001001Service.EPCE9001001_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
}
