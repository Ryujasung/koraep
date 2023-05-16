<%@ page language="java" import="java.io.*,java.util.*,java.text.*,crosscert.*" %>
<%@ page contentType = "text/html; charset=utf-8" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!--!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"-->
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
		
		<title></title>
		<!-- 전자인증 모듈 설정 //-->
		<link rel="stylesheet" type="text/css" href="../CC_WSTD_home/unisignweb/rsrc/css/certcommon.css?v=1" />
		<script type="text/javascript" src="../CC_WSTD_home/unisignweb/js/unisignwebclient.js?v=1"></script>
		<script type="text/javascript" src="./UniSignWeb_Multi_Init_Nim.js?v=1"></script>
		<!-- 전자인증 모듈 설정 //-->
		<script>								
			
			function SignData() 
			{
				
				if (document.frm.plainText.value == "")
				{
					alert("서명할 원문이 없습니다.");
					return;
				}
				
				unisign.SignData( document.frm.plainText.value, null, 
					function(signedText)
					{ 
						document.frm.signedText.value = signedText;
						
						if ( null == signedText || '' == signedText )
						{
							unisign.GetLastError(
								function(errCode, errMsg) 
								{ 
									alert('Error code : ' + errCode + '\n\nError Msg : ' + errMsg); 
								}
							);
						} 
					} 
				);
			}
			
			/*
			function SignVerify() 
			{
				
				
				var plainText = unisign.VerifySignData( document.frm.signedText.value );
				if ( plainText ) 
				{
					alert( '전자서명문 검증에 성공하였습니다.\n\n원문 [ ' + plainText + ' ]' ); 
				} 
				else 
				{
					alert( '전자서명문 검증에 실패하였습니다.' );
					
					unisign.GetLastError(
						function(errCode, errMsg) 
						{ 
							alert('Error code : ' + errCode + '\n\nError Msg : ' + errMsg); 
						}
					); 
				}
			}
			*/

			function Send()
			{
				if (document.frm.signedText.value == "")
				{
					alert("전자서명값이 없습니다.");
				}
				document.frm.method = "post";
				document.frm.action = "verifySignData.jsp";
				document.frm.submit();
			
			}
		</script>
	</head>
	<body>
		<h3><font color="red">  hidden  처리 대상 : 원문, 전자서명값</font></h3><br>
		form 속성에 onsubmit="return false" 을 설정해야 함 <br>
		<form name="frm" onsubmit="return false">
		<table cellpadding="0" cellspacing="0" width="100%"  align = "center">
			<tr>
				<td align = "center">
					
					<textarea name="plainText" rows="5" cols="40">abcdefghijklmnopqrstuvwxyz1234567890~!@#$%^&amp;*()</textarea> 
					<br>
					<input type = "button" value = "전자서명(인증서선택)" onclick="javascript:SignData();" >
					
				</td>
				
				<td align = "center">
					
					<textarea name="signedText" rows="5" cols="40"></textarea>
					<br><input type=button value="전송(verifySignData.jsp)" onclick="Send();">	
					
						
				</td>
			</tr>
		</table>
		
		</form>
	</body>
</html>

