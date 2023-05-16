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
import egovframework.koraep.mf.ep.service.EPMF2910101Service;
import net.sf.json.JSONObject;


/**
 * 반환관리
 * @author 양성수
 *
 */
@Controller
public class EPMF2910101Controller {

	@Resource(name = "epmf2910101Service")
	private  EPMF2910101Service epmf2910101Service; 	//반환관리 service

	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service


	/**
	 * 반환관리 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/MF/EPMF2910164.do", produces = "application/text; charset=utf8")
	public String epmf2910164(HttpServletRequest request, ModelMap model) {
		System.out.println("상휘1");
		model =epmf2910101Service.epmf2910164_select(model, request);
		return "/MF/EPMF2910164";
	}

	/**
	 * 반환관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2910164_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf2910164_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epmf2910101Service.epmf2910164_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}

	/**
	 * 반환관리 생산자 직매장/공장 선택시  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF2910101_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf2910101_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf2910101Service.epmf2910101_select3(inputMap, request)).toString();
	}


}
