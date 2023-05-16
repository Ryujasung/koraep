package egovframework.koraep.wh.ep.web;

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
import egovframework.koraep.wh.ep.service.EPWH8149093Service;

/**
 * 공지사항 상세조회 Controller
 * @author pc
 *
 */
@Controller
public class EPWH8149093Controller {
	
	@Resource(name="epwh8149093Service")
	private EPWH8149093Service epwh8149093Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service
	
	/**
	 * 공지사항 상세조회 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8149093.do", produces="application/text; charset=utf8")
	public String epwh8149093(ModelMap model, HttpServletRequest request)  {
		
		//공지사항 상세, 이전글, 다음글 리스트 조회
		model = epwh8149093Service.epwh8149093(model, request);

		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH8149093";
		}else{ //모바일
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";

			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
				model.addAttribute("userInfo", ssUserInfo); //사용자
				model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
				model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdList(vo))); //메뉴
				model.addAttribute("APP", session.getAttribute("APP")); //앱접속여부
			}
			
			return "/WH_M/EPWH8149093";
		}

	}
	
	/**
	 * 공지사항 삭제
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8149093_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh8149093_delete(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		
		return Integer.toString(epwh8149093Service.epwh8149093_delete(data, request));
		
	}

}
