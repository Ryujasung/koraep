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
import egovframework.koraep.ce.ep.service.EPCE0181001Service;
import net.sf.json.JSONObject;


/**
 * 도매 도매업자 지점관리
 * @author 양성수
 *
 */
@Controller
public class EPCE0181001Controller {

	@Resource(name = "epce0181001Service")
	private  EPCE0181001Service epce0181001Service;// 도매업자 지점관리 service

	@Resource(name = "commonceService")
	private CommonCeService commonceService;//공통  service


	/**
	 *  도매업자 지점관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0181001.do", produces = "application/text; charset=utf8")
	public String epce0181001(HttpServletRequest request, ModelMap model) {
		model =epce0181001Service.epce0181001_select(model, request);
		return "/CE/EPCE0181001";
	}

	/**
	 *   도매업자 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0181001_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0181001_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0181001Service.epce0181001_select4(inputMap, request)).toString();
	}


	/**
	 *  총괄지점 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0181001_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0181001_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0181001Service.epce0181001_select2(inputMap, request)).toString();
	}

	/**
	 * 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0181001_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0181001_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0181001Service.epce0181001_select3(inputMap, request)).toString();
	}


	/**
	 * 도매업자 지점관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0181001_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0181001_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = epce0181001Service.epce0181001_excel(data, request);
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
	 * 활동/비활동
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0181001_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0181001_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce0181001Service.epce0181001_update(inputMap, request);
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

/***************************************************************************************************************************************************************************************
 * 		도매업자 지점관리 저장/ 수정
 ****************************************************************************************************************************************************************************************/

	/**
	 *  도매업자 지점관리 등록 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0181031.do", produces = "application/text; charset=utf8")
	public String epce0181031(HttpServletRequest request, ModelMap model) {
		model = epce0181001Service.epce0181031_select(model, request);

		return "/CE/EPCE0181031";
	}

	/**
	 *  도매업자 지점관리 변경 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0181042.do", produces = "application/text; charset=utf8")
	public String epce0181042(HttpServletRequest request, ModelMap model) {
		model = epce0181001Service.epce0181042_select(model, request);

		return "/CE/EPCE0181042";
	}


	/**
	 * 그룹여부 변경시 총괄지점 검색
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0181031_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0181031_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce0181001Service.epce0181031_select(data)).toString();
	}

	/**
	 * 지점 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0181031_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0181031_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = epce0181001Service.epce0181031_insert(data, request);
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
	 * 지점 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0181042_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0181042_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			errCd = epce0181001Service.epce0181042_update(data, request);
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


	/***************************************************************************************************************************************************************************************
	 * 					지역 일괄 설정
	 ****************************************************************************************************************************************************************************************/

	/**
	 *  지역 일괄 설정 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0181088.do", produces = "application/text; charset=utf8")
	public String epce0181088(HttpServletRequest request, ModelMap model) {
		model =epce0181001Service.epce0181088_select(model, request);
		return "/CE/EPCE0181088";
	}

	/**
	 * 지역 일괄 설정 저장/수정
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0181088_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0181088_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce0181001Service.epce0181088_update(inputMap, request);
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

	/***************************************************************************************************************************************************************************************
	 * 				단체 설정
	 ****************************************************************************************************************************************************************************************/

	/**
	 *  단체 설정 설정 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE01810882.do", produces = "application/text; charset=utf8")
	public String epce01810882(HttpServletRequest request, ModelMap model) {
		model =epce0181001Service.epce01810882_select(model, request);
		return "/CE/EPCE01810882";
	}

	/**
	 *  소속단체설정 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE01810883.do", produces = "application/text; charset=utf8")
	public String epce01810883(HttpServletRequest request, ModelMap model) {
		model =epce0181001Service.epce01810883_select(model, request);
		return "/CE/EPCE01810883";
	}

	/**
	 * 단체 설정 저장/수정
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE01810882_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce01810882_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce0181001Service.epce01810882_update(inputMap, request);
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
	 * ERP설정 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE01810884.do", produces = "application/text; charset=utf8")
	public String epce01810884(HttpServletRequest request, ModelMap model) {
		model =epce0181001Service.epce01810884_select(model, request);
		return "/CE/EPCE01810884";
	}
	
	/**
	 * ERP 설정 저장/수정
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE01810884_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce01810884_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce0181001Service.epce01810884_update(inputMap, request);
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
}
