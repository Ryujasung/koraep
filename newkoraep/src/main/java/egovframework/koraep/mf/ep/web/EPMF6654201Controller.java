package egovframework.koraep.mf.ep.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.mf.ep.service.EPMF6654201Service;

/**
 * 직접회수관리 Controller
 * @author pc
 *
 */
@Controller
public class EPMF6654201Controller {
	
	private static final Logger log = LoggerFactory.getLogger(EPMF6654201Controller.class);
	
	@Resource(name="epmf6654201Service")
	private EPMF6654201Service epmf6654201Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6654201.do", produces="application/text; charset=utf8")
	public String epmf6654201(ModelMap model, HttpServletRequest request)  {
		
		model = epmf6654201Service.epmf6654201_select1(model, request);
		
		return "MF/EPMF6654201";
		
	}
	
	/**
	 * 직접반환등록 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6654231.do", produces="application/text; charset=utf8")
	public String epmf6654231(ModelMap model, HttpServletRequest request)  {
		
		model = epmf6654201Service.epmf6654231_select(model, request);
		
		return "/MF/EPMF6654231";
		
	}
	
	/**
	 * 직접반환변경 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6654242.do", produces="application/text; charset=utf8")
	public String epmf6654242(ModelMap model, HttpServletRequest request)  {
		
		model = epmf6654201Service.epmf6654242_select(model, request);
		
		return "/MF/EPMF6654242";
		
	}
	
	/**
	 * 직접반환정보 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF6654264.do", produces = "application/text; charset=utf8")
	public String epmf6654264_select(HttpServletRequest request, ModelMap model) {

		model = epmf6654201Service.epmf6654264_select(model, request);
		
		return "/MF/EPMF6654264";
	}
	
	/**
	 * 직접반환정보 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6654201_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6654201_select(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		
		return util.mapToJson(epmf6654201Service.epmf6654201_select2(data, request)).toString();
		
	}
	
	/**
	 * 직접반환정보 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6654201_05.do")
	@ResponseBody
	public String epmf6654201_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf6654201Service.epmf6654201_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 직접반환정보 상세 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6654264_05.do")
	@ResponseBody
	public String epmf6654264_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf6654201Service.epmf6654264_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 직접반환정보 등록
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6654231_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6654231_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf6654201Service.epmf6654231_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
		
	}
	
	/**
	 * 직접반환정보 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6654201_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6654201_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		String errCd = "";
		
		try{
			errCd = epmf6654201Service.epmf6654201_delete(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
		
	}
	
	/**
	 * 직접반환정보등록 엑셀 업로드 후처리
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6654231_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPMF6654231_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf6654201Service.epmf6654231_select2(inputMap, request)).toString();
	}
	
	/**
	 * 직적반환정보변경 저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6654242_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6654242_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epmf6654201Service.epmf6654242_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
		
	}
	
}
