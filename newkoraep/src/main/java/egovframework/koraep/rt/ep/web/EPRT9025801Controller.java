package egovframework.koraep.rt.ep.web;

import java.io.IOException;
import java.sql.SQLException;
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
import egovframework.koraep.rt.ep.service.EPRT9025801Service;

   
/**
 * 반환정보조회
 * @author 양성수
 *
 */
@Controller
public class EPRT9025801Controller {  

	@Resource(name = "eprt9025801Service")
	private  EPRT9025801Service eprt9025801Service; 	//반환정보조회 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 반환정보조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/RT/EPRT9025801.do", produces = "application/text; charset=utf8")
	public String eprt9025801(HttpServletRequest request, ModelMap model) {
		model = eprt9025801Service.eprt9025801_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/RT/EPRT9025801";
		}else{ //모바일
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";
			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
			}
			model.addAttribute("userInfo", ssUserInfo); //사용자
			model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
			if(vo != null){
				model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdList(vo))); //메뉴
			} else {
				model.addAttribute("mmObject","");
			}
			return "/RT_M/EPRT9025801";
		}
	}

	/**
	 * 반환정보조회  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT9025801_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String eprt9025801_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(eprt9025801Service.eprt9025801_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 반환정보조회  확인처리
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT9025801_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String eprt9025801_update(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";
		try{
			errCd = eprt9025801Service.eprt9025801_update(data, request);
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
	/***********************************************************************************************************************************************
	*	회수정보 상세조회
	************************************************************************************************************************************************/
	
	/**
	 * 반환정보조회 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/RT/EPRT9025864.do", produces = "application/text; charset=utf8")
	public String eprt9025864(HttpServletRequest request, ModelMap model) {

		model = eprt9025801Service.eprt9025864_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		if(device.isNormal()){ //웹
			return "/RT/EPRT9025864";
		}else{ //모바일
			String title = commonceService.getMenuTitle("EPWH2371301");	//타이틀
			model.addAttribute("titleSub", title);
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";
			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
			}
			model.addAttribute("userInfo", ssUserInfo); //사용자
			model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
			if(vo != null){
				model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdList(vo))); //메뉴
			} else {
				model.addAttribute("mmObject","");
			}
			return "/RT_M/EPRT9025864";
		}
	}
	
	/***********************************************************************************************************************************************
	*	회수정보 등록
	************************************************************************************************************************************************/
	/**
	 * 회수정보 등록
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/RT/EPRT9025831.do", produces = "application/text; charset=utf8")
	public String eprt9025831(HttpServletRequest request, ModelMap model) {
		model = eprt9025801Service.eprt9025831_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/RT/EPRT9025831";
		}else{ //모바일
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";
			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
			}
			model.addAttribute("userInfo", ssUserInfo); //사용자
			model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
			if(vo != null){
				model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdList(vo))); //메뉴
			} else {
				model.addAttribute("mmObject","");
			}
			return "/RT_M/EPRT9025831";
		}
	}
	  
	/**
	 * 회수정보등록 날짜 변경시 보증금,수수료조회
	 * @param inputMap
	 * @param request   
	 * @return
	 * @  
	 */
	@RequestMapping(value="/RT/EPRT9025831_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String eprt9025831_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(eprt9025801Service.eprt9025831_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 회수정보등록  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT9025831_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String eprt9025831_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = eprt9025801Service.eprt9025831_insert(data, request);
			
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
			if(data.get("ERR_CTNR_NM") !=null){
				System.out.println(data.get("ERR_CTNR_NM").toString());
			}
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		if(data.get("ERR_CTNR_NM") !=null){
			rtnObj.put("ERR_CTNR_NM", data.get("ERR_CTNR_NM").toString());
		}
		
		return rtnObj.toString();
	}
	
	
	
	
	/***********************************************************************************************************************************************
	*	회수정보 변경
	************************************************************************************************************************************************/
	/**
	 * 회수정보 변경
	 * @param request
	 * @param model
	 * @return
	 * @   
	 */
	@RequestMapping(value = "/RT/EPRT9025842.do", produces = "application/text; charset=utf8")
	public String eprt9025842(HttpServletRequest request, ModelMap model) {
		model = eprt9025801Service.eprt9025842_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/RT/EPRT9025842";
		}else{ //모바일
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";
			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
			}
			model.addAttribute("userInfo", ssUserInfo); //사용자
			model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
			if(vo != null){
				model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdList(vo))); //메뉴
			} else {
				model.addAttribute("mmObject","");
			}
			return "/RT_M/EPRT9025842";
		}
	}

	/**
	 * 회수정보수정  저장
	 * @param map
	 * @param model
	 * @param request   
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT9025842_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String eprt9025842_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = eprt9025801Service.eprt9025842_insert(data, request);
			
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
			if(data.get("ERR_CTNR_NM") !=null){
				System.out.println(data.get("ERR_CTNR_NM").toString());
			}
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		if(data.get("ERR_CTNR_NM") !=null){
			rtnObj.put("ERR_CTNR_NM", data.get("ERR_CTNR_NM").toString());
		}
		
		return rtnObj.toString();
	}
	
	/**
	 * 반환정보조회  확인처리
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT9025842_04.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String eprt9025842_delete(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";
		try{
			errCd = eprt9025801Service.eprt9025842_delete(data, request);
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
