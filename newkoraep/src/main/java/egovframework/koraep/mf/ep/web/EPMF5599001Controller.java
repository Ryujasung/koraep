package egovframework.koraep.mf.ep.web;

import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.mf.ep.service.EPMF5599001Service;
import egovframework.koraep.mf.ep.service.EPMF0140101Service;

/**
 * 본인정보조회 Controller
 * @author Administrator
 *
 */

@Controller
public class EPMF5599001Controller {

	@Resource(name="epmf0140101Service")
	private EPMF0140101Service epmf0140101Service;
	
	@Resource(name="epmf5599001Service")
	private EPMF5599001Service epmf5599001Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 회원 상세조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF5599001.do")
	public String epmf0140164(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPMF5599001");
		model.addAttribute("titleSub", title);
		
		HashMap<String, String> map = new HashMap<String, String>();
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		if(vo != null){
			map.put("USER_ID", vo.getUSER_ID());
			map.put("S_BIZRNO", vo.getBIZRNO_ORI());
		}
		
		model = epmf0140101Service.epmf0140164_select(model, request, map);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);
		
		return "/MF/EPMF5599001";
	}

	/**
	 * 회원 정보 변경
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF5599042.do")
	public String epmf0140142(ModelMap model, HttpServletRequest request) {
		
		model = epmf0140101Service.epmf0140142_select(model, request);
		
		return "/MF/EPMF5599042";
	}
	
	/**
	 * 사업자정보 상세조회 
	 * @param data
	 * @param request
	 * @return 
	 * @
	 */
	@RequestMapping(value="/MF/EPMF55990012.do")
	public String epmf55990012(ModelMap model, HttpServletRequest request) {
		
		model = epmf5599001Service.epmf55990012_select(model, request);

		return "/MF/EPMF55990012";
	}
	
	/**
	 * 사업자정보변경
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF55990422.do", produces="application/text; charset=utf8")
	public String epmf55990422(ModelMap model, HttpServletRequest request) {
		
		model = epmf5599001Service.epmf55990422_select(model, request);
		
		return "/MF/EPMF0160142";
	}
}
