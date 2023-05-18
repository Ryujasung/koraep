package egovframework.koraep.wh.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

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
import egovframework.koraep.wh.ep.service.EPWH8126695Service;

/**
 * 문의/답변상세조회 Controller
 * @author pc
 *
 */
@Controller
public class EPWH8126695Controller {
	
	private static final Logger log = LoggerFactory.getLogger(EPWH8126695Controller.class);
	
	@Resource(name="epwh8126695Service")
	private EPWH8126695Service epwh8126695Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service
	
	/**
	 * 문의/답변 상세조회 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8126695.do", produces="application/text; charset=utf8")
	public String epwh8126695(ModelMap model, HttpServletRequest request)  {
		
		try {
			//문의/답변 상세, 답변글 리스트 조회
			model = epwh8126695Service.epwh8126695(model, request);

		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			String errCd = e.getMessage();
			
			//페이지이동 조회조건 파라메터 정보
			String reqParams = request.getParameter("INQ_PARAMS");
			if(reqParams==null || reqParams.equals("")) reqParams = "{}";
			JSONObject jParams = JSONObject.fromObject(reqParams);

			model.addAttribute("INQ_PARAMS",jParams);
			model.addAttribute("askInfo", "{}");
			model.addAttribute("ansrInfo","{}");
			model.addAttribute("RSLT_CD", errCd);
			model.addAttribute("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		}
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH8126695";
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
			
			return "/WH_M/EPWH8126695";
		}
	}
	
	/**
	 * 문의/답변 삭제
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8126695_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh8126695_delete(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		
		return Integer.toString(epwh8126695Service.epwh8126695_delete(data, request));
		
	}

}
