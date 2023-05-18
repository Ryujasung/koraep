package egovframework.koraep.ce.ep.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.WebUtils;

import com.popbill.api.CloseDownService;
import com.popbill.api.CorpState;
import com.sshtools.j2ssh.net.HttpResponse;

import egovframework.common.AuthPerm;
import egovframework.common.CommonProperties;
import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE0085201Service;
import egovframework.koraep.ce.ep.service.EPCE0160131Service;
import egovframework.koraep.cms.cs.web.CMSCS002Controller;

/**
 * 회원가입 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE0085201Controller {

	@Resource(name="epce0085201Service")
	private EPCE0085201Service epce0085201Service;
	
	@Resource(name="epce0160131Service")
	private EPCE0160131Service epce0160131Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;        //공통 service
	
	/**
	 * 약관동의 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE0085201.do")
	public String epce0085201(ModelMap model, HttpServletRequest request) {

		return "/CE/EPCE0085201";
	}
	
	/**
	 * 사업자확인 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00852012.do")
	public String epce00852012(ModelMap model, HttpServletRequest request) {

		return "/CE/EPCE00852012";
	}
	
	/**
	 * 정보입력 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00852013.do")
	public String epce00852013(ModelMap model, HttpServletRequest request) {

		model = epce0085201Service.epce0085201_select(model, request);
		
		return "/CE/EPCE00852013";
	}
	
	/**
	 * 정보입력 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00852014.do")
	public String epce00852014(ModelMap model, HttpServletRequest request) {

		model = epce0085201Service.epce0085201_select(model, request);
		
		return "/CE/EPCE00852014";
	}
	
	/**
	 * 정보입력 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00852015.do")
	public String epce00852015(ModelMap model, HttpServletRequest request) {

		model = epce0085201Service.epce0085201_select2(model, request);
		
		return "/CE/EPCE00852015";
	}
	
	/**
	 * 가입신청완료 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00852016.do")
	public String epce00852016(ModelMap model, HttpServletRequest request) {

		return "/CE/EPCE00852016";
	}
	
	/**
	 * 회원가입절차
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00852886.do")
	public String epce0085288(ModelMap model, HttpServletRequest request) {

		return "/joinPreview";
	}
	
	/**
	 * 전자서명 인스톨
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE0085288.do")
	public String VestCertInstall(ModelMap model, HttpServletRequest request) {

		return "/VestCertInstall";
	}
	
	/**
	 * 전자서명 검증
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00852882.do")
	public String verify(ModelMap model, HttpServletRequest request) {

		return "/verify";
	}
	
	/**
	 * 전자서명 검증
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00852.do")
	public String kmcistest(ModelMap model, HttpServletRequest request) {

		return "/kmcis_web_sample_step01";
	}
	
	/**
	 * 본인인증 요청폼 화면 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00852883.do")
	public String popKmcisForm(@RequestParam HashMap<String, String> param, ModelMap model, HttpServletRequest request) throws Exception{
//		HttpSecurity http = null;
//		http.csrf().disable();
		
		HttpSession session = request.getSession(); 
		System.out.println("883");
		System.out.println("session"+session);
		System.out.println("getId : "+session.getId());
		System.out.println("isNew : "+session.isNew());
		System.out.println("getCreationTime : "+new java.util.Date(session.getCreationTime()).toString());
		System.out.println("getLastAccessedTime : "+new java.util.Date(session.getLastAccessedTime()).toString());
		System.out.println("getMaxInactiveInterval : "+session.getMaxInactiveInterval());
			Calendar today = Calendar.getInstance();		//날짜 생성
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
	        String day = sdf.format(today.getTime());
//	        System.out.println("param"+param);
//	        System.out.println("model"+model);
//	        System.out.println("request"+request.getParameter("CERT_DIV"));
	        //취약점점검 3169 류제성
			/* java.util.Random ran = new Random(); */	 //랜덤 문자 길이
	        Random ran = SecureRandom.getInstance("SHAIPRNG");
	        int numLength = 6;
	        String randomStr = "";
	        for (int i = 0; i < numLength; i++) {
	            randomStr += ran.nextInt(10);	 //0 ~ 9 랜덤 숫자 생성
	        }
	        String reqNum = day + randomStr;	//reqNum은 최대 40byte 까지 사용 가능
//	        System.out.println(request.getServerName());
	        
	        String cpId = "COSM1001";
//	        String urlCode = "001007";//운영서버
	        String urlCode = "004004";//개발서버
