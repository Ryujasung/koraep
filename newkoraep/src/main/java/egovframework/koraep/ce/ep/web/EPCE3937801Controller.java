package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;

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
import egovframework.koraep.ce.ep.service.EPCE3937801Service;

/**
 * 권한그룹관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE3937801Controller {

	
	@Resource(name="epce3937801Service")
	private EPCE3937801Service epce3937801Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 권한그룹관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3937801.do")
	public String epce3937801(ModelMap model, HttpServletRequest request) {
		
		model = epce3937801Service.epce3937801_select(model, request);
		
		return "/CE/EPCE3937801";
	}
	
	/**
	 * 권한그룹 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE393780119.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3937801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce3937801Service.epce3937801_select2(data)).toString();
	}
	
	/**
	 * 권한그룹관리 등록 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3937831.do")
	public String epce3937831_select(ModelMap model, HttpServletRequest request) {
		
		model = epce3937801Service.epce3937831_select(model, request);
		
		return "/CE/EPCE3937831";
	}
	
	/**
	 * 권한그룹관리 변경 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3937842.do")
	public String epce3937842_select(ModelMap model, HttpServletRequest request) {
		
		model = epce3937801Service.epce3937842_select(model, request);
		
		return "/CE/EPCE3937842";
	}

	/**
	 * 권한그룹 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE393783109.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3937831_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce3937801Service.epce3937831_insert(data, request);
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
	 * 권한그룹 수정
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE393783121.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3937842_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce3937801Service.epce3937842_update(data, request);
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
