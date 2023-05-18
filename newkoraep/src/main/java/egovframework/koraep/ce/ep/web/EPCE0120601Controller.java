package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE0120601Service;
import net.sf.json.JSONObject;

/**
 * 직매장별거래처관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE0120601Controller {


	@Resource(name="epce0120601Service")
	private EPCE0120601Service epce0120601Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service

	/**
	 * 거래구분변경 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0120602.do")
	public String epce0120602_select(ModelMap model, HttpServletRequest request) {

		model = epce0120601Service.epce0120602_select(model, request);

		return "/CE/EPCE0120602";
	}

	/**
	 * 직매장별거래처관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0120601.do")
	public String epce0120601_select(ModelMap model, HttpServletRequest request) {

		model = epce0120601Service.epce0120601_select(model, request);

		return "/CE/EPCE0120601";
	}

	/**
	 * 직매장별거래처관리 등록 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0120631.do")
	public String epce0120631_select(ModelMap model, HttpServletRequest request) {

		model = epce0120601Service.epce0120631_select(model, request);

		return "/CE/EPCE0120631";
	}

	/**
	 * 직매장별거래처관리 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE012060119.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0120601_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce0120601Service.epce0120601_select2(data)).toString();
	}

	/**
	 * 직매장별거래처관리 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0120601_05.do")
	@ResponseBody
	public String epce0120601_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			errCd = epce0120601Service.epce0120601_excel(data, request);
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
	 * 직매장별거래처관리  직매장/공장 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0120601192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0120601_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce0120601Service.epce0120601_select3(data, request)).toString();
	}

	/**
	 * 직매장별거래처관리 등록 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE012063119.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0120631_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce0120601Service.epce0120631_select2(data)).toString();
	}


	/**
	 * 거래상태 변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0120601_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0120601_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			errCd = epce0120601Service.epce0120601_update(data, request);
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
	 * 거래구분변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0120602_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0120602_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			errCd = epce0120601Service.epce0120602_update(data, request);
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
	 * 기준수수료생성
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0120601_212.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0120601_update2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epce0120601Service.epce0120601_update2(data, request);
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
	 * 직매장별거래처관리 등록확인
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0120675.do")
	public String epce0120675_select(ModelMap model, HttpServletRequest request) {

		model = epce0120601Service.epce0120675_select(model, request);

		return "/CE/EPCE0120675";
	}

	/**
	 * 거래처 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0120631_31.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0120631_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			errCd = epce0120601Service.epce0120631_insert(data, request);
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
