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
import egovframework.koraep.ce.ep.service.EPCE0198201Service;

/**
 * 회수보증금관리 Controller
 * @author 양성수
 *
 */
@Controller
public class EPCE0198201Controller {

	@Resource(name = "epce0198201Service")
	private  EPCE0198201Service epce0198201Service; 	//회수보증금관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 *회수보증금관리 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0198201.do", produces = "application/text; charset=utf8")
	public String epce0198201(HttpServletRequest request, ModelMap model) {
		
		model=   epce0198201Service.epce0198201_select(model, request);

	return "/CE/EPCE0198201";
	}
	
	/**
	 * 회수보증금관리 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0198201_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0198201_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0198201Service.epce0198201_select2(inputMap, request)).toString();
	}	
	
	
	/**
	 * 회수보증금관리 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0198201_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0198201_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epce0198201Service.epce0198201_delete(inputMap, request);
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
	
	
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//	회수보증금등록
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	
	/**
	 *회수보증금등록 초기화면     
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0198231.do", produces = "application/text; charset=utf8")
	public String epce0198231(HttpServletRequest request, ModelMap model) {
		model=   epce0198201Service.epce0198231_select(model, request);

	return "/CE/EPCE0198231";
	}
	
	/**
	 * 회수보증금등록 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0198231_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0198231_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0198201Service.epce0198231_insert(data, request);
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
	
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//	회수보증금등록
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	/**
	 *회수보증금변경 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0198242.do", produces = "application/text; charset=utf8")
	public String epce0198242(HttpServletRequest request, ModelMap model) {
		model=   epce0198201Service.epce0198242_select(model, request);

	return "/CE/EPCE0198242";
	}
	
	
	/**
	 * 회수보증금변경 변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0198242_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0198242_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0198201Service.epce0198242_update(data, request);
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
