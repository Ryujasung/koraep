
package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.sql.SQLException;
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
import egovframework.koraep.ce.ep.service.EPCE4738731Service;

/**
 * 입고정정등록
 * @author 양성수
 *
 */
@Controller
public class EPCE4738731Controller {  

	@Resource(name = "epce4738731Service")
	private  EPCE4738731Service epce4738731Service; 	//입고정정등록 service
	
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 입고정정등록 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE4738731.do", produces = "application/text; charset=utf8")
	public String epce4738731(HttpServletRequest request, ModelMap model) {

		model =epce4738731Service.epce4738731_select(model, request);
		return "/CE/EPCE4738731";
	}
	
	/**
	 * 입고정정등록  빈용기명
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4738731_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4738731_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4738731Service.epce4738731_select2(inputMap, request)).toString();
	}	    
	
	
	/**
	 * 입고정정등록  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */									
	@RequestMapping(value="/CE/EPCE4738731_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce4738731_insert(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = epce4738731Service.epce4738731_insert(data, request);
			
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
	
	/***************************************************************************************************************************************************************************************
	 * 	 입고정정일괄등록 
	****************************************************************************************************************************************************************************************/
		
	/**
	 * 입고정정등록 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE47387312.do", produces = "application/text; charset=utf8")
	public String epce47387312(HttpServletRequest request, ModelMap model) {

		model =epce4738731Service.epce47387312_select(model, request);
		return "/CE/EPCE47387312";
	}
	
	/**
	 * 엑셀 업로드 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE47387312_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce47387312_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4738731Service.epce47387312_select2(inputMap, request)).toString();
	}	
	
	
	/**
	 * 입고정정등록  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */									
	@RequestMapping(value="/CE/EPCE47387312_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce47387312_insert(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = epce4738731Service.epce47387312_insert(data, request);
			
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
	
	
	/***************************************************************************************************************************************************************************************
	 * 	 입고정정수정
	****************************************************************************************************************************************************************************************/
	
	/**
	 * 입고정정등록 수정 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE4738742.do", produces = "application/text; charset=utf8")
	public String epce4738742(HttpServletRequest request, ModelMap model) {

		model =epce4738731Service.epce4738742_select(model, request);
		return "/CE/EPCE4738742";
	}
	
	/**
	 * 입고정정등록  수정
	 * @param map
	 * @param model
	 * @param request
	 * @return   
	 * @
	 */									
	@RequestMapping(value="/CE/EPCE4738742_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce4738731_update(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce4738731Service.epce4738742_update(data, request);
			
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
	
	
/***************************************************************************************************************************************************************************************
 * 	 입고내역선택 
****************************************************************************************************************************************************************************************/
	
	/**
	 * 입고내역선택 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE47387642.do", produces = "application/text; charset=utf8")
	public String epce47387642(HttpServletRequest request, ModelMap model) {
		model =epce4738731Service.epce47387642_select(model, request);
		return "/CE/EPCE47387642";
	}
	
	/**
	 *  입고내역선택  생산자에 따른 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE47387642_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2983901_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4738731Service.epce47387642_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 입고내역선택 생산자 직매장/공장 선택시  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE47387642_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2983901_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4738731Service.epce47387642_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 입고내역선택 도매업자 구분 선택시 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE47387642_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2983901_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4738731Service.epce47387642_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 입고내역선택  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE47387642_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2983901_select4(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4738731Service.epce47387642_select5(inputMap, request)).toString();
	}	
	
	
}
