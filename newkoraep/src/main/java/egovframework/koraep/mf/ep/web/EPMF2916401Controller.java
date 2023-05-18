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
import egovframework.koraep.mf.ep.service.EPMF2916401Service;
import egovframework.koraep.mf.ep.service.EPMF2983901Service;

/**
 * 실태조사
 * @author 양성수
 *
 */
@Controller
public class EPMF2916401Controller {  

	@Resource(name = "epmf2916401Service")
	private  EPMF2916401Service epmf2916401Service; 	//실태조사 service
	
	@Resource(name = "epmf2983901Service")
	private  EPMF2983901Service epmf2983901Service; 	//입고관리 service
	
	@Resource(name = "epmf2910101Service")
	private  EPMF2910101Service epmf2910101Service; 	//반환관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 실태조사 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/MF/EPMF2916401.do", produces = "application/text; charset=utf8")
	public String epmf2916401(HttpServletRequest request, ModelMap model) {

		model =epmf2916401Service.epmf2916401_select(model, request);
		return "/MF/EPMF2916401";
	}
	
	/**
	 *  실태조사  생산자에 따른 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2916401_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2916401_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2916401Service.epmf2916401_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 실태조사 생산자 직매장/공장 선택시  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2916401_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2916401_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2916401Service.epmf2916401_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 실태조사 도매업자 구분 선택시 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2916401_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2916401_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2916401Service.epmf2916401_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 실태조사  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2916401_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2916401_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2916401Service.epmf2916401_select5(inputMap, request)).toString();
	}	
	
	/**
	 * 실태조사  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2916401_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf2916401_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf2916401Service.epmf2916401_excel(data, request);
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
	 * 실태조사요청취소
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2916401_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2916401_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epmf2916401Service.epmf2916401_update(inputMap, request);
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
	//	입고상세 페이지 ,  반환상세페이지 호출
	//---------------------------------------------------------------------------------------------------------------------
	
	/**
	 * 실태조사 반환관리 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF2916464.do", produces = "application/text; charset=utf8")
	public String epmf2910164(HttpServletRequest request, ModelMap model) {

		model =epmf2910101Service.epmf2910164_select(model, request);
		return "/MF/EPMF2916464";
	}
	
	/**
	 * 실태조사 입고관리 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF29164642.do", produces = "application/text; charset=utf8")
	public String epmf2983964(HttpServletRequest request, ModelMap model) {

		model =epmf2983901Service.epmf2983964_select(model, request);
		return "/MF/EPMF29164642";
	}
	
	//---------------------------------------------------------------------------------------------------------------------
	// 증빙파일등록
	//---------------------------------------------------------------------------------------------------------------------
	/**
	 * 실태조사 증빙파일등록 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF2916488.do", produces = "application/text; charset=utf8")
	public String epmf2916488(HttpServletRequest request, ModelMap model) {
		return "/MF/EPMF2916488";
	}
	
	/**
	 * 실태조사 증빙파일등록  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2916488_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2916488_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2916401Service.epmf2916488_select(inputMap, request)).toString();
	}	
	
	/**
	 * 실태조사 증빙파일등록  저장
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2916488_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPMF2916488_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
	
		String errCd = "";
		try{
			errCd = epmf2916401Service.epmf2916488_insert(inputMap, request);
			
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
	 * 실태조사 증빙파일등록  삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2916488_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPMF2916488_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
	
		
		String errCd = "";
		try{
			errCd = epmf2916401Service.epmf2916488_delete(inputMap, request);
			
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
	// 증빙파일조회
	//---------------------------------------------------------------------------------------------------------------------
	/**
	 * 실태조사 증빙파일조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF29164882.do", produces = "application/text; charset=utf8")
	public String EPMF29164882(HttpServletRequest request, ModelMap model) {
		return "/MF/EPMF29164882";
	}
	
	/**
	 * 실태조사 증빙파일조회  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF29164882_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPMF29164882_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2916401Service.epmf29164882_select(inputMap, request)).toString();
	}	
	
	//---------------------------------------------------------------------------------------------------------------------
	// 실태조사요청정보
	//---------------------------------------------------------------------------------------------------------------------
	/**
	 * 실태조사 실태조사요청정보 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF29164883.do", produces = "application/text; charset=utf8")
	public String EPMF29164883(HttpServletRequest request, ModelMap model) {
		return "/MF/EPMF29164883";
	}
	
	/**
	 * 실태조사 실태조사요청정보  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF29164883_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf29164883_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2916401Service.epmf29164883_select(inputMap, request)).toString();
	}	
	
	/**
	 * 실태조사 실태조사요청정보  등록
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF29164883_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf29164883_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
	
		
		String errCd = "";
		try{
			errCd = epmf2916401Service.epmf29164883_update(inputMap, request);
			
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
	 * 실태조사표 조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/MF/EPMF29164313.do", produces = "application/text; charset=utf8")
	public String epmf29164313(HttpServletRequest request, ModelMap model) {

		model =epmf2916401Service.epmf29164313_select(model, request);
		return "/MF/EPMF29164313";
	}
	
	/**
	 * 실태조사 실태조사표 확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF29164313_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf29164313_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
	
		
		String errCd = "";
		try{
			errCd = epmf2916401Service.EPMF29164313_update(inputMap, request);
			
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