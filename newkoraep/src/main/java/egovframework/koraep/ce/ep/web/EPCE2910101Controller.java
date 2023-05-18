package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE2910101Service;
import net.sf.json.JSONObject;


/**
 * 반환관리
 * @author 양성수
 *
 */
@Controller
public class EPCE2910101Controller {

	@Resource(name = "epce2910101Service")
	private  EPCE2910101Service epce2910101Service; 	//반환관리 service

	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service


	/**
	 * 반환관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE2910101.do", produces = "application/text; charset=utf8")
	public String epce2910101(HttpServletRequest request, ModelMap model) {

		model =epce2910101Service.epce2910101_select(model, request);
		return "/CE/EPCE2910101";
	}
	
	/**
	 * 반환관리상세 페이지 호출(20200402)
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE2910102.do", produces = "application/text; charset=utf8")
	public String epce2910102(HttpServletRequest request, ModelMap model) {

		model =epce2910101Service.epce2910101_select_1(model, request);
		return "/CE/EPCE2910102";
	}

	/**
	 *  반환관리  생산자에 따른 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2910101_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2910101_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce2910101Service.epce2910101_select2(inputMap, request)).toString();
	}

	/**
	 * 반환관리 생산자 직매장/공장 선택시  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2910101_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2910101_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce2910101Service.epce2910101_select3(inputMap, request)).toString();
	}

	/**
	 * 반환관리 도매업자 구분 선택시 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2910101_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2910101_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce2910101Service.epce2910101_select4(inputMap, request)).toString();
	}

	/**
	 * 반환관리  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2910101_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2910101_select4(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce2910101Service.epce2910101_select5(inputMap, request)).toString();
	}
	
	/**
	 * 반환내역상제조회(20200402추가)
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2910101_195.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2910101_select5_1(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce2910101Service.epce2910101_select5_1(inputMap, request)).toString();
	}

	/**
	 * 반환관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2910101_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6624501_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epce2910101Service.epce2910101_excel(data, request);
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}
	
	/**
	 * 반환내역상세  엑셀저장(20200402 추가)
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2910102_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2910102_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epce2910101Service.epce2910102_excel(data, request);
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}

	/**
	 * 반환관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2910164_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2910164_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epce2910101Service.epce2910164_excel(data, request);
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}


	/**
	 * 반환관리  삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2910101_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2910101_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = epce2910101Service.epce2910101_delete(inputMap, request);
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		return rtnObj.toString();
	}
	
	/**
	 * 반환관리  실태조사
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2910101_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2910101_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = epce2910101Service.epce2910101_update(inputMap, request);
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}

	/**
	 * 반환등록요청 일괄확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2910101_212.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2910101_update2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = epce2910101Service.epce2910101_update2(inputMap, request);
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}
	
	/**
	 * 반환관리 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE2910164.do", produces = "application/text; charset=utf8")
	public String epce2910164(HttpServletRequest request, ModelMap model) {

		model =epce2910101Service.epce2910164_select(model, request);
		return "/CE/EPCE2910164";
	}




}
