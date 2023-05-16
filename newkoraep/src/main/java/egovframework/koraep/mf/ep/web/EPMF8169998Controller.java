package egovframework.koraep.mf.ep.web;

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
import egovframework.koraep.mf.ep.service.EPMF8169998Service;

/**
 * FAQ 등록 Controller
 * @author pc
 *
 */
@Controller
public class EPMF8169998Controller {
	
	@Resource(name="epmf8169998Service")
	private EPMF8169998Service epmf8169998Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * FAQ 등록 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8169998.do", produces="application/text; charset=utf8")
	public String epmf8169998(ModelMap model, HttpServletRequest request)  {
		
		String title = commonceService.getMenuTitle("EPMF8169998");	//타이틀
		model.addAttribute("titleSub", title);
		
		//조회 상태유지
		model = epmf8169998Service.epmf8169998(model, request);
		
		return "MF/EPMF8169998";
		
	}
	
	/**
	 * FAQ 수정 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8169942.do", produces="application/text; charset=utf8")
	public String epmf8169942(ModelMap model, HttpServletRequest request)  {
		
		String title = commonceService.getMenuTitle("EPMF8169942");	//타이틀
		model.addAttribute("titleSub", title);
		
		//조회 상태유지
		model = epmf8169998Service.epmf8169998(model, request);
		
		return "MF/EPMF8169998";
		
	}
	
	/**
	 * FAQ 등록
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8169998_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf8169998_update(@RequestParam HashMap<String, String> data, HttpServletRequest request)  {
	
		String errCd = "";
		
		try{
			errCd = epmf8169998Service.epmf8169998_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
		
	}

}
