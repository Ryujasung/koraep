<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.clipsoft.clipreport.server.service.admin.serviceconfig.util.ParameterConverter" %>
<%
	String create = ParameterConverter.valueParameter(request.getParameter("Create"));
	String dbName = ParameterConverter.valueParameter((String) request.getAttribute("dbName"));
	String jndiName = ParameterConverter.valueParameter((String) request.getAttribute("jndiName"));
	String encoding = ParameterConverter.valueParameter((String) request.getAttribute("encoding"));
%>
<script type="text/javascript">
	function addJNDIDataConnection(form) {
		if (!form.dbName.value) {
			alert("디비이름을 입력하세요.");
			form.dbName.focus();
			return;
		}
		
		if (!form.jndiName.value) {
			alert("JNDI 이름을 입력하세요.");
			form.jndiName.focus();
			return;
		}
		
		form.submit();
	}
</script>
<div class="container">
	<div class="page-header">
		<h3>로컬엔진 JNDI 커넥션추가 페이지</h3>
	</div>
	<div style="width:1200px; margin:0px auto;">
		<form style="padding-left:50px; padding-top:50px;" class="form-horizontal" action="index.jsp" method="post">
			<input type="hidden" name="ClipID" value="L54">
			<input type="hidden" name="dataConnectionType">
			
			<div class="control-group">
				<!-- <p><strong>Database Name : </strong>OOF에서 Connection Type이 Data일때 사용할 디비이름을 뜻합니다.</p> -->
			    <label class="control-label">Database Name</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" id="dbName" name="dbName" placeholder="Database Name" value="<%=dbName%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">JNDI Name</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" id="jndiName" name="jndiName" placeholder="JNDI Name" value="<%=jndiName%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">Encoding</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" id="encoding" name="encoding" placeholder="Encoding" value="<%=encoding%>">
			    </div>
			</div>
			  
			<div class="control-group">
			    <div class="controls">
			      	<button type="button" class="btn btn-primary" onclick="addJNDIDataConnection(this.form)">확인</button>
			      	<a class="btn" type="button" href="index.jsp?ClipID=L103">취소</a>
			    </div>
			</div>
			  
		</form>
	</div>
</div>
<script type="text/javascript">
	<% if (create != null && create.equals("false")) { %>
		alert("같은 이름의 커넥션을 추가하실수 없습니다.");
	<% } %>
</script>
