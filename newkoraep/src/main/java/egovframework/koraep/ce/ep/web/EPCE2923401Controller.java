package egovframework.koraep.ce.ep.web;

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
import egovframework.koraep.ce.ep.service.EPCE2923401Service;


/**
 * 회수정보조회 엑셀다운로드
 * @author 
 *
 */
@Controller
public class EPCE2923401Controller {  

	@Resource(name = "epce2923401Service")
	private  EPCE2923401Service epce2923401Service; 	//회수정보조회 service
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 회수정보조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE2923401.do", produces = "application/text; charset=utf8")
	public String epce2923401(HttpServletRequest request, ModelMap model) {

		model = epce2923401Service.epce2923401_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		return "/CE/EPCE2923401";

	}
	
	/**
	 *  회수정보조회 업체명조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2923401_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2923401_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce2923401Service.epce2923401_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 회수정보조회 지점조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2923401_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2923401_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce2923401Service.epce2923401_select3(inputMap, request)).toString();
	}	

	/**
	 * 회수정보조회  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2923401_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2923401_select4(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce2923401Service.epce2923401_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 회수정보조회  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2923401_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6624501_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = epce2923401Service.epce2923401_excel(data, request);
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
