package egovframework.koraep.ce.ep.web;

import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE0140199Service;

/**
 * 회원관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE0140199Controller {

	
	@Resource(name="epce0140199Service")
	private EPCE0140199Service epce0140199Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 회원관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0140199.do")
	public String epce0140199(ModelMap model, HttpServletRequest request) {
		
		model = epce0140199Service.epce0140199_select(model, request);
		
		return "/CE/EPCE0140199";
	}
	
	/**
	 * 휴면예정계정 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0140199_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0140199_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) throws Exception {
		
		
		String err = epce0140199Service.epce0140199_merge(data, request);
		
		return util.mapToJson(epce0140199Service.epce0140199_select2(data, request)).toString();
	}
	
	
	/**
	 * 메일발송
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0140199_99.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0140199_mail(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			
			if(data.get("gGubn").equals("A")){
				errCd = epce0140199Service.epce0140199_mail(data, request); //회원복원
			}
			
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
		
		
		
//		return util.mapToJson(epce0140199Service.epce0140199_select2(data, request)).toString();
	}
	
	/**
	 * 회원관리 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0140199_05.do")
	@ResponseBody
	public String epce0140199_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0140199Service.epce0140199_excel(data, request);
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
	@RequestMapping(value="/CE/EPCE0140199_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce3978301_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			if(data.get("gGubn").equals("A")){
				errCd = epce0140199Service.epce0140199_update(data, request); //회원복원
			}else if(data.get("gGubn").equals("B")){
				errCd = epce0140199Service.epce0140199_update2(data, request); //관리자변경
			}else if(data.get("gGubn").equals("C")){
				errCd = epce0140199Service.epce0140199_update(data, request); //비활동처리
			}else if(data.get("gGubn").equals("D")){
				errCd = epce0140199Service.epce0140199_update3(data, request); //비밀번호변경승인
			}else if(data.get("gGubn").equals("E")){
				errCd = epce0140199Service.epce0140199_update4(data, request); //비밀번호오류초기화
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
//	@RequestMapping(value="/CE/EPCE0140188.do")
//	public String epce0140188(ModelMap model, HttpServletRequest request) {
//		
//		model = epce0140199Service.epce0140188_select(model);
//		
//		return "/CE/EPCE0140188";
//	}
	
	/**
	 * 권한그룹 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
//	@RequestMapping(value="/CE/EPCE0140188_19.do", produces="text/plain;charset=UTF-8")
//	@ResponseBody
//	public String epce0140188_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
//		return util.mapToJson(epce0140199Service.epce0140188_select2(data)).toString();
//	}
	
	/**
	 * 메뉴 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
//	@RequestMapping(value="/CE/EPCE0140188_192.do", produces="text/plain;charset=UTF-8")
//	@ResponseBody
//	public String epce0140188_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
//		return util.mapToJson(epce0140199Service.epce0140188_select3(data)).toString();
//	}
	
	/**
	 * 권한그룹 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
//	@RequestMapping(value="/CE/EPCE0140188_21.do", produces="text/plain;charset=UTF-8")
//	@ResponseBody
//	public String epce0140188_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
//		
//		String errCd = "";
//		
//		try{
//			errCd = epce0140199Service.epce0140188_update(data, request);
//		}catch(Exception e){
//			errCd = e.getMessage();
//		}
//		
//		JSONObject rtnObj = new JSONObject();
//		rtnObj.put("RSLT_CD", errCd);
//		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
//		
//		return rtnObj.toString();
//	}
	
	/**
	 * 사용자변경이력 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
//	@RequestMapping(value="/CE/EPCE01401882.do")
//	public String epce01401882(ModelMap model, HttpServletRequest request) {
//		
//		model = epce0140199Service.epce01401882_select(model);
//		
//		return "/CE/EPCE01401882";
//	}
	
	/**
	 * 사용자변경이력 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
//	@RequestMapping(value="/CE/EPCE01401882_19.do", produces="text/plain;charset=UTF-8")
//	@ResponseBody
//	public String epce01401882_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
//		return util.mapToJson(epce0140199Service.epce01401882_select2(data)).toString();
//	}
	
	/**
	 * 회원 상세조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
//	@RequestMapping(value="/CE/EPCE0140164.do")
//	public String epce0140164(ModelMap model, HttpServletRequest request) {
//		
//		String title = commonceService.getMenuTitle("EPCE0140164");
//		model.addAttribute("titleSub", title);
//		
//		//파라메터 정보
//		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
//		JSONObject jParams = JSONObject.fromObject(reqParams);
//		model.addAttribute("INQ_PARAMS",jParams);
//		
//		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
//		
//		String returnUrl = "";
//		
//		if(map != null && map.containsKey("USER_ID")){
//			returnUrl = "/CE/EPCE0140164";
//		}else{
//			returnUrl = "/CE/EPCE5599001";
//			
//			map = new HashMap<String, String>();
//			
//			HttpSession session = request.getSession();
//			UserVO vo = (UserVO) session.getAttribute("userSession");
//			if(vo != null){
//				map.put("USER_ID", vo.getUSER_ID());
//			}
//		}
//		
//		model = epce0140199Service.epce0140164_select(model, request, map);
//		
//		return returnUrl;
//	}
	
	/**
	 * 회원 상세조회2
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
//	@RequestMapping(value="/CE/EPCE0140164_19.do", produces="text/plain;charset=UTF-8")
//	@ResponseBody
//	public String epce0140164_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
//		return util.mapToJson(epce0140199Service.epce0140164_select2(data)).toString();
//	}
	
	/**
	 * 회원 정보 변경
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
//	@RequestMapping(value="/CE/EPCE0140142.do")
//	public String epce0140142(ModelMap model, HttpServletRequest request) {
//		
//		model = epce0140199Service.epce0140142_select(model, request);
//		
//		return "/CE/EPCE0140142";
//	}
	
	/**
	 * 회원 정보 변경 저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
//	@RequestMapping(value="/CE/EPCE0140142_21.do", produces="text/plain;charset=UTF-8")
//	@ResponseBody
//	public String epce0140142_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
//		
//		String errCd = "";
//		
//		try{
//			errCd = epce0140199Service.epce0140142_update(data, request);
//		}catch(Exception e){
//			errCd = e.getMessage();
//		}
//		
//		JSONObject rtnObj = new JSONObject();
//		rtnObj.put("RSLT_CD", errCd);
//		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
//		
//		return rtnObj.toString();
//	}
	
	/**
	 * 회원 정보 삭제
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
//	@RequestMapping(value="/CE/EPCE0140164_04.do", produces="text/plain;charset=UTF-8")
//	@ResponseBody
//	public String epce0140142_delete(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
//		
//		String errCd = "";
//		
//		try{
//			errCd = epce0140199Service.epce0140142_delete(data, request);
//		}catch(Exception e){
//			errCd = e.getMessage();
//		}
//		
//		JSONObject rtnObj = new JSONObject();
//		rtnObj.put("RSLT_CD", errCd);
//		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
//		
//		return rtnObj.toString();
//	}
	
	/**
	 * 회원가입승인
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
//	@RequestMapping(value="/CE/EPCE0140164_21.do", produces="text/plain;charset=UTF-8")
//	@ResponseBody
//	public String epce0140164_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
//		
//		String errCd = "";
//		
//		try{
//			errCd = epce0140199Service.epce0140164_update(data, request);
//		}catch(Exception e){
//			errCd = e.getMessage();
//		}
//		
//		JSONObject rtnObj = new JSONObject();
//		rtnObj.put("RSLT_CD", errCd);
//		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
//		
//		return rtnObj.toString();
//	}
	
	/**
	 * 회원탈퇴
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
//	@RequestMapping(value="/CE/EPCE0140164_212.do", produces="text/plain;charset=UTF-8")
//	@ResponseBody
//	public String epce0140164_update2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
//		
//		String errCd = "";
//		
//		try{
//			errCd = epce0140199Service.epce0140164_update2(data, request);
//		}catch(Exception e){
//			errCd = e.getMessage();
//		}
//		
//		JSONObject rtnObj = new JSONObject();
//		rtnObj.put("RSLT_CD", errCd);
//		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
//		
//		return rtnObj.toString();
//	}
}
