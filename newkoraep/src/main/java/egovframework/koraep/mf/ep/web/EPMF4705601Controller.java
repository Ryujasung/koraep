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
import egovframework.koraep.mf.ep.service.EPMF2910101Service;
import egovframework.koraep.mf.ep.service.EPMF4705601Service;
import egovframework.koraep.mf.ep.service.EPMF2983901Service;


/**
 * 수기입고정정 
 * @author 양성수
 *
 */
@Controller
public class EPMF4705601Controller {  

	@Resource(name = "epmf4705601Service")
	private  EPMF4705601Service epmf4705601Service; 	// 수기입고정정 service
	
	@Resource(name = "epmf2983901Service")
	private  EPMF2983901Service epmf2983901Service; 	//입고관리 service
	
	@Resource(name = "epmf2910101Service")
	private  EPMF2910101Service epmf2910101Service; 	//반환관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 *  수기입고정정  페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/MF/EPMF4705601.do", produces = "application/text; charset=utf8")
	public String epmf4705601(HttpServletRequest request, ModelMap model) {

		model = epmf4705601Service.epmf4705601_select(model, request);
		return "/MF/EPMF4705601";
	}
	
	/**
	 *  수기입고정정 직매장 조회, 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4705601_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4705601_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf4705601Service.epmf4705601_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 수기입고정정 도매업자 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4705601_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4705601_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf4705601Service.epmf4705601_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 수기입고정정 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4705601_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4705601_select3(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf4705601Service.epmf4705601_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 수기입고정정 생산자 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4705601_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4705601_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf4705601Service.epmf4705601_select5(inputMap, request)).toString();
	}
	
	/**
	 * 진행중인 정산기간 존재 여부 체크
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4705601_195.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4705601_select5(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf4705601Service.epmf4705601_select6(inputMap, request)).toString();
	}
	
	/**
	 * 빈용기구분코드 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4705601_196.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4705601_select6(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf4705601Service.epmf4705601_select7(inputMap, request)).toString();
	}
	
	/**
	 * 수기입고정정 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4705601_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf4705601_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf4705601Service.epmf4705601_excel(data, request);
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
	 * 수기입고정정 정정확인 정정반려 확인취소 상태 변경
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4705601_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4705601_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epmf4705601Service.epmf4705601_update(inputMap, request);
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
	

	//---------------------------------------------------------------------------------------------------------------------
	//	수기입고정정 내역조회
	//---------------------------------------------------------------------------------------------------------------------
		
	/**
	 * 수기입고정정 내역조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/MF/EPMF4705664.do", produces = "application/text; charset=utf8")
	public String epmf4705664(HttpServletRequest request, ModelMap model) {

		model =epmf4705601Service.epmf4705664_select(model, request);
		return "/MF/EPMF4705664";
	}
	

	/**
	 * 수기입고정정내역조회 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4705664_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4705664_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epmf4705601Service.epmf4705664_delete(inputMap, request);
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
	 * 입고정정등록 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF4705631.do", produces = "application/text; charset=utf8")
	public String epmf4705631(HttpServletRequest request, ModelMap model) {

		model = epmf4705601Service.epmf4705631_select(model, request);
		return "/MF/EPMF4705631";
	}
	
	/**
	 * 입고정정등록  빈용기명
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4705631_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4705631_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf4705601Service.epmf4705631_select2(inputMap, request)).toString();
	}	    
	
	
	/**
	 * 입고정정등록  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */									
	@RequestMapping(value="/MF/EPMF4705631_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf4705631_insert(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = epmf4705601Service.epmf4705631_insert(data, request);
			
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
	
	/***************************************************************************************************************************************************************************************
	 * 	 수기정산등록
	****************************************************************************************************************************************************************************************/
		
	/**
	 * 입고정정 수기정산등록 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF47056312.do", produces = "application/text; charset=utf8")
	public String epmf47056312(HttpServletRequest request, ModelMap model) {

		model = epmf4705601Service.epmf47056312_select(model, request);
		return "/MF/EPMF47056312";
	}
	
	/**
	 * 수기정산등록 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */									
	@RequestMapping(value="/MF/EPMF47056312_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf47056312_insert(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = epmf4705601Service.epmf47056312_insert(data, request);
			
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
	
	
	/***************************************************************************************************************************************************************************************
	 * 	 입고정정수정
	****************************************************************************************************************************************************************************************/
	
	/**
	 * 입고정정등록 수정 페이지 호출 - 수기등록
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF47056422.do", produces = "application/text; charset=utf8")
	public String epmf47056422(HttpServletRequest request, ModelMap model) {

		model =epmf4705601Service.epmf47056422_select(model, request);
		return "/MF/EPMF47056422";
	}
	
	/**
	 * 입고정정등록 수정 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF4705642.do", produces = "application/text; charset=utf8")
	public String epmf4705642(HttpServletRequest request, ModelMap model) {

		model =epmf4705601Service.epmf4705642_select(model, request);
		return "/MF/EPMF4705642";
	}
	
	/**
	 * 입고정정등록  수정 - 수기등록
	 * @param map
	 * @param model
	 * @param request
	 * @return   
	 * @
	 */									
	@RequestMapping(value="/MF/EPMF47056422_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf47056422_update(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf4705601Service.epmf47056422_update(data, request);
			
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
	 * 입고정정등록  수정
	 * @param map
	 * @param model
	 * @param request
	 * @return   
	 * @
	 */									
	@RequestMapping(value="/MF/EPMF4705642_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf4705642_update(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf4705601Service.epmf4705642_update(data, request);
			
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
	
	
/***************************************************************************************************************************************************************************************
 * 	 입고내역선택 
****************************************************************************************************************************************************************************************/
	
	/**
	 * 입고내역선택 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/MF/EPMF47056642.do", produces = "application/text; charset=utf8")
	public String epmf47056642(HttpServletRequest request, ModelMap model) {
		model = epmf4705601Service.epmf47056642_select(model, request);
		return "/MF/EPMF47056642";
	}
	
	/**
	 *  입고내역선택  생산자에 따른 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF47056642_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2983901_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf4705601Service.epmf47056642_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 입고내역선택 생산자 직매장/공장 선택시  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF47056642_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2983901_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf4705601Service.epmf47056642_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 입고내역선택 도매업자 구분 선택시 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF47056642_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2983901_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf4705601Service.epmf47056642_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 입고내역선택  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF47056642_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2983901_select4(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf4705601Service.epmf47056642_select5(inputMap, request)).toString();
	}	
	
}
