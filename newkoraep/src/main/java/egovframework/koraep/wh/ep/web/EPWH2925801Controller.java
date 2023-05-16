package egovframework.koraep.wh.ep.web;

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
import egovframework.koraep.wh.ep.service.EPWH2925801Service;

   
/**
 * 회수정보관리
 * @author 양성수
 *
 */
@Controller
public class EPWH2925801Controller {  

	@Resource(name = "epwh2925801Service")
	private  EPWH2925801Service epwh2925801Service; 	//회수정보관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 회수정보관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH2925801.do", produces = "application/text; charset=utf8")
	public String epwh2925801(HttpServletRequest request, ModelMap model) {

		model = epwh2925801Service.epwh2925801_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH2925801";
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
			
			return "/WH_M/EPWH2925801";
		}
	}
	
	/**
	 *  회수정보관리 업체명조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2925801_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2925801_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2925801Service.epwh2925801_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 회수정보관리 지점조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2925801_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2925801_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2925801Service.epwh2925801_select3(inputMap, request)).toString();
	}	

	/**
	 * 회수정보관리  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2925801_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2925801_select4(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2925801Service.epwh2925801_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 회수정보관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2925801_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh6624501_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		try{
			errCd = epwh2925801Service.epwh2925801_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
		
	
	/**
	 * 회수정보관리  삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2925801_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2925801_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epwh2925801Service.epwh2925801_delete(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		return rtnObj.toString();
	}
	
	/**
	 * 회수정보관리  회수등록일괄확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2925801_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2925801_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epwh2925801Service.epwh2925801_update(inputMap, request);
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
	 * 회수정보관리 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH2925864.do", produces = "application/text; charset=utf8")
	public String epwh2925864(HttpServletRequest request, ModelMap model) {

		model = epwh2925801Service.epwh2925864_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH2925864";
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
			
			return "/WH_M/EPWH2925864";
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
	@RequestMapping(value = "/WH/EPWH2925831.do", produces = "application/text; charset=utf8")
	public String epwh2925831(HttpServletRequest request, ModelMap model) {
		model = epwh2925801Service.epwh2925831_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH2925831";
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
			
			return "/WH_M/EPWH2925831";
		}
		
		
	}
	
	/**
	 *  회수정보등록도매업자 변경시 지점 & 보증금,수수료 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @      
	 */
	@RequestMapping(value="/WH/EPWH2925831_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2925831_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2925801Service.epwh2925831_select2(inputMap, request)).toString();
	}	  
	  
	/**
	 * 회수정보등록 날짜 변경시 보증금,수수료조회
	 * @param inputMap
	 * @param request   
	 * @return
	 * @  
	 */
	@RequestMapping(value="/WH/EPWH2925831_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2925831_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2925801Service.epwh2925831_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 회수정보등록 엑셀업로드 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2925831_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2925831_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2925801Service.epwh2925831_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 소매업자 
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2925831_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2925831_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2925801Service.epwh2925831_select5(inputMap, request)).toString();
	}	
	
	/**
	 * 회수정보등록  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2925831_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh2925831_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh2925801Service.epwh2925831_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
			//if(data.get("ERR_CTNR_NM") !=null){
			//	System.out.println(data.get("ERR_CTNR_NM").toString());
			//}
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
	@RequestMapping(value = "/WH/EPWH2925842.do", produces = "application/text; charset=utf8")
	public String epwh2925842(HttpServletRequest request, ModelMap model) {
		
		model = epwh2925801Service.epwh2925842_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH2925842";
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
			
			return "/WH_M/EPWH2925842";
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
	@RequestMapping(value="/WH/EPWH2925842_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh2925842_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh2925801Service.epwh2925842_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
			//if(data.get("ERR_CTNR_NM") !=null){
			//	System.out.println(data.get("ERR_CTNR_NM").toString());
			//}
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
	*	회수조정
	************************************************************************************************************************************************/
	/**
	 * 회수조정
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH29258422.do", produces = "application/text; charset=utf8")
	public String epwh29258422(HttpServletRequest request, ModelMap model) {
		model = epwh2925801Service.epwh29258422_select(model, request);
		return "/WH/EPWH29258422";
	}

	/***********************************************************************************************************************************************
	*	회수증빙자료관리
	************************************************************************************************************************************************/
	/**
	 * 회수증빙자료관리
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH2925897.do", produces = "application/text; charset=utf8")
	public String epwh2925897(HttpServletRequest request, ModelMap model) {
		model = epwh2925801Service.epwh2925897_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH2925897";
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
			
			return "/WH_M/EPWH2925897";
		}
	}
	
	/**
	 * 회수정보관리  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2925897_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2925897_select(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2925801Service.epwh2925897_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 회수증빙관리 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2925897_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2925897_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
	
		String errCd = "";
		try{
			errCd = epwh2925801Service.epwh2925897_delete(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		   
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}	
	
	/***********************************************************************************************************************************************
	*	회수증빙자료등록
	************************************************************************************************************************************************/
	/**
	 * 회수증빙자료등록
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH2925888.do", produces = "application/text; charset=utf8")
	public String epwh2925888(HttpServletRequest request, ModelMap model) {
		model = epwh2925801Service.epwh2925888_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH2925888";
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
			
			return "/WH_M/EPWH2925888";
		}
	}
	
	/**
	 * 회수증빙자료등록  등록
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2925888_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2925888_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
	
		String errCd = "";
		try{
			errCd = epwh2925801Service.epwh2925888_insert(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		   
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}	
	
	/***********************************************************************************************************************************************
	*	회수증빙자료다운로드
	************************************************************************************************************************************************/
	/**
	 * 회수증빙자료다운로드
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH29258882.do", produces = "application/text; charset=utf8")
	public String epwh29258882(@RequestParam Map<String, Object> param,HttpServletRequest request, ModelMap model) {
		model = epwh2925801Service.epwh29258882_select(param,model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH29258882";
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
			
			return "/WH_M/EPWH29258882";
		}
	}
}
