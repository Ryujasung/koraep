/**
 * 
 */
package egovframework.koraep.ce.ep.service;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.security.GeneralSecurityException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.io.FilenameUtils;
import org.apache.logging.log4j.core.Logger;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.WebUtils;

import egovframework.common.AES256Util;
import egovframework.common.CommonProperties;
import egovframework.common.ExcelReader;
import egovframework.common.UserSessionManager;
import egovframework.common.encrypt;
import egovframework.common.util;
import egovframework.koraep.auth.service.UserAuthCheckService;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.CommonCeMapper;

/**
 * @author Administrator
 *
 */
@Service("commonceService")
public class CommonCeService{

	@Resource(name="commonceMapper")
	private CommonCeMapper commonceMapper;
	
	@Resource(name="userAuthCheckService")
	private UserAuthCheckService userAuthCheckService;
	
	//private static final Logger logger = (Logger) LoggerFactory.getLogger(CommonCeService.class);
	/**
	 * 로그인 체크 
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	@Transactional
	public HashMap<String, String> loginCheck(HashMap<String, String> map, HttpServletRequest request, HttpServletResponse response) {
		
		HttpSession session = request.getSession(); 
		System.out.println("session"+session);
		System.out.println("session"+session.toString());
		System.out.println("CsrfToken"+(CsrfToken)request.getAttribute("_csrf"));
		
		
		String msg = "";
		
		String ssoId = util.null2void(map.get("SSO_ID"));
		if(!ssoId.equals("")) map.put("USER_ID", ssoId);
		
		map.put("UPD_PRSN_ID", map.get("USER_ID"));
		map.put("RGST_PRSN_ID", map.get("USER_ID"));
		map.put("REG_ID", map.get("USER_ID"));
		
		UserVO vo = commonceMapper.SELECT_USER_VO(map);
		int aa = vo.getLGN_ERR_TMS();
		if(vo == null || vo.getUSER_ID() == null ){
			//CHECKPOINT : NULL 역참조
			if(aa <= 4){
				msg = "아이디 또는 비밀번호가 맞지않습니다. 오류횟수 (" +aa+"/5).\n다시한번 확인 하시기 바랍니다.";
				
			}else{
				msg = "비밀번호 오류 회수(5회)가 초과 되었습니다. \n비밀번호 변경요청을 하시기 바랍니다.";
			}
		}
		else if(!vo.getALT_REQ_STAT_CD().equals("0") || vo.getBIZR_STAT_CD().equals("W")){
			msg = "승인대기 상태의 사업자입니다. \n센터 승인 후 사용하시기 바랍니다.";
		}
		else if(vo.getBIZR_STAT_CD() == null || !vo.getBIZR_STAT_CD().equals("Y")){
			msg = "비활동 사업자 회원입니다. \n관리자에게 문의 하시기 바랍니다.";
		}
		else if(vo.getUSER_STAT_CD().equals("N")){//사용자상태 1-활동, 2-비활동, 9-승인대기
			msg = "비활동 상태의 회원입니다. \n해당 사업자 관리자에게 문의 하시기 바랍니다.";
		}
		else if(vo.getUSER_STAT_CD().equals("W")){//사용자상태 1-활동, 2-비활동, 9-승인대기
			msg = "승인대기 상태의 회원입니다. \n해당 사업자 관리자 승인 후 사용하시기 바랍니다.";
		}
		else if(vo.getPWD_ALT_REQ_YN().equals("Y")){//비밀번호변경 Y:요청 N:미요청
			msg = "비밀번호 변경요청에 대한 사업자 관리 승인 후, \n변경된 비밀번호로 로그인하실 수 있습니다.";
		} 
		else if(ssoId.equals("") && vo.getLGN_ERR_TMS() >= 6){
			msg = "비밀번호 오류 회수(5회)가 초과 되었습니다. \n비밀번호 변경요청을 하시기 바랍니다.";
		} else {
			
		}
		//세션 저장
		session.setAttribute("userSession", vo);
		
		HashMap<String, String> rtnMap = new HashMap<String, String>();
		rtnMap.put("noti", "");
		
		//csrf 토큰값이 변경됨.. 재설정 처리필요
		CsrfToken token = (CsrfToken)request.getAttribute("_csrf");
		rtnMap.put("_csrf", token.getToken());
		String _csrf = token.getToken();
		System.out.println("LOGIN : "+_csrf);
		if(!msg.equals("")){
			rtnMap.put("msg", msg);
			return rtnMap;
		}
		
		if(Integer.parseInt(String.valueOf(vo.getPWD_CHG_MM())) >= 6) rtnMap.put("noti", "패스워드 유효기간(6개월)이 만료되었습니다. \n변경 후 사용하시기 바랍니다.");
		
		//중복 로그인 체크 - 이전 세션삭제 및 접속 강제종료 처리
		UserSessionManager usm = UserSessionManager.getInstance();
		if(usm.isUsingValue(String.valueOf(vo.getUSER_ID()))){
			usm.removeSessionValue(String.valueOf(vo.getUSER_ID()));
			map.put("USER_ID", String.valueOf(vo.getUSER_ID()));
			commonceMapper.UPDATE_FORCE_LOGOUT_HIST(map);	
		}
		usm.addSession(session.getId(), vo.getUSER_ID().toString());	//싱글톤에 세션저장
		
		//List<?> list = commonceMapper.SELECT_USER_MENU_LIST(vo);
		//vo.setUSER_MENU_LIST(list);

		session.setAttribute("EXCEL_AUTH_YN", "Y");
		
		String userAgent = request.getHeader("User-Agent");
		String accsBrsr  = "";
		
		/*
		 * 브라우저 및 OS 분류 참고사이트
		 * http://www.happyjung.com/lecture/1564
		 */
		if(userAgent.indexOf("Firefox") > 0)      accsBrsr = "Firefox / ";
		else if(userAgent.indexOf("rv:11") > 0)   accsBrsr = "Explorer 11 / ";
		else if(userAgent.indexOf("MSIE 10") > 0) accsBrsr = "Explorer 10 / ";
		else if(userAgent.indexOf("MSIE 9") > 0)  accsBrsr = "Explorer 9 / ";
		else if(userAgent.indexOf("MSIE 8") > 0)  accsBrsr = "Explorer 8 / ";
		else if(userAgent.indexOf("MSIE 7") > 0)  accsBrsr = "Explorer 7 / ";
		else if(userAgent.indexOf("MSIE 6") > 0)  accsBrsr = "Explorer 6 / ";
		else if(userAgent.indexOf("Edge") > 0)    accsBrsr = "Edge / ";
		else if(userAgent.indexOf("Chrome") > 0)  accsBrsr = "Chrome / ";
		else if(userAgent.indexOf("Safari") > 0)  accsBrsr = "Safari / ";

		if(userAgent.indexOf("Windows") > 0)         accsBrsr += "Windows";
		else if(userAgent.indexOf("Android") > 0)    accsBrsr += "Android";
		else if(userAgent.indexOf("iPhone") > 0)     accsBrsr += "iPhone";
		else if(userAgent.indexOf("iPad") > 0)       accsBrsr += "iPad";
		else if(userAgent.indexOf("iPod") > 0)       accsBrsr += "iPod";
		else if(userAgent.indexOf("Machintosh") > 0) accsBrsr += "Machintosh";
		
		//로그인 이력 등록 및 최종 로그인등록일시 업데이트 
		map.put("ACSS_IP", request.getRemoteAddr());
		map.put("SESSION_ID", session.getId());
		map.put("ACCS_BRSR", accsBrsr);
		
		commonceMapper.INSERT_LOGIN_HIST(map);
		commonceMapper.UPDATE_LAST_LOGIN_DTTM(map);
		
		//CHECKPOINT 널 역참조
		if(vo != null) {
			rtnMap.put("USER_ID", String.valueOf(vo.getUSER_ID()));
			rtnMap.put("USER_SE_CD", String.valueOf(vo.getUSER_SE_CD()));
			rtnMap.put("USER_NM", String.valueOf(vo.getUSER_NM()));
			rtnMap.put("CET_BROF_CD", String.valueOf(vo.getCET_BRCH_CD()));
			rtnMap.put("GRP_CD", String.valueOf(vo.getGRP_CD()));
			rtnMap.put("GRP_NM", String.valueOf(vo.getGRP_NM()));
			rtnMap.put("BIZRNM", String.valueOf(vo.getBIZRNM()));
			rtnMap.put("LAST_LGN_DT", String.valueOf(vo.getLAST_LGN_DTTM()));
			rtnMap.put("PRSN_INFO_CHG_AGR_YN", String.valueOf(vo.getPRSN_INFO_CHG_AGR_YN()));
			rtnMap.put("BIZR_TP_CD", String.valueOf(vo.getBIZR_TP_CD()));
			rtnMap.put("AFF_OGN_CD", String.valueOf(vo.getAFF_OGN_CD()));
			rtnMap.put("ERP_CD", String.valueOf(vo.getERP_CD()));
			rtnMap.put("ERP_LK_DT", String.valueOf(vo.getERP_LK_DT()));
			rtnMap.put("ERP_CFM_YN", String.valueOf(vo.getERP_CFM_YN()));
			rtnMap.put("ERP_CD_NM", String.valueOf(vo.getERP_CD_NM()));
			
			rtnMap.put("svyMsg","");
		}
		
		
		//20200317 보나뱅크 ERP 설문조사  끝나면 원복할 소스
		List<?> svylist = commonceMapper.SELECT_SVY_MST_LIST(vo);
		if(svylist != null && svylist.size() > 0){
			HashMap<String, String> tmpMap = (HashMap<String, String>)svylist.get(0);
			rtnMap.put("svyMsg","[" + tmpMap.get("DT") + "] 동안, \n[" +tmpMap.get("SBJ") + "] 에 대한 설문조사를 진행하오니, \n참여해주시기 바랍니다.");
			rtnMap.put("popupYn", tmpMap.get("POPUP_YN"));
		}
		
		//20200317 보나뱅크 ERP 사업자 로그인 시 설문 
//		if( "E02".equals(vo.getERP_CD()) || "E01".equals(vo.getERP_CD())){
//			if( "W".equals(vo.getBIZR_TP_CD()) || "W1".equals(vo.getBIZR_TP_CD())){
//				List<?> svylist = commonceMapper.SELECT_SVY_MST_LIST2(vo);
//				if(svylist != null && svylist.size() > 0){
//					HashMap<String, String> tmpMap = (HashMap<String, String>)svylist.get(0);
//					rtnMap.put("svyMsg","[" + tmpMap.get("DT") + "] 동안, \n[" +tmpMap.get("SBJ") + "] 에 대한 설문조사를 진행하오니, \n참여해주시기 바랍니다.");
//					rtnMap.put("popupYn", tmpMap.get("POPUP_YN"));
//					
//				}
//			}else{
//				List<?> svylist = commonceMapper.SELECT_SVY_MST_LIST(vo);
//				if(svylist != null && svylist.size() > 0){
//					HashMap<String, String> tmpMap = (HashMap<String, String>)svylist.get(0);
//					rtnMap.put("svyMsg","[" + tmpMap.get("DT") + "] 동안, \n[" +tmpMap.get("SBJ") + "] 에 대한 설문조사를 진행하오니, \n참여해주시기 바랍니다.");
//					rtnMap.put("popupYn", tmpMap.get("POPUP_YN"));
//				}
//			}
//			
//		}else{
//			List<?> svylist = commonceMapper.SELECT_SVY_MST_LIST(vo);
//			if(svylist != null && svylist.size() > 0){
//				HashMap<String, String> tmpMap = (HashMap<String, String>)svylist.get(0);
//				rtnMap.put("svyMsg","[" + tmpMap.get("DT") + "] 동안, \n[" +tmpMap.get("SBJ") + "] 에 대한 설문조사를 진행하오니, \n참여해주시기 바랍니다.");
//				rtnMap.put("popupYn", tmpMap.get("POPUP_YN"));
//			}
//			
//		}
		
		
		
		//String dtssNo = vo.getCG_DTSS_NO();
		//if(dtssNo == null) dtssNo = "";
		//rtnMap.put("CG_DTSS_NO", dtssNo);
		
		return rtnMap;
	}
	
	/**
	 * 20200323 로그인 체크(설문 취소 시) 
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	@Transactional
	public HashMap<String, String> loginCheck3(HashMap<String, String> map, HttpServletRequest request, HttpServletResponse response) {
		
		HttpSession session = request.getSession();
		String msg = "";
//		
//		String ssoId = util.null2void(map.get("SSO_ID"));
//		if(!ssoId.equals("")) map.put("USER_ID", ssoId);
//		
//		map.put("UPD_PRSN_ID", map.get("USER_ID"));
//		map.put("RGST_PRSN_ID", map.get("USER_ID"));
//		map.put("REG_ID", map.get("USER_ID"));
//		
//		UserVO vo = commonceMapper.SELECT_USER_VO(map);
//		
//		if(vo == null || vo.getUSER_ID() == null){
//			msg = "아이디 또는 비밀번호가 맞지않습니다.\n다시한번 확인 하시기 바랍니다.";
//		}
//		else if(!vo.getALT_REQ_STAT_CD().equals("0") || vo.getBIZR_STAT_CD().equals("W")){
//			msg = "승인대기 상태의 사업자입니다. \n센터 승인 후 사용하시기 바랍니다.";
//		}
//		else if(vo.getBIZR_STAT_CD() == null || !vo.getBIZR_STAT_CD().equals("Y")){
//			msg = "비활동 사업자 회원입니다. \n관리자에게 문의 하시기 바랍니다.";
//		}
//		else if(vo.getUSER_STAT_CD().equals("N")){//사용자상태 1-활동, 2-비활동, 9-승인대기
//			msg = "비활동 상태의 회원입니다. \n해당 사업자 관리자에게 문의 하시기 바랍니다.";
//		}
//		else if(vo.getUSER_STAT_CD().equals("W")){//사용자상태 1-활동, 2-비활동, 9-승인대기
//			msg = "승인대기 상태의 회원입니다. \n해당 사업자 관리자 승인 후 사용하시기 바랍니다.";
//		}
//		else if(ssoId.equals("") && vo.getLGN_ERR_TMS() > 4){
//			msg = "비밀번호 오류 회수(5회)가 초과 되었습니다. \n비밀번호 변경요청을 하시기 바랍니다.";
//		}
//		else if(vo.getPWD_ALT_REQ_YN().equals("Y")){//비밀번호변경 Y:요청 N:미요청
//			msg = "비밀번호 변경 승인대기 상태의 회원입니다. \n해당 사업자 관리자에게 문의 하시기 바랍니다.";
//		} 
//		
//		//세션 저장
//		session.setAttribute("userSession", vo);
		
		UserVO vo = (UserVO) session.getAttribute("userSession");
		
		HashMap<String, String> rtnMap = new HashMap<String, String>();
		rtnMap.put("noti", "");
		
		//csrf 토큰값이 변경됨.. 재설정 처리필요
		CsrfToken token = (CsrfToken)request.getAttribute("_csrf");
		rtnMap.put("_csrf", token.getToken());
		
		if(!msg.equals("")){
			rtnMap.put("msg", msg);
			return rtnMap;
		}
		
		if(vo.getPWD_CHG_MM() >= 6) rtnMap.put("noti", "패스워드 유효기간(6개월)이 만료되었습니다. \n변경 후 사용하시기 바랍니다.");
		
		//중복 로그인 체크 - 이전 세션삭제 및 접속 강제종료 처리
		UserSessionManager usm = UserSessionManager.getInstance();
		if(usm.isUsingValue(vo.getUSER_ID())){
			usm.removeSessionValue(vo.getUSER_ID());
			map.put("USER_ID", vo.getUSER_ID());
			commonceMapper.UPDATE_FORCE_LOGOUT_HIST(map);	
		}
		usm.addSession(session.getId(), vo.getUSER_ID());	//싱글톤에 세션저장
		
		//List<?> list = commonceMapper.SELECT_USER_MENU_LIST(vo);
		//vo.setUSER_MENU_LIST(list);

		session.setAttribute("EXCEL_AUTH_YN", "Y");
		
		String userAgent = request.getHeader("User-Agent");
		String accsBrsr  = "";
		
		/*
		 * 브라우저 및 OS 분류 참고사이트
		 * http://www.happyjung.com/lecture/1564
		 */
		if(userAgent.indexOf("Firefox") > 0)      accsBrsr = "Firefox / ";
		else if(userAgent.indexOf("rv:11") > 0)   accsBrsr = "Explorer 11 / ";
		else if(userAgent.indexOf("MSIE 10") > 0) accsBrsr = "Explorer 10 / ";
		else if(userAgent.indexOf("MSIE 9") > 0)  accsBrsr = "Explorer 9 / ";
		else if(userAgent.indexOf("MSIE 8") > 0)  accsBrsr = "Explorer 8 / ";
		else if(userAgent.indexOf("MSIE 7") > 0)  accsBrsr = "Explorer 7 / ";
		else if(userAgent.indexOf("MSIE 6") > 0)  accsBrsr = "Explorer 6 / ";
		else if(userAgent.indexOf("Edge") > 0)    accsBrsr = "Edge / ";
		else if(userAgent.indexOf("Chrome") > 0)  accsBrsr = "Chrome / ";
		else if(userAgent.indexOf("Safari") > 0)  accsBrsr = "Safari / ";

		if(userAgent.indexOf("Windows") > 0)         accsBrsr += "Windows";
		else if(userAgent.indexOf("Android") > 0)    accsBrsr += "Android";
		else if(userAgent.indexOf("iPhone") > 0)     accsBrsr += "iPhone";
		else if(userAgent.indexOf("iPad") > 0)       accsBrsr += "iPad";
		else if(userAgent.indexOf("iPod") > 0)       accsBrsr += "iPod";
		else if(userAgent.indexOf("Machintosh") > 0) accsBrsr += "Machintosh";
		
		//로그인 이력 등록 및 최종 로그인등록일시 업데이트 
		map.put("ACSS_IP", request.getRemoteAddr());
		map.put("SESSION_ID", session.getId());
		map.put("ACCS_BRSR", accsBrsr);
		
