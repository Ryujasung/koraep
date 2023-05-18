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
import egovframework.koraep.ce.ep.service.EPCE4792901Service;

/**
 * 교환정산 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE4792901Controller {

	@Resource(name="epce4792901Service")
	private EPCE4792901Service epce4792901Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 교환정산 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4792901.do")
	public String epce4792901(ModelMap model, HttpServletRequest request) {
		model = epce4792901Service.epce4792901_select(model, request);
		
		return "/CE/EPCE4792901";
	}
	
	/**
	 * 교환정산등록 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4792931.do")
	public String epce4792931(ModelMap model, HttpServletRequest request) {
		model = epce4792901Service.epce4792931_select(model, request);
		
		return "/CE/EPCE4792931";
	}
	
	/**
	 * 교환정산 내역조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4792964.do")
	public String epce4792964(ModelMap model, HttpServletRequest request) {
		model = epce4792901Service.epce4792964_select(model, request);
		
		return "/CE/EPCE4792964";
	}
	
	/**
	 * 교환정산 상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE47929642.do")
	public String epce47929642(ModelMap model, HttpServletRequest request) {
		model = epce4792901Service.epce47929642_select(model, request);
		
		return "/CE/EPCE47929642";
	}
	
	/**
	 * 교환정산등록 상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE47929644.do")
	public String epce47929644(ModelMap model, HttpServletRequest request) {
		model = epce4792901Service.epce47929644_select(model, request);
		
		return "/CE/EPCE47929644";
	}
	
	/**
	 * 교환정산 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4792901_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0101801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4792901Service.epce4792901_select2(data)).toString();
	}
	
	/**
	 * 교환정산등록 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4792931_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0101831_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4792901Service.epce4792931_select(data)).toString();
	}
	
	/**
	 * 교환정산 등록
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4792931_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4792931_insert(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epce4792901Service.epce4792931_insert(data, request);
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
	@RequestMapping(value="/CE/EPCE4792901_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4792901_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epce4792901Service.epce4792901_update(data, request);
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
	@RequestMapping(value="/CE/EPCE4792901_212.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4792901_update2(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epce4792901Service.epce4792901_update2(data, request);
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
	@RequestMapping(value="/CE/EPCE47929312.do")
	public String epce47929312(ModelMap model, HttpServletRequest request) {
		model = epce4792901Service.epce47929312_select(model, request);
		
		return "/CE/EPCE47929312";
	}
	
	/**
	 * 교환정산서발급 
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE47929312_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce47929312_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epce4792901Service.epce47929312_insert(data, request);
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
	@RequestMapping(value="/CE/EPCE47929643.do")
	public String epce47929643(ModelMap model, HttpServletRequest request) {
		model = epce4792901Service.epce47929643_select(model, request);
		
		return "/CE/EPCE47929643";
	}
	
	/**
	 * 정산서발급취소
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE47929643_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce47929643_update(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			errCd = epce4792901Service.epce47929643_update(data, request);
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
