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
import egovframework.koraep.ce.ep.service.EPCE6186401Service;


/**
 * 회수대비초과반환현황
 * @author 양성수
 *
 */
@Controller
public class EPCE6186401Controller {  

	@Resource(name = "epce6186401Service")
	private  EPCE6186401Service epce6186401Service; 	//회수대비초과반환현황 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 회수대비초과반환현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE6186401.do", produces = "application/text; charset=utf8")
	public String epce6186401(HttpServletRequest request, ModelMap model) {

		model =epce6186401Service.epce6186401_select(model, request);
		return "/CE/EPCE6186401";
	}
	
	/**
	 *  회수대비초과반환현황 도매업자 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6186401_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6186401_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce6186401Service.epce6186401_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 회수대비초과반환현황  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6186401_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6186401_select2(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce6186401Service.epce6186401_select3(inputMap, request)).toString();
	}															   
	
	/**
	 * 회수대비초과반환현황  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6186401_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6186401_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = epce6186401Service.epce6186401_excel(data, request);
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
