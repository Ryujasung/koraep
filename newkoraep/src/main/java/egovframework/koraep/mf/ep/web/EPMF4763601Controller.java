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
import egovframework.koraep.mf.ep.service.EPMF4763601Service;

/**
 * 직접회수정정 Controller
 * @author Administrator
 *
 */

@Controller
public class EPMF4763601Controller {

	@Resource(name="epmf4763601Service")
	private EPMF4763601Service epmf4763601Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 직접회수정정 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4763601.do")
	public String epmf4763601(ModelMap model, HttpServletRequest request) {
		model = epmf4763601Service.epmf4763601_select(model, request);
		
		return "/MF/EPMF4763601";
	}
	
	/**
	 * 직접회수정정 등록 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4763631.do")
	public String epmf4763631(ModelMap model, HttpServletRequest request) {
		model = epmf4763601Service.epmf4763631_select(model, request);
		
		return "/MF/EPMF4763631";
	}
	
	/**
	 * 직접회수정정 수정 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4763642.do")
	public String epmf4763642(ModelMap model, HttpServletRequest request) {
		model = epmf4763601Service.epmf4763642_select(model, request);
		
		return "/MF/EPMF4763642";
	}
	
	/**
	 * 직접회수정정 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4763601_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0101801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf4763601Service.epmf4763601_select2(data, request)).toString();
	}

	/**
	 * 직접회수정정 생산자선택시 
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4763601_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf6658201_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf4763601Service.epmf4763601_select3(data, request)).toString();
	}
	
	/**
	 * 직접회수정정 등록
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4763631_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4763631_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf4763601Service.epmf4763631_insert(data, request);
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
	 * 직접회수정정 수정
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4763642_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6663642_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epmf4763601Service.epmf4763642_update(data, request);
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
	 * 직접회수정정 삭제
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4763601_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4763601_delete(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epmf4763601Service.epmf4763601_delete(data, request);
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
	 * 직접회수정정 상태변경
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4763601_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4763601_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epmf4763601Service.epmf4763601_update(data, request);
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
	 * 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4763601_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf4763601_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf4763601Service.epmf4763601_excel(data, request);
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
