package egovframework.koraep.mf.ep.web;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.mf.ep.service.EPMF6624501Service;

/**
 * 교환관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPMF6624501Controller {

	
	@Resource(name="epmf6624501Service")
	private EPMF6624501Service epmf6624501Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 교환관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6624501.do")
	public String epmf6624501(ModelMap model, HttpServletRequest request) {
		
		if(request.getParameter("EXCH_REQ_DOC_NO") != null){ //상세조회 바로이동
			model.addAttribute("EXCH_REQ_DOC_NO", request.getParameter("EXCH_REQ_DOC_NO").toString());
		}
		
		model = epmf6624501Service.epmf6624501_select(model, request);
		
		return "/MF/EPMF6624501";
	}
	
	/**
	 * 교환상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6624564.do")
	public String epmf6624564(ModelMap model, HttpServletRequest request) {
		
		model = epmf6624501Service.epmf6624564_select(model, request);
		
		return "/MF/EPMF6624564";
	}
	
	/**
	 * 교환변경 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6624542.do")
	public String epmf6624542(ModelMap model, HttpServletRequest request) {
		
		model = epmf6624501Service.epmf6624542_select(model, request);
		
		return "/MF/EPMF6624542";
	}
	
	/**
	 * 교환확인취소
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6624564_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf6624564_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			
			data.put("PRE_EXCH_STAT_CD", "CC");
			data.put("EXCH_STAT_CD", "RG");
			
			errCd = epmf6624501Service.epmf6624564_update(data, request); 
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 교환확인
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6624564_212.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf6624564_update2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			
			data.put("PRE_EXCH_STAT_CD", "RG");
			data.put("EXCH_STAT_CD", "CC");
			
			errCd = epmf6624501Service.epmf6624564_update(data, request); 
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 교환관리 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */ 
	@RequestMapping(value="/MF/EPMF6624501_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf6624501_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epmf6624501Service.epmf6624501_select2(data, request)).toString();
	}
	
	/**
	 * 교환삭제 
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6624501_04.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf6624501_delete(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf6624501Service.epmf6624501_delete(data, request); 
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 교환등록 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6624531.do")
	public String epmf6624531(ModelMap model, HttpServletRequest request) {
		
		model = epmf6624501Service.epmf6624531_select(model, request);
		
		return "/MF/EPMF6624531";
	}
	
	/**
	 * 교환관리 데이터 체크
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6624531_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf6624531_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "0000";
		JSONObject rtnObj = new JSONObject();
		
		try{
			//중복체크 필요없음..
			//errCd = epmf6624501Service.epmf6624531_select(data, request);
			
			//빈용기 정보
			List<?> list = epmf6624501Service.epmf6624531_select2(data);
			rtnObj.put("CTNR_INFO", util.mapToJson(list).toString());
			
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		rtnObj.put("RSLT_CD", errCd);
		if(!errCd.equals("0000")){
			rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		}else{
			rtnObj.put("RSLT_MSG","");
		}
		
		return rtnObj.toString();
	}
	
	/**
	 * 교환 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6624531_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf6624531_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf6624501Service.epmf6624531_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}  
	
	/**
	 * 교환 변경
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6624542_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf6624542_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf6624501Service.epmf6624542_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}  
	
	/**
	 * 교환관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6624501_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epmf6624501_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf6624501Service.epmf6624501_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
}