//	        String urlCode = "011002";//테스트서버
	        System.out.println("urlcode"+urlCode);
	        String certNum = reqNum;
	        String date = day;
	        String certMet = "M";
	        String birthDay = "";
	        String gender = "";
	        String name = "";
	        String phoneNo = "";
	        String phoneCorp = "";
	        String nation = "";
	        String plusInfo = param.get("plusInfo");
	        String extendVar     = "0000000000000000";     
	        String tr_add = "Y";// 확장변수
//	        String tr_url = "https://" + request.getServerName() + "/EP/EPCE00852885.do?_csrf="+param.get("csrf");
//	        String tr_url = request.getScheme() + "://" + request.getServerName() +":" +request.getServerPort() +"/EP/EPCE00852885.do?_csrf="+_csrf+ "&certNum=" + certNum;
	        String tr_url = request.getScheme() + "://" + request.getServerName() +":" +request.getServerPort() +"/EP/EPCE00852885.do?_csrf="+param.get("_csrf")+ "&certNum=" + certNum;
//	        String tr_url = request.getScheme() + "://" + request.getServerName() +":" +request.getServerPort() +"/EP/EPCE00852885.do";
	        param.put("certNum", certNum);	//요청번호
	        param.put("date", date);		//요청일시 yyyymmddhh24miss
	        param.put("tr_url", tr_url);
//	        System.out.println("EPCE00852883 param"+param);
	        if(phoneCorp == null) phoneCorp = "";
	        if(gender == null) gender = "";
	        
			//01. 한국모바일인증(주) 암호화 모듈 선언
			com.icert.comm.secu.IcertSecuManager seed  = new com.icert.comm.secu.IcertSecuManager();
			
			//02. 1차 암호화 (tr_cert 데이터변수 조합 후 암호화)
			String enc_tr_cert = "";
			String tr_cert = cpId +"/"+ urlCode +"/"+ certNum +"/"+ date +"/"+ certMet +"/"+ birthDay +"/"+ gender +"/"+ name +"/"+ phoneNo +"/"+ phoneCorp +"/"+ nation +"/"+ plusInfo +"/"+ extendVar;
			enc_tr_cert        = seed.getEnc(tr_cert, "");

			//03. 1차 암호화 데이터에 대한 위변조 검증값 생성 (HMAC)
			String hmacMsg = "";
			hmacMsg = seed.getMsg(enc_tr_cert);

			//04. 2차 암호화 (1차 암호화 데이터, HMAC 데이터, extendVar 조합 후 암호화)
			tr_cert  = seed.getEnc(enc_tr_cert + "/" + hmacMsg + "/" + extendVar, "");
			
			
			
			HashMap<String, Object> rtn = new HashMap<String, Object>();
			rtn.put("tr_cert", tr_cert);
			rtn.put("tr_url", tr_url);
			model.addAttribute("rtn",rtn);
//			System.out.println("883 : "+_csrf);
//			return "/kmcis_web_sample_step02";
			return "/kmcis_form";
	}
	
	/**
	 * 본인인증 시드값 생성
	 * @param param
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/EP/EPCE00852884.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String popKmcisSeed(@RequestParam HashMap<String, String> param, ModelMap model, HttpServletRequest request) throws Exception {
		
        Calendar today = Calendar.getInstance();		//날짜 생성
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String day = sdf.format(today.getTime());

        java.util.Random ran = new Random();	 //랜덤 문자 길이
        int numLength = 6;
        String randomStr = "";
        for (int i = 0; i < numLength; i++) {
            randomStr += ran.nextInt(10);	 //0 ~ 9 랜덤 숫자 생성
        }
        String reqNum = day + randomStr;	//reqNum은 최대 40byte 까지 사용 가능
        System.out.println(request.getServerName());
        
        String cpId = "COSM1001";
        String urlCode = "001007";
//        String urlCode = "011002";//개발서버
        String certNum = reqNum;
        String date = day;
        String certMet = "M";
        String birthDay = param.get("birthDay");
        String gender = param.get("gender");
        String name = param.get("name");
        String phoneNo = param.get("phoneNo");
        String phoneCorp = param.get("phoneCorp");
        String nation = param.get("nation");
        String plusInfo = param.get("plusInfo");
        String extendVar     = "0000000000000000";                  // 확장변수
/*        String tr_url = "https://" + request.getServerName() + "/EP/EPCE00852885.do";*/
//        String tr_url = "https://" + request.getServerName() + "/EP/EPCE00852885.do?_csrf="+param.get("csrf");
        String tr_url = request.getScheme() + "://" + request.getServerName() +":" +request.getServerPort() +"/EP/EPCE00852885.do?_csrf="+param.get("_csrf")+ "?certNum=" + certNum;
