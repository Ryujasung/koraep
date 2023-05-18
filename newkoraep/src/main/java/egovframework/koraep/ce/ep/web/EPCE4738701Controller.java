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
import egovframework.koraep.ce.ep.service.EPCE2983901Service;
import egovframework.koraep.ce.ep.service.EPCE4738701Service;
import net.sf.json.JSONObject;


/**
 * 입고정정
 * @author 양성수
 *
 */
@Controller
public class EPCE4738701Controller {

	@Resource(name = "epce4738701Service")
	private  EPCE4738701Service epce4738701Service;// 입고정정 service

	@Resource(name = "epce2983901Service")
	private  EPCE2983901Service epce2983901Service;//입고관리 service

	@Resource(name = "epce2910101Service")
	private  EPCE2910101Service epce2910101Service;//반환관리 service

	@Resource(name = "commonceService")
	private CommonCeService commonceService;//공통  service


	/**
	 *  입고정정  페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE4738701.do", produces = "application/text; charset=utf8")
	public String epce4738701(HttpServletRequest request, ModelMap model) {
		model =epce4738701Service.epce4738701_select(model, request);
		return "/CE/EPCE4738701";
	}

	/**
	 *  입고정정 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4738701_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4738701_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4738701Service.epce4738701_select2(inputMap, request)).toString();
	}

	/**
	 * 입고정정 도매업자 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4738701_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4738701_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4738701Service.epce4738701_select3(inputMap, request)).toString();
	}

	/**
	 * 입고정정 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4738701_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4738701_select3(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4738701Service.epce4738701_select4(inputMap, request)).toString();
	}

	/**
	 * 입고정정 생산자 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4738701_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4738701_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4738701Service.epce4738701_select5(inputMap, request)).toString();
	}

	/**
	 * 입고정정   엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4738701_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce4738701_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = epce4738701Service.epce4738701_excel(data, request);
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
	 * 입고정정 정정확인 정정반려 확인취소 상태 변경
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4738701_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4738701_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce4738701Service.epce4738701_update(inputMap, request);
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
	//	입고정정 내역조회
	//---------------------------------------------------------------------------------------------------------------------

	/**
	 * 입고정정 내역조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE4738764.do", produces = "application/text; charset=utf8")
	public String epce4738764(HttpServletRequest request, ModelMap model) {
		model = epce4738701Service.epce4738764_select(model, request);
		return "/CE/EPCE4738764";
	}


	/**
	 * 입고정정내역조회 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4738764_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4738764_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = epce4738701Service.epce4738764_delete(inputMap, request);
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
	//	입고정정이월처리
	//---------------------------------------------------------------------------------------------------------------------

	/**
	 * 입고정정이월가능여부 확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4738701_195.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4738701_select5(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		String errCd = "0000";
		
		try{
			rtnMap = epce4738701Service.epce4738701_select6(inputMap, request);
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
		
		if(("0000").equals(errCd)) {
			rtnObj.put("EXCA_STD_NM",rtnMap.get("EXCA_STD_NM"));
			rtnObj.put("EXCA_STD_CD",rtnMap.get("EXCA_STD_CD"));
		}
		
		return rtnObj.toString();
	}

	/**
	 * 입고정정이월처리
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4738701_212.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4738701_update2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce4738701Service.epce4738701_update2(inputMap, request);
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