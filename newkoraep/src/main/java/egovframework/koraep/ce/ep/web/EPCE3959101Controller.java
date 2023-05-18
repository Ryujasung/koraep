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
import egovframework.koraep.ce.ep.service.EPCE3959101Service;

/**
 * 사업자권한관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE3959101Controller {

	
	@Resource(name="epce3959101Service")
	private EPCE3959101Service epce3959101Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 사업자권한관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3959101.do")
	public String epce3959101(ModelMap model, HttpServletRequest request) {
		
		model = epce3959101Service.epce3959101_select(model, request);
		
		return "/CE/EPCE3959101";
	}
	
	/**
	 * 권한목록 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3959101_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3937801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce3959101Service.epce3959101_select2(data)).toString();
	}
	
	/**
	 * 지역권한설정 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3959131.do")
	public String epce3959131(ModelMap model, HttpServletRequest request) {
		
		model = epce3959101Service.epce3959131_select(model, request);
		
		return "/CE/EPCE3959131";
	}
	
	/**
	 * 소속단체권한설정 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE39591312.do")
	public String epce39591312(ModelMap model, HttpServletRequest request) {
		
		model = epce3959101Service.epce39591312_select(model, request);
		
		return "/CE/EPCE39591312";
	}
	
	/**
	 * 개별사업자권한설정 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE39591313.do")
	public String epce39591313(ModelMap model, HttpServletRequest request) {
		
		model = epce3959101Service.epce39591313_select(model, request);
		
		return "/CE/EPCE39591313";
	}
	
	/**
	 * 지점 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE39591313_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce39591313_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce3959101Service.epce39591313_select2(data)).toString();
	}
	
	/**
	 * 지역권한 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3959131_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3959131_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			data.put("BIZR_ATH_SE", "A");//지역
			errCd = epce3959101Service.epce3959131_update(data, request);
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
	 * 소속단체권한 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE39591312_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce39591312_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			data.put("BIZR_ATH_SE", "O");//소속단체
			errCd = epce3959101Service.epce3959131_update(data, request);
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
	 * 개별사업자권한 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE39591313_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce39591313_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			data.put("BIZR_ATH_SE", "B");//개별사업자
			errCd = epce3959101Service.epce3959131_insert(data, request);
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