//        String tr_url = request.getScheme() + "://" + request.getServerName() +":" +request.getServerPort() +"/EP/EPCE00852885.do";
        HttpSession session =request.getSession();
        session.setAttribute("CSRF_TOKEN", UUID.randomUUID().toString());
        		
        param.put("certNum", certNum);	//요청번호
        param.put("date", date);		//요청일시 yyyymmddhh24miss
        param.put("tr_url", tr_url);
        System.out.println("EPCE00852884 param"+param);
        if(phoneCorp == null) phoneCorp = "";
        if(gender == null) gender = "";
        
		//01. 한국모바일인증(주) 암호화 모듈 선언
		com.icert.comm.secu.IcertSecuManager seed  = new com.icert.comm.secu.IcertSecuManager();
		
		//02. 1차 암호화 (tr_cert 데이터변수 조합 후 암호화)
		String enc_tr_cert = "";
		String tr_cert = cpId +"/"+ urlCode +"/"+ certNum +"/"+ date +"/"+ certMet +"/"+ birthDay +"/"+ gender +"/"+ name +"/"+ phoneNo +"/"+ phoneCorp +"/"+ nation +"/"+ plusInfo +"/"+ extendVar;
		enc_tr_cert        = seed.getEnc(tr_cert, "");

		//03. 1차 암호화 데이터에 대한 위변조 검증값 생성 (HMAC)
		String hmacMsg = "";
		hmacMsg = seed.getMsg(enc_tr_cert);

		//04. 2차 암호화 (1차 암호화 데이터, HMAC 데이터, extendVar 조합 후 암호화)
		tr_cert  = seed.getEnc(enc_tr_cert + "/" + hmacMsg + "/" + extendVar, "");
		
		
		
		HashMap<String, Object> rtn = new HashMap<String, Object>();
		rtn.put("tr_cert", tr_cert);
		rtn.put("tr_url", tr_url);
//		model.addAttribute("rtn",rtn);
		return util.mapToJson(rtn).toString();
