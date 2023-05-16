package egovframework.koraep.ce.ep.web;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE0160101Service;
import egovframework.koraep.ce.ep.service.EPCE0160116Service;


/**
 * 사업자상세 정보 Controller
 * @author 김창순
 *
 */

@Controller
public class EPCE0160116Controller {
	
	@Resource(name="epce0160101Service")
	private EPCE0160101Service epce0160101Service;
	
	@Resource(name="epce0160116Service")
	private EPCE0160116Service epce0160116Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service
	
	/**
	 * 사업자관리 상세
	 * @param request
	 * @return
	 * @
	 */
//	@RequestMapping(value="/CE/EPCE0160116.do", produces="application/text; charset=utf8")
//	public String epce0160116_select(HttpServletRequest request, ModelMap model)  {
//		
//		model = epce0160116Service.epce0160116_select(model, request);
//		
//		return "/CE/EPCE0160116";
//		
//	}

	/**
	 * 사업자정보관리 가입/변경요청 승인
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160116_1.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0160116_update(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		
		String errCd = "";
		
			try{
				errCd = epce0160116Service.epce0160116_update(data, request);
			}catch(Exception e){
				errCd = e.getMessage();
			}
			
			JSONObject rtnObj = new JSONObject();
			rtnObj.put("RSLT_CD", errCd);
			rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
			
			return rtnObj.toString();
		//가입/변경요청 승인
//		if(data.get("FLAG").equals("Y"))
//			return EPCE0160116Service.epce0160116_update(data, request);
		//가입요청 반송
//		else
//			return EPCE0160116Service.epce0160116_delete(data, request);
//		return "/CE/EPCE0160116";
	}
	
	/**
	 * 사업자정보관리 가입/변경요청 반송
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160116_2.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0160116_update2(@RequestParam Map<String, String> data, HttpServletRequest request)  {
			String errCd = "";
			
			try{
				errCd = epce0160116Service.epce0160116_delete(data, request);
			}catch(Exception e){
				errCd = e.getMessage();
			}
			
			JSONObject rtnObj = new JSONObject();
			rtnObj.put("RSLT_CD", errCd);
			rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
			
			return rtnObj.toString();

	}
	
	/**
	 * 사업자정보 삭제
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160116_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0160116_delete(@RequestParam Map<String, String> data, HttpServletRequest request)  {
			String errCd = "";
			
			try{
				errCd = epce0160116Service.epce0160116_delete2(data, request);
			}catch(Exception e){
				errCd = e.getMessage();
			}
			
			JSONObject rtnObj = new JSONObject();
			rtnObj.put("RSLT_CD", errCd);
			rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
			
			return rtnObj.toString();

	}
	
	/**
	 * 사업자정보변경
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160142.do", produces="application/text; charset=utf8")
	public String epce0160142(ModelMap model, HttpServletRequest request) {
		
		model = epce0160116Service.epce0160142_select(model, request);
		
		return "/CE/EPCE0160142";
	}
	
	/**
	 * 사업자 정보 변경 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160142_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0160142_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0160116Service.epce0160142_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}




}






