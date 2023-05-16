<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String pageFile = request.getParameter("page");
	request.getSession().setAttribute("clipreport_page", pageFile);
	if (pageFile == null || pageFile.equals("null")) {
		pageFile = "./main/home";
	}
	pageFile += ".jsp";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="shortcut icon" type="image/x-icon" href="../ico/favicon.ico">
<!-- BootStrap -->
<link href="../css/admin/bootstrap.css" rel="stylesheet" media="screen">
<!-- <link href="../css/admin/bootstrap.min.css" rel="stylesheet" media="screen"> -->
<link href="../css/admin/bootstrap-responsive.css" rel="stylesheet" media="screen">
<!-- <link href="../css/admin/bootstrap-responsive.min.css" rel="stylesheet" media="screen"> -->

<title>CLIP report Server Admin Console</title>
<style>
html, body {
	height: 100%;
	overflow-y: auto;
}

ul.nav li.dropdown:hover>ul.dropdown-menu {
	display: block;
	margin: 0;
}

#container {
	width: 1200px;
	padding-left:20px;
	padding-right: 20px;
	margin: 0px auto;
	/* border: 1px solid #bcbcbc; */
}

.background {
	
}

#header {
	padding-left:20px;
	padding-right: 20px;
	margin-bottom: 20px;
	/* border: 1px solid #bcbcbc; */
}

#content {
	width: 1150px;
	height: 750px;
	padding-left:20px;
	padding-right: 20px;
	margin-bottom: 20px;
	float: left;
	/* border: 1px solid #bcbcbc; */
}

#content_home {
	margin:70px auto;
	width:50%;
	height:100%;
	
	background-image: url(../img/admin/CLIPreport.png);
	background-size:100%;
	
	background-repeat:no-repeat;
	color: #FFFFFF;
	vertical-align: text-bottom;
}

#footer {
	clear: both;
	padding: 20px;
	background-color:#EFEFEF;
	/* border: 1px solid #bcbcbc; */
}
</style>
</head>
<body data-spy="scroll" data-target="bs-docs-sidebar" data-twttr-rendered="true">
	<div id="container" class="background">
		<div id="header" class="background">
			<%@include file="./main/language.jsp" %> 
			<%@include file="./main/header.jsp" %>
			<%@include file="./main/navigation.jsp" %>
		</div>
		<div id="content" class="background">
			<jsp:include page="<%=pageFile%>"></jsp:include>
		</div>
		<div id="footer" class="background">
			<%@include file="./main/footer.jsp" %>
		</div>
	</div> <!-- /container -->
	
	<script src="../js/admin/jquery-1.11.1.js"></script>
	<script src="../js/admin/bootstrap.js"></script>
	<!-- <script src="../js/admin/bootstrap.min.js"></script> -->
</body>
</html>