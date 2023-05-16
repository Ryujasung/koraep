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

import egovframework.koraep.mf.ep.service.EPMF8169997Service;

/**
 * FAQ 상세조회 Controller
 * @author pc
 *
 */
@Controller
public class EPMF8169997Controller {
	
	private static final Logger log = LoggerFactory.getLogger(EPMF8169997Controller.class);
	
	@Resource(name="epmf8169997Service")
	private EPMF8169997Service epmf8169997Service;
	
	/**
	 * FAQ 상세조회 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8169997.do", produces="application/text; charset=utf8")
	public String epmf8169997(ModelMap model, HttpServletRequest request)  {
		
		//공지사항 상세, 이전글, 다음글 리스트 조회
		model = epmf8169997Service.epmf8169997(model, request);
		
		return "MF/EPMF8169997";
		
	}
	
	/**
	 * FAQ 삭제
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8169997_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf8169997_delete(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		
		return Integer.toString(epmf8169997Service.epmf8169997_delete(data, request));
		
	}

}
