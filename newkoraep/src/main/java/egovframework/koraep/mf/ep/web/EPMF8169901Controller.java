package egovframework.koraep.mf.ep.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.mf.ep.service.EPMF8169901Service;

/**
 * FAQ Controller
 * @author pc
 *
 */
@Controller
public class EPMF8169901Controller {
	
	private static final Logger log = LoggerFactory.getLogger(EPMF8169901Controller.class);
	
	@Resource(name="epmf8169901Service")
	private EPMF8169901Service epmf8169901Service;
	
	/**
	 * FAQ 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8169901.do", produces="application/text; charset=utf8")
	public String epmf8169901(ModelMap model, HttpServletRequest request)  {
		
		//FAQ 게시글 수 조회
		model = epmf8169901Service.epmf8169901(model, request);
		
		return "MF/EPMF8169901";
		
	}
	
	/**
	 * FAQ 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8169901_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf8169901_select(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		
		return util.mapToJson(epmf8169901Service.epmf8169901_select(data, request)).toString();
		
	}

}
