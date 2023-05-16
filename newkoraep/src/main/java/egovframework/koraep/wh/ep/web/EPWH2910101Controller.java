package egovframework.koraep.wh.ep.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
import net.sf.json.JSONObject;


/**
 * 반환관리
 * @author 양성수
 *
 */
@Controller
public class EPWH2910101Controller {

	@Resource(name = "epwh2910101Service")
	private  EPWH2910101Service epwh2910101Service; 	//반환관리 service

	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service


	/**
	 * 반환관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH2910101.do", produces = "application/text; charset=utf8")
	public String epwh2910101(HttpServletRequest request, ModelMap model) {

		model = epwh2910101Service.epwh2910101_select(model, request);

		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);

		if(device.isNormal()){ //웹
			return "/WH/EPWH2910101";
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

			return "/WH_M/EPWH2910101";
		}
	}
	
	/**
	 * 반환정보조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH2910102.do", produces = "application/text; charset=utf8")
	public String epwh2910102(HttpServletRequest request, ModelMap model) {

		model = epwh2910101Service.epwh2910101_select_1(model, request);

		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);

		if(device.isNormal()){ //웹
			return "/WH/EPWH2910102";
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

			return "/WH/EPWH2910102";
		}
	}

	/**
	 *  반환관리  생산자에 따른 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910101_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910101_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2910101Service.epwh2910101_select2(inputMap, request)).toString();
	}

	/**
	 * 반환관리 생산자 직매장/공장 선택시  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910101_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910101_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2910101Service.epwh2910101_select3(inputMap, request)).toString();
	}

	/**
	 * 반환관리 도매업자 구분 선택시 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910101_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910101_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2910101Service.epwh2910101_select4(inputMap, request)).toString();
	}

	/**
	 * 반환관리  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910101_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910101_select4(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2910101Service.epwh2910101_select5(inputMap, request)).toString();
	}
	
	/**
	 * 반환내역상제조회(20200402추가)
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910101_195.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910101_select4_1(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2910101Service.epwh2910101_select5_1(inputMap, request)).toString();
	}

	/**
	 * 반환관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910101_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh6624501_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epwh2910101Service.epwh2910101_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}
	
	/**
	 * 반환내역상세  엑셀저장(20200402추가)
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910102_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh2910102_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epwh2910101Service.epwh2910102_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}


	/**
	 * 반환관리  삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910101_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910101_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = epwh2910101Service.epwh2910101_delete(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		return rtnObj.toString();
	}
	/**
	 * 반환관리  실태조사
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910101_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910101_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = epwh2910101Service.epwh2910101_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}
	
	/**
	 * 반환등록요청 일괄확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910101_212.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2910101_update2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = epwh2910101Service.epwh2910101_update2(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}
	
	

	/**
	 * 반환관리 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH2910164.do", produces = "application/text; charset=utf8")
	public String epwh2910164(HttpServletRequest request, ModelMap model) {

		model = epwh2910101Service.epwh2910164_select(model, request);

		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);

		if(device.isNormal()){ //웹
			return "/WH/EPWH2910164";
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

			return "/WH_M/EPWH2910164";
		}
	}

	/**
	 * 반환관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910164_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh2910164_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epwh2910101Service.epwh2910164_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}

}
