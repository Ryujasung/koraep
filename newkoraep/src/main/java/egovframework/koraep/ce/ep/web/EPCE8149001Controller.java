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
import egovframework.koraep.ce.ep.service.EPCE8149001Service;
import egovframework.koraep.ce.ep.service.EPCE8149093Service;

/**
 * 공지사항 Controller
 * @author pc
 *
 */
@Controller

public class EPCE8149001Controller {

	@Resource(name="epce8149001Service")
	private EPCE8149001Service epce8149001Service;

	@Resource(name="epce8149093Service")
	private EPCE8149093Service epce8149093Service;

	/**
	 * 공지사항 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8149001.do", produces="application/text; charset=utf8")
	public String epce8149001(ModelMap model, HttpServletRequest request)  {

		if(request.getParameter("NOTI_SEQ") != null){ //상세조회 바로이동
			model.addAttribute("NOTI_SEQ", request.getParameter("NOTI_SEQ").toString());
		}

		//공지사항 게시글 수 조회
		model = epce8149001Service.epce8149001(model, request);
		return "CE/EPCE8149001";

	}

	/**
	 * 공지사항 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8149001_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce8149001_select(@RequestParam Map<String, String> data, HttpServletRequest request)  {

		return util.mapToJson(epce8149001Service.epce8149001_select(data, request)).toString();

	}

/***************************************************************************************************************************************************************************************
* 			문의하기
****************************************************************************************************************************************************************************************/

	/**
	 *  문의하기 공지사항 초기값
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	/*@RequestMapping(value="/CE/EPCE8149088.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce8149088(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce8149001Service.epce8149088_select(inputMap, request)).toString();
	}	*/
	/**
	 * 문의하기 공지사항 초기값
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE8149088.do", produces = "application/text; charset=utf8")
	public String epce8149088(HttpServletRequest request, ModelMap model) {
		model =epce8149001Service.epce8149088_select(model, request);
		return "/CE/epce8149088";
	}


	/**
	 *  문의하기 공지사항 조회
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8149088_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce8149088_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce8149001Service.epce8149088_select2(inputMap, request)).toString();
	}

	/**
	 * 문의하기 공지사항 상세조회 초기값
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE81490882.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce81490882(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce8149001Service.epce81490882_select(inputMap, request)).toString();
	}


}
