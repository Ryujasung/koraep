package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;


import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE3964901Service;



/**
 *  회수용기코드관리 Controller
 * @author 양성수
 *
 */
@Controller
public class EPCE3964901Controller {

	@Resource(name = "epce3964901Service")
	private EPCE3964901Service epce3964901Service; 	//회수용기코드관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service
	
	
	/**
	 * 회수용기코드관리 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE3964901.do", produces = "application/text; charset=utf8")
	public String epce3964901(HttpServletRequest request, ModelMap model) {
		
		model =epce3964901Service.epce3964901_select(model,request);
		
	return "/CE/EPCE3964901";
	}
	
	
	
		/**
		 * 회수용기코드관리 리스트 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		@RequestMapping(value="/CE/EPCE3964901_19.do", produces="application/text; charset=utf8")
		@ResponseBody
		public String epce3964901_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
			return util.mapToJson(epce3964901Service.epce3964901_select2(inputMap, request)).toString();
		}	
	
	/**
	 *  회수용기코드 저장,수정 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3964901_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3964901_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
        
	    String errCd = "";
		try{
			errCd = epce3964901Service.epce3964901_select3(inputMap, request);
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
	 * 회수용기코드관리 저장,수정
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3964901_09.do", produces="application/text; charset=utf8")
	@ResponseBody
    @Transactional
	public String epce3964901_insert(@RequestParam Map<String, String> data, HttpServletRequest request)  {
	
	    String errCd = "";
		try{
	
			errCd = epce3964901Service. epce3964901_insert(data, request);
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
