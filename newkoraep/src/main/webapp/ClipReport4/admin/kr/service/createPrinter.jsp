<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.print.PrintService" %>
<%@ page import="com.clipsoft.clipreport.common.util.print.*" %>
<%@ page import="com.clipsoft.clipreport.server.service.admin.serviceconfig.util.ParameterConverter" %>
<%
	ArrayList<PrintService> printerList = PrintControl.getInstance().getPrintServiceList();
	String create = ParameterConverter.valueParameter(request.getParameter("Create"));
	String printerName = ParameterConverter.valueParameter((String)request.getAttribute("name"));
	String driver = ParameterConverter.valueParameter((String)request.getAttribute("driver"));
%>
<script>
	function addPrinter(form) {
		if (!form.printerName.value) {
			alert("프린터 이름을 입력하세요.");
			form.printerName.focus();
			return;
		}
		
		var driverList = document.getElementById("driverList");
		form.driverName.value = driverList.value;
		form.submit();
	}
</script>
<div class="container">
	<div class="page-header">
		<h3>새 프린터 추가 페이지</h3>
	</div>
	<div style="width:1200px; margin:0px auto;">
		<form style="padding-left:50px; padding-top:50px;" class="form-horizontal" action="index.jsp" method="post">
			<input type="hidden" name="ClipID" value="E51">
			<input type="hidden" name="driverName">
			
			<div class="control-group">
			    <label class="control-label">프린터 이름</label>
			    <div class="controls">
			      <input type="text" class="input-large" id="printerName" name="printerName" placeholder="Printer Name" value="<%=printerName%>">
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">드라이버 명</label>
			    <div class="controls">
			      <select id="driverList">
			      	<% int count = printerList.size(); for (int index = 0; index < count; index++) { %>
			      	<option><%= printerList.get(index).getName() %></option>
			      	<% } %>
			      </select>
			    </div>
			</div>
			  
			<div class="control-group">
			    <div class="controls">
			      	<button type="button" class="btn btn-primary" onclick="addPrinter(this.form)">확인</button>
			      	<a class="btn" type="button" href="index.jsp?ClipID=E102">취소</a>
			    </div>
			</div>
			  
		</form>
	</div>
</div>
<script type="text/javascript">
	<% if (create != null && create.equals("false")) { %>
		alert("같은 이름의 프린터를 추가하실수 없습니다.");
	<% } %>
</script>