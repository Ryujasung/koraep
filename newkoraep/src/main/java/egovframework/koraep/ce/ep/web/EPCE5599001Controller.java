package egovframework.koraep.ce.ep.web;

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
import egovframework.koraep.ce.ep.service.EPCE0140101Service;
import egovframework.koraep.ce.ep.service.EPCE5599001Service;

/**
 * 본인정보조회 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE5599001Controller {

	@Resource(name="epce0140101Service")
	private EPCE0140101Service epce0140101Service;
	
	@Resource(name="epce5599001Service")
	private EPCE5599001Service epce5599001Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 회원 상세조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE5599001.do")
	public String epce0140164(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE5599001");
		model.addAttribute("titleSub", title);
		
		HashMap<String, String> map = new HashMap<String, String>();
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		if(vo != null){
			map.put("USER_ID", vo.getUSER_ID());
		}
		
		model = epce0140101Service.epce0140164_select(model, request, map);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);
		
		return "/CE/EPCE5599001";
	}

	/**
	 * 회원 정보 변경
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE5599042.do")
	public String epce0140142(ModelMap model, HttpServletRequest request) {
		
		model = epce0140101Service.epce0140142_select(model, request);
		
		return "/CE/EPCE5599042";
	}
	
	/**
	 * 사업자정보 상세조회 
	 * @param data
	 * @param request
	 * @return 
	 * @
	 */
	@RequestMapping(value="/CE/EPCE55990012.do")
	public String epce55990012(ModelMap model, HttpServletRequest request) {
		
		model = epce5599001Service.epce55990012_select(model, request);

		return "/CE/EPCE55990012";
	}
	
	/**
	 * 사업자정보변경
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE55990422.do", produces="application/text; charset=utf8")
	public String epce55990422(ModelMap model, HttpServletRequest request) {
		
		model = epce5599001Service.epce55990422_select(model, request);
		
		return "/CE/EPCE0160142";
	}
	
}
