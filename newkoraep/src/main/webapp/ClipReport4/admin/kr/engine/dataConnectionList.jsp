<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.clipsoft.clipreport.common.server.beans.connection.*" %>
<%@ page import="com.clipsoft.clipreport.common.server.enums.DataConnectionType" %>
<%
	ArrayList<DataConnectionInfo> dataConnectionList = (ArrayList<DataConnectionInfo>) request.getAttribute("dataConnectionList");
%>
<script type="text/javascript">
	function deleteDataConnection(form) {
		var isDelete = confirm("삭제하시겠습니까?");
		if (isDelete) {
			form.submit();
		} else {
			alert("취소되었습니다.")
		}
	}
</script>
<div class="container">
	<div class="page-header">
		<h3>로컬엔진 커넥션설정 페이지</h3>
	</div>
	<div style="width:100%; margin:0px auto;">
		<div class="table-responsive">
			<table class="table table-hover">
				
				<thead>
					<tr>
						<th colspan="5"></th>
					</tr>	
				</thead> <!-- thead -->
				
				<tfoot>
					<tr>
						<td colspan="5">
							<!-- <a href="index.jsp?ClipID=L51">
								<button class="btn btn-primary"><i class="icon-edit icon-white"></i> 커넥션 추가</button>
							</a> -->
							<div class="btn-group">
								<button class="btn btn-primary">커넥션 추가</button>
								<button class="btn btn-primary dropdown-toggle"
									data-toggle="dropdown">▼</button>
								</button>
								<ul class="dropdown-menu">
									<li><a href="index.jsp?ClipID=L51">JDBC</a></li>
									<li><a href="index.jsp?ClipID=L53">JNDI</a></li>
									<!-- <li><a href="index.jsp?ClipID=L55">SAP</a></li> -->
								</ul>
							</div>
						</td>
					</tr>
				</tfoot> <!-- tfoot -->
				
				<tbody>
					<tr>
						<th style="text-align:center">번호</th>
						<th style="text-align:center">디비이름</th>
						<th style="text-align:center">커넥션타입</th>
						<th colspan="2" style="text-align:center"></th>
					</tr>
					<% int count = dataConnectionList.size(); if (count > 0) { for (int index = 0; index < count; index++) {%>
					<tr>
						<td style="text-align:center"><%=index+1%> </td>
						<td style="text-align:center"><%=dataConnectionList.get(index).getDBName()%></td>
						<td style="text-align:center"><%=dataConnectionList.get(index).getType().toString() %></td>
						<td style="text-align:center">
							<form style="display:inline" action="index.jsp" method="post">
								<%
									String readID = "";
									if (dataConnectionList.get(index).getType().toString().equalsIgnoreCase("JDBC")) {
										readID = "L104";
									} else if (dataConnectionList.get(index).getType().toString().equalsIgnoreCase("JNDI")) {
										readID = "L105";
									} else if (dataConnectionList.get(index).getType().toString().equalsIgnoreCase("SAP")) {
										readID = "L106";
									}
								%>
								<input type="hidden" name="ClipID" value="<%=readID%>">
								<input type="hidden" name="dbName" value="<%=dataConnectionList.get(index).getDBName()%>">
								<button type="submit" class="btn btn-link">설정</button>
							</form>
						</td>
						<td style="text-align:center">
							<form style="display:inline" action="index.jsp" method="post">
								<input type="hidden" name="ClipID" value="L202">
								<input type="hidden" name="dbName" value="<%=dataConnectionList.get(index).getDBName()%>"> 
								<button type="button" class="btn btn-link" onclick="deleteDataConnection(this.form)">삭제</button>
							</form>
						</td>
					</tr>
					<% } } else {%>
					<tr>
						<td colspan="5" style="text-align:center">커넥션정보가 존재하지 않습니다. 새로운 커넥션을 추가해주세여</td>
					</tr>	
					<% } %>	
				</tbody> <!-- tbody -->
				
			</table> <!-- table -->
		</div>
	</div>
</div> <!-- container -->
