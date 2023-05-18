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
import egovframework.koraep.ce.ep.service.EPCE3961201Service;

/**
 *  실행이력조회 Controller
 * @author 양성수
 *
 */
@Controller
public class EPCE3961201Controller {
	
	
	@Resource(name = "epce3961201Service")
	private EPCE3961201Service epce3961201Service; 	//실행이력조회 service

	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	/**
	 * 실행이력조회 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE3961201.do", produces = "application/text; charset=utf8")
	public String epce3961201(HttpServletRequest request, ModelMap model) {

		//언어구분 리스트 , 용어구분 리스트 
		model =epce3961201Service.epce3961201_select(model,request);
		
		
	return "/CE/EPCE3961201";
	}
	
	
	/**
	 * 실행이력조회 메뉴명조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3961201_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3961201_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3961201Service.epce3961201_select2(inputMap, request)).toString();
	}	
	
	
	/**
	 * 실행이력조회 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3961201_05.do")
	@ResponseBody
	public String epce2308801_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce3961201Service.epce3961201_excel(data, request);
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
	 * 실행이력조회 버튼명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3961201_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3961201_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3961201Service.epce3961201_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 실행이력조회 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3961201_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3961201_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3961201Service.epce3961201_select4(inputMap, request)).toString();
		
	}	

	/**
	 * 실행이력조회 조회 PRAM
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE3961201_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce3961201_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce3961201Service.epce3961201_select5(inputMap, request)).toString();
		
	}	
	
	/**
	 * 실행이력조회 상세조회 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE3961264.do", produces = "application/text; charset=utf8")
	public String epceEPCE3961264(HttpServletRequest request, ModelMap model) {
		    
	return "/CE/EPCE3961264";
	}

	
	
	

}
