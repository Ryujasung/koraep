package egovframework.koraep.rt.ep.web;

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
import egovframework.koraep.rt.ep.service.EPRT9071301Service;

   
/**
 * 지급내역조회조회
 * @author 양성수
 *
 */
@Controller
public class EPRT9071301Controller {  

	@Resource(name = "eprt9071301Service")
	private  EPRT9071301Service eprt9071301Service; 	//지급내역조회조회 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 지급내역조회 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/RT/EPRT9071301.do", produces = "application/text; charset=utf8")
	public String eprt9071301(HttpServletRequest request, ModelMap model) {
		
		model =eprt9071301Service.eprt9071301_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/RT/EPRT9071301";
		}else{ //모바일
			String title = commonceService.getMenuTitle("EPRT9071301");	//타이틀
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
				model.addAttribute("mmObject", ""); //메뉴
			}
			
			
			return "/RT_M/EPRT9071301";
		}
	}
	
	/**
	 * 지급내역조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT9071301_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String eprt9071301_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(eprt9071301Service.eprt9071301_select2(data, request)).toString();
	}
	
	/**
	 * 지급내역상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT9071364.do")
	public String eprt9071364(ModelMap model, HttpServletRequest request) {
		
		model = eprt9071301Service.eprt9071364_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/RT/EPRT9071364";
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
				model.addAttribute("mmObject", ""); //메뉴
			}
			return "/RT_M/EPRT9071364";
		}
	}
	
	/**
	 * 지급내역조회 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT9071301_05.do")
	@ResponseBody
	public String eprt9071301_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = eprt9071301Service.eprt9071301_excel(data, request);
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
	 * 지급내역상세조회 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT9071364_05.do")
	@ResponseBody
	public String eprt9071364_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = eprt9071301Service.eprt9071364_excel(data, request);
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
