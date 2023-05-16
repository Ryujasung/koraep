package egovframework.koraep.wh.ep.web;

import java.util.HashMap;
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
import egovframework.koraep.wh.ep.service.EPWH0140101Service;
import egovframework.koraep.wh.ep.service.EPWH5599001Service;
import net.sf.json.JSONObject;

/**
 * 본인정보조회 Controller
 * @author Administrator
 *
 */

@Controller
public class EPWH5599001Controller {

	@Resource(name="epwh0140101Service")
	private EPWH0140101Service epwh0140101Service;

	@Resource(name="epwh5599001Service")
	private EPWH5599001Service epwh5599001Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service

	/**
	 * 회원 상세조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH5599001.do")
	public String epwh0140164(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPWH5599001");
		model.addAttribute("titleSub", title);

		HashMap<String, String> map = new HashMap<String, String>();

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		if(vo != null){
			map.put("USER_ID", vo.getUSER_ID());
			map.put("S_BIZRNO", vo.getBIZRNO_ORI());
		}

		model = epwh0140101Service.epwh0140164_select(model, request, map);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);

		return "/WH/EPWH5599001";
	}

	/**
	 * 회원 정보 변경
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH5599042.do")
	public String epwh0140142(ModelMap model, HttpServletRequest request) {

		model = epwh0140101Service.epwh0140142_select(model, request);

		return "/WH/EPWH5599042";
	}

	/**
	 * 사업자정보 상세조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH55990012.do")
	public String epwh55990012(ModelMap model, HttpServletRequest request) {

		model = epwh5599001Service.epwh55990012_select(model, request);

		return "/WH/EPWH55990012";
	}

	/**
	 *  지역 일괄 설정 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH55990088.do", produces = "application/text; charset=utf8")
	public String epwh55990088(HttpServletRequest request, ModelMap model) {
		model =epwh5599001Service.epwh55990088(model, request);
		return "/WH/EPWH55990088";
	}

	/**
	 * 지역 일괄 설정 저장/수정
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH0181088_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0181088_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epwh5599001Service.epwh0181088_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}

	/**
	 * 사업자정보변경
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH55990422.do", produces="application/text; charset=utf8")
	public String epwh55990422(ModelMap model, HttpServletRequest request) {

		model = epwh5599001Service.epwh55990422_select(model, request);

		return "/WH/EPWH0160142";
	}

	/**
	 * 소속단체설정 팝업호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH55990013.do", produces="text/plain;charset=UTF-8")
	public String epce0160188(ModelMap model, HttpServletRequest request)  {
		model = epwh5599001Service.epce55990013(model, request);
		return "WH/EPWH55990013";
	}

	/**
	 * 단체 설정 저장/수정
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPCE55990013_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce55990013_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epwh5599001Service.epce55990013_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}

}
