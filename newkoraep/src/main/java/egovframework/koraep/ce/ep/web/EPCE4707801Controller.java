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
import egovframework.koraep.ce.ep.service.EPCE4707801Service;

/**
 * 정산연간조정 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE4707801Controller {

	@Resource(name="epce4707801Service")
	private EPCE4707801Service epce4707801Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 정산연간조정 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707801.do")
	public String epce4707801(ModelMap model, HttpServletRequest request) {
		model = epce4707801Service.epce4707801_select(model, request);
		
		return "/CE/EPCE4707801";
	}
	
	/**
	 * 정산연간조정 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707801_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0101801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4707801Service.epce4707801_select2(data)).toString();
	}		
	
	//---------------------------------------------------------------------------------------------------------------------
	//	조정수량관리
	//---------------------------------------------------------------------------------------------------------------------
	
	/**
	 * 조정수량관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707888.do")
	public String epce4707888(ModelMap model, HttpServletRequest request) {
		return "/CE/EPCE4707888";
	}
	
	/**
	 * 조정수량관리 초기값  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707888_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4707888_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4707801Service.epce4707888_select(inputMap, request)).toString();
	}	
	
	/**
	 * 조정수량관리 삭제전 데이터 검색
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707888_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4707888_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce4707801Service.epce4707888_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 조정수량관리   등록
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707888_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4707888_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		String errCd = "";
		try{
			errCd = epce4707801Service.epce4707888_insert(inputMap, request);
			
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
	 * 조정수량관리   삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707888_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4707888_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		String errCd = "";
		try{
			errCd = epce4707801Service.epce4707888_delete(inputMap, request);
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
