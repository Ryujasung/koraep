package egovframework.koraep.ce.ep.web;

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
import egovframework.koraep.ce.ep.service.EPCE2983931Service;


/**
 * 입고내역서 등록
 * @author 양성수
 *
 */
@Controller
public class EPCE2983931Controller {  

	@Resource(name = "epce2983931Service")
	private  EPCE2983931Service epce2983931Service; 	//입고내역서 등록 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 입고내역서 등록 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE2983931.do", produces = "application/text; charset=utf8")
	public String epce2983931(HttpServletRequest request, ModelMap model) {

		model =epce2983931Service.epce2983931_select(model, request);
		return "/CE/EPCE2983931";
	}
	
	/**
	 * 입고내역서등록  그리드 컬럼 선택시
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2983931_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2983931_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce2983931Service.epce2983931_select2(inputMap, request)).toString();
	}	
	
	
	/**
	 * 입고내역서등록  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */									
	@RequestMapping(value="/CE/EPCE2983931_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2983931_insert(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = epce2983931Service.epce2983931_insert(data, request);
			
		}catch(Exception e){
			errCd = e.getMessage();
		}
		   
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 입고내역서등록  증빙사진 ori >> tmp
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */				

	@RequestMapping(value="/CE/EPCE2983931_092.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2983931_insert2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		String errCd = "";
		try{
			errCd = epce2983931Service.epce29839882_insert2(inputMap, request);
			
		}catch(Exception e){
			errCd = e.getMessage();
		}
		   
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}	
	
	/**
	 * 입고내역서등록  수정
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */									
	@RequestMapping(value="/CE/EPCE2983931_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2983931_update(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce2983931Service.epce2983931_update(data, request);
			
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 입고내역서 취소버튼 클릭시 증빙사진 tmp 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2983931_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public void epce2983931_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		epce2983931Service.epce2983931_delete(inputMap, request);
	}	
	
	
	//----------------------------------------------------------------------------------------------------------------------
	//						 증빙사진
	//----------------------------------------------------------------------------------------------------------------------
	
	/**
	 * 증빙사진 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE29839882.do", produces = "application/text; charset=utf8")
	public String epce29839882(HttpServletRequest request, ModelMap model) {
		return "/CE/EPCE29839882";
	}
	
	/**
	 * 증빙사진 페이지 값
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE29839882_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce29839882_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce2983931Service.epce29839882_select(inputMap, request)).toString();
	}	

	/**
	 * 증빙사진 등록
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE29839882_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE29839882_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epce2983931Service.epce29839882_insert(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
}
