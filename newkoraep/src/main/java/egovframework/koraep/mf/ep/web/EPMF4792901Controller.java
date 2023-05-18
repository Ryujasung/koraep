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
import egovframework.koraep.mf.ep.service.EPMF4792901Service;

/**
 * 교환정산 Controller
 * @author Administrator
 *
 */

@Controller
public class EPMF4792901Controller {

	@Resource(name="epmf4792901Service")
	private EPMF4792901Service epmf4792901Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 교환정산 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4792901.do")
	public String epmf4792901(ModelMap model, HttpServletRequest request) {
		model = epmf4792901Service.epmf4792901_select(model, request);
		
		return "/MF/EPMF4792901";
	}
	
	/**
	 * 교환정산등록 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4792931.do")
	public String epmf4792931(ModelMap model, HttpServletRequest request) {
		model = epmf4792901Service.epmf4792931_select(model, request);
		
		return "/MF/EPMF4792931";
	}
	
	/**
	 * 교환정산 내역조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4792964.do")
	public String epmf4792964(ModelMap model, HttpServletRequest request) {
		model = epmf4792901Service.epmf4792964_select(model, request);
		
		return "/MF/EPMF4792964";
	}
	
	/**
	 * 교환정산 상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF47929642.do")
	public String epmf47929642(ModelMap model, HttpServletRequest request) {
		model = epmf4792901Service.epmf47929642_select(model, request);
		
		return "/MF/EPMF47929642";
	}
	
	/**
	 * 교환정산등록 상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF47929644.do")
	public String epmf47929644(ModelMap model, HttpServletRequest request) {
		model = epmf4792901Service.epmf47929644_select(model, request);
		
		return "/MF/EPMF47929644";
	}
	
	/**
	 * 교환정산 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4792901_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0101801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf4792901Service.epmf4792901_select2(data, request)).toString();
	}
	
	/**
	 * 교환정산등록 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4792931_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0101831_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf4792901Service.epmf4792931_select(data, request)).toString();
	}
	
	/**
	 * 교환정산 등록
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4792931_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4792931_insert(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epmf4792901Service.epmf4792931_insert(data, request);
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
	 * 교환정산 상태변경
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4792901_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4792901_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epmf4792901Service.epmf4792901_update(data, request);
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
	 * 교환정산 요청취소
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4792901_212.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4792901_update2(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epmf4792901Service.epmf4792901_update2(data, request);
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
	 * 교환정산서발급 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF47929312.do")
	public String epmf47929312(ModelMap model, HttpServletRequest request) {
		model = epmf4792901Service.epmf47929312_select(model, request);
		
		return "/MF/EPMF47929312";
	}
	
	/**
	 * 교환정산서발급 
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF47929312_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf47929312_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epmf4792901Service.epmf47929312_insert(data, request);
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
	 * 교환정산서 상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF47929643.do")
	public String epmf47929643(ModelMap model, HttpServletRequest request) {
		model = epmf4792901Service.epmf47929643_select(model, request);
		
		return "/MF/EPMF47929643";
	}
	
}
