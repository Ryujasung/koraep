package egovframework.koraep.mf.ep.web;

import java.io.IOException;
import java.sql.SQLException;
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
import egovframework.koraep.mf.ep.service.EPMF6104901Service;


/**
 * 상세출고현황
 * @author 이내희
 *
 */
@Controller
public class EPMF6104901Controller {  

	@Resource(name = "epmf6104901Service")
	private  EPMF6104901Service epmf6104901Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 상세출고현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/MF/EPMF6104901.do", produces = "application/text; charset=utf8")
	public String epmf6104901(HttpServletRequest request, ModelMap model) {
		model =epmf6104901Service.epmf6104901_select(model, request);
		return "/MF/EPMF6104901";
	}
	
	/**
	 * 상세출고현황 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6104901_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf6104901_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf6104901Service.epmf6104901_select2(data,request)).toString();
	}
	
	/**
	 * 생산자변경시 생산자에맞는 빈용기명, 직매장, 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6104901_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6104901_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf6104901Service.epmf6104901_select3(inputMap, request)).toString();
	}
	
	/**
	 * 상세출고현황  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6104901_05.do")
	@ResponseBody
	public String epmf6104901_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf6104901Service.epmf6104901_excel(data, request);
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
}
