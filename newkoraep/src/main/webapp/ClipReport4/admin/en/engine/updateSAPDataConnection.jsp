<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.clipsoft.clipreport.server.service.admin.serviceconfig.util.ParameterConverter" %>
<%
	String dbName = (String) request.getAttribute("dbName");
	String encoding = (String) request.getAttribute("encoding");
	String client = (String) request.getAttribute("client");
	String user = (String) request.getAttribute("user");
	String password = (String) request.getAttribute("password");
	String language = (String) request.getAttribute("language");
	String hostName = (String) request.getAttribute("hostName");
	String systemNumber = (String) request.getAttribute("systemNumber");
	String group = (String) request.getAttribute("group");
	String gateway = (String) request.getAttribute("gateway");
%>
<script type="text/javascript">
	function updateSAPDataConnection(form) {
		if (!form.user.value) {
			alert("Please enter the User.");
			form.user.focus();
			return;
		}

		if (!form.password.value) {
			alert("Please enter the Password.");
			form.password.focus();
			return;
		}
		form.submit();
	}
</script>
<div class="container">
	<div class="page-header">
		<h3>Changing the local engine SAP connection page</h3>
	</div>
	<div style="width:1200px; margin:0px auto;">
		<form class="form-horizontal" action="index.jsp" method="post">
			<input type="hidden" name="ClipID" value="L155">
			<input type="hidden" name="dbName" value="<%=dbName%>">
			<div class="control-group">
			    <label class="control-label">Database Name</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" id="dbName" name="dbName" disabled value="<%=dbName%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">Client</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" id="client" name="client" disabled value="<%=client%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">User</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" id="user" name="user" placeholder="User" value="<%=user%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">Password</label>
			    <div class="controls">
			      <input type="password" class="input-xxlarge" id="password" name="password" maxlength="15" placeholder="Password" value="<%=password%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">Language</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" id="language" name="language" disabled value="<%=language%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">HostName</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" id="hostName" name="hostName" disabled value="<%=hostName%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">SystemNumber</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" id="systemNumber" name="systemNumber" disabled value="<%=systemNumber%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">Group</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" id="group" name="group" disabled value="<%=group%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">Gateway</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" id="gateway" name="gateway" disabled value="<%=gateway%>">
			    </div>
			</div>
			  
			<div class="control-group">
			    <div class="controls">
			      	<button type="button" class="btn btn-primary" onclick="updateSAPDataConnection(this.form)">OK</button>
			      	<a class="btn" type="button" href="index.jsp?ClipID=L103">Cancel</a>
			    </div>
			</div>
		</form>
	</div>
</div>
