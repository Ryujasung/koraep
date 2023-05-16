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
import egovframework.koraep.mf.ep.service.EPMF8149093Service;

/**
 * 공지사항 상세조회 Controller
 * @author pc
 *
 */
@Controller
public class EPMF8149093Controller {
	
	private static final Logger log = LoggerFactory.getLogger(EPMF8149093Controller.class);
	
	@Resource(name="epmf8149093Service")
	private EPMF8149093Service epmf8149093Service;
	
	/**
	 * 공지사항 상세조회 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8149093.do", produces="application/text; charset=utf8")
	public String epmf8149093(ModelMap model, HttpServletRequest request)  {

		//공지사항 상세, 이전글, 다음글 리스트 조회
		model = epmf8149093Service.epmf8149093(model, request);
		//System.out.println("-----------------------공지사항 상세조회 페이지 호출------------------------------");
		
		return "MF/EPMF8149093";
		
	}
	
	/**
	 * 공지사항 삭제
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8149093_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf8149093_delete(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		return Integer.toString(epmf8149093Service.epmf8149093_delete(data, request));
		
	}

}
