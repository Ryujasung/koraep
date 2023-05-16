package egovframework.koraep.wh.ep.web;

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
import egovframework.koraep.wh.ep.service.EPWH8149094Service;

/**
 * 공지사항 등록 Controller
 * @author pc
 *
 */
@Controller
public class EPWH8149094Controller {
	
	@Resource(name="epwh8149094Service")
	private EPWH8149094Service epwh8149094Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 공지사항 등록 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8149094.do", produces="application/text; charset=utf8")
	public String epwh8149094(ModelMap model, HttpServletRequest request)  {
			
		String title = commonceService.getMenuTitle("EPWH8149094");	//타이틀
		model.addAttribute("titleSub", title);
		
		//조회 상태유지
		model = epwh8149094Service.epwh8149094(model, request);
		
		return "/WH/EPWH8149094";
		
	}
	
	/**
	 * 공지사항 수정 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8149042.do", produces="application/text; charset=utf8")
	public String epwh8149042(ModelMap model, HttpServletRequest request)  {
			
		String title = commonceService.getMenuTitle("EPWH8149042");	//타이틀
		model.addAttribute("titleSub", title);
		
		//조회 상태유지
		model = epwh8149094Service.epwh8149094(model, request);
		
		return "/WH/EPWH8149094";
		
	}
	
	/**
	 * 공지사항 등록
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8149094_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh8149094_update(@RequestParam HashMap<String, String> data, HttpServletRequest request)  {

		String errCd = "";
		
		try{
			errCd = epwh8149094Service.epwh8149094_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
}
