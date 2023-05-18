package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE0130201Service;
import net.sf.json.JSONObject;

/**
 * 생산자ERP입고정보
 * @author 유병승
 *
 */
@Controller
public class EPCE0130201Controller {  

	@Resource(name = "epce0130201Service")
	private  EPCE0130201Service epce0130201Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 생산자ERP입고정보 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/CE/EPCE0130201.do", produces = "application/text; charset=utf8")
	public String epce0130201(HttpServletRequest request, ModelMap model) {
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);
		return "/CE/EPCE0130201";
	}
	
	/**
	 * 생산자ERP입고정보  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0130201_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0130201_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0130201Service.epce0130201_select(inputMap, request)).toString();
	}	
	
	/**
	 * 생산자ERP입고정보 삭제
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0130201_04.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3960201_delete(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";
		
		try{
			errCd = epce0130201Service.epce0130201_delete(data, request);
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
