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
		<h3>The basic configuration of the local engine page</h3>
	</div>
	<div style="width:100%; height:100%; margin:0px auto;">
		<div class="row">
			<div class="span12">
				<form class="form" action="index.jsp" method="post">
					<input type="hidden" name="ClipID" value="L152">
					
					<div class="control-group">
						<p><strong>EachReport : </strong>The report creates a separate folder to determine whether to create.</p>
						<% if (isEachReport.equals("true")) { %>
							<label class="checkbox"> <input type="checkbox" name="isEachReport" checked> EachReport </label>
						<% } else { %>
							<label class="checkbox"> <input type="checkbox" name="isEachReport" > EachReport </label>
						<% } %>
					</div>
					
					<div class="control-group" style="padding-top: 10px;">
						<p><strong>ReportFolderPath : </strong>It means the path to the report JSON file is saved.</p>
						<div class="controls">
							<input type="text" class="input-xxlarge" id="reportFolderPath" name="reportFolderPath" disabled value="<%=reportFolderPath%>">
						</div>
						
						<p><strong>FontFolderPath : </strong>It means the path to the folder where you want to manage fonts.</p>
						<div class="controls">
							<input type="text" class="input-xxlarge" id="fontFolderPath" name="fontFolderPath" disabled value="<%=fontFolderPath%>">
						</div>
						
						<p><strong>DefaultFontFile : </strong>Font that was used in the designer is , if it does not exist in the current server , the default font to be replaced .</p>
						<div class="controls">
							<input type="text" class="input-xxlarge" id="defaultFontFile" name="defaultFontFile" disabled value="<%=defaultFontFile%>">
						</div>
						
						<p><strong>SystemFont : </strong>SystemFont use</p>
						<% if (isSystemFont.equals("true")) { %>
							<label class="checkbox"> <input type="checkbox" name="isSystemFont" checked> SystemFont </label>
						<% } else { %>
							<label class="checkbox"> <input type="checkbox" name="isSystemFont" > SystemFont </label>
						<% } %>
					</div>
					
					
					<div class="control-group" style="padding-top: 10px;">
						<p><strong>Console : </strong>Was Console me will output a log, <strong>DB : </strong>Record the log in DB file , you will be seen in the report log page.</p>
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
						<p><strong>LogFilePath : </strong>If you want to display loaded with logs to DB, please set the path.</p>
						<div class="controls">
							<input type="text" class="input-xxlarge" id="logFilePath" 	name="logDBFilePath" placeholder="LogFilePath" value="<%=logDBFilePath%>">
						</div>
					</div>
				 				
				 	<div class="control-group" style="padding-top: 10px;">
				 		<p><strong>LogType : </strong>If necessary , you can be displayed by setting the log type.</p>
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
						<button type="submit" class="btn btn-primary"><i class="icon-edit icon-white"></i> Setting</button>
					</div>					
				</form>
			</div>
		</div> 
	</div>
</div>
<script type="text/javascript">
	<% if (update != null && update.equals("false")) { %>
			alert("Please set again the path of the log file is wrong")
	<% } else %>
</script>

