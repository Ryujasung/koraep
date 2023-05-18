package egovframework.koraep.wh.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.popbill.api.CloseDownService;
import com.popbill.api.CorpState;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.wh.ep.service.EPWH9000201Service;


/**
 * 사업자관리 Controller
 * @author 김창순
 *
 */
@Controller
public class EPWH9000201Controller {

	@Resource(name="epwh9000201Service")
	private EPWH9000201Service epwh9000201Service;

	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	/**
	 * 사업자관리 페이지 호출
	 * @param request
	 * @return
	 * @
	 */

	@RequestMapping(value="/WH/EPWH9000201.do", produces="application/text; charset=utf8")
	public String epwh9000201_select(HttpServletRequest request, ModelMap model)  {

		model = epwh9000201Service.epwh9000201_select(model, request);

		// 모바일 체크
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){
			return "/WH/EPWH9000201";
		}else{
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";
			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
			}
			model.addAttribute("userInfo", ssUserInfo); //사용자
			model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
			model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdList(vo))); //메뉴

			return "/WH_M/EPWH9000201";		
		}
	}

	/**
	 * 사업자관리 조회
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH900020119.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh9000201_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		return util.mapToJson(epwh9000201Service.epwh9000201_select2(data, request)).toString();

	}

	/**
	 * 사업자관리 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9000201_05.do")
	@ResponseBody
	public String epwh9000201_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			errCd = epwh9000201Service.epwh9000201_excel(data, request);
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


	@Value("#{LINKHUB_CONFIG.CorpNum}")
	private String corpNum;

	@Autowired
	private CloseDownService closedownService;

	/**
	 * 사업자관리 휴폐업조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9000201422.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh900020142_update2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "0000";
		String errMsg = "";
		String sUserId = "";

		try{

			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			if(vo != null){
				sUserId = vo.getUSER_ID();
			}

			List<?> list = JSONArray.fromObject(data.get("list"));

			if(list != null && list.size() > 0){

				String[] corpNumList = new String[list.size()];
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = (Map<String, String>)list.get(i);
					corpNumList[i] = map.get("BIZRNO_DE");
		    	}

				// 조회할 사업자번호 배열, 최대 1000건
				CorpState[] corpStates = closedownService.CheckCorpNum(corpNum, corpNumList);

				for(int i=0; i<corpStates.length; i++){
					Map<String, String> map = new HashMap<String, String>();
					map.put("BIZRNO", corpStates[i].getCorpNum());
					map.put("RUN_STAT_CD", corpStates[i].getState()); // 0 : 미등록 (등록되지 않은 사업자번호 사업자번호 ), 1 : 사업중, 2 : 폐업, 3 : 휴업

					epwh9000201Service.epwh9000201_updateData4(map, request); //상태 업데이트
				}
			}

		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			/*e.printStackTrace();*/
			//취약점검 6283 기원우
			errCd = "A001";
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		if(errMsg.equals("")){
			rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		}else{
			rtnObj.put("RSLT_MSG", errMsg);
		}

		return rtnObj.toString();
	}

	/**
	 * 사업자관리 활동/비활동처리
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH900020142.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh900020142_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			if(data.get("gGubn").equals("A")){
				errCd = epwh9000201Service.epwh9000201_updateData3(data, request); //회원복원
			}else if(data.get("gGubn").equals("C")){
				errCd = epwh9000201Service.epwh9000201_updateData3(data, request); //비활동처리
			}

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
	 * 반환수집소 정보 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9000231_1.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh9000231_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		String state = "";
		
		try{
			
//			MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
//			String BIZRNO = mptRequest.getParameter("BIZRNO1") + mptRequest.getParameter("BIZRNO2") + mptRequest.getParameter("BIZRNO3");

//			try{
//				CorpState corpState = closedownService.CheckCorpNum(corpNum, BIZRNO);
//				if(corpState != null){
//					state = corpState.getState();
//				}
//			}catch(Exception e){
//				//errMsg = e.getMessage();
//				state = "";
//			}
			
			errCd = epwh9000201Service.epwh9000231_insert(request, state);
			
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
	 * 반환수집소 정보수정
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9000242_1.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000242_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		String state = "";
		
		try{
			
//			MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
//			String BIZRNO = mptRequest.getParameter("BIZRNO1") + mptRequest.getParameter("BIZRNO2") + mptRequest.getParameter("BIZRNO3");

//			try{
//				CorpState corpState = closedownService.CheckCorpNum(corpNum, BIZRNO);
//				if(corpState != null){
//					state = corpState.getState();
//				}
//			}catch(Exception e){
//				//errMsg = e.getMessage();
//				state = "";
//			}
			
			errCd = epwh9000201Service.epwh9000242_insert(request, state);
			
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
	 * 사업자변경내역 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9000201_1.do")
	public String epwh900020118(ModelMap model, HttpServletRequest request)  {

		model = epwh9000201Service.epwh900020118_select(model);

		return "WH/EPWH9000201_1";

	}

	/**
	 * 사업자변경내역 목록조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9000201_2.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh900020118_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request)  {
		return util.mapToJson(epwh9000201Service.epwh900020118_select2(data)).toString();
	}

	/**
	 * 사업자정보 상세조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9000216.do", produces="text/plain;charset=UTF-8")
	public String epwh9000216(ModelMap model, HttpServletRequest request) {
		model = epwh9000201Service.epwh9000216_select(model, request);
		
		Device device = DeviceUtils.getCurrentDevice(request);
		
		if(device.isNormal()){ //웹
		return "/WH/EPWH9000216";
		}else{ //모바일
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";
			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
			}
			model.addAttribute("userInfo", ssUserInfo); //사용자
			model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
			model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdList(vo))); //메뉴

			return "/WH_M/EPWH9000216";
		}
	}

	/**
	 * 지급제외설정 팝업
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9000217.do", produces="text/plain;charset=UTF-8")
	public String epwh9000217(ModelMap model, HttpServletRequest request) {
		model =  epwh9000201Service.epwh9000217_select(model, request);
		return "/WH/EPWH9000217";
	}

	/**
	 * 지급제외설정 수정
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9000217_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh9000217_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epwh9000201Service.epwh9000217_update(inputMap, request);
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
	 * 사업자정보 상세조회2
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9000216_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epwh9000216_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epwh9000201Service.epwh9000216_select2(data)).toString();
	}

	/**
	 * 관리자등록 팝업호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH90002018_1.do", produces="text/plain;charset=UTF-8")
	public String epwh90002018_1(ModelMap model, HttpServletRequest request)  {

		model = epwh9000201Service.epwh90002018_1_select(model, request);

		return "/WH/EPWH90002018_1";
	}

	/**
	 * 소속단체설정 팝업호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9000288.do", produces="text/plain;charset=UTF-8")
	public String epwh9000288(ModelMap model, HttpServletRequest request)  {
		model = epwh9000201Service.epwh9000288(model, request);
		return "WH/EPWH9000288";
	}

	/**
	 * 단체 설정 저장/수정
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9000288_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh9000288_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epwh9000201Service.epwh9000288_update(inputMap, request);
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
	 * 관리자등록
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH90002018_2.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh90002018_2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request)  {

		String errCd = "";

		try{
			errCd = epwh9000201Service.epwh90002018_1_update4(data, request, model); //관리자변경
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();

	}
	
	/**
	 * 사업자 등록 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9000231.do", produces="application/text; charset=utf8")
	public String epwh9000231_select(ModelMap model, HttpServletRequest request) {
		
		model = epwh9000201Service.epwh9000231_select(model, request);
		//페이지이동 조회조건 파라메터 정보
//		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"), "{}");
//		JSONObject jParams = JSONObject.fromObject(reqParams);
//		model.addAttribute("INQ_PARAMS",jParams);
		
		return "/WH/EPWH9000231";
	}

	/**
	 * 정보변경
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH9000242.do", produces="application/text; charset=utf8")
	public String epwh9000242(ModelMap model, HttpServletRequest request) {
		
		model = epwh9000201Service.epwh9000242_select(model, request);
		
		return "/WH/EPWH9000242";
	}

}

