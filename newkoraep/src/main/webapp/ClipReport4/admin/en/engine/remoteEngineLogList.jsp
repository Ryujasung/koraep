<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.clipsoft.clipreport.common.server.*" %>
<%@ page import="com.clipsoft.clipreport.common.server.beans.log.*" %>
<%@ page import="com.clipsoft.clipreport.server.service.admin.util.BootStrapUtil" %>
<%@ page import="com.clipsoft.clipreport.common.server.beans.engine.Engine" %>
<%
	String currentViewEngine = (String) request.getAttribute("name");
	ArrayList<Engine> engineList = (ArrayList<Engine>) request.getAttribute("engineList");
	ArrayList<ReportLog> reportLogList = (ArrayList<ReportLog>) request.getAttribute("reportLogList");
	int pageBlock = (Integer) request.getAttribute("pageBlock");
	int logPage = (Integer) request.getAttribute("logPage");
	int rowCount = (Integer) request.getAttribute("rowCount");
	int startRow = (Integer) request.getAttribute("startRow");
	int currentBlock = (Integer) request.getAttribute("currentBlock");
	int totalBlock = (Integer) request.getAttribute("totalBlock");
	int startPage = (Integer) request.getAttribute("startPage");
	int endPage = (Integer) request.getAttribute("endPage");
	int size = (Integer) request.getAttribute("size");
%>

<script type="text/javascript">
	function deleteEngineLog(form) {
		var selectItemList = document.getElementById("selectEngineList");
		form.name.value = selectItemList.value;
		form.submit();
	}
</script>

<div class="container">
	<div class="page-header">
		<h3>원격엔진서버 로그 페이지</h3>
		전체 리포트로그 개수 : <%= rowCount %>  
	</div>
	<div style="height:10px;"></div>
	
	<div style="width: 1200px; margin: 0px auto;">
		<div class="table-responsive">
			<div>
				<table class="table">
					<thead>
						<tr>
			        		<th colspan="6">
			        			<form class="form-inline" style="display:inline;" action="index.clip" method="post">
			        				<input type="hidden" name="ClipID" value="M202">
			        				<input type="hidden" name="name" >
									<button type="button" class="btn btn-link" onclick="deleteEngineLog(this.form)">전체삭제</button>
								</form>
								<form class="form-inline" style="display:inline;" action="index.clip" method="post">
									<!--  
									<script type="text/javascript">
										window.setTimeout("document.getElementById('UpdateLogForm').submit();", 5000);
									</script>
									-->
									<input type="hidden" name="ClipID" value="M158">
									<input type="hidden" name="pageBlock" value="<%= pageBlock %>">
									<input type="hidden" name="logPage" value="<%= logPage %>">
									<button type="submit" class="btn btn-link">업데이트</button>
								</form>
								<select style="float:right;" id="selectEngineList">
									<% int count = engineList.size(); if (count > 0) { for (Engine engine : engineList) {%>
									<option><%= engine.getName() %></option>
									<% } %>
								 	<% } else { %>
								 	<option>엔진이 없습니다.</option>
								 	<% } %>
								</select>								
			        		</th>
		        		</tr>
						<tr>
							<th width="5%" style="text-align:center; vertical-align: text-bottom;">번호</th>
				            <th width="15%" style="text-align:center; vertical-align: text-bottom;">날짜</th>
				            <th width="12%" style="text-align:center; vertical-align: text-bottom;">아이피</th>
				            <th width="12%" style="text-align:center; vertical-align: text-bottom;">리포트이름</th>
				            <th width="12%" style="text-align:center; vertical-align: text-bottom;">로그타입</th>
				            <th width="44%" style="text-align:center; vertical-align: text-bottom;">로그</th>
		        		</tr>
					</thead> <!-- Table Header -->
					<tbody>
			        	<% if (rowCount > 0) { startRow += 1; for (int i = 0; i < size; i++) { ReportLog reportLog = reportLogList.get(i); %>
			        	<% String logType = reportLog.getLogWriteType().toString(); %>
			        	<tr>
			        		<td width="5%" style="text-align:center"><%= startRow++ %></td>
				            <td width="15%" style="text-align:center"><%= reportLog.getDate() %></td>
				            <td width="12%" style="text-align:center"><%= reportLog.getIP() %></td>
				            <td width="12%" style="text-align:center"><%= reportLog.getReportFileName() %></td>
				            <td width="12%" style="text-align:center"><span style="width:100%;" class="label <%= BootStrapUtil.findLabelClass(logType) %>"><%= logType %></span></td>
				            <td width="44%" style="text-align:center"><%= reportLog.getLog() %></td>
						</tr>
						<% }} else { %>
						<tr class="warning">
							<td colspan="6" style="text-align:center">엔진서버에 로그정보가 존재하지 않습니다.</td>
						</tr>
						<% } %>
		        	</tbody> <!-- Table Body -->
				</table>
			</div>
			<div class="pagination pagination-centered">
				<ul>
					<% if (currentBlock < 1) { %>
						<li><a href="#">&laquo;</a></li>
					<% } else { %>
							<% if (pageBlock -1 < 1) { %>
								<li><a href="#">&laquo;</a></li>
							<% } else { %>
								<li><a href="index.clip?ClipID=M08&pageBlock=<%= pageBlock-1 %>&logPage=<%= startPage-1 %>">&laquo;</a></li>
							<% } %>
					<% } %>
					<% for (int pageIndex = startPage; pageIndex <= endPage; pageIndex++) { %>
						<% if (logPage == pageIndex) { %> 
							<li class="active"><a href="index.clip?ClipID=M08&pageBlock=<%= pageBlock %>&logPage=<%= pageIndex %>"><span><%= pageIndex %></span></a></li>
						<% }	else { %>
						<li><a href="index.clip?ClipID=M08&pageBlock=<%= pageBlock %>&logPage=<%= pageIndex %>"><span><%= pageIndex %></span></a></li>
					<% } } %>
					<%
						if (currentBlock > totalBlock) { %>
							<li><a href="#">&raquo;</a></li>
					<% } else { %>
							<% if (pageBlock+1 > totalBlock) { %>
								<li><a href="#">&raquo;</a></li>
							<% } else { %>
								<li><a href="index.clip?ClipID=M08&pageBlock=<%= pageBlock+1 %>&logPage=<%= endPage+1 %>">&raquo;</a></li>
							<% } %>
					<% } %>
				</ul>
			</div>			
		</div>
	</div>
</div>