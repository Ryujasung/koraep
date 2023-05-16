package egovframework.koraep.ce.ep.web;

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
import egovframework.koraep.ce.ep.service.EPCE8126601Service;

/**
 * 문의/답변 Controller
 * @author pc
 *
 */
@Controller
public class EPCE8126601Controller {
	
	private static final Logger log = LoggerFactory.getLogger(EPCE8126601Controller.class);
	
	@Resource(name="epce8126601Service")
	private EPCE8126601Service epce8126601Service;
	
	/**
	 * 문의/답변 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8126601.do", produces="application/text; charset=utf8")
	public String epce8126601(ModelMap model, HttpServletRequest request)  {
		
		if(request.getParameter("ASK_SEQ") != null){ //상세조회 바로이동
			model.addAttribute("ASK_SEQ", request.getParameter("ASK_SEQ").toString());
		}
		
		//공지사항 게시글 수 조회
		model = epce8126601Service.epce8126601(model, request);
		return "/CE/EPCE8126601";
		
	}
	
	/**
	 * 문의/답변 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8126601_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce8126601_select(@RequestParam Map<String, String> data, HttpServletRequest request)  {

		return util.mapToJson(epce8126601Service.epce8126601_select(data, request)).toString();
		
	}

}
