package egovframework.koraep.ce.ep.web;

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
import egovframework.koraep.ce.ep.service.EPCE0105901Service;
/**
 *  빈용기기준금액관리 Controller
 * @author 양성수
 *
 */
@Controller
public class EPCE0105901Controller {

	@Resource(name = "epce0105901Service")
	private  EPCE0105901Service epce0105901Service; 	//빈용기기준금액관리 service
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service

	
	/**
	 * 빈용기기준금액관리 초기화면
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE0105901.do", produces = "application/text; charset=utf8")
	public String epce0105901(ModelMap model ,HttpServletRequest request) {
		model =epce0105901Service.epce0105901_select(model,request);
	return "/CE/EPCE0105901";
	}
	
	
	/**
	 * 빈용기기준금액관리 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0105901_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0105901_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0105901Service.epce0105901_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 빈용기기준금액관리 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0105901_05.do")
	@ResponseBody
	public String epce0105901_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0105901Service.epce0105901_excel(data, request);
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
	 * 빈용기기준금액관리 빈용기명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0105901_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0105901_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0105901Service.epce0105901_select3(inputMap, request)).toString();
	}	
	
	
}
