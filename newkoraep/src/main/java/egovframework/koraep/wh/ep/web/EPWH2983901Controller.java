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
import egovframework.koraep.wh.ep.service.EPWH2983901Service;

/**
 * 입고관리
 * @author 양성수
 *
 */
@Controller
public class EPWH2983901Controller {  

	@Resource(name = "epwh2983901Service")
	private  EPWH2983901Service epwh2983901Service; 	//입고관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 입고관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/WH/EPWH2983901.do", produces = "application/text; charset=utf8")
	public String epwh2983901(HttpServletRequest request, ModelMap model) {

		model = epwh2983901Service.epwh2983901_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH2983901";
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
			
			return "/WH_M/EPWH2983901";
		}
	}
	
	/**
	 *  입고관리  생산자에 따른 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2983901_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2983901_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2983901Service.epwh2983901_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 입고관리 생산자 직매장/공장 선택시  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2983901_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2983901_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2983901Service.epwh2983901_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 입고관리 도매업자 구분 선택시 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2983901_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2983901_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2983901Service.epwh2983901_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 입고관리  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2983901_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2983901_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2983901Service.epwh2983901_select5(inputMap, request)).toString();
	}	
	
	/**
	 * 입고관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2983901_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh2983901_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh2983901Service.epwh2983901_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	
	/**
	 * 입고관리  실태조사 ,확인취소요청
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2983901_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2983901_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epwh2983901Service.epwh2983901_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 입고관리  일괄확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2983901_212.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2983901_update2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epwh2983901Service.epwh2983901_update2(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	//---------------------------------------------------------------------------------------------------------------------
	//	입고상세 페이지 
	//---------------------------------------------------------------------------------------------------------------------
	
	/**
	 * 입고관리 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH2983964.do", produces = "application/text; charset=utf8")
	public String epwh2983964(HttpServletRequest request, ModelMap model) {

		model =epwh2983901Service.epwh2983964_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH2983964";
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
			
			return "/WH_M/EPWH2983964";
		}
	}

	/**
	 * 입고관리 상세  조정확인후 상태다시 셋팅
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2983964_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2983964_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2983901Service.epwh2983964_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 입고관리 상세 조정확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2983964_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2983964_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epwh2983901Service.epwh2983964_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 입고관리 상세 조정확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @  
	 */
	@RequestMapping(value="/WH/EPWH2983964_212.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2983964_update2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epwh2983901Service.epwh2983964_update2(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	


	//---------------------------------------------------------------------------------------------------------------------
	//	 조사확인요청사유서(도매업자)
	//---------------------------------------------------------------------------------------------------------------------
	
	/**
	 *  조사확인요청사유서도매업자)  페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH2983988.do", produces = "application/text; charset=utf8")
	public String epwh2983988(HttpServletRequest request, ModelMap model) {
		return "/WH/EPWH2983988";
	}

	/**
	 *  조사확인요청사유서(도매업자)  초기값
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2983988_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2983988_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2983901Service.epwh2983988_select(inputMap, request)).toString();
	}	
	
	
	/**
	 *  조사확인요청사유서(도매업자) 저장
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2983988_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2983988_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epwh2983901Service.epwh2983988_insert(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	//---------------------------------------------------------------------------------------------------------------------
	//	증빙사진상세 페이지 
	//---------------------------------------------------------------------------------------------------------------------
		
	/**
	 * 입고증빙사진 상세조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH29839883.do", produces = "application/text; charset=utf8")
	public String EPWH29839883(HttpServletRequest request, ModelMap model) {
		return "/WH/EPWH29839883";
	}
	
	/**
	 * 입고증빙사진  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH29839883_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPWH29839883_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2983901Service.epwh29839883_select(inputMap, request)).toString();
	}	
	
}
