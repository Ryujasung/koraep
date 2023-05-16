package egovframework.koraep.rt.ep.web;

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
import egovframework.koraep.rt.ep.service.EPRT9017301Service;

   
/**
 * 반환업무설정
 * @author 양성수
 *
 */
@Controller
public class EPRT9017301Controller {  

	@Resource(name = "eprt9017301Service")
	private  EPRT9017301Service eprt9017301Service; 	//반환업무설정 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 반환업무설정 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/RT/EPRT9017301.do", produces = "application/text; charset=utf8")
	public String eprt9017301(HttpServletRequest request, ModelMap model) {
		
		model = eprt9017301Service.eprt9017301_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/RT/EPRT9017301";
		}else{ //모바일
			String title = commonceService.getMenuTitle("EPRT9017301");	//타이틀
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
				model.addAttribute("mmObject", "");
			}
			return "/RT_M/EPRT9017301";
		}
		
	}
	
	/**
	 * 반환업무설정 도매업자 조회
	 * @param inputMap   
	 * @param request         
	 * @return
	 * @     
	 */   
	@RequestMapping(value="/RT/EPRT9017301_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String eprt9017301_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(eprt9017301Service.eprt9017301_select2(inputMap, request)).toString();
	}     	   
	
	/**
	 * 반환업무설정 설정 저장  
	 * @param map   
	 * @param model   
	 * @param request       
	 * @return   
	 * @   
	 */
	@RequestMapping(value="/RT/EPRT9017301_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String eprt9017301_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";
		try{
			errCd = eprt9017301Service.eprt9017301_insert(data, request);
			
		}catch(Exception e){
			errCd = e.getMessage();
		}
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		return rtnObj.toString();   
	}
	
/***********************************************************************************************************************************************
*	거래처추가 
************************************************************************************************************************************************/
	/**
	 * 거래처추가 페이지 호출   
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/RT/EPRT9017331.do", produces = "application/text; charset=utf8")
	public String eprt9017331(HttpServletRequest request, ModelMap model) {
		model = eprt9017301Service.eprt9017331_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/RT/EPRT9017331";
		}else{ //모바일
			
			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
			
			String title = commonceService.getMenuTitle("EPRT9017331");	//타이틀
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
				model.addAttribute("mmObject", "");
			}
			return "/RT_M/EPRT9017331";
		}
	}
	
	/**
	 * 지점 조회  
	 * @param inputMap        
	 * @param request             
	 * @return   
	 * @         
	 */   
	@RequestMapping(value="/RT/EPRT9017331_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String eprt9017331_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(eprt9017301Service.eprt9017331_select2(inputMap, request)).toString();
	}     	       
	   
	/**   
	 * 거래처 등록         
	 * @param map      
	 * @param model   
	 * @param request         
	 * @return      
	 * @      
	 */
	@RequestMapping(value="/RT/EPRT9017331_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String eprt9017331_insert(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";   
		try{
			errCd = eprt9017301Service.eprt9017331_insert(data, request);
			
		}catch(Exception e){
			errCd = e.getMessage();
		}
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		return rtnObj.toString();
	}
	
	
}