//		commonceMapper.INSERT_LOGIN_HIST(map);
//		commonceMapper.UPDATE_LAST_LOGIN_DTTM(map);
		if(vo != null) {
			rtnMap.put("USER_ID", vo.getUSER_ID());
			rtnMap.put("USER_SE_CD", vo.getUSER_SE_CD());
			rtnMap.put("USER_NM", vo.getUSER_NM());
			rtnMap.put("CET_BROF_CD", vo.getCET_BRCH_CD());
			rtnMap.put("GRP_CD", vo.getGRP_CD());
			rtnMap.put("GRP_NM", vo.getGRP_NM());
			rtnMap.put("BIZRNM", vo.getBIZRNM());
			rtnMap.put("LAST_LGN_DT", vo.getLAST_LGN_DTTM());
			rtnMap.put("PRSN_INFO_CHG_AGR_YN", vo.getPRSN_INFO_CHG_AGR_YN());
			rtnMap.put("BIZR_TP_CD", vo.getBIZR_TP_CD());
			rtnMap.put("AFF_OGN_CD", vo.getAFF_OGN_CD());
			rtnMap.put("ERP_CD", vo.getERP_CD());
			rtnMap.put("ERP_LK_DT", vo.getERP_LK_DT());
			rtnMap.put("ERP_CFM_YN", vo.getERP_CFM_YN());
			rtnMap.put("ERP_CD_NM", vo.getERP_CD_NM());
			
			rtnMap.put("svyMsg","");
		}
		
		
		
		//String dtssNo = vo.getCG_DTSS_NO();
		//if(dtssNo == null) dtssNo = "";
		//rtnMap.put("CG_DTSS_NO", dtssNo);
		
		return rtnMap;
	}
	
	/**
	 * 로그인 체크 
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	@Transactional
	public HashMap<String, String> loginCheck_sso(HashMap<String, String> map, HttpServletRequest request, HttpServletResponse response) {
		
		HttpSession session = request.getSession();
		String msg = "";
		String ssoId = util.null2void(map.get("SSO_ID"));
		if(!ssoId.equals("")) map.put("USER_ID", ssoId);
		
		map.put("UPD_PRSN_ID", map.get("USER_ID"));
		map.put("RGST_PRSN_ID", map.get("USER_ID"));
		map.put("REG_ID", map.get("USER_ID"));
		
		UserVO vo = commonceMapper.SELECT_USER_VO(map);
		int aa = vo.getLGN_ERR_TMS();
		if(vo == null || vo.getUSER_ID() == null ){
			//CHECKPOINT int형 aa 로 조건비교
			if(aa <= 4){
				msg = "아이디 또는 비밀번호가 맞지않습니다. 오류횟수 (" +aa+"/5).\n다시한번 확인 하시기 바랍니다.";
			}else{
				msg = "비밀번호 오류 회수(5회)가 초과 되었습니다. \n비밀번호 변경요청을 하시기 바랍니다.";
			}
		
		}else if(vo.getBIZR_STAT_CD() == null || !vo.getBIZR_STAT_CD().equals("Y")){
			msg = "비활동 사업자 회원입니다. \n관리자에게 문의 하시기 바랍니다.";
		}else if(!vo.getALT_REQ_STAT_CD().equals("0")){
			msg = "승인대기 상태의 사업자입니다. \n센터 승인 후 사용하시기 바랍니다.";
		}else if(vo.getUSER_STAT_CD().equals("N")){//사용자상태 1-활동, 2-비활동, 9-승인대기
			msg = "비활동 상태의 회원입니다. \n해당 사업자 관리자에게 문의 하시기 바랍니다.";
		}else if(vo.getUSER_STAT_CD().equals("W")){//사용자상태 1-활동, 2-비활동, 9-승인대기
			msg = "승인대기 상태의 회원입니다. \n해당 사업자 관리자 승인 후 사용하시기 바랍니다.";
		}else if(vo.getPWD_ALT_REQ_YN().equals("Y")){//비밀번호변경 Y:요청 N:미요청
			msg = "비밀번호 변경요청에 대한 사업자 관리 승인 후, \n변경된 비밀번호로 로그인하실 수 있습니다.";
		}else if(ssoId.equals("") && aa >= 6){
			msg = "비밀번호 오류 회수(5회)가 초과 되었습니다. \n비밀번호 변경요청을 하시기 바랍니다.";
		} 
		
		UserDetails user = userAuthCheckService.loadUserByUsername(vo.getUSER_ID());
		
		try{
			Authentication authentication = new UsernamePasswordAuthenticationToken(user.getUsername(), user.getPassword(), user.getAuthorities());
		    SecurityContext securityContext = SecurityContextHolder.getContext();
		    securityContext.setAuthentication(authentication);
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			e.getMessage();
		}
		
		//세션 저장
		session.setAttribute("userSession", vo);
		
		HashMap<String, String> rtnMap = new HashMap<String, String>();
		rtnMap.put("noti", "");
		
		//csrf 토큰값이 변경됨.. 재설정 처리필요
		CsrfToken token = (CsrfToken)request.getAttribute("_csrf");
		rtnMap.put("_csrf", token.getToken());
		
		if(!msg.equals("")){
			rtnMap.put("msg", msg);
			return rtnMap;
		}
		//CHECKPOINT 단순히 getpwdchgmm을 int 변환 하는것만으로도 충분한지 확인 필요
		int getpwdchgmm = vo.getPWD_CHG_MM();
		if(getpwdchgmm >= 6) rtnMap.put("noti", "패스워드 유효기간(6개월)이 만료되었습니다. \n변경 후 사용하시기 바랍니다.");
		
		//중복 로그인 체크 - 이전 세션삭제 및 접속 강제종료 처리
		UserSessionManager usm = UserSessionManager.getInstance();
		if(usm.isUsingValue(String.valueOf(vo.getUSER_ID()))){
			usm.removeSessionValue(String.valueOf(vo.getUSER_ID()));
			map.put("USER_ID", String.valueOf(vo.getUSER_ID()));
			commonceMapper.UPDATE_FORCE_LOGOUT_HIST(map);	
		}
		usm.addSession(session.getId(), String.valueOf(vo.getUSER_ID()));	//싱글톤에 세션저장
		
		//List<?> list = commonceMapper.SELECT_USER_MENU_LIST(vo);
		//vo.setUSER_MENU_LIST(list);

		session.setAttribute("EXCEL_AUTH_YN", "Y");
		
		String userAgent = request.getHeader("User-Agent");
		String accsBrsr  = "";
		
		/*
		 * 브라우저 및 OS 분류 참고사이트
		 * http://www.happyjung.com/lecture/1564
		 */
		if(userAgent.indexOf("Firefox") > 0)      accsBrsr = "Firefox / ";
		else if(userAgent.indexOf("rv:11") > 0)   accsBrsr = "Explorer 11 / ";
		else if(userAgent.indexOf("MSIE 10") > 0) accsBrsr = "Explorer 10 / ";
		else if(userAgent.indexOf("MSIE 9") > 0)  accsBrsr = "Explorer 9 / ";
		else if(userAgent.indexOf("MSIE 8") > 0)  accsBrsr = "Explorer 8 / ";
		else if(userAgent.indexOf("MSIE 7") > 0)  accsBrsr = "Explorer 7 / ";
		else if(userAgent.indexOf("MSIE 6") > 0)  accsBrsr = "Explorer 6 / ";
		else if(userAgent.indexOf("Edge") > 0)    accsBrsr = "Edge / ";
		else if(userAgent.indexOf("Chrome") > 0)  accsBrsr = "Chrome / ";
		else if(userAgent.indexOf("Safari") > 0)  accsBrsr = "Safari / ";

		if(userAgent.indexOf("Windows") > 0)         accsBrsr += "Windows";
		else if(userAgent.indexOf("Android") > 0)    accsBrsr += "Android";
		else if(userAgent.indexOf("iPhone") > 0)     accsBrsr += "iPhone";
		else if(userAgent.indexOf("iPad") > 0)       accsBrsr += "iPad";
		else if(userAgent.indexOf("iPod") > 0)       accsBrsr += "iPod";
		else if(userAgent.indexOf("Machintosh") > 0) accsBrsr += "Machintosh";
		
		//로그인 이력 등록 및 최종 로그인등록일시 업데이트 
		map.put("ACSS_IP", request.getRemoteAddr());
		map.put("SESSION_ID", session.getId());
		map.put("ACCS_BRSR", accsBrsr);
		
		commonceMapper.INSERT_LOGIN_HIST(map);
		commonceMapper.UPDATE_LAST_LOGIN_DTTM(map);
		
		if (vo != null) {
			rtnMap.put("USER_ID", String.valueOf(vo.getUSER_ID()));
			rtnMap.put("USER_SE_CD", String.valueOf(vo.getUSER_SE_CD()));
			rtnMap.put("USER_NM", String.valueOf(vo.getUSER_NM()));
			rtnMap.put("CET_BROF_CD", String.valueOf(vo.getCET_BRCH_CD()));
			rtnMap.put("GRP_CD", String.valueOf(vo.getGRP_CD()));
			rtnMap.put("GRP_NM", String.valueOf(vo.getGRP_NM()));
			rtnMap.put("BIZRNM", String.valueOf(vo.getBIZRNM()));
			rtnMap.put("LAST_LGN_DT", String.valueOf(vo.getLAST_LGN_DTTM()));
			rtnMap.put("PRSN_INFO_CHG_AGR_YN", String.valueOf(vo.getPRSN_INFO_CHG_AGR_YN()));
			rtnMap.put("BIZR_TP_CD", String.valueOf(vo.getBIZR_TP_CD()));
			rtnMap.put("AFF_OGN_CD", String.valueOf(vo.getAFF_OGN_CD()));
		}
		
		
		//String dtssNo = vo.getCG_DTSS_NO();
		//if(dtssNo == null) dtssNo = "";
		//rtnMap.put("CG_DTSS_NO", dtssNo);
		
		return rtnMap;
	}	
	
	
	
	/**
	 * 로그인 체크 - 모바일
	 * @param map
	 * @param request
	 * @return
	 * @throws UnsupportedEncodingException 
	 * @
	 */
	@Transactional
	public HashMap<String, String> loginCheck_mobile(HashMap<String, String> map, HttpServletRequest request)  {
		
		HttpSession session = request.getSession();
		String msg = "";
		
		String ssoId = util.null2void(map.get("SSO_ID"));
		String pwd = map.get("USER_PWD");
		
		if(!ssoId.equals("")){
			map.put("USER_ID", ssoId);
			pwd = "";
		}else{
			//map.put("USER_ID", URLDecoder.decode(map.get("USER_ID"),"utf-8"));
			try {
				pwd = URLDecoder.decode(pwd,"utf-8");
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
			}
			pwd = util.encrypt(pwd);
			map.put("USER_PWD", pwd);
		}
		
		/**
		 * auth 처리
		 */
		Collection<SimpleGrantedAuthority> roles = new ArrayList<SimpleGrantedAuthority>();
		roles.add(new SimpleGrantedAuthority("ROLE_USER"));
		
		UserDetails user = new User(map.get("USER_ID"), pwd, roles);

		try{
			Authentication authentication = new UsernamePasswordAuthenticationToken(user.getUsername(), pwd, user.getAuthorities());
		    SecurityContext securityContext = SecurityContextHolder.getContext();
		    securityContext.setAuthentication(authentication);
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			e.getMessage();
		}
		
		/********************************************************/
		
		
		map.put("UPD_PRSN_ID", map.get("USER_ID"));
		map.put("RGST_PRSN_ID", map.get("USER_ID"));
		map.put("REG_ID", map.get("USER_ID"));
		
		map.put("MBL_LOGIN", "Y");
		UserVO vo = commonceMapper.SELECT_USER_VO(map);
		
		if(vo == null || vo.getUSER_ID() == null){
			msg = "아이디 또는 비밀번호가 맞지않습니다.\n다시한번 확인 하시기 바랍니다.";
		}else if(vo.getBIZR_STAT_CD() == null || !vo.getBIZR_STAT_CD().equals("Y")){
			msg = "비활동 사업자 회원입니다. \n관리자에게 문의 하시기 바랍니다.";
		}else if(!vo.getALT_REQ_STAT_CD().equals("0")){
			msg = "승인대기 상태의 사업자입니다. \n센터 승인 후 사용하시기 바랍니다.";
		}else if(vo.getUSER_STAT_CD().equals("N")){//사용자상태 1-활동, 2-비활동, 9-승인대기
			msg = "비활동 상태의 회원입니다. \n해당 사업자 관리자에게 문의 하시기 바랍니다.";
		}else if(vo.getUSER_STAT_CD().equals("W")){//사용자상태 1-활동, 2-비활동, 9-승인대기
			msg = "승인대기 상태의 회원입니다. \n해당 사업자 관리자 승인 후 사용하시기 바랍니다.";
		}else if(ssoId.equals("") && !pwd.equals(vo.getUSER_PWD())){
			msg = "아이디 또는 비밀번호가 맞지않습니다.\n다시한번 확인 하시기 바랍니다.";
			commonceMapper.UPDATE_PW_ERR_ADD(map);
		}else if(vo.getPWD_ALT_REQ_YN().equals("Y")){//비밀번호변경 Y:요청 N:미요청
			msg = "비밀번호 변경요청에 대한 사업자 관리 승인 후, \n변경된 비밀번호로 로그인하실 수 있습니다.";
		}else if(ssoId.equals("") && vo.getLGN_ERR_TMS() > 4){
			msg = "비밀번호 오류 회수(5회)가 초과 되었습니다. \n비밀번호 변경요청을 하시기 바랍니다.";
		}
		
		//세션 저장
		session.setAttribute("userSession", vo);
		session.setAttribute("MBL_LOGIN", "Y");
		
		HashMap<String, String> rtnMap = new HashMap<String, String>();
		rtnMap.put("noti", "");
		
		//csrf 토큰값이 변경됨.. 재설정 처리필요
		//CsrfToken token = (CsrfToken)request.getAttribute("_csrf");
		//rtnMap.put("_csrf", token.getToken());
		
		if(!msg.equals("")){
			rtnMap.put("msg", msg);
			return rtnMap;
		}
		
		//모바일 정보 인서트
		commonceMapper.updateMblUserInfo(map);
		
		
		if(vo.getPWD_CHG_MM() >= 6) rtnMap.put("noti", "패스워드 유효기간(6개월)이 만료되었습니다. \n변경 후 사용하시기 바랍니다.");
		
		
		
		//중복 로그인 체크 - 이전 세션삭제 및 접속 강제종료 처리
		UserSessionManager usm = UserSessionManager.getInstance();
		
	
		if(usm.isUsingValue(vo.getUSER_ID())){
			usm.removeSessionValue(vo.getUSER_ID());
			map.put("USER_ID", vo.getUSER_ID());
			commonceMapper.UPDATE_FORCE_LOGOUT_HIST(map);	
		}
		
		
		usm.addSession(session.getId(), vo.getUSER_ID());	//싱글톤에 세션저장
		
		
		//List<?> list = commonceMapper.SELECT_USER_MENU_LIST(vo);
		//vo.setUSER_MENU_LIST(list);
		
		//MySessionDataDto mInfo = commonSvc.getMySessionData(userid); 
	    
	    //HttpSession session = request.getSession(true);
		

		session.setAttribute("EXCEL_AUTH_YN", "Y");
		
		String userAgent = request.getHeader("User-Agent");
		String accsBrsr  = "";

		/*
		 * 브라우저 및 OS 분류 참고사이트
		 * http://www.happyjung.com/lecture/1564
		 */
		if(userAgent.indexOf("Firefox") > 0)      accsBrsr = "Firefox / ";
		else if(userAgent.indexOf("rv:11") > 0)   accsBrsr = "Explorer 11 / ";
		else if(userAgent.indexOf("MSIE 10") > 0) accsBrsr = "Explorer 10 / ";
		else if(userAgent.indexOf("MSIE 9") > 0)  accsBrsr = "Explorer 9 / ";
		else if(userAgent.indexOf("MSIE 8") > 0)  accsBrsr = "Explorer 8 / ";
		else if(userAgent.indexOf("MSIE 7") > 0)  accsBrsr = "Explorer 7 / ";
		else if(userAgent.indexOf("MSIE 6") > 0)  accsBrsr = "Explorer 6 / ";
		else if(userAgent.indexOf("Edge") > 0)    accsBrsr = "Edge / ";
		else if(userAgent.indexOf("Chrome") > 0)  accsBrsr = "Chrome / ";
		else if(userAgent.indexOf("Safari") > 0)  accsBrsr = "Safari / ";

		if(userAgent.indexOf("Windows") > 0)         accsBrsr += "Windows";
		else if(userAgent.indexOf("Android") > 0)    accsBrsr += "Android";
		else if(userAgent.indexOf("iPhone") > 0)     accsBrsr += "iPhone";
		else if(userAgent.indexOf("iPad") > 0)       accsBrsr += "iPad";
		else if(userAgent.indexOf("iPod") > 0)       accsBrsr += "iPod";
		else if(userAgent.indexOf("Machintosh") > 0) accsBrsr += "Machintosh";
		
		
		//로그인 이력 등록 및 최종 로그인등록일시 업데이트 
		map.put("ACSS_IP", request.getRemoteAddr());
		map.put("SESSION_ID", session.getId());
		map.put("ACCS_BRSR", accsBrsr);
		
		commonceMapper.INSERT_LOGIN_HIST(map);
		commonceMapper.UPDATE_LAST_LOGIN_DTTM(map);
		
		//rtnMap.put("USER_ID", vo.getUSER_ID());
		//rtnMap.put("USER_NM", vo.getUSER_NM());
		//rtnMap.put("BIZRNM", vo.getBIZRNM());
		//rtnMap.put("LAST_LGN_DT", vo.getLAST_LGN_DTTM());
		rtnMap.put("LOGIN", "Y");
		
		return rtnMap;
	}
	
	
	/**
	 * 키보드 비보안 로그인 - 테스트용, 사용하면안됨.
	 * @param map
	 * @param request
	 * @param response
	 * @return
	 * @
	 */
	public HashMap<String, String> loginCheck2(HashMap<String, String> map, HttpServletRequest request, HttpServletResponse response) {
			
		HttpSession session = request.getSession();
		String msg = "";
		String pwd = map.get("USER_PWD");
		
		try {
			map.put("USER_ID", URLDecoder.decode(map.get("USER_ID"),"utf-8"));
			pwd = URLDecoder.decode(pwd,"utf-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		pwd = util.encrypt(pwd);
		map.put("USER_PWD", util.encrypt(pwd));
		
		UserVO vo = commonceMapper.SELECT_USER_VO(map);
		if(vo == null || vo.getUSER_ID() == null){
			msg = "아이디 또는 비밀번호가 맞지않습니다.\n다시한번 확인 하시기 바랍니다.";
		}else if(!pwd.equals(String.valueOf(vo.getUSER_PWD()))){
			msg = "아이디 또는 비밀번호가 맞지않습니다.\n다시한번 확인 하시기 바랍니다.";
		}else if(vo.getBIZR_STAT_CD() == null || !vo.getBIZR_STAT_CD().equals("Y")){
			msg = "비활동 사업자 회원입니다. \n관리자에게 문의 하시기 바랍니다.";
		}
		
		HashMap<String, String> rtnMap = new HashMap<String, String>();
		if(!msg.equals("")){
			rtnMap.put("msg", msg);
			return rtnMap;
		}
		
		//중복 로그인 체크 - 이전 세션삭제 및 접속 강제종료 처리
		UserSessionManager usm = UserSessionManager.getInstance();
		if(usm.isUsingValue(vo.getUSER_ID())){
			usm.removeSessionValue(vo.getUSER_ID());
			map.put("USER_ID", vo.getUSER_ID());
			commonceMapper.UPDATE_FORCE_LOGOUT_HIST(map);	
		}
		usm.addSession(session.getId(), vo.getUSER_ID());	//싱글톤에 세션저장
		
		
		List<?> list = commonceMapper.SELECT_USER_MENU_LIST(vo);
		vo.setUSER_MENU_LIST(list);
		if(list != null && list.size() > 0){
			HashMap<String, String> tmpMap = (HashMap<String, String>)list.get(0);
			vo.setGRP_CD(tmpMap.get("GRP_CD"));
			vo.setGRP_NM(tmpMap.get("GRP_NM"));
		}
		session.setAttribute("userSession", vo);
		
		//로그인 이력 등록 및 최종 로그인등록일시 업데이트 
		map.put("UPD_PRSN_ID", map.get("USER_ID"));
		map.put("RGST_PRSN_ID", map.get("USER_ID"));
		map.put("ACSS_IP", request.getRemoteAddr());
		map.put("REG_ID", map.get("USER_ID"));
		map.put("SESSION_ID", session.getId());
		
		commonceMapper.INSERT_LOGIN_HIST(map);
		commonceMapper.UPDATE_LAST_LOGIN_DTTM(map);
		
//		rtnMap.put("MBR_SE_CD", vo.getMBR_SE_CD());
		rtnMap.put("USER_SE_CD", vo.getUSER_SE_CD());
		rtnMap.put("USER_NM", vo.getUSER_NM());
		
		return rtnMap;
	}
	
	/**
	 * 로그아웃 처리
	 * @param request
	 * @
	 */
	public void logOut(HttpServletRequest request) {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		if(vo != null){
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("USER_ID", vo.getUSER_ID());
			map.put("ACSS_IP", request.getRemoteAddr());
			//commonceMapper.UPDATE_LOGIN_HIST(map);	//로그아웃 시간 기록
			commonceMapper.UPDATE_FORCE_LOGOUT_HIST(map);	//로그아웃 시간 기록
		}
		session.invalidate();
	}
	
	
	/**
	 * 회원 발급키 생성
	 * @param busiNo
	 * @return
	 * @
	 */
	public String getMbrIssuKey(String BIZRNO) {
		AES256Util aes;
		String key = "";
		try {
			aes = new AES256Util();
			HashMap<String, String> map = commonceMapper.SELECT_MBR_ISSU_KEY_INFO(BIZRNO);
			if(map == null || !map.containsKey("CNTR_DT")) return "";
			
			key = BIZRNO + "|" + map.get("CNTR_DT") + "|" + map.get("MBR_SE_CD") + "|" + map.get("ADMIN_ID");	
			key = aes.encrypt(key);
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return key;
	}
	
	
	/**
	 * 회원 발급키 생성
	 * @param HashMap
	 * @return
	 * @
	 */
	public String getMbrIssuKey(HashMap<String, String> map) {
		AES256Util aes;
		String key = "";
		try {
			aes = new AES256Util();
			key = map.get("BIZRNO") + "|" + map.get("CNTR_DT") + "|" + map.get("MBR_SE_CD") + "|" + map.get("ADMIN_ID");	
			key = aes.encrypt(key);
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		return key;
	}
	
	
	/**
	 * 사용자 메뉴 조회
	 * @param vo
	 * @return
	 * @
	 */
	public List<?> selectUserMemuList(UserVO vo) {
		List<?> menuList = commonceMapper.SELECT_USER_MENU_LIST(vo);
		return menuList;
	}
	
	
	/**
	 * 회원 아이디 찾기
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String searchUserId(HashMap<String, String> paramMap, HttpServletRequest request) {
		
		HashMap<String, String> rtnMap = new HashMap<String, String>();
		String msg = "";
		String rsltCd = "0000";
		
		
		HashMap<String, String> map = commonceMapper.SELECT_SEARCH_USER_ID(paramMap);
		if(map == null || !map.containsKey("USER_ID")){
			rsltCd = "9999";
			msg = "일치하는 회원정보가 존재하지 않습니다.";
		}else{
			msg = "조회하신 사용자ID는 [ <b>" + map.get("USER_ID") + "</b> ] 입니다.";
		}
		
		rtnMap.put("msg",msg);
		rtnMap.put("cd",rsltCd);
		
				
		return util.mapToJson(rtnMap).toString();
	}
	
	
	/**
	 * 패스워드 변경요청
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String updateUserPwd(HashMap<String, String> map, HttpServletRequest request) {
		String msg = "";
		String rsltCd = "9999";
		String userSeCd = "2";	//1 -관리자, 2-업무담당
		String cntrDt = "";
		String bizNo = "";
		String MBIL_PHON1 = "";	//관리자의 경우 핸드폰 번호 - 본인인증용
		String MBIL_PHON2 = "";
		String MBIL_PHON3 = "";
		
		String nm = map.get("USER_NM");
		//String pwd = map.get("USER_PWD");
		//pwd = util.encrypt(pwd);
		
		try {
			map.put("USER_ID", map.get("USER_ID"));
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		UserVO vo = commonceMapper.SELECT_USER_VO(map);
		if(vo == null || vo.getUSER_ID() == null){
			msg = "입력하신 아이디가 존재하지 않습니다.\n다시한번 확인 하시기 바랍니다.";
		}else if(!nm.equals(vo.getUSER_NM())){
			msg = "입력하신 성명이 맞지 않습니다. \n다시한번 확인 하시기 바랍니다.";
		/*
		}else if(!pwd.equals(vo.getUSER_PWD())){
			msg = "비밀번호가 맞지 않습니다.\n다시한번 확인 하시기 바랍니다.";
		*/
		}else if(vo.getBIZR_STAT_CD() == null || !vo.getBIZR_STAT_CD().equals("Y")){
			msg = "비활동 사업자 회원입니다. \n관리자에게 문의 하시기 바랍니다.";
		}else if(vo.getUSER_SE_CD().equals("D")){	//관리자
			msg = "본인인증이 필요합니다.";
			userSeCd = "D";
			cntrDt = vo.getCNTR_DT();
			bizNo = vo.getBIZRNO();
			MBIL_PHON1 = vo.getMBIL_NO1();
			MBIL_PHON2 = vo.getMBIL_NO2();
			MBIL_PHON3 = vo.getMBIL_NO3();
		}else if(vo.getUSER_SE_CD().equals("S")){	//업무담당자
			msg = "본인인증이 필요합니다.";
			userSeCd = "S";
			cntrDt = vo.getCNTR_DT();
			bizNo = vo.getBIZRNO();
			MBIL_PHON1 = vo.getMBIL_NO1();
			MBIL_PHON2 = vo.getMBIL_NO2();
			MBIL_PHON3 = vo.getMBIL_NO3();
		}
		
		
		if(msg.equals("")){
			String altPwd = map.get("ALT_REQ_PWD");
			try {
				altPwd = URLDecoder.decode(altPwd,"utf-8");
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}
			
			map.put("ALT_REQ_PWD", util.encrypt(altPwd));
			
			if (vo.getUSER_PWD().equals(map.get("ALT_REQ_PWD"))) {
				msg = "이전과 동일한 비밀번호를 사용할 수 없습니다.";
			} else {				
				map.put("UPD_PRSN_ID", map.get("USER_ID"));
				
				commonceMapper.UPDATE_USER_PWDCHG(map);
				msg = "요청이 정상적으로 처리되었습니다. \n해당 사업자 관리자 승인 후 변경된 비밀번호로 로그인하실 수 있습니다.";
				rsltCd = "0000";
			}
		}
		
		HashMap<String, String> rtnMap = new HashMap<String, String>();
		rtnMap.put("msg",msg);
		rtnMap.put("cd",rsltCd);
		rtnMap.put("USER_SE_CD",userSeCd);
		
		rtnMap.put("CNTR_DT",cntrDt);
		rtnMap.put("BIZRNO",bizNo);
		rtnMap.put("MBIL_PHON1", MBIL_PHON1);
		rtnMap.put("MBIL_PHON2", MBIL_PHON2);
		rtnMap.put("MBIL_PHON3", MBIL_PHON3);
		
				
		return util.mapToJson(rtnMap).toString();
	}
	
	
	/**
	 * 관리자 패스워드 변경처리, 업무담당자 변경요청처리
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String updateUserAdminPwd(HashMap<String, String> map, HttpServletRequest request) {
		String msg = "";
		String rsltCd = "9999";
		String pwd = map.get("ALT_REQ_PWD");
		
		try {
			map.put("USER_ID", URLDecoder.decode(map.get("USER_ID"),"utf-8"));
			pwd = URLDecoder.decode(pwd,"utf-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		UserVO vo = commonceMapper.SELECT_USER_VO(map);
		
		if(vo.getUSER_SE_CD().equals("D")){	//관리자
			
			pwd = util.encrypt(pwd);
			map.put("ALT_REQ_PWD", pwd);
			
			if (vo.getUSER_PWD().equals(map.get("ALT_REQ_PWD"))) {
				msg = "이전과 동일한 비밀번호를 사용할 수 없습니다.";
			} else {	
				map.put("UPD_PRSN_ID", map.get("USER_ID"));
				
				commonceMapper.UPDATE_USER_ADMIN_PWDCHG(map);
				msg = "요청이 정상적으로 처리되었습니다. \n변경된 비밀번호로 로그인 하십시오.";
				rsltCd = "0000";
			}
			
		}else if(vo.getUSER_SE_CD().equals("S")){	//업무담당자

			map.put("ALT_REQ_PWD", util.encrypt(pwd));
			
			if (vo.getUSER_PWD().equals(map.get("ALT_REQ_PWD"))) {
				msg = "이전과 동일한 비밀번호를 사용할 수 없습니다.";
			} else {
				map.put("UPD_PRSN_ID", map.get("USER_ID"));
				
				commonceMapper.UPDATE_USER_PWDCHG(map);
				msg = "요청이 정상적으로 처리되었습니다. \n해당 사업자 관리자 승인 후 변경된 비밀번호로 로그인하실 수 있습니다.";
				rsltCd = "0000";
			}
		}

		HashMap<String, String> rtnMap = new HashMap<String, String>();
		rtnMap.put("msg",msg);
		rtnMap.put("cd",rsltCd);
				
		return util.mapToJson(rtnMap).toString();
	}
	
	/**
	 * 실행이력 등록
	 * @param map
	 * @
	 */
	public void insertExecHist(HashMap<String, String> map) {
		commonceMapper.INSERT_EPCN_EXEC_HIST(map);
	}
	
	
	/**
	 * 언어구분 조회
	 * @param
	 * @return
	 * @
	 */
	public List<?> getLangSeCdList() {
		List<?> list = commonceMapper.SELECT_LANG_SE_CD_LIST();
		return list;
	}
	
	
	/**
	 * static 다국어코드 조회
	 * @return
	 * @
	 */
	public HashMap<String, String> getLangCdList() {
		HashMap<String, String> textMap = util.getLANG_CD_LIST();
		if(textMap == null || textMap.size() == 0){
			List<?> list = commonceMapper.SELECT_TEXT_LIST();
			
			textMap = new HashMap<String, String>();
			for (int i = 0; i < list.size(); i++) {
				HashMap<String, String> listMap = (HashMap<String, String>) list.get(i);
				textMap.put(listMap.get("LANG_CD"), listMap.get("LANG_NM"));
			}
			
			util.setLANG_CD_LIST(textMap);
		}
		return textMap;
	}
	
	/**
	 * static 메뉴코드 조회
	 * @return
	 * @
	 */
	public List<?> getMenuCdList(UserVO vo) {
		List<?> list = vo.getUSER_MENU_LIST();
		if(list == null || list.size() == 0){
			list = commonceMapper.SELECT_USER_MENU_LIST(vo);
			vo.setUSER_MENU_LIST(list);
		}
		return list;
	}
	
	/**
	 * static 메뉴코드 조회 - 모바일용
	 * @return
	 * @
	 */
	public List<?> getMenuCdListM(UserVO vo) {
		List<?> list = vo.getUSER_MENU_LIST();
		if(list == null || list.size() == 0){
			list = commonceMapper.SELECT_USER_MENU_LIST_M(vo);
			vo.setUSER_MENU_LIST(list);
		}
		return list;
	}
	
	
	
	/******************************* 공통코드 조회 ****************************************/
	
	
	/**
	 * 공통코드 조회 - 코드그룹으로 조회
	 * @param grpCd
	 * @return
	 * @
	 */
	public List<?> getCommonCdListNew(String grpCd) {
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("GRP_CD", grpCd);
		List<?> list = commonceMapper.SELECT_COMMON_CD_LIST_NEW(map);
		return list;
	}
	
	/**
	 * 공통코드 조회 - 언어구분 받은 놈
	 * @param grpCd
	 * @return
	 * @
	 */
	public List<?> getCommonCdListNew2(HashMap<String, String> map) {

		List<?> list = commonceMapper.SELECT_COMMON_CD_LIST_NEW2(map);
		return list;
	}
	
	
	
	
	/**
	 * 공통코드 파라메터를  map으로 던질경우
	 * @param paraMap
	 * @return
	 * @
	 */
	public List<?> getCommonCdList(Map<String, String> paraMap) {
		
		String grpCd = (paraMap.get("GRP_CD") == null) ? "" : paraMap.get("GRP_CD");	//코드그룹
		String cdSe = (paraMap.get("CD_SE") == null) ? "" : paraMap.get("CD_SE");		//코드구분
		String pprItem = (paraMap.get("PPR_ITEM") == null) ? "" : paraMap.get("PPR_ITEM");	//예비항목

		List<?> list;
		if((paraMap.size() == 0)
				|| (grpCd.equals("") && cdSe.equals("") && pprItem.equals(""))){
			list = this.getCommonCdList();
		}else{
			list = this.getCommonCdList(grpCd, cdSe, pprItem);
		}
		
		return list;
	}


	/**
	 * 공통코드 조회 - 코드그룹으로 조회
	 * @param grpCd
	 * @return
	 * @
	 */
	public List<?> getCommonCdList(String grpCd) {
		List<?> list = this.getCommonCdList(grpCd, "", "");
		return list;
	}
	
	
	/**
	 * 공통코드 조회 - 코드그룹, 코드구분으로 조회
	 * @param grpCd
	 * @param cdSe
	 * @return
	 * @
	 */
	public List<?> getCommonCdList(String grpCd, String cdSe) {
		List<?> list = this.getCommonCdList(grpCd, cdSe, "");
		return list;
	}
	
	
	/**
	 * 공통코드 조회 - 코드그룹, 코드구분, 예비항목 으로 조회
	 * @param grpCd
	 * @param cdSe
	 * @param pprItem
	 * @return
	 * @
	 */
	public List<?> getCommonCdList(String grpCd, String cdSe, String pprItem) {
		List<HashMap<String, String>> rtnList = new ArrayList<HashMap<String, String>>();
		
		if(cdSe == null) cdSe = "";
		if(pprItem == null) pprItem = "";
		
		List<?> list = this.getCommonCdList();
		for(int i=0; i<list.size(); i++){
			HashMap<String, String> map = (HashMap<String, String>)list.get(i);
			String cd = map.get("GRP_CD");
			if(!cd.equals(grpCd)) continue;
			
			if(!cdSe.equals("") && !cdSe.equals(map.get("CD_SE"))) continue;
			if(!pprItem.equals("") && map.get("PPR_ITEM").indexOf(pprItem) < 0) continue;
			
			rtnList.add(map);
		}
		
		return rtnList;
	}
	
	
	/**
	 * 공통코드 다시 적용 되어야 할 경우(추가,변경,삭제) 사용 - 관리자 코드관리에서만 사용할것.
	 * @
	 */
	public void reloadCommonCdList() {
		List<?>list = commonceMapper.SELECT_COMMON_CD_LIST();
		util.setCOMMON_CD_LIST(list);
	}
	
		
	/**
	 * static 공통코드 조회
	 * @return
	 * @
	 */
	private List<?> getCommonCdList() {
		List<?> list = util.getCOMMON_CD_LIST();
		if(list == null || list.size() == 0){
			list = commonceMapper.SELECT_COMMON_CD_LIST();
			util.setCOMMON_CD_LIST(list);
		}
		return list;
	}
	
	
	/******************************* 은행코드 조회 ****************************************/
	
	/**
	 * 은행코드 조회
	 * @return
	 * @
	 */
	public List<?> getBankCdList() {
		List<?> list = util.getBANK_CD_LIST();
		if(list == null || list.size() == 0){
			list = commonceMapper.SELECT_BANK_CD_LIST();
			util.setBANK_CD_LIST(list);
		}
		
		return list;
	}
	
	/**
	 * 은행코드에 해당하는 명 조회
	 * @param bankCd
	 * @return
	 * @
	 */
	public String getBankNm(String bankCd) {
		List<?> list = this.getBankCdList();
		String bankNm = "";
		for(int i=0; i<list.size(); i++){
			HashMap<String, String> map = (HashMap<String, String>)list.get(i);
			String cd = map.get("BANK_CD");
			if(cd.equals(bankCd)){
				bankNm = map.get("BANK_NM");
				break;
			}
		}
		
		return bankNm;
	}
	
	/**
	 * 은행명에 해당하는 코드조회
	 * @param bankCd
	 * @return
	 * @
	 */
	public String getBankCd(String bankNm) {
		List<?> list = this.getBankCdList();
		String bankCd = "";
		for(int i=0; i<list.size(); i++){
			HashMap<String, String> map = (HashMap<String, String>)list.get(i);
			String nm = map.get("BANK_NM");
			if(nm.equals(bankNm)){
				bankCd = map.get("BANK_CD");
				break;
			}
		}
		
		return bankCd;
	}
	
	
	
	
	
	/******************************* 에러코드 조회 ****************************************/
	
	
	/**
	 * 에러 코드의 메세지 조회
	 * @param paraMap
	 * @return
	 * @
	 */
	public String getErrorMsg(Map<String, String> paraMap) {
		String sysSe = paraMap.get("SYS_SE");
		String errCd = paraMap.get("ERR_CD");
		
		return getErrorMsg(sysSe, errCd);
	}
	
	/**
	 * 에러 메세지 조회
	 * @param sysSe
	 * @param errCd
	 * @return
	 * @
	 */
	public String getErrorMsg(String sysSe, String errCd) {
		String errMsg = "";
		
		if(sysSe == null || sysSe.equals("") || errCd == null || errCd.equals("")) return errMsg;
		
		List<?> list = this.getErrCdList();

		for(int i=0; i<list.size(); i++){
			HashMap<String, String> map = (HashMap<String, String>)list.get(i);
			String sys = map.get("ERR_SE");
			String cd = map.get("ERR_CD");
			if(!sysSe.equals(sys) || !errCd.equals(cd)) continue;
			errMsg = map.get("ERR_MSG");
			break;
		}
		
		return errMsg;
	}
	
	/**
	 * 에러 그룹 리스트
	 * @param paraMap
	 * @return
	 * @
	 */
	public List<?> getErrCdList(Map<String, String> paraMap) {
		String sysSe = (paraMap.get("SYS_SE") == null) ? "" : paraMap.get("SYS_SE");
		
		List<?> list = this.getErrCdList();
		if(sysSe == null || sysSe.equals("")) return list;
		
		List<HashMap<String, String>> rtnList = new ArrayList<HashMap<String, String>>();
		for(int i=0; i<list.size(); i++){
			HashMap<String, String> map = (HashMap<String, String>)list.get(i);
			String cd = map.get("SYS_SE");
			if(!cd.equals(sysSe)) continue;
			
			rtnList.add(map);
		}
		
		return rtnList;
	}
	
	/**
	 * 공통코드 다시 적용 되어야 할 경우(추가,변경,삭제) 사용 - 관리자 오류코드관리에서만 사용할것.
	 * @
	 */
	public void reloadErrCdList() {
		List<?>list = commonceMapper.SELECT_ERR_CD_LIST();
		util.setERR_CD_LIST(list);
	}
	
	/**
	 * static 에러 코드조회
	 * @return
	 * @
	 */
	private List<?> getErrCdList() {
		List<?> list = util.getERR_CD_LIST();
		if(list == null || list.size() == 0){
			list = commonceMapper.SELECT_ERR_CD_LIST();
			util.setERR_CD_LIST(list);
		}
		return list;
	}
	
	
	
	/**
	 * static New 에러 코드조회 
	 * @return
	 * @
	 */
	private List<?> getErrCdListNew(HashMap<String,String> map) {
		 List<?> list = commonceMapper.SELECT_ERR_CD_LIST_NEW(map);
		return list;
	}
	

	/**
	 * 에러 메세지 조회 NEW
	 * @param sysSe
	 * @param errCd
	 * @return
	 * @
	 */
	public String getErrorMsgNew(HttpServletRequest request, String ERR_SE, String errCd) {
		String errMsg = "";
		HashMap<String,String> map = new HashMap<String, String>();
		
		if(ERR_SE == null || ERR_SE.equals("") || errCd == null || errCd.equals("")) return errMsg;
		
		map.put("ERR_SE", ERR_SE);
		map.put("ERR_CD", errCd);
		
		List<?> list = this.getErrCdListNew(map);
		if(list.size() == 0 ) {
			map.put("ERR_SE", "A");
			map.put("ERR_CD", "AAAA");
			list = this.getErrCdListNew(map);
		}
		
		HashMap<String, String> map2 = (HashMap<String, String>)list.get(0);
		errMsg = map2.get("ERR_MSG");
		
		if(ERR_SE.equals("B")){ //연계 API 이력 등록
			try {
				insertErrorLogAPI(request, errCd, errMsg);
			}catch (IOException io) {
				io.getMessage();
			}catch (SQLException sq) {
				sq.getMessage();
			}catch (NullPointerException nu){
				nu.getMessage();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				return errMsg;
			}
		}else{
			if(!errCd.equals("0000")){ //에러로그
				insertErrorLog(request, errCd, errMsg);
			}
		}
		
		return errMsg;
	}
	
	
	/**
	 * 사업장 정보 및 계좌정보 ERP 연계 프로시저 호출
	 * 필요한 키값 : REG_ID - 사용자 아디디(센터ID 10자리), 10자리보다 크면 에러남.
	 * @param map
	 * @
	 */
	public void updateErpSendBsnmInfo(String ssUserId) {
		
		HashMap<String, String> eMap = new HashMap<String, String>();
		eMap.put("REG_ID", ssUserId);
		
		commonceMapper.UPDATE_ERP_PROC_BSNM_SEND_INFO(eMap);
	}
	
	
	/**
	 * 정산기준 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> SELECT_EPCN_EXCA_BSS_MGNT_LIST() {
		
		List<?> list = commonceMapper.SELECT_EPCN_EXCA_BSS_MGNT_LIST();
		return list;
	}
	
	/**
	 * 조건별 사업자  콤보박스 목록조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> bizr_select(HashMap<String, String> map)  {
		
		//사업자 리스트
		List<?> bizrList = commonceMapper.bizr_select(map);
		
		return bizrList;
	}
	
	
	/**
	 * 생산자  콤보박스 목록조회 (사업자구분 조회조건 )
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> mfc_bizrnm_select(HttpServletRequest request, Map<String, String> map)  {

		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		List<?> mfcBizrnmList=null;
		
		if(uvo != null){
			if(String.valueOf(uvo.getBIZR_TP_CD()).equals("T1")){
				map.put("T_USER_ID", uvo.getUSER_ID());
			}
			map.put("BIZRID", uvo.getBIZRID());  			
			map.put("BIZRNO", uvo.getBIZRNO_ORI());
			
			if(!String.valueOf(uvo.getBRCH_NO()).equals("9999999999")){
				map.put("BRCH_ID", uvo.getBRCH_ID());  		
				map.put("BRCH_NO", uvo.getBRCH_NO());
			}
		}

		//생산자 리스트
		if(uvo.getBIZR_TP_CD().equals("T1")){	// 센터일경우
			mfcBizrnmList = commonceMapper.mfc_bizrnm_select(map);
		}else 	if(uvo.getBIZR_TP_CD().equals("W1") ||uvo.getBIZR_TP_CD().equals("W2")){//도매업자일경우
			mfcBizrnmList = commonceMapper.mfc_bizrnm_select_wh(map);
		}else 	if(uvo.getBIZR_TP_CD().equals("M1") ||uvo.getBIZR_TP_CD().equals("M2")){//생산자일경우
			mfcBizrnmList = commonceMapper.mfc_bizrnm_select_mf(map);
		}
		return mfcBizrnmList;
	}
	
	
	/**
	 * 생산자  콤보박스 목록조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> mfc_bizrnm_select(HttpServletRequest request)  {

		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		HashMap<String, String> map = new HashMap<String, String>();
		List<?> mfcBizrnmList=null;
		
		if(uvo != null){
			if(String.valueOf(uvo.getBIZR_TP_CD()).equals("T1")){
				map.put("T_USER_ID", uvo.getUSER_ID());
			}
			map.put("BIZRID", uvo.getBIZRID());  			
			map.put("BIZRNO", uvo.getBIZRNO_ORI());  	
			
			if(!String.valueOf(uvo.getBRCH_NO()).equals("9999999999")){
				map.put("BRCH_ID", uvo.getBRCH_ID());  		
				map.put("BRCH_NO", uvo.getBRCH_NO());
			}
		}

		//생산자 리스트
		if(uvo.getBIZR_TP_CD().equals("T1")){	// 센터일경우
			mfcBizrnmList = commonceMapper.mfc_bizrnm_select(map);
		}else 	if(uvo.getBIZR_TP_CD().equals("W1") ||uvo.getBIZR_TP_CD().equals("W2")){//도매업자일경우
			mfcBizrnmList = commonceMapper.mfc_bizrnm_select_wh(map);
		}else 	if(uvo.getBIZR_TP_CD().equals("M1") ||uvo.getBIZR_TP_CD().equals("M2")){//생산자일경우
			mfcBizrnmList = commonceMapper.mfc_bizrnm_select_mf(map);
		}
		return mfcBizrnmList;
	}
	
	/**
	 * 생산자  콤보박스 목록조회 (상태값 Y)
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> mfc_bizrnm_select_y(HttpServletRequest request)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");

		HashMap<String, String> map = new HashMap<String, String>();
		map.put("BIZR_STAT_CD", "Y");
		List<?> mfcBizrnmList=null;
		
		if(uvo != null){
			if(uvo.getBIZR_TP_CD().equals("T1")){	// 센터일경우
				map.put("T_USER_ID", uvo.getUSER_ID());
			}
			map.put("BIZRID", uvo.getBIZRID());  			
			map.put("BIZRNO", uvo.getBIZRNO_ORI());  			
			map.put("BRCH_ID", uvo.getBRCH_ID());  		
			map.put("BRCH_NO", uvo.getBRCH_NO());  
		}
		
		//생산자 리스트
		//CHECKPOINT
		if(String.valueOf(uvo.getBIZR_TP_CD()).equals("T1")){	// 센터일경우
			mfcBizrnmList = commonceMapper.mfc_bizrnm_select(map);
		}else 	if(String.valueOf(uvo.getBIZR_TP_CD()).equals("W1") ||String.valueOf(uvo.getBIZR_TP_CD()).equals("W2")){//도매업자일경우
			mfcBizrnmList = commonceMapper.mfc_bizrnm_select_wh(map);
		}else 	if(String.valueOf(uvo.getBIZR_TP_CD()).equals("M1") ||String.valueOf(uvo.getBIZR_TP_CD()).equals("M2")){//생산자일경우
			mfcBizrnmList = commonceMapper.mfc_bizrnm_select_mf(map);
		}
		return mfcBizrnmList;
	}
	/**
	 * 생산자  콤보박스 목록조회 - 모든 생산자
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> mfc_bizrnm_select_all(HttpServletRequest request)  {
		HashMap<String, String> map = new HashMap<String, String>();
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");

		if(uvo != null && uvo.getBIZR_TP_CD().equals("T1")){
			map.put("T_USER_ID", uvo.getUSER_ID());
		}
		
		List<?> mfcBizrnmList = commonceMapper.mfc_bizrnm_select(map);
		return mfcBizrnmList;
	}
	/**
	 * 생산자  콤보박스 목록조회 (상태값 Y) - 모든 생산자
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	public List<?> mfc_bizrnm_select_all_y(HttpServletRequest request)  {
		HashMap<String, String> map = new HashMap<String, String>();
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");

		if(uvo != null && uvo.getBIZR_TP_CD().equals("T1")){
			map.put("T_USER_ID", uvo.getUSER_ID());
		}
		
		map.put("BIZR_STAT_CD", "Y");
		
		List<?> mfcBizrnmList = commonceMapper.mfc_bizrnm_select(map);
		return mfcBizrnmList;
	}
	
	
	
	/**
	 * 총괄직매장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> grp_brch_no_select(Map<String, String> data)  {
		HashMap<String, String> map = new HashMap<String, String>();
		map.putAll(data);
		List<?>  grp_brch_noList =null;
		
			grp_brch_noList = commonceMapper.grp_brch_no_select(map);
		return grp_brch_noList;
	}
	
	/**
	 * 사업자유형코드 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public String bizr_tp_cd_select(HashMap<String, String> map)  {
		
		//사업자유형코드
		String bizr_tp_cd = commonceMapper.bizr_tp_cd_select(map);
		return bizr_tp_cd;
	}
	
	/**
	 * 생산자별 빈용기명 콤보박스 목록조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> ctnr_nm_select(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		String bizr_tp_cd="";
		
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		
		if(map.containsKey("BIZRNO")){
				//사업자유형코드 조회
				bizr_tp_cd = commonceMapper.bizr_tp_cd_select((HashMap<String, String>) data);
				// 생산자 기타코드(소주표준화병 제외하기 위해 처리)  W1 주류 생산자 W2 음료생산자
				if(bizr_tp_cd == null || bizr_tp_cd.equals("")){
					map.put("BIZR_TP_CD", "");
				}else if(bizr_tp_cd.equals("M2")){
					map.put("BIZR_TP_CD", "M2");
				}else{
					map.put("BIZR_TP_CD", "M1");
				}
		} else {
			if(uvo.getBIZR_TP_CD().equals("M1")||uvo.getBIZR_TP_CD().equals("M2")){	//로그인자가 생산자일경우
				map.put("BIZRID", uvo.getBIZRID());  					// 사업자ID
				map.put("BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호
				map.put("BRCH_ID", uvo.getBRCH_ID());  				// 지점ID
				map.put("BRCH_NO", uvo.getBRCH_NO());  			// 지점번호
				map.put("BIZR_TP_CD", uvo.getBIZR_TP_CD());		// 요청회원구분코드
			}else{
				map.put("BIZR_TP_CD", "");
			}
		}
		
		//빈용기명(표준용기) 리스트
		List<?> epcnStdCtnrList = commonceMapper.ctnr_nm_select((HashMap<String, String>) map);

		return epcnStdCtnrList;
	}
	
	/**
	 * 생산자별 빈용기명 콤보박스 목록조회 (보증금 추가)
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> ctnr_nm_std_dps_select(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		String bizr_tp_cd="";
		
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		
		if(map.containsKey("BIZRNO")){
				//사업자유형코드 조회
				bizr_tp_cd = commonceMapper.bizr_tp_cd_select((HashMap<String, String>) data);
				// 생산자 기타코드(소주표준화병 제외하기 위해 처리)  W1 주류 생산자 W2 음료생산자
				if(bizr_tp_cd == null || bizr_tp_cd.equals("")){
					map.put("BIZR_TP_CD", "");
				}else if(bizr_tp_cd.equals("M2")){
					map.put("BIZR_TP_CD", "M2");
				}else{
					map.put("BIZR_TP_CD", "M1");
				}
		} else {
			if(uvo.getBIZR_TP_CD().equals("M1")||uvo.getBIZR_TP_CD().equals("M2")){	//로그인자가 생산자일경우
				map.put("BIZRID", uvo.getBIZRID());  					// 사업자ID
				map.put("BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호
				map.put("BRCH_ID", uvo.getBRCH_ID());  				// 지점ID
				map.put("BRCH_NO", uvo.getBRCH_NO());  			// 지점번호
				map.put("BIZR_TP_CD", uvo.getBIZR_TP_CD());		// 요청회원구분코드
			}else{
				map.put("BIZR_TP_CD", "");
			}
		}
		
		//빈용기명(표준용기) 리스트
		List<?> epcnStdCtnrList = commonceMapper.ctnr_nm_std_dps_select((HashMap<String, String>) map);

		return epcnStdCtnrList;
	}
	
	/**
	 * 생산자별 빈용기명 콤보박스 목록조회 거래중인것들만
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> ctnr_nm_select2(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		
		//로그인자가 센터일경우
		if(uvo.getBIZR_TP_CD().equals("T1") ){
			map.put("T_USER_ID", uvo.getUSER_ID());
		}
		//로그인자가 생산자일경우
		else if(uvo.getBIZR_TP_CD().equals("M1")||uvo.getBIZR_TP_CD().equals("M2")){
			map.put("MFC_BIZRID", uvo.getBIZRID());  					// 사업자ID
			map.put("MFC_BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호
		}
		//로그인자가 도매업자일경우
		else if(uvo.getBIZR_TP_CD().equals("W1")||uvo.getBIZR_TP_CD().equals("W2")){
			map.put("CUST_BIZRID", uvo.getBIZRID());  					// 사업자ID
			map.put("CUST_BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호
			
			if(!uvo.getBRCH_NO().equals("9999999999")){
				map.put("CUST_BRCH_ID", uvo.getBRCH_ID());  				// 지점ID
				map.put("CUST_BRCH_NO", uvo.getBRCH_NO());  			// 지점번호
			}
		}
		
		//빈용기명(표준용기) 리스트
		List<?> epcnStdCtnrList = commonceMapper.ctnr_nm_select2(map);
		return epcnStdCtnrList;
	}
	
	
	
	/**
	 *	빈용기 구분 조회
	 * @param data
	 * @param request
	 * @return
	 * @       
	 */
	public List<?> ctnr_se_select(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		Map<String, String> map = new HashMap<String, String>();
		if(data == null || !data.containsKey("BIZR_TP_CD") ){
			map.put("BIZR_TP_CD", uvo.getBIZR_TP_CD());
		}else{
			map.putAll(data);
		}
		
		List<?> selList = commonceMapper.ctnr_se_select((HashMap<String, String>) map);
		return selList;
	}
	
	/**
	 *	빈용기 취급수수료 + 보증금 조회
	 * @param data
	 * @param request
	 * @return
	 * @       
	 */    
	public List<?> ctnr_cd_select(Map<String, String> data)  {
		
		List<?> selList = null;
		
		String ctnrCdRtcYn = commonceMapper.ctnr_cd_rtc_yn((Map<String, String>) data);
		
		
		if("Y".equals(ctnrCdRtcYn)){
			selList = commonceMapper.ctnr_cd_select((Map<String, String>) data);	
		} else{
			selList = commonceMapper.ctnr_cd_select_all((Map<String, String>) data);
		}
		
		return selList;
	}
	
	/**
	 *	도매업자,공병상이랑 거래중인 생산자 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> mfc_bizrnm_select2(Map<String, String> data)  {
		List<?> selList = commonceMapper.mfc_bizrnm_select2((Map<String, String>) data);
		return selList;
	}
	
	/**
	 *	도매업자,공병상이랑 거래중인 생산자 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> mfc_bizrnm_select6(Map<String, String> data)  {
		List<?> selList = commonceMapper.mfc_bizrnm_select6((Map<String, String>) data);
		return selList;
	}
	
	/**
	 *	도매업자,공병상이랑 거래중인 생산자의 직매장 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> mfc_bizrnm_select3(Map<String, String> data)  {
		List<?> selList = commonceMapper.mfc_bizrnm_select3((HashMap<String, String>) data);
		return selList;
	}
	
	/**
	 *	 도매업자 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> mfc_bizrnm_select4(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		List<?> selList=null;
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		
		//로그인자가 센터
		if(uvo.getBIZR_TP_CD().equals("T1") ){
			map.put("T_USER_ID", uvo.getUSER_ID());
		}
		//로그인자가 생산자일경우
		else if(uvo.getBIZR_TP_CD().equals("M1")||uvo.getBIZR_TP_CD().equals("M2")){
			map.put("MFC_BIZRID", uvo.getBIZRID());  					// 사업자ID
			map.put("MFC_BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호
			//로그인자가 본사가 아닌경우 본사인경우 모든 직매장 보여야한다.
			if(!uvo.getBRCH_NO().equals("9999999999") ){
				map.put("S_BRCH_ID", uvo.getBRCH_ID());  			// 지점ID
				map.put("S_BRCH_NO", uvo.getBRCH_NO());  			// 지점번호
			}
		}
		
		//로그인자가 도매업자 일경우
		if(uvo.getBIZR_TP_CD().equals("W1")||uvo.getBIZR_TP_CD().equals("W2")){
			map.put("BIZRID", uvo.getBIZRID());  					// 사업자ID
			map.put("BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호
			selList = commonceMapper.whsdl_select((Map<String, String>) map);//도매업자일경우
		}
		else{
			selList = commonceMapper.mfc_bizrnm_select4((HashMap<String, String>) map);
		}
		
		return selList;
	}
	
	/**
	 *	 생산자랑 거래중인 도매업자 조회 (상태값 Y)
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> mfc_bizrnm_select4_y(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		map.put("STAT_CD", "Y");
		List<?> selList=null;
		
		//로그인자가 생산자일경우
		if(uvo.getBIZR_TP_CD().equals("M1")||uvo.getBIZR_TP_CD().equals("M2")){
			map.put("MFC_BIZRID", uvo.getBIZRID());  					// 사업자ID
			map.put("MFC_BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호
			
			if(!map.containsKey("MFC_BRCH_ID")){//
				
				//로그인자가 본사가 아닌경우, 본사인경우는 모등 직매장이 보여야한다.
				if(!uvo.getBRCH_NO().equals("9999999999")){
					map.put("MFC_BRCH_ID", uvo.getBRCH_ID());  				// 지점ID
					map.put("MFC_BRCH_NO", uvo.getBRCH_NO());  			// 지점번호
				}
			}
		}
		
		if(uvo.getBIZR_TP_CD().equals("W1")||uvo.getBIZR_TP_CD().equals("W2")){ //로그인자가 도매업자
			map.put("BIZRID", uvo.getBIZRID());  					// 사업자ID
			map.put("BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호
			selList = commonceMapper.whsdl_select((Map<String, String>) map);//도매업자일경우
		}else{
			selList = commonceMapper.mfc_bizrnm_select4((HashMap<String, String>) map);
		}
		
		return selList;
	}
	
	/**
	 *	 생산자랑 거래중인 도매업자 지점 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> mfc_bizrnm_select5(Map<String, String> data)  {
		List<?> selList = commonceMapper.mfc_bizrnm_select5((HashMap<String, String>) data);
		return selList;
	}
	
	/**
	 *	사업자 유형에 따른 도매업자 업체명 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> enp_nm_select(Map<String, String> data)  {
		List<?> selList = commonceMapper.enp_nm_select((HashMap<String, String>) data);
		return selList;
	}
	
	/**
	 *	도매업자 구분 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> whsdl_se_select(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		List<?> selList = null;
		//센터랑 ,생산자가 아닐경우
		if(!uvo.getBIZR_TP_CD().equals("T1")&&
			!uvo.getBIZR_TP_CD().equals("M1")&&
			!uvo.getBIZR_TP_CD().equals("M2") ){
			map.put("ETC_CD", "T");
			map.put("BIZR_TP_CD", uvo.getBIZR_TP_CD());
		}
			selList = commonceMapper.whsdl_se_select((HashMap<String, String>) map);
		return selList;
	}
	
	/**
	 *	도매업자 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> whsdl_select(Map<String, String> data)  {
		
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		List<?> selList = null;
		selList =commonceMapper.whsdl_select((Map<String, String>) map);//도매업자일경우
		return selList;
	}
	
	/**
	 *	소매업자 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> rtl_select(Map<String, String> data)  {
		
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		List<?> selList = null;
		selList = commonceMapper.rtl_select((HashMap<String, String>) map);
		return selList;
	}
	
	/**
	 *	도매랑 거래중인 소매업자  (소매거래처정보 테이블에서 가져오기)
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> rtl_cust_select(Map<String, String> data)  {
		
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		List<?> selList = null;
		selList = commonceMapper.rtl_cust_select((HashMap<String, String>) map);
		return selList;
	}
	
	
	/**
	 *	사업자에 따른 지점 조회 (도매업자)
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> brch_nm_select_wh(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);

		map.put("BIZRID", uvo.getBIZRID());  					// 사업자ID
		map.put("BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호

		List<?> selList = commonceMapper.brch_nm_select((HashMap<String, String>) map);
		return selList;
	}
	
	/**
	 *	사업자에 따른 지점 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> brch_nm_select(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		
		//로그인자가 센터일경우
		if(uvo.getBIZR_TP_CD().equals("T1") ){
			map.put("T_USER_ID", uvo.getUSER_ID());
		}
		
		if(map.get("BIZRNO") == null){
			
			//로그인자가 생산자일경우
			if(uvo.getBIZR_TP_CD().equals("M1")||uvo.getBIZR_TP_CD().equals("M2")
			 ||uvo.getBIZR_TP_CD().equals("W1")||uvo.getBIZR_TP_CD().equals("W2")){
				map.put("BIZRID", uvo.getBIZRID());  					// 사업자ID
				map.put("BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호
				
				//로그인자가 본사가 아닌경우 본사인경우 모든 직매장 보여야한다.
				if(!uvo.getBRCH_NO().equals("9999999999")){
					map.put("BRCH_ID", uvo.getBRCH_ID());  				// 지점ID
					map.put("BRCH_NO", uvo.getBRCH_NO());  			// 지점번호
				}
				map.put("BIZR_TP_CD", uvo.getBIZR_TP_CD());
			}else{
				map.put("BIZRID", "");  			// 사업자ID
				map.put("BIZRNO", "");  			// 사업자번호
			}
			
		}else{
			
			if(uvo.getBIZR_TP_CD().equals("M1")||uvo.getBIZR_TP_CD().equals("M2")){ //생산자 로그인
					
				//로그인자가 본사가 아닌경우, 본사인경우는 모든 직매장 보여야한다.
				if(!uvo.getBRCH_NO().equals("9999999999") && (!data.containsKey("ALL_YN") || !data.get("ALL_YN").equals("Y")) ){
					map.put("BRCH_ID", uvo.getBRCH_ID());  				// 지점ID
					map.put("BRCH_NO", uvo.getBRCH_NO());  			// 지점번호
				}
				// 없어도 될듯...
				//map.put("BIZR_TP_CD", uvo.getBIZR_TP_CD());
				
			}else if(uvo.getBIZR_TP_CD().equals("W1")||uvo.getBIZR_TP_CD().equals("W2")){ // 도매업자 로그인
				
					map.put("CUST_BIZRID", uvo.getBIZRID());  				// 사업자ID
					map.put("CUST_BIZRNO", uvo.getBIZRNO_ORI());  		// 사업자번호
					
				if(!uvo.getBRCH_NO().equals("9999999999") && (!data.containsKey("ALL_YN") || !data.get("ALL_YN").equals("Y"))){
					map.put("CUST_BRCH_ID", uvo.getBRCH_ID());  			// 지점ID
					map.put("CUST_BRCH_NO", uvo.getBRCH_NO());  		// 지점번호
				}
				
			}
			
		}
		
		List<?> selList = commonceMapper.brch_nm_select((HashMap<String, String>) map);
		return selList;
	}
	
	/**
	 *	사업자에 따른 지점 조회 (상태값 Y)
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> brch_nm_select_y(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		map.put("STAT_CD", "Y");
		if(map.get("BIZRNO") ==null){
			//로그인자가 생산자일경우
			if(uvo.getBIZR_TP_CD().equals("M1")||uvo.getBIZR_TP_CD().equals("M2")
			 ||uvo.getBIZR_TP_CD().equals("W1")||uvo.getBIZR_TP_CD().equals("W2")){  
				
				map.put("BIZRID", uvo.getBIZRID());  					// 사업자ID
				map.put("BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호
				//로그인자가 본사가 아닌경우 본사인경우 모든 직매장 보여야한다.
				if(!uvo.getBRCH_NO().equals("9999999999")){
					map.put("BRCH_ID", uvo.getBRCH_ID());  				// 지점ID
					map.put("BRCH_NO", uvo.getBRCH_NO());  			// 지점번호
				}
			}
		}else{// 로그인자가 도매업자 일경우 
			
			if(uvo.getBIZR_TP_CD().equals("M1")||uvo.getBIZR_TP_CD().equals("M2")){  
				
				//로그인자가 본사가 아닌경우 본사인경우 모든 직매장 보여야한다.
				if(!uvo.getBRCH_NO().equals("9999999999")){
					map.put("BRCH_ID", uvo.getBRCH_ID());  				// 지점ID
					map.put("BRCH_NO", uvo.getBRCH_NO());  			// 지점번호
				}
				
			}else if(uvo.getBIZR_TP_CD().equals("W1")||uvo.getBIZR_TP_CD().equals("W2")){  
				map.put("CUST_BIZRID", uvo.getBIZRID());  			// 사업자ID
				map.put("CUST_BIZRNO", uvo.getBIZRNO_ORI());  	// 사업자번호
				if(!uvo.getBRCH_NO().equals("9999999999")){
					map.put("CUST_BRCH_ID", uvo.getBRCH_ID());  	 // 지점ID
					map.put("CUST_BRCH_NO", uvo.getBRCH_NO());  // 지점번호
				}
			}
		}
		
		List<?> selList = commonceMapper.brch_nm_select((HashMap<String, String>) map);
		return selList;
	}
	
	/**
	 *	사업자에 따른 지점 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> brch_nm_select_all(Map<String, String> data)  {
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);

		List<?> selList = commonceMapper.brch_nm_select((HashMap<String, String>) map);
		return selList;
	}
	
	/**
	 *	사업자에 따른 지점 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> brch_nm_select_all_y(Map<String, String> data)  {
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		map.put("STAT_CD", "Y");

		List<?> selList = commonceMapper.brch_nm_select((HashMap<String, String>) map);
		return selList;
	}
	
	/**
	 *	사업자에 따른 부서 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> dept_nm_select(Map<String, String> data)  {
		List<?> selList = commonceMapper.dept_nm_select((HashMap<String, String>) data);
		return selList;
	}
	
	/**
	 *	문서채번
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public String doc_psnb_select(String psnbCd)  {
		
		Map<String, String> data = new HashMap<String, String>();
		String psnbSeq_full = "";

		data.put("DOC_PSNB_CD", psnbCd);
		
		if(psnbCd.equals("RV")){ //회수정보
			
			data.put("CNT", "6"); //회수만 6자리로
			
			psnbSeq_full = commonceMapper.doc_psnb_select_rv(data);
			String psnbSeq = psnbSeq_full.substring(psnbSeq_full.length()-6, psnbSeq_full.length()); //6
			data.put("PSNB_SEQ", psnbSeq);
			commonceMapper.doc_psnb_insert(data);
			
		}else{
			
			data.put("CNT", "4"); //4자리
			
			boolean roop = true;
			while(roop){
				psnbSeq_full = commonceMapper.doc_psnb_select(data);
				String psnbSeq = psnbSeq_full.substring(psnbSeq_full.length()-4, psnbSeq_full.length()); //4
				
				data.put("PSNB_SEQ", psnbSeq);
				try{
					commonceMapper.doc_psnb_insert(data);
					roop = false;
				}catch (IOException io) {
					io.getMessage();
				}catch (SQLException sq) {
					sq.getMessage();
				}catch (NullPointerException nu){
					nu.getMessage();
				}catch(Exception e){
					roop = true; //다시 조회
				}
			}
			
		}
		
		return psnbSeq_full;
	}
	
	/**
	 *	채번 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public String psnb_select(String psnbCd)  {
		
		Map<String, String> data = new HashMap<String, String>();
		String psnbSeq = "";
		String cnt = ""; //일련번호 자리수
		
		if(psnbCd.equals("S0001")){ //사업자ID
			cnt = "7";
			data.put("PSNB_NM", "사업자ID");
		}else if(psnbCd.equals("S0002")){ // ERP사업자코드
		    cnt ="6";
		    data.put("PSNB_NM", "ERP사업자코드");
		}else if(psnbCd.equals("S0003")){ //개별취급수수료
		    cnt ="8";
		    data.put("PSNB_NM", "개별취급수수료");
		}else if(psnbCd.equals("S0004") ){ //정산수납확인 일련번호
			cnt ="10";
			data.put("PSNB_NM", "정산수납확인 일련번호");
		}else if(psnbCd.equals("S0006")){ // 정산기준등록순번
			cnt ="5";
			data.put("PSNB_NM", "정산기준등록순번");
		}else if(psnbCd.equals("S0007")){ // 지점ID
			cnt ="8";
			data.put("PSNB_NM", "지점ID");
		}else if(psnbCd.equals("S0008") ){ //수납확인 일련번호
			cnt ="10";
			data.put("PSNB_NM", "수납확인 일련번호");
		}else{ //미사용?
			cnt = "5";
			data.put("PSNB_NM", "기타");
		}
		
		data.put("PSNB_CD", psnbCd);
		data.put("CNT", cnt);
		
		boolean roop = true;
		while(roop){
			psnbSeq = commonceMapper.psnb_select(data);
			
			data.put("PSNB_SEQ", psnbSeq);
			try{
				commonceMapper.psnb_insert(data);
				roop = false;
			}catch (IOException io) {
				io.getMessage();
			}catch (SQLException sq) {
				sq.getMessage();
			}catch (NullPointerException nu){
				nu.getMessage();
			}catch(Exception e){
				roop = true;	//다시 조회
			}
		}
		
		return psnbSeq;
	}
	
	
	/**
	 * static 언어목록 조회 
	 * @return
	 * @
	 */
	public List<?> selectTextList() {
		return commonceMapper.SELECT_TEXT_LIST();
	}
	
	/**
	 * 타이틀명 조회
	 * @param menuCd
	 * @return
	 * @
	 */
	public String getMenuTitle(String menuCd) {

		HashMap<String,String> map = new HashMap<String, String>();
		map.put("MENU_CD", menuCd);
		
		String title = commonceMapper.SELECT_MENU_TITLE(map);
		
		return title;
	}
	
	/**
	 * 버튼 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> selectBtnList(Map<String, String> map, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		
		if(vo != null){
			map.put("USER_ID", vo.getUSER_ID());
		}
		
		return commonceMapper.SELECT_BTN_LIST(map);
	}
	
	/**
	 * 엑셀저장
	 * @param data, list
	 * @return
	 * @
	 */
	public void excelSave(HttpServletRequest request, HashMap<String, String> data, List<?> list) {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");

		int rowNum = 0;
		String path = CommonProperties.EXCEL_PATH + File.separator;
		String excelFile = data.get("fileName").toString();
		
		//그리드 컬럼 목록
		List<?> columns = JSONArray.fromObject(data.get("columns"));
		
		SXSSFWorkbook wb = new SXSSFWorkbook(100);

		// 셀 스타일
		XSSFCellStyle sc = (XSSFCellStyle)wb.createCellStyle();
		sc.setAlignment(CellStyle.ALIGN_CENTER);
		sc.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

		//HSSFColor myColor = new HSSFColor(new java.awt.Color(153, 204, 255));
		sc.setFillForegroundColor(new XSSFColor(new java.awt.Color(239, 246, 252)));
		sc.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		
		sc.setBorderBottom(CellStyle.BORDER_THIN);
		sc.setBorderLeft(CellStyle.BORDER_THIN);
		sc.setBorderRight(CellStyle.BORDER_THIN);
		sc.setBorderTop(CellStyle.BORDER_THIN);
		
		
		CellStyle sc2 = wb.createCellStyle();
		sc2.setAlignment(CellStyle.ALIGN_CENTER);
		
		// 셀 스타일
		CellStyle sl = wb.createCellStyle();
		sl.setAlignment(CellStyle.ALIGN_LEFT);
		
		// 셀 스타일
		CellStyle sr = wb.createCellStyle();
		sr.setAlignment(CellStyle.ALIGN_RIGHT);
		

		Sheet sheet = wb.createSheet("Sheet1");
		sheet.setDefaultColumnWidth(20);// 기본값.
		//sheet.setColumnWidth(int columnindex, int width);//각 컬럼의 길이 조정.

		Map<Integer, Double> tMap = new HashMap<Integer, Double>();
		
		Row row00 = null; //그룹 헤더용
		Row row0  = null; //그룹 헤더용
		Row row1  = null;
		
		boolean groupMergeReady0 = false;
		boolean groupMergeReady  = false;
		int groupMergeCnt0 = 0;
		int groupMergeCnt  = 0;
		
		//타이틀
		for(int i=0; i<columns.size(); i++){
			
			Map<String, String> cMap = (Map<String, String>)columns.get(i);
			
			if(i==0){
				if(cMap.containsKey("groupHeader2")){ //그룹헤더
					row00 = sheet.createRow(rowNum);
					rowNum++;
				}

				if(cMap.containsKey("groupHeader")){ //그룹헤더
					row0 = sheet.createRow(rowNum);
					rowNum++;
				}
				
				row1 = sheet.createRow(rowNum);
				rowNum++;
			}
			
			Cell cell_00 = null;
			Cell cell_0  = null;

			if(cMap.containsKey("groupHeader2")){ //그룹헤더
				if(row00!=null) {
					cell_00 = row00.createCell(i);
					String ghText = String.valueOf(cMap.get("groupHeader2"));
					
					if(ghText.equals("M")){ //빈값일때 가로병합
						groupMergeCnt0++;
					}else{
						if(groupMergeCnt0 > 0) groupMergeReady0 = true;
					}
					
					cell_00.setCellValue(ghText);
					cell_00.setCellStyle(sc);
				} else {
					return ;
				}
			}

			if(cMap.containsKey("groupHeader")){ //그룹헤더
				cell_0 = row0.createCell(i);
				String ghText = String.valueOf(cMap.get("groupHeader"));
				
				if(ghText.equals("")){ //빈값일때 가로병합
					groupMergeCnt++;
				}else{
					if(groupMergeCnt > 0) groupMergeReady = true;
				}
				
				cell_0.setCellValue(ghText);
				cell_0.setCellStyle(sc);
			}
			
			Cell cell_1 = row1.createCell(i);
			cell_1.setCellValue( cMap.get("headerText") );
			cell_1.setCellStyle(sc);
			
			//그리드 합계 기능 사용 대상 !@
			if(cMap.get("id") != null && !cMap.get("id").equals("")){
				tMap.put(i, (double) 0);
			}
			
			if(cell_00 != null) {
				if(cell_0 !=null) {
					//셀병합 세로
					if(cell_00.getStringCellValue().equals(cell_0.getStringCellValue()) && cell_00.getStringCellValue().equals(cell_1.getStringCellValue())){
						sheet.addMergedRegion(new CellRangeAddress(0, 2, i, i));
					}
					else if(cell_00.getStringCellValue().equals(cell_0.getStringCellValue())){
						sheet.addMergedRegion(new CellRangeAddress(0, 1, i, i));
					}
					else if(cell_0.getStringCellValue().equals(cell_1.getStringCellValue())){
						sheet.addMergedRegion(new CellRangeAddress(1, 2, i, i));
					}

					//셀병합 가로
					if(groupMergeReady0){
						sheet.addMergedRegion(new CellRangeAddress(0, 0, i-groupMergeCnt0-1, i-1));
						groupMergeCnt0 = 0; //초기화
						groupMergeReady0 = false; //초기화
					}
					//셀병합 가로 (for문 마지막에 그룹헤더가 빈값이면 병합)
					if(i == (columns.size()-1) && cell_00 != null && cell_00.getStringCellValue().equals("M")){
						sheet.addMergedRegion(new CellRangeAddress(0, 0, i-groupMergeCnt0, i));
					}
					
					//셀병합 가로
					if(groupMergeReady){
						sheet.addMergedRegion(new CellRangeAddress(1, 1, i-groupMergeCnt-1, i-1));
						groupMergeCnt = 0; //초기화
						groupMergeReady = false; //초기화
					}
					//셀병합 가로 (for문 마지막에 그룹헤더가 빈값이면 병합)
					if(i == (columns.size()-1) && cell_0 != null && cell_0.getStringCellValue().equals("")){
						sheet.addMergedRegion(new CellRangeAddress(1, 1, i-groupMergeCnt, i));
					}
				} else {
					return ;
				}
			}
			else {
				//셀병합 세로
				if(cell_0 != null && cell_0.getStringCellValue().equals(cell_1.getStringCellValue())){
					sheet.addMergedRegion(new CellRangeAddress(0, 1, i, i));
				}

				//셀병합 가로
				if(groupMergeReady){
					sheet.addMergedRegion(new CellRangeAddress(0, 0, i-groupMergeCnt-1, i-1));
					groupMergeCnt = 0; //초기화
					groupMergeReady = false; //초기화
				}
				//셀병합 가로 (for문 마지막에 그룹헤더가 빈값이면 병합)
				if(i == (columns.size()-1) && cell_0 != null && cell_0.getStringCellValue().equals("")){
					sheet.addMergedRegion(new CellRangeAddress(0, 0, i-groupMergeCnt, i));
				}
			}
		}

		//조회 리스트 데이터
		for (int i = 0; i < list.size(); i++) {
	
			Map<String, Object> listMap = (Map<String, Object>)list.get(i);
			Row row = sheet.createRow(rowNum);

			//컬럼 값
			for(int k=0; k<columns.size(); k++){
				Map<String, String> cMap = (Map<String, String>)columns.get(k);
				String dataField = cMap.get("dataField");
				Cell cell_1 = row.createCell(k);
				
				if(listMap != null && listMap.containsKey(dataField)){
					if(listMap.get(dataField) instanceof String) { 
						cell_1.setCellValue(String.valueOf(listMap.get(dataField)) );
					}else{
						cell_1.setCellValue(Double.parseDouble(String.valueOf(listMap.get(dataField))) );
						
						//합계 데이터 계산 !@
						if(tMap.containsKey(k)){
							tMap.put(k, tMap.get(k) + Double.parseDouble(String.valueOf(listMap.get(dataField))) );
						}
					}
				}else{
					
				}

				if(cMap.get("textAlign").equals("left")){
					cell_1.setCellStyle(sl);
				}else if(cMap.get("textAlign").equals("right")){
					cell_1.setCellStyle(sr);
				}else{
					cell_1.setCellStyle(sc2);
				}					
			}
			
			rowNum++;
		}
		
		
		if(!tMap.isEmpty()){
			Row row = sheet.createRow(rowNum);
			Cell cell_1 = row.createCell(0);
			cell_1.setCellValue("Total");//다국어...
			cell_1.setCellStyle(sc2);
			
			for(int key : tMap.keySet()){
				Cell cell_t = row.createCell(key);
				cell_t.setCellValue(tMap.get(key));
				cell_t.setCellStyle(sr);// 그냥 우정렬로..
			}
		}
		

		try {
			String fullPath = path + excelFile;
			String testPath = "C:/Users/LeadIT/Desktop/cosmo/"+excelFile;
			FileOutputStream fileOut = new FileOutputStream(new File(FilenameUtils.getFullPath(testPath)+FilenameUtils.getName(testPath)));
//			FileOutputStream fileOut = new FileOutputStream(new File(FilenameUtils.getFullPath(fullPath)+FilenameUtils.getName(fullPath)));
//			FileOutputStream fileOut = new FileOutputStream(new File(FilenameUtils.getFullPath(fullPath)+FilenameUtils.getName(fullPath)));
			wb.write(fileOut);
			fileOut.close();
			wb.dispose();

			//if(uvo.getATH_GRP_CD().equals("ATC002") || uvo.getATH_GRP_CD().equals("ATC003")){
			/*if(uvo.getBIZR_TP_CD().equals("T1")){ //센터사용자
				String userId = uvo.getUSER_ID();
				if(userId.equals("jaejae1523") || userId.equals("2funfunsoo") || userId.equals("limhyunju08") 
						|| userId.equals("puen9775") || userId.equals("cb000002") || userId.equals("winersujin")
				){ //콜센터 예외처리

				}else{
					//java.lang.UnsatisfiedLinkError: no f_fcwpkg_jni in java.library.path
					//파일 암호화
					String[] args = new String[2];
					args[0] = excelFile;
					args[1] = path+excelFile;
					String[] user = new String[2];
					user[0] = uvo.getUSER_ID();
					user[1] = uvo.getUSER_NM();
					encrypt.main(args, user);
				}
			}*/
			
			//JOptionPane.showMessageDialog(null, "엑셀로 저장 완료 (파일 이름 :" + excelFile + ")");

		} catch (FileNotFoundException e) {
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		} catch (IOException e) {
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
	}
	
	/**
	 * 엑셀 그리드 업로드
	 * @param inputMap
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	  @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	    public HashMap excelUpload(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		
				HashMap<String, Object> rtnMap = new HashMap<String, Object>();
			    
				try {
					ArrayList<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
					ExcelReader er = new ExcelReader();
					//크로스 사이트 스크립트 수정 후 변경
//			    	MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
			    	MultipartHttpServletRequest mptRequest = WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
			    	String callBackFunc = mptRequest.getParameter("callBackFunc");
			    	Iterator fileIter = mptRequest.getFileNames();
					while (fileIter.hasNext()) {
						MultipartFile mFile = mptRequest.getFile((String)fileIter.next());
						
						String orginFileName = mFile.getOriginalFilename();
						int index = orginFileName.lastIndexOf(".");
						String fileExt = orginFileName.substring(index + 1);
						if(fileExt.toLowerCase().equals("xlsx")){
							list = er.getDataStreamXlsx(mFile, true);
						}else if(fileExt.toLowerCase().equals("xls")){
							list = er.getDataStream(mFile, true);
						}else{
							throw new Exception("A013");   //"업로드 파일 오류-확장자 불일치";
						}
						 
					}//while
			    	rtnMap.put("list", util.mapToJson(list));    	 
			    	
				}catch (IOException io) {
					io.getMessage();
				}catch (SQLException sq) {
					sq.getMessage();
				}catch (NullPointerException nu){
					nu.getMessage();
				}catch (Exception e) {
					 if(e.getMessage().equals("A013") ){
						 throw new Exception(e.getMessage());
					 }else{
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					 }
				}
				
				return rtnMap;
		  }
	  
		/**
		 * 오류발생이력등록
		 * @param map
		 * @
		 */
		public void insertErrHist(HashMap<String, String> map) {
			commonceMapper.INSERT_EPCN_ERR_HIST(map);
		}
		
		/**
		 * error log insert
		 * @param request
		 * @param e
		 * @
		 */
		/*
		public void insertExceptionHandleErrLog(HttpServletRequest request, Exception e) {
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			if(vo != null){
				String USER_ID = vo.getUSER_ID();
				
				String MENU_GRP_CD = "";
				String MENU_CD = "";
				String BTN_CD = "";
				String ERR_CD = "";
				String ERR_MSG = "";
				String ACPT_ERR = (e.getMessage() == null) ? "" : e.getMessage().toString();
				if(ACPT_ERR.length() > 450) ACPT_ERR = ACPT_ERR.substring(0, 450);
				String PRAM = "";
				String ACSS_IP = request.getRemoteAddr();
				
				
				boolean flag = true;
				String url = request.getRequestURI().toUpperCase();
				if(url.indexOf("SELECT") > - 1 || url.indexOf("LOG") > - 1
						 || url.indexOf("USER") > - 1 || url.indexOf("MAIN") > - 1) flag = false;
				
				url = url.substring(url.lastIndexOf("/")+1);
				String cd = url.substring(0,6);
				if(flag){
					BTN_CD = (null == request.getParameter("PARAM_BTN_CD")) ? "" : request.getParameter("PARAM_BTN_CD");
					MENU_GRP_CD = cd.substring(4);
					if(url.indexOf("_") > -1){
						MENU_CD = url.substring(0, url.indexOf("_"));
					}else{
						MENU_CD = url.substring(0, url.indexOf("."));
					}
				}
				
				
				if(e instanceof DataAccessResourceFailureException){
					ERR_CD = "E004";
				}else if(e instanceof DataIntegrityViolationException){
					ERR_CD = "E005";
				}else if(e instanceof UncategorizedDataAccessException){
					ERR_CD = "E006";
				}else if(e instanceof UncategorizedSQLException){
					ERR_CD = "E002";
				}else if(e instanceof DataAccessException){
					ERR_CD = "E003";
				}else if(e instanceof SQLException){
					ERR_CD = "E001";
				}else if(e instanceof TransactionException){
					ERR_CD = "E007";
				}else if(e instanceof EgovBizException){
					ERR_CD = "E008";
				}else{
					ERR_CD = "E099";
				}
				ERR_MSG = this.getErrorMsg("A", ERR_CD);
				
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("USER_ID", USER_ID);
				map.put("MENU_GRP_CD", MENU_GRP_CD);
				map.put("MENU_CD", MENU_CD);
				map.put("BTN_CD", BTN_CD);
				map.put("ERR_CD", ERR_CD);
				map.put("ERR_MSG", ERR_MSG);
				map.put("ACPT_ERR", ACPT_ERR);
				map.put("PRAM", PRAM);
				map.put("ACSS_IP", ACSS_IP);
				this.insertErrHist(map);
			}
		}
		*/
		
		/**
		 * 에러 로그 등록(수동)
		 * @param request
		 * @param e
		 * @
		 */
		public void insertErrorLog(HttpServletRequest request, String ERR_CD, String ERR_MSG) {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			if(vo != null){
				String USER_ID = vo.getUSER_ID();
				
				String MENU_GRP_CD = "";
				String MENU_CD = "";
				String BTN_CD = "";
				String ACPT_ERR = ""; //수신오류
				Map<String, Object> PRAM = (Map<String, Object>)request.getParameterMap();
				String ACSS_IP = request.getRemoteAddr();
				
				boolean flag = true;
				System.out.println("여기냐?");
				String url = request.getRequestURI().toUpperCase();
				if(url.indexOf("SELECT") > - 1 || url.indexOf("LOG") > - 1
						 || url.indexOf("USER") > - 1 || url.indexOf("MAIN") > - 1) flag = false;
				
				url = url.substring(url.lastIndexOf("/")+1);
				String cd = url.substring(0,6);
				if(flag){
					BTN_CD = (null == request.getParameter("PARAM_BTN_CD")) ? "" : request.getParameter("PARAM_BTN_CD");
					MENU_GRP_CD = cd.substring(4);
					if(url.indexOf("_") > -1){
						MENU_CD = url.substring(0, url.indexOf("_"));
					}else{
						MENU_CD = url.substring(0, url.indexOf("."));
					}
				}
				
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("USER_ID", USER_ID);
				map.put("MENU_GRP_CD", MENU_GRP_CD);
				map.put("MENU_CD", MENU_CD);
				map.put("BTN_CD", BTN_CD);
				map.put("ERR_CD", ERR_CD);
				map.put("ERR_MSG", ERR_MSG);
				map.put("ACPT_ERR", ACPT_ERR);
				map.put("PRAM", JSONObject.fromObject(PRAM).toString());
				map.put("ACSS_IP", ACSS_IP);
				this.insertErrHist(map);
			}
		}
		
		/**
		 * 에러 로그 등록(수동 - API)
		 * @param request
		 * @param
		 * @
		 */
		@SuppressWarnings("unchecked")
		public void insertErrorLogAPI(HttpServletRequest request, String ERR_CD, String ERR_MSG) {

	        Map<String, String> PRAM = (Map<String, String>)request.getAttribute("PRAM");
	        
	        HashMap<String, String> map = new HashMap<String, String>();
	        System.out.println("여긴가2");
			map.put("BIZR_ISSU_KEY", PRAM.get("MBR_ISSU_KEY").toString());
			map.put("LK_API_CD", PRAM.get("API_ID").toString());
			map.put("ACSS_IP", request.getRemoteAddr());
			map.put("CALL_URL", request.getRequestURL().toString());
			map.put("ERR_CD", ERR_CD);
			map.put("ERR_MSG", ERR_MSG);
			map.put("REG_SN", PRAM.get("REG_SN").toString());
			//map.put("PRAM", JSONObject.fromObject(PRAM).toString());
			
			commonceMapper.INSERT_EPCN_API_HIST(map);

		}
		
		/**
		 * 그리드컬럼 조회
		 * @param menuCd
		 * @return
		 * @
		 */
		public List<?> GRID_INFO_SELECT(String menuCd,HttpServletRequest request) {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			HashMap<String,String> map = new HashMap<String, String>();
			map.put("MENU_CD", menuCd);
			map.put("USER_ID", vo.getUSER_ID());  		// 등록자
			List<?> list = commonceMapper.GRID_INFO_SELECT(map);
			return list;
		}
		
		/**
		 * 그리드컬럼 저장
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String GRID_INFO_INSERT(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
				try {
					inputMap.put("USER_ID", vo.getUSER_ID());  		// 등록자
					commonceMapper.GRID_INFO_INSERT(inputMap); 		// 그리드 컬럼 저장 수정
				}catch (IOException io) {
					io.getMessage();
				}catch (SQLException sq) {
					sq.getMessage();
				}catch (NullPointerException nu){
					nu.getMessage();
				}catch (Exception e) {
					throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			return errCd;    	
	    }
		
		
		/**
		 * 정산기준관리 조회
		 * @param menuCd
		 * @return
		 * @
		 */
		public List<?> std_mgnt_select(HttpServletRequest request, Map<String, String> data) {
			
			HttpSession session = request.getSession();
			UserVO uvo = (UserVO) session.getAttribute("userSession");
			
			HashMap<String,String> map = new HashMap<String, String>();
			map.putAll(data);
			if(uvo.getBIZR_TP_CD().equals("M1") || uvo.getBIZR_TP_CD().equals("M2") ){
				map.put("BIZRID", uvo.getBIZRID());  			// 사업자아이디
				map.put("BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호
			}
			List<?> list = commonceMapper.std_mgnt_select(map);
			return list;
		}
		   
		/**
		 * 정산기준관리 생산자 조회
		 * @param menuCd
		 * @return
		 * @
		 */
		public List<?> std_mgnt_mfc_select(HttpServletRequest request, Map<String, String> data) {
			
			HttpSession session = request.getSession();
			UserVO uvo = (UserVO) session.getAttribute("userSession");
			
			HashMap<String,String> map = new HashMap<String, String>();
			map.putAll(data);
			if(uvo.getBIZR_TP_CD().equals("M1") || uvo.getBIZR_TP_CD().equals("M2") ){
				map.put("BIZRID", uvo.getBIZRID());  				// 사업자아이디
				map.put("BIZRNO", uvo.getBIZRNO());  			// 사업자번호
			}
			
			List<?> list = commonceMapper.std_mgnt_mfc_select(map);
			return list;
		}
		
		
		/**
		 * 회수용기코드
		 * @param data   
		 * @param request   
		 * @return
		 * @   
		 */        
		public List<?> rtrvl_ctnr_cd_select(Map<String, String> data)  {
			Map<String, String> map =new HashMap<String, String>();
			map.putAll(data);
			
			//회수용기명(표준용기) 리스트
			List<?> epcnStdCtnrList = commonceMapper.rtrvl_ctnr_cd_select((HashMap<String, String>) map);

			return epcnStdCtnrList;
		}
		
		/**
		 * 회수용기코드 조건추가
		 * @param data   
		 * @param request   
		 * @return
		 * @   
		 */        
		public List<?> rtrvl_ctnr_cd_select2(Map<String, String> data)  {
			Map<String, String> map =new HashMap<String, String>();
			map.putAll(data);
			
			//회수용기명(표준용기) 리스트
			List<?> epcnStdCtnrList = commonceMapper.rtrvl_ctnr_cd_select2((HashMap<String, String>) map);

			return epcnStdCtnrList;
		}
		
		/**
		 * 회수용기코드 보증금 취급수수료
		 * @param data
		 * @param request
		 * @return
		 * @
		 */ 
		public List<?> rtrvl_ctnr_dps_fee_select(Map<String, String> data)  {
			Map<String, String> map =new HashMap<String, String>();
			map.putAll(data);
			//회수용기코드 보증금 취급수수료
			List<?> epcnStdCtnrList = commonceMapper.rtrvl_ctnr_dps_fee_select((HashMap<String, String>) map);
			return epcnStdCtnrList;
		}
		
		/**
		 * 등록일자제한설정
		 * @param data
		 * @param request
		 * @return
		 * @
		 */ 
		public HashMap<?,?>  rtc_dt_list_select(Map<String, String> data){     
			Map<String, String> map =new HashMap<String, String>();
			map.putAll(data);
			//등록일자제한설정 
			HashMap<?,?> rtc_dt_list = commonceMapper.rtc_dt_list_select(map); 
			return rtc_dt_list;
		}
		
		/**
		 * 등록일자제한설정 입력일 체크
		 * @param data
		 * @param request
		 * @return
		 * @
		 */ 
		public int  rtc_dt_ck(Map<String, String> data){     
			Map<String, String> map =new HashMap<String, String>();
			map.putAll(data);
			//등록일자제한설정 
			int selList = commonceMapper.rtc_dt_ck(map);   
			return selList;
		}
		
		

		/**
		 * 권한 인서트
		 * @param data
		 * @param request
		 * @return
		 * @
		 */ 
		public void ath_grp_insert(Map<String, String> data)  {
			Map<String, String> map =new HashMap<String, String>();
			map.putAll(data);
						
			if(map.get("BIZR_TP_CD").equals("M1")){
				map.put("ATH_GRP_CD", "ATH002");
			}else if(map.get("BIZR_TP_CD").equals("M2")){
				map.put("ATH_GRP_CD", "ATH003");
			}else if(map.get("BIZR_TP_CD").equals("W1")){
				map.put("ATH_GRP_CD", "ATH004");
			}else if(map.get("BIZR_TP_CD").equals("W2")){
				map.put("ATH_GRP_CD", "ATW003");
			}else if(map.get("BIZR_TP_CD").equals("R1")){
				map.put("ATH_GRP_CD", "ATR001");
			}
						
			if(map.containsKey("ATH_GRP_CD") && !map.get("ATH_GRP_CD").equals("")){
				
				map.put("BIZRID", "T1S0001326");
				map.put("BIZRNO", "a25adbd5cec406ef9e68bfcaf77c4375");
				
				//사용자권한 인서트
				commonceMapper.ath_grp_insert(map);
			}

		}
		
		/**
		 * 알림등록
		 * @param data
		 * @param request
		 * @return
		 * @
		 */ 
		public void anc_insert(Map<String, String> data)  {

			String ancStdCd = commonceMapper.anc_std_cd_select(data);
			data.put("ANC_STD_CD", ancStdCd);
			
			commonceMapper.anc_mgnt_insert(data);
			
			if(data.get("ANC_SE").equals("C1")){ //공지사항 알림등록
				commonceMapper.anc_info_insert(data);
			}else if(data.get("ANC_SE").equals("C2")){ //문의답변 알림등록
				commonceMapper.anc_insert(data);
			}
			
		}
		
		/**
		 * 메인 알림조회
		 * @return
		 * @
		 */
		public List<?> selectAncList(String userId) {
			return commonceMapper.SELECT_ANC_LIST(userId);
		}
		
		/**
		 * 메인 알림조회 모바일
		 * @return
		 * @
		 */
		public List<?> selectAncListM(String userId) {
			return commonceMapper.SELECT_ANC_LIST_M(userId);
		}
		
		/**
		 * 알림 확인 처리
		 * @param data
		 * @param request
		 * @return
		 * @
		 */ 
		public void confirm_anc(Map<String, String> data, HttpServletRequest request)  {
			
			if(data != null && data.containsKey("ANC_KEY") && !data.get("ANC_KEY").equals("")){
				String[] ancKey = data.get("ANC_KEY").split(";");
				
				data.put("ANC_STD_CD", ancKey[0]);
				data.put("USER_ID", ancKey[1]);
				data.put("DTL_SN", ancKey[2]);
			}else{
				
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				if(vo != null){
					data.put("USER_ID", vo.getUSER_ID());
				}
			}
			
			commonceMapper.confirm_anc(data);
		}
		
		/**
		 * 메인화면 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap selectMainList(HttpServletRequest request) {
			
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	Map<String, String> data = new HashMap<String, String>();
	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String userId = "";
			String bizrTpCd = "";
			
			if(vo != null){
				userId = vo.getUSER_ID();
				bizrTpCd = vo.getBIZR_TP_CD();
				
				data.put("USER_ID", vo.getUSER_ID());
				data.put("BIZR_TP_CD", vo.getBIZR_TP_CD());
				data.put("BIZRID", vo.getBIZRID());
				data.put("BIZRNO", vo.getBIZRNO_ORI());
				if(!vo.getBRCH_NO().equals("9999999999")){
					data.put("S_BRCH_ID", vo.getBRCH_ID());
					data.put("S_BRCH_NO", vo.getBRCH_NO());
				}
			}
	    	
    		try {
    			
    			if(bizrTpCd.substring(0,1).equals("M") ){
    				rtnMap.put("cnt", commonceMapper.SELECT_MAIN_DLIVY_CNT(data));
	    			rtnMap.put("cnt2", commonceMapper.SELECT_MAIN_CFM_CNT(data));
	    			rtnMap.put("cfmList", util.mapToJson(commonceMapper.SELECT_MAIN_CFM_LIST(data))); 
					rtnMap.put("exchList",  util.mapToJson(commonceMapper.SELECT_MAIN_EXCH_LIST(data)));
					rtnMap.put("notiList", util.mapToJson(commonceMapper.SELECT_MAIN_NOTI_LIST(data))); 
    			}
    			else if(bizrTpCd.substring(0,1).equals("W") ){
	    			//rtnMap.put("cnt", commonceMapper.SELECT_MAIN_RTRVL_CNT(data));
	    			rtnMap.put("cnt", commonceMapper.SELECT_MAIN_RTN_CNT(data));
	    			rtnMap.put("amt", commonceMapper.SELECT_MAIN_PAY_AMT(data));
					rtnMap.put("notiList", util.mapToJson(commonceMapper.SELECT_MAIN_NOTI_LIST(data))); 
					rtnMap.put("ancList",  util.mapToJson(commonceMapper.SELECT_MAIN_ANC_LIST(userId)));
					rtnMap.put("cfmCrctList",  util.mapToJson(commonceMapper.SELECT_MAIN_CFM_CRCT_LIST(data)));
    			}
    			else if(bizrTpCd.substring(0,1).equals("T") ){
    				rtnMap.put("cnt", commonceMapper.SELECT_MAIN_DLIVY_CNT_T(data));
	    			rtnMap.put("cnt2", commonceMapper.SELECT_MAIN_CFM_CNT_T(data));
					rtnMap.put("notiList", util.mapToJson(commonceMapper.SELECT_MAIN_NOTI_LIST(data))); 
					rtnMap.put("askList",  util.mapToJson(commonceMapper.SELECT_MAIN_ASK_LIST(data)));
    			}
    			
			}catch (IOException io) {
				io.getMessage();
			}catch (SQLException sq) {
				sq.getMessage();
			}catch (NullPointerException nu){
				nu.getMessage();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	  
	    		
	    	return rtnMap;    	
	    }
		
		
		/**
		 * 모바일사용자정보 업데이트
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public void updateMblUserInfo(HashMap<String, String> map) {
			commonceMapper.updateMblUserInfo(map);
		}
		
		/**
		 * 정산기간정보 조회
		 * @return
		 * @
		 */
		public HashMap<String, String> exca_std_mgnt_select(HashMap<String, String> map) {
			return commonceMapper.SELECT_EXCA_STD_MGNT(map);
		}
		
		/**
		 * 알림 보내기
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public void send_anc(String ancStdCd) {
			commonceMapper.send_anc(ancStdCd);
		}
		
		
		/**
		 * 개인정보취급방침 변경 동의
		 * @param map
		 * @
		 */
		public String updatePrsnInfoChgAgrYn(HashMap<String, String> map) throws Exception {
			String errCd = "0000";
			String sUserId = "";
			
			try {

				commonceMapper.UPDATE_PRSN_INFO_CHG_AGR_YN(map);
			}catch (IOException io) {
				io.getMessage();
			}catch (SQLException sq) {
				sq.getMessage();
			}catch (NullPointerException nu){
				nu.getMessage();
			}catch(Exception e){
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return errCd;
		}
		
		/**
		 * 직매장별거래처정보 사업자유형코드 조회
		 * @param data
		 * @param request
		 * @return
		 * @       
		 */
		public String bizr_tp_cd_select(HttpServletRequest request, Map<String, String> map) throws Exception  {
			
			String bizrTpCd = "";
			
			try {

				bizrTpCd = commonceMapper.SELECT_BIZR_TP_CD(map);
			}catch (IOException io) {
				io.getMessage();
			}catch (SQLException sq) {
				sq.getMessage();
			}catch (NullPointerException nu){
				nu.getMessage();
			}catch(Exception e){
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return bizrTpCd;
		}


		public int loginErrCnt(HashMap<String, String> map) throws Exception{
			// TODO Auto-generated method stub
			int ErrCnt = 0;
			try {

				ErrCnt = commonceMapper.loginErrCnt(map);
			}catch (IOException io) {
				io.getMessage();
			}catch (SQLException sq) {
				sq.getMessage();
			}catch (NullPointerException nu){
				nu.getMessage();
			}catch(Exception e){
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return ErrCnt;
		}
		
		/**
		 * 비밀번호 변경 후 관리자 승인 전
		 * @param data
		 * @param request
		 * @return
		 * @       
		 */
		public String loginPwdChg(HashMap<String, String> map) throws Exception{
			// TODO Auto-generated method stub
			String pwdChg = "";
			try {

				pwdChg = commonceMapper.loginPwdChg(map);
			}catch (IOException io) {
				io.getMessage();
			}catch (SQLException sq) {
				sq.getMessage();
			}catch (NullPointerException nu){
				nu.getMessage();
			}catch(Exception e){
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return pwdChg;
		}


		public void insertPrivacy(HttpServletRequest request, ModelMap model, HashMap<String, String> privacyMap) {
			// TODO Auto-generated method stub
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			System.out.println(privacyMap);
			HashMap<String, Object> data = new HashMap<String, Object>();
			JSONObject jsonmap = JSONObject.fromObject(model);
			HashMap<String, String> listmap = util.jsonToMap(jsonmap.getJSONObject("searchDtl"));	
			Long PRIVACY = commonceMapper.privacycnt();
			Long PRIVACYNO =  PRIVACY+1 ;
			System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
			System.out.println("회원정보@@@@@@@@@@@@@@@@@@@@@@@@@@");
			System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
			String ACSS_IP = request.getRemoteAddr();
			data.put("PRIVACYNO", PRIVACYNO);
			data.put("USER_ID", vo.getUSER_ID());
			data.put("USER_NM", vo.getUSER_NM());
			data.put("MENU_CD",privacyMap.get("PARAM_MENU_CD"));
			data.put("TARGET_ID", listmap.get("USER_ID"));
			data.put("TARGET_NM", listmap.get("USER_NM"));
			data.put("EMAIL", listmap.get("EMAIL"));
			data.put("TEL_NO",listmap.get("TEL_NO"));
			
			if(!listmap.get("MBIL_NO").equals("") && listmap.get("MBIL_NO") != null ){
				String MBIL_NO = listmap.get("MBIL_NO").toString()+listmap.get("MBIL_NO3").toString();
				
				
				data.put("MBIL_NO",MBIL_NO);
			}
			data.put("REG_PRSN_ID", vo.getUSER_ID());
			data.put("REG_PRSN_NAME", vo.getUSER_NM());
			data.put("ACSS_IP", ACSS_IP);
			data.put("PARAMSTR","");
			
			System.out.println(data);
			commonceMapper.insertPrivacy(data);
		}

		public List<?> pbox_select(Map<String, String> inputMap) {
			Map<String, String> map =new HashMap<String, String>();
			map.putAll(inputMap);
			List<?> epcnpboxList = commonceMapper.pbox_select((HashMap<String, String>) map);
			return epcnpboxList;
		}

	
		public void insertListPrivacy(HttpServletRequest request,
				HashMap<String, Object> privacyMap) {
			commonceMapper.insertPrivacy(privacyMap);
		}
		
	
		
		
}