//		return "/kmcis_form";
	}
	
	
	/**
	 * 본인인증 결과
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/EP/EPCE00852885.do")
	public String kmcStep03( ModelMap model, HttpServletRequest request,HttpServletResponse response, HttpSession session) throws Exception {
		System.out.println("result");
		session = request.getSession();
		System.out.println("session"+session);
		System.out.println("getId : "+session.getId());
		System.out.println("isNew : "+session.isNew());
		System.out.println("getCreationTime : "+new java.util.Date(session.getCreationTime()).toString());
		System.out.println("getLastAccessedTime : "+new java.util.Date(session.getLastAccessedTime()).toString());
		System.out.println("getMaxInactiveInterval : "+session.getMaxInactiveInterval());
//		response.setHeader("Set-Cookie", "JSESSIONID="+session.getId() +";"+ "SameSite=None");
//		response.setHeader("Set-Cookie", "Test1=TestCookieValue1; Secure; SameSite=None");
//		response.setHeader("Set-Cookie", "Test1=TestCookieValue2; Secure; SameSite=None");
//		response.setHeader("Set-Cookie", "Test1=TestCookieValue3; Secure; SameSite=None");
//		System.out.println("CsrfToken"+(CsrfToken)request.getAttribute("_csrf"));
//		CsrfToken token = (CsrfToken)request.getAttribute("_csrf");
//		String _csrf = token.getToken();
//		HttpSecurity http = null;
//		http.csrf().disable();
		String cd = "0000";
        String msg = "";
//        System.out.println("model"+model);
//        System.out.println("request"+request.getParameter("_csrf"));
        
//        session.setAttribute("CSRF_TOKEN", UUID.randomUUID().toString());
//        System.out.println("send"+session.getAttribute("CSRF_TOKEN"));
//		model.addAttribute("_csrf", session.getAttribute("CSRF_TOKEN"));
//		CsrfToken _csrf = (CsrfToken) session.getAttribute("_csrf");
//		System.out.println("_csrf"+_csrf);
        
     // 변수 -------------------------------------------------------------------------------------------------------------
        String rec_cert		= "";           // 결과수신DATA

    	String k_certNum = "";			    // 파라미터로 수신한 요청번호
    	String certNum		= "";			// 요청번호
        String date			= "";			// 요청일시
    	String CI	    	= "";			// 연계정보(CI)
    	String DI	    	= "";			// 중복가입확인정보(DI)
        String phoneNo		= "";			// 휴대폰번호
    	String phoneCorp	= "";			// 이동통신사
    	String birthDay		= "";			// 생년월일
    	String gender		= "";			// 성별
    	String nation		= "";			// 내국인
    	String name			= "";			// 성명
    	String M_name		= "";			// 미성년자 성명
    	String M_birthDay	= "";			// 미성년자 생년월일
    	String M_Gender		= "";			// 미성년자 성별
    	String M_nation		= "";			// 미성년자 내외국인
        String result		= "";			// 결과값

        String certMet		= "";			// 인증방법
        String ip			= "";			// ip주소
    	String plusInfo		= "";

    	String encPara		= "";
    	String encMsg1		= ""; 
    	String encMsg2		= "";
    	String msgChk       = "";
        //-----------------------------------------------------------------------------------------------------------------
//        System.out.println("1"+request.getParameter("rec_cert"));
		
    	if(null != request.getParameter("rec_cert")) {
    		rec_cert = request.getParameter("rec_cert").trim();
    	}
    	
    	if(null != request.getParameter("certNum")) {
    		k_certNum = request.getParameter("certNum").trim();
    	}
        
        try{
        	
        	//01. 암호화 모듈 (jar) Loading
            com.icert.comm.secu.IcertSecuManager seed = new com.icert.comm.secu.IcertSecuManager();

            //02. 1차 복호화
            //수신된 certNum를 이용하여 복호화
            rec_cert  = seed.getDec(rec_cert, k_certNum);

            //03. 1차 파싱
            int inf1 = rec_cert.indexOf("/",0);
            int inf2 = rec_cert.indexOf("/",inf1+1);

            encPara  = rec_cert.substring(0,inf1);         //암호화된 통합 파라미터
            encMsg1  = rec_cert.substring(inf1+1,inf2);    //암호화된 통합 파라미터의 Hash값

    		//04. 위변조 검증
            encMsg2 = seed.getMsg(encPara);
            if(encMsg2.equals(encMsg1)) msgChk = "Y";
    		
            if(msgChk.equals("N")){
            	msg = "비정상적인 접근입니다.!!";
            	model.addAttribute("msg", msg);
    			return "/example/kmcis_result";
            }
            
            //05. 2차 복호화
    		rec_cert  = seed.getDec(encPara, k_certNum);

            //06. 2차 파싱
            int info1  = rec_cert.indexOf("/",0);
            int info2  = rec_cert.indexOf("/",info1+1);
            int info3  = rec_cert.indexOf("/",info2+1);
            int info4  = rec_cert.indexOf("/",info3+1);
            int info5  = rec_cert.indexOf("/",info4+1);
            int info6  = rec_cert.indexOf("/",info5+1);
            int info7  = rec_cert.indexOf("/",info6+1);
            int info8  = rec_cert.indexOf("/",info7+1);
    		int info9  = rec_cert.indexOf("/",info8+1);
    		int info10 = rec_cert.indexOf("/",info9+1);
    		int info11 = rec_cert.indexOf("/",info10+1);
    		int info12 = rec_cert.indexOf("/",info11+1);
    		int info13 = rec_cert.indexOf("/",info12+1);
    		int info14 = rec_cert.indexOf("/",info13+1);
    		int info15 = rec_cert.indexOf("/",info14+1);
    		int info16 = rec_cert.indexOf("/",info15+1);
    		int info17 = rec_cert.indexOf("/",info16+1);
    		int info18 = rec_cert.indexOf("/",info17+1);

            certNum		= rec_cert.substring(0,info1);
            date		= rec_cert.substring(info1+1,info2);
            CI			= rec_cert.substring(info2+1,info3);
            phoneNo		= rec_cert.substring(info3+1,info4);
            phoneCorp	= rec_cert.substring(info4+1,info5);
            birthDay	= rec_cert.substring(info5+1,info6);
            gender		= rec_cert.substring(info6+1,info7);
            nation		= rec_cert.substring(info7+1,info8);
    		name		= rec_cert.substring(info8+1,info9);
    		result		= rec_cert.substring(info9+1,info10);
    		certMet		= rec_cert.substring(info10+1,info11);
    		ip			= rec_cert.substring(info11+1,info12);
    		M_name		= rec_cert.substring(info12+1,info13);
    		M_birthDay	= rec_cert.substring(info13+1,info14);
    		M_Gender	= rec_cert.substring(info14+1,info15);
    		M_nation	= rec_cert.substring(info15+1,info16);
    		plusInfo	= rec_cert.substring(info16+1,info17);
    		DI      	= rec_cert.substring(info17+1,info18);

            //07. CI, DI 복호화
            CI  = seed.getDec(CI, k_certNum);
            DI  = seed.getDec(DI, k_certNum);
    		
            /******************************** 수신내역 유효성 검증 ***************************/
