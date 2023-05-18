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
import egovframework.koraep.ce.ep.service.EPCE9000101Service;
import net.sf.json.JSONObject;


/**
 * 회수정보관리
 * @author 양성수
 *
 */
@Controller
public class EPCE9000101Controller {

	@Resource(name = "EPCE9000101Service")
	private  EPCE9000101Service EPCE9000101Service;//회수정보관리 service

	@Resource(name = "commonceService")
	private CommonCeService commonceService;//공통  service

	/**
	 * 회수정보관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
//	public String EPCE9000131_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
//
//		String errCd = "";
//
//		try{
//			errCd = EPCE9000101Service.EPCE9000131_insert(data, request);
	@RequestMapping(value = "/CE/EPCE9000101.do", produces = "application/text; charset=utf8")
	public String EPCE9000101(HttpServletRequest request, ModelMap model) {
		model =EPCE9000101Service.EPCE9000101_select(model, request);
		return "/CE/EPCE9000101";
	}
	
	/**
	 * 회수정보관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000101_2.do", produces = "application/text; charset=utf8")
	public String EPCE9000101_2(HttpServletRequest request, ModelMap model) {
		EPCE9000101Service.EPCE9000101_add(model, request);
		
		model =EPCE9000101Service.EPCE9000101_select(model, request);
		
		return "/CE/EPCE9000101";
	}
	
	/**
	 * 회수정보관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000101_3.do", produces = "application/text; charset=utf8")
	public String EPCE9000101_3(HttpServletRequest request, ModelMap model) {
		EPCE9000101Service.EPCE9000101_del(model, request);
		
		model =EPCE9000101Service.EPCE9000101_select(model, request);
		return "/CE/EPCE9000101";
	}

	/**
	 *  회수정보관리 업체명조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000101_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE9000101_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(EPCE9000101Service.EPCE9000101_select2(inputMap, request)).toString();
	}

	/**
	 * 회수정보관리 지점조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000101_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE9000101_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(EPCE9000101Service.EPCE9000101_select3(inputMap, request)).toString();
	}

	/**
	 * 회수정보관리  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000101_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE9000101_select4(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(EPCE9000101Service.EPCE9000101_select4(inputMap, request)).toString();
	}

	/**
	 * 회수정보관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000101_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6624501_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";
		try{
			errCd = EPCE9000101Service.EPCE9000101_excel(data, request);
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
	 * 회수정보관리  삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000101_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE9000101_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = EPCE9000101Service.EPCE9000101_delete(inputMap, request);
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
	 * 회수정보관리  회수등록일괄확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000101_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE9000101_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = EPCE9000101Service.EPCE9000101_update(inputMap, request);
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

	/***********************************************************************************************************************************************
	*	회수정보 상세조회
	************************************************************************************************************************************************/

	/**
	 * 회수정보관리 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000164.do", produces = "application/text; charset=utf8")
	public String EPCE9000164(HttpServletRequest request, ModelMap model) {

		model =EPCE9000101Service.EPCE9000164_select(model, request);
		return "/CE/EPCE9000164";
	}

	/***********************************************************************************************************************************************
	*	회수정보 등록
	************************************************************************************************************************************************/
	/**
	 * 회수정보 등록
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000131.do", produces = "application/text; charset=utf8")
	public String EPCE9000131(HttpServletRequest request, ModelMap model) {
		model =EPCE9000101Service.EPCE9000131_select(model, request);
		return "/CE/EPCE9000131";
	}

	/**
	 *  회수정보등록도매업자 변경시    지점 & 보증금,수수료 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000131_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE9000131_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(EPCE9000101Service.EPCE9000131_select2(inputMap, request)).toString();
	}

	/**
	 * 회수정보등록 날짜 변경시 보증금,수수료조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000131_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE9000131_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(EPCE9000101Service.EPCE9000131_select3(inputMap, request)).toString();
	}

	/**
	 * 회수정보등록 엑셀업로드 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000131_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE9000131_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(EPCE9000101Service.EPCE9000131_select4(inputMap, request)).toString();
	}

	/**
	 * 소매업자
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000131_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2925831_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(EPCE9000101Service.EPCE9000131_select5(inputMap, request)).toString();
	}

	/**
	 * 회수정보등록  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000131_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String EPCE9000131_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			errCd = EPCE9000101Service.EPCE9000131_insert(data, request);

		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
			/*e.printStackTrace();*/
			//취약점점검 6297 기원우
			//if(data.get("ERR_CTNR_NM") !=null){
			//	System.out.println(data.get("ERR_CTNR_NM").toString());
			//}
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		if(data.get("ERR_CTNR_NM") !=null){
			rtnObj.put("ERR_CTNR_NM", data.get("ERR_CTNR_NM").toString());
		}

