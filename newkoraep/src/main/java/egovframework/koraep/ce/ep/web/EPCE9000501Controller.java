package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.popbill.api.CloseDownService;
import com.popbill.api.CorpState;

import egovframework.common.CommonProperties;
import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE9000501Service;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


/**
 * 사업자관리 Controller
 * @author 김창순
 *
 */
@Controller
public class EPCE9000501Controller {

	@Resource(name="epce9000501Service")
	private EPCE9000501Service epce9000501Service;

	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	/**
	 * 사업자관리 페이지 호출
	 * @param request
	 * @return
	 * @
	 */

	@RequestMapping(value="/CE/EPCE9000501.do", produces="application/text; charset=utf8")
	public String epce9000501_select(HttpServletRequest request, ModelMap model)  {

		model = epce9000501Service.epce9000501_select(model, request);

		return "/CE/EPCE9000501";

	}

	/**
	 * 무인회수기정보 조회
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE900050119.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000501_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
			
		return util.mapToJson(epce9000501Service.epce9000501_select2(data, request)).toString();

	}
	
	/**
	 * 무인회수기소모품 조회
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE900053219.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000532_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
			
		return util.mapToJson(epce9000501Service.epce9000532_select2(data, request)).toString();

	}
	/**
	 * 사업자관리 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE900053219_05.do")
	@ResponseBody
	public String epce900053219_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			errCd = epce9000501Service.epce900053219_05_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}
	

	/**
	 * 사업자관리 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000501_05.do")
	@ResponseBody
	public String epce9000501_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			errCd = epce9000501Service.epce9000501_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}


	@Value("#{LINKHUB_CONFIG.CorpNum}")
	private String corpNum;

	@Autowired
	private CloseDownService closedownService;

	
	/**
	 * 사업자변경내역 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000501_1.do")
	public String epce900050118(ModelMap model, HttpServletRequest request)  {

		model = epce9000501Service.epce900050118_select(model);

		return "CE/EPCE9000501_1";

	}
	
	/**
	 * 소모품 현황 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000501_3.do")
	public String epce9000501181(ModelMap model, HttpServletRequest request)  {

		model = epce9000501Service.epce900050118_select1(model);

		return "CE/EPCE9000501_3";
	}

	
	/**
	 * 사업자정보 상세조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000516.do", produces="text/plain;charset=UTF-8")
	public String epce9000516(ModelMap model, HttpServletRequest request) {
		model = epce9000501Service.epce9000516_select(model, request);
		return "/CE/EPCE9000516";
	}
	
	/**
	 * 소모품 상세조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000536.do", produces="text/plain;charset=UTF-8")
	public String epce9000536(ModelMap model, HttpServletRequest request) {
		model = epce9000501Service.epce9000536_select(model, request);
		return "/CE/EPCE9000536";
	}
	
	/**
	 * 소모품 상세조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000537.do", produces="text/plain;charset=UTF-8")
	public String epce9000537(ModelMap model, HttpServletRequest request) {
		model = epce9000501Service.epce9000536_select(model, request);
		return "/CE/EPCE9000537";
	}
	
	/*@RequestMapping(value="/CE/EPCE9000538.do", produces="text/plain;charset=UTF-8")
	public String epce9000538(ModelMap model, HttpServletRequest request) {
		model =epce9000501Service.EPCE9000538_select(model, request);
		return "/CE/EPCE9000532";
	}*/
	
