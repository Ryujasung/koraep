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
import egovframework.koraep.ce.ep.service.EPCE2308801Service;

/**
 * 수납확인내역조회 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE2308801Controller {

	@Resource(name="epce2308801Service")
	private EPCE2308801Service epce2308801Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 수납확인내역조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2308801.do")
	public String epce2308801(ModelMap model, HttpServletRequest request) {
		
		model = epce2308801Service.epce2308801_select(model, request);
		
		return "/CE/EPCE2308801";
	}
	
	/**
	 * 수납확인내역 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2308801_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2308801_select(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce2308801Service.epce2308801_select2(data)).toString();
	}

	/**
	 * 수납확인내역 상세조회팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2308888.do", produces="application/text; charset=utf8")
	public String epce2308888(ModelMap model, HttpServletRequest request) {
		
		String title = commonceService.getMenuTitle("EPCE2308888");
		model.addAttribute("titleSub", title);
		
		return "/CE/EPCE2308888";
	}
	
	/**
	 * 수납확인 상세조회 (고지서)
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2308888_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2308888_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce2308801Service.epce2308888_select(data)).toString();
	}
	
	/**
	 * 수납확인 상세조회 (수납내역)
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2308888_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2308888_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce2308801Service.epce2308888_select2(data)).toString();
	}
	
	/**
	 * 수납확인내역조회 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2308801_05.do")
	@ResponseBody
	public String epce2308801_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce2308801Service.epce2308801_excel(data, request);
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
