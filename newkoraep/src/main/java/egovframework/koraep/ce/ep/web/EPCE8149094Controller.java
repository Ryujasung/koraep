package egovframework.koraep.ce.ep.web;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE8149094Service;
import egovframework.mapper.ce.ep.EPCE8149093Mapper;

/**
 * 공지사항 등록 Controller
 * @author pc
 *
 */
@Controller
public class EPCE8149094Controller {
	
	@Resource(name="epce8149093Mapper")
	private EPCE8149093Mapper epce8149093Mapper;
	
	@Resource(name="epce8149094Service")
	private EPCE8149094Service epce8149094Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 공지사항 등록 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8149094.do", produces="application/text; charset=utf8")
	public String epce8149094(ModelMap model, HttpServletRequest request)  {
			
		String title = commonceService.getMenuTitle("EPCE8149094");	//타이틀
		model.addAttribute("titleSub", title);
		
		//조회 상태유지
		model = epce8149094Service.epce8149094(model, request);
		
		return "CE/EPCE8149094";
		
	}
	
	/**
	 * 공지사항 수정 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8149042.do", produces="application/text; charset=utf8")
	public String epce8149042(ModelMap model, HttpServletRequest request)  {
			
		String title = commonceService.getMenuTitle("EPCE8149042");	//타이틀
		model.addAttribute("titleSub", title);
		
		//조회 상태유지
		model = epce8149094Service.epce8149094(model, request);
		
		return "CE/EPCE8149094";
		
	}
	
	/**
	 * 공지사항 등록
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8149094_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce8149094_update(@RequestParam HashMap<String, String> data, HttpServletRequest request)  {
		
		String errCd = "";
		try{
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String userId = vo.getUSER_ID();
		
		//세션값의 권한체크
		Map<String,Object> userInfo = (Map<String, Object>) epce8149093Mapper.getUserInfo(userId);
		//게시글 작성자 조회
		Map<String,Object> notRegId = epce8149093Mapper.notiRegId(data);
		System.out.println("data"+data);
		if(!data.containsKey("NOTI_SEQ") || data.get("NOTI_SEQ").equals("")){
//			System.out.println("신규등록하면 바로 등록");
			errCd = epce8149094Service.epce8149094_update(data, request);
			
		}else{
			if(notRegId.get("REG_ID").equals(userId) || userInfo.get("ATH_GRP_CD").equals("ATC002") ||userInfo.get("ATH_GRP_CD").equals("ATH001")){
//				System.out.println("권한이 있거나, 등록아이디가 같으면 등록 성공");
				errCd = epce8149094Service.epce8149094_update(data, request);
			}else{
//				System.out.println("권한이없습니다.");
				errCd = "B003";
			}
		}
		
		
//		Enumeration<String> params = request.getParameterNames();
//		while(params.hasMoreElements()) {
//			  String name = (String) params.nextElement();
//			  System.out.println(name);
//			  System.out.println(request.getParameter(name));
//			  System.out.println("");
//			}
//		CsrfToken token = (CsrfToken)request.getAttribute("_csrf");
//		
//		System.out.println("token"+token);
//		System.out.println("data"+request.getParameter("token"));
//		System.out.println("request"+request.toString());
//		System.out.println("data"+data.toString());
//		if(request.getParameter("TOKEN").equals(token)){
//			System.out.println("일치");
//			System.out.println(request.getSession().getAttribute("CSRF_TOKEN"));
//		}else{
//			System.out.println("불일치");
//		}

		
			
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		System.out.println("rtnObj"+rtnObj);
		return rtnObj.toString();
	}
	
}
