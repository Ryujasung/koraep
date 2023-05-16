package egovframework.koraep.mf.ep.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.mf.ep.service.EPMF8126695Service;

/**
 * 문의/답변상세조회 Controller
 * @author pc
 *
 */
@Controller
public class EPMF8126695Controller {
	
	private static final Logger log = LoggerFactory.getLogger(EPMF8126695Controller.class);
	
	@Resource(name="epmf8126695Service")
	private EPMF8126695Service epmf8126695Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	/**
	 * 문의/답변 상세조회 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8126695.do", produces="application/text; charset=utf8")
	public String epmf8126695(ModelMap model, HttpServletRequest request)  {
		
		try {
			//문의/답변 상세, 답변글 리스트 조회
			model = epmf8126695Service.epmf8126695(model, request);

		} catch (Exception e) {
			String errCd = e.getMessage();
			
			//페이지이동 조회조건 파라메터 정보
			String reqParams = request.getParameter("INQ_PARAMS");
			if(reqParams==null || reqParams.equals("")) reqParams = "{}";
			JSONObject jParams = JSONObject.fromObject(reqParams);

			model.addAttribute("INQ_PARAMS",jParams);
			model.addAttribute("askInfo", "{}");
			model.addAttribute("ansrInfo","{}");
			model.addAttribute("RSLT_CD", errCd);
			model.addAttribute("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		}
		
		//문의/답변 상세, 답변글 리스트 조회
		
		return "MF/EPMF8126695";
		
	}
	
	/**
	 * 문의/답변 삭제
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF8126695_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf8126695_delete(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		
		return Integer.toString(epmf8126695Service.epmf8126695_delete(data, request));
		
	}

}
