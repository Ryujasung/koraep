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
import egovframework.koraep.ce.ep.service.EPCE6101501Service;


/**
 * 출고현황
 * @author 이내희
 *
 */
@Controller
public class EPCE6101501Controller {  

	@Resource(name = "epce6101501Service")
	private  EPCE6101501Service epce6101501Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 출고현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE6101501.do", produces = "application/text; charset=utf8")
	public String epce6101501(HttpServletRequest request, ModelMap model) {
		model =epce6101501Service.epce6101501_select(model, request);
		return "/CE/EPCE6101501";
	}
	
	
	/**
	 * 출고현황 리스트 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6101501_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6101501_select(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce6101501Service.epce6101501_select2(data)).toString();
	}
	
	/**
	 * 생산자에 따른 도매업자 업체명 조회, 빈용기조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6101501_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6101501_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce6101501Service.epce6101501_select3(inputMap, request)).toString();
	}
	
	/**
	 * 용도 변경시  빈용기명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6101501_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6101501_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce6101501Service.epce6101501_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 출고현황  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6101501_05.do")
	@ResponseBody
	public String epce6101501_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce6101501Service.epce6101501_excel(data, request);
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
