package egovframework.koraep.wh.ep.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.wh.ep.service.EPWH9001001Service;
import net.sf.json.JSONObject;


/**
 * 회수대비초과반환현황
 * @author 양성수
 *
 */
@Controller
public class EPWH9001001Controller {

	@Resource(name = "epwh9001001Service")
	private  EPWH9001001Service epwh9001001Service; 	//회수대비초과반환현황 service

	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service


	/**
	 * 회수대비초과반환현황 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH9001001.do", produces = "application/text; charset=utf8")
	public String epwh9001001(HttpServletRequest request, ModelMap model) {
		model =epwh9001001Service.epwh9001001_select(model, request);

		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);

		if(device.isNormal()){ //웹
			System.out.println("asd"+model);
			return "/WH/EPWH9001001";
		}else{ //모바일
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";

			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
				model.addAttribute("userInfo", ssUserInfo); //사용자
				model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
				model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdList(vo))); //메뉴
			}

			return "/WH_M/EPWH9001001";
		}
	}

	/**
	 *  회수대비초과반환현황 도매업자 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9001001_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh9001001_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh9001001Service.epwh9001001_select2(inputMap, request)).toString();
	}

	/**
	 * 회수대비초과반환현황  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9001001_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh9001001_select2(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh9001001Service.epwh9001001_select3(inputMap, request)).toString();
	}

	/**
	 * 회수대비초과반환현황  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9001001_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh9001001_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = epwh9001001Service.epwh9001001_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}


}
