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
import egovframework.koraep.ce.ep.service.EPCE4791401Service;

/**
 * 정산기간관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE4791401Controller {

	@Resource(name="epce4791401Service")
	private EPCE4791401Service epce4791401Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 정산기간관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4791401.do")
	public String epce4791401(ModelMap model, HttpServletRequest request) {
		model = epce4791401Service.epce4791401_select(model, request);
		
		return "/CE/EPCE4791401";
	}
	
	/**
	 * 정산기간관리 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4791401_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0101801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4791401Service.epce4791401_select2(data)).toString();
	}
	
	/**
	 * 정산기간등록 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4791431.do")
	public String epce4791431(ModelMap model, HttpServletRequest request) {
		model = epce4791401Service.epce4791431_select(model, request);
		
		return "/CE/EPCE4791431";
	}
	
	/**
	 * 생산자 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4791431_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce4791431_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4791401Service.epce4791431_select2(data)).toString();
	}
	
	/**
	 * 정산기간변경 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4791442.do")
	public String epce4791442(ModelMap model, HttpServletRequest request) {
		model = epce4791401Service.epce4791442_select(model, request);
		
		return "/CE/EPCE4791442";
	}
	
	/**
	 * 정산기간상세조회 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4791464.do")
	public String epce4791464(ModelMap model, HttpServletRequest request) {
		model = epce4791401Service.epce4791464_select(model, request);
		
		return "/CE/EPCE4791464";
	}
	
	/**
	 * 정산기간 상세조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4791464_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce4791464_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4791401Service.epce4791464_select(data)).toString();
	}
	
	/**
	 * 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4791431_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce4791431_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce4791401Service.epce4791431_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 삭제
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4791442_04.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce4791442_delete(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce4791401Service.epce4791442_delete(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 수정
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4791442_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce4791442_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce4791401Service.epce4791442_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 상태변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4791464_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String EPCE4791464_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce4791401Service.EPCE4791464_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
}
