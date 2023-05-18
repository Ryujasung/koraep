package egovframework.koraep.wh.ep.web;

import java.io.IOException;
import java.sql.SQLException;
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
import egovframework.koraep.wh.ep.service.EPWH4704201Service;
import egovframework.koraep.wh.ep.service.EPWH2983901Service;


/**
 * 입고정정 확인
 * @author 양성수
 *
 */
@Controller
public class EPWH4704201Controller {  

	@Resource(name = "epwh4704201Service")
	private  EPWH4704201Service epwh4704201Service; 	// 입고정정 확인 service
	
	@Resource(name = "epwh2983901Service")
	private  EPWH2983901Service epwh2983901Service; 	//입고관리 service
	
	@Resource(name = "epwh2910101Service")
	private  EPWH2910101Service epwh2910101Service; 	//반환관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 *  입고정정 확인 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/WH/EPWH4704201.do", produces = "application/text; charset=utf8")
	public String epwh4704201(HttpServletRequest request, ModelMap model) {

		if(request.getParameter("WRHS_DOC_NO") != null){ //상세조회 바로이동
			model.addAttribute("WRHS_DOC_NO", request.getParameter("WRHS_DOC_NO").toString());
		}
		
		if(request.getParameter("WRHS_CRCT_DOC_NO") != null){
			model.addAttribute("WRHS_CRCT_DOC_NO", request.getParameter("WRHS_CRCT_DOC_NO").toString());
		}
		
		model =epwh4704201Service.epwh4704201_select(model, request);

		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH4704201";
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
			
			return "/WH_M/EPWH4704201";
		}
	}
	
	/**
	 *  입고정정  생산자에 따른 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4704201_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh4704201_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh4704201Service.epwh4704201_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 입고정정 생산자 직매장/공장 선택시  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4704201_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh4704201_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh4704201Service.epwh4704201_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 입고정정 확인  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4704201_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh4704201_select3(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh4704201Service.epwh4704201_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 입고정정 확인  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4704201_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh4704201_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh4704201Service.epwh4704201_excel(data, request);
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
	 * 입고정정 확인요청취소
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4704201_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh4704201_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epwh4704201Service.epwh4704201_update(inputMap, request);
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
	
	
	//---------------------------------------------------------------------------------------------------------------------
	//	수기입고정정 내역조회
	//---------------------------------------------------------------------------------------------------------------------
		
	/**
	 * 수기입고정정 내역조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/WH/EPWH4705664.do", produces = "application/text; charset=utf8")
	public String epce4705664(HttpServletRequest request, ModelMap model) {

		model =epwh4704201Service.epwh4705664_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH4705664";
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
			
			return "/WH_M/EPWH4705664";
		}
	}
}
