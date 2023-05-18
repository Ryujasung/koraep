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
import egovframework.koraep.ce.ep.service.EPCE6123901Service;


/**
 * 생산자별 출고/회수 현황
 * @author 이내희
 *
 */
@Controller
public class EPCE6123901Controller {  

	@Resource(name = "epce6123901Service")
	private  EPCE6123901Service epce6123901Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 생산자별 출고/회수 현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE6123901.do", produces = "application/text; charset=utf8")
	public String epce6123901(HttpServletRequest request, ModelMap model) {
		
		return "/CE/EPCE6123901";
	}
	
	/**
	 * 생산자별 출고/회수 현황 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6123901_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6123901_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce6123901Service.epce6123901_select(data)).toString();
	}
	
	/**
	 * 생산자별 출고/회수 현황  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6123901_05.do")
	@ResponseBody
	public String epce6123901_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce6123901Service.epce6123901_excel(data, request);
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
