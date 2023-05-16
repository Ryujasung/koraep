package egovframework.koraep.ce.ep.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE0121801Service;

/**
 * 소매거래처관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE0121801Controller {

	
	@Resource(name="epce0121801Service")
	private EPCE0121801Service epce0121801Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 소매거래처관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0121801.do")
	public String epce0121801(ModelMap model, HttpServletRequest request) {
		
		model = epce0121801Service.epce0121801_select(model, request);
		
		return "/CE/EPCE0121801";
	}
	
	/**
	 * 소매거래처관리  조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0121801_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0121801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce0121801Service.epce0121801_select2(data)).toString();
	}
	
	/**
	 * 소매거래처관리 등록 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0121831.do")
	public String epce0120631(ModelMap model, HttpServletRequest request) {
		
		model = epce0121801Service.epce0121831_select(model, request);
		
		return "/CE/EPCE0121831";
	}
	
	/**
	 * 거래처 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0121831_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0121831_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0121801Service.epce0121831_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}  
	
	/**
	 * 소매거래처관리 데이터 체크
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0121831_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0121831_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";
		
		try{
			errCd = epce0121801Service.epce0121831_select2(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		if(!errCd.equals("0000")){
			rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		}else{
			rtnObj.put("RSLT_MSG","");
		}
		return rtnObj.toString();
	}
	
	/**
	 * 소매거래처관리 데이터 체크 (엑셀저장용)
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0121831_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0121831_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce0121801Service.epce0121831_select3(data, request)).toString();
	}
	
	/**
	 * 거래상태 변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0121801_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0120601_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		System.out.println("EPCE0121801_21 : "+data);
		try{
			errCd = epce0121801Service.epce0121801_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}  
	
	/**
	 * 소매거래처 변경 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0121888.do")
	public String epce0140188(ModelMap model, HttpServletRequest request) {
		
		model = epce0121801Service.epce0121888_select(model);
		
		return "/CE/EPCE0121888";
	}
	
	/**
	 * 소매거래처 정보 변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0121888_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0121888_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0121801Service.epce0121888_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0121801_05.do")
	@ResponseBody
	public String epce0121801_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0121801Service.epce0121801_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	/**
	 * 협의서증빙자료  삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0121801_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0121801_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epce0121801Service.epce0121801_delete(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		return rtnObj.toString();
	}
	
	
	/***********************************************************************************************************************************************
	*	협의서증빙자료 팝업
	************************************************************************************************************************************************/
	/**
	 * 협의서증빙자료 팝업
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE01218881.do", produces = "application/text; charset=utf8")
	public String epce01218881(@RequestParam HashMap<String, String> data, HttpServletRequest request, ModelMap model) {
		System.out.println("epce01218881 : "+data);
		model = epce0121801Service.epce01218881_select(model, request);
		return "/CE/EPCE01218881";
	}

	/**
	 * 협의서증빙자료등록
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE01218881_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE01218881_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {

		String errCd = "";
		System.out.println("controller inputMap"+inputMap);
		try{
			errCd = epce0121801Service.epce01218881_insert(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}

	/***********************************************************************************************************************************************
	*	협의서자료다운로드
	************************************************************************************************************************************************/
	/**
	 * 협의서자료다운로드
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE01218882.do", produces = "application/text; charset=utf8")
	public String EPCE01218882(@RequestParam Map<String, String> param,HttpServletRequest request, ModelMap model) {
		
		model = epce0121801Service.epce01218882_select(param,model, request);
		return "/CE/EPCE01218882";
	}

}
