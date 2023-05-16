<%
    response.setHeader("Pragma", "no-cache" );
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma", "no-store");
    response.setHeader("Cache-Control", "no-cache" );
%>
<%@ page  contentType = "text/html;charset=ksc5601"%>
<%@ page import ="java.util.*,java.text.SimpleDateFormat"%>
<%@ page import = "java.util.*" %>
<%@ page import ="java.security.SecureRandom" %>
<%
    //tr_cert 데이터 변수 선언 ---------------------------------------------------------------
// 	String tr_cert       = "";
//     String cpId          = request.getParameter("cpId");        // 회원사ID
//     String urlCode       = request.getParameter("urlCode");     // URL코드
//     String certNum       = request.getParameter("certNum");     // 요청번호
//     String date          = request.getParameter("date");        // 요청일시
//     String certMet       = request.getParameter("certMet");     // 본인인증방법
//     String name          = request.getParameter("name");        // 성명
//     String phoneNo	     = request.getParameter("phoneNo");	    // 휴대폰번호
//     String phoneCorp     = request.getParameter("phoneCorp");   // 이동통신사
// 	if(phoneCorp == null) phoneCorp = "";
// 	String birthDay	     = request.getParameter("birthDay");	// 생년월일
// 	String gender	     = request.getParameter("gender");		// 성별
// 	if(gender == null) gender = "";
//     String nation        = request.getParameter("nation");      // 내외국인 구분
// 	String plusInfo      = request.getParameter("plusInfo");	// 추가DATA정보
// 	String extendVar     = "0000000000000000";                  // 확장변수
	
//시작
	 //날짜 생성
        Calendar today = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String day = sdf.format(today.getTime());
      	//취약점점검 3080 류제성
        /* java.util.Random ran = new Random(); */
		Random ran = SecureRandom.getInstance("SHAIPRNG");
        //랜덤 문자 길이
        int numLength = 6;
        String randomStr = "";

        for (int i = 0; i < numLength; i++) {
            //0 ~ 9 랜덤 숫자 생성
            randomStr += ran.nextInt(10);
        }

		//reqNum은 최대 40byte 까지 사용 가능
        String reqNum = day + randomStr;
     	String tr_cert       = "";
	  String cpId          = "COSM1001";        // 회원사ID
	    String urlCode       = "011002";     // URL코드
	    String certNum       = reqNum;     // 요청번호
	    String date          = day;        // 요청일시
	    String certMet       = "M";     // 본인인증방법
	    String name          = "";        // 성명
	    String phoneNo	     = "";	    // 휴대폰번호
	    String phoneCorp     = "";   // 이동통신사
		if(phoneCorp == null) phoneCorp = "";
		String birthDay	     = "";	// 생년월일
		String gender	     = "";		// 성별
		if(gender == null) gender = "";
	    String nation        = "";      // 내외국인 구분
		String plusInfo      = "";	// 추가DATA정보
		String extendVar     = "0000000000000000";                  // 확장변수
		//끝
    //End-tr_cert 데이터 변수 선언 ---------------------------------------------------------------
// String tr_url = request.getScheme() + "://" + request.getServerName() +":" +request.getServerPort() +"/EP/EPCE00852885.do?_csrf="+param.get("_csrf");
String tr_url = request.getScheme() + "://" + request.getServerName() +":" +request.getServerPort() +"/EP/EPCE00852885.do";
// 	String tr_url     = request.getParameter("tr_url");         // 본인인증서비스 결과수신 POPUP URL

	/** certNum 주의사항 **************************************************************************************
	* 1. 본인인증 결과값 복호화를 위한 키로 활용되므로 중요함.
	* 2. 본인인증 요청시 중복되지 않게 생성해야함. (예-시퀀스번호)
	* 3. certNum값은 본인인증 결과값 수신 후 복호화키로 사용함.
	       tr_url값에 certNum값을 포함해서 전송하고, (tr_url = tr_url + "?certNum=" + certNum;)
		   tr_url에서 쿼리스트링 형태로 certNum값을 받으면 됨. (certNum = request.getParameter("certNum"); )
	*
	***********************************************************************************************************/

    //01. 한국모바일인증(주) 암호화 모듈 선언
   com.icert.comm.secu.IcertSecuManager seed  = new com.icert.comm.secu.IcertSecuManager();

	//02. 1차 암호화 (tr_cert 데이터변수 조합 후 암호화)
	String enc_tr_cert = "";
	tr_cert            = cpId +"/"+ urlCode +"/"+ certNum +"/"+ date +"/"+ certMet +"/"+ birthDay +"/"+ gender +"/"+ name +"/"+ phoneNo +"/"+ phoneCorp +"/"+ nation +"/"+ plusInfo +"/"+ extendVar;
	enc_tr_cert        = seed.getEnc(tr_cert, "");

	//03. 1차 암호화 데이터에 대한 위변조 검증값 생성 (HMAC)
	String hmacMsg = "";
	hmacMsg = seed.getMsg(enc_tr_cert);

	//04. 2차 암호화 (1차 암호화 데이터, HMAC 데이터, extendVar 조합 후 암호화)
	tr_cert  = seed.getEnc(enc_tr_cert + "/" + hmacMsg + "/" + extendVar, "");
