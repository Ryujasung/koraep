/**
 * 
 */
package egovframework.koraep.ce.ep.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;

import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;
import org.h2.engine.SysProperties;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.mail.MailException;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.WebUtils;

import MTransKeySrvLib.MTransKeySrv;

import com.clipsoft.org.json.simple.parser.JSONParser;
import com.clipsoft.org.json.simple.parser.ParseException;

import egovframework.common.CommonProperties;
import egovframework.common.EgovFileMngUtil;
import egovframework.common.util;
import egovframework.koraep.auth.service.UserAuthCheckService;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE2925801Service;
import egovframework.koraep.ce.ep.service.EPCE8149301Service;
import egovframework.mapper.auth.AuthMapper;



/**
 * @author Administrator
 *
 */
@Controller
public class CommonCeController {

	@Resource(name = "commonceService")
	private CommonCeService commonceService;

	@Resource(name = "authMapper")
	private AuthMapper authMapper;
	
	@Resource(name="userAuthCheckService")
	private UserAuthCheckService userAuthCheckservice;
	
	@Resource(name="epce8149301Service")
	private EPCE8149301Service epce8149301Service;
	
	@Resource(name = "epce2925801Service")
	private EPCE2925801Service epce2925801Service; 	//회수정보관리 service
	
	
	/**
	 * ID찾기
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/EP/EPCE87234882.do")
	public String EPCE87234882(HttpServletRequest request) {
		return "/CE/EPCE87234882";
	}
	
	/**
	 * 회원가입창
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/EP/EPCE872340188.do")
	public String EPCE872340188(HttpServletRequest request) {
		return "/CE/EPCE872340188";
	}
	
	/**
	 * ID찾기 실행
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/EP/EPCE87234882_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String searchUserId(@RequestParam HashMap<String, String> paramMap,ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		return commonceService.searchUserId(paramMap, request);
	}
	
	/**
	 * 비밀번호변경요청
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/EP/EPCE8723488.do")
	public String EPCE8723488(HttpServletRequest request) {
		return "/CE/EPCE8723488";
	}
	
	/**
	 * 비밀번호변경요청 실행
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/EP/EPCE8723488_21.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String updateUserPwd(@RequestParam HashMap<String, String> paramMap,ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		return commonceService.updateUserPwd(paramMap, request);
	}
	
	/**
	 * 관리자 패스워드 변경처리, 업무담당자 변경요청처리
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/EP/EPCE8723488_212.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String updateUserAdminPwd(@RequestParam HashMap<String, String> paramMap,ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		return commonceService.updateUserAdminPwd(paramMap, request);
	}
	
	/**
	 * popup 조회
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/EP/EPCE8149301_POP.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce8149301_pop(@RequestParam HashMap<String, String> map, HttpServletRequest request) {
		return epce8149301Service.epce8149301_select3(map);
	}
	
	/**
	 * login
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = { "/login.do", "LOGIN.do" })
	public String login(ModelMap model, HttpServletRequest request) {

		Device device = null;

		try {
			/* 모바일체크 */
			device = DeviceUtils.getCurrentDevice(request);
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
		if(null == device) {
			HttpSession session = request.getSession(false);
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";
			
			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
				model.addAttribute("userInfo", ssUserInfo); //사용자
			}
			else {
				model.addAttribute("userInfo", ""); //사용자
			}
			
