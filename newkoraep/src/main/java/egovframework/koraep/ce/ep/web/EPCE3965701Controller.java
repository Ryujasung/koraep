package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

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
import egovframework.koraep.ce.ep.service.EPCE3944888Service;
import egovframework.koraep.ce.ep.service.EPCE3944801Service;
import egovframework.koraep.ce.ep.service.EPCE3965701Service;

/**
 * 오류코드 Controller
 * 
 * @author 양성수
 * 
 */
@Controller
public class EPCE3965701Controller {

	@Resource(name = "epce3965701Service")
	private EPCE3965701Service epce3965701Service; // 오류코드 service

	@Resource(name = "epce3944801Service")
	private EPCE3944801Service epce3944801Service; // 다국어관리 service

	@Resource(name = "epce3944888Service")
	private EPCE3944888Service epce3944888Service; // 언어구분관리 service

	@Resource(name = "commonceService")
	private CommonCeService commonceService; // 공통 service

	private static final Logger log = LoggerFactory.getLogger(EPCE3965701Controller.class);

	/**
	 * 오류코드 페이지 호출 및 초기값
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/CE/EPCE3965701.do", produces = "application/text; charset=utf8")
	public String epce3965701(HttpServletRequest request, ModelMap model)	 {

		// 언어구분리스트 , 오류구분코드 셋팅
		model = epce3965701Service.epce3965701_select(model, request);

		return "/CE/EPCE3965701";
	}
	
	/**
	 * 오류코드 리스트 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3965701_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3965701_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3965701Service.epce3965701_select2(inputMap, request)).toString();
	}	
	
	
	/**
	 * 언어구분 변경시 언어에 맞는 오류구분으로  변경
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3965701_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3965701_select2(@RequestParam HashMap<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3965701Service.epce3965701_select3(inputMap, request)).toString();
	}	
	
	
	/**
	 *  오류코드  저장 수정 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3965701_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3965701_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
	    String errCd = "";
		try{
			errCd = epce3965701Service.epce3965701_select4(inputMap, request);
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
	 * 오류코드관리 저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3965701_09.do", produces="application/text; charset=utf8")
	@ResponseBody
    @Transactional
	public String epce3965701_insert(@RequestParam Map<String, String> data, HttpServletRequest request)  {
	
	    String errCd = "";
		try{
	
			errCd = epce3965701Service. epce3965701_insert(data, request);
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
