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
import egovframework.koraep.ce.ep.service.EPCE0101801Service;

/**
 * 생산자보증금잔액관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE0101801Controller {

	@Resource(name="epce0101801Service")
	private EPCE0101801Service epce0101801Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 생산자보증금잔액관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0101801.do")
	public String epce0101801(ModelMap model, HttpServletRequest request) {
		
		model = epce0101801Service.epce0101801_select(model, request);
		
		return "/CE/EPCE0101801";
	}
	
	/**
	 * 잔액 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0101801_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0101801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce0101801Service.epce0101801_select2(data)).toString();
	}
	
	/**
	 * 조정금액관리 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0101888.do", produces = "application/text; charset=utf8")
	public String epce0101888(ModelMap model, HttpServletRequest request) {
		
		model = epce0101801Service.epce0101888_select(model);
		
		return "/CE/EPCE0101888";
	}
	
	/**
	 * 조정금액관리 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0101888_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0101888_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce0101801Service.epce0101888_select2(data)).toString();
	}
	
	/**
	 * 조정금액관리 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0101888_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0101888_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0101801Service.epce0101888_update(data, request);
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
	 * 보증금잔액관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0101801_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0101801_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0101801Service.epce0101801_excel(data, request);
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
