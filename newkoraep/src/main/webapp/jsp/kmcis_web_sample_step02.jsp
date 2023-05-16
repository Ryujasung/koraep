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
    //tr_cert ������ ���� ���� ---------------------------------------------------------------
// 	String tr_cert       = "";
//     String cpId          = request.getParameter("cpId");        // ȸ����ID
//     String urlCode       = request.getParameter("urlCode");     // URL�ڵ�
//     String certNum       = request.getParameter("certNum");     // ��û��ȣ
//     String date          = request.getParameter("date");        // ��û�Ͻ�
//     String certMet       = request.getParameter("certMet");     // �����������
//     String name          = request.getParameter("name");        // ����
//     String phoneNo	     = request.getParameter("phoneNo");	    // �޴�����ȣ
//     String phoneCorp     = request.getParameter("phoneCorp");   // �̵���Ż�
// 	if(phoneCorp == null) phoneCorp = "";
// 	String birthDay	     = request.getParameter("birthDay");	// �������
// 	String gender	     = request.getParameter("gender");		// ����
// 	if(gender == null) gender = "";
//     String nation        = request.getParameter("nation");      // ���ܱ��� ����
// 	String plusInfo      = request.getParameter("plusInfo");	// �߰�DATA����
// 	String extendVar     = "0000000000000000";                  // Ȯ�庯��
	
//����
	 //��¥ ����
        Calendar today = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String day = sdf.format(today.getTime());
      	//��������� 3080 ������
        /* java.util.Random ran = new Random(); */
		Random ran = SecureRandom.getInstance("SHAIPRNG");
        //���� ���� ����
        int numLength = 6;
        String randomStr = "";

        for (int i = 0; i < numLength; i++) {
            //0 ~ 9 ���� ���� ����
            randomStr += ran.nextInt(10);
        }

		//reqNum�� �ִ� 40byte ���� ��� ����
        String reqNum = day + randomStr;
     	String tr_cert       = "";
	  String cpId          = "COSM1001";        // ȸ����ID
	    String urlCode       = "011002";     // URL�ڵ�
	    String certNum       = reqNum;     // ��û��ȣ
	    String date          = day;        // ��û�Ͻ�
	    String certMet       = "M";     // �����������
	    String name          = "";        // ����
	    String phoneNo	     = "";	    // �޴�����ȣ
	    String phoneCorp     = "";   // �̵���Ż�
		if(phoneCorp == null) phoneCorp = "";
		String birthDay	     = "";	// �������
		String gender	     = "";		// ����
		if(gender == null) gender = "";
	    String nation        = "";      // ���ܱ��� ����
		String plusInfo      = "";	// �߰�DATA����
		String extendVar     = "0000000000000000";                  // Ȯ�庯��
		//��
    //End-tr_cert ������ ���� ���� ---------------------------------------------------------------
// String tr_url = request.getScheme() + "://" + request.getServerName() +":" +request.getServerPort() +"/EP/EPCE00852885.do?_csrf="+param.get("_csrf");
String tr_url = request.getScheme() + "://" + request.getServerName() +":" +request.getServerPort() +"/EP/EPCE00852885.do";
// 	String tr_url     = request.getParameter("tr_url");         // ������������ ������� POPUP URL

	/** certNum ���ǻ��� **************************************************************************************
	* 1. �������� ����� ��ȣȭ�� ���� Ű�� Ȱ��ǹǷ� �߿���.
	* 2. �������� ��û�� �ߺ����� �ʰ� �����ؾ���. (��-��������ȣ)
	* 3. certNum���� �������� ����� ���� �� ��ȣȭŰ�� �����.
	       tr_url���� certNum���� �����ؼ� �����ϰ�, (tr_url = tr_url + "?certNum=" + certNum;)
		   tr_url���� ������Ʈ�� ���·� certNum���� ������ ��. (certNum = request.getParameter("certNum"); )
	*
	***********************************************************************************************************/

    //01. �ѱ����������(��) ��ȣȭ ��� ����
   com.icert.comm.secu.IcertSecuManager seed  = new com.icert.comm.secu.IcertSecuManager();

	//02. 1�� ��ȣȭ (tr_cert �����ͺ��� ���� �� ��ȣȭ)
	String enc_tr_cert = "";
	tr_cert            = cpId +"/"+ urlCode +"/"+ certNum +"/"+ date +"/"+ certMet +"/"+ birthDay +"/"+ gender +"/"+ name +"/"+ phoneNo +"/"+ phoneCorp +"/"+ nation +"/"+ plusInfo +"/"+ extendVar;
	enc_tr_cert        = seed.getEnc(tr_cert, "");

	//03. 1�� ��ȣȭ �����Ϳ� ���� ������ ������ ���� (HMAC)
	String hmacMsg = "";
	hmacMsg = seed.getMsg(enc_tr_cert);

	//04. 2�� ��ȣȭ (1�� ��ȣȭ ������, HMAC ������, extendVar ���� �� ��ȣȭ)
	tr_cert  = seed.getEnc(enc_tr_cert + "/" + hmacMsg + "/" + extendVar, "");
