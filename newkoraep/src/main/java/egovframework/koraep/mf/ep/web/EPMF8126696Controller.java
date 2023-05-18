package egovframework.koraep.mf.ep.web;

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
import egovframework.koraep.ce.ep.service.EPCE8126696Service;
import egovframework.koraep.mf.ep.service.EPMF8126696Service;
import egovframework.mapper.ce.ep.EPCE8149093Mapper;

/**
 * 문의/답변 등록 Controller
 * @author pc
 *
 */
@Controller
public class EPMF8126696Controller {
	
	@Resource(name="epce8149093Mapper")
	private EPCE8149093Mapper epce8149093Mapper;
	
	@Resource(name="epce8126696Service")
	private EPCE8126696Service epce8126696Service;
	
	@Resource(name="epmf8126696Service")
	private EPMF8126696Service epmf8126696Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 문의/답변 등록 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8126696.do", produces="application/text; charset=utf8")
	public String epmf8126696(ModelMap model, HttpServletRequest request)  {
		
		String title = commonceService.getMenuTitle("EPMF8126696");	//타이틀
		model.addAttribute("titleSub", title);
		
		//조회 상태유지
		model = epmf8126696Service.epmf8126696(model, request);
		
		return "MF/EPMF8126696";
		
	}
	
	/**
	 * 문의/답변 수정 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8126642.do", produces="application/text; charset=utf8")
	public String epmf8126642(ModelMap model, HttpServletRequest request)  {
		
		String title = commonceService.getMenuTitle("EPMF8126642");	//타이틀
		model.addAttribute("titleSub", title);
		
		//조회 상태유지
		model = epmf8126696Service.epmf8126696(model, request);
		
		return "MF/EPMF8126696";
		
	}
	
	/**
	 * 문의/답변 등록
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8126696_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf8126696_update(@RequestParam HashMap<String, String> data, HttpServletRequest request)  {

		String errCd = "";
		
		try{
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String userId = vo.getUSER_ID();
			//세션id의 권한체크
			Map<String,Object> userInfo = (Map<String, Object>) epce8149093Mapper.getUserInfo(userId);
			//게시글 작성자 조회
			Map<String,Object> ansRegId = epce8126696Service.ansRegId(data);
			if(!data.containsKey("ASK_SEQ") || data.get("ASK_SEQ").equals("")){
				errCd = epmf8126696Service.epmf8126696_update(data, request);
				
			}else{
				if(ansRegId.get("REG_ID").equals(userId)){
					errCd = epmf8126696Service.epmf8126696_update(data, request);
				}else{
					errCd = "B003";
				}
			}
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
