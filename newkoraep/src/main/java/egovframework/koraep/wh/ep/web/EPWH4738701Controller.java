package egovframework.koraep.wh.ep.web;

import java.util.HashMap;
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
import egovframework.koraep.wh.ep.service.EPWH2910101Service;
import egovframework.koraep.wh.ep.service.EPWH4738701Service;
import egovframework.koraep.wh.ep.service.EPWH2983901Service;


/**
 * 입고정정 
 * @author 양성수
 *
 */
@Controller
public class EPWH4738701Controller {  

	@Resource(name = "epwh4738701Service")
	private  EPWH4738701Service epwh4738701Service; 	// 입고정정 service
	
	@Resource(name = "epwh2983901Service")
	private  EPWH2983901Service epwh2983901Service; 	//입고관리 service
	
	@Resource(name = "epwh2910101Service")
	private  EPWH2910101Service epwh2910101Service; 	//반환관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 *  입고정정  페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/WH/EPWH4738701.do", produces = "application/text; charset=utf8")
	public String epwh4738701(HttpServletRequest request, ModelMap model) {

		model =epwh4738701Service.epwh4738701_select(model, request);
		return "/WH/EPWH4738701";
	}
	
	/**
	 *  입고정정 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4738701_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh4738701_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh4738701Service.epwh4738701_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 입고정정 도매업자 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4738701_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh4738701_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh4738701Service.epwh4738701_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 입고정정   조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4738701_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh4738701_select3(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh4738701Service.epwh4738701_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 입고정정 생산자 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4738701_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh4738701_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh4738701Service.epwh4738701_select5(inputMap, request)).toString();
	}	
	
	/**
	 * 입고정정   엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4738701_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh4738701_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh4738701Service.epwh4738701_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 입고정정 정정확인 정정반려 확인취소 상태 변경
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4738701_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh4738701_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epwh4738701Service.epwh4738701_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	

	//---------------------------------------------------------------------------------------------------------------------
	//	입고정정 내역조회
	//---------------------------------------------------------------------------------------------------------------------
		
	/**
	 * 입고정정 내역조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/WH/EPWH4738764.do", produces = "application/text; charset=utf8")
	public String epwh4738764(HttpServletRequest request, ModelMap model) {

		model =epwh4738701Service.epwh4738764_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH4738764";
		}else{ //모바일
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";

			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
				model.addAttribute("userInfo", ssUserInfo); //사용자
				model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
				model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdList(vo))); //메뉴
			}
			
			return "/WH_M/EPWH4738764";
		}
	}
	

	/**
	 * 입고정정내역조회 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4738764_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh4738764_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epwh4738701Service.epwh4738764_delete(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	
}
