package egovframework.koraep.wh.ep.web;

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
import egovframework.koraep.wh.ep.service.EPWH0117301Service;

/**
 * 가맹점관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPWH0117301Controller {

	
	@Resource(name="EPWH0117301Service")
	private EPWH0117301Service epwh0117301Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 가맹점관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0117301.do")
	public String EPWH0117301(ModelMap model, HttpServletRequest request) {
		
		model = epwh0117301Service.EPWH0117301_select(model, request);
		
		return "/WH/EPWH0117301";
	}
	
	/**
	 * 가맹점관리 등록 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0117331.do")
	public String epwh0120631(ModelMap model, HttpServletRequest request) {
		
		model = epwh0117301Service.EPWH0117331_select(model, request);
		
		return "/WH/EPWH0117331";
	}
	
	/**
	 * 소매업무설정 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0117342.do")
	public String epwh0120642(ModelMap model, HttpServletRequest request) {
		
		model = epwh0117301Service.EPWH0117342_select(model, request);
		
		return "/WH/EPWH0117342";
	}
	
	/**
	 * 소매업무설정 도매업자 선택시
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0117342_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0117342_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epwh0117301Service.epwh0117342_select(data, request)).toString();	
	}
	
	/**
	 * 적용대상 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0117342_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0117342_select3(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epwh0117301Service.epwh0117342_select2(data, request)).toString();	
	}
	
	/**
	 * 업무설정 일괄적용
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0117342_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0117342_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh0117301Service.epwh0117342_update(data, request);
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
