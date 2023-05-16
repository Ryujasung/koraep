<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String engineName = (null == request.getParameter("engineName")) ? "" : (String) request.getParameter("engineName");
	String enginePath = (null == request.getParameter("enginePath")) ? "" : (String) request.getParameter("enginePath");
	String portNumber = (null == request.getParameter("portNumber")) ? "" : (String) request.getParameter("portNumber");
	String reportPath = (null == request.getParameter("reportPath")) ? "" : (String) request.getParameter("reportPath");
	String fontPath = (null == request.getParameter("fontPath")) ? "" : (String) request.getParameter("fontPath");
	
	if (reportPath == null || reportPath.equals("null")) {
		reportPath = "";
	} 
	if (fontPath == null || fontPath.equals("null")) {
		fontPath = "";
	}
	
	String status = (String) request.getParameter("status");
	if (status == null) {
		status = "true";
	}
	
	engineName = engineName.replaceAll("\0", "").replaceAll("\\\\r", "").replaceAll("\\\\n", "").replaceAll("\\\\t", "");
	enginePath = enginePath.replaceAll("\0", "").replaceAll("\\\\r", "").replaceAll("\\\\n", "").replaceAll("\\\\t", "");
	portNumber = portNumber.replaceAll("\0", "").replaceAll("\\\\r", "").replaceAll("\\\\n", "").replaceAll("\\\\t", "");
	reportPath = reportPath.replaceAll("\0", "").replaceAll("\\\\r", "").replaceAll("\\\\n", "").replaceAll("\\\\t", "");
	fontPath = fontPath.replaceAll("\0", "").replaceAll("\\\\r", "").replaceAll("\\\\n", "").replaceAll("\\\\t", "");

%>

<script type="text/javascript">
	function updateEnginePathConfigInfo(form) {
		if (!form.reportPath.value) {
			alert("리포트경로를 적어주세요");
			form.reportPath.focus();
			return;
		}

		if (!form.fontPath.value) {
			alert("폰트경로를 적어주세요");
			form.fontPath.focus();
			return;
		}
		form.submit();
	}
</script>
<div>
	<div style="width: 100%; margin:0px auto;">
		<form class="form-horizontal" action="index.clip" method="post">
			<input type="hidden" name="ClipID" value="M151">
			<input type="hidden" name="name" value="<%= engineName %>">
			<div class="control-group">
				<label class="control-label" for="inputName">이름</label>
			    	<div class="controls">
						<input id="disabledInput" type="text" disabled value="<%=engineName%>">
					</div>
			</div> <!-- Name -->
			
			<div class="control-group">
				<label class="control-label" for="inputPath">주소</label>
			    	<div class="controls">
						<input id="disabledInput" type="text" disabled value="<%=enginePath%>">
					</div>
			</div> <!-- Path -->
			
			<div class="control-group">
				<label class="control-label" for="inputPortNumber">포트번호</label>
				 <div class="controls">
						<input id="disabledInput" type="text" disabled value="<%=portNumber%>">
					</div>
			</div> <!-- PortNumber -->
			
			<div class="control-group">
				<label class="control-label" for="inputPortNumber">리포트폴더경로</label>
				<div class="controls">
					<input type="text" id="inputPortNumber" name="reportPath" placeholder="ReportPath" value="<%= reportPath %>">
				</div>
			</div> <!-- ReportPath -->
			  
			<div class="control-group">
				<label class="control-label" for="inputPortNumber">폰트폴더경로</label>
				<div class="controls">
					<input type="text" id="inputPortNumber" name="fontPath" placeholder="FontPath" value="<%= fontPath %>">
				</div>
			</div> <!-- FontPath -->
			  
			<div class="control-group">
				<div class="controls">
					<button type="submit" class="btn btn-primary">설정</button>
				</div>
			</div> <!-- Control Group Button -->
		</form> <!-- Form -->
		<label>폴더 경로는 서버내의 로컬 경로로 설정합니다.</label> 
		<label><strong>Windows</strong> C:\\ClipReport\\Document\\</label> 
		<label><strong>Linux</strong> /Home/UserID/ClipReport/Font</label>
	</div>
</div>
<% if (status.equals("false")) { %>
	<script type="text/javascript">
		window.alert("파일 경로를 잘못 입력하셨습니다.");
	</script>
<% } %>