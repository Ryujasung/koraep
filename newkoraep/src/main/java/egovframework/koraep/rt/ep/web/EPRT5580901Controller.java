package egovframework.koraep.rt.ep.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.rt.ep.service.EPRT5580901Service;

/**
 * 마이메뉴 관리Controller
 * @author Administrator
 *
 */

@Controller
public class EPRT5580901Controller {

	@Resource(name="eprt5580901Service")
	private EPRT5580901Service eprt5580901Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 마이메뉴관리 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT5580901.do", produces="application/text; charset=utf8")
	public String eprt0101801(ModelMap model, HttpServletRequest request) {
		return "/RT/EPRT5580901";
	}
	
	/**
	 * 사용자 권한메뉴 및 설정된 마이메뉴 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT5580901_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String eprt5580901_select1(@RequestParam Map<String, String> param, HttpServletRequest request) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		if(param == null) param = new HashMap<String, String>();
		
		param.put("USER_ID", vo.getUSER_ID());
		param.put("BIZRID", vo.getBIZRID());
		param.put("BIZRNO", vo.getBIZRNO_ORI());
		
		List<?> allList = eprt5580901Service.eprt5580901_select1(param);
		map.put("allMenuList", allList);
		
		List<?> myList = eprt5580901Service.eprt5580901_select2(param);
		map.put("myMenuList", myList);
		
		return util.mapToJson(map).toString();
	}
	
	
	
	/**
	 * 사용자 마이메뉴 저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT5580901_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String eprt5580901_save(@RequestParam Map<String, Object> param, HttpServletRequest request) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		param.put("USER_ID", vo.getUSER_ID());
		param.put("RGST_PRSN_ID", vo.getUSER_ID());
		
		List<?> myList = eprt5580901Service.eprt5580901_save(param);
		map.put("myMenuList", myList);
		
		return util.mapToJson(map).toString();
	}
}
