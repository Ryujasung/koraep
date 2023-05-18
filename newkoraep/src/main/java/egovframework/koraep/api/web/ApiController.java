/**
 * 
 */
package egovframework.koraep.api.web;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
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

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;







import com.clipsoft.org.json.simple.parser.JSONParser;

import egovframework.common.util;
import egovframework.koraep.api.service.ApiService;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE9000601Mapper;

/**
 * @author Administrator
 *
 */
@Controller
public class ApiController {

	
	@Resource(name="apiService")
	private ApiService apiService;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	

	@Resource(name="epce9000601Mapper")
	private EPCE9000601Mapper epce9000601Mapper;  //반환관리 Mapper

	
	/**
	 * http json data 수신
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/api/recvJsonData.do")
	public void recvJsonData(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		Map<String, String> data =  new HashMap<String, String>();
		Map<String, String> hist =  new HashMap<String, String>();
		
		JSONObject rtnObj = new JSONObject();
		String errCd = "";
		BufferedReader dis = null;
		
		int seq = 0;
		
		try{
			/*
			System.out.println("/api/recvJsonData.do!@!@!@!@");
			//대기
			for(int i=0;i<60;i++){
				Thread.sleep(10000);
				System.out.println("############# i : "+i);
			}			
			System.out.println("/api/recvJsonData.do END !@!@!@!@");
			*/
			
			StringBuffer sb = new StringBuffer();
	        String str = "";
	        dis = new BufferedReader( new InputStreamReader( request.getInputStream() ) );

	        while( (str = dis.readLine()) !=null) {      
            	sb.append(URLDecoder.decode(str, "utf-8"));
            }

	        data = JSONObject.fromObject(sb.toString());

	        seq = apiService.regSnSeq();

	        hist.put("REG_DT", util.getShortDateString());
	        hist.put("REG_SN", String.valueOf(seq));
	        hist.put("REG_TM", util.getShortTimeString());
	        hist.put("PRAM"  , sb.toString());
	        
	        data.put("REG_SN", String.valueOf(seq));

	        errCd = apiService.regApiDtlHist(request, hist);
	        
