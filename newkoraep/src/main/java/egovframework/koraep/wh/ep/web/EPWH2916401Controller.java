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
import egovframework.koraep.wh.ep.service.EPWH2916401Service;
import egovframework.koraep.wh.ep.service.EPWH2983901Service;

/**
 * 실태조사
 * @author 양성수
 *
 */
@Controller
public class EPWH2916401Controller {  

	@Resource(name = "epwh2916401Service")
	private  EPWH2916401Service epwh2916401Service; 	//실태조사 service
	
	@Resource(name = "epwh2983901Service")
	private  EPWH2983901Service epwh2983901Service; 	//입고관리 service
	
	@Resource(name = "epwh2910101Service")
	private  EPWH2910101Service epwh2910101Service; 	//반환관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 실태조사 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/WH/EPWH2916401.do", produces = "application/text; charset=utf8")
	public String epwh2916401(HttpServletRequest request, ModelMap model) {

		model =epwh2916401Service.epwh2916401_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH2916401";
		}else{ //모바일
			String title = commonceService.getMenuTitle("EPWH2916401");	//타이틀
			model.addAttribute("titleSub", title);
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";

			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
				model.addAttribute("userInfo", ssUserInfo); //사용자
				model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
				model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdList(vo))); //메뉴
			}
			
			return "/WH_M/EPWH2916401";
		}
	}
	
	/**
	 *  실태조사  생산자에 따른 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2916401_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2916401_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2916401Service.epwh2916401_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 실태조사 생산자 직매장/공장 선택시  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2916401_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2916401_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2916401Service.epwh2916401_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 실태조사 도매업자 구분 선택시 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2916401_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2916401_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2916401Service.epwh2916401_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 실태조사  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2916401_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2916401_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2916401Service.epwh2916401_select5(inputMap, request)).toString();
	}	
	
	/**
	 * 실태조사  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2916401_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh2916401_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh2916401Service.epwh2916401_excel(data, request);
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
	 * 실태조사요청취소
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2916401_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2916401_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epwh2916401Service.epwh2916401_update(inputMap, request);
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
	//	입고상세 페이지 ,  반환상세페이지 호출
	//---------------------------------------------------------------------------------------------------------------------
	
	/**
	 * 실태조사 반환관리 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH2916464.do", produces = "application/text; charset=utf8")
	public String epwh2910164(HttpServletRequest request, ModelMap model) {

		model =epwh2910101Service.epwh2910164_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH2916464";
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
			
			return "/WH_M/EPWH2916464";
		}
		
		
	}
	
	/**
	 * 실태조사 입고관리 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH29164642.do", produces = "application/text; charset=utf8")
	public String epwh2983964(HttpServletRequest request, ModelMap model) {

		model =epwh2983901Service.epwh2983964_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH29164642";
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
			
			return "/WH_M/EPWH29164642";
		}
		
		
	}
	
	//---------------------------------------------------------------------------------------------------------------------
	// 증빙파일등록
	//---------------------------------------------------------------------------------------------------------------------
	/**
	 * 실태조사 증빙파일등록 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH2916488.do", produces = "application/text; charset=utf8")
	public String epwh2916488(HttpServletRequest request, ModelMap model) {
		return "/WH/EPWH2916488";
	}
	
	/**
	 * 실태조사 증빙파일등록  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2916488_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2916488_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2916401Service.epwh2916488_select(inputMap, request)).toString();
	}	
	
	/**
	 * 실태조사 증빙파일등록  저장
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2916488_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPWH2916488_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
	
		String errCd = "";
		try{
			errCd = epwh2916401Service.epwh2916488_insert(inputMap, request);
			
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
	 * 실태조사 증빙파일등록  삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2916488_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPWH2916488_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
	
		
		String errCd = "";
		try{
			errCd = epwh2916401Service.epwh2916488_delete(inputMap, request);
			
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
	// 증빙파일조회
	//---------------------------------------------------------------------------------------------------------------------
	/**
	 * 실태조사 증빙파일조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH29164882.do", produces = "application/text; charset=utf8")
	public String EPWH29164882(HttpServletRequest request, ModelMap model) {
		return "/WH/EPWH29164882";
	}
	
	/**
	 * 실태조사 증빙파일조회  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH29164882_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPWH29164882_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2916401Service.epwh29164882_select(inputMap, request)).toString();
	}	
	
	//---------------------------------------------------------------------------------------------------------------------
	// 실태조사요청정보
	//---------------------------------------------------------------------------------------------------------------------
	/**
	 * 실태조사 실태조사요청정보 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH29164883.do", produces = "application/text; charset=utf8")
	public String EPWH29164883(HttpServletRequest request, ModelMap model) {
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH29164883";
		}else{ //모바일
			
			String RSRC_DOC_NO = request.getParameter("RSRC_DOC_NO");
			
			model.addAttribute("RSRC_DOC_NO", RSRC_DOC_NO);
			
			String title = commonceService.getMenuTitle("EPWH2916401");	//타이틀
			model.addAttribute("titleSub", title);
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";

			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
				model.addAttribute("userInfo", ssUserInfo); //사용자
				model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
				model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdList(vo))); //메뉴
			}
			
			//페이지이동 조회조건 파라메터 정보
			String reqParams = request.getParameter("INQ_PARAMS");
			if(reqParams==null || reqParams.equals("")) reqParams = "{}";
			JSONObject jParams = JSONObject.fromObject(reqParams);

			model.addAttribute("INQ_PARAMS",jParams);
			
			return "/WH_M/EPWH29164883";
		}
		
	}
	
	/**
	 * 실태조사 실태조사요청정보  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH29164883_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh29164883_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2916401Service.epwh29164883_select(inputMap, request)).toString();
	}	
	
	/**
	 * 실태조사 실태조사요청정보  등록
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH29164883_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh29164883_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
	
		
		String errCd = "";
		try{
			errCd = epwh2916401Service.epwh29164883_update(inputMap, request);
			
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
	 * 실태조사표 조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */										
	@RequestMapping(value = "/WH/EPWH29164313.do", produces = "application/text; charset=utf8")
	public String epce29164313(HttpServletRequest request, ModelMap model) {

		model =epwh2916401Service.epwh29164313_select(model, request);
		return "/WH/EPWH29164313";
	}
	
	/**
	 * 실태조사 실태조사표 확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH29164313_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh29164313_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
	
		
		String errCd = "";
		try{
			errCd = epwh2916401Service.EPWH29164313_update(inputMap, request);
			
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
