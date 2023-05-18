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
import egovframework.koraep.ce.ep.service.EPCE2393001Service;

/**
 * 고지서조회 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE2393001Controller {

	@Resource(name="epce2393001Service")
	private EPCE2393001Service epce2393001Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 고지서조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2393001.do")
	public String epce2393001(ModelMap model, HttpServletRequest request) {
		
		model = epce2393001Service.epce2393001_select(model, request);
		
		return "/CE/EPCE2393001";
	}
	
	/**
	 * 고지서 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2393001_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2393001_select(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce2393001Service.epce2393001_select2(data)).toString();
	}
	
	/**
	 * 보증금고지서 상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2393064.do")
	public String epce2393064(ModelMap model, HttpServletRequest request) {
		
		model = epce2393001Service.epce2393064_select(model, request);
		
		return "/CE/EPCE2393064";
	}
	
	/**
	 * 취급수수료고지서 상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE23930642.do")
	public String epce23930642(ModelMap model, HttpServletRequest request) {
		
		model = epce2393001Service.epce2393064_select2(model, request);
		
		return "/CE/EPCE23930642";
	}
	
	/**
	 * 보증금(조정)고지서 상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE23930643.do")
	public String epce23930643(ModelMap model, HttpServletRequest request) {
		
		model = epce2393001Service.epce2393064_select3(model, request);
		
		return "/CE/EPCE23930643";
	}
	
	
	/**
	 * 고지서 발급취소
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2393064_21.do", produces="application/text; charset=UTF-8")
	@ResponseBody
	public String epce2393064_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		String errCd = "";
		
		try{
			errCd = epce2393001Service.epce2339064_update(inputMap, request);
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
	 * 취소요청 취소
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2393064_212.do", produces="application/text; charset=UTF-8")
	@ResponseBody
	public String epce2393064_update2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		String errCd = "";
		
		try{
			errCd = epce2393001Service.epce2339064_update2(inputMap, request);
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
	 * 재고지 취소
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2393064_213.do", produces="application/text; charset=UTF-8")
	@ResponseBody
	public String epce2393064_update3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		String errCd = "";
		
		try{
			errCd = epce2393001Service.epce2339064_update3(inputMap, request);
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
	 * 고지서 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2393001_05.do")
	@ResponseBody
	public String epce2393001_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce2393001Service.epce2393001_excel(data, request);
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
	 * 보증금고지서 상세 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2393064_05.do")
	@ResponseBody
	public String epce2393064_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce2393001Service.epce2393064_excel(data, request);
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
	 * 취급수수료고지서 상세 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE23930642_05.do")
	@ResponseBody
	public String epce23930642_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce2393001Service.epce23930642_excel(data, request);
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
	 * 재고지 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2393088.do")
	public String epce2393088(ModelMap model, HttpServletRequest request) {
		model = epce2393001Service.epce2393088_select(model, request);
		
		return "/CE/EPCE2393088";
	}
	
	/**
	 * 재고지 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2393088_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2393088_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce2393001Service.epce2393088_update(data, request);
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
	 * 취소요청사유 
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE23930882.do", produces = "application/text; charset=utf8")
	public String epce23930882(HttpServletRequest request, ModelMap model) {
		model.addAttribute("titleSub", commonceService.getMenuTitle("EPCE23930882"));
		return "/CE/EPCE23930882";
	}
	
	/**
	 * 취소요청사유  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE23930882_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce23930882_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce2393001Service.epce23930882_select(inputMap, request)).toString();
	}	
	
}