//        	현재 서버 시각 구하기
    		SimpleDateFormat formatter	= new SimpleDateFormat("yyyyMMddHHmmss",Locale.KOREAN);
    		String strCurrentTime	= formatter.format(new Date());
    		
    		Date toDate				= formatter.parse(strCurrentTime);
    		Date fromDate			= formatter.parse(date);
    		long timediff			= toDate.getTime()-fromDate.getTime();
//    		System.out.println("2"+rec_cert);
    		//csrf 토큰값이 변경됨.. 재설정 처리필요
//    		CsrfToken token = (CsrfToken)request.getAttribute("_csrf");
//    		model.addAttribute("_csrf", token.getToken());
    		/*
    		if ( timediff < -30*60*1000 || 30*60*100 < timediff  ){
				msg = "비정상적인 접근입니다. (요청시간경과)";
				model.addAttribute("msg", msg);
    			return "/example/kmcis_result";
			}
	
			//	1-1-2) ip 값 검증
			// 사용자IP 구하기
			String client_ip = request.getHeader("HTTP_X_FORWARDED_FOR");
			if ( client_ip != null ){
				if( client_ip.indexOf(",") != -1 )
					client_ip = client_ip.substring(0,client_ip.indexOf(","));
			}
			if ( client_ip==null || client_ip.length()==0 ){
				client_ip = request.getRemoteAddr();
			}
	
			if( !client_ip.equals(ip) ){
				msg = "비정상적인 접근입니다. (IP불일치)";
				model.addAttribute("msg", msg);
    			return "/example/kmcis_result";
			}
            /********************************수신내역 유효성 검증 ***************************/
            
			model.addAttribute("msg", "");
			model.addAttribute("encMsg1", encMsg1);	//위,변조여부1
			model.addAttribute("encMsg2", encMsg2);	//위,변조여부2
			model.addAttribute("certNum", certNum);	//요청번호
			model.addAttribute("date", date);			//요청일시
			model.addAttribute("CI", CI);				//연계정보(CI)
			model.addAttribute("DI", DI);				//중복가입확인정보(DI)
			model.addAttribute("phoneNo", phoneNo);		//휴대폰번호
			model.addAttribute("phoneCorp", phoneCorp);	//이동통신사
			
			model.addAttribute("birthDay", birthDay);	//생년월일
			model.addAttribute("nation", nation);		//내국인
			model.addAttribute("gender", gender);		//성별
			model.addAttribute("name", name);			//성명
			model.addAttribute("certMet", certMet);		//인증방법
			model.addAttribute("ip", ip);				//ip주소
			model.addAttribute("M_name", M_name);		//미성년자 성명
			model.addAttribute("M_birthDay", M_birthDay);	//미성년자 생년월일
			model.addAttribute("M_nation", M_nation);		//미성년자 내외국인
			model.addAttribute("plusInfo", plusInfo);		//plusInfo
			model.addAttribute("rec_cert", rec_cert);			//결과 수신데이타
			
			model.addAttribute("result", result);			//인증 결과 값 ( ▪“Y” : 성공 ▪ “N” : 실패 ▪ “F” : 오류 )