	        //데이터 처리
	        errCd = apiService.recvJsonData(request, data);
			System.out.println("errCd"+errCd);
		}catch (IOException io) {
        	io.printStackTrace();
        }catch (SQLException sq) {
        	sq.printStackTrace();
        }catch (NullPointerException nu){
        	nu.printStackTrace();
        }catch(Exception e){

			e.printStackTrace();

			errCd = e.getMessage();
			if(errCd.indexOf("Could not open JDBC Connection") > - 1){
				errCd = "B013";
			}else if(errCd.length() > 4){
				errCd = "B999";
			}
		}finally{
	        hist.put("ANSR_RST", errCd);
	        hist.put("ANSR_TM",  util.getShortTimeString());

	        apiService.updateApiDtlHist(request, hist);

			if(dis != null) dis.close();
		}
		
		data.put("REG_SN", String.valueOf(seq));
		
		//API param 데이터
		request.setAttribute("PRAM", data);
		
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "B", errCd)); //B : API
		rtnObj.put("RSLT_DT", util.getShortDateString());
		rtnObj.put("RSLT_TKTM", util.getShortTimeString());
	        
		String rslt =  URLEncoder.encode(rtnObj.toString(), "utf-8");
		
		response.setContentType("application/text");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		out.print(rslt);
		out.flush();
		out.close();
    }
	
	//사용안함?
	/*@RequestMapping(value="/api/searchData.do")*/
	public void searchData(HttpServletRequest request, HttpServletResponse response) throws Exception {

		JSONObject rtnObj = new JSONObject();
		String errCd = "";
		try{
			errCd = "0000";
			JSONArray rslt = apiService.searchData(request);
			rtnObj.put("RSLT_LST", rslt);
		}catch (IOException io) {
        	io.printStackTrace();
        }catch (SQLException sq) {
        	sq.printStackTrace();
        }catch (NullPointerException nu){
        	nu.printStackTrace();
        }catch(Exception e){
			errCd = e.getMessage();
			rtnObj.put("RSLT_LST", "[]");
		}
		
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "B", errCd));
		rtnObj.put("RSLT_DT", util.getShortDateString());
		rtnObj.put("RSLT_TKTM", util.getShortTimeString());
		
		String rslt =  URLEncoder.encode(rtnObj.toString(), "utf-8");
		
		response.setContentType("application/text");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		out.print(rslt);
		out.flush();
		out.close();
    }
	/**
	 * http json data 수신
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/api/recvJsonTest.do")
	public void recvJsonTest(HttpServletRequest request, HttpServletResponse response) throws Exception  {
	/*RestTemplate restTemplate = new RestTemplate(); 

	HttpHeaders headers = new HttpHeaders(); 
	headers.setContentType(MediaType.APPLICATION_JSON);//JSON 변환 
//	headers.set("Authorization", appKey); //appKey 설정 ,KakaoAK kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk 이 형식 준수

	HttpEntity entity = new HttpEntity("parameters", headers); 
//	URI url=URI.create(apiURL); 
	//x -> x좌표, y -> y좌표 
	System.out.println("########3@@@@@@");
	ResponseEntity response= restTemplate.exchange(url, HttpMethod.GET, entity, String.class);
	//String 타입으로 받아오면 JSON 객체 형식으로 넘어옴
	System.out.println("########4@@@@@@");
	JSONParser jsonParser = new JSONParser(); 
	JSONObject jsonObject = (JSONObject) jsonParser.parse(response.getBody().toString());
	//저는 Body 부분만 사용할거라 getBody 후 JSON 타입을 인자로 넘겨주었습니다
	//헤더도 필요하면 getBody()는 사용할 필요가 없음
	
	//JSONParser jsonParser = new JSONParser();
	JSONArray docuArray = (JSONArray) jsonObject.get("documents");
	//documents만 뽑아오고  
	System.out.println("########5@@@@@@"+docuArray.size());
	for(int i = 0 ; docuArray.size() > i ; i++){
		JSONObject docuObject = (JSONObject) docuArray.get(i); 
		//배열 i번째 요소 불러오고
		         
//		logger.info(docuObject.get("contents").toString());
		//뽑아오기 원하는 Key 이름을 넣어주면 그 value가 반환된다.
		System.out.println("########6@@@@@@"+docuObject.get("contents").toString().substring(1, 10));
		String tmp = docuObject.get("contents").toString().substring(1, 10);
		
		
		//회수량보증금 단가로 회수용기코드 추출
		int rtn_gtn = 10000;
		int rtn_qty = 100;
		int result = rtn_gtn/rtn_qty;
		String cpct_cd = "";
		if(result == 70){
			cpct_cd = "13";
		}else if(result == 100){
			cpct_cd = "23";
		}else if(result == 130){
			cpct_cd = "33";
		}else if(result == 350){
			cpct_cd = "43";
		}
		
		
		Map<String, String> map = new HashMap<String, String>();
		map.put("SERIAL_NO", tmp);
		//톰라api로 받아온 데이터입력
		epce9000601Mapper.tomra_data_insert(map);
	}*/
	//=========================================
	
	//==================json 데이터로 테스트start=======================
	System.out.println("########json 데이터로 테스트start@@@@@@");
	JSONParser parser = new JSONParser();
	Object obj = null;
	FileReader fileReader = new FileReader("C:/Temp/TOMRA-Testdata.json");
	try {
		
		System.out.println("########1@@@@@@");
		obj = parser.parse(fileReader);
		System.out.println(obj);
		com.orsoncharts.util.json.JSONObject jo = (com.orsoncharts.util.json.JSONObject) obj;
		System.out.println(jo);
		com.orsoncharts.util.json.JSONArray docuArray = (com.orsoncharts.util.json.JSONArray) jo.get("data");
		System.out.println(docuArray);
		//System.out.println(jo.get("JDBCDriver"));
		
		System.out.println("########5@@@@@@"+ docuArray.size());
		for(int i = 0 ; docuArray.size() > i ; i++){
			Map<String, String> map = new HashMap<String, String>();
			
			com.orsoncharts.util.json.JSONObject docuObject = (com.orsoncharts.util.json.JSONObject) docuArray.get(i); 
			//배열 i번째 요소 불러오고
			System.out.println("########44@@@@@@"+ docuObject.get("machine"));
			//JSONArray docuArray3 = (JSONArray) docuObject.get("machine");
			//JSONObject docuObject3 = (JSONObject) docuArray3.get(0); 
			System.out.println("########444serial@@@@@@"+ ((Map) docuObject.get("machine")).get("serial"));
			map.put("SERIAL_NO", (String) ((Map) docuObject.get("machine")).get("serial"));
			com.orsoncharts.util.json.JSONArray docuArray2 = (com.orsoncharts.util.json.JSONArray) docuObject.get("items");
			System.out.println("########55@@@@@@"+ docuArray2.size());
			if(docuArray2.size() > 1){
				for(int x = 0 ; docuArray2.size() > x ; x++){
					com.orsoncharts.util.json.JSONObject docuObject2 = (com.orsoncharts.util.json.JSONObject) docuArray2.get(i); 
					System.out.println("########77@@@@@@"+ docuObject2.get("barcode"));
					System.out.println("########88@@@@@@"+ docuObject2.get("reject"));
					map.put("BARCODE_NO", (String) docuObject2.get("barcode"));
					map.put("RTN_GTN", (String) docuObject2.get("reject"));
					epce9000601Mapper.tomra_data_insert(map);
				}
			}else{
				System.out.println("########99@@@@@@"+docuArray2.get(0));
				com.orsoncharts.util.json.JSONObject docuObject3 = (com.orsoncharts.util.json.JSONObject) docuArray2.get(0); 
				System.out.println("########10@@@@@@"+ docuObject3.get("barcode"));
				map.put("BARCODE_NO", (String) docuObject3.get("barcode"));
				map.put("RTN_GTN", (String)  docuObject3.get("reject"));
				epce9000601Mapper.tomra_data_insert(map);
			}
			//logger.info(docuObject.get("serial").toString());
			//뽑아오기 원하는 Key 이름을 넣어주면 그 value가 반환된다.
			//System.out.println("########6@@@@@@"+docuObject.get("serial"));
		}
		
		fileReader.close();
	} catch (FileNotFoundException e1) {
		// TODO Auto-generated catch block
		e1.printStackTrace();
	} catch (IOException e1) {
		// TODO Auto-generated catch block
		e1.printStackTrace();
	} 
	}
	/**
	 * http json data 수신
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/api/urmJsonData.do")
	public void urmJsonData(HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		Map<String, String> data =  new HashMap<String, String>();
		Map<String, String> hist =  new HashMap<String, String>();
		
		JSONObject rtnObj = new JSONObject();
		String errCd = "";
		BufferedReader dis = null;
		
		int seq = 0;
		
		try{
			
			/*테스트 코드*/
			
			/*StringBuffer sb = new StringBuffer();
	        String str = "";
	        dis = new BufferedReader( new InputStreamReader( request.getInputStream() ) );

	        while( (str = dis.readLine()) !=null) {      
            	sb.append(URLDecoder.decode(str, "utf-8"));
            }
			JSONArray jsonArr = JSONArray.fromObject(sb.toString());
			JSONObject jsonObj = null;
			if(jsonArr.size() > 0){
				for(int i = 0; i<jsonArr.size(); i++){
					jsonObj = jsonArr.getJSONObject(i);
					
				}
				System.out.println(jsonObj);
				
			}
			data = JSONObject.fromObject(jsonObj);*/

			/*정상코드*/	        
			StringBuffer sb = new StringBuffer();
	        String str = "";
	        dis = new BufferedReader( new InputStreamReader( request.getInputStream() ) );

	        while( (str = dis.readLine()) !=null) {      
            	sb.append(URLDecoder.decode(str, "utf-8"));
            }

	        data = JSONObject.fromObject(sb.toString());

	        seq = apiService.urmRegSnSeq();

	        hist.put("REG_DT", util.getShortDateString());
	        hist.put("REG_SN", String.valueOf(seq));
	        hist.put("REG_TM", util.getShortTimeString());
	        hist.put("PRAM"  , sb.toString());
	        hist.put("ACSS_IP", request.getRemoteAddr());
	        hist.put("CALL_URL", request.getRequestURL().toString());
	        data.put("REG_SN", String.valueOf(seq));
	        errCd = apiService.regUrmHist(request, hist);
	        
	        //데이터 처리
	        errCd = apiService.urmJsonData(request, data);
		}catch (IOException io) {
        	io.printStackTrace();
        }catch (SQLException sq) {
        	sq.printStackTrace();
        }catch (NullPointerException nu){
        	nu.printStackTrace();
        }catch(Exception e){

			e.printStackTrace();
			
			errCd = e.getMessage();
			if(errCd.indexOf("Could not open JDBC Connection") > - 1){
				errCd = "B013";
			}else if(errCd.length() > 4){
				errCd = "B999";
			}
		}finally{
			if(errCd == "0000"){
				hist.put("ANSR_RST", errCd);
				hist.put("ERR_YN", "N");
			}else{
				hist.put("ANSR_RST", errCd);
				hist.put("ERR_YN", "Y");
			}
	        System.out.println("hist = "+hist);
	        System.out.println("request = "+request);

	        apiService.updateUrmHist(request, hist);

			if(dis != null) dis.close();
		}
		
		data.put("REG_SN", String.valueOf(seq));
		
		//API param 데이터
		request.setAttribute("PRAM", data);
		
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "B", errCd)); //B : API
		rtnObj.put("RSLT_DT", util.getShortDateString());
		rtnObj.put("RSLT_TKTM", util.getShortTimeString());
	        
		String rslt =  URLEncoder.encode(rtnObj.toString(), "utf-8");
		
		response.setContentType("application/text");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		out.print(rslt);
		out.flush();
		out.close();
	}
	
	/**
	 * 본인인증 요청폼 화면 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/API/EPCE00852883.do")
	public String popKmcisForm(@RequestParam HashMap<String, String> param, ModelMap model, HttpServletRequest request) throws Exception{
//		HttpSecurity http = null;
//		http.csrf().disable();
		
		HttpSession session = request.getSession(); 
		System.out.println("session"+session);
		CsrfToken token = (CsrfToken)request.getAttribute(CsrfToken.class.getName());
//		String _csrf = token.getToken();
//		String _csrf_header = token.getParameterName();
//		System.out.println("_csrf : "+_csrf);
//		System.out.println("_csrf_header : "+_csrf_header);
//		System.out.println("token.getToken() : "+token.getToken());
//		System.out.println("token.getParameterName() : "+token.getParameterName());
		//csrf 토큰값이 변경됨.. 재설정 처리필요
		
		Enumeration params = request.getParameterNames();
		System.out.println("----------------------------");
		while (params.hasMoreElements()){
		    String name = (String)params.nextElement();
		    System.out.println(name + " : " +request.getParameter(name));
		}
		System.out.println("----------------------------");
		 
			Calendar today = Calendar.getInstance();		//날짜 생성
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
	        String day = sdf.format(today.getTime());
//	        System.out.println("param"+param);
//	        System.out.println("model"+model);
//	        System.out.println("request"+request.getParameter("CERT_DIV"));
	        //취약점점검 3089 류제성
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
//	        String urlCode = "004004";//개발서버
	        String urlCode = "011002";//테스트서버
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
	        String tr_url = request.getScheme() + "://" + request.getServerName() +":" +request.getServerPort() +"/API/EPCE00852885.do?_csrf="+param.get("_csrf")+ "&certNum=" + certNum;
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
			System.out.println("rtn"+ rtn);
//			System.out.println("883 : "+_csrf);
//			return "/kmcis_web_sample_step02";
			return "/kmcis_form";
	}
	
	
	/**
	 * 본인인증 결과
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/API/EPCE00852885.do")
	public String kmcStep03( ModelMap model, HttpServletRequest request,HttpSession session) throws Exception {
		System.out.println("result");
		session = request.getSession(); 
//		System.out.println("session"+session);
//		System.out.println("session"+session.toString());
		Enumeration params = request.getParameterNames();
		System.out.println("----------------------------");
		while (params.hasMoreElements()){
		    String name = (String)params.nextElement();
		    System.out.println(name + " : " +request.getParameter(name));
		}
		System.out.println("----------------------------");
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
        	io.printStackTrace();
        }catch (SQLException sq) {
        	sq.printStackTrace();
        }catch (NullPointerException nu){
        	nu.printStackTrace();
        }catch(Exception e){
        	e.printStackTrace();
        	msg = "[KMCIS] Receive Error -" + e.getMessage();
        	model.addAttribute("msg", msg);
//        	/*model.addAttribute("msg", msg);*/
        }
		
		return "/kmcis_result";
	}
}
