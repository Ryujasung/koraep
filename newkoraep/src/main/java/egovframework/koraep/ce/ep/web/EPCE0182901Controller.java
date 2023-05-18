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
import egovframework.koraep.ce.ep.service.EPCE0182901Service;

/**
 * 회수수수료관리 Controller
 * @author 양성수
 *
 */
@Controller
public class EPCE0182901Controller{

	@Resource(name = "epce0182901Service")
	private  EPCE0182901Service epce0182901Service; 	//회수수수료관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 *회수수수료관리 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0182901.do", produces = "application/text; charset=utf8")
	public String epce0182901(HttpServletRequest request, ModelMap model) {
		
		model=   epce0182901Service.epce0182901_select(model, request);

	return "/CE/EPCE0182901";
	}
	  
  /**
	 * 회수수수료관리 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0182901_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0182901_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0182901Service.epce0182901_select2(inputMap, request)).toString();
	}	
	
	
	/**
	 * 회수수수료관리 삭제
	 * @param inputMap			
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0182901_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0182901_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epce0182901Service.epce0182901_delete(inputMap, request);
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
	
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//	회수수수료 등록
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
	
	
	/**
	 *회수수수료등록 초기화면     
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0182931.do", produces = "application/text; charset=utf8")
	public String epce0182931(HttpServletRequest request, ModelMap model) {
		model=   epce0182901Service.epce0182931_select(model, request);

	return "/CE/EPCE0182931";
	}
	
	/**
	 * 회수수수료등록 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0182931_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0182931_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0182901Service.epce0182931_insert(data, request);
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
	
	
	
	
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//	회수수수료 수정
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
	
	/**
	 *  회수수수료변경 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0182942.do", produces = "application/text; charset=utf8")
	public String epce0182942(HttpServletRequest request, ModelMap model) {
		model=   epce0182901Service.epce0182942_select(model, request);

	return "/CE/EPCE0182942";
	}
	
	
	/**
	 * 회수수수료변경 변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0182942_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0182942_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0182901Service.epce0182942_update(data, request);
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
