package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE3965801Service;
import net.sf.json.JSONObject;

/**
 * 생산자제품코드관리 Controller
 * 
 * @author 유병승
 * 
 */
@Controller
public class EPCE3965801Controller {

	@Resource(name = "epce3965801Service")
	private EPCE3965801Service epce3965801Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; // 공통 service

	private static final Logger log = LoggerFactory.getLogger(EPCE3965801Controller.class);

	/**
	 * 생산자제품코드관리 페이지 호출 및 초기값
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/CE/EPCE3965801.do", produces = "application/text; charset=utf8")
	public String epce3965801(HttpServletRequest request, ModelMap model)	 {
		model = epce3965801Service.epce3965801_select(model, request);
		return "/CE/EPCE3965801";
	}
	
	/**
	 * 생산자제품코드관리 리스트 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3965801_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3965801_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3965801Service.epce3965801_select2(inputMap, request)).toString();
	}	
	
	
	/**
	 * 빈용기 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3965801_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3965801_select2(@RequestParam HashMap<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3965801Service.epce3965801_select3(inputMap, request)).toString();
	}	
	
	
	/**
	 *  생산자제품코드관리  저장 수정 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3965801_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3965801_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
	    String errCd = "";
		try{
			errCd = epce3965801Service.epce3965801_select4(inputMap, request);
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
		
		return rtnObj.toString();
	}
	
	/**
	 * 생산자제품코드관리관리 저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3965801_09.do", produces="application/text; charset=utf8")
	@ResponseBody
    @Transactional
	public String epce3965801_insert(@RequestParam Map<String, String> data, HttpServletRequest request)  {
	    String errCd = "";
		try{
			errCd = epce3965801Service.epce3965801_insert(data, request);
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
