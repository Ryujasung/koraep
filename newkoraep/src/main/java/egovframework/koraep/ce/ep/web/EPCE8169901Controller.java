package egovframework.koraep.ce.ep.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.EPCE8169901Service;

/**
 * FAQ Controller
 * @author pc
 *
 */
@Controller
public class EPCE8169901Controller {
	
	@Resource(name="epce8169901Service")
	private EPCE8169901Service epce8169901Service;
	
	/**
	 * FAQ 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8169901.do", produces="application/text; charset=utf8")
	public String epce8169901(ModelMap model, HttpServletRequest request)  {
		
		//FAQ 게시글 수 조회
		model = epce8169901Service.epce8169901(model, request);
		
		return "CE/EPCE8169901";
		
	}
	
	/**
	 * FAQ 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8169901_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce8169901_select(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		
		return util.mapToJson(epce8169901Service.epce8169901_select(data, request)).toString();
		
	}

}
