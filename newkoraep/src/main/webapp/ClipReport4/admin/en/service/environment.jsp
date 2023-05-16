<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="	com.clipsoft.clipreport.server.service.admin.serviceconfig.ServiceConfigManager"%>
<%
	String engineMotionType = (String) request.getAttribute("engineMotionType");
%>

<div class="container">
	<div class="page-header"> 
		<h3>Service Settings page</h3>
	</div>
	<div style="width: 1200px; margin: 0px auto;">
		<div>
			<form class="form-horizontal" action="index.jsp" method="post">
				<div class="controls">
					<input type="hidden" name="ClipID" value="E151">
					<p> Option of engine operating mode </p>
					
					<% if (engineMotionType.equals("Local")) { %>	
				    	<label class="radio"><input type="radio" name="engineMotionType" value="Local" checked> Local Engine </label>
				    	<label class="radio"><input type="radio" name="engineMotionType" value="Remote"> Remote Engine </label>
					<% } else { %>
						<label class="radio"><input type="radio" name="engineMotionType" value="Local" > Local Engine 	</label>
						<label class="radio"><input type="radio" name="engineMotionType" value="Remote" checked> Remote Engine </label>
					<% } %>
					<button type="submit" class="btn btn-primary">Setting</button>
			    </div> <!-- div controls -->
			</form> <!-- Form -->
		</div>
	</div>
</div> <!-- contatiner -->