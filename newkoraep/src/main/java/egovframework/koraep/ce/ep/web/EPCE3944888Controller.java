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
import egovframework.koraep.ce.ep.service.EPCE3944888Service;

/**
 * 언어구분관리 Controller
 * 
 * @author 양성수
 * 
 */
@Controller
public class EPCE3944888Controller {

	@Resource(name="epce3944888Service")
	private EPCE3944888Service epce3944888Service; //언어구분관리 service
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 언어구분관리 기본페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE3944888.do", produces = "application/text; charset=utf8")
	public String epce3944888(HttpServletRequest request, ModelMap model) {

		model =epce3944888Service.epce3944888_select(model,request);
		
		return "/CE/EPCE3944888";
		
	}
	
	/**
	 * 언어구분관리 저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3944888_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3944888_insert(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		
		String errCd = "";
		
		try{
			errCd = epce3944888Service.epce3944888_insert(data, request);
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
	 * 언어구분관리 수정
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3944888_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3944888_update(@RequestParam Map<String, String> data, HttpServletRequest request)  {
	
		String errCd = "";
		try{
			errCd = epce3944888Service.epce3944888_update(data, request);
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
	 * 언어구분관리 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3944888_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3944888_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3944888Service.epce3944888_select2(inputMap, request)).toString();
	}	
	
	
	
}
