package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE4707201Service;
import net.sf.json.JSONObject;

/**
 * 정산서조회 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE4707201Controller {

	@Resource(name="epce4707201Service")
	private EPCE4707201Service epce4707201Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;//공통 service

	/**
	 * 정산서조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707201.do")
	public String epce4707201(ModelMap model, HttpServletRequest request) {
		model = epce4707201Service.epce4707201_select(model, request);
		return "/CE/EPCE4707201";
	}

	/**
	 * 정산서 상세조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707264.do")
	public String epce4707264(ModelMap model, HttpServletRequest request) {
		model = epce4707201Service.epce4707264_select(model, request);
		return "/CE/EPCE4707264";
	}

	/**
	 * 정산서조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707201_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0101801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4707201Service.epce4707201_select2(data)).toString();
	}
	
	/**
	 * 정산서 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707201_05.do")
	@ResponseBody
	public String epce2393001_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce4707201Service.epce4707201_excel(data, request);
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}	

	/**
	 * 정산서발급취소
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707201_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4707201_update(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = epce4707201Service.epce4707201_update(data, request);
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			System.out.println(e.toString());
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();

	}

	/**
	 * 수기정산서발급취소
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707264_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4707264_update2(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = epce4707201Service.epce4707201_update2(data, request);
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
	 * 수납확인내역 상세조회팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707288.do", produces="application/text; charset=utf8")
	public String epce2308888(ModelMap model, HttpServletRequest request) {
		String title = commonceService.getMenuTitle("EPCE4707288");
		model.addAttribute("titleSub", title);

		return "/CE/EPCE4707288";
	}

	/**
	 * 수납확인 상세조회 (정산서)
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707288_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2308888_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4707201Service.epce4707288_select(data)).toString();
	}

	/**
	 * 수납확인 상세조회 (수납내역)
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707288_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce2308888_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4707201Service.epce4707288_select2(data)).toString();
	}

	/**
	 * 재고지 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE47072882.do")
	public String epce47072882(ModelMap model, HttpServletRequest request) {
		model = epce4707201Service.epce47072882_select(model, request);
		return "/CE/EPCE47072882";
	}

	/**
	 * 재고지 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE47072882_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce47072882_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = epce4707201Service.epce47072882_update(data, request);
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
	 * 정산서발급취소 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE47072883.do")
	public String epce47072883(ModelMap model, HttpServletRequest request) {
		model = epce4707201Service.epce47072883_select(model, request);

		return "/CE/EPCE47072883";
	}

	/**
	 * 정산서발급취소 생산자 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE47072883_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce01018883_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce4707201Service.epce47072883_select2(data)).toString();
	}

	/**
	 * 정산서 재고지 취소
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE4707264_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce4707264_update(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = epce4707201Service.epce4707264_update(data, request);
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
