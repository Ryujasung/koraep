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

import egovframework.koraep.ce.ep.service.EPCE8169997Service;

/**
 * FAQ 상세조회 Controller
 * @author pc
 *
 */
@Controller
public class EPCE8169997Controller {
	
	private static final Logger log = LoggerFactory.getLogger(EPCE8169997Controller.class);
	
	@Resource(name="epce8169997Service")
	private EPCE8169997Service epce8169997Service;
	
	/**
	 * FAQ 상세조회 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8169997.do", produces="application/text; charset=utf8")
	public String epce8169997(ModelMap model, HttpServletRequest request)  {
		
		//공지사항 상세, 이전글, 다음글 리스트 조회
		model = epce8169997Service.epce8169997(model, request);
		
		return "CE/EPCE8169997";
		
	}
	
	/**
	 * FAQ 삭제
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8169997_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce8169997_delete(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		
		return Integer.toString(epce8169997Service.epce8169997_delete(data, request));
		
	}

}
