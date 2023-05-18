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
import egovframework.koraep.ce.ep.service.EPCE4793901Service;

/**
 * 수기정산발급 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE4793901Controller {

	@Resource(name="epce4793901Service")
	private EPCE4793901Service epce4793901Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 수기정산발급 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4793901.do")
	public String epce4793901(ModelMap model, HttpServletRequest request) {
		model = epce4793901Service.epce4793901_select(model, request);
		
		return "/CE/EPCE4793901";
	}
	
	/**
	 * 수기정산금액확인 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4793931.do")
	public String epce4793931(ModelMap model, HttpServletRequest request) {
		model = epce4793901Service.epce4793931_select(model, request);
		
		return "/CE/EPCE4793931";
	}
	
	/**
	 * 수기정산발급 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4793901_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0101801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4793901Service.epce4793901_select2(data)).toString();
	}
	
	/**
	 * 정산서발급 
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4793931_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4793931_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epce4793901Service.epce4793931_insert(data, request);
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
