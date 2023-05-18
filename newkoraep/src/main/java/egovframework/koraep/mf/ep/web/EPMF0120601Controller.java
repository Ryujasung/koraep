package egovframework.koraep.mf.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.mf.ep.service.EPMF0120601Service;


/**
 * 직매장별거래처관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPMF0120601Controller {

	
	@Resource(name="epmf0120601Service")
	private EPMF0120601Service epmf0120601Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 직매장별거래처관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0120601.do")
	public String epmf0120601_select(ModelMap model, HttpServletRequest request) {
		
		Device device = DeviceUtils.getCurrentDevice(request);        
		
		//System.out.println("device===" + device);
		
		model = epmf0120601Service.epmf0120601_select(model, request);
		
		if(device.isNormal()){
			return "/MF/EPMF0120601";
		}else{
			return "/MF/EPMF0120601_m";
		}
		
		
	}
	
	/**
	 * 직매장별거래처관리 등록 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0120631.do")
	public String epmf0120631_select(ModelMap model, HttpServletRequest request) {
		
		model = epmf0120601Service.epmf0120631_select(model, request);
		
		return "/MF/EPMF0120631";
	}
	
	/**
	 * 직매장별거래처관리 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF012060119.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0120601_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf0120601Service.epmf0120601_select2(data, request)).toString();
	}
	
	/**
	 * 직매장별거래처관리 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0120601_05.do")
	@ResponseBody
	public String epmf0120601_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf0120601Service.epmf0120601_excel(data, request);
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
	 
	/**
	 * 직매장별거래처관리  직매장/공장 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0120601192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0120601_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf0120601Service.epmf0120601_select3(data, request)).toString();
	}
	
	/**
	 * 직매장별거래처관리 등록 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF012063119.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0120631_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf0120601Service.epmf0120631_select2(data, request)).toString();
	}
	
	
	/**
	 * 거래상태 변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0120601_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0120601_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf0120601Service.epmf0120601_update(data, request);
			errCd = epmf0120601Service.epmf0120601_update2(data, request);
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
	
	/**
	 * 기준수수료생성
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0120601_212.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0120601_update2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = epmf0120601Service.epmf0120601_update2(data, request);
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
	
	
	/**
	 * 직매장별거래처관리 등록확인
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0120675.do")
	public String epmf0120675_select(ModelMap model, HttpServletRequest request) {
		
		model = epmf0120601Service.epmf0120675_select(model, request);
		
		return "/MF/EPMF0120675";
	}
	
	/**
	 * 거래처 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0120631_31.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0120631_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf0120601Service.epmf0120631_insert(data, request);
			errCd = epmf0120601Service.epmf0120601_update2(data, request);
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
