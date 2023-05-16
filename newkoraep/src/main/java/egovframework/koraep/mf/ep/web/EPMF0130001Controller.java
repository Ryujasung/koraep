package egovframework.koraep.mf.ep.web;

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
import egovframework.koraep.mf.ep.service.EPMF0130001Service;

/**
 * 입고정보생산자ERP대조
 * @author 이근표
 *
 */
@Controller
public class EPMF0130001Controller {  

	@Resource(name = "epmf0130001Service")
	private  EPMF0130001Service epmf0130001Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService;

	
	/**
	 * 입고정보생산자ERP대조 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/MF/EPMF0130001.do", produces = "application/text; charset=utf8")
	public String epce0130001(HttpServletRequest request, ModelMap model) {

		model = epmf0130001Service.epmf0130001_select(model, request);
		
		return "/MF/EPMF0130001";
	}
	
	/**
	 * 입고정보생산자ERP대조 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0130001_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0130001_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf0130001Service.epmf0130001_select2(data, request)).toString();
	}
	
	/**
	 * 입고정보생산자ERP대조 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0130001_05.do")
	@ResponseBody
	public String epce0130001_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf0130001Service.epmf0130001_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
}
