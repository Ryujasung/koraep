package egovframework.koraep.wh.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

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
import egovframework.koraep.wh.ep.service.EPWH2910142Service;


/**
 * 반환내역서변경
 * @author 양성수
 *
 */
@Controller
public class EPWH2910142Controller {  

	@Resource(name = "epwh2910142Service")
	private  EPWH2910142Service epwh2910142Service; 	//반환관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 반환내역서 변경 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH2910142.do", produces = "application/text; charset=utf8")
	public String epwh2910142(HttpServletRequest request, ModelMap model) {

		model =epwh2910142Service.epwh2910142_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH2910142";
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
			
			return "/WH_M/EPWH2910142";
		}
	}

	/**
	 * 반환내역서변경 빈용기구분 선택시 빈용기명조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910142_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910142_select5(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2910142Service.epwh2910142_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 반환내역서변경 그리드 컬럼 선택시
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910142_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910142_select6(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2910142Service.epwh2910142_select3(inputMap, request)).toString();
	}	
	
	
	/**
	 * 반환내역서변경  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910142_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh2910142_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh2910142Service.epwh2910142_update(data, request);
			
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 	반환내역서 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910142_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910142_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epwh2910142Service.epwh2910142_delete(inputMap, request);
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	

	
}
