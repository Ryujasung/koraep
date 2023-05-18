package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
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
import egovframework.koraep.ce.ep.service.EPCE6658201Service;

/**
 * 출고정보조회 Controller
 * @author pc
 *
 */
@Controller
public class EPCE6658201Controller {
	
	@Resource(name="epce6658201Service")
	private EPCE6658201Service epce6658201Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 출고정보조회 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6658201.do", produces="application/text; charset=utf8")
	public String epce6658201(ModelMap model, HttpServletRequest request)  {
		
		//출고등록상태, 생산자 및 직매장/공장 리스트 조회
		model = epce6658201Service.epce6658201_select1(model, request);
		
		return "CE/EPCE6658201";
		
	}
	
	/**
	 * 출고정보 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6658201_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6658201_select(@RequestParam Map<String, String> data, HttpServletRequest request)  {
		return util.mapToJson(epce6658201Service.epce6658201_select2(data, request)).toString();
		
	}
	
	
	/**
	 * 직매장별거래처관리  직매장/공장 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6658201_191.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6658201_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce6658201Service.epce6658201_select3(data, request)).toString();
	}
	
	/**
	 * 출고정보 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE66582641.do", produces = "application/text; charset=utf8")
	public String epce6658201_select3(HttpServletRequest request, ModelMap model) {

		model = epce6658201Service.epce6658201_select4(model, request);
		
		return "/CE/EPCE66582641";
	}
	
	/**
	 * 출고정보 상세 페이지 호출 (링크)
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE66582642.do", produces = "application/text; charset=utf8")
	public String epce66582642_select(HttpServletRequest request, ModelMap model) {

		model = epce6658201Service.epce66582642_select(model, request);
		
		return "/CE/EPCE66582642";
	}

	/**
	 * 출고정보 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6658201_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce6658201_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		
		try{
			errCd = epce6658201Service.epce6658201_delete(inputMap, request);
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
	 * 출고정보 상세 페이지 엑셀저장
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE66582641_05.do", produces = "application/text; charset=utf8")
	@ResponseBody
	public String epce6658201_select4(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epce6658201Service.epce66582641_excel(data, request);
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
	 * 출고관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE6658201_05.do")
	@ResponseBody
	public String epce6658201_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce6658201Service.epce6658201_excel(data, request);
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
