package egovframework.koraep.mf.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.mf.ep.service.EPMF6657001Service;

/**
 * 연간출고회수현황확인서 Controller
 * @author pc
 *
 */
@Controller
public class EPMF6657001Controller {
	
	@Resource(name="epmf6657001Service")
	private EPMF6657001Service epmf6657001Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 연간출고회수현황확인서 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6657001.do", produces="application/text; charset=utf8")
	public String epmf6657001(ModelMap model, HttpServletRequest request)  {
		model = epmf6657001Service.epmf6657001_select(model, request);
		return "MF/EPMF6657001";
	}
	
	/**
	 * 연간출고회수현황확인서 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6657001_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6657001_select(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf6657001Service.epmf6657001_select2(data)).toString();
		
	}
	
	@RequestMapping(value="/MF/EPMF6657001_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf6657001_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";
		try{
			errCd = epmf6657001Service.epmf6657001_excel(data, request);
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
