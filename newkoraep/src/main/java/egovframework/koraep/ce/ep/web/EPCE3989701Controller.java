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
import egovframework.koraep.ce.ep.service.EPCE3989701Service;

/**
 * 알림관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE3989701Controller {

	@Resource(name="epce3989701Service")
	private EPCE3989701Service epce3989701Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 알림내역 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value={"/CE/EPCE5589775.do", "/MF/EPMF5589775.do", "/WH/EPWH5589775.do", "/RT/EPRT5589775.do"})
	public String epce5589775(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		model = epce3989701Service.epce3989775_select(model, request, data);
		return "/CE/EPCE5589775";
		
	}
	
	/**
	 * 공지알림이력조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE5589776.do", produces="text/plain;charset=UTF-8")
	public String epce5589776(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		model = epce3989701Service.epce3989776_select(model, request, data);
		return "/CE/EPCE5589776";
		
	}
	
	/**
	 * 공지알림이력조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE5589776_1.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce5589776_selectList(@RequestParam Map<String, String> inputMap, HttpServletRequest request) {
		return util.mapToJson(epce3989701Service.epce5589776_selectList(inputMap, request)).toString();
	}
	
	/**
	 * 알림관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value={"/CE/EPCE3989701.do", "/MF/EPMF3989701.do", "/WH/EPWH3989701.do", "/RT/EPRT3989701.do"})
	public String epce3989701(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		//if(data.containsKey("ANC_STD_CD")){
		//	model = epce3989701Service.epce3989775_select(model, request, data);
		//	return "/CE/EPCE3989775";
		//}else{
			model = epce3989701Service.epce3989701_select(model);
			return "/CE/EPCE3989701";
		//}
	}
	
	/**
	 * 알림관리 사용여부 수정
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3989701_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3989701_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = epce3989701Service.epce3989701_update(data, request);
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
	 * 알림관리 메세지 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3989701_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3989701_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = epce3989701Service.epce3989701_insert(data, request);
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