//			//csrf 토큰값이 변경됨.. 재설정 처리필요
//			CsrfToken token = (CsrfToken)request.getAttribute("_csrf");
//			String _csrf = token.getToken();
//			model.addAttribute("_csrf", _csrf);
//			System.out.println("885 : "+_csrf);
            
        }catch (IOException io) {
        	io.getMessage();
        }catch (SQLException sq) {
        	sq.getMessage();
        }catch (NullPointerException nu){
        	nu.getMessage();
        }catch(Exception e){
        	/*e.printStackTrace();*/
        	//취약점점검 6316 기원우 
        	msg = "[KMCIS] Receive Error -" + e.getMessage();
        	model.addAttribute("msg", msg);
//        	/*model.addAttribute("msg", msg);*/
        }
		
		return "/kmcis_result";
	}
	
	/**
	 * 사업자번호 확인
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00852012_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce00852012_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce0085201Service.epce00852012_select(data)).toString();
	}

	/**
	 * 아이디 중복체크
	 * @param param
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00852013_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce00852013_check(@RequestParam HashMap<String, String> param, ModelMap model, HttpServletRequest request) {
		String ableYn = epce0160131Service.epce0160131_2_check(param);
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("USE_ABLE_YN", ableYn);
		
		return util.mapToJson(map).toString();
	}
	
	/**
	 * 아이디, 휴대번호 중복체크
	 * @param param
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00852015_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce00852015_check(@RequestParam HashMap<String, String> param, ModelMap model, HttpServletRequest request) {
		
		String ableYn = epce0160131Service.epce0160131_2_check(param); //아이디
		String ableYn2 = epce0160131Service.epce0160131_4_check(param); //휴대번호
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("USE_ABLE_YN", ableYn);
		map.put("USE_ABLE_YN2", ableYn2);
		
		return util.mapToJson(map).toString();
	}
	
	/**
	 * 예금주명 확인API
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00852013_192.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce00852013_check2(@RequestParam HashMap<String, String> map, ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		String domain = request.getServerName();

		String BANK_CD = map.get("BANK_CD");
		String ACCT_NO = map.get("SEARCH_ACCT_NO");
		map.put("ACCT_NO", map.get("SEARCH_ACCT_NO"));
		
		HashMap<String, String> rtnMap = new HashMap<String, String>();
		
		if(BANK_CD == null || BANK_CD.equals("")){
			rtnMap.put("RSLT_CD", "0001");
			rtnMap.put("RSLT_MSG", "은행코드가 입력되지 않았습니다.");
			return util.mapToJson(rtnMap).toString();
		}
		
		if(ACCT_NO == null || ACCT_NO.equals("")){
			rtnMap.put("RSLT_CD", "0001");
			rtnMap.put("RSLT_MSG", "계좌번호가 입력되지 않았습니다.");
			return util.mapToJson(rtnMap).toString();
		}

		// CMS 예금주 조회 api 호출
		HashMap<String, String> param = new HashMap<String, String>();
		List<HashMap<String, String>> list = new ArrayList<HashMap<String,String>>();
		list.add(map);
		
		param.put("list", util.mapToJson(list).toString());
		
		Map<String, String> data = CMSCS002Controller.acctNmCheck(param, request);
		Map<String, String> result = (Map<String, String>) JSONArray.fromObject(data.get("RESULT_OBJECT")).get(0);
		
		// 기존 포맷에 맞게 변경
		JSONObject acctNm = new JSONObject();
		acctNm.put("ACCT_NM", result.get("ACCT_DPSTR_NM"));

		JSONArray array = new JSONArray();
		array.add(acctNm);
		
		JSONObject obj = new JSONObject();
		obj.put("RESP_DATA", array);
		obj.put("RSLT_CD", result.get("RESULT_CODE"));
		obj.put("RSLT_MSG", result.get("RESULT_MSG"));
		
		return obj.toString();
	}
	
	
	@Value("#{LINKHUB_CONFIG.CorpNum}")
	private String corpNum;
	
	@Autowired
	private CloseDownService closedownService;
	
	/**
	 * 정보 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00852013_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	
	public String epce00852013_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		String state = "";
		
		try{
			//크로스 추가
//			MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
			MultipartHttpServletRequest mptRequest = WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
			String BIZRNO = mptRequest.getParameter("BIZRNO1") + mptRequest.getParameter("BIZRNO2") + mptRequest.getParameter("BIZRNO3");
			
			try{
				CorpState corpState = closedownService.CheckCorpNum(corpNum, BIZRNO);
				if(corpState != null){
					state = corpState.getState();
				}
			}catch (IOException io) {
				io.getMessage();
			}catch (SQLException sq) {
				sq.getMessage();
			}catch (NullPointerException nu){
				nu.getMessage();
			}catch(Exception e){
				//errMsg = e.getMessage();
				state = "";
			}
			
			errCd = epce0085201Service.epce00852013_insert(request, state);
			
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 업무담당자 정보 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/EP/EPCE00852015_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce00852015_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce0085201Service.epce00852015_insert(request);
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
}
