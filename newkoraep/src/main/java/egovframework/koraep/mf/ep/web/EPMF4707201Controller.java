package egovframework.koraep.mf.ep.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.mf.ep.service.EPMF4707201Service;
import net.sf.json.JSONObject;

/**
 * 정산서조회 Controller
 * @author Administrator
 *
 */

@Controller
public class EPMF4707201Controller {

	@Resource(name="epmf4707201Service")
	private EPMF4707201Service epmf4707201Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service

	/**
	 * 정산서조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4707201.do")
	public String epmf4707201(ModelMap model, HttpServletRequest request) {
		model = epmf4707201Service.epmf4707201_select(model, request);

		return "/MF/EPMF4707201";
	}

	/**
	 * 정산서 상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4707264.do")
	public String epmf4707264(ModelMap model, HttpServletRequest request) {
		model = epmf4707201Service.epmf4707264_select(model, request);

		return "/MF/EPMF4707264";
	}

	/**
	 * 정산서조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4707201_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0101801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf4707201Service.epmf4707201_select2(data, request)).toString();
	}

	/**
	 * 정산서발급취소
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4707201_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf4707201_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			errCd = epmf4707201Service.epmf4707201_update(data, request);
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
	@RequestMapping(value="/MF/EPMF4707288.do", produces="application/text; charset=utf8")
	public String epce2308888(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPMF4707288");
		model.addAttribute("titleSub", title);

		return "/MF/EPMF4707288";
	}

	/**
	 * 수납확인 상세조회 (고지서)
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4707288_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2308888_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf4707201Service.epce4707288_select(data)).toString();
	}

	/**
	 * 수납확인 상세조회 (수납내역)
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF4707288_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2308888_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf4707201Service.epce4707288_select2(data)).toString();
	}

}
