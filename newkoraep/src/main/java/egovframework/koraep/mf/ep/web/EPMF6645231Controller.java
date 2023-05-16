package egovframework.koraep.mf.ep.web;

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
import egovframework.koraep.mf.ep.service.EPMF6645231Service;

/**
 * 직접회수정보등록 Controller
 * @author pc
 */
@Controller
public class EPMF6645231Controller {
	
	@Resource(name="epmf6645231Service")
	private EPMF6645231Service epmf6645231Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 직접회수정보등록 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6645231.do", produces="application/text; charset=utf8")
	public String epmf6645231(ModelMap model, HttpServletRequest request)  {
		
		//직매장/공장, 판매처 및 빈용기명 리스트 조회
		model = epmf6645231Service.epmf6645231_select1(model, request);
		
		return "/MF/EPMF6645231";
		
	}
	
	/**
	 * 직접회수정보 등록
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6645231_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6645231_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf6645231Service.epmf6645231_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
		
	}
		
	/**
	 * 직접회수생산자 선택시 직매장/공장 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6645231_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6645231_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		return util.mapToJson(epmf6645231Service.epmf6645231_select3(inputMap, request)).toString();
		
	}
	
	/**
	 * 직접회수일자 변경시 빈용기명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6645231_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6645231_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		return util.mapToJson(epmf6645231Service.epmf6645231_select4(inputMap, request)).toString();
		
	}
	
	/**
	 * 직접회수정보 그리드 컬럼 선택시
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6645231_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6645231_select5(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf6645231Service.epmf6645231_select5(inputMap, request)).toString();
	}
	
	/**
	 * 직접회수정보등록 엑셀 업로드 후처리
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6645231_195.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPMF2910131_select6(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf6645231Service.epmf6645231_select6(inputMap, request)).toString();
	}
}
