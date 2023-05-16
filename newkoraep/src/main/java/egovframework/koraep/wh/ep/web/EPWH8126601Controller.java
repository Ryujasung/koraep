package egovframework.koraep.wh.ep.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import egovframework.koraep.wh.ep.service.EPWH8126601Service;

/**
 * 문의/답변 Controller
 * @author pc
 *
 */
@Controller
public class EPWH8126601Controller {
	
	private static final Logger log = LoggerFactory.getLogger(EPWH8126601Controller.class);
	
	@Resource(name="epwh8126601Service")
	private EPWH8126601Service epwh8126601Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service
	
	/**
	 * 문의/답변 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8126601.do", produces="application/text; charset=utf8")
	public String epwh8126601(ModelMap model, HttpServletRequest request)  {
		
		if(request.getParameter("ASK_SEQ") != null){ //상세조회 바로이동
			model.addAttribute("ASK_SEQ", request.getParameter("ASK_SEQ").toString());
		}
		
		//공지사항 게시글 수 조회
		model = epwh8126601Service.epwh8126601(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH8126601";
		}else{ //모바일
			String title = commonceService.getMenuTitle("EPWH8126601");	//타이틀
			model.addAttribute("titleSub", title);
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";

			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
				model.addAttribute("userInfo", ssUserInfo); //사용자
				model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
				model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdList(vo))); //메뉴
			}
			
			return "/WH_M/EPWH8126601";
		}
	}
	
	/**
	 * 문의/답변 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8126601_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh8126601_select(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		
		return util.mapToJson(epwh8126601Service.epwh8126601_select(data, request)).toString();
		
	}

}
