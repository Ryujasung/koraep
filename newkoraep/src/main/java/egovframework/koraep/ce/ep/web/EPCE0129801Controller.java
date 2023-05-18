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
import egovframework.koraep.ce.ep.service.EPCE0129801Service;

/**
 * 부서관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE0129801Controller {

	
	@Resource(name="epce0129801Service")
	private EPCE0129801Service epce0129801Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 부서관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0129801.do")
	public String epce0129801_select(ModelMap model, HttpServletRequest request) {
		
		model = epce0129801Service.epce0129801_select(model, request);
		
		return "/CE/EPCE0129801";
	}
	
	/**
	 * 부서관리 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE012980119.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0129801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce0129801Service.epce0129801_select2(data)).toString();
	}
	
	/**
	 * 부서관리 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0129801_05.do")
	@ResponseBody
	public String epce0129801_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0129801Service.epce0129801_excel(data, request);
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
	 * 부서관리 등록 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0129831.do")
	public String epce0129831_select(ModelMap model, HttpServletRequest request) {
		
		model = epce0129801Service.epce0129831_select(model, request);
		
		return "/CE/EPCE0129831";
	}
	
	/**
	 * 업체명 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0129831_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0129831_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce0129801Service.epce0129831_select2(data)).toString();
	}
	
	/**
	 * 상위부서코드 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0129831_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0129831_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce0129801Service.epce0129831_select3(data, request)).toString();
	}
	
	/**
	 * 변경페이지
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0129842.do")
	public String epce0129842_select(ModelMap model, HttpServletRequest request) {
		
		model = epce0129801Service.epce0129842_select(model, request);
		
		return "/CE/EPCE0129842";
	}
	/**
	 * 부서코드 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0129831_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0129831_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0129801Service.epce0129831_insert(data, request);
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
	 * 부서코드 수정
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0129842_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0129842_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0129801Service.epce0129842_update(data, request);
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
	 * 활동상태 변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0129801_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0129801_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0129801Service.epce0129801_update(data, request);
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