%>

<html>
<head>
<title>������������ Sample ȭ��</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<style>
<!--
   body,p,ol,ul,td
   {
	 font-family: ����;
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
    /* ����� ���� üũ*/
    // ������� ��� (�������� ������� �߰� �ʿ�)
    if (UserAgent.match(/iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i) != null || UserAgent.match(/LG|SAMSUNG|Samsung/) != null) {
   		 document.reqKMCISForm.target = '';
	  } 
	  
	  // ������� �ƴ� ���
	  else {
   		KMCIS_window = window.open('', 'KMCISWindow', 'width=425, height=550, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=435, top=250' );
   		
   		if(KMCIS_window == null){
  			alert(" �� ������ XP SP2 �Ǵ� ���ͳ� �ͽ��÷η� 7 ������� ��쿡�� \n    ȭ�� ��ܿ� �ִ� �˾� ���� �˸����� Ŭ���Ͽ� �˾��� ����� �ֽñ� �ٶ��ϴ�. \n\n�� MSN,����,���� �˾� ���� ���ٰ� ��ġ�� ��� �˾������ ���ֽñ� �ٶ��ϴ�.");
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
<span class="style1">������������ ��ûȭ�� Sample�Դϴ�.</span><br>
<br><br>
<table cellpadding=1 cellspacing=1>
    <tr>
        <td align=center>ȸ����ID</td>
        <td align=left><%=cpId%></td>
    </tr>
    <tr>
        <td align=center>URL�ڵ�</td>
        <td align=left><%=urlCode%></td>
    </tr>
    <tr>
        <td align=center>��û��ȣ</td>
        <td align=left><%=certNum%></td>
    </tr>
    <tr>
        <td align=center>��û�Ͻ�</td>
        <td align=left><%=date%></td>
    </tr>
    <tr>
        <td align=center>�����������</td>
        <td align=left><%=certMet%></td>
        </td>
    </tr>
    <tr>
        <td align=center>�̿��ڼ���</td>
        <td align=left><%=name%></td>
    </tr>
    <tr>
        <td align=center>�޴�����ȣ</td>
        <td align=left><%=phoneNo%></td>
    </tr>
    <tr>
        <td align=center>�̵���Ż�</td>
        <td align=left><%=phoneCorp%></td>
    </tr>
    <tr>
        <td align=center>�������</td>
		<td align=left><%=birthDay%></td>
    </tr>
	<tr>
        <td align=center>�̿��ڼ���</td>
        <td align=left><%=gender%></td>
    </tr>
    <tr>
        <td align=center>���ܱ���</td>
        <td align=left><%=nation%></td>
    </tr>
    <tr>
        <td align=center>�߰�DATA����</td>
        <td align=left><%=plusInfo%></td>
        </td>
    </tr>
    <tr>
        <td align=center>&nbsp</td>
        <td align=left>&nbsp</td>
    </tr>
    <tr width=100>
        <td align=center>��û����(��ȣȭ)</td>
        <td align=left>
            <%=tr_cert.substring(0,50)%>...
        </td>
    </tr>
    <tr>
        <td align=center>�������URL</td>
        <td align=left><%=tr_url%></td>
    </tr>
</table>

<!-- ������������ ��û form --------------------------->
<form name="reqKMCISForm" method="post" action="#">
    <input type="hidden" name="tr_cert"     value = "<%=tr_cert%>">
    <input type="hidden" name="tr_url"      value = "<%=tr_url%>">
    <input type="submit" value="������������ ��û"  onclick= "javascript:openKMCISWindow();">
</form>
<BR>
<BR>
<!--End ������������ ��û form ----------------------->

<br>
<br>
  �� Sampleȭ���� ������������ ��ûȭ�� ���߽� ���� �ǵ��� �����ϰ� �ִ� ȭ���Դϴ�.<br>
<br>
</center>
</BODY>
</HTML>