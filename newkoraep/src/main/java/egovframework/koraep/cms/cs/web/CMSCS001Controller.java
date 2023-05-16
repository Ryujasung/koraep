package egovframework.koraep.cms.cs.web;

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
import egovframework.koraep.cms.cs.service.CMSCS001Service;
import net.sf.json.JSONObject;

/**
 * 지급내역조회 Controller
 * @author Administrator
 *
 */

@Controller
public class CMSCS001Controller {

	@Resource(name="cmscs001Service")
	private CMSCS001Service cmscs001Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;//공통 service
	
	/**
	 * 예금주결과조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CMS/CMSCS001.do")
	public String cmscs001(ModelMap model, HttpServletRequest request) {
		model = cmscs001Service.cmscs0001_select(model, request);
		return "/CMS/CMS_CS_001";
	}
	
	/*
	 * 예금주조회결과조회
	 * @param model
	 * @param request
	 * @return
	 * 
	 */
	@RequestMapping(value="/CMS/CMSCS001_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String cmscs001_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(cmscs001Service.cmscs001_select2(data)).toString();
	}

}
