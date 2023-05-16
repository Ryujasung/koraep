<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.clipsoft.clipreport.common.server.*" %>
<%@ page import="com.clipsoft.clipreport.common.server.beans.log.*" %>
<%@ page import="com.clipsoft.clipreport.server.service.admin.util.BootStrapUtil" %>
<%
	ArrayList<ReportLog> reportLogList = (ArrayList<ReportLog>) request.getAttribute("reportLogList");
	int curPageBlock = (Integer) request.getAttribute("curPageBlock");
	int curLogPage = (Integer) request.getAttribute("curLogPage");
	int rowCount = (Integer) request.getAttribute("rowCount");
	int startRow = (Integer) request.getAttribute("startRow");
	int currentBlock = (Integer) request.getAttribute("currentBlock");
	int totalBlock = (Integer) request.getAttribute("totalBlock");
	int startPage = (Integer) request.getAttribute("startPage");
	int endPage = (Integer) request.getAttribute("endPage");
	int size = (Integer) request.getAttribute("size");
%>
<div class="container">
	<div class="page-header">
		<h3>로컬엔진 리포트 로그 페이지</h3>
		전체 리포트로그 개수 : <%= rowCount %>
	</div>
	
	<div style="width: 100%; margin: 0px auto;">
		<div class="table-responsive">
			
			<!-- Table Header -->
			<div>
				<table class="table">
					<thead>
						<tr>
			        		<th colspan="6">
			        			<form class="form-inline" style="display:inline;" action="index.jsp" method="post">
			        				<input type="hidden" name="ClipID" value="L201">
									<button type="submit" class="btn btn-link">전체삭제</button>
								</form>
								<form class="form-inline" style="display:inline;" action="index.jsp" method="post">
									<!--  
									<script type="text/javascript">
										window.setTimeout("document.getElementById('UpdateLogForm').submit();", 5000);
									</script>
									-->
									<input type="hidden" name="curPageBlock" value="<%= curPageBlock %>">
									<input type="hidden" name="curLogPage" value="<%= curLogPage %>">
									
									 <input type="hidden" name="ClipID" value="L158">
									<button type="submit" class="btn btn-link">업데이트</button>
								</form>
			        		</th>
		        		</tr>
						<tr>
							<th width="5%" style="text-align:center; vertical-align: text-bottom;">번호</th>
				            <th width="15%" style="text-align:center; vertical-align: text-bottom;">날짜</th>
				            <th width="12%" style="text-align:center; vertical-align: text-bottom;">아이피주소</th>
				            <th width="12%" style="text-align:center; vertical-align: text-bottom;">리포트파일이름</th>
				            <th width="12%" style="text-align:center; vertical-align: text-bottom;">로그타입</th>
				            <th width="44%" style="text-align:center; vertical-align: text-bottom;">메시지</th>
		        		</tr>
					</thead>
					<tbody>
			        	<% if (rowCount > 0) { startRow += 1; for (int i = 0; i < size; i++) { ReportLog reportLog = reportLogList.get(i); %>
			        	<% String logType = reportLog.getLogWriteType().toString(); %>
			        	<tr>
			        		<td width="5%" style="text-align:center"><%= startRow++ %></td>
				            <td width="15%" style="text-align:center"><%= reportLog.getDate() %></td>
				            <td width="12%" style="text-align:center"><%= reportLog.getIP() %></td>
				            <td width="12%" style="text-align:center"><%= reportLog.getReportFileName() %></td>
				            <td width="12%" style="text-align:center"><span style="width:100%;" class="label <%= BootStrapUtil.findLabelClass(logType) %>"><%= logType %></span></td>
							<td width="44%" style="text-align:center"><%= reportLog.getLog()%></td>
						</tr>
						<% }} else { %>
						<tr class="warning">
							<td colspan="6" style="text-align:center">엔진서버에 리포트로그정보가 존재하지 않습니다.</td>
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
							<% if (curPageBlock -1 < 1) { %>
								<li><a href="#">&laquo;</a></li>
							<% } else { %>
								<li><a href="index.jsp?ClipID=L102&curPageBlock=<%= curPageBlock-1 %>&curLogPage=<%= startPage-1 %>">&laquo;</a></li>
							<% } %>
					<% } %>
					<% for (int pageIndex = startPage; pageIndex <= endPage; pageIndex++) { %>
						<% if (curLogPage == pageIndex) { %> 
							<li class="active"><a href="index.jsp?ClipID=L102&curPageBlock=<%= curPageBlock %>&curLogPage=<%= pageIndex %>"><span><%= pageIndex %></span></a></li>
						<% }	else { %>
						<li><a href="index.jsp?ClipID=L102&curPageBlock=<%= curPageBlock %>&curLogPage=<%= pageIndex %>"><span><%= pageIndex %></span></a></li>
					<% } } %>
					<%
						if (currentBlock > totalBlock) { %>
							<li><a href="#">&raquo;</a></li>
					<% } else { %>
							<% if (curPageBlock+1 > totalBlock) { %>
								<li><a href="#">&raquo;</a></li>
							<% } else { %>
								<li><a href="index.jsp?ClipID=L102&curPageBlock=<%= curPageBlock+1 %>&curLogPage=<%= endPage+1 %>">&raquo;</a></li>
							<% } %>
					<% } %>
				</ul>
			</div>
		</div>
	</div>
</div>