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

import egovframework.koraep.ce.ep.service.EPCE8126695Service;

/**
 * 문의/답변상세조회 Controller
 * @author pc
 *
 */
@Controller
public class EPCE8126695Controller {
	
	private static final Logger log = LoggerFactory.getLogger(EPCE8126695Controller.class);
	
	@Resource(name="epce8126695Service")
	private EPCE8126695Service epce8126695Service;
	
	/**
	 * 문의/답변 상세조회 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8126695.do", produces="application/text; charset=utf8")
	public String epce8126695(ModelMap model, HttpServletRequest request)  {
		
		//문의/답변 상세, 답변글 리스트 조회
		model = epce8126695Service.epce8126695(model, request);
		
		return "CE/EPCE8126695";
		
	}
	
	/**
	 * 문의/답변 삭제
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8126695_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce8126695_delete(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		
		return Integer.toString(epce8126695Service.epce8126695_delete(data, request));
		
	}

}
