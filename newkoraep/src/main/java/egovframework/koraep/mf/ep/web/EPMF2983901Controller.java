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
import egovframework.koraep.mf.ep.service.EPMF2983901Service;

/**
 * 입고관리
 * @author 양성수
 *
 */
@Controller
public class EPMF2983901Controller {  

	@Resource(name = "epmf2983901Service")
	private  EPMF2983901Service epmf2983901Service; 	//입고관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 입고관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/MF/EPMF2983901.do", produces = "application/text; charset=utf8")
	public String epmf2983901(HttpServletRequest request, ModelMap model) {

		if(request.getParameter("RTN_DOC_NO") != null){ //상세조회 바로이동
			model.addAttribute("RTN_DOC_NO", request.getParameter("RTN_DOC_NO").toString());
		}

		if(request.getParameter("WRHS_DOC_NO") != null){ //상세조회 바로이동
			model.addAttribute("WRHS_DOC_NO", request.getParameter("WRHS_DOC_NO").toString());
		}
		
		model =epmf2983901Service.epmf2983901_select(model, request);
		return "/MF/EPMF2983901";
	}
	
	/**
	 *  입고관리  생산자에 따른 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2983901_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2983901_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2983901Service.epmf2983901_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 입고관리 생산자 직매장/공장 선택시  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2983901_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2983901_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2983901Service.epmf2983901_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 입고관리 도매업자 구분 선택시 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2983901_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2983901_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2983901Service.epmf2983901_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 입고관리  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2983901_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2983901_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2983901Service.epmf2983901_select5(inputMap, request)).toString();
	}	
	
	/**
	 * 입고관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2983901_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf2983901_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf2983901Service.epmf2983901_excel(data, request);
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
	 *  입고확인 취소요청  페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF29839884.do", produces = "application/text; charset=utf8")
	public String epmf29839884(HttpServletRequest request, ModelMap model) {

		String title = commonceService.getMenuTitle("EPMF29839884");
		model.addAttribute("titleSub", title);
		
		return "/MF/EPMF29839884";
	}
	
	/**
	 * 입고관리  실태조사 ,확인취소요청
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2983901_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2983901_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epmf2983901Service.epmf2983901_update(inputMap, request);
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
	 * 입고관리  일괄확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2983901_212.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2983901_update2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epmf2983901Service.epmf2983901_update2(inputMap, request);
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
	//	입고상세 페이지 
	//---------------------------------------------------------------------------------------------------------------------
	
	/**
	 * 입고관리 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF2983964.do", produces = "application/text; charset=utf8")
	public String epmf2983964(HttpServletRequest request, ModelMap model) {

		model =epmf2983901Service.epmf2983964_select(model, request);
		return "/MF/EPMF2983964";
	}

	/**
	 * 입고관리 상세  조정확인후 상태다시 셋팅
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2983964_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2983964_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2983901Service.epmf2983964_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 입고관리 상세 조정확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2983964_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2983964_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epmf2983901Service.epmf2983964_update(inputMap, request);
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
	 * 입고관리 상세 조정확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @  
	 */
	@RequestMapping(value="/MF/EPMF2983964_212.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2983964_update2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epmf2983901Service.epmf2983964_update2(inputMap, request);
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
	//	 조사확인요청사유서(도매업자)
	//---------------------------------------------------------------------------------------------------------------------
	
	/**
	 *  조사확인요청사유서도매업자)  페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF2983988.do", produces = "application/text; charset=utf8")
	public String epmf2983988(HttpServletRequest request, ModelMap model) {
		return "/MF/EPMF2983988";
	}

	/**
	 *  조사확인요청사유서(도매업자)  초기값
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2983988_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2983988_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2983901Service.epmf2983988_select(inputMap, request)).toString();
	}	
	
	
	/**
	 *  조사확인요청사유서(도매업자) 저장
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2983988_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2983988_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epmf2983901Service.epmf2983988_insert(inputMap, request);
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
	//	증빙사진상세 페이지 
	//---------------------------------------------------------------------------------------------------------------------
		
	/**
	 * 입고증빙사진 상세조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF29839883.do", produces = "application/text; charset=utf8")
	public String EPMF29839883(HttpServletRequest request, ModelMap model) {
		return "/MF/EPMF29839883";
	}
	
	/**
	 * 입고증빙사진  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF29839883_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPMF29839883_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2983901Service.epmf29839883_select(inputMap, request)).toString();
	}	
	
}
