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
import egovframework.koraep.ce.ep.service.EPCE4750301Service;

/**
 * 생산자정산지급내역 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE4750301Controller {

	@Resource(name="epce4750301Service")
	private EPCE4750301Service epce4750301Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 생산자정산지급내역 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4750301.do")
	public String epce4750301(ModelMap model, HttpServletRequest request) {
		model = epce4750301Service.epce4750301_select(model, request);
		
		return "/CE/EPCE4750301";
	}
	
	/**
	 * 생산자정산지급내역 연계전송 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4750331.do")
	public String epce4750331(ModelMap model, HttpServletRequest request) {
		model = epce4750301Service.epce4750331_select(model, request);
		
		return "/CE/EPCE4750331";
	}
	

	/**
	 * 생산자정산지급내역 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4750301_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce4750301_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4750301Service.epce4750301_select2(data)).toString();
	}
	
	/**
	 * 연계전송
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4750301_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4750301_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epce4750301Service.epce4750301_update(data, request);
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
	 * 오류건 재전송
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4750301_212.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4750301_update2(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epce4750301Service.epce4750301_update2(data, request);
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
