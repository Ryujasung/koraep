package egovframework.koraep.wh.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.wh.ep.service.EPWH2924601Service;


/**
 * 회수정보조회
 * @author 양성수
 *
 */
@Controller
public class EPWH2924601Controller {  

	@Resource(name = "epwh2924601Service")
	private  EPWH2924601Service epwh2924601Service; 	//회수정보조회 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 회수정보조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH2924601.do", produces = "application/text; charset=utf8")
	public String epwh2924601(HttpServletRequest request, ModelMap model) {

		model = epwh2924601Service.epwh2924601_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		return "/WH/EPWH2924601";

	}
	
	/**
	 *  회수정보조회 업체명조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2924601_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2924601_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2924601Service.epwh2924601_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 회수정보조회 지점조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2924601_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2924601_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2924601Service.epwh2924601_select3(inputMap, request)).toString();
	}	

	/**
	 * 회수정보조회  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2924601_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2924601_select4(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		System.out.println("con");
		return util.mapToJson(epwh2924601Service.epwh2924601_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 회수정보조회  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2924601_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh6624501_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = epwh2924601Service.epwh2924601_excel(data, request);
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