		return rtnObj.toString();
	}




	/***********************************************************************************************************************************************
	*	회수정보 변경
	************************************************************************************************************************************************/
	/**
	 * 회수정보 변경
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000142.do", produces = "application/text; charset=utf8")
	public String EPCE9000142(HttpServletRequest request, ModelMap model) {
		model = EPCE9000101Service.EPCE9000142_select(model, request);
		return "/CE/EPCE9000142";
	}

	/**
	 * 회수정보수정  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000142_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String EPCE9000142_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			errCd = EPCE9000101Service.EPCE9000142_update(data, request);
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
			//if(data.get("ERR_CTNR_NM") !=null){
			//	System.out.println(data.get("ERR_CTNR_NM").toString());
			//}
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		if(data.get("ERR_CTNR_NM") !=null){
			rtnObj.put("ERR_CTNR_NM", data.get("ERR_CTNR_NM").toString());
		}

		return rtnObj.toString();
	}

	/***********************************************************************************************************************************************
	*	회수조정
	************************************************************************************************************************************************/
	/**
	 * 회수조정
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE90001422.do", produces = "application/text; charset=utf8")
	public String EPCE90001422(HttpServletRequest request, ModelMap model) {
		model = EPCE9000101Service.EPCE90001422_select(model, request);
		return "/CE/EPCE90001422";
	}

	/***********************************************************************************************************************************************
	*	회수증빙자료관리
	************************************************************************************************************************************************/
	/**
	 * 회수증빙자료관리
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000197.do", produces = "application/text; charset=utf8")
	public String EPCE9000197(HttpServletRequest request, ModelMap model) {
		model = EPCE9000101Service.EPCE9000197_select(model, request);
		return "/CE/EPCE9000197";
	}

	/**
	 * 회수정보관리  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000197_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE9000197_select(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(EPCE9000101Service.EPCE9000197_select2(inputMap, request)).toString();
	}

	/**
	 * 회수증빙관리 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000197_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE9000197_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {

		String errCd = "";
		try{
			errCd = EPCE9000101Service.EPCE9000197_delete(inputMap, request);
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

	/***********************************************************************************************************************************************
	*	회수증빙자료등록
	************************************************************************************************************************************************/
	/**
	 * 회수증빙자료등록
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000188.do", produces = "application/text; charset=utf8")
	public String EPCE9000188(HttpServletRequest request, ModelMap model) {
		model = EPCE9000101Service.EPCE9000188_select(model, request);
		return "/CE/EPCE9000188";
	}

	/**
	 * 회수증빙자료등록  등록
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000188_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String EPCE9000188_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {

		String errCd = "";
		try{
			errCd = EPCE9000101Service.EPCE9000188_insert(inputMap, request);
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

	/***********************************************************************************************************************************************
	*	회수증빙자료다운로드
	************************************************************************************************************************************************/
	/**
	 * 회수증빙자료다운로드
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE90001882.do", produces = "application/text; charset=utf8")
	public String EPCE90001882(@RequestParam Map<String, Object> param,HttpServletRequest request, ModelMap model) {
		model = EPCE9000101Service.EPCE90001882_select(param,model, request);
		return "/CE/EPCE90001882";
	}

}
