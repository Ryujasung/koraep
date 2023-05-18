package egovframework.koraep.mf.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.mf.ep.service.EPMF2916431Service;
import egovframework.koraep.mf.ep.service.EPMF2983931Service;


/**
 * 입고내역서 등록
 * @author 양성수
 *
 */
@Controller
public class EPMF2916431Controller {  

	@Resource(name = "epmf2916431Service")
	private  EPMF2916431Service epmf2916431Service; 	//입고내역서 등록 service
	
	@Resource(name = "epmf2983931Service")
	private  EPMF2983931Service epmf2983931Service; 	//입고내역서 등록 service
	
	
	
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 입고내역서 등록 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF2916431.do", produces = "application/text; charset=utf8")
	public String epmf2916431(HttpServletRequest request, ModelMap model) {

		model =epmf2916431Service.epmf2916431_select(model, request);
		return "/MF/EPMF2916431";
	}
	
	/**
	 * 입고내역서등록  그리드 컬럼 선택시
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2916431_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2916431_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2916431Service.epmf2916431_select2(inputMap, request)).toString();
	}	
	
	
	/**
	 * 입고내역서등록  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */									
	@RequestMapping(value="/MF/EPMF2916431_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf2916431_insert(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = epmf2916431Service.epmf2916431_insert(data, request);
			
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
	
	/**
	 * 입고내역서등록  수정
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */									
	@RequestMapping(value="/MF/EPMF2916431_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf2916431_update(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf2916431Service.epmf2916431_update(data, request);
			
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
