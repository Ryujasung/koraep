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
import egovframework.koraep.ce.ep.service.EPCE6139401Service;


/**
 * 상세입고현황
 * @author 양성수
 *
 */
@Controller
public class EPCE6139401Controller {  

	@Resource(name = "epce6139401Service")
	private  EPCE6139401Service epce6139401Service; 	//상세입고현황 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 상세입고현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE6139401.do", produces = "application/text; charset=utf8")
	public String epce6139401(HttpServletRequest request, ModelMap model) {

		model =epce6139401Service.epce6139401_select(model, request);
		return "/CE/EPCE6139401";
	}
	
	/**
	 *  상세입고현황  도매업자 업체명 조회, 빈용기조회 ,직매장 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6139401_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6139401_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce6139401Service.epce6139401_select2(inputMap, request)).toString();
	}	
	
	/**
	 *  상세입고현황  빈용기조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6139401_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6139401_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce6139401Service.epce6139401_select3(inputMap, request)).toString();
	}	
	
	/**
	 *  상세입고현황  도매업자 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6139401_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6139401_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce6139401Service.epce6139401_select4(inputMap, request)).toString();
	}	
	
	
	/**
	 * 상세입고현황  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6139401_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6139401_select4(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce6139401Service.epce6139401_select5(inputMap, request)).toString();
	}															   
	
	
	/**
	 * 상세입고현황  새로고침
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */

	@RequestMapping(value="/CE/EPCE6139401_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6139401_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = epce6139401Service.epce6139401_update(inputMap, request);
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
	 * 상세입고현황  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6139401_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6139401_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce6139401Service.epce6139401_excel(data, request);
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
