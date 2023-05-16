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
import egovframework.koraep.mf.ep.service.EPMF8126601Service;

/**
 * 문의/답변 Controller
 * @author pc
 *
 */
@Controller
public class EPMF8126601Controller {
	
	@Resource(name="epmf8126601Service")
	private EPMF8126601Service epmf8126601Service;
	
	/**
	 * 문의/답변 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8126601.do", produces="application/text; charset=utf8")
	public String epmf8126601(ModelMap model, HttpServletRequest request)  {
		
		if(request.getParameter("ASK_SEQ") != null){ //상세조회 바로이동
			model.addAttribute("ASK_SEQ", request.getParameter("ASK_SEQ").toString());
		}
		
		//공지사항 게시글 수 조회
		model = epmf8126601Service.epmf8126601(model, request);
		return "/MF/EPMF8126601";
		
	}
	
	/**
	 * 문의/답변 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8126601_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf8126601_select(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		return util.mapToJson(epmf8126601Service.epmf8126601_select(data, request)).toString();
		
	}

}
