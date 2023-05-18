package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.sql.SQLException;
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
import egovframework.koraep.ce.ep.service.EPCE2371301Service;
import net.sf.json.JSONObject;

/**
 * 지급내역조회 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE2371301Controller {

	@Resource(name="epce2371301Service")
	private EPCE2371301Service epce2371301Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;//공통 service

	/**
	 * 지급내역조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2371301.do")
	public String epce2371301(ModelMap model, HttpServletRequest request) {
		model = epce2371301Service.epce2371301_select(model, request);

		return "/CE/EPCE2371301";
	}
	
	/**
	 * 연계전송 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2371331.do")
	public String epce2371331(ModelMap model, HttpServletRequest request) {
		model = epce2371301Service.epce2371331_select(model, request);

		return "/CE/EPCE2371331";
	}

	/**
	 * 지급내역상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2371364.do")
	public String epce2371364(ModelMap model, HttpServletRequest request) {
		model = epce2371301Service.epce2371364_select(model, request);

		return "/CE/EPCE2371364";
	}


	/**
	 * 지급내역조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2371301_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2371301_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce2371301Service.epce2371301_select2(data)).toString();
	}

	/**
	 * 연계자료생성
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2371331_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2371331_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = epce2371301Service.epce2371331_insert(data, request);
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}

	/**
	 * 오류건 재전송
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2371331_092.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2371331_insert2(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = epce2371301Service.epce2371331_insert2(data, request);
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}

	/**
	 * 지급내역조회 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE2371301_05.do")
	@ResponseBody
	public String epce2371301_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = epce2371301Service.epce2371301_excel(data, request);
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
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
	@RequestMapping(value="/CE/EPCE2371364_05.do")
	@ResponseBody
	public String epce2371364_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = epce2371301Service.epce2371364_excel(data, request);
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}
}
