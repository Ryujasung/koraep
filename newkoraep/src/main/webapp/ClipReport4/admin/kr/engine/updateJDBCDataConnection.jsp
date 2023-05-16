<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String jdbcType = (String) request.getAttribute("jdbcType");
	String dbName = (String) request.getAttribute("dbName");
	String driver = (String) request.getAttribute("driver");
	String version = (String) request.getAttribute("version");
	String url = (String) request.getAttribute("url");
	String user = (String) request.getAttribute("user");
	String password = (String) request.getAttribute("password");
	String encoding = (String) request.getAttribute("encoding");
%>
<script type="text/javascript">
	function updateJDBCDataConnection(form) {
		if (!form.user.value) {
			alert("사용자 정보를 입력하세요.");
			form.user.focus();
			return;
		} 
		
		/* if (!form.password.value) {
			alert("새롭게 지정할 패스워드를 입력하세요.");
			form.password.focus();
			return;
		} */
		
		form.submit();
	}
</script>
<div class="container">
	<div class="page-header">
		<h3>로컬엔진 JDBC 커넥션수정 페이지</h3>
	</div>
	<div style="width:1200px; margin:0px auto;">
		<form class="form-horizontal" action="index.jsp" method="post">
			<input type="hidden" name="ClipID" value="L153">
			<input type="hidden" name="dbName" value="<%=dbName%>">
			<div class="control-group">
			    <label class="control-label">JDBC Type</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" disabled value="<%=jdbcType%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">Database Name</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" disabled value="<%=dbName%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">DBMS Version</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" disabled value="<%=version%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">Driver</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" disabled value="<%=driver%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">URL</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" disabled value="<%=url%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">User</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" name="user" placeholder="User" value="<%=user%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">Password</label>
			    <div class="controls">
			      <input type="password" class="input-xxlarge" name="password" maxlength="15" placeholder="Password" value="<%=password%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">Encoding</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" name="encoding" disabled value="<%=encoding%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <div class="controls">
			      	<button type="button" class="btn btn-primary" onclick="updateJDBCDataConnection(this.form)">확인</button>
			      	<a class="btn" type="button" href="index.jsp?ClipID=L103">취소</a>
			    </div>
			</div>

		</form>
	</div>
</div>