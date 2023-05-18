package egovframework.koraep.mf.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

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
import egovframework.koraep.mf.ep.service.EPMF6652931Service;

/**
 * 출고정보등록 Controller
 * @author pc
 */
@Controller
public class EPMF6652931Controller {
	
	@Resource(name="epmf6652931Service")
	private EPMF6652931Service epmf6652931Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 출고정보등록 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6652931.do", produces="application/text; charset=utf8")
	public String epmf6652931(ModelMap model, HttpServletRequest request)  {
		
		//직매장/공장, 판매처 및 빈용기명 리스트 조회
		model = epmf6652931Service.epmf6652931_select1(model, request);
		
		return "/MF/EPMF6652931";
		
	}
	
	/**
	 * 출고정보 등록
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6652931_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6652931_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epmf6652931Service.epmf6652931_update(data, request);
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
	@RequestMapping(value="/MF/EPMF6652931_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6652931_select2(@RequestParam Map<String, String> data, HttpServletRequest request)  {

		return util.mapToJson(epmf6652931Service.epmf6652931_select2(data, request)).toString();
		
	}
	
	/**
	 * 출고생산자 선택시 직매장/공장 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6652931_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6652931_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		return util.mapToJson(epmf6652931Service.epmf6652931_select3(inputMap, request)).toString();
		
	}
	
	/**
	 * 직매장/공장 선택시 도매업자 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6652931_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6652931_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		return util.mapToJson(epmf6652931Service.epmf6652931_select4(inputMap, request)).toString();
		
	}
	
	/**
	 * 출고정보 그리드 컬럼 선택시
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6652931_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6652931_select5(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf6652931Service.epmf6652931_select5(inputMap, request)).toString();
	}
	
	/**
	 * 출고정보등록 엑셀 업로드 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6652931_195.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPMF6652931_select6(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epmf6652931Service.epmf6652931_select6(inputMap, request)).toString();
	}
	
	/**
	 * 출고일자 변경시 빈용기명 재조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/MF/EPMF6652931_196.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epmf6652931_select7(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		
		return util.mapToJson(epmf6652931Service.epmf6652931_select7(inputMap, request)).toString();
		
	}
	
}