			return "/CE/EPCE8723401";
		}
		else {
			if(device.isNormal()){ //웹
				//팝업
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("ADMIN_YN", "N");
				
				String jsonStr = epce8149301Service.epce8149301_select1(map);
				model.addAttribute("popMngList", jsonStr);
				model.addAttribute("userInfo", ""); //사용자
				
				return "/CE/EPCE8723401";
				//return "/CE/EPCE8723401_test";
			}
			else{ //모바일
					
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				String ssUserInfo = "";
				
				if(vo != null){
					ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
					model.addAttribute("userInfo", ssUserInfo); //사용자
				}
				else {
					model.addAttribute("userInfo", ""); //사용자
				}
				
				return "/CE_M/EPCE8723401";
				//return "/CE/EPCE8723401";
			}
		}
	}

	
	
	/**
	 * login fail
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/loginfail.do")
	@ResponseBody
	public String loginfail(ModelMap model, HttpServletRequest request ,@RequestParam HashMap<String, String> map)throws Exception {
		
		String msg ;
		int cnt = 0;
		String pwdYN = "";
		try {
			cnt = commonceService.loginErrCnt(map);
			//20200512 패스워드변경 후 관리자 승인 전 팝업 추가
			pwdYN = commonceService.loginPwdChg(map);
			if("Y".equals(pwdYN)){
				msg	= "password change"; //패스워드 변경 후 관리자 승인 전
			}else if(cnt >= 5 ){
				msg	= "Invalid username and passwords"; //패스워드 5번 오퓨 시	
			}else {
				msg	= "Invalid username and password"; //한글이 깨져서 jsp에서 강제로 바꿈...
			}
			
		}catch(Exception e){
			msg = "no id";
		}
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("cnt", cnt);
		rtnMap.put("msg", msg);
		return util.mapToJson(rtnMap).toString();
	}

	/**
	 * 모바일 login
	 * 
	 * @param request
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value = "/MBL_LOGIN.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String mobile_login(@RequestParam HashMap<String, String> map, ModelMap model, HttpServletRequest request) {
		
		HashMap<String, String> rtnMap = new HashMap<String, String>();
		
		HttpSession session = request.getSession();
		session.setAttribute("APP", "Y");
		
		System.out.println("[GODCOM] " + map.toString());
		
		JSONParser parser = new JSONParser();
		com.clipsoft.org.json.simple.JSONObject JSONData;
		try {
			JSONData = (com.clipsoft.org.json.simple.JSONObject)parser.parse(map.get("JSONData"));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			rtnMap.put("RSLT_CD", "9999");
			return util.mapToJson(rtnMap).toString();
		}
		
		String user_id   = (String)JSONData.get("USER_ID");
		String user_pwd  = (String)JSONData.get("USER_PWD");
		String push_tk   = (String)JSONData.get("PUSH_TK");
		String push_tp   = (String)JSONData.get("PUSH_TP");
		String os_ver    = (String)JSONData.get("OS_VER");
		String device_nm = (String)JSONData.get("DEVICE_NM");
		String uuid      = (String)JSONData.get("UUID");
		
		String strBord_key = "";
		String strInput = "SUPARK8967";
	    strBord_key = util.encrypt(strInput);
	    strBord_key = strBord_key.substring(10,26);
	    
	    String decrypted = MTransKeySrv.MTK_Decrypt(strBord_key.getBytes(), user_pwd);
	    if(decrypted == null){
	    	decrypted = "error :: " + MTransKeySrv.MTK_GetLastError();
	    	rtnMap.put("RSLT_CD", decrypted);
	    }else{
	    	map.put("USER_PWD"  , decrypted);
	    	map.put("USER_ID"   , user_id);
	    	map.put("PUSH_TK"   , push_tk);
	    	map.put("PUSH_TP"   , push_tp);
	    	map.put("OS_VER"    , os_ver);
	    	map.put("DEVICE_NM" , device_nm);
	    	map.put("UUID"      , uuid);
	    	rtnMap = commonceService.loginCheck_mobile(map, request); //로그인 체크
	    }
		return util.mapToJson(rtnMap).toString();
		
	}
	
	/**
	 * 로그인 체크
	 * 
	 * @param map
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/USER_LOGIN_CHECK.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String loginCheck(@RequestParam HashMap<String, String> map, ModelMap model, HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
		// Authentication authentication =
		// SecurityContextHolder.getContext().getAuthentication();
		UserDetails user = (UserDetails) authentication.getPrincipal();
		
		System.out.println("user : "+user);
		System.out.println("user :"+user.toString());
		System.out.println("user :"+(UserDetails) authentication.getPrincipal());
		System.out.println("user :"+user.getUsername());
		String USER_ID = user.getUsername();
		map.put("USER_ID", USER_ID);
		HashMap<String, String> rtnMap = commonceService.loginCheck(map, request, response);
		return util.mapToJson(rtnMap).toString();
	}
	
	/**
	 * 20200323 로그인 체크 (설문 취소 시)
	 * 
	 * @param map
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/USER_LOGIN_CHECK3.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String loginCheck3(@RequestParam HashMap<String, String> map, ModelMap model, HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
		// Authentication authentication =
		// SecurityContextHolder.getContext().getAuthentication();
//		UserDetails user = (UserDetails) authentication.getPrincipal();
//		
//		String USER_ID = user.getUsername();
		map.put("USER_ID", "");
		HashMap<String, String> rtnMap = commonceService.loginCheck3(map, request, response);

		return util.mapToJson(rtnMap).toString();
	}

	@RequestMapping(value = "/SSO_LOGIN.do")
	public String ssoLoginCheck(ModelMap model, HttpServletRequest request,
			HttpServletResponse response) {
		
		System.out.println("GODCOM SSO_LOGIN==============");

		//return "/CE/EPCE8723401";
		return "/SSO_LOGIN";
	}

	/**
	 * SSO LOGIN
	 * 
	 * @param map
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/SSO_LOGIN_CHECK.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String ssoLoginCheck(@RequestParam HashMap<String, String> map,
			ModelMap model, HttpServletRequest request,
			HttpServletResponse response) {

		HttpSession session = request.getSession();
		
		HashMap<String, String> rtnMap = null;
		

			if (session.getAttribute("SSO_ID") == null
					|| session.getAttribute("SSO_ID").equals("")) {
				
				rtnMap = new HashMap<String, String>();
				
				rtnMap.put("noti", "");
				rtnMap.put("msg", "SSO로그인 정보가 올바르지 않습니다.");
				
				return util.mapToJson(rtnMap).toString();
			}

			map.put("SSO_ID", (String) session.getAttribute("SSO_ID"));
			
			rtnMap = commonceService.loginCheck_sso(map, request, response);
		

		return util.mapToJson(rtnMap).toString();
	}

	/**
	 * 세션 종료 로그아웃
	 * 
	 * @title : logOut
	 * @desc : TODO
	 * @parameter : @return
	 * @parameter : @
	 * @returns : String
	 * @throws
	 */
	@RequestMapping(value = { "/USER_LOGOUT.do", "/USER_LOGOUT_M.do" })
	public String logOut(HttpServletRequest request,
			HttpServletResponse response) {
		commonceService.logOut(request);
		System.out.println("그럼 여기?");
		String reqUrl = request.getRequestURI();
		if (reqUrl.indexOf("_M") > -1)
			return "redirect:/MAIN_M.do";

		return "redirect:/login.do";
	}

	/**
	 * 모바일 APP 기본정보 리턴
	 * 
	 * @param request
	 * @param response
	 * @throws IOException
	 *             @
	 */
	@RequestMapping(value = "/MAIN/APP_INFO.do")
	public void getAppInfo(HttpServletRequest request, HttpServletResponse response) throws IOException {

		String filePath = CommonProperties.APP_INFO_PATH + File.separator + "APP_INFO.ini";
		Properties prop = new Properties();

		PrintWriter out = null;

		FileInputStream fis = new FileInputStream(filePath);
		try {
			prop.load(fis);

			JSONObject mainObj = new JSONObject();
			JSONArray jArr = new JSONArray();
			JSONObject rtnObj = new JSONObject();
			
			if(prop != null) {
				rtnObj.put("c_available_service", prop.getProperty("c_available_service"));
				rtnObj.put("c_start_url", prop.getProperty("c_start_url"));
				rtnObj.put("c_program_ver", prop.getProperty("c_program_ver"));
				rtnObj.put("c_minimum_ver", prop.getProperty("c_minimum_ver"));
				rtnObj.put("c_act", this.iniEncStr(prop.getProperty("c_act")));
				rtnObj.put("c_act_close", prop.getProperty("c_act_close"));
				rtnObj.put("c_act_yn", prop.getProperty("c_act_yn"));
				rtnObj.put("c_update_act", this.iniEncStr(prop.getProperty("c_update_act")));
				rtnObj.put("c_update_close", prop.getProperty("c_update_close"));
				rtnObj.put("c_appstore_url", prop.getProperty("c_appstore_url"));
				rtnObj.put("c_session_time", prop.getProperty("c_session_time"));
				rtnObj.put("c_update_date", prop.getProperty("c_update_date"));
				rtnObj.put("c_qna_url", prop.getProperty("c_qna_url"));
				rtnObj.put("_master_id", prop.getProperty("_master_id"));
				rtnObj.put("_locale", prop.getProperty("_locale"));
			}

			jArr.add(rtnObj);
			mainObj.put("_tran_res_data", jArr);

			String rslt = URLEncoder.encode(rtnObj.toString(), "utf-8");

			response.setContentType("application/text;charset=UTF-8");
			//response.setContentType("application/text");
			//response.setCharacterEncoding("utf-8");
			out = response.getWriter();
			out.print(rslt);
			out.flush();
			out.close();
			fis.close();
		} catch (Exception e) {
			if (out != null)
				out.close();
			if (fis != null)
				fis.close();
		} finally {
			if (out != null)
				out.close();
			if (fis != null)
				fis.close();
		}

	}

	public String iniEncStr(String str) {
		try {
			return new String(str.getBytes("ISO-8859-1"), "utf-8");
		} catch (UnsupportedEncodingException e) {
			return "";
		}
	}

	/**
	 * 메인페이지로 이동
	 * 
	 * @param map
	 * @param model
	 * @param request
	 * @param response
	 * @return @
	 */
	@RequestMapping(value = "/MAIN.do", produces = "text/plain;charset=UTF-8")
	public String moveMain(ModelMap model, HttpServletRequest request, HttpServletResponse response) {      
        
		HttpSession session = request.getSession();           
		UserVO vo = (UserVO) session.getAttribute("userSession");
        		
		/* 다국어 */
		List<?> list = commonceService.selectTextList();
		HashMap<String, String> textMap = new HashMap<String, String>();
		for (int i = 0; i < list.size(); i++) {
			HashMap<String, String> listMap = (HashMap<String, String>) list.get(i);
			textMap.put(listMap.get("LANG_CD"), listMap.get("LANG_NM"));
		}
		//model.addAttribute("ttObject", util.mapToJson(vo.getUSER_TEXT_LIST()));
		model.addAttribute("ttObject", util.mapToJson(textMap));
		/* 다국어 */

		// ??
		if (request.getAttribute("message") != null) {
			model.addAttribute("message", request.getAttribute("message"));
		}

		// 팝업리스트 - 팝업관리
		//HashMap<String, String> map = new HashMap<String, String>();
		//map.put("SEARCH_SBJ", "");
		//map.put("ADMIN_YN", "N");

		model.addAttribute("BIZRNM", vo.getBIZRNM());
		model.addAttribute("USER_NM", vo.getUSER_NM());
		model.addAttribute("BRCH_NO", vo.getBRCH_NO());
		model.addAttribute("BIZR_TP_CD_ORI", vo.getBIZR_TP_CD());
		model.addAttribute("ATH_GRP_NM", vo.getATH_GRP_NM());

		String url = "";
		/*
		 * String mbrSeCd = vo.getBIZR_TP_CD(); if(mbrSeCd.equals("A")){ //url =
		 * "redirect:/CE/EPCE55234011.do"; return "/main";//임시 메인 }else
		 * if(mbrSeCd.equals("B")){ url = "redirect:/CE/EPMPCNDP2.do"; }else
		 * if(mbrSeCd.equals("C") || mbrSeCd.equals("D")){ url =
		 * "redirect:/EPMP/EPMPCNDP3.do"; }
		 */
		
		String bizrTpCd = (vo.getBIZR_TP_CD() == null) ? "" : vo.getBIZR_TP_CD().substring(0, 1).toUpperCase();
		model.addAttribute("BIZR_TP_CD", bizrTpCd);
		
		String athSeCd =  (vo.getATH_SE_CD() == null) ? "" : vo.getATH_SE_CD();
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);
		String normalYn = "";
		if(device.isNormal()){ //웹
			normalYn = "Y";
		}else{
		//}else if(bizrTpCd.equals("W") || bizrTpCd.equals("R")){ //모바일  도매업자, 소매업자
			normalYn = "N";
			String ssUserInfo = "";
			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
			}
			model.addAttribute("userInfo", ssUserInfo); //사용자
			//model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
			
			if(vo != null){
				model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdListM(vo))); //메뉴
			}
		}
		
		if (bizrTpCd.equals("T")) { // 센터

			if(athSeCd.equals("B")){ //센터지사
				url = "/main_b";
			}else if(athSeCd.equals("C")){ //센터도매업무관리
				url = "/main_c";
			}else if(athSeCd.equals("H")){ //고객지원
				url = "/main_h";
			}else{
				url = "/main";
			}
			
		} else if (bizrTpCd.equals("M")) { // 생산자
			if(athSeCd.equals("G")){
				url = "/main_mf_g";
			}else{
				url = "/main_mf";
			}
		} else if (bizrTpCd.equals("W")) { // 도매업자
			if(normalYn.equals("Y")){
				url = "/main_wh";
			}else{
				url = "/main_wh_m";
			}
		} else if (bizrTpCd.equals("R")) { // 소매업자
			if(normalYn.equals("Y")){
				url = "/main_rt";
			}else{
				url = "/main_rt_m";
			}
		} else if (bizrTpCd.equals("D")) { // 출고등록, 직접회수, 소매거래처등록 사업자
		} else if (bizrTpCd.equals("E")) { // 기타 사업자
		}

		return url;
	}

	/**
	 * 알림 조회
	 * 
	 * @param paramMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_ANC_LIST.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String selectAncList(@RequestParam Map<String, String> paramMap, ModelMap model, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String ssUserId = "";
		
		if(vo != null){
			ssUserId = vo.getUSER_ID();
		}
		
		List<?> ancList = commonceService.selectAncList(ssUserId);
		
		if (ancList == null || ancList.size() == 0)
			return "[]";

		String rtn = "";
		try {
			rtn = util.mapToJson(ancList).toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return rtn;
	}
	
	/**
	 * 알림 조회 모바일
	 * 
	 * @param paramMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_ANC_LIST_M.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String selectAncListM(@RequestParam Map<String, String> paramMap, ModelMap model, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String ssUserId = "";
		
		if(vo != null){
			ssUserId = vo.getUSER_ID();
		}
		
		List<?> ancList = commonceService.selectAncListM(ssUserId);
		
		if (ancList == null || ancList.size() == 0)
			return "[]";

		String rtn = "";
		try {
			rtn = util.mapToJson(ancList).toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return rtn;
	}
	
	/**
	 * 알림 확인 처리
	 * 
	 * @param paramMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/CONFIRM_ANC.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String confirmAnc(@RequestParam Map<String, String> paramMap, ModelMap model, HttpServletRequest request) {

		try {
			commonceService.confirm_anc(paramMap, request);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	
		
		JSONObject rtnObj = new JSONObject();
		
		return rtnObj.toString();
	}
	
	/**
	 * 메인화면 설정
	 * 
	 * @param paramMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/MAIN_LIST.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String setMain(@RequestParam Map<String, String> paramMap, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(commonceService.selectMainList(request)).toString();
	}
	
	
	/**
	 * 사용자 메뉴 조회
	 * 
	 * @param paramMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_USER_MENU_LIST.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String selectUserMeuList(@RequestParam Map<String, String> paramMap,
			ModelMap model, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");

		//List<?> menuList = commonceService.selectUserMemuList(vo);
		//List<?> menuList = vo.getUSER_MENU_LIST();
		
		List<?> menuList = commonceService.selectUserMemuList(vo);
		vo.setUSER_MENU_LIST(menuList);
		
		if (menuList == null || menuList.size() == 0)
			return "[]";

		String rtn = "";
		try {
			rtn = util.mapToJson(menuList).toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return rtn;
	}

	/**
	 * 공통(기타)코드 조회
	 * 
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_COMMON_CD_LIST.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String getCommonCdList(@RequestParam Map<String, String> paraMap,
			ModelMap model, HttpServletRequest request) {
		// 입력가능 파라메터 GRP_CD(그룹코드), CD_SE(코드구분), RMK(비고 - indexOf 검색)
		List<?> list = commonceService.getCommonCdList(paraMap);

		String rtn = "";

		try {
			rtn = util.mapToJson(list).toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return rtn;
	}

	/**
	 * 은행코드 조회
	 * 
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_BANK_CD_LIST.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String getBankCdList(@RequestParam Map<String, String> paraMap,
			ModelMap model, HttpServletRequest request) {
		List<?> list = commonceService.getBankCdList();

		String rtn = "";

		try {
			rtn = util.mapToJson(list).toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return rtn;
	}

	/**
	 * 에러코드 조회
	 * 
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_ERR_CD_LIST.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String getErrCdList(@RequestParam Map<String, String> paraMap,
			ModelMap model, HttpServletRequest request) {
		// 입력가능 파라메터 SYS_SE(시스템구분),
		List<?> list = commonceService.getErrCdList(paraMap);

		String rtn = "";

		try {
			rtn = util.mapToJson(list).toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return rtn;
	}
	@RequestMapping(value = {"/SEARCH_ZIPCODE_POP.do","/EP/SEARCH_ZIPCODE_POP.do"})
	public String viewZipCode(ModelMap model, HttpServletRequest request) {
		return "/searchZipCode";
	}

	/**
	 * 우체국 api 우편번호 조회
	 * 
	 * @param param
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = {"/SELECT_ZIPCODE.do","/EP/SELECT_ZIPCODE.do"}, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String getPostZipCode(@RequestParam Map<String, String> param,
			ModelMap model, HttpServletRequest request) {

		HashMap<String, Object> rtn = new HashMap<String, Object>();
		List<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>(); // 결과
																						// 주소정보들

		String currentPage = (param.get("currentPage") == null || param
				.get("currentPage") == "0") ? "1" : param.get("currentPage");
		String countPerPage = "10";
		String keyword = (param.get("keyword") == null) ? "" : param
				.get("keyword");
		if (keyword.equals(""))
			return "";

		String regkey = "ef14f56a4eb3f7f691444117703002";
		String apiUrl = "";
		try {
			apiUrl = "http://biz.epost.go.kr/KpostPortal/openapi?regkey="
					+ regkey + "&target=postNew" + "&query="
					+ URLEncoder.encode(keyword, "euc-kr") + "&countPerPage="
					+ countPerPage + "&currentPage=" + currentPage;
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		// log.debug("====" + apiUrl);

		Document document = null;
		try {
			document = (Document) Jsoup.connect(apiUrl).get();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		// 검색결과 - 에러 확인
		String errCd = document.select("error_code").text();
		if (null != errCd && !"".equals(errCd)) {
			rtn.put("errCd", errCd);
			rtn.put("errMsg", document.select("message").text());
			return util.mapToJson(rtn).toString();
		}

		// 검색결과 - 조회결과 정보
		Elements pageinfo = document.select("pageinfo");
		String totCnt = pageinfo.select("totalCount").text();
		String totalPage = pageinfo.select("totalPage").text();

		// 검색결과 리스트
		Elements itemlist = document.select("item");
		for (Element element : itemlist) {
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("postcd", element.select("postcd").text());
			map.put("address", element.select("address").text());
			map.put("addrjibun", element.select("addrjibun").text());
			list.add(map);
		}

		rtn.put("errCd", "");
		rtn.put("errMsg", "");
		rtn.put("totalCount", totCnt);
		rtn.put("totalPage", totalPage);
		rtn.put("currentPage", currentPage);
		rtn.put("addrList", list);

		return util.mapToJson(rtn).toString();
	}

	/**
	 * 엑셀 다운로드 공통 - grid data를 받아서 다운
	 * 
	 * @param paraMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping("/EXCEL_DOWN.do")
	public String excelDown(@RequestParam Map<String, String> paraMap,
			ModelMap model, HttpServletRequest request) {
		/*
		 * log.debug("list ===============" + paraMap.get("list"));
		 * log.debug("COLUMN ===============" + paraMap.get("COLUMN"));
		 * log.debug("TITLE ===============" + paraMap.get("TITLE"));
		 * log.debug("EXCEL_NAME ===============" + paraMap.get("EXCEL_NAME"));
		 */
		List<?> list = JSONArray.fromObject(paraMap.get("list"));
		model.addAttribute("resultList", list);
		model.addAttribute("COLUMN", paraMap.get("COLUMN"));
		model.addAttribute("TITLE", paraMap.get("TITLE"));
		model.addAttribute("EXCEL_NAME", paraMap.get("EXCEL_NAME"));
		return "/excel_down";
	}

	@RequestMapping(value = "/POP_EXCEL_UPLOAD_VIEW.do", produces = "text/plain;charset=UTF-8")
	public String popExcelUpload(ModelMap model, HttpServletRequest request) {
		/*
		 * String callBackFunc = request.getParameter("callBackFunc");
		 * model.addAttribute("msg", ""); model.addAttribute("callBackFunc",
		 * callBackFunc); model.addAttribute("list", "[]");
		 * model.addAttribute("saveYn", "N");
		 */

		return "/excel_upload";
	}

	/**
	 * 엑셀 그리드 업로드
	 * 
	 * @param model
	 * @param request
	 * @return @
	 */
	/*
	 * @RequestMapping(value="/EXCEL_UPLOAD.do",
	 * produces="text/plain;charset=UTF-8") public String excelUpload2(ModelMap
	 * model,HttpServletRequest request) { String msg = "";
	 * 
	 * ArrayList<HashMap<String, String>> list = new ArrayList<HashMap<String,
	 * String>>(); ExcelReader er = new ExcelReader();
	 * MultipartHttpServletRequest mptRequest =
	 * (MultipartHttpServletRequest)request; String callBackFunc =
	 * mptRequest.getParameter("callBackFunc"); Iterator fileIter =
	 * mptRequest.getFileNames(); while (fileIter.hasNext()) { MultipartFile
	 * mFile = mptRequest.getFile((String)fileIter.next());
	 * 
	 * String orginFileName = mFile.getOriginalFilename(); int index =
	 * orginFileName.lastIndexOf("."); String fileExt =
	 * orginFileName.substring(index + 1);
	 * if(fileExt.toLowerCase().equals("xlsx")){ list =
	 * er.getDataStreamXlsx(mFile, true); }else
	 * if(fileExt.toLowerCase().equals("xls")){ list = er.getDataStream(mFile,
	 * true); }else{ //throw new Exception("업로드 파일 오류-확장자 불일치"); msg =
	 * "업로드 파일 오류-확장자 불일치"; }
	 * 
	 * }//while
	 * 
	 * 
	 * model.addAttribute("saveYn", "Y"); model.addAttribute("msg", msg);
	 * model.addAttribute("callBackFunc", callBackFunc); if(list == null ||
	 * list.size() == 0){ model.addAttribute("list", "[]"); }else{
	 * model.addAttribute("list", util.mapToJson(list).toString()); } return
	 * "/excel_upload"; }
	 */

	/**
	 * 엑셀 그리드 업로드
	 * 
	 * @param inputMap
	 * @param request
	 * @return @
	 */

	@RequestMapping(value = "/EXCEL_UPLOAD.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String excelUpload(@RequestParam Map<String, String> inputMap, HttpServletRequest request) {

		String errCd = "";
		try {
			return util.mapToJson(
					commonceService.excelUpload(inputMap, request)).toString();
		} catch (Exception e) {
			errCd = e.getMessage();
			JSONObject rtnObj = new JSONObject();
			rtnObj.put("RSLT_CD", errCd);
			rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
			return rtnObj.toString();
		}
	}

	/**
	 * 도움말
	 * 
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/POP_HELP.do", produces = "text/plain;charset=UTF-8")
	public String viewHelp(ModelMap model, HttpServletRequest request) {
		String url = request.getParameter("HELP_URL");
		url = "/help/" + url + "_HELP";
		return url;
	}

	@RequestMapping(value = "/CALL_PRNT_LOG.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String selectIdPhoneCheck(
			@RequestParam HashMap<String, String> param, ModelMap model,
			HttpServletRequest request) {
		/*
		 * String menuId = param.get("MENU_ID"); String url =
		 * param.get("CALL_URL"); String histPrcsSe = param.get("HIST_PRCS_SE");
		 * //기타코드테이블(그룹코드: C006) : S:처리, C:등록, U:수정, D:삭제, P:출력, X:엑셀저장 String
		 * sysSe = param.get("SYS_SE"); //시스템구분 -기타코드테이블(그룹코드: C005) : A: 웹시스템,
		 * B: 연계API
		 * 
		 * if(histPrcsSe == null || histPrcsSe.equals("")) histPrcsSe = "P";
		 * if(sysSe == null || sysSe.equals("")) sysSe = "A";
		 * 
		 * HttpSession session = request.getSession(); UserVO vo =
		 * (UserVO)session.getAttribute("userSession");
		 * 
		 * HashMap<String, String> map = new HashMap<String, String>();
		 * map.put("USER_ID", vo.getUSER_ID()); map.put("SYS_SE", sysSe);
		 * map.put("HIST_PRCS_SE", histPrcsSe); map.put("MENU_GRP_CD",
		 * menuId.substring(0, 4)); map.put("MENU_CD", menuId);
		 * map.put("LK_API_CD", ""); map.put("ACSS_IP",
		 * request.getRemoteAddr()); map.put("CALL_URL", url);
		 * 
		 * commonceService.insertExecHist(map);
		 */
		return "";
	}

	/*	*//**
	 * 생산자별 빈용기명 콤보박스 목록조회
	 * 
	 * @param data
	 * @param request
	 * @return @
	 */
	/*
	 * @RequestMapping(value="/CE/EPMF3121.do",
	 * produces="application/text; charset=utf8")
	 * 
	 * @ResponseBody public String epmf3121_select(@RequestParam Map<String,
	 * String> data, HttpServletRequest request) {
	 * 
	 * log.debug("==/CE/EPMF3121.do===========================");
	 * log.debug("=============================" + data.toString());
	 * 
	 * return util.mapToJson(commonceService.epmf3121_select(data,
	 * request)).toString();
	 * 
	 * }
	 */

	/**
	 * 언어목록 조회
	 * 
	 * @param paramMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_TEXT_LIST.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String selectTextList(@RequestParam Map<String, String> paramMap,
			ModelMap model, HttpServletRequest request) {

		List<?> list = commonceService.selectTextList();

		if (list == null || list.size() == 0)
			return "[]";

		String rtn = "";

		try {
			rtn = util.mapToJson(list).toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return rtn;
	}

	/**
	 * 버튼목록 조회
	 * 
	 * @param paramMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_BTN_LIST.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String selectBtnList(@RequestParam Map<String, String> paramMap,
			ModelMap model, HttpServletRequest request) {

		List<?> list = commonceService.selectBtnList(paramMap, request);

		if (list == null || list.size() == 0)
			return "[]";

		String rtn = "";

		try {
			rtn = util.mapToJson(list).toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return rtn;
	}

	/**
	 * 사업자별 지점 조회
	 * 
	 * @param paramMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_BRCH_LIST.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String selectBrchList(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {

		String BIZRID_NO = data.get("BIZRID_NO");
		if (BIZRID_NO != null && !BIZRID_NO.equals("")) {
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}

		List<?> list = commonceService.brch_nm_select(request, data);

		String rtn = "";

		try {
			rtn = util.mapToJson(list).toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return rtn;
	}
	
	/**
	 * 사업자별 지점 조회
	 * 
	 * @param paramMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_BRCH_LIST_ALL.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String selectBrchListAll(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		if(vo != null){
			
			data.put("BIZRID", vo.getBIZRID());
			data.put("BIZRNO", vo.getBIZRNO_ORI());
			
			data.put("BRCH_ID", vo.getBRCH_ID());
			if(!vo.getBRCH_NO().equals("9999999999")){
				data.put("BRCH_NO", vo.getBRCH_NO());
			}
		}
		
		List<?> list = commonceService.brch_nm_select_all(data); // 도매업자 지점

		String rtn = "";

		try {
			rtn = util.mapToJson(list).toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return rtn;
	}
	
	/**
	 * 도매업자 구분 선택시 업체조회
	 * 
	 * @param paramMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_WHSDL_BIZR_LIST.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String selectWhsdlBizrList(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(commonceService.mfc_bizrnm_select4(request, data)).toString();
	}

	/**
	 * 생산자별 빈용기명 콤보박스 목록조회
	 * 
	 * @param paramMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_CTNR_LIST.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String selectCtnrList(@RequestParam Map<String, String> data,
			ModelMap model, HttpServletRequest request) {

		String BIZRID_NO = data.get("BIZRID_NO");
		if (BIZRID_NO != null && !BIZRID_NO.equals("")) {
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		} else {
			data.put("BIZRID", "");
			data.put("BIZRNO", "");
		}

		List<?> list = commonceService.ctnr_nm_std_dps_select(request, data);

		String rtn = "";

		try {
			rtn = util.mapToJson(list).toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return rtn;
	}
	
	/**
	 * 빈용기 취급수수료 + 보증금 조회
	 * 
	 * @param paramMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_CTNR_CD.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String ctnr_cd_select(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		try {
			rtnMap.put("ctnr_nm", util.mapToJson(commonceService.ctnr_cd_select(data)));//빈용기명 조회
		} catch (Exception e) {
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return util.mapToJson(rtnMap).toString();
	}
	
	/**
	 * 빈용기 조회
	 * 
	 * @param paramMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_CTNR_CD2.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String ctnr_cd_select2(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		try {
			rtnMap.put("ctnr_nm", util.mapToJson(commonceService.ctnr_nm_select2(request, data)));//빈용기명 조회
		} catch (Exception e) {
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return util.mapToJson(rtnMap).toString();
	}
	
	/**
	 * 빈용기 용도 조회
	 * 
	 * @param paramMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_PRPS_CD.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String prps_cd_select(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		try {
			rtnMap.put("selList", util.mapToJson(commonceService.ctnr_se_select(request, data)));
		} catch (Exception e) {
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return util.mapToJson(rtnMap).toString();
	}

	/**
	 * 회수용기 조회
	 * 
	 * @param paramMap
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/SELECT_RTRVL_CTNR_CD2.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String rtrvl_ctnr_cd_select2(@RequestParam Map<String, String> data, ModelMap model, HttpServletRequest request) {
		
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		try {
			rtnMap.put("ctnr_nm", util.mapToJson(commonceService.rtrvl_ctnr_cd_select2(data)));//빈용기명 조회
		} catch (Exception e) {
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return util.mapToJson(rtnMap).toString();
	}

	/**
	 * 팝업)파일 업로드 화면 호출
	 * 
	 * @param model
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/POP_FILE_UPLOAD_VIEW.do", produces = "text/plain;charset=UTF-8")
	public String popFileUploadView(@RequestParam Map<String, String> param,
			ModelMap model, HttpServletRequest request) {

		Iterator<String> it = param.keySet().iterator();
		while (it.hasNext()) {
			String key = it.next();
			model.addAttribute(key, param.get(key));
		}

		return "/file_upload";
	}

	@RequestMapping(value = "/POP_FILE_UPLOAD_PROC.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String popFileUploadProc(ModelMap model, HttpServletRequest request) {

		String centerBizrNo = CommonProperties.CENTER_BIZNO;
		List<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
		//크로스
//		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest) request;
		MultipartHttpServletRequest mptRequest = WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
		Iterator<?> fileIter = mptRequest.getFileNames();
		while (fileIter.hasNext()) {
			MultipartFile mFile = mptRequest.getFile((String) fileIter.next());
			if (mFile != null) {
				String fileName = mFile.getOriginalFilename();
				if (fileName != null && !fileName.equals("")) {
					// String tmpFileName = fileName.toLowerCase();
					HashMap map = new HashMap();
					try {
						map = EgovFileMngUtil.uploadFile(mFile, centerBizrNo);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
					} // 파일저장
					fileName = (String) map.get("uploadFileName");
					list.add(map);
				}
			}
		}

		String rtn = "";

		try {
			rtn = util.mapToJson(list).toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return rtn;
	}

	/**
	 * 그리드 컬럼 저장
	 * 
	 * @param inputMap
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/GRID_INFO.do", produces = "application/text; charset=utf8")
	@ResponseBody
	public String grid_info(@RequestParam Map<String, String> inputMap,
			HttpServletRequest request) {
		String errCd = "";
		try {
			errCd = commonceService.GRID_INFO_INSERT(inputMap, request);
		} catch (Exception e) {
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}
	
	
	/**
	 * API test
	 * 
	 * @param inputMap
	 * @param request
	 * @return @
	 */
	@RequestMapping(value = "/api/API_TEST.do", produces = "application/text; charset=utf8")
	@ResponseBody
	public String API_TEST(@RequestParam Map<String, Object> inputMap, HttpServletRequest request) {
		String errCd = "";
		try {
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
			String sendDtTm = formatter.format(new Date());

			
			HashMap<String, String> mObj = util.jsonToMap(JSONObject.fromObject(inputMap.get("MAIN_OBJ")));
			List<JSONObject> list = JSONArray.fromObject(mObj.get("REPT_REC"));
			
			JSONArray rObj = JSONArray.fromObject(mObj.get("REPT_REC"));
			
			JSONObject mainObj = new JSONObject();

			//공통세팅
			mainObj.put("TRMS_DT"      , sendDtTm.substring(0, 8));//등록일자
			mainObj.put("TRMS_TKTM"    , sendDtTm.substring(8, sendDtTm.length()));//등록시간
			mainObj.put("API_ID"       , mObj.get("API_ID"));//요청APIT  AP_R01, AP_R03, AP_R06, AP_R09
			mainObj.put("MBR_ISSU_KEY" , mObj.get("MBR_ISSU_KEY"));//발급키
			mainObj.put("BIZRNO"       , mObj.get("BIZRNO"));//사업자번호 12345672 6088107131
			mainObj.put("REG_DIV"      , mObj.get("REG_DIV"));//등록구분 : I-신규, U-수정
			mainObj.put("ERP_CD"       , mObj.get("ERP_CD"));//ERP코드
			mainObj.put("REPT_REC"     , JSONArray.fromObject(mObj.get("REPT_REC")));

			JSONArray jArr = new JSONArray();//레코드용 array
			
			//반환정보등록
			//집계자료
			JSONObject summaryObj = new JSONObject();
			summaryObj.put("RTN_DT", "20190227");//반환일자
			summaryObj.put("MFC_BIZRNO", "0000000000");//생상자사업자번호
			summaryObj.put("DTSS_NO", "0000000000");//직매장번호
			summaryObj.put("STD_CTNR_CD", "210001");//표준용기코드
			summaryObj.put("RTRVL_QTY", "123");//반환수량
			summaryObj.put("BOX_QTY", "1");//박수수량
			summaryObj.put("CAR_NO", "2293");//차량번호
			jArr.add(summaryObj);

			//로우 데이타 -- 반복사용구간
			JSONObject rowobj7 = new JSONObject();
			rowobj7.put("RTN_DT", "20190227");//반환일자
			rowobj7.put("MFC_BIZRNO", "2148100777");//생상자사업자번호
			rowobj7.put("DTSS_NO", "2118813587");//직매장번호
			rowobj7.put("STD_CTNR_CD", "210001");//표준용기코드
			rowobj7.put("RTRVL_QTY", "123");//반환수량
			rowobj7.put("BOX_QTY", "1");//박수수량
			rowobj7.put("CAR_NO", "2293");//차량번호
			jArr.add(rowobj7);
			
			/*
			JSONObject rowobj8 = new JSONObject();
			rowobj8.put("MFC_CTNR_CD", "000000300002");//제품코드
			rowobj8.put("SE_CD1", "1");//구분코드1
			rowobj8.put("SE_CD2", "");//구분코드2
			rowobj8.put("SE_CD3", "");//구분코드3
			rowobj8.put("MFC_CTNR_NM", "고병-오비 640");//제품명
			rowobj8.put("STD_CTNR_CD", "311172");//빈용기코드
			rowobj8.put("REG_SE", "D");//차량번호
			//jArr.add(rowobj8);
			
			rowobj8.put("MFC_CTNR_CD", "000000300004");//제품코드
			rowobj8.put("SE_CD1", "1");//구분코드1
			rowobj8.put("SE_CD2", "");//구분코드2
			rowobj8.put("SE_CD3", "");//구분코드3
			rowobj8.put("MFC_CTNR_NM", "고병-오비 500");//제품명
			rowobj8.put("STD_CTNR_CD", "311172");//빈용기코드
			rowobj8.put("REG_SE", "D");//차량번호
			//jArr.add(rowobj8);

			JSONObject rowobj9 = new JSONObject();
			rowobj9.put("CFM_DT", "20180714");//입고확인일자
			rowobj9.put("DTSS_NO", "0000000000");//직매장번호
			rowobj9.put("CUST_BIZRNO", "0000000000");//판매처사업자번호(도매업자)
			rowobj9.put("MFC_CTNR_CD", "000000300002");//생산자제품코드
			rowobj9.put("SE_CD1", "");//구분코드1
			rowobj9.put("SE_CD2", "");//구분코드2
			rowobj9.put("SE_CD3", "");//구분코드3
			rowobj9.put("CFM_QTY", "3");//입고확인수량
			rowobj9.put("CFM_GTN", "100");//입고확인보증금
			rowobj9.put("CFM_FEE", "10");//입고확인수수료
			rowobj9.put("CFM_FEE_STAX", "1");//입고확인부가세
			//jArr.add(rowobj9);

			rowobj9.put("CFM_DT", "20180714");//입고확인일자
			rowobj9.put("DTSS_NO", "1858500254");//직매장번호
			rowobj9.put("CUST_BIZRNO", "6098125258");//판매처사업자번호(도매업자)
			rowobj9.put("MFC_CTNR_CD", "000000300002");//생산자제품코드
			rowobj9.put("SE_CD1", "");//구분코드1
			rowobj9.put("SE_CD2", "");//구분코드2
			rowobj9.put("SE_CD3", "");//구분코드3
			rowobj9.put("CFM_QTY", "3");//입고확인수량
			rowobj9.put("CFM_GTN", "100");//입고확인보증금
			rowobj9.put("CFM_FEE", "10");//입고확인수수료
			rowobj9.put("CFM_FEE_STAX", "1");//입고확인부가세
			//jArr.add(rowobj9);
			 */
			
			/*
			// 회수
			//집계자료
			JSONObject summaryObj = new JSONObject();
			summaryObj.put("RTRVL_DT", "20180627");//회수일자
			summaryObj.put("RTL_BIZRNO", "0000000000");//소매 사업자 번호
			summaryObj.put("RTRVL_CTNR_CD", "311");//회수용기코드
			summaryObj.put("RTRVL_QTY", "1000");//회수수량
			summaryObj.put("RTRVL_GTN", "300");//회수보증금
			summaryObj.put("RTL_FEE", "100");//소매수수료
			summaryObj.put("BCNC_SE", "0");//거래처구분(0: 유흥취급, 1: 가정취급)
			summaryObj.put("RTL_ENP_NM", "회수테스트A");//거래처명
			jArr.add(summaryObj);

			//로우 데이타 -- 반복사용구간
			JSONObject rowobj = new JSONObject();
 
			rowobj.put("RTRVL_DT", "20180627");//회수일자
			rowobj.put("RTL_BIZRNO", "1231212345");//소매 사업자 번호
			rowobj.put("RTRVL_CTNR_CD", "311");//회수용기코드
			rowobj.put("RTRVL_QTY", "300");//회수수량
			rowobj.put("RTRVL_GTN", "100");//회수보증금
			rowobj.put("RTL_FEE", "30");//소매수수료
			rowobj.put("BCNC_SE", "0");//거래처구분(0: 유흥취급, 1: 가정취급)
			rowobj.put("RTL_ENP_NM", "회수거래처");//거래처명
			jArr.add(rowobj);
			
			rowobj.put("RTRVL_DT", "20180627");//회수일자
			rowobj.put("RTL_BIZRNO", "2118841856");//소매 사업자 번호
			rowobj.put("RTRVL_CTNR_CD", "311");//회수용기코드
			rowobj.put("RTRVL_QTY", "700");//회수수량
			rowobj.put("RTRVL_GTN", "200");//회수보증금
			rowobj.put("RTL_FEE", "70");//소매수수료
			rowobj.put("BCNC_SE", "1");//거래처구분(0: 유흥취급, 1: 가정취급)
			rowobj.put("RTL_ENP_NM", "회수거래처2");//거래처명
			jArr.add(rowobj);
			
			//출고
			//집계자료
			JSONObject summaryObj = new JSONObject();
			summaryObj.put("DLIVY_DT", "20180626");//출고일자
			summaryObj.put("DTSS_NO", "0000000000");//직매장번호(물류센터)
			summaryObj.put("WHSLD_BIZRNO", "0000000000");//거래처 사업자 번호
			summaryObj.put("STD_CTNR_CD", "311211");//표준용기코드
			summaryObj.put("DLIVY_QTY", "1000");//출고수량
			summaryObj.put("WHSLD_ENP_NM", "테스트A");//거래처명
			jArr.add(summaryObj);

			//로우 데이타 -- 반복사용구간
			JSONObject rowobj = new JSONObject();

			rowobj.put("DLIVY_DT", "20180626");//출고일자
			rowobj.put("DTSS_NO", "9999999999");//직매장번호(물류센터)
			rowobj.put("WHSLD_BIZRNO", "3131313131");//거래처 사업자 번호
			rowobj.put("STD_CTNR_CD", "311211");//표준용기코드
			rowobj.put("DLIVY_QTY", "800");//출고수량
			rowobj.put("WHSLD_ENP_NM", "테스트거래처");
			jArr.add(rowobj);

			rowobj.put("DLIVY_DT", "20180626");//출고일자
			rowobj.put("DTSS_NO", "9999999999");//직매장번호(물류센터)
			rowobj.put("WHSLD_BIZRNO", "4242424242");//거래처 사업자 번호
			rowobj.put("STD_CTNR_CD", "311211");//표준용기코드
			rowobj.put("DLIVY_QTY", "200");//출고수량
			rowobj.put("WHSLD_ENP_NM", "테스트거래처2");
			jArr.add(rowobj);
			 */
			
			
			/*
			//직접회수
			//집계자료
			JSONObject summaryObj = new JSONObject();
			summaryObj.put("DRCT_RTRVL_DT", "20180514");//직접회수일자
			summaryObj.put("DTSS_NO", "0000000000");//직매장번호(물류센터)
			summaryObj.put("RTL_BIZRNO", "0000000000");//소매 사업자 번호
			summaryObj.put("STD_CTNR_CD", "311211");//표준용기코드
			summaryObj.put("DRCT_RTRVL_QTY", "1000");//직접회수수량
			summaryObj.put("DRCT_PYMT_GTN", "700");//직접지급보증금
			summaryObj.put("DRCT_PYMT_FEE", "300");//직접지급수수료
			summaryObj.put("RTL_ENP_NM", "테스트A");//거래처명
			jArr.add(summaryObj);
			
			summaryObj.put("DRCT_RTRVL_DT", "20180514");//직접회수일자
			summaryObj.put("DTSS_NO", "0000000000");//직매장번호(물류센터)
			summaryObj.put("RTL_BIZRNO", "0000000000");//소매 사업자 번호
			summaryObj.put("STD_CTNR_CD", "210001");//표준용기코드
			summaryObj.put("DRCT_RTRVL_QTY", "100");//직접회수수량
			summaryObj.put("DRCT_PYMT_GTN", "70");//직접지급보증금
			summaryObj.put("DRCT_PYMT_FEE", "30");//직접지급수수료
			summaryObj.put("RTL_ENP_NM", "테스트B");//거래처명
			jArr.add(summaryObj);

			//로우 데이타 -- 반복사용구간
			JSONObject rowobj = new JSONObject();
			rowobj.put("DRCT_RTRVL_DT", "20180514");//직접회수일자
			rowobj.put("DTSS_NO", "6068524205");//직매장번호(물류센터)
			rowobj.put("RTL_BIZRNO", "5151515151");//소매 사업자 번호
			rowobj.put("STD_CTNR_CD", "311211");//표준용기코드
			rowobj.put("DRCT_RTRVL_QTY", "1000");//직접회수수량
			rowobj.put("DRCT_PYMT_GTN", "700");//직접지급보증금
			rowobj.put("DRCT_PYMT_FEE", "300");//직접지급수수료
			rowobj.put("RTL_ENP_NM", "테스트거래처");//거래처명
			jArr.add(rowobj);

			rowobj.put("DRCT_RTRVL_DT", "20180514");//직접회수일자
			rowobj.put("DTSS_NO", "6068524205");//직매장번호(물류센터)
			rowobj.put("RTL_BIZRNO", "5151515151");//소매 사업자 번호
			rowobj.put("STD_CTNR_CD", "210001");//표준용기코드
			rowobj.put("DRCT_RTRVL_QTY", "100");//직접회수수량
			rowobj.put("DRCT_PYMT_GTN", "70");//직접지급보증금
			rowobj.put("DRCT_PYMT_FEE", "30");//직접지급수수료
			rowobj.put("RTL_ENP_NM", "테스트거래처2");//거래처명
			jArr.add(rowobj);
			*/
			
			//mainObj.put("REPT_REC", jArr);
			
			String apiStr = "{\"BIZRNO\":\"2148100777\",\"REPT_REC\":[{\"WHSLD_ENP_NM\":\"(유)남부상사\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3028101184\"},{\"WHSLD_ENP_NM\":\"(유)대신상사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3148111972\"},{\"WHSLD_ENP_NM\":\"(유)대신상사\",\"DLIVY_QTY\":\"168\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3148111972\"},{\"WHSLD_ENP_NM\":\"(유)대신상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3148111972\"},{\"WHSLD_ENP_NM\":\"(유)대신상사\",\"DLIVY_QTY\":\"8820\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3148111972\"},{\"WHSLD_ENP_NM\":\"(유)중앙주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3028105079\"},{\"WHSLD_ENP_NM\":\"(유)중앙주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3028105079\"},{\"WHSLD_ENP_NM\":\"(유)중앙주류\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3028105079\"},{\"WHSLD_ENP_NM\":\"(유)중앙주류\",\"DLIVY_QTY\":\"2320\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3028105079\"},{\"WHSLD_ENP_NM\":\"(유)중앙주류\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3028105079\"},{\"WHSLD_ENP_NM\":\"(유)하나주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068125174\"},{\"WHSLD_ENP_NM\":\"(유)하나주류\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068125174\"},{\"WHSLD_ENP_NM\":\"(자)금산주류합동\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3058102085\"},{\"WHSLD_ENP_NM\":\"(자)금산주류합동\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3058102085\"},{\"WHSLD_ENP_NM\":\"(자)금산주류합동\",\"DLIVY_QTY\":\"24\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3058102085\"},{\"WHSLD_ENP_NM\":\"(자)금산주류합동\",\"DLIVY_QTY\":\"2552\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3058102085\"},{\"WHSLD_ENP_NM\":\"(자)금성종합주류상사\",\"DLIVY_QTY\":\"940\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068115093\"},{\"WHSLD_ENP_NM\":\"(자)금성종합주류상사\",\"DLIVY_QTY\":\"510\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068115093\"},{\"WHSLD_ENP_NM\":\"(자)금성종합주류상사\",\"DLIVY_QTY\":\"24\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068115093\"},{\"WHSLD_ENP_NM\":\"(자)금평주류상사\",\"DLIVY_QTY\":\"180\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068110841\"},{\"WHSLD_ENP_NM\":\"(자)금평주류상사\",\"DLIVY_QTY\":\"7740\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068110841\"},{\"WHSLD_ENP_NM\":\"(자)금평주류상사\",\"DLIVY_QTY\":\"-100\",\"STD_CTNR_CD\":\"211001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068110841\"},{\"WHSLD_ENP_NM\":\"(자)동서주류상사\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3148102449\"},{\"WHSLD_ENP_NM\":\"(자)동서주류상사\",\"DLIVY_QTY\":\"20520\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3148102449\"},{\"WHSLD_ENP_NM\":\"(자)우일종합주류상사\",\"DLIVY_QTY\":\"780\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3148107328\"},{\"WHSLD_ENP_NM\":\"(자)우일종합주류상사\",\"DLIVY_QTY\":\"360\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3148107328\"},{\"WHSLD_ENP_NM\":\"(주)계룡주류상사\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068110481\"},{\"WHSLD_ENP_NM\":\"(주)근대화체인\",\"DLIVY_QTY\":\"5352\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068102720\"},{\"WHSLD_ENP_NM\":\"(주)대전합동상사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068101793\"},{\"WHSLD_ENP_NM\":\"(주)대전합동상사\",\"DLIVY_QTY\":\"11880\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068101793\"},{\"WHSLD_ENP_NM\":\"(주)삼사주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068109892\"},{\"WHSLD_ENP_NM\":\"(주)삼사주류\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068109892\"},{\"WHSLD_ENP_NM\":\"(주)세븐 세종\",\"DLIVY_QTY\":\"8604\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3178510209\"},{\"WHSLD_ENP_NM\":\"(주)장천상사\",\"DLIVY_QTY\":\"570\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3148102814\"},{\"WHSLD_ENP_NM\":\"(주)제일주류합동\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3028100735\"},{\"WHSLD_ENP_NM\":\"(주)제일주류합동\",\"DLIVY_QTY\":\"3040\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3028100735\"},{\"WHSLD_ENP_NM\":\"(주)충청주류상사\",\"DLIVY_QTY\":\"3420\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068106731\"},{\"WHSLD_ENP_NM\":\"(주)충청주류상사\",\"DLIVY_QTY\":\"5760\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068106731\"},{\"WHSLD_ENP_NM\":\"(주)충청주류상사\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068106731\"},{\"WHSLD_ENP_NM\":\"(주)한밭연쇄점\",\"DLIVY_QTY\":\"15600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3058115111\"},{\"WHSLD_ENP_NM\":\"(합)청원주류상사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068130454\"},{\"WHSLD_ENP_NM\":\"(합)청원주류상사\",\"DLIVY_QTY\":\"13110\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068130454\"},{\"WHSLD_ENP_NM\":\"(합)청원주류상사\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3068130454\"},{\"WHSLD_ENP_NM\":\"㈜대전중앙체인\",\"DLIVY_QTY\":\"1512\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3058193908\"},{\"WHSLD_ENP_NM\":\"주식회사 하나체인본부\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3148110987\"},{\"WHSLD_ENP_NM\":\"주식회사 하나체인본부\",\"DLIVY_QTY\":\"7904\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3148110987\"},{\"WHSLD_ENP_NM\":\"현대주류(주)\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3058110912\"},{\"WHSLD_ENP_NM\":\"현대주류(주)\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3058110912\"},{\"WHSLD_ENP_NM\":\"현대주류(주)\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3058110912\"},{\"WHSLD_ENP_NM\":\"(유)동양상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"3138100400\"},{\"WHSLD_ENP_NM\":\"(자)현대주류상사\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"3078106127\"},{\"WHSLD_ENP_NM\":\"(자)현대주류상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"3078106127\"},{\"WHSLD_ENP_NM\":\"(자)현대주류상사\",\"DLIVY_QTY\":\"12\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"3078106127\"},{\"WHSLD_ENP_NM\":\"(자)현대주류상사\",\"DLIVY_QTY\":\"24\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"3078106127\"},{\"WHSLD_ENP_NM\":\"(자)현대주류상사\",\"DLIVY_QTY\":\"1368\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"3078106127\"},{\"WHSLD_ENP_NM\":\"(자)현대주류상사\",\"DLIVY_QTY\":\"11880\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"3078106127\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"900\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"3540\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 세종\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"5368500694\"},{\"WHSLD_ENP_NM\":\"(주)신진\",\"DLIVY_QTY\":\"864\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"3088100451\"},{\"WHSLD_ENP_NM\":\"(주)신진\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"3088100451\"},{\"WHSLD_ENP_NM\":\"(주)신진\",\"DLIVY_QTY\":\"3200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"3088100451\"},{\"WHSLD_ENP_NM\":\"(주)이마트24 세종물류센터\",\"DLIVY_QTY\":\"9800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"3998500251\"},{\"WHSLD_ENP_NM\":\"(합)대두주류상사\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"3138102636\"},{\"WHSLD_ENP_NM\":\"GS25 공주\",\"DLIVY_QTY\":\"1320\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"3078505956\"},{\"WHSLD_ENP_NM\":\"GS25 공주\",\"DLIVY_QTY\":\"24144\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3088504514\",\"WHSLD_BIZRNO\":\"3078505956\"},{\"WHSLD_ENP_NM\":\"(유)안면주류\",\"DLIVY_QTY\":\"40\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3108100982\"},{\"WHSLD_ENP_NM\":\"(유)오비상사\",\"DLIVY_QTY\":\"2960\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3128112238\"},{\"WHSLD_ENP_NM\":\"(유)오비상사\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3128112238\"},{\"WHSLD_ENP_NM\":\"(자)대진상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118100379\"},{\"WHSLD_ENP_NM\":\"(자)대진상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118100379\"},{\"WHSLD_ENP_NM\":\"(자)대진상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118100379\"},{\"WHSLD_ENP_NM\":\"(자)대진상사\",\"DLIVY_QTY\":\"15660\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118100379\"},{\"WHSLD_ENP_NM\":\"(자)대진상사\",\"DLIVY_QTY\":\"3364\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118100379\"},{\"WHSLD_ENP_NM\":\"(자)백락주류상사\",\"DLIVY_QTY\":\"17280\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3128165905\"},{\"WHSLD_ENP_NM\":\"(자)삼화상사\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118100651\"},{\"WHSLD_ENP_NM\":\"(자)삼화상사\",\"DLIVY_QTY\":\"1480\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118100651\"},{\"WHSLD_ENP_NM\":\"(자)삼화상사\",\"DLIVY_QTY\":\"1248\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118100651\"},{\"WHSLD_ENP_NM\":\"(자)삼화상사\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118100651\"},{\"WHSLD_ENP_NM\":\"(자)천원합동\",\"DLIVY_QTY\":\"-30\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3128101051\"},{\"WHSLD_ENP_NM\":\"(자)한길상사\",\"DLIVY_QTY\":\"-30\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3128171858\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부 목천지점\",\"DLIVY_QTY\":\"40056\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3128528382\"},{\"WHSLD_ENP_NM\":\"(주)내성기업\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"2198100772\"},{\"WHSLD_ENP_NM\":\"(주)내성기업\",\"DLIVY_QTY\":\"1200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"2198100772\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"36\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"756\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"17548\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)신도\",\"DLIVY_QTY\":\"3600\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118107576\"},{\"WHSLD_ENP_NM\":\"(주)신도\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118107576\"},{\"WHSLD_ENP_NM\":\"(주)신도\",\"DLIVY_QTY\":\"6450\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118107576\"},{\"WHSLD_ENP_NM\":\"(주)한밭연쇄점천안지점\",\"DLIVY_QTY\":\"400\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3128513967\"},{\"WHSLD_ENP_NM\":\"(합)반도주류상사\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3108120692\"},{\"WHSLD_ENP_NM\":\"(합)반도주류상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3108120692\"},{\"WHSLD_ENP_NM\":\"(합자)삽교대덕\",\"DLIVY_QTY\":\"36\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118100646\"},{\"WHSLD_ENP_NM\":\"(합자)삽교대덕\",\"DLIVY_QTY\":\"13500\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118100646\"},{\"WHSLD_ENP_NM\":\"(합자)삽교대덕\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118100646\"},{\"WHSLD_ENP_NM\":\"㈜청마주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3128625174\"},{\"WHSLD_ENP_NM\":\"㈜청마주류\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3128625174\"},{\"WHSLD_ENP_NM\":\"주식회사 아성주류\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"230201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3128645433\"},{\"WHSLD_ENP_NM\":\"주식회사 아성주류\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3128645433\"},{\"WHSLD_ENP_NM\":\"주식회사유일주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3128102496\"},{\"WHSLD_ENP_NM\":\"주식회사유일주류\",\"DLIVY_QTY\":\"5760\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3128102496\"},{\"WHSLD_ENP_NM\":\"주식회사유일주류\",\"DLIVY_QTY\":\"-420\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3128102496\"},{\"WHSLD_ENP_NM\":\"주식회사중앙체인\",\"DLIVY_QTY\":\"12\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3108123423\"},{\"WHSLD_ENP_NM\":\"주식회사중앙체인\",\"DLIVY_QTY\":\"17952\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3108123423\"},{\"WHSLD_ENP_NM\":\"충남중부수퍼마켓사업협동조합\",\"DLIVY_QTY\":\"800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3118130515\"},{\"WHSLD_ENP_NM\":\"태안주류판매(자)\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3108100809\"},{\"WHSLD_ENP_NM\":\"태안주류판매(자)\",\"DLIVY_QTY\":\"240\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3108100809\"},{\"WHSLD_ENP_NM\":\"태안주류판매(자)\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3108100809\"},{\"WHSLD_ENP_NM\":\"태안주류판매(자)\",\"DLIVY_QTY\":\"4784\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3128541518\",\"WHSLD_BIZRNO\":\"3108100809\"},{\"WHSLD_ENP_NM\":\"(명)대원종합주류상사\",\"DLIVY_QTY\":\"1380\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3018114084\"},{\"WHSLD_ENP_NM\":\"(명)대원종합주류상사\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3018114084\"},{\"WHSLD_ENP_NM\":\"(명)대원종합주류상사\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3018114084\"},{\"WHSLD_ENP_NM\":\"(자)대광주류합동상사\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3018103044\"},{\"WHSLD_ENP_NM\":\"(주)GS25  청주\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"1428506703\"},{\"WHSLD_ENP_NM\":\"(주)GS25  청주\",\"DLIVY_QTY\":\"2800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"1428506703\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"84\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"11072\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)중부한남체인\",\"DLIVY_QTY\":\"7272\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3018112728\"},{\"WHSLD_ENP_NM\":\"(합자)대광\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3028100754\"},{\"WHSLD_ENP_NM\":\"(합자)대광\",\"DLIVY_QTY\":\"2480\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3028100754\"},{\"WHSLD_ENP_NM\":\"(합자)대광\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3028100754\"},{\"WHSLD_ENP_NM\":\"(합자)대광\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3028100754\"},{\"WHSLD_ENP_NM\":\"(합자)동부주류합동\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3158100861\"},{\"WHSLD_ENP_NM\":\"(합자)동부주류합동\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3158100861\"},{\"WHSLD_ENP_NM\":\"(합자)동부주류합동\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3158100861\"},{\"WHSLD_ENP_NM\":\"보은주류합동(자)\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3028102709\"},{\"WHSLD_ENP_NM\":\"보은주류합동(자)\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3028102709\"},{\"WHSLD_ENP_NM\":\"주식회사 우리주류\",\"DLIVY_QTY\":\"180\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3018172274\"},{\"WHSLD_ENP_NM\":\"주식회사 우리주류\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3018172274\"},{\"WHSLD_ENP_NM\":\"주식회사삼화상사\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3158100459\"},{\"WHSLD_ENP_NM\":\"주식회사삼화상사\",\"DLIVY_QTY\":\"2800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3158100459\"},{\"WHSLD_ENP_NM\":\"청원_진로새마을금고\",\"DLIVY_QTY\":\"1300\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3018209706\"},{\"WHSLD_ENP_NM\":\"충북청주수퍼마켓협동조합\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3018206558\"},{\"WHSLD_ENP_NM\":\"충북청주수퍼마켓협동조합\",\"DLIVY_QTY\":\"9056\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3018206558\"},{\"WHSLD_ENP_NM\":\"합자회사음성합동상사\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3038100437\"},{\"WHSLD_ENP_NM\":\"합자회사진천주류합동상사\",\"DLIVY_QTY\":\"7590\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3018101328\"},{\"WHSLD_ENP_NM\":\"합자회사진천주류합동상사\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3178500661\",\"WHSLD_BIZRNO\":\"3018101328\"},{\"WHSLD_ENP_NM\":\"국군복지단(육군면세)\",\"DLIVY_QTY\":\"8472\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4028529379\",\"WHSLD_BIZRNO\":\"1068307115\"},{\"WHSLD_ENP_NM\":\"(명)옥당주류판매\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108101961\"},{\"WHSLD_ENP_NM\":\"(명)옥당주류판매\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108101961\"},{\"WHSLD_ENP_NM\":\"(명)옥당주류판매\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108101961\"},{\"WHSLD_ENP_NM\":\"(유)영진주류\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108127490\"},{\"WHSLD_ENP_NM\":\"(유)진광상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108118308\"},{\"WHSLD_ENP_NM\":\"(유)진광상사\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108118308\"},{\"WHSLD_ENP_NM\":\"(유)진광상사\",\"DLIVY_QTY\":\"11880\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108118308\"},{\"WHSLD_ENP_NM\":\"(유)창업주류합동상사\",\"DLIVY_QTY\":\"5352\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108118235\"},{\"WHSLD_ENP_NM\":\"(유)창업주류합동상사\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108118235\"},{\"WHSLD_ENP_NM\":\"(자)국진상사\",\"DLIVY_QTY\":\"0\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108121929\"},{\"WHSLD_ENP_NM\":\"(자)녹동주류합동\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4138100224\"},{\"WHSLD_ENP_NM\":\"(자)녹동주류합동\",\"DLIVY_QTY\":\"1200\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4138100224\"},{\"WHSLD_ENP_NM\":\"(주)광일종합주류\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4098107795\"},{\"WHSLD_ENP_NM\":\"(주)광주생필체인\",\"DLIVY_QTY\":\"8064\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4098106573\"},{\"WHSLD_ENP_NM\":\"(주)광주생필체인\",\"DLIVY_QTY\":\"21408\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4098106573\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 광주물류센터(전주)\",\"DLIVY_QTY\":\"13152\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"7928500009\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 광주물류센터(전주)\",\"DLIVY_QTY\":\"54060\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"7928500009\"},{\"WHSLD_ENP_NM\":\"(주)만국체인\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108101734\"},{\"WHSLD_ENP_NM\":\"(주)만국체인\",\"DLIVY_QTY\":\"29952\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108101734\"},{\"WHSLD_ENP_NM\":\"(주)만국체인\",\"DLIVY_QTY\":\"15808\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108101734\"},{\"WHSLD_ENP_NM\":\"(주)무등상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108110586\"},{\"WHSLD_ENP_NM\":\"(주)무등상사\",\"DLIVY_QTY\":\"5040\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108110586\"},{\"WHSLD_ENP_NM\":\"(주)무등상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108110586\"},{\"WHSLD_ENP_NM\":\"(주)부성상사\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108104783\"},{\"WHSLD_ENP_NM\":\"(주)부성상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108104783\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 전남지점\",\"DLIVY_QTY\":\"336\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"3818500721\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 전남지점\",\"DLIVY_QTY\":\"8800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"3818500721\"},{\"WHSLD_ENP_NM\":\"(주)이마트24 광주물류센터\",\"DLIVY_QTY\":\"2800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4098535324\"},{\"WHSLD_ENP_NM\":\"(주)호남상사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4088101556\"},{\"WHSLD_ENP_NM\":\"(주)호남상사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4088101556\"},{\"WHSLD_ENP_NM\":\"(주)호남상사\",\"DLIVY_QTY\":\"360\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4088101556\"},{\"WHSLD_ENP_NM\":\"(주)호남상사\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4088101556\"},{\"WHSLD_ENP_NM\":\"(합자)동서주류\",\"DLIVY_QTY\":\"5760\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108111061\"},{\"WHSLD_ENP_NM\":\"(합자)동서주류\",\"DLIVY_QTY\":\"15150\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108111061\"},{\"WHSLD_ENP_NM\":\"(합자)한신주류\",\"DLIVY_QTY\":\"150\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4128100672\"},{\"WHSLD_ENP_NM\":\"(합자)한신주류\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4128100672\"},{\"WHSLD_ENP_NM\":\"GS25장성\",\"DLIVY_QTY\":\"11200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108529195\"},{\"WHSLD_ENP_NM\":\"가든주류\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4098127618\"},{\"WHSLD_ENP_NM\":\"가든주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4098127618\"},{\"WHSLD_ENP_NM\":\"가든주류\",\"DLIVY_QTY\":\"1512\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4098127618\"},{\"WHSLD_ENP_NM\":\"가든주류\",\"DLIVY_QTY\":\"8704\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4098127618\"},{\"WHSLD_ENP_NM\":\"가든주류\",\"DLIVY_QTY\":\"20520\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4098127618\"},{\"WHSLD_ENP_NM\":\"광주광역시수퍼마켓협동조합\",\"DLIVY_QTY\":\"4536\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4098211786\"},{\"WHSLD_ENP_NM\":\"광주맥주판매(주)\",\"DLIVY_QTY\":\"180\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4098117411\"},{\"WHSLD_ENP_NM\":\"광주맥주판매(주)\",\"DLIVY_QTY\":\"2352\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4098117411\"},{\"WHSLD_ENP_NM\":\"광주맥주판매(주)\",\"DLIVY_QTY\":\"3780\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4098117411\"},{\"WHSLD_ENP_NM\":\"광주맥주판매(주)\",\"DLIVY_QTY\":\"32064\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4098117411\"},{\"WHSLD_ENP_NM\":\"광주상사(합자)\",\"DLIVY_QTY\":\"3600\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4088101600\"},{\"WHSLD_ENP_NM\":\"광주상사(합자)\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4088101600\"},{\"WHSLD_ENP_NM\":\"영광판매(주)\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108100905\"},{\"WHSLD_ENP_NM\":\"영광판매(주)\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108100905\"},{\"WHSLD_ENP_NM\":\"영광판매(주)\",\"DLIVY_QTY\":\"2280\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108100905\"},{\"WHSLD_ENP_NM\":\"제일주류(합자)\",\"DLIVY_QTY\":\"240\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4088103495\"},{\"WHSLD_ENP_NM\":\"제일주류(합자)\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4088103495\"},{\"WHSLD_ENP_NM\":\"제일주류(합자)\",\"DLIVY_QTY\":\"12930\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4088103495\"},{\"WHSLD_ENP_NM\":\"한국미니스톱(주)호남지사\",\"DLIVY_QTY\":\"12800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4108508467\",\"WHSLD_BIZRNO\":\"4108509753\"},{\"WHSLD_ENP_NM\":\"(명)낭주상사\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118113096\"},{\"WHSLD_ENP_NM\":\"(유)건국주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118107482\"},{\"WHSLD_ENP_NM\":\"(유)남해상사\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118107522\"},{\"WHSLD_ENP_NM\":\"(유)남해상사\",\"DLIVY_QTY\":\"72\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118107522\"},{\"WHSLD_ENP_NM\":\"(유)대화주류상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118107648\"},{\"WHSLD_ENP_NM\":\"(유)동해주류상사\",\"DLIVY_QTY\":\"540\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158102631\"},{\"WHSLD_ENP_NM\":\"(유)문성상사\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118103088\"},{\"WHSLD_ENP_NM\":\"(유)미래유통\",\"DLIVY_QTY\":\"3952\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118138272\"},{\"WHSLD_ENP_NM\":\"(유)보해물산\",\"DLIVY_QTY\":\"500\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118103109\"},{\"WHSLD_ENP_NM\":\"(유)보해물산\",\"DLIVY_QTY\":\"90\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118103109\"},{\"WHSLD_ENP_NM\":\"(유)보해물산\",\"DLIVY_QTY\":\"750\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118103109\"},{\"WHSLD_ENP_NM\":\"(유)서남주류\",\"DLIVY_QTY\":\"5760\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118107537\"},{\"WHSLD_ENP_NM\":\"(유)서남주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118107537\"},{\"WHSLD_ENP_NM\":\"(유)옥주주류상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158103246\"},{\"WHSLD_ENP_NM\":\"(유)옥주주류상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158103246\"},{\"WHSLD_ENP_NM\":\"(유)옥주주류상사\",\"DLIVY_QTY\":\"1800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158103246\"},{\"WHSLD_ENP_NM\":\"(유)옥주주류상사\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158103246\"},{\"WHSLD_ENP_NM\":\"(유)진도주류상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158105190\"},{\"WHSLD_ENP_NM\":\"(유)진도주류상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158105190\"},{\"WHSLD_ENP_NM\":\"(유)진도주류상사\",\"DLIVY_QTY\":\"1072\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158105190\"},{\"WHSLD_ENP_NM\":\"(유)태흥물산\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118100723\"},{\"WHSLD_ENP_NM\":\"(유)태흥물산\",\"DLIVY_QTY\":\"150\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118100723\"},{\"WHSLD_ENP_NM\":\"(유)태흥물산\",\"DLIVY_QTY\":\"1152\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118100723\"},{\"WHSLD_ENP_NM\":\"(유)호남제일주류\",\"DLIVY_QTY\":\"40\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4128100288\"},{\"WHSLD_ENP_NM\":\"(유)호남제일주류\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4128100288\"},{\"WHSLD_ENP_NM\":\"(유)호남제일주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4128100288\"},{\"WHSLD_ENP_NM\":\"(자)완도주류판매공사\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158100064\"},{\"WHSLD_ENP_NM\":\"(자)완도주류판매공사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158100064\"},{\"WHSLD_ENP_NM\":\"(자)청도주류상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118101590\"},{\"WHSLD_ENP_NM\":\"(자)청도주류상사\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118101590\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 광주물류센터(전주)\",\"DLIVY_QTY\":\"14160\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"7928500009\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 광주물류센터(전주)\",\"DLIVY_QTY\":\"18056\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"7928500009\"},{\"WHSLD_ENP_NM\":\"(주)영산주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118105029\"},{\"WHSLD_ENP_NM\":\"(주)유달상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118100742\"},{\"WHSLD_ENP_NM\":\"(주)유달상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118100742\"},{\"WHSLD_ENP_NM\":\"(주)유달상사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118100742\"},{\"WHSLD_ENP_NM\":\"(합명)청해주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158100332\"},{\"WHSLD_ENP_NM\":\"(합명)탐진주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4148100080\"},{\"WHSLD_ENP_NM\":\"(합명)탐진주류\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4148100080\"},{\"WHSLD_ENP_NM\":\"(합자)신성주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118101571\"},{\"WHSLD_ENP_NM\":\"(합자)신성주류\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118101571\"},{\"WHSLD_ENP_NM\":\"강진주류합명회사\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4148100101\"},{\"WHSLD_ENP_NM\":\"명)노화주류합동\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158100119\"},{\"WHSLD_ENP_NM\":\"보해주류 합명회사\",\"DLIVY_QTY\":\"540\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158100346\"},{\"WHSLD_ENP_NM\":\"유한회사 금천주류\",\"DLIVY_QTY\":\"2520\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118162393\"},{\"WHSLD_ENP_NM\":\"유한회사 영동주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118105048\"},{\"WHSLD_ENP_NM\":\"유한회사 영동주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118105048\"},{\"WHSLD_ENP_NM\":\"전남서부수퍼마켓협동조합\",\"DLIVY_QTY\":\"9552\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4118203746\"},{\"WHSLD_ENP_NM\":\"합명회사 고금주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158135452\"},{\"WHSLD_ENP_NM\":\"합명회사 고금주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158135452\"},{\"WHSLD_ENP_NM\":\"합자회사유성주류상사\",\"DLIVY_QTY\":\"1800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158100569\"},{\"WHSLD_ENP_NM\":\"합자회사유성주류상사\",\"DLIVY_QTY\":\"640\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4118511913\",\"WHSLD_BIZRNO\":\"4158100569\"},{\"WHSLD_ENP_NM\":\"(명)봉황주류\",\"DLIVY_QTY\":\"80\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4138102504\"},{\"WHSLD_ENP_NM\":\"(유)대일주류\",\"DLIVY_QTY\":\"24\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178108801\"},{\"WHSLD_ENP_NM\":\"(유)대일주류\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178108801\"},{\"WHSLD_ENP_NM\":\"(유)대일주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178108801\"},{\"WHSLD_ENP_NM\":\"(유)대한상사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178110520\"},{\"WHSLD_ENP_NM\":\"(유)대한상사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178110520\"},{\"WHSLD_ENP_NM\":\"(유)대한상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178110520\"},{\"WHSLD_ENP_NM\":\"(유)대한상사\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178110520\"},{\"WHSLD_ENP_NM\":\"(유)삼산주류판매상사\",\"DLIVY_QTY\":\"14640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4168111400\"},{\"WHSLD_ENP_NM\":\"(유)삼산주류판매상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4168111400\"},{\"WHSLD_ENP_NM\":\"(유)상운주류\",\"DLIVY_QTY\":\"90\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4168101751\"},{\"WHSLD_ENP_NM\":\"(유)상운주류\",\"DLIVY_QTY\":\"10820\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4168101751\"},{\"WHSLD_ENP_NM\":\"(유)상운주류\",\"DLIVY_QTY\":\"30\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4168101751\"},{\"WHSLD_ENP_NM\":\"(유)한려주류\",\"DLIVY_QTY\":\"3600\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178110495\"},{\"WHSLD_ENP_NM\":\"(유)한려주류\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178110495\"},{\"WHSLD_ENP_NM\":\"(자)진남주류상사\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178100696\"},{\"WHSLD_ENP_NM\":\"(자)진남주류상사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178100696\"},{\"WHSLD_ENP_NM\":\"(자)진남주류상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178100696\"},{\"WHSLD_ENP_NM\":\"(자)진남주류상사\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178100696\"},{\"WHSLD_ENP_NM\":\"(자)진남주류상사\",\"DLIVY_QTY\":\"144\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178100696\"},{\"WHSLD_ENP_NM\":\"(주)공일구체인\",\"DLIVY_QTY\":\"3556\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4168157750\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 광주물류센터(전주)\",\"DLIVY_QTY\":\"5780\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"7928500009\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 광주물류센터(전주)\",\"DLIVY_QTY\":\"5768\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"7928500009\"},{\"WHSLD_ENP_NM\":\"(주)동부주류\",\"DLIVY_QTY\":\"24\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4168109258\"},{\"WHSLD_ENP_NM\":\"(주)하나주류\",\"DLIVY_QTY\":\"5760\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4168100446\"},{\"WHSLD_ENP_NM\":\"(주)하나주류\",\"DLIVY_QTY\":\"4470\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4168100446\"},{\"WHSLD_ENP_NM\":\"(주)하나주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4168100446\"},{\"WHSLD_ENP_NM\":\"(합)광양연합주류\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4168100941\"},{\"WHSLD_ENP_NM\":\"(합)광양연합주류\",\"DLIVY_QTY\":\"5040\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4168100941\"},{\"WHSLD_ENP_NM\":\"(합)광양연합주류\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4168100941\"},{\"WHSLD_ENP_NM\":\"(합)새여수체인\",\"DLIVY_QTY\":\"1680\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178101389\"},{\"WHSLD_ENP_NM\":\"(합)새여수체인\",\"DLIVY_QTY\":\"500\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4178101389\"},{\"WHSLD_ENP_NM\":\"보광주류판매(자)\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4168512450\",\"WHSLD_BIZRNO\":\"4168104312\"},{\"WHSLD_ENP_NM\":\"(유)고창주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4048100332\"},{\"WHSLD_ENP_NM\":\"(유)고창주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4048100332\"},{\"WHSLD_ENP_NM\":\"(유)고창주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4048100332\"},{\"WHSLD_ENP_NM\":\"(유)고창주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4048100332\"},{\"WHSLD_ENP_NM\":\"(유)대광상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4068100100\"},{\"WHSLD_ENP_NM\":\"(유)대광상사\",\"DLIVY_QTY\":\"7200\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4068100100\"},{\"WHSLD_ENP_NM\":\"(유)대광상사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4068100100\"},{\"WHSLD_ENP_NM\":\"(유)대광상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4068100100\"},{\"WHSLD_ENP_NM\":\"(유)대광상사\",\"DLIVY_QTY\":\"11880\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4068100100\"},{\"WHSLD_ENP_NM\":\"(유)동백상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188106747\"},{\"WHSLD_ENP_NM\":\"(유)동보종합주류상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188108691\"},{\"WHSLD_ENP_NM\":\"(유)동보종합주류상사\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188108691\"},{\"WHSLD_ENP_NM\":\"(유)동보종합주류상사\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188108691\"},{\"WHSLD_ENP_NM\":\"(유)동보종합주류상사\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188108691\"},{\"WHSLD_ENP_NM\":\"(유)동양상사\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4078103662\"},{\"WHSLD_ENP_NM\":\"(유)동양상사\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4078103662\"},{\"WHSLD_ENP_NM\":\"(유)동양상사\",\"DLIVY_QTY\":\"5600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4078103662\"},{\"WHSLD_ENP_NM\":\"(유)동양상사\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4078103662\"},{\"WHSLD_ENP_NM\":\"(유)동양상사\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4078103662\"},{\"WHSLD_ENP_NM\":\"(유)마한주류상사\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038101930\"},{\"WHSLD_ENP_NM\":\"(유)무주주류합동상사\",\"DLIVY_QTY\":\"5352\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4068100129\"},{\"WHSLD_ENP_NM\":\"(유)무진상사\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4068102525\"},{\"WHSLD_ENP_NM\":\"(유)무진상사\",\"DLIVY_QTY\":\"2552\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4068102525\"},{\"WHSLD_ENP_NM\":\"(유)백화양주상사\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4028102538\"},{\"WHSLD_ENP_NM\":\"(유)백화양주상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4028102538\"},{\"WHSLD_ENP_NM\":\"(유)백화양주상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4028102538\"},{\"WHSLD_ENP_NM\":\"(유)삼우상사\",\"DLIVY_QTY\":\"180\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038103511\"},{\"WHSLD_ENP_NM\":\"(유)샘물종합주류\",\"DLIVY_QTY\":\"180\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4078100189\"},{\"WHSLD_ENP_NM\":\"(유)세진\",\"DLIVY_QTY\":\"90\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4058105252\"},{\"WHSLD_ENP_NM\":\"(유)세진\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4058105252\"},{\"WHSLD_ENP_NM\":\"(유)세진\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4058105252\"},{\"WHSLD_ENP_NM\":\"(유)세진\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4058105252\"},{\"WHSLD_ENP_NM\":\"(유)세진\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4058105252\"},{\"WHSLD_ENP_NM\":\"(유)승화주류상사\",\"DLIVY_QTY\":\"14040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038109946\"},{\"WHSLD_ENP_NM\":\"(유)승화주류상사\",\"DLIVY_QTY\":\"560\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038109946\"},{\"WHSLD_ENP_NM\":\"(유)신일상사\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188104109\"},{\"WHSLD_ENP_NM\":\"(유)신일상사\",\"DLIVY_QTY\":\"150\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188104109\"},{\"WHSLD_ENP_NM\":\"(유)신일상사\",\"DLIVY_QTY\":\"4580\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188104109\"},{\"WHSLD_ENP_NM\":\"(유)신일상사\",\"DLIVY_QTY\":\"6930\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188104109\"},{\"WHSLD_ENP_NM\":\"(유)신일상사\",\"DLIVY_QTY\":\"400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188104109\"},{\"WHSLD_ENP_NM\":\"(유)신정주류\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038109868\"},{\"WHSLD_ENP_NM\":\"(유)신정주류\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038109868\"},{\"WHSLD_ENP_NM\":\"(유)신정주류\",\"DLIVY_QTY\":\"39420\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038109868\"},{\"WHSLD_ENP_NM\":\"(유)신정주류\",\"DLIVY_QTY\":\"540\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038109868\"},{\"WHSLD_ENP_NM\":\"(유)영진주류판매\",\"DLIVY_QTY\":\"240\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4078103624\"},{\"WHSLD_ENP_NM\":\"(유)영진주류판매\",\"DLIVY_QTY\":\"1200\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4078103624\"},{\"WHSLD_ENP_NM\":\"(유)영진주류판매\",\"DLIVY_QTY\":\"1170\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4078103624\"},{\"WHSLD_ENP_NM\":\"(유)우리주류\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038134843\"},{\"WHSLD_ENP_NM\":\"(유)우리주류\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038134843\"},{\"WHSLD_ENP_NM\":\"(유)우리주류\",\"DLIVY_QTY\":\"25920\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038134843\"},{\"WHSLD_ENP_NM\":\"(유)전주상사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188106714\"},{\"WHSLD_ENP_NM\":\"(유)전주상사\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188106714\"},{\"WHSLD_ENP_NM\":\"(유)전주상사\",\"DLIVY_QTY\":\"24\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188106714\"},{\"WHSLD_ENP_NM\":\"(유)전주상사\",\"DLIVY_QTY\":\"440\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188106714\"},{\"WHSLD_ENP_NM\":\"(유)전주호남주류상사\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188106674\"},{\"WHSLD_ENP_NM\":\"(유)조일주류상사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4018104630\"},{\"WHSLD_ENP_NM\":\"(유)조일주류상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4018104630\"},{\"WHSLD_ENP_NM\":\"(유)조일주류상사\",\"DLIVY_QTY\":\"2480\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4018104630\"},{\"WHSLD_ENP_NM\":\"(유)조일주류상사\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4018104630\"},{\"WHSLD_ENP_NM\":\"(유)천마주류상사\",\"DLIVY_QTY\":\"14400\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038111286\"},{\"WHSLD_ENP_NM\":\"(유)천마주류상사\",\"DLIVY_QTY\":\"38880\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038111286\"},{\"WHSLD_ENP_NM\":\"(유)한국주류상사\",\"DLIVY_QTY\":\"2572\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4028101790\"},{\"WHSLD_ENP_NM\":\"(유)한국주류상사\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4028101790\"},{\"WHSLD_ENP_NM\":\"(유)현대주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4018104514\"},{\"WHSLD_ENP_NM\":\"(유)현대주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4018104514\"},{\"WHSLD_ENP_NM\":\"(유)현대주류\",\"DLIVY_QTY\":\"80\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4018104514\"},{\"WHSLD_ENP_NM\":\"(유)현대주류\",\"DLIVY_QTY\":\"1280\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4018104514\"},{\"WHSLD_ENP_NM\":\"(유)현대주류\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4018104514\"},{\"WHSLD_ENP_NM\":\"(유)현진종합주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4048103509\"},{\"WHSLD_ENP_NM\":\"(유)현진종합주류\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4048103509\"},{\"WHSLD_ENP_NM\":\"(유)현진종합주류\",\"DLIVY_QTY\":\"2864\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4048103509\"},{\"WHSLD_ENP_NM\":\"(유)호남상사\",\"DLIVY_QTY\":\"0\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4058105247\"},{\"WHSLD_ENP_NM\":\"(유)호남상사\",\"DLIVY_QTY\":\"0\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4058105247\"},{\"WHSLD_ENP_NM\":\"(유)호남상사\",\"DLIVY_QTY\":\"0\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4058105247\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 호남지점\",\"DLIVY_QTY\":\"5600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"1398511030\"},{\"WHSLD_ENP_NM\":\"(주)서해주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4018101540\"},{\"WHSLD_ENP_NM\":\"(주)서해주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4018101540\"},{\"WHSLD_ENP_NM\":\"(주)서해주류\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4018101540\"},{\"WHSLD_ENP_NM\":\"(주)서해주류\",\"DLIVY_QTY\":\"1152\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4018101540\"},{\"WHSLD_ENP_NM\":\"(주)한솔체인\",\"DLIVY_QTY\":\"2280\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4028132712\"},{\"WHSLD_ENP_NM\":\"(주)한솔체인\",\"DLIVY_QTY\":\"3880\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4028132712\"},{\"WHSLD_ENP_NM\":\"(주)합동\",\"DLIVY_QTY\":\"880\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038100718\"},{\"WHSLD_ENP_NM\":\"남원제이주류판매 합자회사\",\"DLIVY_QTY\":\"30\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4078100438\"},{\"WHSLD_ENP_NM\":\"남원제이주류판매 합자회사\",\"DLIVY_QTY\":\"380\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4078100438\"},{\"WHSLD_ENP_NM\":\"남원제이주류판매 합자회사\",\"DLIVY_QTY\":\"960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4078100438\"},{\"WHSLD_ENP_NM\":\"유한회사송민체인\",\"DLIVY_QTY\":\"192\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4028161181\"},{\"WHSLD_ENP_NM\":\"유한회사송민체인\",\"DLIVY_QTY\":\"2352\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4028161181\"},{\"WHSLD_ENP_NM\":\"유한회사송민체인\",\"DLIVY_QTY\":\"16712\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4028161181\"},{\"WHSLD_ENP_NM\":\"전북익산수퍼마켓사업협동조합\",\"DLIVY_QTY\":\"3600\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038210998\"},{\"WHSLD_ENP_NM\":\"전북익산수퍼마켓사업협동조합\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038210998\"},{\"WHSLD_ENP_NM\":\"전북익산수퍼마켓사업협동조합\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038210998\"},{\"WHSLD_ENP_NM\":\"전북익산수퍼마켓사업협동조합\",\"DLIVY_QTY\":\"5600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4038210998\"},{\"WHSLD_ENP_NM\":\"전북전주수퍼마켓협동조합\",\"DLIVY_QTY\":\"216\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4028217611\"},{\"WHSLD_ENP_NM\":\"전북전주수퍼마켓협동조합\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4028217611\"},{\"WHSLD_ENP_NM\":\"전북전주수퍼마켓협동조합\",\"DLIVY_QTY\":\"7656\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4028217611\"},{\"WHSLD_ENP_NM\":\"전일슈퍼마켓사업협동조합\",\"DLIVY_QTY\":\"1784\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4188205366\"},{\"WHSLD_ENP_NM\":\"정읍주류판매(주)\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4048100313\"},{\"WHSLD_ENP_NM\":\"출고총량\",\"DLIVY_QTY\":\"-7\",\"STD_CTNR_CD\":\"211202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"0000000000\",\"WHSLD_BIZRNO\":\"0000000000\"},{\"WHSLD_ENP_NM\":\"출고총량\",\"DLIVY_QTY\":\"49596\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"0000000000\",\"WHSLD_BIZRNO\":\"0000000000\"},{\"WHSLD_ENP_NM\":\"출고총량\",\"DLIVY_QTY\":\"397819\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"0000000000\",\"WHSLD_BIZRNO\":\"0000000000\"},{\"WHSLD_ENP_NM\":\"출고총량\",\"DLIVY_QTY\":\"-240\",\"STD_CTNR_CD\":\"310202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"0000000000\",\"WHSLD_BIZRNO\":\"0000000000\"},{\"WHSLD_ENP_NM\":\"출고총량\",\"DLIVY_QTY\":\"-84\",\"STD_CTNR_CD\":\"311202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"0000000000\",\"WHSLD_BIZRNO\":\"0000000000\"},{\"WHSLD_ENP_NM\":\"출고총량\",\"DLIVY_QTY\":\"596320\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"0000000000\",\"WHSLD_BIZRNO\":\"0000000000\"},{\"WHSLD_ENP_NM\":\"출고총량\",\"DLIVY_QTY\":\"564480\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"0000000000\",\"WHSLD_BIZRNO\":\"0000000000\"},{\"WHSLD_ENP_NM\":\"출고총량\",\"DLIVY_QTY\":\"2020\",\"STD_CTNR_CD\":\"230201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"0000000000\",\"WHSLD_BIZRNO\":\"0000000000\"},{\"WHSLD_ENP_NM\":\"출고총량\",\"DLIVY_QTY\":\"10480\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"0000000000\",\"WHSLD_BIZRNO\":\"0000000000\"},{\"WHSLD_ENP_NM\":\"출고총량\",\"DLIVY_QTY\":\"-210\",\"STD_CTNR_CD\":\"210001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"0000000000\",\"WHSLD_BIZRNO\":\"0000000000\"},{\"WHSLD_ENP_NM\":\"출고총량\",\"DLIVY_QTY\":\"-100\",\"STD_CTNR_CD\":\"211001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"0000000000\",\"WHSLD_BIZRNO\":\"0000000000\"},{\"WHSLD_ENP_NM\":\"출고총량\",\"DLIVY_QTY\":\"2993596\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"0000000000\",\"WHSLD_BIZRNO\":\"0000000000\"},{\"WHSLD_ENP_NM\":\"출고총량\",\"DLIVY_QTY\":\"4464102\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"0000000000\",\"WHSLD_BIZRNO\":\"0000000000\"},{\"WHSLD_ENP_NM\":\"(유)동화상사\",\"DLIVY_QTY\":\"2200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1278106439\"},{\"WHSLD_ENP_NM\":\"(유)보광주류상사\",\"DLIVY_QTY\":\"5040\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1368110960\"},{\"WHSLD_ENP_NM\":\"(유)보광주류상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1368110960\"},{\"WHSLD_ENP_NM\":\"(유)보광주류상사\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1368110960\"},{\"WHSLD_ENP_NM\":\"(주)광덕상사\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1228123637\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부 목천지점\",\"DLIVY_QTY\":\"24732\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"3128528382\"},{\"WHSLD_ENP_NM\":\"(주)대양상사\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1378111865\"},{\"WHSLD_ENP_NM\":\"(주)대양상사\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1378111865\"},{\"WHSLD_ENP_NM\":\"(주)대화주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1308128706\"},{\"WHSLD_ENP_NM\":\"(주)대화주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1308128706\"},{\"WHSLD_ENP_NM\":\"(주)대화주류\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1308128706\"},{\"WHSLD_ENP_NM\":\"(주)동영\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1318104823\"},{\"WHSLD_ENP_NM\":\"(주)동영\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1318104823\"},{\"WHSLD_ENP_NM\":\"(주)부평상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1228111596\"},{\"WHSLD_ENP_NM\":\"(주)부평상사\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1228111596\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 인천\",\"DLIVY_QTY\":\"11760\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"7378500579\"},{\"WHSLD_ENP_NM\":\"(주)삼성주류\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1318129498\"},{\"WHSLD_ENP_NM\":\"(주)삼화주류\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1218132040\"},{\"WHSLD_ENP_NM\":\"(주)삼화주류\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1218132040\"},{\"WHSLD_ENP_NM\":\"(주)삼화주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1218132040\"},{\"WHSLD_ENP_NM\":\"(주)삼화주류\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1218132040\"},{\"WHSLD_ENP_NM\":\"(주)서울로직\",\"DLIVY_QTY\":\"12136\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1268612802\"},{\"WHSLD_ENP_NM\":\"(주)세븐 인천\",\"DLIVY_QTY\":\"192\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"3178511872\"},{\"WHSLD_ENP_NM\":\"(주)세븐 인천\",\"DLIVY_QTY\":\"3564\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"3178511872\"},{\"WHSLD_ENP_NM\":\"(주)영진체인본부\",\"DLIVY_QTY\":\"527\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1318108741\"},{\"WHSLD_ENP_NM\":\"(주)영진체인본부\",\"DLIVY_QTY\":\"-12\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1318108741\"},{\"WHSLD_ENP_NM\":\"(주)영진체인본부\",\"DLIVY_QTY\":\"-7\",\"STD_CTNR_CD\":\"211202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1318108741\"},{\"WHSLD_ENP_NM\":\"(주)영진체인본부\",\"DLIVY_QTY\":\"-36\",\"STD_CTNR_CD\":\"311202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1318108741\"},{\"WHSLD_ENP_NM\":\"(주)영진체인본부\",\"DLIVY_QTY\":\"55488\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1318108741\"},{\"WHSLD_ENP_NM\":\"(주)이마트24 인천물류센터\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"2348500949\"},{\"WHSLD_ENP_NM\":\"(주)이마트24 인천물류센터\",\"DLIVY_QTY\":\"1000\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"2348500949\"},{\"WHSLD_ENP_NM\":\"(주)인합상사\",\"DLIVY_QTY\":\"210\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1218110518\"},{\"WHSLD_ENP_NM\":\"(주)인화상사\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1318106175\"},{\"WHSLD_ENP_NM\":\"(주)제일상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1218105261\"},{\"WHSLD_ENP_NM\":\"(주)제일상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1218105261\"},{\"WHSLD_ENP_NM\":\"(주)제일상사\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1218105261\"},{\"WHSLD_ENP_NM\":\"(주)중부상사\",\"DLIVY_QTY\":\"27000\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1218114945\"},{\"WHSLD_ENP_NM\":\"(주)중부상사\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1218114945\"},{\"WHSLD_ENP_NM\":\"(주)진양상사\",\"DLIVY_QTY\":\"17280\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1398106280\"},{\"WHSLD_ENP_NM\":\"(주)청남\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"2048176208\"},{\"WHSLD_ENP_NM\":\"(주)청남\",\"DLIVY_QTY\":\"16008\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"2048176208\"},{\"WHSLD_ENP_NM\":\"(주)체인팝\",\"DLIVY_QTY\":\"91056\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1378102842\"},{\"WHSLD_ENP_NM\":\"(주)합동상사\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1318108886\"},{\"WHSLD_ENP_NM\":\"(주)현진상사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1218115814\"},{\"WHSLD_ENP_NM\":\"(주)현진상사\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1218115814\"},{\"WHSLD_ENP_NM\":\"(주)현진상사\",\"DLIVY_QTY\":\"18360\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1218115814\"},{\"WHSLD_ENP_NM\":\"(주)현진상사\",\"DLIVY_QTY\":\"9160\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1218115814\"},{\"WHSLD_ENP_NM\":\"(합명)금파주류\",\"DLIVY_QTY\":\"11880\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1368105813\"},{\"WHSLD_ENP_NM\":\"(합명)심도상사\",\"DLIVY_QTY\":\"360\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1368103469\"},{\"WHSLD_ENP_NM\":\"GS25 인천1\",\"DLIVY_QTY\":\"15800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1378503140\"},{\"WHSLD_ENP_NM\":\"경기김포수퍼마켓협동조합\",\"DLIVY_QTY\":\"960\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1378206603\"},{\"WHSLD_ENP_NM\":\"경기김포수퍼마켓협동조합\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1378206603\"},{\"WHSLD_ENP_NM\":\"경기김포수퍼마켓협동조합\",\"DLIVY_QTY\":\"6788\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1378206603\"},{\"WHSLD_ENP_NM\":\"연일주류 주식회사\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1378164187\"},{\"WHSLD_ENP_NM\":\"유한회사 술파는사람들\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1308128536\"},{\"WHSLD_ENP_NM\":\"이전유통(주)\",\"DLIVY_QTY\":\"52208\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1288116696\"},{\"WHSLD_ENP_NM\":\"인천상사(주)\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1228134449\"},{\"WHSLD_ENP_NM\":\"인천시수퍼마켓협동조합\",\"DLIVY_QTY\":\"-48\",\"STD_CTNR_CD\":\"311202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1318204140\"},{\"WHSLD_ENP_NM\":\"인천시수퍼마켓협동조합\",\"DLIVY_QTY\":\"-12\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1318204140\"},{\"WHSLD_ENP_NM\":\"인천시수퍼마켓협동조합\",\"DLIVY_QTY\":\"-180\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1318204140\"},{\"WHSLD_ENP_NM\":\"인천시수퍼마켓협동조합\",\"DLIVY_QTY\":\"13396\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1318204140\"},{\"WHSLD_ENP_NM\":\"주식회사 삼광주류\",\"DLIVY_QTY\":\"380\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1398109161\"},{\"WHSLD_ENP_NM\":\"주식회사 삼광주류\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1398109161\"},{\"WHSLD_ENP_NM\":\"정읍주류판매(주)\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4048100313\"},{\"WHSLD_ENP_NM\":\"정읍주류판매(주)\",\"DLIVY_QTY\":\"2520\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4048100313\"},{\"WHSLD_ENP_NM\":\"정읍주류판매(주)\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4048100313\"},{\"WHSLD_ENP_NM\":\"협신상사(주)\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4058100558\"},{\"WHSLD_ENP_NM\":\"협신상사(주)\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4058100558\"},{\"WHSLD_ENP_NM\":\"협신상사(주)\",\"DLIVY_QTY\":\"5760\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188502036\",\"WHSLD_BIZRNO\":\"4058100558\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 광주물류센터(전주)\",\"DLIVY_QTY\":\"14280\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188508781\",\"WHSLD_BIZRNO\":\"7928500009\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 광주물류센터(전주)\",\"DLIVY_QTY\":\"13000\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"4188508781\",\"WHSLD_BIZRNO\":\"7928500009\"},{\"WHSLD_ENP_NM\":\"(유)대경주류\",\"DLIVY_QTY\":\"2190\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038123705\"},{\"WHSLD_ENP_NM\":\"(자)제일상사\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5048103681\"},{\"WHSLD_ENP_NM\":\"(주)경북유통\",\"DLIVY_QTY\":\"1512\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148109339\"},{\"WHSLD_ENP_NM\":\"(주)경북유통\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148109339\"},{\"WHSLD_ENP_NM\":\"(주)경상유통\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5158100762\"},{\"WHSLD_ENP_NM\":\"(주)경상유통\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5158100762\"},{\"WHSLD_ENP_NM\":\"(주)경상유통\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5158100762\"},{\"WHSLD_ENP_NM\":\"(주)경상유통\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5158100762\"},{\"WHSLD_ENP_NM\":\"(주)대경유통\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5048110009\"},{\"WHSLD_ENP_NM\":\"(주)대경유통\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5048110009\"},{\"WHSLD_ENP_NM\":\"(주)대경유통\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5048110009\"},{\"WHSLD_ENP_NM\":\"(주)대구백화점체인사업\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5048502531\"},{\"WHSLD_ENP_NM\":\"(주)대구백화점체인사업\",\"DLIVY_QTY\":\"10208\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5048502531\"},{\"WHSLD_ENP_NM\":\"(주)대림주류유통\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028122697\"},{\"WHSLD_ENP_NM\":\"(주)대림주류유통\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028122697\"},{\"WHSLD_ENP_NM\":\"(주)대명상사\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5018108504\"},{\"WHSLD_ENP_NM\":\"(주)대양종합주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028113596\"},{\"WHSLD_ENP_NM\":\"(주)대양종합주류\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028113596\"},{\"WHSLD_ENP_NM\":\"(주)대인체인본부\",\"DLIVY_QTY\":\"2232\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5158103018\"},{\"WHSLD_ENP_NM\":\"(주)대인체인본부\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5158103018\"},{\"WHSLD_ENP_NM\":\"(주)동양주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038102336\"},{\"WHSLD_ENP_NM\":\"(주)동양주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038102336\"},{\"WHSLD_ENP_NM\":\"(주)부국\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038122730\"},{\"WHSLD_ENP_NM\":\"(주)부국\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038122730\"},{\"WHSLD_ENP_NM\":\"(주)부국\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038122730\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 칠곡지점\",\"DLIVY_QTY\":\"1512\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"1838500597\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 칠곡지점\",\"DLIVY_QTY\":\"8132\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"1838500597\"},{\"WHSLD_ENP_NM\":\"(주)산동상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5158100802\"},{\"WHSLD_ENP_NM\":\"(주)산동상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5158100802\"},{\"WHSLD_ENP_NM\":\"(주)산동상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5158100802\"},{\"WHSLD_ENP_NM\":\"(주)신영유통\",\"DLIVY_QTY\":\"3816\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028106891\"},{\"WHSLD_ENP_NM\":\"(주)신영유통\",\"DLIVY_QTY\":\"6752\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028106891\"},{\"WHSLD_ENP_NM\":\"(주)신우유통\",\"DLIVY_QTY\":\"3288\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5058101110\"},{\"WHSLD_ENP_NM\":\"(주)신우유통\",\"DLIVY_QTY\":\"42560\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5058101110\"},{\"WHSLD_ENP_NM\":\"(주)에스엠종합주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028126373\"},{\"WHSLD_ENP_NM\":\"(주)에스엠종합주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028126373\"},{\"WHSLD_ENP_NM\":\"(주)에스엠종합주류\",\"DLIVY_QTY\":\"5040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028126373\"},{\"WHSLD_ENP_NM\":\"(주)영남유통\",\"DLIVY_QTY\":\"2800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5048102794\"},{\"WHSLD_ENP_NM\":\"(주)이마트24칠곡물류센터\",\"DLIVY_QTY\":\"1600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5138533455\"},{\"WHSLD_ENP_NM\":\"(주)중앙주류\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028122663\"},{\"WHSLD_ENP_NM\":\"(주)중앙주류\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028122663\"},{\"WHSLD_ENP_NM\":\"(주)중앙주류\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028122663\"},{\"WHSLD_ENP_NM\":\"(주)지에스리테일 경산물류센터\",\"DLIVY_QTY\":\"9800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5138501841\"},{\"WHSLD_ENP_NM\":\"(주)청구주류\",\"DLIVY_QTY\":\"900\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028113510\"},{\"WHSLD_ENP_NM\":\"(주)청구주류\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028113510\"},{\"WHSLD_ENP_NM\":\"(주)청구주류\",\"DLIVY_QTY\":\"1200\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028113510\"},{\"WHSLD_ENP_NM\":\"(주)평화주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148120033\"},{\"WHSLD_ENP_NM\":\"(주)평화주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148120033\"},{\"WHSLD_ENP_NM\":\"(주)평화주류\",\"DLIVY_QTY\":\"5040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148120033\"},{\"WHSLD_ENP_NM\":\"(주)한국주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028114616\"},{\"WHSLD_ENP_NM\":\"(주)한국주류\",\"DLIVY_QTY\":\"2310\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028114616\"},{\"WHSLD_ENP_NM\":\"(주)한국주류\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028114616\"},{\"WHSLD_ENP_NM\":\"(주)한성상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148108927\"},{\"WHSLD_ENP_NM\":\"(주)한성상사\",\"DLIVY_QTY\":\"1140\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148108927\"},{\"WHSLD_ENP_NM\":\"(주)한성상사\",\"DLIVY_QTY\":\"3780\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148108927\"},{\"WHSLD_ENP_NM\":\"(주)화창주류\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038129145\"},{\"WHSLD_ENP_NM\":\"(주)화창주류\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038129145\"},{\"WHSLD_ENP_NM\":\"(주)화창주류\",\"DLIVY_QTY\":\"3780\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038129145\"},{\"WHSLD_ENP_NM\":\"(합자)명성상사\",\"DLIVY_QTY\":\"1540\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148115258\"},{\"WHSLD_ENP_NM\":\"(합자)명성상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148115258\"},{\"WHSLD_ENP_NM\":\"(합자)명성상사\",\"DLIVY_QTY\":\"3780\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148115258\"},{\"WHSLD_ENP_NM\":\"경북주류판매(주)\",\"DLIVY_QTY\":\"1000\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038122384\"},{\"WHSLD_ENP_NM\":\"경북주류판매(주)\",\"DLIVY_QTY\":\"3000\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038122384\"},{\"WHSLD_ENP_NM\":\"고령진흥합자회사\",\"DLIVY_QTY\":\"180\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038102393\"},{\"WHSLD_ENP_NM\":\"고령진흥합자회사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038102393\"},{\"WHSLD_ENP_NM\":\"고령진흥합자회사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038102393\"},{\"WHSLD_ENP_NM\":\"고령진흥합자회사\",\"DLIVY_QTY\":\"1260\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038102393\"},{\"WHSLD_ENP_NM\":\"국제주류판매(주)\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5048106558\"},{\"WHSLD_ENP_NM\":\"주식회사 삼광주류\",\"DLIVY_QTY\":\"2800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1398109161\"},{\"WHSLD_ENP_NM\":\"주식회사 삼광주류\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1398109161\"},{\"WHSLD_ENP_NM\":\"주식회사 심도\",\"DLIVY_QTY\":\"15420\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"7258100205\"},{\"WHSLD_ENP_NM\":\"주식회사성진상사\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1378132026\"},{\"WHSLD_ENP_NM\":\"주식회사훈성유통\",\"DLIVY_QTY\":\"30944\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"1098141665\"},{\"WHSLD_ENP_NM\":\"한국미니스톱(주)인천\",\"DLIVY_QTY\":\"4200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1218513847\",\"WHSLD_BIZRNO\":\"4998500401\"},{\"WHSLD_ENP_NM\":\"(유) 광덕주류\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1348109910\"},{\"WHSLD_ENP_NM\":\"(유) 광성주류\",\"DLIVY_QTY\":\"1140\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1338115914\"},{\"WHSLD_ENP_NM\":\"(유) 광성주류\",\"DLIVY_QTY\":\"1480\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1338115914\"},{\"WHSLD_ENP_NM\":\"(유) 광성주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1338115914\"},{\"WHSLD_ENP_NM\":\"(유) 삼진주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1348109865\"},{\"WHSLD_ENP_NM\":\"(유) 시화주류\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1348116309\"},{\"WHSLD_ENP_NM\":\"(유) 안흥주류\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1338123073\"},{\"WHSLD_ENP_NM\":\"(유) 제일유통\",\"DLIVY_QTY\":\"240\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1338115990\"},{\"WHSLD_ENP_NM\":\"(유) 제일유통\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1338115990\"},{\"WHSLD_ENP_NM\":\"(유) 제일유통\",\"DLIVY_QTY\":\"20700\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1338115990\"},{\"WHSLD_ENP_NM\":\"(유) 태영주류\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"230201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1348607519\"},{\"WHSLD_ENP_NM\":\"(유) 태영주류\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1348607519\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부 목천지점\",\"DLIVY_QTY\":\"7386\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"3128528382\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부 목천지점\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"3128528382\"},{\"WHSLD_ENP_NM\":\"(주)내성기업\",\"DLIVY_QTY\":\"2448\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"2198100772\"},{\"WHSLD_ENP_NM\":\"(주)대영주류\",\"DLIVY_QTY\":\"16200\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1138123045\"},{\"WHSLD_ENP_NM\":\"(주)서울로직\",\"DLIVY_QTY\":\"6936\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1268612802\"},{\"WHSLD_ENP_NM\":\"(주)서울중앙체인본부\",\"DLIVY_QTY\":\"1344\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1138119653\"},{\"WHSLD_ENP_NM\":\"(주)서울중앙체인본부\",\"DLIVY_QTY\":\"33600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1138119653\"},{\"WHSLD_ENP_NM\":\"(주)세계주류\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1098137496\"},{\"WHSLD_ENP_NM\":\"(주)세계주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1098137496\"},{\"WHSLD_ENP_NM\":\"(주)세계주류\",\"DLIVY_QTY\":\"41040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1098137496\"},{\"WHSLD_ENP_NM\":\"(합명)탑주류\",\"DLIVY_QTY\":\"56160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1348105286\"},{\"WHSLD_ENP_NM\":\"㈜ 대림종합주류\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1408104851\"},{\"WHSLD_ENP_NM\":\"㈜ 대성주류\",\"DLIVY_QTY\":\"150\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1348160839\"},{\"WHSLD_ENP_NM\":\"㈜ 신명상사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1348116328\"},{\"WHSLD_ENP_NM\":\"㈜ 양지유통체인\",\"DLIVY_QTY\":\"2016\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1348113035\"},{\"WHSLD_ENP_NM\":\"㈜ 양지유통체인\",\"DLIVY_QTY\":\"53680\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1348113035\"},{\"WHSLD_ENP_NM\":\"건국종합주류 ㈜\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1348191083\"},{\"WHSLD_ENP_NM\":\"군포주류(유)\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1238109661\"},{\"WHSLD_ENP_NM\":\"군포주류(유)\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1238109661\"},{\"WHSLD_ENP_NM\":\"군포주류(유)\",\"DLIVY_QTY\":\"1700\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1238109661\"},{\"WHSLD_ENP_NM\":\"대인상사(유)\",\"DLIVY_QTY\":\"11880\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1388105987\"},{\"WHSLD_ENP_NM\":\"백산주류 (유)\",\"DLIVY_QTY\":\"1260\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1388100890\"},{\"WHSLD_ENP_NM\":\"백산주류 (유)\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1388100890\"},{\"WHSLD_ENP_NM\":\"삼부주류(유)\",\"DLIVY_QTY\":\"49680\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1188104494\"},{\"WHSLD_ENP_NM\":\"삼부주류(유)\",\"DLIVY_QTY\":\"40\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1188104494\"},{\"WHSLD_ENP_NM\":\"삼정주류 ㈜\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1238116916\"},{\"WHSLD_ENP_NM\":\"삼정주류 ㈜\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1238116916\"},{\"WHSLD_ENP_NM\":\"성원주류 (유)\",\"DLIVY_QTY\":\"2280\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1338104421\"},{\"WHSLD_ENP_NM\":\"성원주류 (유)\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1338104421\"},{\"WHSLD_ENP_NM\":\"성원주류 (유)\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1338104421\"},{\"WHSLD_ENP_NM\":\"안산시수퍼마켓협동조합\",\"DLIVY_QTY\":\"32112\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1348203965\"},{\"WHSLD_ENP_NM\":\"유한회사 금강\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1348126087\"},{\"WHSLD_ENP_NM\":\"유한회사 금강\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1348126087\"},{\"WHSLD_ENP_NM\":\"유한회사 대한주류\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1348109899\"},{\"WHSLD_ENP_NM\":\"유한회사 현대종합주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"2678100733\"},{\"WHSLD_ENP_NM\":\"유한회사 현대종합주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"2678100733\"},{\"WHSLD_ENP_NM\":\"유한회사 현대종합주류\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"2678100733\"},{\"WHSLD_ENP_NM\":\"유한회사대연주류\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1238193820\"},{\"WHSLD_ENP_NM\":\"주식회사 대건주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1238103411\"},{\"WHSLD_ENP_NM\":\"주식회사 대건주류\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1238103411\"},{\"WHSLD_ENP_NM\":\"주식회사 동부주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1408184699\"},{\"WHSLD_ENP_NM\":\"주식회사 동부주류\",\"DLIVY_QTY\":\"180\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1408184699\"},{\"WHSLD_ENP_NM\":\"주식회사 동부주류\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1408184699\"},{\"WHSLD_ENP_NM\":\"주식회사 바로물류\",\"DLIVY_QTY\":\"1344\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"3058190556\"},{\"WHSLD_ENP_NM\":\"주식회사 바로물류\",\"DLIVY_QTY\":\"6256\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"3058190556\"},{\"WHSLD_ENP_NM\":\"주식회사 케이엘유통\",\"DLIVY_QTY\":\"792\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1388179515\"},{\"WHSLD_ENP_NM\":\"주식회사 케이엘유통\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1388179515\"},{\"WHSLD_ENP_NM\":\"진양주류 (유한)\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1238109680\"},{\"WHSLD_ENP_NM\":\"포도주류(유)\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1238193835\"},{\"WHSLD_ENP_NM\":\"포도주류(유)\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1238193835\"},{\"WHSLD_ENP_NM\":\"포도주류(유)\",\"DLIVY_QTY\":\"33480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1238193835\"},{\"WHSLD_ENP_NM\":\"한국미니스톱(주)안양\",\"DLIVY_QTY\":\"5600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1168163309\"},{\"WHSLD_ENP_NM\":\"흥안주류유한회사\",\"DLIVY_QTY\":\"420\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1388100828\"},{\"WHSLD_ENP_NM\":\"흥안주류유한회사\",\"DLIVY_QTY\":\"7580\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1238536604\",\"WHSLD_BIZRNO\":\"1388100828\"},{\"WHSLD_ENP_NM\":\"(유)대성주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258125105\"},{\"WHSLD_ENP_NM\":\"(유)대성주류\",\"DLIVY_QTY\":\"11880\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258125105\"},{\"WHSLD_ENP_NM\":\"(유)서호주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248138664\"},{\"WHSLD_ENP_NM\":\"(유)서호주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248138664\"},{\"WHSLD_ENP_NM\":\"국제주류판매(주)\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5048106558\"},{\"WHSLD_ENP_NM\":\"농협하나로유통경북사업소군위물류센터\",\"DLIVY_QTY\":\"540\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"6608500022\"},{\"WHSLD_ENP_NM\":\"달성기업합자회사\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148101055\"},{\"WHSLD_ENP_NM\":\"대가합자회사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038105240\"},{\"WHSLD_ENP_NM\":\"대가합자회사\",\"DLIVY_QTY\":\"180\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038105240\"},{\"WHSLD_ENP_NM\":\"대가합자회사\",\"DLIVY_QTY\":\"3780\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038105240\"},{\"WHSLD_ENP_NM\":\"대구주류판매주식회사\",\"DLIVY_QTY\":\"1000\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5018102456\"},{\"WHSLD_ENP_NM\":\"대구주류판매주식회사\",\"DLIVY_QTY\":\"1200\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5018102456\"},{\"WHSLD_ENP_NM\":\"대양산업주식회사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5058100770\"},{\"WHSLD_ENP_NM\":\"대양산업주식회사\",\"DLIVY_QTY\":\"2760\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5058100770\"},{\"WHSLD_ENP_NM\":\"대양산업주식회사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5058100770\"},{\"WHSLD_ENP_NM\":\"대양산업주식회사\",\"DLIVY_QTY\":\"4140\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5058100770\"},{\"WHSLD_ENP_NM\":\"대양산업주식회사\",\"DLIVY_QTY\":\"2640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5058100770\"},{\"WHSLD_ENP_NM\":\"대하주류판매주식회사\",\"DLIVY_QTY\":\"11520\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5048109725\"},{\"WHSLD_ENP_NM\":\"대한슈퍼체인주식회사\",\"DLIVY_QTY\":\"2184\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038107874\"},{\"WHSLD_ENP_NM\":\"대한슈퍼체인주식회사\",\"DLIVY_QTY\":\"9700\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038107874\"},{\"WHSLD_ENP_NM\":\"북부주류판매주식회사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5048101892\"},{\"WHSLD_ENP_NM\":\"북부주류판매주식회사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5048101892\"},{\"WHSLD_ENP_NM\":\"신흥기업합자회사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148102511\"},{\"WHSLD_ENP_NM\":\"신흥기업합자회사\",\"DLIVY_QTY\":\"780\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148102511\"},{\"WHSLD_ENP_NM\":\"신흥기업합자회사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148102511\"},{\"WHSLD_ENP_NM\":\"신흥기업합자회사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5148102511\"},{\"WHSLD_ENP_NM\":\"영천주류판매(주)\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5058101726\"},{\"WHSLD_ENP_NM\":\"영천주류판매(주)\",\"DLIVY_QTY\":\"2250\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5058101726\"},{\"WHSLD_ENP_NM\":\"영천주류판매(주)\",\"DLIVY_QTY\":\"5040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5058101726\"},{\"WHSLD_ENP_NM\":\"오성주류판매(주)\",\"DLIVY_QTY\":\"3540\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5018111066\"},{\"WHSLD_ENP_NM\":\"오성주류판매(주)\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5018111066\"},{\"WHSLD_ENP_NM\":\"오성주류판매(주)\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5018111066\"},{\"WHSLD_ENP_NM\":\"주식회사 남부주류\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5158100781\"},{\"WHSLD_ENP_NM\":\"주식회사 남부주류\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5158100781\"},{\"WHSLD_ENP_NM\":\"주식회사대구현대화체인본부\",\"DLIVY_QTY\":\"336\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038107364\"},{\"WHSLD_ENP_NM\":\"주식회사대구현대화체인본부\",\"DLIVY_QTY\":\"6852\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5038107364\"},{\"WHSLD_ENP_NM\":\"합자회사 삼화산업\",\"DLIVY_QTY\":\"4300\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028103031\"},{\"WHSLD_ENP_NM\":\"합자회사 삼화산업\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028103031\"},{\"WHSLD_ENP_NM\":\"합자회사 삼화산업\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5028502063\",\"WHSLD_BIZRNO\":\"5028103031\"},{\"WHSLD_ENP_NM\":\"(자)동양주류\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5058105606\"},{\"WHSLD_ENP_NM\":\"(자)동양주류\",\"DLIVY_QTY\":\"30\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5058105606\"},{\"WHSLD_ENP_NM\":\"(자)서부기업\",\"DLIVY_QTY\":\"396\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5058100746\"},{\"WHSLD_ENP_NM\":\"(자)서부기업\",\"DLIVY_QTY\":\"3600\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5058100746\"},{\"WHSLD_ENP_NM\":\"(자)서부기업\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5058100746\"},{\"WHSLD_ENP_NM\":\"(자)서부기업\",\"DLIVY_QTY\":\"2520\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5058100746\"},{\"WHSLD_ENP_NM\":\"(자)영일만상사\",\"DLIVY_QTY\":\"30240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068122189\"},{\"WHSLD_ENP_NM\":\"(자)영일만상사\",\"DLIVY_QTY\":\"10080\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068122189\"},{\"WHSLD_ENP_NM\":\"(자)제일주류\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5078100645\"},{\"WHSLD_ENP_NM\":\"(자)제일주류\",\"DLIVY_QTY\":\"2240\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5078100645\"},{\"WHSLD_ENP_NM\":\"(자)제일주류\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5078100645\"},{\"WHSLD_ENP_NM\":\"(자)한국주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068118759\"},{\"WHSLD_ENP_NM\":\"(자)한국주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068118759\"},{\"WHSLD_ENP_NM\":\"(자)한국주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068118759\"},{\"WHSLD_ENP_NM\":\"(주)경주현대화체인본부\",\"DLIVY_QTY\":\"1920\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5058102405\"},{\"WHSLD_ENP_NM\":\"(주)경주현대화체인본부\",\"DLIVY_QTY\":\"11600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5058102405\"},{\"WHSLD_ENP_NM\":\"(주)대하유통\",\"DLIVY_QTY\":\"1152\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068105235\"},{\"WHSLD_ENP_NM\":\"(주)삼풍기업\",\"DLIVY_QTY\":\"3600\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068104672\"},{\"WHSLD_ENP_NM\":\"(주)삼풍기업\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068104672\"},{\"WHSLD_ENP_NM\":\"(주)삼풍기업\",\"DLIVY_QTY\":\"8820\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068104672\"},{\"WHSLD_ENP_NM\":\"(주)포항종합\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068101087\"},{\"WHSLD_ENP_NM\":\"(주)포항종합\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068101087\"},{\"WHSLD_ENP_NM\":\"농협하나로유통경북사업소군위물류센터\",\"DLIVY_QTY\":\"3320\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"6608500022\"},{\"WHSLD_ENP_NM\":\"농협하나로유통경북사업소군위물류센터\",\"DLIVY_QTY\":\"400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"6608500022\"},{\"WHSLD_ENP_NM\":\"동도주류판매(주)\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"230201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5058104984\"},{\"WHSLD_ENP_NM\":\"영덕주류 합명회사\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5078100188\"},{\"WHSLD_ENP_NM\":\"포항시수퍼마켓협동조합\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068205514\"},{\"WHSLD_ENP_NM\":\"포항시수퍼마켓협동조합\",\"DLIVY_QTY\":\"7992\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068205514\"},{\"WHSLD_ENP_NM\":\"현대주류판매(자)\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068108080\"},{\"WHSLD_ENP_NM\":\"현대주류판매(자)\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068108080\"},{\"WHSLD_ENP_NM\":\"현대주류판매(자)\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068108080\"},{\"WHSLD_ENP_NM\":\"현대주류판매(자)\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5068518494\",\"WHSLD_BIZRNO\":\"5068108080\"},{\"WHSLD_ENP_NM\":\"(주)극동주류\",\"DLIVY_QTY\":\"460\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5098102047\"},{\"WHSLD_ENP_NM\":\"(주)극동주류\",\"DLIVY_QTY\":\"320\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5098102047\"},{\"WHSLD_ENP_NM\":\"(주)극동주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5098102047\"},{\"WHSLD_ENP_NM\":\"(주)대동주류상사\",\"DLIVY_QTY\":\"80\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5088103761\"},{\"WHSLD_ENP_NM\":\"(주)대동주류상사\",\"DLIVY_QTY\":\"1260\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5088103761\"},{\"WHSLD_ENP_NM\":\"(주)백산유통\",\"DLIVY_QTY\":\"1800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5118101736\"},{\"WHSLD_ENP_NM\":\"(주)안동중앙주류\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5088101249\"},{\"WHSLD_ENP_NM\":\"(주)협신주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5098101539\"},{\"WHSLD_ENP_NM\":\"(유)서호주류\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248138664\"},{\"WHSLD_ENP_NM\":\"(유)서호주류\",\"DLIVY_QTY\":\"4200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248138664\"},{\"WHSLD_ENP_NM\":\"(유)세계주류\",\"DLIVY_QTY\":\"1620\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248138698\"},{\"WHSLD_ENP_NM\":\"(유)세계주류\",\"DLIVY_QTY\":\"360\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248138698\"},{\"WHSLD_ENP_NM\":\"(유)세계주류\",\"DLIVY_QTY\":\"21600\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248138698\"},{\"WHSLD_ENP_NM\":\"(유)안성종합주류\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258107674\"},{\"WHSLD_ENP_NM\":\"(유)한진주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248639090\"},{\"WHSLD_ENP_NM\":\"(유한)병점주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248128259\"},{\"WHSLD_ENP_NM\":\"(유한)병점주류\",\"DLIVY_QTY\":\"16200\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248128259\"},{\"WHSLD_ENP_NM\":\"(자)현대주류\",\"DLIVY_QTY\":\"17280\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258118832\"},{\"WHSLD_ENP_NM\":\"(주)건영주류\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258165368\"},{\"WHSLD_ENP_NM\":\"(주)건영주류\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258165368\"},{\"WHSLD_ENP_NM\":\"(주)건영주류\",\"DLIVY_QTY\":\"25896\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258165368\"},{\"WHSLD_ENP_NM\":\"(주)경기남부유통\",\"DLIVY_QTY\":\"14160\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258104416\"},{\"WHSLD_ENP_NM\":\"(주)경기현대화연쇄점\",\"DLIVY_QTY\":\"168\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248106236\"},{\"WHSLD_ENP_NM\":\"(주)경기현대화연쇄점\",\"DLIVY_QTY\":\"15152\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248106236\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부 목천지점\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"3128528382\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부 목천지점\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"3128528382\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부 목천지점\",\"DLIVY_QTY\":\"27920\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"3128528382\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부 목천지점\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"3128528382\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"2352\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"58088\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 안성\",\"DLIVY_QTY\":\"5800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1418520814\"},{\"WHSLD_ENP_NM\":\"(주)삼성에이플러스\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"2048136152\"},{\"WHSLD_ENP_NM\":\"(주)삼성에이플러스\",\"DLIVY_QTY\":\"68\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"2048136152\"},{\"WHSLD_ENP_NM\":\"(주)서울로직\",\"DLIVY_QTY\":\"156\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1268612802\"},{\"WHSLD_ENP_NM\":\"(주)서울로직\",\"DLIVY_QTY\":\"3770\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1268612802\"},{\"WHSLD_ENP_NM\":\"(주)영광주류\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248177425\"},{\"WHSLD_ENP_NM\":\"(주)우리에프엔비\",\"DLIVY_QTY\":\"36624\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248673346\"},{\"WHSLD_ENP_NM\":\"(주)평택주류\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258102062\"},{\"WHSLD_ENP_NM\":\"(주)평택주류\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258102062\"},{\"WHSLD_ENP_NM\":\"(주)평택주류\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258102062\"},{\"WHSLD_ENP_NM\":\"(주)합동주류\",\"DLIVY_QTY\":\"3560\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258101141\"},{\"WHSLD_ENP_NM\":\"(주)합동주류\",\"DLIVY_QTY\":\"14040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258101141\"},{\"WHSLD_ENP_NM\":\"(주)혜성주류\",\"DLIVY_QTY\":\"14100\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248138591\"},{\"WHSLD_ENP_NM\":\"(주)혜성주류\",\"DLIVY_QTY\":\"22680\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248138591\"},{\"WHSLD_ENP_NM\":\"GS발안 SSM\",\"DLIVY_QTY\":\"1584\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248569938\"},{\"WHSLD_ENP_NM\":\"GS발안 SSM\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248569938\"},{\"WHSLD_ENP_NM\":\"GS발안 SSM\",\"DLIVY_QTY\":\"55544\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248569938\"},{\"WHSLD_ENP_NM\":\"경기남부수퍼마켓협동조합\",\"DLIVY_QTY\":\"12352\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248232691\"},{\"WHSLD_ENP_NM\":\"낙원주류 합명회사\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258102043\"},{\"WHSLD_ENP_NM\":\"낙원주류 합명회사\",\"DLIVY_QTY\":\"624\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258102043\"},{\"WHSLD_ENP_NM\":\"낙원주류 합명회사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258102043\"},{\"WHSLD_ENP_NM\":\"낙원주류 합명회사\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258102043\"},{\"WHSLD_ENP_NM\":\"낙원주류 합명회사\",\"DLIVY_QTY\":\"23760\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258102043\"},{\"WHSLD_ENP_NM\":\"동원주류판매(주)\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248132414\"},{\"WHSLD_ENP_NM\":\"씨에스유통(주)\",\"DLIVY_QTY\":\"1344\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"2048136642\"},{\"WHSLD_ENP_NM\":\"씨에스유통(주)\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"2048136642\"},{\"WHSLD_ENP_NM\":\"씨에스유통(주)\",\"DLIVY_QTY\":\"9216\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"2048136642\"},{\"WHSLD_ENP_NM\":\"안중주류(유)\",\"DLIVY_QTY\":\"16200\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1258115382\"},{\"WHSLD_ENP_NM\":\"유한회사 광교주류\",\"DLIVY_QTY\":\"96\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248615007\"},{\"WHSLD_ENP_NM\":\"유한회사 광교주류\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248615007\"},{\"WHSLD_ENP_NM\":\"유한회사 광교주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248615007\"},{\"WHSLD_ENP_NM\":\"유한회사 동광상사\",\"DLIVY_QTY\":\"17280\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248602176\"},{\"WHSLD_ENP_NM\":\"유한회사 새한주류\",\"DLIVY_QTY\":\"16200\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248177459\"},{\"WHSLD_ENP_NM\":\"유한회사 성일주류\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1358166398\"},{\"WHSLD_ENP_NM\":\"주식회사 경기종합주류\",\"DLIVY_QTY\":\"10080\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1358100057\"},{\"WHSLD_ENP_NM\":\"주식회사 경기종합주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1358100057\"},{\"WHSLD_ENP_NM\":\"주식회사 바이더웨이(경인)\",\"DLIVY_QTY\":\"1800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1358525319\"},{\"WHSLD_ENP_NM\":\"주식회사 수성주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248139488\"},{\"WHSLD_ENP_NM\":\"주식회사 수성주류\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"230201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248139488\"},{\"WHSLD_ENP_NM\":\"주식회사 수성주류\",\"DLIVY_QTY\":\"11880\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248139488\"},{\"WHSLD_ENP_NM\":\"주식회사 수성주류\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1248510266\",\"WHSLD_BIZRNO\":\"1248139488\"},{\"WHSLD_ENP_NM\":\"(주)다산주류\",\"DLIVY_QTY\":\"21600\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268501875\",\"WHSLD_BIZRNO\":\"1188103272\"},{\"WHSLD_ENP_NM\":\"(합명)해동상사\",\"DLIVY_QTY\":\"21600\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268501875\",\"WHSLD_BIZRNO\":\"1218140050\"},{\"WHSLD_ENP_NM\":\"주식회사 대정\",\"DLIVY_QTY\":\"64800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268501875\",\"WHSLD_BIZRNO\":\"1128100205\"},{\"WHSLD_ENP_NM\":\"(유)금강주류\",\"DLIVY_QTY\":\"3000\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2058121628\"},{\"WHSLD_ENP_NM\":\"(유)금강주류\",\"DLIVY_QTY\":\"67072\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2058121628\"},{\"WHSLD_ENP_NM\":\"(유)금강주류\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2058121628\"},{\"WHSLD_ENP_NM\":\"(유)동천주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"1148148355\"},{\"WHSLD_ENP_NM\":\"(유)동천주류\",\"DLIVY_QTY\":\"25920\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"1148148355\"},{\"WHSLD_ENP_NM\":\"(유)보경실업\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2178100081\"},{\"WHSLD_ENP_NM\":\"(유)보경실업\",\"DLIVY_QTY\":\"72\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2178100081\"},{\"WHSLD_ENP_NM\":\"(유)보경실업\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2178100081\"},{\"WHSLD_ENP_NM\":\"(유)보광주류상사\",\"DLIVY_QTY\":\"1200\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2298113819\"},{\"WHSLD_ENP_NM\":\"(주)협신주류\",\"DLIVY_QTY\":\"1660\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5098101539\"},{\"WHSLD_ENP_NM\":\"(주)협신주류\",\"DLIVY_QTY\":\"1260\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5098101539\"},{\"WHSLD_ENP_NM\":\"(합자)제일실업\",\"DLIVY_QTY\":\"0\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5088100798\"},{\"WHSLD_ENP_NM\":\"(합자)태성기업\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5128100706\"},{\"WHSLD_ENP_NM\":\"(합자)태성기업\",\"DLIVY_QTY\":\"5760\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5128100706\"},{\"WHSLD_ENP_NM\":\"(합자)태성기업\",\"DLIVY_QTY\":\"5040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5128100706\"},{\"WHSLD_ENP_NM\":\"경북영주수퍼마켓협동조합\",\"DLIVY_QTY\":\"1680\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5128205009\"},{\"WHSLD_ENP_NM\":\"경북영주수퍼마켓협동조합\",\"DLIVY_QTY\":\"2660\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5128205009\"},{\"WHSLD_ENP_NM\":\"농협하나로유통경북사업소군위물류센터\",\"DLIVY_QTY\":\"1200\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"6608500022\"},{\"WHSLD_ENP_NM\":\"농협하나로유통경북사업소군위물류센터\",\"DLIVY_QTY\":\"1100\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"6608500022\"},{\"WHSLD_ENP_NM\":\"봉화기업합명회사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5128100439\"},{\"WHSLD_ENP_NM\":\"봉화기업합명회사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5128100439\"},{\"WHSLD_ENP_NM\":\"봉화기업합명회사\",\"DLIVY_QTY\":\"1560\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5128100439\"},{\"WHSLD_ENP_NM\":\"봉화기업합명회사\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5128100439\"},{\"WHSLD_ENP_NM\":\"안동주류판매주식회사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5088100459\"},{\"WHSLD_ENP_NM\":\"영양기업합자회사\",\"DLIVY_QTY\":\"1920\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5088100444\"},{\"WHSLD_ENP_NM\":\"영양기업합자회사\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5088100444\"},{\"WHSLD_ENP_NM\":\"영양기업합자회사\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5088100444\"},{\"WHSLD_ENP_NM\":\"유한회사가은기업\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5118100547\"},{\"WHSLD_ENP_NM\":\"주식회사영남주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5088100541\"},{\"WHSLD_ENP_NM\":\"주식회사영남주류\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5088100541\"},{\"WHSLD_ENP_NM\":\"주식회사영남주류\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5088100541\"},{\"WHSLD_ENP_NM\":\"주식회사영남주류\",\"DLIVY_QTY\":\"7200\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5088100541\"},{\"WHSLD_ENP_NM\":\"청송기업합자회사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5088100430\"},{\"WHSLD_ENP_NM\":\"청송기업합자회사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5088100430\"},{\"WHSLD_ENP_NM\":\"청송기업합자회사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5088100430\"},{\"WHSLD_ENP_NM\":\"합자회사영광기업\",\"DLIVY_QTY\":\"10080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5088506752\",\"WHSLD_BIZRNO\":\"5128100778\"},{\"WHSLD_ENP_NM\":\"(유)보성주류상사\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5138520299\",\"WHSLD_BIZRNO\":\"5118101018\"},{\"WHSLD_ENP_NM\":\"(유)보성주류상사\",\"DLIVY_QTY\":\"210\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5138520299\",\"WHSLD_BIZRNO\":\"5118101018\"},{\"WHSLD_ENP_NM\":\"(유)보성주류상사\",\"DLIVY_QTY\":\"450\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5138520299\",\"WHSLD_BIZRNO\":\"5118101018\"},{\"WHSLD_ENP_NM\":\"(유)상주기업\",\"DLIVY_QTY\":\"1560\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5138520299\",\"WHSLD_BIZRNO\":\"5118100566\"},{\"WHSLD_ENP_NM\":\"(유)상주기업\",\"DLIVY_QTY\":\"3270\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5138520299\",\"WHSLD_BIZRNO\":\"5118100566\"},{\"WHSLD_ENP_NM\":\"(유)상주기업\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5138520299\",\"WHSLD_BIZRNO\":\"5118100566\"},{\"WHSLD_ENP_NM\":\"(유)상주기업\",\"DLIVY_QTY\":\"776\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5138520299\",\"WHSLD_BIZRNO\":\"5118100566\"},{\"WHSLD_ENP_NM\":\"(유)상주기업\",\"DLIVY_QTY\":\"1260\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5138520299\",\"WHSLD_BIZRNO\":\"5118100566\"},{\"WHSLD_ENP_NM\":\"(유)함창기업\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5138520299\",\"WHSLD_BIZRNO\":\"5118100571\"},{\"WHSLD_ENP_NM\":\"(유)함창기업\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5138520299\",\"WHSLD_BIZRNO\":\"5118100571\"},{\"WHSLD_ENP_NM\":\"(주)신화기업\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5138520299\",\"WHSLD_BIZRNO\":\"5118102040\"},{\"WHSLD_ENP_NM\":\"(주)중앙체인\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5138520299\",\"WHSLD_BIZRNO\":\"5138104608\"},{\"WHSLD_ENP_NM\":\"(주)중앙체인\",\"DLIVY_QTY\":\"400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5138520299\",\"WHSLD_BIZRNO\":\"5138104608\"},{\"WHSLD_ENP_NM\":\"농협하나로유통경북사업소군위물류센터\",\"DLIVY_QTY\":\"6540\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5138520299\",\"WHSLD_BIZRNO\":\"6608500022\"},{\"WHSLD_ENP_NM\":\"농협하나로유통경북사업소군위물류센터\",\"DLIVY_QTY\":\"960\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"5138520299\",\"WHSLD_BIZRNO\":\"6608500022\"},{\"WHSLD_ENP_NM\":\"(유한)매일상사\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6228100376\"},{\"WHSLD_ENP_NM\":\"(유한)매일상사\",\"DLIVY_QTY\":\"3600\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6228100376\"},{\"WHSLD_ENP_NM\":\"(유한)한진상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6058112144\"},{\"WHSLD_ENP_NM\":\"(유한)한진상사\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6058112144\"},{\"WHSLD_ENP_NM\":\"(자)남산주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6038121875\"},{\"WHSLD_ENP_NM\":\"(자)남산주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6038121875\"},{\"WHSLD_ENP_NM\":\"(자)남산주류\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6038121875\"},{\"WHSLD_ENP_NM\":\"(자)동림상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6068106951\"},{\"WHSLD_ENP_NM\":\"(자)동림상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6068106951\"},{\"WHSLD_ENP_NM\":\"(주)국일\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6058102423\"},{\"WHSLD_ENP_NM\":\"(주)국일\",\"DLIVY_QTY\":\"3600\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6058102423\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 경남사업소\",\"DLIVY_QTY\":\"2136\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"7558500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 경남사업소\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"7558500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 경남사업소\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"7558500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 경남사업소\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"7558500015\"},{\"WHSLD_ENP_NM\":\"(주)대일상사\",\"DLIVY_QTY\":\"1560\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6038109435\"},{\"WHSLD_ENP_NM\":\"(주)대일상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6038109435\"},{\"WHSLD_ENP_NM\":\"(주)대일상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6038109435\"},{\"WHSLD_ENP_NM\":\"(주)동일주류상사\",\"DLIVY_QTY\":\"150\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6038109279\"},{\"WHSLD_ENP_NM\":\"(주)동일주류상사\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6038109279\"},{\"WHSLD_ENP_NM\":\"(주)동일주류상사\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"230201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6038109279\"},{\"WHSLD_ENP_NM\":\"(주)메가마트언양지점\",\"DLIVY_QTY\":\"1512\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6208503531\"},{\"WHSLD_ENP_NM\":\"(주)바로코사유통사하\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"1228161081\"},{\"WHSLD_ENP_NM\":\"(주)바로코사유통사하\",\"DLIVY_QTY\":\"1512\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"1228161081\"},{\"WHSLD_ENP_NM\":\"(주)백마\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6178100414\"},{\"WHSLD_ENP_NM\":\"(주)백마\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6178100414\"},{\"WHSLD_ENP_NM\":\"(주)부국상사\",\"DLIVY_QTY\":\"90\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6018126568\"},{\"WHSLD_ENP_NM\":\"(주)부국상사\",\"DLIVY_QTY\":\"320\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6018126568\"},{\"WHSLD_ENP_NM\":\"(주)부림\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6058112746\"},{\"WHSLD_ENP_NM\":\"(주)부산근대화연쇄점\",\"DLIVY_QTY\":\"2184\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6178101015\"},{\"WHSLD_ENP_NM\":\"(주)부산근대화연쇄점\",\"DLIVY_QTY\":\"9552\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6178101015\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일양산지점\",\"DLIVY_QTY\":\"1512\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6618500705\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일양산지점\",\"DLIVY_QTY\":\"2992\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6618500705\"},{\"WHSLD_ENP_NM\":\"(유)보광주류상사\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2298113819\"},{\"WHSLD_ENP_NM\":\"(유)서광상사\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2138174510\"},{\"WHSLD_ENP_NM\":\"(유)서광상사\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2138174510\"},{\"WHSLD_ENP_NM\":\"(유)서광상사\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2138174510\"},{\"WHSLD_ENP_NM\":\"(유)선진주류\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2128129574\"},{\"WHSLD_ENP_NM\":\"(유)선진주류\",\"DLIVY_QTY\":\"2800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2128129574\"},{\"WHSLD_ENP_NM\":\"(유)선진주류\",\"DLIVY_QTY\":\"18360\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2128129574\"},{\"WHSLD_ENP_NM\":\"(유)성두유통\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"1148158019\"},{\"WHSLD_ENP_NM\":\"(유)성두유통\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"1148158019\"},{\"WHSLD_ENP_NM\":\"(유)송화주류상사\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2158139538\"},{\"WHSLD_ENP_NM\":\"(유)송화주류상사\",\"DLIVY_QTY\":\"40\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2158139538\"},{\"WHSLD_ENP_NM\":\"(유)송화주류상사\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2158139538\"},{\"WHSLD_ENP_NM\":\"(유)송화주류상사\",\"DLIVY_QTY\":\"40\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2158139538\"},{\"WHSLD_ENP_NM\":\"(유)신동주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2128165911\"},{\"WHSLD_ENP_NM\":\"(유)신동주류\",\"DLIVY_QTY\":\"14220\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2128165911\"},{\"WHSLD_ENP_NM\":\"(유)중앙종합주류\",\"DLIVY_QTY\":\"17280\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2158632428\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부\",\"DLIVY_QTY\":\"2800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2198108717\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부 목천지점\",\"DLIVY_QTY\":\"2642\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"3128528382\"},{\"WHSLD_ENP_NM\":\"(주)내성기업\",\"DLIVY_QTY\":\"3624\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2198100772\"},{\"WHSLD_ENP_NM\":\"(주)대도연쇄점본부\",\"DLIVY_QTY\":\"9304\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2108118824\"},{\"WHSLD_ENP_NM\":\"(주)대박종합주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2108118047\"},{\"WHSLD_ENP_NM\":\"(주)대박종합주류\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2108118047\"},{\"WHSLD_ENP_NM\":\"(주)대성유통\",\"DLIVY_QTY\":\"3360\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2058111436\"},{\"WHSLD_ENP_NM\":\"(주)대성유통\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2058111436\"},{\"WHSLD_ENP_NM\":\"(주)대성유통\",\"DLIVY_QTY\":\"54992\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2058111436\"},{\"WHSLD_ENP_NM\":\"(주)대진유통\",\"DLIVY_QTY\":\"4032\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2158101390\"},{\"WHSLD_ENP_NM\":\"(주)대진유통\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2158101390\"},{\"WHSLD_ENP_NM\":\"(주)동원체인\",\"DLIVY_QTY\":\"9800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2128133307\"},{\"WHSLD_ENP_NM\":\"(주)라인상사\",\"DLIVY_QTY\":\"1308\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2158146252\"},{\"WHSLD_ENP_NM\":\"(주)라인상사\",\"DLIVY_QTY\":\"-48\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2158146252\"},{\"WHSLD_ENP_NM\":\"(주)라인상사\",\"DLIVY_QTY\":\"8400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2158146252\"},{\"WHSLD_ENP_NM\":\"(주)마당쇠유통\",\"DLIVY_QTY\":\"22400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2048175529\"},{\"WHSLD_ENP_NM\":\"(주)민선종합주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2068194764\"},{\"WHSLD_ENP_NM\":\"(주)민선종합주류\",\"DLIVY_QTY\":\"25920\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2068194764\"},{\"WHSLD_ENP_NM\":\"(주)백억주류상사\",\"DLIVY_QTY\":\"3480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2158663580\"},{\"WHSLD_ENP_NM\":\"(주)부원주류\",\"DLIVY_QTY\":\"3880\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"1058103499\"},{\"WHSLD_ENP_NM\":\"(주)부원주류\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"1058103499\"},{\"WHSLD_ENP_NM\":\"(주)부흥물산\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2158100784\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 남양주\",\"DLIVY_QTY\":\"7000\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"7098500633\"},{\"WHSLD_ENP_NM\":\"(주)산호주류\",\"DLIVY_QTY\":\"21600\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"1098188641\"},{\"WHSLD_ENP_NM\":\"(주)삼성주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"1138137267\"},{\"WHSLD_ENP_NM\":\"(주)삼성주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"1138137267\"},{\"WHSLD_ENP_NM\":\"(주)삼성주류\",\"DLIVY_QTY\":\"11880\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"1138137267\"},{\"WHSLD_ENP_NM\":\"(주)서울로직\",\"DLIVY_QTY\":\"2232\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"1268612802\"},{\"WHSLD_ENP_NM\":\"(주)서초식품\",\"DLIVY_QTY\":\"1500\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2138125566\"},{\"WHSLD_ENP_NM\":\"(주)신내종합주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2168107567\"},{\"WHSLD_ENP_NM\":\"(주)신내종합주류\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2168107567\"},{\"WHSLD_ENP_NM\":\"(주)신내종합주류\",\"DLIVY_QTY\":\"19440\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2168107567\"},{\"WHSLD_ENP_NM\":\"(주)해성주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2148117827\"},{\"WHSLD_ENP_NM\":\"(주)해성주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2148117827\"},{\"WHSLD_ENP_NM\":\"(주)해성주류\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2148117827\"},{\"WHSLD_ENP_NM\":\"GS25 남양주1\",\"DLIVY_QTY\":\"168\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"1328513605\"},{\"WHSLD_ENP_NM\":\"GS25 남양주1\",\"DLIVY_QTY\":\"22400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"1328513605\"},{\"WHSLD_ENP_NM\":\"경성종합주류 주식회사\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"5468100368\"},{\"WHSLD_ENP_NM\":\"경성종합주류 주식회사\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"5468100368\"},{\"WHSLD_ENP_NM\":\"동성주류\",\"DLIVY_QTY\":\"0\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2198103255\"},{\"WHSLD_ENP_NM\":\"동성주류\",\"DLIVY_QTY\":\"0\",\"STD_CTNR_CD\":\"230201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2198103255\"},{\"WHSLD_ENP_NM\":\"동성주류\",\"DLIVY_QTY\":\"0\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2198103255\"},{\"WHSLD_ENP_NM\":\"동풍상사(주)\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2128100354\"},{\"WHSLD_ENP_NM\":\"동풍상사(주)\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2128100354\"},{\"WHSLD_ENP_NM\":\"세왕상사(주)\",\"DLIVY_QTY\":\"5040\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2198119529\"},{\"WHSLD_ENP_NM\":\"세왕상사(주)\",\"DLIVY_QTY\":\"30240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2198119529\"},{\"WHSLD_ENP_NM\":\"신승상사(주)\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2208101335\"},{\"WHSLD_ENP_NM\":\"신승상사(주)\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2208101335\"},{\"WHSLD_ENP_NM\":\"신승상사(주)\",\"DLIVY_QTY\":\"20520\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2208101335\"},{\"WHSLD_ENP_NM\":\"우성식품(주)\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2078105003\"},{\"WHSLD_ENP_NM\":\"우성식품(주)\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2078105003\"},{\"WHSLD_ENP_NM\":\"우성식품(주)\",\"DLIVY_QTY\":\"180\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2078105003\"},{\"WHSLD_ENP_NM\":\"임창상사주식회사\",\"DLIVY_QTY\":\"3340\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"1068124158\"},{\"WHSLD_ENP_NM\":\"정산주류(주)\",\"DLIVY_QTY\":\"150\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2128600529\"},{\"WHSLD_ENP_NM\":\"정산주류(주)\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2128600529\"},{\"WHSLD_ENP_NM\":\"주식회사 유송체인\",\"DLIVY_QTY\":\"1344\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2048139009\"},{\"WHSLD_ENP_NM\":\"풍원식품(주)\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2078108086\"},{\"WHSLD_ENP_NM\":\"합명회사강남양행\",\"DLIVY_QTY\":\"2310\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2108118407\"},{\"WHSLD_ENP_NM\":\"합명회사강남양행\",\"DLIVY_QTY\":\"2260\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2108118407\"},{\"WHSLD_ENP_NM\":\"합명회사강남양행\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531893\",\"WHSLD_BIZRNO\":\"2108118407\"},{\"WHSLD_ENP_NM\":\"(유)대원\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1298109219\"},{\"WHSLD_ENP_NM\":\"(주)생필체인\",\"DLIVY_QTY\":\"16464\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6078107050\"},{\"WHSLD_ENP_NM\":\"(주)생필체인\",\"DLIVY_QTY\":\"21672\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6078107050\"},{\"WHSLD_ENP_NM\":\"(주)생필체인\",\"DLIVY_QTY\":\"1200\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6078107050\"},{\"WHSLD_ENP_NM\":\"(주)서원홀딩스중부지점\",\"DLIVY_QTY\":\"3360\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6068507088\"},{\"WHSLD_ENP_NM\":\"(주)서원홀딩스중부지점\",\"DLIVY_QTY\":\"27816\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6068507088\"},{\"WHSLD_ENP_NM\":\"(주)신우\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6068134840\"},{\"WHSLD_ENP_NM\":\"(주)신우\",\"DLIVY_QTY\":\"2520\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6068134840\"},{\"WHSLD_ENP_NM\":\"(주)신우\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6068134840\"},{\"WHSLD_ENP_NM\":\"(주)이마트24 양산물류센터\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6158533824\"},{\"WHSLD_ENP_NM\":\"(주)이마트24 양산물류센터\",\"DLIVY_QTY\":\"1600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6158533824\"},{\"WHSLD_ENP_NM\":\"(주)지에스리테일 김해물류센터\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"8228500203\"},{\"WHSLD_ENP_NM\":\"(주)지에스리테일 김해물류센터\",\"DLIVY_QTY\":\"4200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"8228500203\"},{\"WHSLD_ENP_NM\":\"(주)지에스리테일cvs\",\"DLIVY_QTY\":\"2352\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6218501588\"},{\"WHSLD_ENP_NM\":\"(주)지에스리테일cvs\",\"DLIVY_QTY\":\"2824\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6218501588\"},{\"WHSLD_ENP_NM\":\"(주)해림상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6038151044\"},{\"WHSLD_ENP_NM\":\"(주)해림상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6038151044\"},{\"WHSLD_ENP_NM\":\"(주)해림상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6038151044\"},{\"WHSLD_ENP_NM\":\"(합자)세일주류\",\"DLIVY_QTY\":\"9360\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6218112961\"},{\"WHSLD_ENP_NM\":\"(합자)세일주류\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6218112961\"},{\"WHSLD_ENP_NM\":\"(합자)우성종합주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6078121014\"},{\"WHSLD_ENP_NM\":\"(합자)우성종합주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6078121014\"},{\"WHSLD_ENP_NM\":\"(합자)우성종합주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6078121014\"},{\"WHSLD_ENP_NM\":\"(합자)제일주류\",\"DLIVY_QTY\":\"-2070\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6218112904\"},{\"WHSLD_ENP_NM\":\"(합자)제일주류\",\"DLIVY_QTY\":\"0\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6218112904\"},{\"WHSLD_ENP_NM\":\"대도실업(주)\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6068111416\"},{\"WHSLD_ENP_NM\":\"대도실업(주)\",\"DLIVY_QTY\":\"400\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6068111416\"},{\"WHSLD_ENP_NM\":\"부산서부슈퍼마켓협동조합\",\"DLIVY_QTY\":\"1512\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6018203975\"},{\"WHSLD_ENP_NM\":\"부산서부슈퍼마켓협동조합\",\"DLIVY_QTY\":\"1320\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6018203975\"},{\"WHSLD_ENP_NM\":\"삼덕주류판매(주)\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6038116241\"},{\"WHSLD_ENP_NM\":\"코리아세븐_언양상온센타\",\"DLIVY_QTY\":\"520\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6208518387\"},{\"WHSLD_ENP_NM\":\"코리아세븐_언양상온센타\",\"DLIVY_QTY\":\"2000\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6208518387\"},{\"WHSLD_ENP_NM\":\"한국미니스톱(주)영남지점\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6078522888\"},{\"WHSLD_ENP_NM\":\"한국미니스톱(주)영남지점\",\"DLIVY_QTY\":\"9924\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6078522888\"},{\"WHSLD_ENP_NM\":\"현대상사(주)\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6038104143\"},{\"WHSLD_ENP_NM\":\"현대상사(주)\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6068521737\",\"WHSLD_BIZRNO\":\"6038104143\"},{\"WHSLD_ENP_NM\":\"(유한)대동상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6048109632\"},{\"WHSLD_ENP_NM\":\"(유한)대동상사\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6048109632\"},{\"WHSLD_ENP_NM\":\"(유한)대동상사\",\"DLIVY_QTY\":\"1680\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6048109632\"},{\"WHSLD_ENP_NM\":\"(유한)대동상사\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6048109632\"},{\"WHSLD_ENP_NM\":\"(유한)청림상사\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078129864\"},{\"WHSLD_ENP_NM\":\"(유한)한진상사\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"230201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6058112144\"},{\"WHSLD_ENP_NM\":\"(자)삼정상사\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6218102594\"},{\"WHSLD_ENP_NM\":\"(주)대림\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078124383\"},{\"WHSLD_ENP_NM\":\"(주)대림\",\"DLIVY_QTY\":\"1380\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078124383\"},{\"WHSLD_ENP_NM\":\"(주)대림\",\"DLIVY_QTY\":\"1560\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078124383\"},{\"WHSLD_ENP_NM\":\"(주)대림\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078124383\"},{\"WHSLD_ENP_NM\":\"(주)동양종합주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6038127016\"},{\"WHSLD_ENP_NM\":\"(주)바로코사유통사하\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"1228161081\"},{\"WHSLD_ENP_NM\":\"(주)바로코사유통사하\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"1228161081\"},{\"WHSLD_ENP_NM\":\"(주)부덕종합주류\",\"DLIVY_QTY\":\"30240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078107889\"},{\"WHSLD_ENP_NM\":\"(주)부성종합주류\",\"DLIVY_QTY\":\"180\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078170529\"},{\"WHSLD_ENP_NM\":\"(주)세창상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078118993\"},{\"WHSLD_ENP_NM\":\"(주)세창상사\",\"DLIVY_QTY\":\"40\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078118993\"},{\"WHSLD_ENP_NM\":\"(주)해동주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6188100722\"},{\"WHSLD_ENP_NM\":\"(주)해동주류\",\"DLIVY_QTY\":\"5760\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6188100722\"},{\"WHSLD_ENP_NM\":\"(합명)미래종합주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078111933\"},{\"WHSLD_ENP_NM\":\"(합명)미래종합주류\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078111933\"},{\"WHSLD_ENP_NM\":\"(합명)미래종합주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078111933\"},{\"WHSLD_ENP_NM\":\"(합명)미래종합주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078111933\"},{\"WHSLD_ENP_NM\":\"(합자)금호상사\",\"DLIVY_QTY\":\"13110\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6218107959\"},{\"WHSLD_ENP_NM\":\"(합자)금호상사\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6218107959\"},{\"WHSLD_ENP_NM\":\"(합자)부경주류\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6178113904\"},{\"WHSLD_ENP_NM\":\"(합자)부경주류\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6178113904\"},{\"WHSLD_ENP_NM\":\"(합자)부산풍국\",\"DLIVY_QTY\":\"1540\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078118237\"},{\"WHSLD_ENP_NM\":\"(합자)유원상사\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078118197\"},{\"WHSLD_ENP_NM\":\"(합자)청인상사\",\"DLIVY_QTY\":\"204\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078127508\"},{\"WHSLD_ENP_NM\":\"(합자)청인상사\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078127508\"},{\"WHSLD_ENP_NM\":\"(합자)청인상사\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078127508\"},{\"WHSLD_ENP_NM\":\"(합자)청인상사\",\"DLIVY_QTY\":\"90\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078127508\"},{\"WHSLD_ENP_NM\":\"해성주류판매주식회사\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078120960\"},{\"WHSLD_ENP_NM\":\"해성주류판매주식회사\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6078120960\"},{\"WHSLD_ENP_NM\":\"현대상사(주)\",\"DLIVY_QTY\":\"22400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6078527054\",\"WHSLD_BIZRNO\":\"6038104143\"},{\"WHSLD_ENP_NM\":\"(명)동림주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088119321\"},{\"WHSLD_ENP_NM\":\"(명)동림주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088119321\"},{\"WHSLD_ENP_NM\":\"(명)동림주류\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088119321\"},{\"WHSLD_ENP_NM\":\"(유) 유창주류\",\"DLIVY_QTY\":\"4800\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6098118999\"},{\"WHSLD_ENP_NM\":\"(유)대원\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1298109219\"},{\"WHSLD_ENP_NM\":\"(유)두성\",\"DLIVY_QTY\":\"8912\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1298109204\"},{\"WHSLD_ENP_NM\":\"(유)두성\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1298109204\"},{\"WHSLD_ENP_NM\":\"(유)태양종합주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268625516\"},{\"WHSLD_ENP_NM\":\"(유)태양종합주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268625516\"},{\"WHSLD_ENP_NM\":\"(유)한영\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268115110\"},{\"WHSLD_ENP_NM\":\"(유)한영\",\"DLIVY_QTY\":\"14040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268115110\"},{\"WHSLD_ENP_NM\":\"(유)한영\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268115110\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"684\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"31756\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 곤지암\",\"DLIVY_QTY\":\"4400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"2538500770\"},{\"WHSLD_ENP_NM\":\"(주)세븐 서이천\",\"DLIVY_QTY\":\"12424\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268549224\"},{\"WHSLD_ENP_NM\":\"(주)세븐 성남\",\"DLIVY_QTY\":\"8220\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1298523543\"},{\"WHSLD_ENP_NM\":\"(주)씨스페이시스 광주센터\",\"DLIVY_QTY\":\"5600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268535792\"},{\"WHSLD_ENP_NM\":\"(주)이마트24 이천물류센터\",\"DLIVY_QTY\":\"48\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1358555074\"},{\"WHSLD_ENP_NM\":\"(주)이마트24 이천물류센터\",\"DLIVY_QTY\":\"11200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1358555074\"},{\"WHSLD_ENP_NM\":\"(합자)북성상사\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268110852\"},{\"WHSLD_ENP_NM\":\"(합자)북성상사\",\"DLIVY_QTY\":\"1160\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268110852\"},{\"WHSLD_ENP_NM\":\"(합자)북성상사\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268110852\"},{\"WHSLD_ENP_NM\":\"경기동부수퍼마켓협동조합\",\"DLIVY_QTY\":\"9304\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1298203401\"},{\"WHSLD_ENP_NM\":\"세종주류상사(합자)\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268102750\"},{\"WHSLD_ENP_NM\":\"세종주류상사(합자)\",\"DLIVY_QTY\":\"36\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268102750\"},{\"WHSLD_ENP_NM\":\"세종주류상사(합자)\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268102750\"},{\"WHSLD_ENP_NM\":\"세종주류상사(합자)\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268102750\"},{\"WHSLD_ENP_NM\":\"유한회사 금호주류상사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268658701\"},{\"WHSLD_ENP_NM\":\"유한회사 금호주류상사\",\"DLIVY_QTY\":\"-210\",\"STD_CTNR_CD\":\"210001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268658701\"},{\"WHSLD_ENP_NM\":\"유한회사 금호주류상사\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268658701\"},{\"WHSLD_ENP_NM\":\"유한회사 도드람종합주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268175156\"},{\"WHSLD_ENP_NM\":\"유한회사 도드람종합주류\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268175156\"},{\"WHSLD_ENP_NM\":\"유한회사동천\",\"DLIVY_QTY\":\"30\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1298101920\"},{\"WHSLD_ENP_NM\":\"유한회사동천\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1298101920\"},{\"WHSLD_ENP_NM\":\"한국미니스톱(주)곤지암\",\"DLIVY_QTY\":\"11200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268545761\"},{\"WHSLD_ENP_NM\":\"합자회사제일상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268101289\"},{\"WHSLD_ENP_NM\":\"합자회사제일상사\",\"DLIVY_QTY\":\"24\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268101289\"},{\"WHSLD_ENP_NM\":\"합자회사제일상사\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268101289\"},{\"WHSLD_ENP_NM\":\"합자회사제일상사\",\"DLIVY_QTY\":\"2480\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1268531914\",\"WHSLD_BIZRNO\":\"1268101289\"},{\"WHSLD_ENP_NM\":\"(유)금강주류\",\"DLIVY_QTY\":\"1344\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2058121628\"},{\"WHSLD_ENP_NM\":\"(유)금강주류\",\"DLIVY_QTY\":\"40136\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2058121628\"},{\"WHSLD_ENP_NM\":\"(유)동남양행\",\"DLIVY_QTY\":\"21600\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2108120183\"},{\"WHSLD_ENP_NM\":\"(유)동대문종합주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2298116169\"},{\"WHSLD_ENP_NM\":\"(유)동대문종합주류\",\"DLIVY_QTY\":\"27000\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2298116169\"},{\"WHSLD_ENP_NM\":\"(유)북부주류판매상사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2088102047\"},{\"WHSLD_ENP_NM\":\"(유)북부주류판매상사\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2088102047\"},{\"WHSLD_ENP_NM\":\"(유)석재상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2108103883\"},{\"WHSLD_ENP_NM\":\"(유)석재상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2108103883\"},{\"WHSLD_ENP_NM\":\"(유)석재상사\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2108103883\"},{\"WHSLD_ENP_NM\":\"(유)신림주류판매상사\",\"DLIVY_QTY\":\"2220\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1128101747\"},{\"WHSLD_ENP_NM\":\"(유)신림주류판매상사\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1128101747\"},{\"WHSLD_ENP_NM\":\"(유)원천종합주류\",\"DLIVY_QTY\":\"540\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1118114083\"},{\"WHSLD_ENP_NM\":\"(유)원천종합주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1118114083\"},{\"WHSLD_ENP_NM\":\"(유)원천종합주류\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1118114083\"},{\"WHSLD_ENP_NM\":\"(유)원천종합주류\",\"DLIVY_QTY\":\"14040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1118114083\"},{\"WHSLD_ENP_NM\":\"(유한)덕암주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1118127268\"},{\"WHSLD_ENP_NM\":\"(유한)덕암주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1118127268\"},{\"WHSLD_ENP_NM\":\"(유한)덕암주류\",\"DLIVY_QTY\":\"10020\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1118127268\"},{\"WHSLD_ENP_NM\":\"(유한)천지상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2178112520\"},{\"WHSLD_ENP_NM\":\"(유한)천지상사\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2178112520\"},{\"WHSLD_ENP_NM\":\"(유한)합천상사\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2078142503\"},{\"WHSLD_ENP_NM\":\"(주)경남주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2048118019\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부 목천지점\",\"DLIVY_QTY\":\"4512\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"3128528382\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"36\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"24620\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)대산주류\",\"DLIVY_QTY\":\"40\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1098188622\"},{\"WHSLD_ENP_NM\":\"(주)대산주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1098188622\"},{\"WHSLD_ENP_NM\":\"(주)대산주류\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1098188622\"},{\"WHSLD_ENP_NM\":\"(주)대진유통\",\"DLIVY_QTY\":\"1680\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2158101390\"},{\"WHSLD_ENP_NM\":\"(주)대진유통\",\"DLIVY_QTY\":\"5600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2158101390\"},{\"WHSLD_ENP_NM\":\"(주)동양주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2168100230\"},{\"WHSLD_ENP_NM\":\"(주)동양주류\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2168100230\"},{\"WHSLD_ENP_NM\":\"(주)동호유통\",\"DLIVY_QTY\":\"5324\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1328164125\"},{\"WHSLD_ENP_NM\":\"(주)럭키주류\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2158632374\"},{\"WHSLD_ENP_NM\":\"(주)럭키주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2158632374\"},{\"WHSLD_ENP_NM\":\"(주)럭키주류\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2158632374\"},{\"WHSLD_ENP_NM\":\"(주)마당쇠유통\",\"DLIVY_QTY\":\"-144\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2048175529\"},{\"WHSLD_ENP_NM\":\"(주)마당쇠유통\",\"DLIVY_QTY\":\"30304\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2048175529\"},{\"WHSLD_ENP_NM\":\"(유) 유창주류\",\"DLIVY_QTY\":\"2520\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6098118999\"},{\"WHSLD_ENP_NM\":\"(유)대성종합주류\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6228100401\"},{\"WHSLD_ENP_NM\":\"(유)삼양주류판매상사\",\"DLIVY_QTY\":\"30\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088119340\"},{\"WHSLD_ENP_NM\":\"(유)성광종합주류\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088111047\"},{\"WHSLD_ENP_NM\":\"(유)세일주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088111144\"},{\"WHSLD_ENP_NM\":\"(유)세일주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088111144\"},{\"WHSLD_ENP_NM\":\"(유)신일주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6158135348\"},{\"WHSLD_ENP_NM\":\"(유)신일주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6158135348\"},{\"WHSLD_ENP_NM\":\"(유)신일주류\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6158135348\"},{\"WHSLD_ENP_NM\":\"(유)에이스주류\",\"DLIVY_QTY\":\"1170\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6098125258\"},{\"WHSLD_ENP_NM\":\"(유)에이스주류\",\"DLIVY_QTY\":\"5760\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6098125258\"},{\"WHSLD_ENP_NM\":\"(유)에이스주류\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6098125258\"},{\"WHSLD_ENP_NM\":\"(유)우리주류\",\"DLIVY_QTY\":\"5040\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6158104258\"},{\"WHSLD_ENP_NM\":\"(유)우리주류\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6158104258\"},{\"WHSLD_ENP_NM\":\"(유)우리주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6158104258\"},{\"WHSLD_ENP_NM\":\"(유)제일종합주류\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6158104239\"},{\"WHSLD_ENP_NM\":\"(유)제일종합주류\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6158104239\"},{\"WHSLD_ENP_NM\":\"(유)제일종합주류판매상사\",\"DLIVY_QTY\":\"5550\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088122127\"},{\"WHSLD_ENP_NM\":\"(유)제일종합주류판매상사\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088122127\"},{\"WHSLD_ENP_NM\":\"(유)제일종합주류판매상사\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088122127\"},{\"WHSLD_ENP_NM\":\"(유)진성주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088110956\"},{\"WHSLD_ENP_NM\":\"(유)진성주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088110956\"},{\"WHSLD_ENP_NM\":\"(유)진성주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088110956\"},{\"WHSLD_ENP_NM\":\"(유)진성주류\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088110956\"},{\"WHSLD_ENP_NM\":\"(유)창신주류\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6098118742\"},{\"WHSLD_ENP_NM\":\"(유)창신주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6098118742\"},{\"WHSLD_ENP_NM\":\"(자)대양상사\",\"DLIVY_QTY\":\"6840\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6158100892\"},{\"WHSLD_ENP_NM\":\"(자)대양상사\",\"DLIVY_QTY\":\"240\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6158100892\"},{\"WHSLD_ENP_NM\":\"(자)대양상사\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6158100892\"},{\"WHSLD_ENP_NM\":\"(자)삼성주류판매상사\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088101608\"},{\"WHSLD_ENP_NM\":\"(자)삼성주류판매상사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088101608\"},{\"WHSLD_ENP_NM\":\"(자)삼성주류판매상사\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088101608\"},{\"WHSLD_ENP_NM\":\"㈜ 대도상사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088106296\"},{\"WHSLD_ENP_NM\":\"㈜ 대도상사\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088106296\"},{\"WHSLD_ENP_NM\":\"㈜ 대도상사\",\"DLIVY_QTY\":\"5430\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088106296\"},{\"WHSLD_ENP_NM\":\"㈜ 일신주류\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088122433\"},{\"WHSLD_ENP_NM\":\"㈜ 일신주류\",\"DLIVY_QTY\":\"240\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088122433\"},{\"WHSLD_ENP_NM\":\"㈜ 일신주류\",\"DLIVY_QTY\":\"3600\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088122433\"},{\"WHSLD_ENP_NM\":\"㈜대동유통\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6158151921\"},{\"WHSLD_ENP_NM\":\"㈜대동유통\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"230201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6158151921\"},{\"WHSLD_ENP_NM\":\"㈜신진상사\",\"DLIVY_QTY\":\"2250\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6098102084\"},{\"WHSLD_ENP_NM\":\"㈜신진상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6098102084\"},{\"WHSLD_ENP_NM\":\"㈜신진상사\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6098102084\"},{\"WHSLD_ENP_NM\":\"㈜신진상사\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6098102084\"},{\"WHSLD_ENP_NM\":\"경남주류판매㈜\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088101175\"},{\"WHSLD_ENP_NM\":\"경남주류판매㈜\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088101175\"},{\"WHSLD_ENP_NM\":\"경남주류판매㈜\",\"DLIVY_QTY\":\"400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088101175\"},{\"WHSLD_ENP_NM\":\"경남주류판매㈜\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088101175\"},{\"WHSLD_ENP_NM\":\"창원주류판매 ㈜\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6098103332\"},{\"WHSLD_ENP_NM\":\"창원주류판매 ㈜\",\"DLIVY_QTY\":\"80\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6098103332\"},{\"WHSLD_ENP_NM\":\"태평양주류판매㈜\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088105093\"},{\"WHSLD_ENP_NM\":\"태평양주류판매㈜\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537280\",\"WHSLD_BIZRNO\":\"6088105093\"},{\"WHSLD_ENP_NM\":\"(유)신합동주류판매상사\",\"DLIVY_QTY\":\"540\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6088119369\"},{\"WHSLD_ENP_NM\":\"(유)신합동주류판매상사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6088119369\"},{\"WHSLD_ENP_NM\":\"(유)신합동주류판매상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6088119369\"},{\"WHSLD_ENP_NM\":\"(유)신합동주류판매상사\",\"DLIVY_QTY\":\"420\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6088119369\"},{\"WHSLD_ENP_NM\":\"(유)신합동주류판매상사\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6088119369\"},{\"WHSLD_ENP_NM\":\"(자)가야연쇄점본부\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6128100802\"},{\"WHSLD_ENP_NM\":\"(자)가야연쇄점본부\",\"DLIVY_QTY\":\"3120\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6128100802\"},{\"WHSLD_ENP_NM\":\"(자)가야연쇄점본부\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6128100802\"},{\"WHSLD_ENP_NM\":\"(자)가야연쇄점본부\",\"DLIVY_QTY\":\"1520\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6128100802\"},{\"WHSLD_ENP_NM\":\"(자)영남생협연쇄점본부\",\"DLIVY_QTY\":\"4680\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6088102679\"},{\"WHSLD_ENP_NM\":\"(자)한려주류판매상사\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6128101174\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 경남사업소\",\"DLIVY_QTY\":\"96\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"7558500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 경남사업소\",\"DLIVY_QTY\":\"14416\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"7558500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 경남사업소\",\"DLIVY_QTY\":\"7180\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"7558500015\"},{\"WHSLD_ENP_NM\":\"(합)동양상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6128100554\"},{\"WHSLD_ENP_NM\":\"(합)동양상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6128100554\"},{\"WHSLD_ENP_NM\":\"(합)동양상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6128100554\"},{\"WHSLD_ENP_NM\":\"(합)동양상사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6128100554\"},{\"WHSLD_ENP_NM\":\"(합)영남생협김해지점\",\"DLIVY_QTY\":\"6048\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6228505613\"},{\"WHSLD_ENP_NM\":\"(합)영남생협김해지점\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6228505613\"},{\"WHSLD_ENP_NM\":\"㈜ 경남슈퍼체인\",\"DLIVY_QTY\":\"3792\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6088106525\"},{\"WHSLD_ENP_NM\":\"㈜ 경남슈퍼체인\",\"DLIVY_QTY\":\"6680\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6088106525\"},{\"WHSLD_ENP_NM\":\"㈜ 동양체인\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6088102252\"},{\"WHSLD_ENP_NM\":\"㈜ 동양체인\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6088102252\"},{\"WHSLD_ENP_NM\":\"(주)백승상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1078124530\"},{\"WHSLD_ENP_NM\":\"(주)백승상사\",\"DLIVY_QTY\":\"24840\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1078124530\"},{\"WHSLD_ENP_NM\":\"(주)삼정종합주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2158632369\"},{\"WHSLD_ENP_NM\":\"(주)삼정종합주류\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2158632369\"},{\"WHSLD_ENP_NM\":\"(주)삼한주류상사\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1018163874\"},{\"WHSLD_ENP_NM\":\"(주)상승상사\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2108118561\"},{\"WHSLD_ENP_NM\":\"(주)새생활체인\",\"DLIVY_QTY\":\"14904\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2168102000\"},{\"WHSLD_ENP_NM\":\"(주)성북칠성\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2098102583\"},{\"WHSLD_ENP_NM\":\"(주)성북합동상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2098102491\"},{\"WHSLD_ENP_NM\":\"(주)성북합동상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2098102491\"},{\"WHSLD_ENP_NM\":\"(주)성북합동상사\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2098102491\"},{\"WHSLD_ENP_NM\":\"(주)성일연쇄점\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1278106502\"},{\"WHSLD_ENP_NM\":\"(주)성일연쇄점\",\"DLIVY_QTY\":\"12104\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1278106502\"},{\"WHSLD_ENP_NM\":\"(주)수창주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2058105123\"},{\"WHSLD_ENP_NM\":\"(주)수창주류\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2058105123\"},{\"WHSLD_ENP_NM\":\"(주)아그래\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1328150048\"},{\"WHSLD_ENP_NM\":\"(주)은하수주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1178130892\"},{\"WHSLD_ENP_NM\":\"경기북부수퍼마켓협동조합\",\"DLIVY_QTY\":\"10856\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1278208356\"},{\"WHSLD_ENP_NM\":\"경의주류판매(주)\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1278109659\"},{\"WHSLD_ENP_NM\":\"광장주류판매(주)\",\"DLIVY_QTY\":\"15840\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1028137082\"},{\"WHSLD_ENP_NM\":\"광장주류판매(주)\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1028137082\"},{\"WHSLD_ENP_NM\":\"대성주류판매주식회사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2058113768\"},{\"WHSLD_ENP_NM\":\"대성주류판매주식회사\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2058113768\"},{\"WHSLD_ENP_NM\":\"대성주류판매주식회사\",\"DLIVY_QTY\":\"14944\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2058113768\"},{\"WHSLD_ENP_NM\":\"성동주류판매(주)\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2188103761\"},{\"WHSLD_ENP_NM\":\"성동주류판매(주)\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2188103761\"},{\"WHSLD_ENP_NM\":\"성동주류판매(주)\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2188103761\"},{\"WHSLD_ENP_NM\":\"씨에스 광릉\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1278537298\"},{\"WHSLD_ENP_NM\":\"씨에스 광릉\",\"DLIVY_QTY\":\"10456\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1278537298\"},{\"WHSLD_ENP_NM\":\"유한회사원체인\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"4038122589\"},{\"WHSLD_ENP_NM\":\"유한회사원체인\",\"DLIVY_QTY\":\"24688\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"4038122589\"},{\"WHSLD_ENP_NM\":\"종로기업(주)\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1028106099\"},{\"WHSLD_ENP_NM\":\"종로기업(주)\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"1028106099\"},{\"WHSLD_ENP_NM\":\"주식회사 유송체인\",\"DLIVY_QTY\":\"9960\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2048139009\"},{\"WHSLD_ENP_NM\":\"주식회사시장수퍼체인\",\"DLIVY_QTY\":\"1008\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2188103816\"},{\"WHSLD_ENP_NM\":\"주식회사시장수퍼체인\",\"DLIVY_QTY\":\"11304\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2188103816\"},{\"WHSLD_ENP_NM\":\"주식회사양지종합주류\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2138192823\"},{\"WHSLD_ENP_NM\":\"주식회사양지종합주류\",\"DLIVY_QTY\":\"40\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2138192823\"},{\"WHSLD_ENP_NM\":\"주식회사양지종합주류\",\"DLIVY_QTY\":\"35640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2138192823\"},{\"WHSLD_ENP_NM\":\"진양주류(주)\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2108103942\"},{\"WHSLD_ENP_NM\":\"진양주류(주)\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2108103942\"},{\"WHSLD_ENP_NM\":\"취성유통주식회사\",\"DLIVY_QTY\":\"480\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2048182700\"},{\"WHSLD_ENP_NM\":\"취성유통주식회사\",\"DLIVY_QTY\":\"9552\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2048182700\"},{\"WHSLD_ENP_NM\":\"풍원식품(주)\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278525792\",\"WHSLD_BIZRNO\":\"2078108086\"},{\"WHSLD_ENP_NM\":\"(유)건양상사\",\"DLIVY_QTY\":\"360\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278159601\"},{\"WHSLD_ENP_NM\":\"(유)건양상사\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278159601\"},{\"WHSLD_ENP_NM\":\"(유)건양상사\",\"DLIVY_QTY\":\"2560\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278159601\"},{\"WHSLD_ENP_NM\":\"(유)건양상사\",\"DLIVY_QTY\":\"31320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278159601\"},{\"WHSLD_ENP_NM\":\"(유)대륙종합주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278195887\"},{\"WHSLD_ENP_NM\":\"(유)대륙종합주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278195887\"},{\"WHSLD_ENP_NM\":\"(유)대륙종합주류\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278195887\"},{\"WHSLD_ENP_NM\":\"(유)대한상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278106424\"},{\"WHSLD_ENP_NM\":\"(유)대한상사\",\"DLIVY_QTY\":\"2480\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278106424\"},{\"WHSLD_ENP_NM\":\"(유)대한상사\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278106424\"},{\"WHSLD_ENP_NM\":\"(유)동화상사\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278106439\"},{\"WHSLD_ENP_NM\":\"(유)동화상사\",\"DLIVY_QTY\":\"12100\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278106439\"},{\"WHSLD_ENP_NM\":\"(유)동화상사\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278106439\"},{\"WHSLD_ENP_NM\":\"(유)두리상사\",\"DLIVY_QTY\":\"0\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278613842\"},{\"WHSLD_ENP_NM\":\"(유)두리상사\",\"DLIVY_QTY\":\"17292\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278613842\"},{\"WHSLD_ENP_NM\":\"(유)세화상사\",\"DLIVY_QTY\":\"504\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1328100951\"},{\"WHSLD_ENP_NM\":\"(유)세화상사\",\"DLIVY_QTY\":\"22680\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1328100951\"},{\"WHSLD_ENP_NM\":\"(유)세화상사\",\"DLIVY_QTY\":\"12224\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1328100951\"},{\"WHSLD_ENP_NM\":\"(유)술나라영산유통\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1328100607\"},{\"WHSLD_ENP_NM\":\"(유)술나라영산유통\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1328100607\"},{\"WHSLD_ENP_NM\":\"(유)술나라영산유통\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1328100607\"},{\"WHSLD_ENP_NM\":\"(유)양정종합주류\",\"DLIVY_QTY\":\"16380\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1328141684\"},{\"WHSLD_ENP_NM\":\"(유)양정종합주류\",\"DLIVY_QTY\":\"180\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1328141684\"},{\"WHSLD_ENP_NM\":\"(유)오남주류\",\"DLIVY_QTY\":\"34560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1328136541\"},{\"WHSLD_ENP_NM\":\"(유)정우상사\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278106365\"},{\"WHSLD_ENP_NM\":\"(유)정우상사\",\"DLIVY_QTY\":\"7760\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278106365\"},{\"WHSLD_ENP_NM\":\"(유)정우상사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278106365\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부 목천지점\",\"DLIVY_QTY\":\"4816\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"3128528382\"},{\"WHSLD_ENP_NM\":\"(주)대우상사\",\"DLIVY_QTY\":\"4500\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278101638\"},{\"WHSLD_ENP_NM\":\"(주)대우상사\",\"DLIVY_QTY\":\"69270\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278101638\"},{\"WHSLD_ENP_NM\":\"(주)덕건상사\",\"DLIVY_QTY\":\"480\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278159668\"},{\"WHSLD_ENP_NM\":\"(주)덕건상사\",\"DLIVY_QTY\":\"5040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1278159668\"},{\"WHSLD_ENP_NM\":\"㈜ 동양체인\",\"DLIVY_QTY\":\"4708\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6088102252\"},{\"WHSLD_ENP_NM\":\"㈜고성주류판매상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6128100331\"},{\"WHSLD_ENP_NM\":\"㈜현대유통\",\"DLIVY_QTY\":\"7416\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6098107599\"},{\"WHSLD_ENP_NM\":\"국군복지단 창원쇼핑타운\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6098303845\"},{\"WHSLD_ENP_NM\":\"국군복지단 창원쇼핑타운\",\"DLIVY_QTY\":\"1600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6098303845\"},{\"WHSLD_ENP_NM\":\"충무주류판매(주)\",\"DLIVY_QTY\":\"0\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6098537295\",\"WHSLD_BIZRNO\":\"6128100535\"},{\"WHSLD_ENP_NM\":\"( 유 ) 경성주류\",\"DLIVY_QTY\":\"1000\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138112164\"},{\"WHSLD_ENP_NM\":\"( 유 ) 신흥주류\",\"DLIVY_QTY\":\"3330\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138104437\"},{\"WHSLD_ENP_NM\":\"( 유 ) 신흥주류\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138104437\"},{\"WHSLD_ENP_NM\":\"( 유 ) 신흥주류\",\"DLIVY_QTY\":\"360\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138104437\"},{\"WHSLD_ENP_NM\":\"( 유 ) 신흥주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138104437\"},{\"WHSLD_ENP_NM\":\"( 유 ) 합동상사\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6198101928\"},{\"WHSLD_ENP_NM\":\"( 자 ) 서부상사\",\"DLIVY_QTY\":\"1000\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6198100496\"},{\"WHSLD_ENP_NM\":\"(명) 금산주류판매\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6148100512\"},{\"WHSLD_ENP_NM\":\"(명) 금산주류판매\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6148100512\"},{\"WHSLD_ENP_NM\":\"(명) 금산주류판매\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6148100512\"},{\"WHSLD_ENP_NM\":\"(명) 금산주류판매\",\"DLIVY_QTY\":\"2250\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6148100512\"},{\"WHSLD_ENP_NM\":\"(명) 금산주류판매\",\"DLIVY_QTY\":\"3930\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6148100512\"},{\"WHSLD_ENP_NM\":\"(명) 금산주류판매\",\"DLIVY_QTY\":\"1520\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6148100512\"},{\"WHSLD_ENP_NM\":\"(명) 한마음주류\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138102972\"},{\"WHSLD_ENP_NM\":\"(유) 가람주류\",\"DLIVY_QTY\":\"84\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138108786\"},{\"WHSLD_ENP_NM\":\"(유) 와룡주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6198104153\"},{\"WHSLD_ENP_NM\":\"(자) 대원상사\",\"DLIVY_QTY\":\"1152\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6118100037\"},{\"WHSLD_ENP_NM\":\"(자) 장수주류\",\"DLIVY_QTY\":\"4350\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6148101919\"},{\"WHSLD_ENP_NM\":\"(자) 장수주류\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6148101919\"},{\"WHSLD_ENP_NM\":\"(자) 장수주류\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6148101919\"},{\"WHSLD_ENP_NM\":\"(자) 장수주류\",\"DLIVY_QTY\":\"2610\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6148101919\"},{\"WHSLD_ENP_NM\":\"(자) 장수주류\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6148101919\"},{\"WHSLD_ENP_NM\":\"(주) 광신주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138108772\"},{\"WHSLD_ENP_NM\":\"(주) 광신주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138108772\"},{\"WHSLD_ENP_NM\":\"(주) 진주체인\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138113260\"},{\"WHSLD_ENP_NM\":\"(주) 진주체인\",\"DLIVY_QTY\":\"5104\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138113260\"},{\"WHSLD_ENP_NM\":\"(주) 회원\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138108831\"},{\"WHSLD_ENP_NM\":\"(주) 회원\",\"DLIVY_QTY\":\"900\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138108831\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 경남사업소\",\"DLIVY_QTY\":\"3340\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"7558500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 경남사업소\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"7558500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 경남사업소\",\"DLIVY_QTY\":\"5504\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"7558500015\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 경남지점\",\"DLIVY_QTY\":\"1512\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"4558500740\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 경남지점\",\"DLIVY_QTY\":\"5800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"4558500740\"},{\"WHSLD_ENP_NM\":\"(주)지에스리테일진주CVS\",\"DLIVY_QTY\":\"5824\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138519340\"},{\"WHSLD_ENP_NM\":\"(합) 동부상사\",\"DLIVY_QTY\":\"2340\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6118100527\"},{\"WHSLD_ENP_NM\":\"(합) 동부상사\",\"DLIVY_QTY\":\"2400\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6118100527\"},{\"WHSLD_ENP_NM\":\"(합) 동부상사\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6118100527\"},{\"WHSLD_ENP_NM\":\"(합) 동부상사\",\"DLIVY_QTY\":\"2520\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6118100527\"},{\"WHSLD_ENP_NM\":\"(합명) 금성주류\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6148102446\"},{\"WHSLD_ENP_NM\":\"(합명) 금성주류\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6148102446\"},{\"WHSLD_ENP_NM\":\"(합자) 까치상사\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6118100508\"},{\"WHSLD_ENP_NM\":\"(합자) 까치상사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6118100508\"},{\"WHSLD_ENP_NM\":\"(합자) 까치상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6118100508\"},{\"WHSLD_ENP_NM\":\"(합자) 까치상사\",\"DLIVY_QTY\":\"1260\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6118100508\"},{\"WHSLD_ENP_NM\":\"(합자) 까치상사\",\"DLIVY_QTY\":\"2000\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6118100508\"},{\"WHSLD_ENP_NM\":\"(합자) 삼성상사\",\"DLIVY_QTY\":\"1176\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6118100022\"},{\"WHSLD_ENP_NM\":\"(합자) 삼성상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6118100022\"},{\"WHSLD_ENP_NM\":\"(합자) 삼성상사\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6118100022\"},{\"WHSLD_ENP_NM\":\"경남주류판매 (주)\",\"DLIVY_QTY\":\"2980\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138105396\"},{\"WHSLD_ENP_NM\":\"경남주류판매 (주)\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138105396\"},{\"WHSLD_ENP_NM\":\"경남주류판매 (주)\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138105396\"},{\"WHSLD_ENP_NM\":\"유 ) 동아주류판매상사\",\"DLIVY_QTY\":\"240\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6198101404\"},{\"WHSLD_ENP_NM\":\"유)대성주류판매상사\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6198102795\"},{\"WHSLD_ENP_NM\":\"유)대성주류판매상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6198102795\"},{\"WHSLD_ENP_NM\":\"유)대성주류판매상사\",\"DLIVY_QTY\":\"36\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6198102795\"},{\"WHSLD_ENP_NM\":\"유)대성주류판매상사\",\"DLIVY_QTY\":\"1500\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6198102795\"},{\"WHSLD_ENP_NM\":\"유)대성주류판매상사\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6198102795\"},{\"WHSLD_ENP_NM\":\"진산주류판매 ( 주 )\",\"DLIVY_QTY\":\"0\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138100881\"},{\"WHSLD_ENP_NM\":\"진산주류판매 ( 주 )\",\"DLIVY_QTY\":\"3000\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138100881\"},{\"WHSLD_ENP_NM\":\"진산주류판매 ( 주 )\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138100881\"},{\"WHSLD_ENP_NM\":\"진양주류 ( 주 )\",\"DLIVY_QTY\":\"800\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138101065\"},{\"WHSLD_ENP_NM\":\"진양주류 ( 주 )\",\"DLIVY_QTY\":\"800\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138101065\"},{\"WHSLD_ENP_NM\":\"진양주류 ( 주 )\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138101065\"},{\"WHSLD_ENP_NM\":\"진양주류 ( 주 )\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6138101065\"},{\"WHSLD_ENP_NM\":\"합명회사 아시아주류\",\"DLIVY_QTY\":\"400\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6198100502\"},{\"WHSLD_ENP_NM\":\"합명회사 아시아주류\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6198100502\"},{\"WHSLD_ENP_NM\":\"합자회사) 서울주류판매상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6138500220\",\"WHSLD_BIZRNO\":\"6118102864\"},{\"WHSLD_ENP_NM\":\"(유)개화물산\",\"DLIVY_QTY\":\"480\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168102345\"},{\"WHSLD_ENP_NM\":\"(유)개화물산\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168102345\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 의정부\",\"DLIVY_QTY\":\"12000\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"4678500670\"},{\"WHSLD_ENP_NM\":\"(주)양지종합주류\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1328154229\"},{\"WHSLD_ENP_NM\":\"(주)양지종합주류\",\"DLIVY_QTY\":\"400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1328154229\"},{\"WHSLD_ENP_NM\":\"(주)양지종합주류\",\"DLIVY_QTY\":\"1980\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1328154229\"},{\"WHSLD_ENP_NM\":\"(주)코리아세븐 양주물류센터\",\"DLIVY_QTY\":\"192\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1358523816\"},{\"WHSLD_ENP_NM\":\"(주)코리아세븐 양주물류센터\",\"DLIVY_QTY\":\"8400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"1358523816\"},{\"WHSLD_ENP_NM\":\"주식회사 유송체인\",\"DLIVY_QTY\":\"6912\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1278539660\",\"WHSLD_BIZRNO\":\"2048139009\"},{\"WHSLD_ENP_NM\":\"(명)영풍통합상사\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1078114181\"},{\"WHSLD_ENP_NM\":\"(명)영풍통합상사\",\"DLIVY_QTY\":\"3840\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1078114181\"},{\"WHSLD_ENP_NM\":\"(명)인일상사\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1228118809\"},{\"WHSLD_ENP_NM\":\"(유)구로합동상사\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138118687\"},{\"WHSLD_ENP_NM\":\"(유)나산주류상사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2158124976\"},{\"WHSLD_ENP_NM\":\"(유)나산주류상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2158124976\"},{\"WHSLD_ENP_NM\":\"(유)나산주류상사\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2158124976\"},{\"WHSLD_ENP_NM\":\"(유)나산주류상사\",\"DLIVY_QTY\":\"14040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2158124976\"},{\"WHSLD_ENP_NM\":\"(유)남부상사\",\"DLIVY_QTY\":\"29160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1128103459\"},{\"WHSLD_ENP_NM\":\"(유)부림주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1308128555\"},{\"WHSLD_ENP_NM\":\"(유)산원주류\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2158148172\"},{\"WHSLD_ENP_NM\":\"(유)산원주류\",\"DLIVY_QTY\":\"240\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2158148172\"},{\"WHSLD_ENP_NM\":\"(유)성아종합주류\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2108119406\"},{\"WHSLD_ENP_NM\":\"(유)성주실업\",\"DLIVY_QTY\":\"900\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138126886\"},{\"WHSLD_ENP_NM\":\"(유)성주실업\",\"DLIVY_QTY\":\"160\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138126886\"},{\"WHSLD_ENP_NM\":\"(유)성주실업\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138126886\"},{\"WHSLD_ENP_NM\":\"(유)세광주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1098600295\"},{\"WHSLD_ENP_NM\":\"(유)세광주류\",\"DLIVY_QTY\":\"46440\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1098600295\"},{\"WHSLD_ENP_NM\":\"(유)소사합동\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1308108388\"},{\"WHSLD_ENP_NM\":\"(유)송정주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138132578\"},{\"WHSLD_ENP_NM\":\"(유)송정주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138132578\"},{\"WHSLD_ENP_NM\":\"(유)송정주류\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138132578\"},{\"WHSLD_ENP_NM\":\"(유)정진주류상사\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1118126916\"},{\"WHSLD_ENP_NM\":\"(유)정진주류상사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1118126916\"},{\"WHSLD_ENP_NM\":\"(유)진두유통\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1068139234\"},{\"WHSLD_ENP_NM\":\"(유)진천상사\",\"DLIVY_QTY\":\"18960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1188102972\"},{\"WHSLD_ENP_NM\":\"(유)진천상사\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1188102972\"},{\"WHSLD_ENP_NM\":\"(유한)화성통합\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1058108325\"},{\"WHSLD_ENP_NM\":\"(유한)화성통합\",\"DLIVY_QTY\":\"36\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1058108325\"},{\"WHSLD_ENP_NM\":\"(유한)화성통합\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1058108325\"},{\"WHSLD_ENP_NM\":\"(주)가야주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2198124774\"},{\"WHSLD_ENP_NM\":\"(주)가야주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2198124774\"},{\"WHSLD_ENP_NM\":\"(주)가야주류\",\"DLIVY_QTY\":\"400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2198124774\"},{\"WHSLD_ENP_NM\":\"(주)가야주류\",\"DLIVY_QTY\":\"19440\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2198124774\"},{\"WHSLD_ENP_NM\":\"(주)거원유통\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1098116996\"},{\"WHSLD_ENP_NM\":\"(주)거원유통\",\"DLIVY_QTY\":\"21656\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1098116996\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부 목천지점\",\"DLIVY_QTY\":\"15884\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"3128528382\"},{\"WHSLD_ENP_NM\":\"(주)명지주류\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138134936\"},{\"WHSLD_ENP_NM\":\"(주)명지주류\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138134936\"},{\"WHSLD_ENP_NM\":\"(주)명지주류\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138134936\"},{\"WHSLD_ENP_NM\":\"(주)보성주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2148780341\"},{\"WHSLD_ENP_NM\":\"(주)보성주류\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2148780341\"},{\"WHSLD_ENP_NM\":\"(주)보성주류\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2148780341\"},{\"WHSLD_ENP_NM\":\"(주)부흥상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1308117970\"},{\"WHSLD_ENP_NM\":\"(주)부흥상사\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1308117970\"},{\"WHSLD_ENP_NM\":\"(주)북창기업\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1118111015\"},{\"WHSLD_ENP_NM\":\"(주)북창기업\",\"DLIVY_QTY\":\"29160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1118111015\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 경기서지점\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"4188516433\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 경기서지점\",\"DLIVY_QTY\":\"80\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"4188516433\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 경기서지점\",\"DLIVY_QTY\":\"8400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"4188516433\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 경인\",\"DLIVY_QTY\":\"2800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"7438500744\"},{\"WHSLD_ENP_NM\":\"(주)서부상사\",\"DLIVY_QTY\":\"400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1308135129\"},{\"WHSLD_ENP_NM\":\"(주)서부상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1308135129\"},{\"WHSLD_ENP_NM\":\"(주)서울로직\",\"DLIVY_QTY\":\"4356\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1268612802\"},{\"WHSLD_ENP_NM\":\"(주)서울주류합동\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1198106549\"},{\"WHSLD_ENP_NM\":\"(주)서울주류합동\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1198106549\"},{\"WHSLD_ENP_NM\":\"(주)서울주류합동\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1198106549\"},{\"WHSLD_ENP_NM\":\"(주)서울체인\",\"DLIVY_QTY\":\"26600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1178102528\"},{\"WHSLD_ENP_NM\":\"(주)선호상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1068126234\"},{\"WHSLD_ENP_NM\":\"(주)선호상사\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1068126234\"},{\"WHSLD_ENP_NM\":\"(주)신성주류\",\"DLIVY_QTY\":\"76680\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1188107318\"},{\"WHSLD_ENP_NM\":\"(주)아리랑주류\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1068152372\"},{\"WHSLD_ENP_NM\":\"(주)영등포식품\",\"DLIVY_QTY\":\"480\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1078106056\"},{\"WHSLD_ENP_NM\":\"(주)영등포식품\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1078106056\"},{\"WHSLD_ENP_NM\":\"(주)영등포식품\",\"DLIVY_QTY\":\"5760\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1078106056\"},{\"WHSLD_ENP_NM\":\"(주)원창진흥\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1118112483\"},{\"WHSLD_ENP_NM\":\"(주)원창진흥\",\"DLIVY_QTY\":\"5580\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1118112483\"},{\"WHSLD_ENP_NM\":\"(주)일호물산\",\"DLIVY_QTY\":\"72\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1178101024\"},{\"WHSLD_ENP_NM\":\"(주)일호물산\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1178101024\"},{\"WHSLD_ENP_NM\":\"(유)신흥물산\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168102307\"},{\"WHSLD_ENP_NM\":\"(유)신흥물산\",\"DLIVY_QTY\":\"150\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168102307\"},{\"WHSLD_ENP_NM\":\"(유)우일상사\",\"DLIVY_QTY\":\"168\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101313\"},{\"WHSLD_ENP_NM\":\"(유)우일상사\",\"DLIVY_QTY\":\"1396\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101313\"},{\"WHSLD_ENP_NM\":\"(유)우일상사\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101313\"},{\"WHSLD_ENP_NM\":\"(유)제원물산\",\"DLIVY_QTY\":\"1800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168112348\"},{\"WHSLD_ENP_NM\":\"(유)제주물산\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101287\"},{\"WHSLD_ENP_NM\":\"(유)제주물산\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101287\"},{\"WHSLD_ENP_NM\":\"(유)화림물산\",\"DLIVY_QTY\":\"84\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101346\"},{\"WHSLD_ENP_NM\":\"(유)화림물산\",\"DLIVY_QTY\":\"36\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101346\"},{\"WHSLD_ENP_NM\":\"(유)화림물산\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101346\"},{\"WHSLD_ENP_NM\":\"(유)화림물산\",\"DLIVY_QTY\":\"3680\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101346\"},{\"WHSLD_ENP_NM\":\"(주)남양체인\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101050\"},{\"WHSLD_ENP_NM\":\"(주)남양체인\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101050\"},{\"WHSLD_ENP_NM\":\"(주)남양체인\",\"DLIVY_QTY\":\"6064\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101050\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 제주물류센터\",\"DLIVY_QTY\":\"336\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6408500014\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 제주물류센터\",\"DLIVY_QTY\":\"15110\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6408500014\"},{\"WHSLD_ENP_NM\":\"(주)뉴월드\",\"DLIVY_QTY\":\"10368\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168116704\"},{\"WHSLD_ENP_NM\":\"(주)대안물산\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101308\"},{\"WHSLD_ENP_NM\":\"(주)대안물산\",\"DLIVY_QTY\":\"90\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101308\"},{\"WHSLD_ENP_NM\":\"(주)대안물산\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101308\"},{\"WHSLD_ENP_NM\":\"(주)동천\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168131291\"},{\"WHSLD_ENP_NM\":\"(주)동천\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168131291\"},{\"WHSLD_ENP_NM\":\"(주)벽상주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168102331\"},{\"WHSLD_ENP_NM\":\"(주)벽상주류\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168102331\"},{\"WHSLD_ENP_NM\":\"(주)벽상주류\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168102331\"},{\"WHSLD_ENP_NM\":\"(주)벽상주류\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168102331\"},{\"WHSLD_ENP_NM\":\"(주)세광\",\"DLIVY_QTY\":\"48\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168131423\"},{\"WHSLD_ENP_NM\":\"(주)세광\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168131423\"},{\"WHSLD_ENP_NM\":\"(주)세광\",\"DLIVY_QTY\":\"444\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168131423\"},{\"WHSLD_ENP_NM\":\"(주)세광\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168131423\"},{\"WHSLD_ENP_NM\":\"(주)영진\",\"DLIVY_QTY\":\"6000\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168103631\"},{\"WHSLD_ENP_NM\":\"(주)영진\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168103631\"},{\"WHSLD_ENP_NM\":\"(주)영진\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168103631\"},{\"WHSLD_ENP_NM\":\"(주)제주근대화체인\",\"DLIVY_QTY\":\"0\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101875\"},{\"WHSLD_ENP_NM\":\"(주)제주근대화체인\",\"DLIVY_QTY\":\"40\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101875\"},{\"WHSLD_ENP_NM\":\"(주)제주마켓물류센타\",\"DLIVY_QTY\":\"2552\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168121793\"},{\"WHSLD_ENP_NM\":\"영주물산(주)\",\"DLIVY_QTY\":\"12\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168131535\"},{\"WHSLD_ENP_NM\":\"영주물산(주)\",\"DLIVY_QTY\":\"40\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168131535\"},{\"WHSLD_ENP_NM\":\"영주물산(주)\",\"DLIVY_QTY\":\"1792\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168131535\"},{\"WHSLD_ENP_NM\":\"영주물산(주)\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168131535\"},{\"WHSLD_ENP_NM\":\"유한회사덕성물산\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168145887\"},{\"WHSLD_ENP_NM\":\"제주도수퍼마켓협동조합\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168206047\"},{\"WHSLD_ENP_NM\":\"제주도수퍼마켓협동조합\",\"DLIVY_QTY\":\"8840\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168206047\"},{\"WHSLD_ENP_NM\":\"주식회사 경희\",\"DLIVY_QTY\":\"4950\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6168501174\",\"WHSLD_BIZRNO\":\"6168101292\"},{\"WHSLD_ENP_NM\":\"(유한)한진주류\",\"DLIVY_QTY\":\"3600\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6208112347\"},{\"WHSLD_ENP_NM\":\"(유한)한진주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6208112347\"},{\"WHSLD_ENP_NM\":\"(유한)한진주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6208112347\"},{\"WHSLD_ENP_NM\":\"(유한)한진주류\",\"DLIVY_QTY\":\"90\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6208112347\"},{\"WHSLD_ENP_NM\":\"(유한)한진주류\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"230201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6208112347\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 경남사업소\",\"DLIVY_QTY\":\"1272\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"7558500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 경남사업소\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"7558500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 경남사업소\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"7558500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통 경남사업소\",\"DLIVY_QTY\":\"2520\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"7558500015\"},{\"WHSLD_ENP_NM\":\"(주)신정슈퍼체인본부\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6208103232\"},{\"WHSLD_ENP_NM\":\"(주)신정슈퍼체인본부\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6208103232\"},{\"WHSLD_ENP_NM\":\"(주)신정슈퍼체인본부\",\"DLIVY_QTY\":\"15808\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6208103232\"},{\"WHSLD_ENP_NM\":\"(주)신정슈퍼체인본부\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6208103232\"},{\"WHSLD_ENP_NM\":\"(주)영남현대화체인본부\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6208100652\"},{\"WHSLD_ENP_NM\":\"(주)영남현대화체인본부\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6208100652\"},{\"WHSLD_ENP_NM\":\"(주)영남현대화체인본부\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6208100652\"},{\"WHSLD_ENP_NM\":\"(주)울산근대화연쇄점\",\"DLIVY_QTY\":\"3552\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6208100609\"},{\"WHSLD_ENP_NM\":\"(주)울산근대화연쇄점\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6208100609\"},{\"WHSLD_ENP_NM\":\"(합명)국제주류판매상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6108101218\"},{\"WHSLD_ENP_NM\":\"(합명)국제주류판매상사\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6108101218\"},{\"WHSLD_ENP_NM\":\"(합명)국제주류판매상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6108101218\"},{\"WHSLD_ENP_NM\":\"(합명)대한주류판매상사\",\"DLIVY_QTY\":\"-240\",\"STD_CTNR_CD\":\"310202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6108101203\"},{\"WHSLD_ENP_NM\":\"(합명)대한주류판매상사\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6108101203\"},{\"WHSLD_ENP_NM\":\"(합명)대한주류판매상사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6108101203\"},{\"WHSLD_ENP_NM\":\"(합명)대한주류판매상사\",\"DLIVY_QTY\":\"-1860\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6108101203\"},{\"WHSLD_ENP_NM\":\"(합명)대한주류판매상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6108101203\"},{\"WHSLD_ENP_NM\":\"(합명)태양체인본부\",\"DLIVY_QTY\":\"12624\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6108102013\"},{\"WHSLD_ENP_NM\":\"신세계주류판매주식회사\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6108161332\"},{\"WHSLD_ENP_NM\":\"신세계주류판매주식회사\",\"DLIVY_QTY\":\"2980\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6108161332\"},{\"WHSLD_ENP_NM\":\"신세계주류판매주식회사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"6208504506\",\"WHSLD_BIZRNO\":\"6108161332\"},{\"WHSLD_ENP_NM\":\"(주)재영유통\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2148134321\"},{\"WHSLD_ENP_NM\":\"(주)재영유통\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2148134321\"},{\"WHSLD_ENP_NM\":\"(주)재영유통\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2148134321\"},{\"WHSLD_ENP_NM\":\"(주)정방주류\",\"DLIVY_QTY\":\"150\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1178108823\"},{\"WHSLD_ENP_NM\":\"(주)정방주류\",\"DLIVY_QTY\":\"32700\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1178108823\"},{\"WHSLD_ENP_NM\":\"(주)주당\",\"DLIVY_QTY\":\"1230\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1438800611\"},{\"WHSLD_ENP_NM\":\"(주)청룡주류\",\"DLIVY_QTY\":\"12\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1068603861\"},{\"WHSLD_ENP_NM\":\"(주)청룡주류\",\"DLIVY_QTY\":\"360\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1068603861\"},{\"WHSLD_ENP_NM\":\"(주)청룡주류\",\"DLIVY_QTY\":\"780\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1068603861\"},{\"WHSLD_ENP_NM\":\"(주)청룡주류\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1068603861\"},{\"WHSLD_ENP_NM\":\"(주)한국생필체인\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138121917\"},{\"WHSLD_ENP_NM\":\"(주)한국생필체인\",\"DLIVY_QTY\":\"22560\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138121917\"},{\"WHSLD_ENP_NM\":\"(주)한맥상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2128160288\"},{\"WHSLD_ENP_NM\":\"(주)한맥상사\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2128160288\"},{\"WHSLD_ENP_NM\":\"GS25 고양1\",\"DLIVY_QTY\":\"7000\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1418500860\"},{\"WHSLD_ENP_NM\":\"GS25 인천1\",\"DLIVY_QTY\":\"144\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1378503140\"},{\"WHSLD_ENP_NM\":\"GS25 인천1\",\"DLIVY_QTY\":\"7000\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1378503140\"},{\"WHSLD_ENP_NM\":\"남서울주류㈜\",\"DLIVY_QTY\":\"24840\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1208626536\"},{\"WHSLD_ENP_NM\":\"대풍주류판매(주)\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138118708\"},{\"WHSLD_ENP_NM\":\"대풍주류판매(주)\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138118708\"},{\"WHSLD_ENP_NM\":\"대풍주류판매(주)\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138118708\"},{\"WHSLD_ENP_NM\":\"대풍주류판매(주)\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1138118708\"},{\"WHSLD_ENP_NM\":\"부천시수퍼마켓협동조합\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1228205427\"},{\"WHSLD_ENP_NM\":\"부천시수퍼마켓협동조합\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1228205427\"},{\"WHSLD_ENP_NM\":\"부천시수퍼마켓협동조합\",\"DLIVY_QTY\":\"7904\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1228205427\"},{\"WHSLD_ENP_NM\":\"산성주류(주)\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1188109368\"},{\"WHSLD_ENP_NM\":\"산성주류(주)\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1188109368\"},{\"WHSLD_ENP_NM\":\"서영주류판매(주)\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1098124026\"},{\"WHSLD_ENP_NM\":\"서영주류판매(주)\",\"DLIVY_QTY\":\"21600\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1098124026\"},{\"WHSLD_ENP_NM\":\"서영주류판매(주)\",\"DLIVY_QTY\":\"400\",\"STD_CTNR_CD\":\"230201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1098124026\"},{\"WHSLD_ENP_NM\":\"서울남북부수퍼마켓협동조합\",\"DLIVY_QTY\":\"43632\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1088204892\"},{\"WHSLD_ENP_NM\":\"서일주류판매(유)\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1368114200\"},{\"WHSLD_ENP_NM\":\"서일주류판매(유)\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1368114200\"},{\"WHSLD_ENP_NM\":\"서일주류판매(유)\",\"DLIVY_QTY\":\"24840\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1368114200\"},{\"WHSLD_ENP_NM\":\"용천물산(주)\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1068106048\"},{\"WHSLD_ENP_NM\":\"용천물산(주)\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1068106048\"},{\"WHSLD_ENP_NM\":\"용화상사(주)\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1078109960\"},{\"WHSLD_ENP_NM\":\"용화상사(주)\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1078109960\"},{\"WHSLD_ENP_NM\":\"우현종합주류(주)\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2098112043\"},{\"WHSLD_ENP_NM\":\"유한회사 미래종합유통\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1308617714\"},{\"WHSLD_ENP_NM\":\"유한회사 미래종합유통\",\"DLIVY_QTY\":\"2880\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1308617714\"},{\"WHSLD_ENP_NM\":\"유한회사 미래종합유통\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1308617714\"},{\"WHSLD_ENP_NM\":\"유한회사용우상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1068106669\"},{\"WHSLD_ENP_NM\":\"유한회사용우상사\",\"DLIVY_QTY\":\"18360\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1068106669\"},{\"WHSLD_ENP_NM\":\"유화진흥(주)\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2208123493\"},{\"WHSLD_ENP_NM\":\"유화진흥(주)\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2208123493\"},{\"WHSLD_ENP_NM\":\"유화진흥(주)\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2208123493\"},{\"WHSLD_ENP_NM\":\"이코사주류주식회사\",\"DLIVY_QTY\":\"2724\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2158142538\"},{\"WHSLD_ENP_NM\":\"이코사주류주식회사\",\"DLIVY_QTY\":\"14904\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"2158142538\"},{\"WHSLD_ENP_NM\":\"정현종합주류주식회사\",\"DLIVY_QTY\":\"5550\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1228165369\"},{\"WHSLD_ENP_NM\":\"정현종합주류주식회사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1228165369\"},{\"WHSLD_ENP_NM\":\"정현종합주류주식회사\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"230201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1228165369\"},{\"WHSLD_ENP_NM\":\"주식회사 대정\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1128100205\"},{\"WHSLD_ENP_NM\":\"주식회사 대정\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1128100205\"},{\"WHSLD_ENP_NM\":\"주식회사 대정\",\"DLIVY_QTY\":\"17280\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1128100205\"},{\"WHSLD_ENP_NM\":\"주식회사 대정\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1128100205\"},{\"WHSLD_ENP_NM\":\"주식회사 이랜드리테일\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1148101855\"},{\"WHSLD_ENP_NM\":\"주식회사 이랜드리테일\",\"DLIVY_QTY\":\"2840\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1148101855\"},{\"WHSLD_ENP_NM\":\"충무주류(주)\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1308545004\",\"WHSLD_BIZRNO\":\"1098194589\"},{\"WHSLD_ENP_NM\":\"(유) 라온\",\"DLIVY_QTY\":\"17280\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1388181234\"},{\"WHSLD_ENP_NM\":\"(유)삼풍주류\",\"DLIVY_QTY\":\"17280\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1298112427\"},{\"WHSLD_ENP_NM\":\"(유)성원종합주류\",\"DLIVY_QTY\":\"90\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358158049\"},{\"WHSLD_ENP_NM\":\"(유)성원종합주류\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358158049\"},{\"WHSLD_ENP_NM\":\"(유)성원종합주류\",\"DLIVY_QTY\":\"8820\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358158049\"},{\"WHSLD_ENP_NM\":\"(유)오비상사\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1298110017\"},{\"WHSLD_ENP_NM\":\"(유)오비상사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1298110017\"},{\"WHSLD_ENP_NM\":\"(유)종일상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"2298115175\"},{\"WHSLD_ENP_NM\":\"(유)태흥\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1298137597\"},{\"WHSLD_ENP_NM\":\"(유한)투원주류\",\"DLIVY_QTY\":\"5760\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1298109223\"},{\"WHSLD_ENP_NM\":\"(유한)투원주류\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1298109223\"},{\"WHSLD_ENP_NM\":\"(유한)투원주류\",\"DLIVY_QTY\":\"43200\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1298109223\"},{\"WHSLD_ENP_NM\":\"(주)구산주류상사\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"230201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"2298123864\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부 목천지점\",\"DLIVY_QTY\":\"2966\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"3128528382\"},{\"WHSLD_ENP_NM\":\"(주)내성기업\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"2198100772\"},{\"WHSLD_ENP_NM\":\"(주)내성기업\",\"DLIVY_QTY\":\"2424\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"2198100772\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"240\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"10824\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)다산주류\",\"DLIVY_QTY\":\"41040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1188103272\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 서울\",\"DLIVY_QTY\":\"288\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"6568500566\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 수지\",\"DLIVY_QTY\":\"7400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"7658500690\"},{\"WHSLD_ENP_NM\":\"(주)서울로직\",\"DLIVY_QTY\":\"3924\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1268612802\"},{\"WHSLD_ENP_NM\":\"(주)세븐 구성\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1428505776\"},{\"WHSLD_ENP_NM\":\"(주)세븐 구성\",\"DLIVY_QTY\":\"4200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1428505776\"},{\"WHSLD_ENP_NM\":\"(주)양강물산\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"2298115646\"},{\"WHSLD_ENP_NM\":\"(주)양강물산\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"2298115646\"},{\"WHSLD_ENP_NM\":\"(주)이마트24 용인물류센터\",\"DLIVY_QTY\":\"168\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"8298500408\"},{\"WHSLD_ENP_NM\":\"(주)이마트24 용인물류센터\",\"DLIVY_QTY\":\"4400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"8298500408\"},{\"WHSLD_ENP_NM\":\"(주)일월종합상사\",\"DLIVY_QTY\":\"3300\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"2298116024\"},{\"WHSLD_ENP_NM\":\"(주)일월종합상사\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"2298116024\"},{\"WHSLD_ENP_NM\":\"(주)중문주류\",\"DLIVY_QTY\":\"570\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"2148164048\"},{\"WHSLD_ENP_NM\":\"(주)중문주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"2148164048\"},{\"WHSLD_ENP_NM\":\"(주)중문주류\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"2148164048\"},{\"WHSLD_ENP_NM\":\"GS25 송파공산\",\"DLIVY_QTY\":\"11200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"8968500048\"},{\"WHSLD_ENP_NM\":\"GS25 용인\",\"DLIVY_QTY\":\"792\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358505690\"},{\"WHSLD_ENP_NM\":\"GS25 용인\",\"DLIVY_QTY\":\"13696\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358505690\"},{\"WHSLD_ENP_NM\":\"㈜아신(서울종합물류센터)\",\"DLIVY_QTY\":\"-720\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358525546\"},{\"WHSLD_ENP_NM\":\"㈜아신(서울종합물류센터)\",\"DLIVY_QTY\":\"28344\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358525546\"},{\"WHSLD_ENP_NM\":\"기흥주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358100116\"},{\"WHSLD_ENP_NM\":\"기흥주류\",\"DLIVY_QTY\":\"90\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358100116\"},{\"WHSLD_ENP_NM\":\"기흥주류\",\"DLIVY_QTY\":\"400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358100116\"},{\"WHSLD_ENP_NM\":\"기흥주류\",\"DLIVY_QTY\":\"16290\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358100116\"},{\"WHSLD_ENP_NM\":\"대양주류(유)\",\"DLIVY_QTY\":\"17280\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1298627207\"},{\"WHSLD_ENP_NM\":\"롯데쇼핑(주)롯데신갈물류센터\",\"DLIVY_QTY\":\"8400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358528825\"},{\"WHSLD_ENP_NM\":\"쌍용종합주류판매(주)\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1068109424\"},{\"WHSLD_ENP_NM\":\"유한)태정종합주류상사\",\"DLIVY_QTY\":\"540\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358110477\"},{\"WHSLD_ENP_NM\":\"유한)태정종합주류상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358110477\"},{\"WHSLD_ENP_NM\":\"유한)태정종합주류상사\",\"DLIVY_QTY\":\"14040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358110477\"},{\"WHSLD_ENP_NM\":\"유한)태정종합주류상사\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"230201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358110477\"},{\"WHSLD_ENP_NM\":\"유한)태정종합주류상사\",\"DLIVY_QTY\":\"2960\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358110477\"},{\"WHSLD_ENP_NM\":\"유한회사 산수주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1298193226\"},{\"WHSLD_ENP_NM\":\"유한회사 산수주류\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1298193226\"},{\"WHSLD_ENP_NM\":\"유한회사 포도주류\",\"DLIVY_QTY\":\"360\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1298191325\"},{\"WHSLD_ENP_NM\":\"유한회사 포도주류\",\"DLIVY_QTY\":\"7680\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1298191325\"},{\"WHSLD_ENP_NM\":\"유한회사 포도주류\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1298191325\"},{\"WHSLD_ENP_NM\":\"주미성주류유한회사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358181797\"},{\"WHSLD_ENP_NM\":\"주미성주류유한회사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"1358181797\"},{\"WHSLD_ENP_NM\":\"진로새마을금고\",\"DLIVY_QTY\":\"40\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1358518803\",\"WHSLD_BIZRNO\":\"2148200532\"},{\"WHSLD_ENP_NM\":\"(유)금촌상사\",\"DLIVY_QTY\":\"2250\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288102625\"},{\"WHSLD_ENP_NM\":\"(유)금촌상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288102625\"},{\"WHSLD_ENP_NM\":\"(유)금촌상사\",\"DLIVY_QTY\":\"2800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288102625\"},{\"WHSLD_ENP_NM\":\"(유)금촌상사\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288102625\"},{\"WHSLD_ENP_NM\":\"(유)대림종합주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1118102710\"},{\"WHSLD_ENP_NM\":\"(유)대림종합주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1118102710\"},{\"WHSLD_ENP_NM\":\"(유)대림종합주류\",\"DLIVY_QTY\":\"15120\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1118102710\"},{\"WHSLD_ENP_NM\":\"(유)문산상사\",\"DLIVY_QTY\":\"180\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1418101518\"},{\"WHSLD_ENP_NM\":\"(유)문산상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1418101518\"},{\"WHSLD_ENP_NM\":\"(유)문산상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1418101518\"},{\"WHSLD_ENP_NM\":\"(유)문산상사\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1418101518\"},{\"WHSLD_ENP_NM\":\"(유)부영주류\",\"DLIVY_QTY\":\"100\",\"STD_CTNR_CD\":\"230201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288198873\"},{\"WHSLD_ENP_NM\":\"(유)부영주류\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288198873\"},{\"WHSLD_ENP_NM\":\"(유)부영주류\",\"DLIVY_QTY\":\"1120\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288198873\"},{\"WHSLD_ENP_NM\":\"(유)석송주류\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288176258\"},{\"WHSLD_ENP_NM\":\"(유)석송주류\",\"DLIVY_QTY\":\"17280\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288176258\"},{\"WHSLD_ENP_NM\":\"(유)세명주류\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1198169485\"},{\"WHSLD_ENP_NM\":\"(유)세진주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288188190\"},{\"WHSLD_ENP_NM\":\"(유)세진주류\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288188190\"},{\"WHSLD_ENP_NM\":\"(유)세진주류\",\"DLIVY_QTY\":\"33480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288188190\"},{\"WHSLD_ENP_NM\":\"(유)원창상사\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288108124\"},{\"WHSLD_ENP_NM\":\"(유)원창상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288108124\"},{\"WHSLD_ENP_NM\":\"(유)원창상사\",\"DLIVY_QTY\":\"7200\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288108124\"},{\"WHSLD_ENP_NM\":\"(유)원창상사\",\"DLIVY_QTY\":\"5620\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288108124\"},{\"WHSLD_ENP_NM\":\"(유)원창상사\",\"DLIVY_QTY\":\"6630\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288108124\"},{\"WHSLD_ENP_NM\":\"(유)은천상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1118121643\"},{\"WHSLD_ENP_NM\":\"(유)은천상사\",\"DLIVY_QTY\":\"1380\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1118121643\"},{\"WHSLD_ENP_NM\":\"(유)은천상사\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1118121643\"},{\"WHSLD_ENP_NM\":\"(유)은천상사\",\"DLIVY_QTY\":\"1540\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1118121643\"},{\"WHSLD_ENP_NM\":\"(유)은천상사\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1118121643\"},{\"WHSLD_ENP_NM\":\"(유)일산종합주류\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288176296\"},{\"WHSLD_ENP_NM\":\"(유)일산종합주류\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288176296\"},{\"WHSLD_ENP_NM\":\"(유)일산종합주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288176296\"},{\"WHSLD_ENP_NM\":\"(유)일산종합주류\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288176296\"},{\"WHSLD_ENP_NM\":\"(유)일산종합주류\",\"DLIVY_QTY\":\"14040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288176296\"},{\"WHSLD_ENP_NM\":\"(유)진두유통\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1068139234\"},{\"WHSLD_ENP_NM\":\"(유)태백진흥\",\"DLIVY_QTY\":\"2800\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1118102684\"},{\"WHSLD_ENP_NM\":\"(유)태백진흥\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1118102684\"},{\"WHSLD_ENP_NM\":\"(유)태영주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288188676\"},{\"WHSLD_ENP_NM\":\"(유)태영주류\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288188676\"},{\"WHSLD_ENP_NM\":\"(유)태영주류\",\"DLIVY_QTY\":\"180\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288188676\"},{\"WHSLD_ENP_NM\":\"(유)통일종합주류\",\"DLIVY_QTY\":\"780\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288119223\"},{\"WHSLD_ENP_NM\":\"(유)통일종합주류\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288119223\"},{\"WHSLD_ENP_NM\":\"(유)통일종합주류\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288119223\"},{\"WHSLD_ENP_NM\":\"(유)현대상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288102611\"},{\"WHSLD_ENP_NM\":\"(유)현대상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288102611\"},{\"WHSLD_ENP_NM\":\"(유한)만두유통\",\"DLIVY_QTY\":\"3600\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1098125438\"},{\"WHSLD_ENP_NM\":\"(유한)만두유통\",\"DLIVY_QTY\":\"2944\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1098125438\"},{\"WHSLD_ENP_NM\":\"(유한)만두유통\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1098125438\"},{\"WHSLD_ENP_NM\":\"(주)고양상사\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288102644\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부 목천지점\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"3128528382\"},{\"WHSLD_ENP_NM\":\"(주)극동연쇄점본부 목천지점\",\"DLIVY_QTY\":\"8528\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"3128528382\"},{\"WHSLD_ENP_NM\":\"(주)금성주류\",\"DLIVY_QTY\":\"760\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1118114045\"},{\"WHSLD_ENP_NM\":\"(주)금성주류\",\"DLIVY_QTY\":\"40\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1118114045\"},{\"WHSLD_ENP_NM\":\"(주)내성기업\",\"DLIVY_QTY\":\"4368\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"2198100772\"},{\"WHSLD_ENP_NM\":\"(주)내성기업\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"2198100772\"},{\"WHSLD_ENP_NM\":\"(주)내성기업\",\"DLIVY_QTY\":\"117552\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"2198100772\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"168\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)농협하나로유통평택물류센터\",\"DLIVY_QTY\":\"9648\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"4548500015\"},{\"WHSLD_ENP_NM\":\"(주)삼정주판\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288104720\"},{\"WHSLD_ENP_NM\":\"(주)삼정주판\",\"DLIVY_QTY\":\"2552\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288104720\"},{\"WHSLD_ENP_NM\":\"(주)서부상사\",\"DLIVY_QTY\":\"3480\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288101117\"},{\"WHSLD_ENP_NM\":\"(주)서부상사\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288101117\"},{\"WHSLD_ENP_NM\":\"(주)서울로직\",\"DLIVY_QTY\":\"1512\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1268612802\"},{\"WHSLD_ENP_NM\":\"(주)서울로직\",\"DLIVY_QTY\":\"7038\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1268612802\"},{\"WHSLD_ENP_NM\":\"(주)성포주류\",\"DLIVY_QTY\":\"8820\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1288188375\"},{\"WHSLD_ENP_NM\":\"(주)임성상사\",\"DLIVY_QTY\":\"90\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"2158663692\"},{\"WHSLD_ENP_NM\":\"(주)임성상사\",\"DLIVY_QTY\":\"17820\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"2158663692\"},{\"WHSLD_ENP_NM\":\"GS25 고양1\",\"DLIVY_QTY\":\"168\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1418500860\"},{\"WHSLD_ENP_NM\":\"GS25 고양1\",\"DLIVY_QTY\":\"14300\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1418500860\"},{\"WHSLD_ENP_NM\":\"유한회사신합상사\",\"DLIVY_QTY\":\"1840\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1118124280\"},{\"WHSLD_ENP_NM\":\"유한회사신합상사\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1118124280\"},{\"WHSLD_ENP_NM\":\"유한회사태경\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1418121794\"},{\"WHSLD_ENP_NM\":\"유한회사태경\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1418121794\"},{\"WHSLD_ENP_NM\":\"유한회사태경\",\"DLIVY_QTY\":\"11880\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1418121794\"},{\"WHSLD_ENP_NM\":\"주식회사진성통합\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1058103811\"},{\"WHSLD_ENP_NM\":\"주식회사진성통합\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1058103811\"},{\"WHSLD_ENP_NM\":\"주식회사진성통합\",\"DLIVY_QTY\":\"4320\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"1418502567\",\"WHSLD_BIZRNO\":\"1058103811\"},{\"WHSLD_ENP_NM\":\"(유한)한양주류합동\",\"DLIVY_QTY\":\"150\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218104539\"},{\"WHSLD_ENP_NM\":\"(유한)한양주류합동\",\"DLIVY_QTY\":\"16200\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218104539\"},{\"WHSLD_ENP_NM\":\"(유한)한양주류합동\",\"DLIVY_QTY\":\"20\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218104539\"},{\"WHSLD_ENP_NM\":\"(유한)한양주류합동\",\"DLIVY_QTY\":\"1400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218104539\"},{\"WHSLD_ENP_NM\":\"(유한)현대주류\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218107384\"},{\"WHSLD_ENP_NM\":\"(유한)현대주류\",\"DLIVY_QTY\":\"34560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218107384\"},{\"WHSLD_ENP_NM\":\"(자)선일종합주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218108383\"},{\"WHSLD_ENP_NM\":\"(자)호반주류\",\"DLIVY_QTY\":\"36\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218108350\"},{\"WHSLD_ENP_NM\":\"(자)호반주류\",\"DLIVY_QTY\":\"150\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218108350\"},{\"WHSLD_ENP_NM\":\"(자)호반주류\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218108350\"},{\"WHSLD_ENP_NM\":\"(주)춘천주류합동판매상사\",\"DLIVY_QTY\":\"1080\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218101115\"},{\"WHSLD_ENP_NM\":\"(주)춘천주류합동판매상사\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218101115\"},{\"WHSLD_ENP_NM\":\"(주)춘천주류합동판매상사\",\"DLIVY_QTY\":\"640\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218101115\"},{\"WHSLD_ENP_NM\":\"(합명)설악상사\",\"DLIVY_QTY\":\"2304\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2238100427\"},{\"WHSLD_ENP_NM\":\"농협하나로유통 강원지역센터\",\"DLIVY_QTY\":\"240\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"8388500644\"},{\"WHSLD_ENP_NM\":\"농협하나로유통 강원지역센터\",\"DLIVY_QTY\":\"14768\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"8388500644\"},{\"WHSLD_ENP_NM\":\"농협하나로유통 강원지역센터\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"8388500644\"},{\"WHSLD_ENP_NM\":\"대진상사(합자)\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218101089\"},{\"WHSLD_ENP_NM\":\"우리종합주류(명)\",\"DLIVY_QTY\":\"1440\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2238100238\"},{\"WHSLD_ENP_NM\":\"우리종합주류(명)\",\"DLIVY_QTY\":\"168\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2238100238\"},{\"WHSLD_ENP_NM\":\"우리종합주류(명)\",\"DLIVY_QTY\":\"40\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2238100238\"},{\"WHSLD_ENP_NM\":\"우리종합주류(명)\",\"DLIVY_QTY\":\"2480\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2238100238\"},{\"WHSLD_ENP_NM\":\"우리종합주류(명)\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2238100238\"},{\"WHSLD_ENP_NM\":\"유한회사진연사\",\"DLIVY_QTY\":\"840\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2238100223\"},{\"WHSLD_ENP_NM\":\"유한회사진연사\",\"DLIVY_QTY\":\"3600\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2238100223\"},{\"WHSLD_ENP_NM\":\"유한회사진연사\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2238100223\"},{\"WHSLD_ENP_NM\":\"유한회사진연사\",\"DLIVY_QTY\":\"300\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2238100223\"},{\"WHSLD_ENP_NM\":\"유한회사진연사\",\"DLIVY_QTY\":\"6480\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2238100223\"},{\"WHSLD_ENP_NM\":\"주식회사새시대체인\",\"DLIVY_QTY\":\"312\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218100377\"},{\"WHSLD_ENP_NM\":\"주식회사새시대체인\",\"DLIVY_QTY\":\"18644\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218100377\"},{\"WHSLD_ENP_NM\":\"주식회사화천주류판매상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218101100\"},{\"WHSLD_ENP_NM\":\"주식회사화천주류판매상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218101100\"},{\"WHSLD_ENP_NM\":\"주식회사화천주류판매상사\",\"DLIVY_QTY\":\"240\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218101100\"},{\"WHSLD_ENP_NM\":\"주식회사화천주류판매상사\",\"DLIVY_QTY\":\"2480\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218101100\"},{\"WHSLD_ENP_NM\":\"주식회사화천주류판매상사\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218101100\"},{\"WHSLD_ENP_NM\":\"합자회사춘성주류합동\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218101094\"},{\"WHSLD_ENP_NM\":\"합자회사춘성주류합동\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2218500341\",\"WHSLD_BIZRNO\":\"2218101094\"},{\"WHSLD_ENP_NM\":\"(주)강원남부주류\",\"DLIVY_QTY\":\"330\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"2248107869\"},{\"WHSLD_ENP_NM\":\"(주)강원남부주류\",\"DLIVY_QTY\":\"560\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"2248107869\"},{\"WHSLD_ENP_NM\":\"(주)모아주류판매\",\"DLIVY_QTY\":\"456\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"3188108450\"},{\"WHSLD_ENP_NM\":\"(주)모아주류판매\",\"DLIVY_QTY\":\"1230\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"3188108450\"},{\"WHSLD_ENP_NM\":\"(주)모아주류판매\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"3188108450\"},{\"WHSLD_ENP_NM\":\"(주)모아주류판매\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"3188108450\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 원주\",\"DLIVY_QTY\":\"7400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"5658500649\"},{\"WHSLD_ENP_NM\":\"(주)세븐 원주\",\"DLIVY_QTY\":\"7584\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"1438500696\"},{\"WHSLD_ENP_NM\":\"GS25 원주\",\"DLIVY_QTY\":\"168\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"2248520614\"},{\"WHSLD_ENP_NM\":\"GS25 원주\",\"DLIVY_QTY\":\"11200\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"2248520614\"},{\"WHSLD_ENP_NM\":\"농협하나로유통 강원지역센터\",\"DLIVY_QTY\":\"36\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"8388500644\"},{\"WHSLD_ENP_NM\":\"농협하나로유통 강원지역센터\",\"DLIVY_QTY\":\"1632\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"8388500644\"},{\"WHSLD_ENP_NM\":\"농협하나로유통 강원지역센터\",\"DLIVY_QTY\":\"27620\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"8388500644\"},{\"WHSLD_ENP_NM\":\"제1종합주류판매(주)\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"2248102734\"},{\"WHSLD_ENP_NM\":\"제1종합주류판매(주)\",\"DLIVY_QTY\":\"3560\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"2248102734\"},{\"WHSLD_ENP_NM\":\"제1종합주류판매(주)\",\"DLIVY_QTY\":\"8640\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"2248102734\"},{\"WHSLD_ENP_NM\":\"치악주류판매(명)\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"2248104315\"},{\"WHSLD_ENP_NM\":\"치악주류판매(명)\",\"DLIVY_QTY\":\"1230\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"2248104315\"},{\"WHSLD_ENP_NM\":\"치악주류판매(명)\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"2248104315\"},{\"WHSLD_ENP_NM\":\"합명회사평창주류합동\",\"DLIVY_QTY\":\"2552\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"2258100350\"},{\"WHSLD_ENP_NM\":\"합명회사평창주류합동\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2248501067\",\"WHSLD_BIZRNO\":\"2258100350\"},{\"WHSLD_ENP_NM\":\"(명)동해주류상사\",\"DLIVY_QTY\":\"14040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2278100701\"},{\"WHSLD_ENP_NM\":\"(명)동해주류상사\",\"DLIVY_QTY\":\"3400\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2278100701\"},{\"WHSLD_ENP_NM\":\"(유)경포주류판매상사\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2268104704\"},{\"WHSLD_ENP_NM\":\"(유)경포주류판매상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2268104704\"},{\"WHSLD_ENP_NM\":\"(유)경포주류판매상사\",\"DLIVY_QTY\":\"5940\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2268104704\"},{\"WHSLD_ENP_NM\":\"(유)경포주류판매상사\",\"DLIVY_QTY\":\"2780\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2268104704\"},{\"WHSLD_ENP_NM\":\"(유)명주합동주류\",\"DLIVY_QTY\":\"12960\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2268104757\"},{\"WHSLD_ENP_NM\":\"(유)명주합동주류\",\"DLIVY_QTY\":\"3880\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2268104757\"},{\"WHSLD_ENP_NM\":\"(자)대광상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2228100443\"},{\"WHSLD_ENP_NM\":\"(자)대광상사\",\"DLIVY_QTY\":\"336\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2228100443\"},{\"WHSLD_ENP_NM\":\"(자)대광상사\",\"DLIVY_QTY\":\"7560\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2228100443\"},{\"WHSLD_ENP_NM\":\"(자)대광상사\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2228100443\"},{\"WHSLD_ENP_NM\":\"(자)대광상사\",\"DLIVY_QTY\":\"15660\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2228100443\"},{\"WHSLD_ENP_NM\":\"(주)비지에프리테일 강릉\",\"DLIVY_QTY\":\"168\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"1108532276\"},{\"WHSLD_ENP_NM\":\"(주)속초합동상사\",\"DLIVY_QTY\":\"34560\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2278100356\"},{\"WHSLD_ENP_NM\":\"(주)속초합동상사\",\"DLIVY_QTY\":\"60\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2278100356\"},{\"WHSLD_ENP_NM\":\"(주)속초합동상사\",\"DLIVY_QTY\":\"5600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2278100356\"},{\"WHSLD_ENP_NM\":\"GS25 강릉\",\"DLIVY_QTY\":\"19600\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"5578500522\"},{\"WHSLD_ENP_NM\":\"농협하나로유통 강원지역센터\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"8388500644\"},{\"WHSLD_ENP_NM\":\"농협하나로유통 강원지역센터\",\"DLIVY_QTY\":\"7688\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"8388500644\"},{\"WHSLD_ENP_NM\":\"삼성주류 주식회사\",\"DLIVY_QTY\":\"450\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"6278600094\"},{\"WHSLD_ENP_NM\":\"삼원주류판매(명)\",\"DLIVY_QTY\":\"600\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2228100458\"},{\"WHSLD_ENP_NM\":\"삼원주류판매(명)\",\"DLIVY_QTY\":\"590\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"2268505318\",\"WHSLD_BIZRNO\":\"2228100458\"},{\"WHSLD_ENP_NM\":\"(자)우진상사\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3048101889\"},{\"WHSLD_ENP_NM\":\"(자)우진상사\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3048101889\"},{\"WHSLD_ENP_NM\":\"(자)우진상사\",\"DLIVY_QTY\":\"10800\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3048101889\"},{\"WHSLD_ENP_NM\":\"(자)우진상사\",\"DLIVY_QTY\":\"3952\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3048101889\"},{\"WHSLD_ENP_NM\":\"(자)우진상사\",\"DLIVY_QTY\":\"200\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3048101889\"},{\"WHSLD_ENP_NM\":\"(주)대양물산\",\"DLIVY_QTY\":\"3240\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3048100842\"},{\"WHSLD_ENP_NM\":\"(합자)광성합동상사\",\"DLIVY_QTY\":\"13110\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3038100999\"},{\"WHSLD_ENP_NM\":\"(합자)광성합동상사\",\"DLIVY_QTY\":\"2552\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3038100999\"},{\"WHSLD_ENP_NM\":\"(합자)상동주류\",\"DLIVY_QTY\":\"396\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"2258100670\"},{\"WHSLD_ENP_NM\":\"(합자)상동주류\",\"DLIVY_QTY\":\"36\",\"STD_CTNR_CD\":\"231202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"2258100670\"},{\"WHSLD_ENP_NM\":\"(합자)상동주류\",\"DLIVY_QTY\":\"5400\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"2258100670\"},{\"WHSLD_ENP_NM\":\"충북제천수퍼마켓협동조합\",\"DLIVY_QTY\":\"672\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3048202570\"},{\"WHSLD_ENP_NM\":\"충북제천수퍼마켓협동조합\",\"DLIVY_QTY\":\"10272\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3048202570\"},{\"WHSLD_ENP_NM\":\"합명회사청호주류\",\"DLIVY_QTY\":\"720\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3048101216\"},{\"WHSLD_ENP_NM\":\"합명회사청호주류\",\"DLIVY_QTY\":\"14040\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3048101216\"},{\"WHSLD_ENP_NM\":\"합명회사청호주류\",\"DLIVY_QTY\":\"3560\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3048101216\"},{\"WHSLD_ENP_NM\":\"합명회사탄금합동\",\"DLIVY_QTY\":\"120\",\"STD_CTNR_CD\":\"331202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3038100441\"},{\"WHSLD_ENP_NM\":\"합명회사탄금합동\",\"DLIVY_QTY\":\"11520\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3038100441\"},{\"WHSLD_ENP_NM\":\"합명회사탄금합동\",\"DLIVY_QTY\":\"4240\",\"STD_CTNR_CD\":\"231001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3038100441\"},{\"WHSLD_ENP_NM\":\"합명회사탄금합동\",\"DLIVY_QTY\":\"400\",\"STD_CTNR_CD\":\"231201\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3048503245\",\"WHSLD_BIZRNO\":\"3038100441\"},{\"WHSLD_ENP_NM\":\"(유)남부상사\",\"DLIVY_QTY\":\"2160\",\"STD_CTNR_CD\":\"330202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3028101184\"},{\"WHSLD_ENP_NM\":\"(유)남부상사\",\"DLIVY_QTY\":\"2340\",\"STD_CTNR_CD\":\"230202\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3028101184\"},{\"WHSLD_ENP_NM\":\"(유)남부상사\",\"DLIVY_QTY\":\"9720\",\"STD_CTNR_CD\":\"230001\",\"DLIVY_DT\":\"20180726\",\"DTSS_NO\":\"3058527691\",\"WHSLD_BIZRNO\":\"3028101184\"}],\"TRMS_DT\":\"20180730\",\"TRMS_TKTM\":\"152403\",\"MBR_ISSU_KEY\":\"vVX+j2yAEvsRUBlvZb5ZtvJ0d1Yy8A1UbzCG9aiYAfI=\",\"API_ID\":\"AP_R01\",\"REG_DIV\":\"I\"}";
			
			//HashMap<String, Object> main_obj = (HashMap<String, Object>)inputMap.get("MAIN_OBJ");

			System.out.println("ori : " + mainObj.toString());
			System.out.println("jsp : " + mObj.toString());
			
			
			//boolean result = RealSend(mainObj.toString(), "");
			//errCd = RealSend(mainObj2.toString(), inputMap.get("IP").toString());
			errCd = RealSend(mainObj.toString(), inputMap.get("IP").toString());
			//boolean result = RealSend(apiStr, "json");
			
			System.out.println("ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd : " + errCd);
			
			
			
		} catch (Exception e) {
			errCd = e.getMessage();
			e.printStackTrace();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}
	
	//테스트용
	public static String RealSend(String sendData, String ip){
		String rtn = "0000";
		//String doUrl = "http://175.115.52.202/api/recvJsonData.do"; //임시주소 @#@#
		String doUrl = "http://"+ip+"/api/recvJsonData.do"; //임시주소 @#@#
		
		HttpURLConnection connection = null;
		OutputStream os =null;
		BufferedReader br = null;
		try{

			//전송할 서버 url
			URL url = new URL(doUrl);
			sendData = URLEncoder.encode(sendData, "utf-8");

			connection = (HttpURLConnection)url.openConnection();
			connection.setRequestProperty("Content-Type", "text/html");
			connection.setRequestMethod("POST");
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setUseCaches(false);
			//connection.setConnectTimeout(1000);
			//connection.setReadTimeout(1000);

			os = connection.getOutputStream();

			os.write( sendData.getBytes("utf-8") );
			os.flush();
			os.close();
			
			//결과값 수신
			int rc = connection.getResponseCode();
			
			if(rc==200){
				StringBuffer sb = new StringBuffer();
				String str = "";
				//CHECKPOINT	부적절한 자원 해제
				br = new BufferedReader(new InputStreamReader((connection.getInputStream())));
				while( (str = br.readLine()) !=null) {      
					sb.append(URLDecoder.decode(str, "utf-8"));
				}

				JSONObject data = JSONObject.fromObject(sb.toString());
				System.out.println("결과 수신값 : " + sb.toString());
				System.out.println("RSLT_CD=======" + data.get("RSLT_CD"));
				System.out.println("RSLT_MSG=======" + data.get("RSLT_MSG"));
				System.out.println("RSLT_DT=======" + data.get("RSLT_DT"));
				System.out.println("RSLT_TKTM=======" + data.get("RSLT_TKTM"));
				rtn = data.get("RSLT_CD").toString();
			}else{
				StringBuffer sb = new StringBuffer();
				String str = "";
				br = new BufferedReader(new InputStreamReader((connection.getErrorStream())));
				while( (str = br.readLine()) !=null) {      
					sb.append(URLDecoder.decode(str, "utf-8"));
				}

				JSONObject data = JSONObject.fromObject(sb.toString());
				System.out.println("결과 수신값 : " + sb.toString());
				System.out.println("RSLT_CD=======" + data.get("RSLT_CD"));
				System.out.println("RSLT_MSG=======" + data.get("RSLT_MSG"));
				System.out.println("RSLT_DT=======" + data.get("RSLT_DT"));
				System.out.println("RSLT_TKTM=======" + data.get("RSLT_TKTM"));
				//System.out.println("http response code error: "+rc+"\n");
				//connection.getErrorStream();
				rtn = data.get("RSLT_CD").toString();
			}
		} catch(UnknownHostException ue){
			//System.out.println("UnknownHostException : " + ue.getMessage());
		} catch( IOException e ){
			//System.out.println("search URL connect failed: " + e.getMessage());
			rtn = "9999";
		} catch (Exception e) {
			System.out.println("failed: " + e.getMessage());
			rtn = "8888";
		} finally{
			if(os!=null){
				try {
					os.close();
				} catch (IOException e) {

				}
				connection.disconnect();
			}
			if(br!=null) {
				try {
					br.close();
				}catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return rtn;
	}

	/**
	 * 모바일사용자정보 업데이트
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/UPDATE_EPCN_MBL_USER_INFO.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public void updateMblUserInfo(@RequestParam HashMap<String, String> paramMap, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		commonceService.updateMblUserInfo(paramMap);
	}
	
	/**
	 * 모바일 로그아웃
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/MBL_USER_LOGOUT.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String mblLogOut(@RequestParam HashMap<String, String> paramMap, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		commonceService.logOut(request);
		HashMap<String, String> rtnMap = new HashMap<String, String>();
		rtnMap.put("RSLT_CD", "00000000");
		return util.mapToJson(rtnMap).toString();
	}

	
	/**
	 * 개인정보취급방침 변경 동의
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/UPDATE_PRSN_INFO_CHG_AGR_YN.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String updatePrsnInfoChgAgrYn (@RequestParam HashMap<String, String> paramMap, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		String errCd = "";
		
		try{
			errCd = commonceService.updatePrsnInfoChgAgrYn(paramMap);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}


	/**
	 * 모바일 앱 이미지 저장용
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value="/MAIN/APP_IMG_SAVE.do")
	public void regAppImgInfo(@RequestParam HashMap<String, String> map, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//HttpSession session = request.getSession();
		//UserVO vo = (UserVO)session.getAttribute("userSession");
		
		System.out.println("[GODCOM] " + map.toString());
		
		JSONObject rtnObj = new JSONObject();
		String errCd = "0000";
		
		try{
			errCd = epce2925801Service.saveEpcmRtnPrfFileApp(request);
			
			System.out.println("ERRCD : " + errCd);
	        
		}catch(IOException e){
			e.printStackTrace();
			errCd = "B999";	//"파일 수신오류"
			System.out.println("sssssssssss : " + errCd);
		}catch(JSONException e){
			e.printStackTrace();
			errCd = "B009";	//"josn 형식 불일치"
			System.out.println("sssssssssss : " + errCd);
		}catch(SQLException e){
			e.printStackTrace();
			errCd = "B003";	//db처리 오류
			System.out.println("sssssssssss : " + errCd);
		}catch(Exception e){
			e.printStackTrace();
			errCd = e.getMessage();
			System.out.println("sssssssssss : " + errCd);
		}
		
		String sysSe = "B";
		if(errCd.indexOf("A") > -1) sysSe = "A";
		
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsg(sysSe, errCd));
		String rslt = URLEncoder.encode(rtnObj.toString(), "utf-8");
		
		response.setContentType("application/text");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		try{
			out.print(rslt);
			out.flush();
			out.close();
		}catch(Exception e){
			e.printStackTrace();
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}finally{
			if(out != null) out.close();
		}
		
    }
}
