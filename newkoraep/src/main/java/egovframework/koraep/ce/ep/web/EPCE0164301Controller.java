package egovframework.koraep.ce.ep.web;

import java.util.HashMap;
import java.util.List;
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
import egovframework.koraep.ce.ep.service.EPCE0164301Service;
/**
 *  개별취급수수료관리 Controller
 * @author 양성수
 *
 */
@Controller
public class EPCE0164301Controller {

	@Resource(name = "epce0164301Service")
	private  EPCE0164301Service epce0164301Service; 	//개별취급수수료관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 개별취급수수료관리 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0164301.do", produces = "application/text; charset=utf8")
	public String epce0164301(ModelMap model ,HttpServletRequest request) {
		model =epce0164301Service.epce0164301_select(model,request);
	return "/CE/EPCE0164301";
	}
	
	/**
	 * 개별취급수수료관리 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0164301_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0164301_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0164301Service.epce0164301_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 개별취급수수료관리 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0164301_05.do")
	@ResponseBody
	public String epce0164301_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0164301Service.epce0164301_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 개별취급수수료관리 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0164301_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0164301_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		String errCd = "0000";
		JSONObject rtnObj = new JSONObject();
		
		try{
			List<?> list = epce0164301Service.epce0164301_delete(inputMap,request);
			rtnObj.put("initList", util.mapToJson(list).toString());
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		rtnObj.put("RSLT_CD", errCd);
	/*	if(!errCd.equals("0000")){
		}else{
			rtnObj.put("RSLT_MSG","");
		}*/
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		return rtnObj.toString();
	}
	
	
	/**
	 * 개별취급수수료등록 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0164331.do", produces = "application/text; charset=utf8")
	public String epce0164331(ModelMap model ,HttpServletRequest request) {
		model =epce0164301Service.epce0164331_select(model,request);
	return "/CE/EPCE0164331";
	}
	

	/**
	 * 개별취급수수료등록 기준취급수수료 선택 부분 빈용기명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0164331_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0164331_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0164301Service.epce0164331_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 개별취급수수료등록 기준취급수수료 선택 부분   적용기간 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0164331_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0164331_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
	
		return util.mapToJson(epce0164301Service.epce0164331_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 개별취급수수료등록 기준취급수수료 선택 부분    조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0164331_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0164331_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0164301Service.epce0164331_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 개별취급수수료등록 기준취급수수료 선택 부분    조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0164331_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0164331_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		//return util.mapToJson(epce0164301Service.epce0164331_select5(inputMap, request)).toString();
		
		
		String errCd = "0000";
		JSONObject rtnObj = new JSONObject();
		
		try{
			List<?> list = epce0164301Service.epce0164331_select5(inputMap,request);
			rtnObj.put("selList", util.mapToJson(list).toString());
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		rtnObj.put("RSLT_CD", errCd);
		if(!errCd.equals("0000")){
			rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		}else{
			rtnObj.put("RSLT_MSG","");
		}
		return rtnObj.toString();
		
		
		
		
		
		
	}	
	
	/**
	 * 개별취급수수료등록  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0164331_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0164331_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0164301Service.epce0164331_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		return rtnObj.toString();
	}
	
	
	/**
	 * 개별취급수수료변경 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0164342.do", produces = "application/text; charset=utf8")
	public String epce0164342(ModelMap model ,HttpServletRequest request) {
		model =epce0164301Service.epce0164342_select(model,request);
	return "/CE/EPCE0164342";
	}
	/**
	 * 개별취급수수료등록  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0164342_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0164342_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{

			errCd = epce0164301Service.epce0164342_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	
	/**
	 * 기준취급수수료 레이어팝업 초기화면 조회
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0164388.do", produces = "application/text; charset=utf8")
	public String epce0164388(ModelMap model ,HttpServletRequest request) {
		model =epce0164301Service.epce0164388_select(model,request);
	return "/CE/EPCE0164388";
	}
	
	
}
