/**
 * 
 */
package egovframework.koraep.ce.ep.web;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE8149301Service;
import egovframework.mapper.ce.ep.EPCE8149093Mapper;

/**
 * 메뉴관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE8149301Controller {


	@Resource(name="epce8149093Mapper")
	private EPCE8149093Mapper epce8149093Mapper;
	
	@Resource(name="epce8149301Service")
	private EPCE8149301Service epce8149301Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 팝업등록 리스트 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8149301.do", produces="text/plain;charset=UTF-8")
	public String epce8149301_select1(ModelMap model, HttpServletRequest request) {
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		String sbj = request.getParameter("SEARCH_SBJ");
		if(sbj == null) sbj = "";
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("SEARCH_SBJ", sbj);
		map.put("ADMIN_YN", "Y");
		
		String jsonStr = epce8149301Service.epce8149301_select1(map);
		String msg = request.getParameter("msg");
		if(msg == null || msg.equals("")) msg = "";
		
		model.addAttribute("msg", msg);
		model.addAttribute("list", jsonStr);

		return "CE/EPCE8149301";
	}
	
	
	/**
	 * 팝업 등록/수정 화면이동
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8149331.do")
	public String epce8149301_select2(ModelMap model, HttpServletRequest request) {
		
		model = epce8149301Service.epce8149301_select2(model, request);
		
		return "CE/EPCE8149331";
	}
	
	
	/**
	 * 팝업 (미리)보기
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8149301_POP.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce8149301_select3(@RequestParam HashMap<String, String> map, HttpServletRequest request) {
		return epce8149301Service.epce8149301_select3(map);
	}

	/**
	 * 팝업 등록/수정
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8149301_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce8149301_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request, RedirectAttributes ra) {
		
		String errCd = "0000";
		String msg = "";
		String url = "/CE/EPCE8149301.do";
		try{
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String userId = vo.getUSER_ID();
			
			//세션값의 권한체크
			Map<String,Object> userInfo = (Map<String, Object>) epce8149093Mapper.getUserInfo(userId);
			//게시글 작성자 조회
			Map<String,Object> faqRegId = epce8149301Service.popRegId(data);
//			System.out.println("REG_ID"+faqRegId.get("REG_ID"));
			if(!data.containsKey("POP_SEQ") || data.get("POP_SEQ").equals("")){
//				System.out.println("신규등록하면 바로 등록");
				msg = epce8149301Service.epce8149301_update(data, request);
				
			}else{
//				System.out.println("수정하면 열로");
//				System.out.println("작성자"+notiInfo.get(0)).get("REG_ID");
//				System.out.println("세션아이디"+userId);
//				System.out.println("작성자권한"+userInfo.get("ATH_GRP_CD"));
				if(faqRegId.get("REG_ID").equals(userId) || userInfo.get("ATH_GRP_CD").equals("ATC002") ||userInfo.get("ATH_GRP_CD").equals("ATH001")){
//					System.out.println("권한이 있거나, 등록아이디가 같으면 등록 성공");
					msg = epce8149301Service.epce8149301_update(data, request);
				}else{
//					System.out.println("권한이없습니다.");
					errCd = "B003";
				}
			}
			
			
			
//			msg = epce8149301Service.epce8149301_update(data, request);
			if(msg.equals("1")){
				msg = "접속이 종료 되었습니다.\n 로그인 후 다시 사용하시기 바랍니다.";
				url = "/MAIN.do";
			}
			msg = "";
		}catch(Exception e){
			msg = "처리중 오류가 발생 했습니다.";
			//org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		if(!msg.equals(""))ra.addAttribute("message", msg);
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		
		return rtnObj.toString();
	}
	
	/**
	 * 팝업 삭제
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="CE/EPCE8149301_04.do", produces="text/plain;charset=UTF-8")
	@ResponseBody	
	public String epce8149301_delete(@RequestParam HashMap<String, String> map, ModelMap model, HttpServletRequest request) {
		String cd = "";
		try{
			cd = epce8149301Service.epce8149301_delete(request);
		}catch(Exception e){
			cd = "2";
		}
		
		String jsonStr = epce8149301Service.epce8149301_select1(map);
		
		HashMap<String, String> rtnMap = new HashMap<String, String>();
		rtnMap.put("cd", cd);
		rtnMap.put("list", jsonStr);
		
		return util.mapToJson(rtnMap).toString();
	}
	
	/**
	 * 사용여부 변경
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="CE/EPCE8149301_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody	
	public String epce8149301_update3(@RequestParam HashMap<String, String> map, ModelMap model, HttpServletRequest request) {
		String cd = "";
		try{
			cd = epce8149301Service.epce8149301_update3(request);
		}catch(Exception e){
			cd = "2";
		}
		
		String jsonStr = epce8149301Service.epce8149301_select1(map);
		
		HashMap<String, String> rtnMap = new HashMap<String, String>();
		rtnMap.put("cd", cd);
		rtnMap.put("list", jsonStr);
		
		return util.mapToJson(rtnMap).toString();
	}
	

}