%>

<html>
<head>
<title>본인인증서비스 Sample 화면</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<style>
<!--
   body,p,ol,ul,td
   {
	 font-family: 굴림;
	 font-size: 12px;
   }

   a:link { size:9px;color:#000000;text-decoration: none; line-height: 12px}
   a:visited { size:9px;color:#555555;text-decoration: none; line-height: 12px}
   a:hover { color:#ff9900;text-decoration: none; line-height: 12px}

   .style1 {
		color: #6b902a;
		font-weight: bold;
	}
	.style2 {
	    color: #666666
	}
	.style3 {
		color: #3b5d00;
		font-weight: bold;
	}
-->
</style>

<script language=javascript>
<!--
   window.name = "kmcis_web_sample";
   
   var KMCIS_window;

   function openKMCISWindow(){    

    var UserAgent = navigator.userAgent;
    /* 모바일 접근 체크*/
    // 모바일일 경우 (변동사항 있을경우 추가 필요)
    if (UserAgent.match(/iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i) != null || UserAgent.match(/LG|SAMSUNG|Samsung/) != null) {
   		 document.reqKMCISForm.target = '';
	  } 
	  
	  // 모바일이 아닐 경우
	  else {
   		KMCIS_window = window.open('', 'KMCISWindow', 'width=425, height=550, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=435, top=250' );
   		
   		if(KMCIS_window == null){
  			alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 7 사용자일 경우에는 \n    화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
      }
   		
   		document.reqKMCISForm.target = 'KMCISWindow';
	  }
	  
	  document.reqKMCISForm.action = 'https://www.kmcert.com/kmcis/web/kmcisReq.jsp';
	  document.reqKMCISForm.submit();
  }

//-->
</script>

</head>

<body bgcolor="#FFFFFF" topmargin=0 leftmargin=0 marginheight=0 marginwidth=0>

<center>
<br><br><br><br><br><br>
<span class="style1">본인인증서비스 요청화면 Sample입니다.</span><br>
<br><br>
<table cellpadding=1 cellspacing=1>
    <tr>
        <td align=center>회원사ID</td>
        <td align=left><%=cpId%></td>
    </tr>
    <tr>
        <td align=center>URL코드</td>
        <td align=left><%=urlCode%></td>
    </tr>
    <tr>
        <td align=center>요청번호</td>
        <td align=left><%=certNum%></td>
    </tr>
    <tr>
        <td align=center>요청일시</td>
        <td align=left><%=date%></td>
    </tr>
    <tr>
        <td align=center>본인인증방법</td>
        <td align=left><%=certMet%></td>
        </td>
    </tr>
    <tr>
        <td align=center>이용자성명</td>
        <td align=left><%=name%></td>
    </tr>
    <tr>
        <td align=center>휴대폰번호</td>
        <td align=left><%=phoneNo%></td>
    </tr>
    <tr>
        <td align=center>이동통신사</td>
        <td align=left><%=phoneCorp%></td>
    </tr>
    <tr>
        <td align=center>생년월일</td>
		<td align=left><%=birthDay%></td>
    </tr>
	<tr>
        <td align=center>이용자성별</td>
        <td align=left><%=gender%></td>
    </tr>
    <tr>
        <td align=center>내외국인</td>
        <td align=left><%=nation%></td>
    </tr>
    <tr>
        <td align=center>추가DATA정보</td>
        <td align=left><%=plusInfo%></td>
        </td>
    </tr>
    <tr>
        <td align=center>&nbsp</td>
        <td align=left>&nbsp</td>
    </tr>
    <tr width=100>
        <td align=center>요청정보(암호화)</td>
        <td align=left>
            <%=tr_cert.substring(0,50)%>...
        </td>
    </tr>
    <tr>
        <td align=center>결과수신URL</td>
        <td align=left><%=tr_url%></td>
    </tr>
</table>

<!-- 본인인증서비스 요청 form --------------------------->
<form name="reqKMCISForm" method="post" action="#">
    <input type="hidden" name="tr_cert"     value = "<%=tr_cert%>">
    <input type="hidden" name="tr_url"      value = "<%=tr_url%>">
    <input type="submit" value="본인인증서비스 요청"  onclick= "javascript:openKMCISWindow();">
</form>
<BR>
<BR>
<!--End 본인인증서비스 요청 form ----------------------->

<br>
<br>
  이 Sample화면은 본인인증서비스 요청화면 개발시 참고가 되도록 제공하고 있는 화면입니다.<br>
<br>
</center>
</BODY>
</HTML>