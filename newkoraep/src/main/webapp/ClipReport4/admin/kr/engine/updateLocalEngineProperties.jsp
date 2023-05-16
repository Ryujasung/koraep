<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String update = (String) request.getParameter("Update");
	String isEachReport = (String) request.getAttribute("isEachReport");
	String reportFolderPath = (String) request.getAttribute("reportFolderPath");
	String fontFolderPath = (String) request.getAttribute("fontFolderPath");
	String defaultFontFile = (String) request.getAttribute("defaultFontFile");
	String isSystemFont = (String) request.getAttribute("isSystemFont");
	String isConsoleLog = (String) request.getAttribute("isConsoleLog");
	String isDBLog = (String) request.getAttribute("isDBLog");
	String logDBFilePath = (String) request.getAttribute("logDBFilePath");
	String isLogInfo = (String) request.getAttribute("isLogInfo");
	String isLogWarning = (String) request.getAttribute("isLogWarning");
	String isLogError = (String) request.getAttribute("isLogError");
	String isLogDebug = (String) request.getAttribute("isLogDebug");
	
	if (isDBLog.equals("false")) {
		logDBFilePath = "";
	}
%>

<div class="container">
	<div class="page-header">
		<h3>로컬엔진 기본설정 페이지</h3>
	</div>
	<div style="width:100%; height:100%; margin:0px auto;">
		<div class="row">
			<div class="span12">
				<form class="form" action="index.jsp" method="post">
					<input type="hidden" name="ClipID" value="L152">
					
					<div class="control-group">
						<p><strong>EachReport : </strong>리포트를 개별적으로 폴더를 생성하여 만들것인지를 결정합니다.</p>
						<% if (isEachReport.equals("true")) { %>
							<label class="checkbox"> <input type="checkbox" name="isEachReport" checked> EachReport </label>
						<% } else { %>
							<label class="checkbox"> <input type="checkbox" name="isEachReport" > EachReport </label>
						<% } %>
					</div>
					
					<div class="control-group" style="padding-top: 10px;">
						<p><strong>ReportFolderPath : </strong>리포트JSON 파일이 저장될 경로를 뜻합니다.</p>
						<div class="controls">
							<input type="text" class="input-xxlarge" id="reportFolderPath" name="reportFolderPath" disabled value="<%=reportFolderPath%>">
						</div>
						
						<p><strong>FontFolderPath : </strong>폰트들을 관리할 폴더경로를 뜻합니다.</p>
						<div class="controls">
							<input type="text" class="input-xxlarge" id="fontFolderPath" name="fontFolderPath" disabled value="<%=fontFolderPath%>">
						</div>
						
						<p><strong>DefaultFontFile : </strong>디자이너에서 사용된 폰트가 현재 서버에 없을경우 대체되는 기본폰트입니다.</p>
						<div class="controls">
							<input type="text" class="input-xxlarge" id="defaultFontFile" name="defaultFontFile" disabled value="<%=defaultFontFile%>">
						</div>
						
						<p><strong>SystemFont : </strong>SystemFont를 사용할것인지를 결정합니다.</p>
						<% if (isSystemFont.equals("true")) { %>
							<label class="checkbox"> <input type="checkbox" name="isSystemFont" checked> SystemFont </label>
						<% } else { %>
							<label class="checkbox"> <input type="checkbox" name="isSystemFont" > SystemFont </label>
						<% } %>
					</div>
					
					<div class="control-group" style="padding-top: 10px;">
						<p><strong>Console : </strong>Was Console에 로그를 출력합니다, <strong>DB : </strong>DB 파일에 로그를 기록하여 리포트 로그페이지에서 볼수 있습니다.. </p>
						<% if (isConsoleLog.equals("true")) { %>
							<label class="checkbox inline"> <input type="checkbox" name="isConsoleLog" checked> Console </label>
						<% } else { %>
							<label class="checkbox inline"> <input type="checkbox" name="isConsoleLog" > Console </label>
						<% } %>
					
						<% if (isDBLog.equals("true")) { %>
							<label class="checkbox inline"> <input type="checkbox" name="isDBLog" checked> DB </label>
						<% } else { %>
							<label class="checkbox inline"> <input type="checkbox" name="isDBLog" >  DB  </label>
						<% } %> 
					</div>
					
					<div class="control-group" style="padding-top: 10px;">
						<p><strong>LogFilePath : </strong>DB 에 로그를 쌓아서 볼경우 경로를 설정해주세요.</p>
						<div class="controls">
							<input type="text" class="input-xxlarge" id="logFilePath" 	name="logDBFilePath" placeholder="LogFilePath" value="<%=logDBFilePath%>">
						</div>
					</div>
				 				
					<div class="control-group" style="padding-top: 10px;">
						<p><strong>LogType : </strong>필요에 따라 로그타입을 설정하여 볼수 있습니다.</p>
						<% if (isLogInfo.equals("true")) { %>
							<label class="checkbox inline"> <input type="checkbox" name="isLogInfo" checked> Info </label>
						<% } else { %>
						 	<label class="checkbox inline"> <input type="checkbox" name="isLogInfo" > Info </label>
						<% } %>
							
						<% if (isLogWarning.equals("true")) { %>
							<label class="checkbox inline"> <input type="checkbox" name="isLogWarning" checked> Warning </label>
						<% } else { %>
							<label class="checkbox inline"> <input type="checkbox" name="isLogWarning" > Warning </label>
						<% } %>
						
						<% if (isLogError.equals("true")) { %>
							<label class="checkbox inline"> <input type="checkbox" name="isLogError" checked> Error </label>
						<% } else { %>
							<label class="checkbox inline"> <input type="checkbox" name="isLogError" > Error </label>
						<% } %>
							
						<% if (isLogDebug.equals("true")) { %>
							<label class="checkbox inline"> <input type="checkbox" name="isLogDebug" checked> Debug </label>
						<% } else { %>
							<label class="checkbox inline"> <input type="checkbox" name="isLogDebug" > Debug </label>
						<% } %>
					</div>
					<div class="control-group" style="padding-top: 10px;">
						<button type="submit" class="btn btn-primary"><i class="icon-edit icon-white"></i> 설정</button>
					</div>
					</form>
				</div>
		</div> 
	</div>
</div>
<script type="text/javascript">
	<% if (update != null && update.equals("false")) { %>
			alert("로그파일 경로가 잘못되었습니다. 다시 설정해주세요.")
	<% } else %>
</script>

