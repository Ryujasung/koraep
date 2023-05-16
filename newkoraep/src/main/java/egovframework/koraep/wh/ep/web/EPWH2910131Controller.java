package egovframework.koraep.wh.ep.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.wh.ep.service.EPWH2910131Service;


/**
 * 반환관리
 * @author 양성수
 *
 */
@Controller
public class EPWH2910131Controller {  

	@Resource(name = "epwh2910131Service")
	private  EPWH2910131Service epwh2910131Service; 	//반환관리 service
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	
	/**
	 * 반환관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/WH/EPWH2910131.do", produces = "application/text; charset=utf8")
	public String epwh2910131(HttpServletRequest request, ModelMap model) {

		model =epwh2910131Service.epwh2910131_select(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
			return "/WH/EPWH2910131";
		}else{ //모바일
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";
			
			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
				model.addAttribute("userInfo", ssUserInfo); //사용자
				model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
				model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdList(vo))); //메뉴
			}
			
			return "/WH_M/EPWH2910131";
		}
	}
	
	/**
	 *  반환내역서등록 도매업자구분 선택시 업체명
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910131_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910131_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2910131Service.epwh2910131_select2(inputMap, request)).toString();
	}	
	
	/**
	 * 반환내역서등록 업체명 선택시 지점 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910131_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910131_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2910131Service.epwh2910131_select3(inputMap, request)).toString();
	}	
	
	/**
	 * 반환내역서등록 지점 선택시 반환대상 생산자
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910131_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910131_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2910131Service.epwh2910131_select4(inputMap, request)).toString();
	}	
	
	/**
	 * 반환내역서등록 반환대상생산자 선택시 직매장/공장 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910131_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910131_select4(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2910131Service.epwh2910131_select5(inputMap, request)).toString();
	}	

	/**
	 * 반환내역서등록 빈용기구분 선택시 빈용기명조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910131_195.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910131_select5(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2910131Service.epwh2910131_select6(inputMap, request)).toString();
	}	
	
	/**
	 * 반환내역서등록 그리드 컬럼 선택시
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910131_196.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910131_select6(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2910131Service.epwh2910131_select7(inputMap, request)).toString();
	}	
	
	/**
	 * 반환내역서등록 엑셀 업로드 후처리
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910131_197.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910131_select7(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2910131Service.epwh2910131_select8(inputMap, request)).toString();
	}	
	
	/**
	 * 빈용기구분 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910131_198.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh2910131_select8(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epwh2910131Service.epwh2910131_select9(inputMap, request)).toString();
	}	
	
	/**
	 * 반환내역서등록  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH2910131_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh2910131_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epwh2910131Service.epwh2910131_insert(data, request);
			
		}catch(Exception e){
			errCd = e.getMessage();
			if(data.get("ERR_CTNR_NM") !=null){
				//System.out.println(data.get("ERR_CTNR_NM").toString());
			}
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		
		if(errCd.charAt(0) == 'D' || errCd.charAt(0) == 'R') {
			String[] rtnArr = errCd.split("_");
			String rtnMsg = "";
			
			if("D".equals(rtnArr[0])) {
				rtnMsg = rtnArr[1] + "용기의 출고 대비 반환 등록 가능 수량이 부족합니다.\n등록 가능 수량 내에서만 등록 가능합니다.(등록 가능 수량 : "+rtnArr[2] +")";
			}
			else if("R".equals(rtnArr[0])) {
				rtnMsg = rtnArr[1] + "용기의 회수 대비 반환 등록 가능 수량이 부족합니다.\n등록 가능 수량 내에서만 등록 가능합니다.(등록 가능 수량 : "+rtnArr[2] +")";
			}
			
			rtnObj.put("RSLT_CD", "E099");
			rtnObj.put("RSLT_MSG", rtnMsg);
			rtnObj.put("ERR_CTNR_NM", rtnMsg);
		}
		else {
			rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

			if(data.get("ERR_CTNR_NM") !=null){
				rtnObj.put("ERR_CTNR_NM", data.get("ERR_CTNR_NM").toString());
			}
		}
		
		return rtnObj.toString();
	}
}
