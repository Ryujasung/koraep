package egovframework.koraep.mf.ep.web;

import java.util.HashMap;

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
import egovframework.koraep.mf.ep.service.EPMF8716201Service;

/**
 * 회원가입 Controller
 * @author Administrator
 *
 */

@Controller
public class EPMF8716201Controller {

	
	@Resource(name="epmf8716201Service")
	private EPMF8716201Service epmf8716201Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 회원가입작성 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8716231.do")
	public String epmf8716201(ModelMap model, HttpServletRequest request) {
		
		model = epmf8716201Service.epmf8716231_select(model, request);
		
		return "/MF/EPMF8716231";
	}
	
}
