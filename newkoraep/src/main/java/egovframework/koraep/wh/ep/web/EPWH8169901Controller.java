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
import egovframework.koraep.wh.ep.service.EPWH8169901Service;

/**
 * FAQ Controller
 * @author pc
 *
 */
@Controller
public class EPWH8169901Controller {
	
	private static final Logger log = LoggerFactory.getLogger(EPWH8169901Controller.class);
	
	@Resource(name="epwh8169901Service")
	private EPWH8169901Service epwh8169901Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service
	
	/**
	 * FAQ 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8169901.do", produces="application/text; charset=utf8")
	public String epwh8169901(ModelMap model, HttpServletRequest request)  {
		
		//FAQ 게시글 수 조회
		model = epwh8169901Service.epwh8169901(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH8169901";
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
			
			return "/WH_M/EPWH8169901";
		}
		
		
		
	}
	
	/**
	 * FAQ 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8169901_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh8169901_select(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		
		return util.mapToJson(epwh8169901Service.epwh8169901_select(data, request)).toString();
		
	}

}
