package egovframework.koraep.mf.ep.web;

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
import egovframework.koraep.mf.ep.service.EPMF2393001Service;

/**
 * 고지서조회 Controller
 * @author Administrator
 *
 */

@Controller
public class EPMF2393001Controller {

	@Resource(name="epmf2393001Service")
	private EPMF2393001Service epmf2393001Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 고지서조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2393001.do")
	public String epmf2393001(ModelMap model, HttpServletRequest request) {
		
		model = epmf2393001Service.epmf2393001_select(model, request);
		
		return "/MF/EPMF2393001";
	}
	
	/**
	 * 고지서 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2393001_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf2393001_select(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf2393001Service.epmf2393001_select2(data, request)).toString();
	}
	
	/**
	 * 보증금고지서 상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2393064.do")
	public String epmf2393064(ModelMap model, HttpServletRequest request) {
		
		model = epmf2393001Service.epmf2393064_select(model, request);
		
		return "/MF/EPMF2393064";
	}
	
	/**
	 * 취급수수료고지서 상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF23930642.do")
	public String epmf23930642(ModelMap model, HttpServletRequest request) {
		
		model = epmf2393001Service.epmf2393064_select2(model, request);
		
		return "/MF/EPMF23930642";
	}
	
	/**
	 * 보증금(조정)고지서 상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF23930643.do")
	public String epmf23930643(ModelMap model, HttpServletRequest request) {
		
		model = epmf2393001Service.epmf2393064_select3(model, request);
		
		return "/MF/EPMF23930643";
	}
	
	/**
	 * 고지서취소요청
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2393088.do")
	public String epmf2393088(ModelMap model, HttpServletRequest request) {
		model.addAttribute("titleSub", commonceService.getMenuTitle("EPMF2393088"));
		return "/MF/EPMF2393088";
	}
	
	
	/**
	 * 고지서 발급취소요청
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2393088_21.do", produces="application/text; charset=UTF-8")
	@ResponseBody
	public String epmf2393088_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		String errCd = "";
		
		try{
			errCd = epmf2393001Service.epmf2339088_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
		
	}
	
	/**
	 * 고지서 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2393001_05.do")
	@ResponseBody
	public String epmf2393001_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf2393001Service.epmf2393001_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 보증금고지서 상세 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2393064_05.do")
	@ResponseBody
	public String epmf2393064_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf2393001Service.epmf2393064_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 취급수수료고지서 상세 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF23930642_05.do")
	@ResponseBody
	public String epmf23930642_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf2393001Service.epmf23930642_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
}
