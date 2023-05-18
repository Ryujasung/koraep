package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.sql.SQLException;
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

import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE8169998Service;
import egovframework.mapper.ce.ep.EPCE8149093Mapper;

/**
 * FAQ 등록 Controller
 * @author pc
 *
 */
@Controller
public class EPCE8169998Controller {
	
	
	@Resource(name="epce8149093Mapper")
	private EPCE8149093Mapper epce8149093Mapper;
	
	@Resource(name="epce8169998Service")
	private EPCE8169998Service epce8169998Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * FAQ 등록 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8169998.do", produces="application/text; charset=utf8")
	public String epce8169998(ModelMap model, HttpServletRequest request)  {
		
		String title = commonceService.getMenuTitle("EPCE8169998");	//타이틀
		model.addAttribute("titleSub", title);
		
		//조회 상태유지
		model = epce8169998Service.epce8169998(model, request);
		
		return "CE/EPCE8169998";
		
	}
	
	/**
	 * FAQ 수정 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8169942.do", produces="application/text; charset=utf8")
	public String epce8169942(ModelMap model, HttpServletRequest request)  {
		
		String title = commonceService.getMenuTitle("EPCE8169942");	//타이틀
		model.addAttribute("titleSub", title);
		
		//조회 상태유지
		model = epce8169998Service.epce8169998(model, request);
		
		return "CE/EPCE8169998";
		
	}
	
	/**
	 * FAQ 등록
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8169998_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce8169998_update(@RequestParam HashMap<String, String> data, HttpServletRequest request)  {
	
		String errCd = "";
		
		try{
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String userId = vo.getUSER_ID();
			//세션값의 권한체크
			Map<String,Object> userInfo = (Map<String, Object>) epce8149093Mapper.getUserInfo(userId);
			//게시글 작성자 조회
			Map<String,Object> faqRegId = epce8169998Service.faqRegId(data);
			if(!data.containsKey("FAQ_SEQ") || data.get("FAQ_SEQ").equals("")){
				errCd = epce8169998Service.epce8169998_update(data, request);
				
			}else{
				if(faqRegId.get("REG_ID").equals(userId) || userInfo.get("ATH_GRP_CD").equals("ATC002") ||userInfo.get("ATH_GRP_CD").equals("ATH001")){
					errCd = epce8169998Service.epce8169998_update(data, request);
				}else{
					errCd = "B003";
				}
			}
			
			
			
			
			
			
//			errCd = epce8169998Service.epce8169998_update(data, request);
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
