<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String dbName = (String) request.getAttribute("dbName");
	String jndiName = (String) request.getAttribute("jndiName");
	String encoding = (String) request.getAttribute("encoding");
%>
<script type="text/javascript">
	function updateJNDIDataConnection(form) {
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
		<h3>로컬엔진 JNDI 커넥션수정 페이지</h3>
	</div>
	<div style="width:1200px; margin:0px auto;">
		<form class="form-horizontal" action="index.jsp" method="post">
			<input type="hidden" name="ClipID" value="L154">
			<input type="hidden" name="dbName" value="<%=dbName%>">
			<div class="control-group">
			    <label class="control-label">Database Name</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" disabled value="<%=dbName%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">JNDI Name</label>
			    <div class="controls">
			      <input type="text" class="input-xxlarge" name="jndiName" placeholder="JNDI Name" value="<%=jndiName%>">
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
			      	<button type="button" class="btn btn-primary" onclick="updateJNDIDataConnection(this.form)">확인</button>
			      	<a class="btn" type="button" href="index.jsp?ClipID=L103">취소</a>
			    </div>
			</div>

		</form>
	</div>
</div>