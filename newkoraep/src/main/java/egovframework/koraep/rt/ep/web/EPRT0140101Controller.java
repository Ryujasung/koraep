package egovframework.koraep.rt.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.rt.ep.service.EPRT0140101Service;

/**
 * 회원관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPRT0140101Controller {

	
	@Resource(name="eprt0140101Service")
	private EPRT0140101Service eprt0140101Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 회원 상세조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT0140164.do")
	public String eprt0140164(ModelMap model, HttpServletRequest request) {
		
		String title = commonceService.getMenuTitle("EPRT0140164");
		model.addAttribute("titleSub", title);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		
		String returnUrl = "";
		String sUserId = "";
		String sBizrno = "";
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		
		if(vo != null){
			sUserId = vo.getUSER_ID();
			sBizrno = vo.getBIZRNO_ORI();
		}
		
		if(map != null && map.containsKey("USER_ID")){
			returnUrl = "/RT/EPRT0140164";
		}else{
			returnUrl = "/RT/EPRT5599001";
			map = new HashMap<String, String>();
			map.put("USER_ID", sUserId);
		}
		
		map.put("S_BIZRNO", sBizrno);
		
		model = eprt0140101Service.eprt0140164_select(model, request, map);
		
		return returnUrl;
	}
	
	/**
	 * 회원 상세조회2
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT0140164_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String eprt0140164_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(eprt0140101Service.eprt0140164_select2(data)).toString();
	}
	
	/**
	 * 회원 정보 변경
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT0140142.do")
	public String eprt0140142(ModelMap model, HttpServletRequest request) {
		
		model = eprt0140101Service.eprt0140142_select(model, request);
		
		return "/RT/EPRT0140142";
	}
	
	/**
	 * 회원 정보 변경 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT0140142_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String eprt0140142_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = eprt0140101Service.eprt0140142_update(data, request);
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
	 * 회원탈퇴
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT0140164_212.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String eprt0140164_update2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = eprt0140101Service.eprt0140164_update2(data, request);
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
