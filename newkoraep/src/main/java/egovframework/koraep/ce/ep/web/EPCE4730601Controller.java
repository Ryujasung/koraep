package egovframework.koraep.ce.ep.web;

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
import egovframework.koraep.ce.ep.service.EPCE4730601Service;
import net.sf.json.JSONObject;

/**
 * 도매업자정산지급내역 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE4730601Controller {

	@Resource(name="epce4730601Service")
	private EPCE4730601Service epce4730601Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;//공통 service

	/**
	 * 도매업자정산지급내역 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4730601.do")
	public String epce4730601(ModelMap model, HttpServletRequest request) {
		model = epce4730601Service.epce4730601_select(model, request);
		return "/CE/EPCE4730601";
	}
	
	/**
	 * 도매업자정산지급내역 연계전송 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4730631.do")
	public String epce4750331(ModelMap model, HttpServletRequest request) {
		model = epce4730601Service.epce4730631_select(model, request);
		
		return "/CE/EPCE4730631";
	}

	/**
	 * 도매업자정산지급내역 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4730601_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce4730601_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4730601Service.epce4730601_select2(data)).toString();
	}

	/**
	 * 연계전송
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4730601_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4730601_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = epce4730601Service.epce4730601_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();

	}

	/**
	 * 오류건 재전송
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4730601_212.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4730601_update2(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = epce4730601Service.epce4730601_update2(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();

	}

}
