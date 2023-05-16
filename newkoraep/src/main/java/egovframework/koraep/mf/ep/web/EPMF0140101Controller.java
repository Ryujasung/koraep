package egovframework.koraep.mf.ep.web;

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
import egovframework.koraep.mf.ep.service.EPMF0140101Service;

/**
 * 회원관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPMF0140101Controller {

	
	@Resource(name="epmf0140101Service")
	private EPMF0140101Service epmf0140101Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 회원관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0140101.do")
	public String epmf0140101(ModelMap model, HttpServletRequest request) {
		
		model = epmf0140101Service.epmf0140101_select(model, request);
		
		return "/MF/EPMF0140101";
	}
	
	/**
	 * 회원관리 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0140101_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0140101_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		return util.mapToJson(epmf0140101Service.epmf0140101_select2(data, request)).toString();
	}
	
	/**
	 * 회원관리 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0140101_05.do")
	@ResponseBody
	public String epmf0140101_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf0140101Service.epmf0140101_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 회원상태 처리
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0140101_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf3978301_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			if(data.get("gGubn").equals("A")){
				errCd = epmf0140101Service.epmf0140101_update(data, request); //회원복원
			}else if(data.get("gGubn").equals("B")){
				errCd = epmf0140101Service.epmf0140101_update2(data, request); //관리자변경
			}else if(data.get("gGubn").equals("C")){
				errCd = epmf0140101Service.epmf0140101_update(data, request); //비활동처리
			}else if(data.get("gGubn").equals("D")){
				errCd = epmf0140101Service.epmf0140101_update3(data, request); //비밀번호변경승인
			}
			
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 권한설정 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0140188.do")
	public String epmf0140188(ModelMap model, HttpServletRequest request) {
		
		model = epmf0140101Service.epmf0140188_select(model);
		
		return "/MF/EPMF0140188";
	}
	
	/**
	 * 권한그룹 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0140188_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0140188_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf0140101Service.epmf0140188_select2(data, request)).toString();
	}
	
	/**
	 * 메뉴 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0140188_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0140188_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf0140101Service.epmf0140188_select3(data)).toString();
	}
	
	/**
	 * 권한그룹 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0140188_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0140188_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf0140101Service.epmf0140188_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 사용자변경이력 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF01401882.do")
	public String epmf01401882(ModelMap model, HttpServletRequest request) {
		
		model = epmf0140101Service.epmf01401882_select(model);
		
		return "/MF/EPMF01401882";
	}
	
	/**
	 * 사용자변경이력 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF01401882_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf01401882_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf0140101Service.epmf01401882_select2(data)).toString();
	}
	
	/**
	 * 회원 상세조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0140164.do")
	public String epmf0140164(ModelMap model, HttpServletRequest request) {
		
		String title = commonceService.getMenuTitle("EPMF0140164");
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
			returnUrl = "/MF/EPMF0140164";
		}else{
			returnUrl = "/MF/EPMF5599001";
			map = new HashMap<String, String>();
			map.put("USER_ID", sUserId);
		}
		
		map.put("S_BIZRNO", sBizrno);
		
		model = epmf0140101Service.epmf0140164_select(model, request, map);
		
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
	@RequestMapping(value="/MF/EPMF0140164_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0140164_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf0140101Service.epmf0140164_select2(data, request)).toString();
	}
	
	/**
	 * 회원 정보 변경
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0140142.do")
	public String epmf0140142(ModelMap model, HttpServletRequest request) {
		
		model = epmf0140101Service.epmf0140142_select(model, request);
		
		return "/MF/EPMF0140142";
	}
	
	/**
	 * 회원 정보 변경 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0140142_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0140142_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf0140101Service.epmf0140142_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 회원가입승인
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF0140164_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0140164_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf0140101Service.epmf0140164_update(data, request);
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
	@RequestMapping(value="/MF/EPMF0140164_212.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf0140164_update2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf0140101Service.epmf0140164_update2(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
}
