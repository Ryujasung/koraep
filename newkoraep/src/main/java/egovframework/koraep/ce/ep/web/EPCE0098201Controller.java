package egovframework.koraep.ce.ep.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE0098201Service;

/**
 * 문의하기 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE0098201Controller {

	@Resource(name="epce0098201Service")
	private EPCE0098201Service epce0098201Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 공지사항 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE0098201.do")
	public String epce0098201(ModelMap model, HttpServletRequest request) {

		model =epce0098201Service.epce0098201_select(model, request);
		return "/CE/EPCE0098201";
	}
	
	/** 
	 *  문의하기 공지사항 조회
	 * @param request
	 * @param model
	 * @return
	 * @
	 */		
	@RequestMapping(value="/EP/EPCE0098201_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0098201_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0098201Service.epce0098201_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 공지사항 상세
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE0098288.do" , produces="application/text; charset=utf8")
	public String epce0098288(ModelMap model, HttpServletRequest request) {
		model =epce0098201Service.epce0098288_select(model, request);
		return "/CE/EPCE0098288";
	}
	
	/**
	 *  공지사항 상세 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE0098288_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0098288_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0098201Service.epce0098288_select2(inputMap, request)).toString();
	}	
	
	  
/***************************************************************************************************************************************************************************************
 * 		FAQ
 ****************************************************************************************************************************************************************************************/
	  	
	/**
	 * FAQ 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00982882.do")
	public String epce00982882(ModelMap model, HttpServletRequest request) {
		model =epce0098201Service.epce00982882_select(model, request);
		return "/CE/EPCE00982882";
	}
	
	
	/** 
	 *  문의하기 FAQ 조회
	 * @param request
	 * @param model
	 * @return
	 * @
	 */		
	@RequestMapping(value="/EP/EPCE00982882_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce00982882_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0098201Service.epce00982882_select2(inputMap, request)).toString();
	}	
	
	/**
	 * FAQ 상세
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00982883.do" , produces="application/text; charset=utf8")
	public String epce00982883(ModelMap model, HttpServletRequest request) {
		model =epce0098201Service.epce00982883_select(model, request);
		return "/CE/EPCE00982883";
	}
	
	/**
	 *  FAQ 상세 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00982883_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce00982883_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce0098201Service.epce00982883_select2(inputMap, request)).toString();
	}	


}
