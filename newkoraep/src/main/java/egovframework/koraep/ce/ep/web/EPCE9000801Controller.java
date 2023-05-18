package egovframework.koraep.ce.ep.web;

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
import egovframework.koraep.ce.ep.service.EPCE9000801Service;


/**
 * 소모품관리
 * @author 양성수
 *
 */
@Controller
public class EPCE9000801Controller {

	@Resource(name = "epce9000801Service")
	private  EPCE9000801Service epce9000801Service; 	

	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service


	/**
	 * 소모품관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000801.do", produces = "application/text; charset=utf8")
	public String epce9000801(HttpServletRequest request, ModelMap model) {
		
		model =epce9000801Service.epce9000801_select(model, request);
		//model = epce2924601Service.epce2924601_select(model, request);
		return "/CE/EPCE9000801";
	}
	
	
	/**
	 *  소모품 정보변경
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000842.do", produces = "application/text; charset=utf8")
	public String epce9000842(HttpServletRequest request, ModelMap model) {
		model = epce9000801Service.epce9000842_select(model, request);

		return "/CE/EPCE9000842";
	}
	
	
	/**
	 * 소모품 정보 수정
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000842_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000831_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			
			
			errCd = epce9000801Service.epce9000831_update(data, request);
			
			
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
	 * 소모품관리 페이지 호출(20200402)
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000802.do", produces = "application/text; charset=utf8")
	public String epce9000802(HttpServletRequest request, ModelMap model) {

		model =epce9000801Service.epce9000801_select_1(model, request);
		return "/CE/EPCE9000802";
	}

	/**
	 *  반환관리  생산자에 따른 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000801_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000801_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000801Service.epce9000801_select2(inputMap, request)).toString();
	}

	/**
	 * 반환관리 생산자 직매장/공장 선택시  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000801_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000801_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000801Service.epce9000801_select3(inputMap, request)).toString();
	}

	/**
	 * 반환관리 도매업자 구분 선택시 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000801_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000801_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000801Service.epce9000801_select4(inputMap, request)).toString();
	}

	/**
	 * 무인회수기내역  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000801_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000801_select4(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000801Service.epce9000801_select5(inputMap, request)).toString();
	}
	
	/**
	 * 반환내역상제조회(20200402추가)
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000801_195.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000801_select5_1(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000801Service.epce9000801_select5_1(inputMap, request)).toString();
	}

	/**
	 * 반환관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000801_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6624501_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epce9000801Service.epce9000801_excel(data, request);
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
	 * 반환내역상세  엑셀저장(20200402 추가)
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000802_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000802_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epce9000801Service.epce9000802_excel(data, request);
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
	 * 반환관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000864_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000864_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epce9000801Service.epce9000864_excel(data, request);
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
	 * 반환관리  삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000801_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000801_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce9000801Service.epce9000801_delete(inputMap, request);
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
	 * 반환관리  실태조사
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000801_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000801_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = epce9000801Service.epce9000801_update(inputMap, request);
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
	 * 반환등록요청 일괄확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000801_212.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000801_update2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = epce9000801Service.epce9000801_update2(inputMap, request);
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
	 * 반환관리 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000864.do", produces = "application/text; charset=utf8")
	public String epce9000864(HttpServletRequest request, ModelMap model) {

		model =epce9000801Service.epce9000864_select(model, request);
		return "/CE/EPCE9000864";
	}

	/**
	 * 반환정보등록 
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000831.do", produces = "application/text; charset=utf8")
	public String epce9000831(HttpServletRequest request, ModelMap model) {

		model =epce9000801Service.epce9000801_select(model, request);
		return "/CE/EPCE9000831";
	}
	/**
	 * 반환내역서등록  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000831_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000831_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";

		try{
			errCd = epce9000801Service.epce9000801_insert(data, request);

		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
			if(data.get("ERR_CTNR_NM") !=null){
				//System.out.println(data.get("ERR_CTNR_NM").toString());
			}
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		
		if(errCd.charAt(0) == 'D' || errCd.charAt(0) == 'R') {
			String[] rtnArr = errCd.split("_");
			String rtnMsg = "";
			
			
			rtnObj.put("RSLT_CD", "E099");
			rtnObj.put("RSLT_MSG", rtnMsg);
			rtnObj.put("ERR_CTNR_NM", rtnMsg);
		}
		else {
			rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

			if(data.get("ERR_CTNR_NM") !=null){
				rtnObj.put("ERR_CTNR_NM", data.get("ERR_CTNR_NM").toString());
			}
		}
		
		return rtnObj.toString();
	}
	
	/**
	 * 엑셀 업로드 후처리
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000831_197.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000831_select7(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000801Service.epce9000831_select8(inputMap, request)).toString();
	}	
	
	
	/**
	 *소모품코드관리 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE90008011.do", produces = "application/text; charset=utf8")
	public String epce90008011(HttpServletRequest request, ModelMap model) {
		
		model=   epce9000801Service.epce90008011_select(model, request);

	return "/CE/EPCE90008011";
	}
	
	/**
	 *소모품코드관리등록 초기화면     
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE900080131.do", produces = "application/text; charset=utf8")
	public String epce900080131(HttpServletRequest request, ModelMap model) {
		model=   epce9000801Service.epce900080131_select(model, request);

	return "/CE/EPCE900080131";
	}
	
	/**
	 * 소모품코드단가등록 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE900080131_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce900080131_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce9000801Service.epce900080131_insert(data, request);
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
	 *  공급단가변경 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE900080142.do", produces = "application/text; charset=utf8")
	public String epce900080142(HttpServletRequest request, ModelMap model) {
		model=   epce9000801Service.epce900080142_select(model, request);

	return "/CE/EPCE900080142";
	}
	
	
	/**
	 * 공급단가변경 변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE900080142_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce900080142_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce9000801Service.epce900080142_update(data, request);
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
	 * 공급단가변경 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE90008011_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE90008011_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		System.out.println("1");
		return util.mapToJson(epce9000801Service.EPCE90008011_delete(inputMap, request)).toString();
	}	
	
	
	
	
	
	
	
	


}
