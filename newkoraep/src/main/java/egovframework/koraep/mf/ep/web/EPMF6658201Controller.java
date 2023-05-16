package egovframework.koraep.mf.ep.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.mf.ep.service.EPMF6658201Service;

/**
 * 출고정보조회 Controller
 * @author pc
 *
 */
@Controller
public class EPMF6658201Controller {
	
	@Resource(name="epmf6658201Service")
	private EPMF6658201Service epmf6658201Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 출고정보조회 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6658201.do", produces="application/text; charset=utf8")
	public String epmf6658201(ModelMap model, HttpServletRequest request)  {
		
		Device device = DeviceUtils.getCurrentDevice(request);   
		
		//출고등록상태, 생산자 및 직매장/공장 리스트 조회
		model = epmf6658201Service.epmf6658201_select1(model, request);
		
		if(device.isNormal()){
			return "/MF/EPMF6658201";
		}else{
			return "/MF/EPMF0120601_m";
		}
		
	}
	
	/**
	 * 출고정보 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6658201_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6658201_select(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		return util.mapToJson(epmf6658201Service.epmf6658201_select2(data, request)).toString();
		
	}
	
	
	/**
	 * 생산자 직매장/공장 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6658201_191.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf6658201_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf6658201Service.epmf6658201_select3(data, request)).toString();
	}
	
	/**
	 * 출고정보 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF66582641.do", produces = "application/text; charset=utf8")
	public String epmf6658201_select3(HttpServletRequest request, ModelMap model) {

		model = epmf6658201Service.epmf6658201_select4(model, request);
		
		return "/MF/EPMF66582641";
	}
	
	/**
	 * 출고정보 상세 페이지 호출 (링크)
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF66582642.do", produces = "application/text; charset=utf8")
	public String epmf66582642_select(HttpServletRequest request, ModelMap model) {

		model = epmf6658201Service.epmf66582642_select(model, request);
		
		return "/MF/EPMF66582642";
	}

	/**
	 * 출고정보 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6658201_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6658201_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epmf6658201Service.epmf6658201_delete(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
		
	}
	
	/**
	 * 출고정보 상세 페이지 엑셀저장
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF66582641_05.do", produces = "application/text; charset=utf8")
	@ResponseBody
	public String epmf6658201_select4(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epmf6658201Service.epmf66582641_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 출고관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6658201_05.do")
	@ResponseBody
	public String epmf6658201_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf6658201Service.epmf6658201_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
}