	/**
	 * 반환관리  삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000538.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000601_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce9000501Service.EPCE9000538_select(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		return rtnObj.toString();
	}

	/**
	 * 지급제외설정 팝업
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000517.do", produces="text/plain;charset=UTF-8")
	public String epce9000517(ModelMap model, HttpServletRequest request) {
		model = epce9000501Service.epce9000517_select(model, request);
		return "/CE/EPCE9000517";
	}



	/**
	 * 사업자정보 상세조회2
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000516_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000516_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce9000501Service.epce9000516_select2(data)).toString();
	}

	/**
	 * 관리자등록 팝업호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE90005018_1.do", produces="text/plain;charset=UTF-8")
	public String epce90005018_1(ModelMap model, HttpServletRequest request)  {

		model = epce9000501Service.epce90005018_1_select(model, request);

		return "CE/EPCE90005018_1";
	}

	/**
	 * 이동 팝업호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000588.do", produces="text/plain;charset=UTF-8")
	public String epce9000588(ModelMap model, HttpServletRequest request)  {
		model = epce9000501Service.epce9000588(model, request);
		return "CE/EPCE9000588";
	}

	/**
	 * EPCE9000588 저장/수정
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000588_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000588_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce9000501Service.epce9000588_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}

	
	/**
	 *  등록 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000531.do", produces="application/text; charset=utf8")
	public String epce9000531_select(ModelMap model, HttpServletRequest request) {
		
//		model = epce9000531Service.epce9000531_select(model, request);
		//페이지이동 조회조건 파라메터 정보
//		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"), "{}");
//		JSONObject jParams = JSONObject.fromObject(reqParams);
//		model.addAttribute("INQ_PARAMS",jParams);
		model =epce9000501Service.EPCE9000531_select(model, request);
		return "/CE/EPCE9000531";
	}
	
	/**
	 * 소모품현황호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000532.do", produces="application/text; charset=utf8")
	public String epce9000532_select(ModelMap model, HttpServletRequest request) {
		
//		model = epce9000531Service.epce9000531_select(model, request);
		//페이지이동 조회조건 파라메터 정보
//		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"), "{}");
//		JSONObject jParams = JSONObject.fromObject(reqParams);
//		model.addAttribute("INQ_PARAMS",jParams);
		model =epce9000501Service.EPCE9000531_select(model, request);
		return "/CE/EPCE9000532";
	}
	/**
	 * 소모품등록페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000533.do", produces="application/text; charset=utf8")
	public String epce9000533_select(ModelMap model, HttpServletRequest request) {
		
//		model = epce9000531Service.epce9000531_select(model, request);
		//페이지이동 조회조건 파라메터 정보
//		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"), "{}");
//		JSONObject jParams = JSONObject.fromObject(reqParams);
//		model.addAttribute("INQ_PARAMS",jParams);
		model =epce9000501Service.EPCE9000533_select(model, request);
		return "/CE/EPCE9000533";
	}
	/**
	 * 무인회수기  수정
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000542_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000531_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			
			
			errCd = epce9000501Service.epce9000531_update(data, request);
			
			
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 무인회수기소모품  수정
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000537_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000537_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			
			
			errCd = epce9000501Service.epce9000537_update(data, request);
			
			
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	/**
	 * 무인회수기  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000531_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000531_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce9000501Service.epce9000531_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 무인회수기  소모품저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000533_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000533_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce9000501Service.epce9000533_insert(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 무인회수기 시리얼번호 중복체크
	 * @param param
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/SERIAL_NO_CHECK.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String serialNoCheck(@RequestParam HashMap<String, String> param, ModelMap model, HttpServletRequest request) {
		String ableYn = epce9000501Service.serialNoCheck(param);
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("USE_ABLE_YN", ableYn);
		
		return util.mapToJson(map).toString();
	}
	
	/**
	 * 무인회수기 시리얼번호 중복체크
	 * @param param
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/URMCODE_NO_CHECK.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String urmcodeNoCheck(@RequestParam HashMap<String, String> param, ModelMap model, HttpServletRequest request) {
		String ableYn = epce9000501Service.urmcodeNoCheck(param);
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("USE_URM_CODE_YN", ableYn);
		
		return util.mapToJson(map).toString();
	}
	
	/**
	 * 무인회수기 센터고유넘버 중복체크
	 * @param param
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/URM_CE_NO_CHECK.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String urmCeNoCheck(@RequestParam HashMap<String, String> param, ModelMap model, HttpServletRequest request) {
		String urm_ce_no = epce9000501Service.urmCeNoCheck(param);
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("URM_CE_NO", urm_ce_no);
		
		return util.mapToJson(map).toString();
	}
		
		/**
		 * 사업자관리 활동/비활동처리
		 * @param data
		 * @param request
		 * @return
		 * @
		 */
		@RequestMapping(value="/CE/EPCE900050142.do", produces="application/text; charset=utf8")
		@ResponseBody
		public String epce900050142_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

			String errCd = "";

			try{
					errCd = epce9000501Service.epce900050142_update(data, request); //회원복원

			}catch(Exception e){
				errCd = e.getMessage();
			}

			JSONObject rtnObj = new JSONObject();
			rtnObj.put("RSLT_CD", errCd);
			rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

			return rtnObj.toString();
		}
		
		/**
		 * 사업자변경내역 목록조회
		 * @param data
		 * @param request
		 * @return
		 * @
		 */
		@RequestMapping(value="/CE/EPCE9000501_2.do", produces="text/plain;charset=UTF-8")
		@ResponseBody
		public String epce9000501_2_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request)  {
			return util.mapToJson(epce9000501Service.epce9000501_2_select(data)).toString();
		}
		
		@RequestMapping(value="/CE/EPCE9000501_4.do", produces="text/plain;charset=UTF-8")
		@ResponseBody
		public String epce9000501_4_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request)  {
			return util.mapToJson(epce9000501Service.epce9000501_2_select(data)).toString();
		}

		/**
		 * 사업자정보변경
		 * @param model
		 * @param request
		 * @return
		 * @
		 */
		@RequestMapping(value="/CE/EPCE9000542.do", produces="application/text; charset=utf8")
		public String epce9000542(ModelMap model, HttpServletRequest request) {
			
			model = epce9000501Service.epce9000542_select(model, request);
			
			return "/CE/EPCE9000542";
		}
		

}

