package egovframework.koraep.ce.ep.web;

import java.util.HashMap;

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
import egovframework.koraep.ce.ep.service.EPCE3960201Service;

/**
 * 메뉴관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE3960201Controller {

	
	@Resource(name="epce3960201Service")
	private EPCE3960201Service epce3960201Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 메뉴관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3960201.do")
	public String epce3960201(ModelMap model, HttpServletRequest request) {
		
		model = epce3960201Service.epce3960201_select(model);
		
		return "/CE/EPCE3960201";
	}
	
	/**
	 * 메뉴 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3960201_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3960201_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce3960201Service.epce3960201_select2(data)).toString();
	}
	
	/**
	 * 메뉴체크
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3960201_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3960201_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epce3960201Service.epce3960201_select3(data);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 상위메뉴코드 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3960201_193.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3960201_select3(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce3960201Service.epce3960201_select4(data)).toString();
	}
	
	/**
	 * 메뉴 삭제
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3960201_04.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3960201_delete(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";
		
		try{
			errCd = epce3960201Service.epce3960201_delete(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	/**
	 * 메뉴 등록/수정
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3960201_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3960201_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce3960201Service.epce3960201_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}

}
