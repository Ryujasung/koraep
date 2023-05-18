package egovframework.koraep.mf.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.mf.ep.service.EPMF8149094Service;

/**
 * 공지사항 등록 Controller
 * @author pc
 *
 */
@Controller
public class EPMF8149094Controller {
	
	@Resource(name="epmf8149094Service")
	private EPMF8149094Service epmf8149094Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 공지사항 등록 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8149094.do", produces="application/text; charset=utf8")
	public String epmf8149094(ModelMap model, HttpServletRequest request)  {
			
		String title = commonceService.getMenuTitle("EPMF8149094");	//타이틀
		model.addAttribute("titleSub", title);
		
		//조회 상태유지
		model = epmf8149094Service.epmf8149094(model, request);
		
		return "MF/EPMF8149094";
		
	}
	
	/**
	 * 공지사항 수정 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8149042.do", produces="application/text; charset=utf8")
	public String epmf8149042(ModelMap model, HttpServletRequest request)  {
			
		String title = commonceService.getMenuTitle("EPMF8149042");	//타이틀
		model.addAttribute("titleSub", title);
		
		//조회 상태유지
		model = epmf8149094Service.epmf8149094(model, request);
		
		return "MF/EPMF8149094";
		
	}
	
	/**
	 * 공지사항 등록
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8149094_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf8149094_update(@RequestParam HashMap<String, String> data, HttpServletRequest request)  {

		String errCd = "";
		
		try{
			errCd = epmf8149094Service.epmf8149094_update(data, request);
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
