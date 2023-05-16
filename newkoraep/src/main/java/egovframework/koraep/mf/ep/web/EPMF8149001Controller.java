package egovframework.koraep.mf.ep.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.mf.ep.service.EPMF8149001Service;

/**
 * 공지사항 Controller
 * @author pc
 *
 */
@Controller

public class EPMF8149001Controller {
	
	@Resource(name="epmf8149001Service")
	private EPMF8149001Service epmf8149001Service;
	
	/**
	 * 공지사항 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8149001.do", produces="application/text; charset=utf8")
	public String epmf8149001(ModelMap model, HttpServletRequest request)  {

		if(request.getParameter("NOTI_SEQ") != null){ //상세조회 바로이동
			model.addAttribute("NOTI_SEQ", request.getParameter("NOTI_SEQ").toString());
		}
		
		//공지사항 게시글 수 조회
		model = epmf8149001Service.epmf8149001(model, request);
		return "MF/EPMF8149001";
		
	}
	
	/**
	 * 공지사항 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8149001_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf8149001_select(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		
		return util.mapToJson(epmf8149001Service.epmf8149001_select(data, request)).toString();
		
	}

}
