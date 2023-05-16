<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.clipsoft.clipreport.server.service.admin.serviceconfig.*" %>
<%
	String language = ServiceConfigManager.getInstance().getLanguage(request);
	
	String theMessage1 = "";
	String theMessage2 = "";
	String theMessage3 = "";
	
	if (language.equalsIgnoreCase("KR")) {
		theMessage1 = "비밀번호가 틀렸습니다.";
		theMessage2 = "다시 입력해주세요";
		theMessage3 = "패스워드를 입력하세요.";
	} else if (language.equalsIgnoreCase("EN")) {
		theMessage1 = "Password was wrong";
		theMessage2 = "Please re-enter";
		theMessage3 = "Please enter your password";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8;"> 
	<link rel="shortcut icon" type="image/x-icon" href="../ico/favicon.ico">

	<!-- BootStrap -->
	<link href="../css/admin/bootstrap.css" rel="stylesheet" media="screen">
	<!-- <link href="../css/admin/bootstrap.min.css" rel="stylesheet" media="screen">  -->
	<link href="../css/admin/bootstrap-responsive.css" rel="stylesheet" media="screen">
	<!-- <link href="../css/admin/bootstrap-responsive.min.css" rel="stylesheet" media="screen">  -->
	
	<title>CLIP report Server Admin Console</title>
	
	<script type="text/javascript">
		function beginLogin() {
			document.loginForm.password.focus();
		}
		
		function login(form) {
			if (!form.password.value) {
				alert(form.confirmMessage.value);
				return;
			}
			form.submit();
		}
	</script>
	
	<style>
		.loginContainer {
			margin: 80px auto;
			width: 640px;
		}
		
		.login {
			position: relative;
			margin: 0 auto;
			padding: 20px 20px 20px;
			width: 310px;
			background: white;
			border-radius: 3px;
			-webkit-box-shadow: 0 0 200px rgba(255, 255, 255, 0.5), 0 1px 2px
				rgba(0, 0, 0, 0.3);
			box-shadow: 0 0 200px rgba(255, 255, 255, 0.5), 0 1px 2px
				rgba(0, 0, 0, 0.3);
		}
		
		.login:before {
			content: '';
			position: absolute;
			top: -8px;
			right: -8px;
			bottom: -8px;
			left: -8px;
			z-index: -1;
			background: rgba(0, 0, 0, 0.08);
			border-radius: 4px;
		}
		
		.login h1 {
			margin: -20px -20px 21px;
			line-height: 40px;
			font-size: 15px;
			font-weight: bold;
			color: #555;
			text-align: center;
			text-shadow: 0 1px white;
			background: #f3f3f3;
			border-bottom: 1px solid #cfcfcf;
			border-radius: 3px 3px 0 0;
			background-image: -webkit-linear-gradient(top, whiteffd, #eef2f5);
			background-image: -moz-linear-gradient(top, whiteffd, #eef2f5);
			background-image: -o-linear-gradient(top, whiteffd, #eef2f5);
			background-image: linear-gradient(to bottom, whiteffd, #eef2f5);
			-webkit-box-shadow: 0 1px whitesmoke;
			box-shadow: 0 1px whitesmoke;
		}
		
		.login p {
			margin: 20px 0 0;
		}
		
		.login p:first-child {
			margin-top: 0;
		}
		
		.login input[type=text], .login input[type=password] {
			width: 278px;
		}
		
		.login p.remember_me {
			float: left;
			line-height: 31px;
		}
		
		.login p.remember_me label {
			font-size: 12px;
			color: #777;
			cursor: pointer;
		}
		
		.login p.remember_me input {
			position: relative;
			bottom: 1px;
			margin-right: 4px;
			vertical-align: middle;
		}
		
		.login button.button {
			text-align: right;
			padding-top: 20px;
		}
</style>		
</head>

<body onload="beginLogin()">
	<div class="loginContainer">
		<div class="login">
			<h1>CLIP report Server Admin Console</h1>
			<form name="loginForm" action=index.jsp method="post">
				<input type="hidden" name="ClipID" value="A01"/>
				<input type="hidden" name="confirmMessage" value="<%=theMessage3%>"/>
				<a href="http://www.clipsoft.co.kr" target="_blank"><img src="../img/admin/clipsoft_ci_300_2.gif"></a>
				<input style="margin-top: 20px;" type="password" name="password" id="password" maxlength="15" placeholder="Server Admin Password" />
				
				<div style="padding-top:20px; padding-bottom:20px;">
				<% String isLogin = request.getParameter("isLogin"); %>
				<% if (null != isLogin && isLogin.equals("false")) { %>
					<div align="center"> 	<%=theMessage1%> <br><%=theMessage2%> </div>
				<% } else { %>
					<div><br><br></div>
				<% } %>
				</div>
				
				<div class="control-group" style="padding-right: 20px;"  align="right">
					<button type="button" class="btn btn-primary" onclick="login(this.form)">Login</button>
				</div>
				<p>Copyright CLIPSOFT Corp. All Rights Reserved.</p>
			</form>
		</div>
	</div>
   
  	<!-- Le javascript
    ================================================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	<script src="../js/jquery-1.11.1.js"></script>
	<script src="../js/admin/bootstrap.js"></script>
</body>
</html>