package egovframework.koraep.wh.ep.web;

import java.io.IOException;
import java.sql.SQLException;
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
import egovframework.koraep.wh.ep.service.EPWH4707201Service;
import net.sf.json.JSONObject;

/**
 * 정산서조회 Controller
 * @author Administrator
 *
 */

@Controller
public class EPWH4707201Controller {

	@Resource(name="epwh4707201Service")
	private EPWH4707201Service epwh4707201Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service

	/**
	 * 정산서조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4707201.do")
	public String epwh4707201(ModelMap model, HttpServletRequest request) {
		model = epwh4707201Service.epwh4707201_select(model, request);

		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);

		if(device.isNormal()){ //웹
			return "/WH/EPWH4707201";
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
			

			return "/WH_M/EPWH4707201";
		}
	}

	/**
	 * 정산서 상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4707264.do")
	public String epwh4707264(ModelMap model, HttpServletRequest request) {
		model = epwh4707201Service.epwh4707264_select(model, request);

		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);

		if(device.isNormal()){ //웹
			return "/WH/EPWH4707264";
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
			return "/WH_M/EPWH4707264";
		}
	}

	/**
	 * 정산서조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4707201_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh0101801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epwh4707201Service.epwh4707201_select2(data, request)).toString();
	}

	/**
	 * 정산서발급취소
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4707201_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh4707201_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			errCd = epwh4707201Service.epwh4707201_update(data, request);
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
	 * 수납확인내역 상세조회팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4707288.do", produces="application/text; charset=utf8")
	public String epce2308888(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPWH4707288");
		model.addAttribute("titleSub", title);

		return "/WH/EPWH4707288";
	}

	/**
	 * 수납확인 상세조회 (고지서)
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4707288_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2308888_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epwh4707201Service.epwh4707288_select(data)).toString();
	}

	/**
	 * 수납확인 상세조회 (수납내역)
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH4707288_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2308888_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epwh4707201Service.epwh4707288_select2(data)).toString();
	}

}
