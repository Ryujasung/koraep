
package egovframework.koraep.mf.ep.web;

import java.io.IOException;
import java.sql.SQLException;
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

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.mf.ep.service.EPMF6658242Service;

/**
 * 출고정보변경 Controller
 * @author pc
 */
@Controller
public class EPMF6658242Controller {
	
	private static final Logger log = LoggerFactory.getLogger(EPMF6658242Controller.class);
	
	@Resource(name="epmf6658242Service")
	private EPMF6658242Service epmf6658242Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 출고정보변경 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6658242.do", produces="application/text; charset=utf8")
	public String epmf6658242(ModelMap model, HttpServletRequest request)  {
		
		//직매장/공장, 판매처 및 빈용기명 리스트 조회
		model = epmf6658242Service.epmf6658242_select1(model, request);
		
		return "/MF/EPMF6658242";
		
	}
	
	/**
	 * 출고정보변경 저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6658242_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6658242_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epmf6658242Service.epmf6658242_update(data, request);
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
	
	/**
	 * 생산자별 빈용기명 콤보박스 목록조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6658242_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6658242_select2(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		return util.mapToJson(epmf6658242Service.epmf6658242_select2(data, request)).toString();
		
	}
	
	
	/**
	 * 직매장/공장 선택시 도매업자 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6658242_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6652931_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		return util.mapToJson(epmf6658242Service.epmf6658242_select3(inputMap, request)).toString();
		
	}
	
	/**
	 * 출고변경 그리드 컬럼 선택시
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6658242_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6658242_select6(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf6658242Service.epmf6658242_select4(inputMap, request)).toString();
	}
	
	/**
	 * 출고정보 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6658242_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6658242_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epmf6658242Service.epmf6658242_delete(inputMap, request);
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
