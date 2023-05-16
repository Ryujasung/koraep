<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.clipsoft.clipreport.common.server.beans.connection.*" %>
<%@ page import="com.clipsoft.clipreport.common.server.enums.DataConnectionType" %>
<%
	ArrayList<DataConnectionInfo> dataConnectionList = (ArrayList<DataConnectionInfo>) request.getAttribute("dataConnectionList");
%>
<script type="text/javascript">
	function deleteDataConnection(form) {
		var isDelete = confirm("Are you sure that you want to delete?");
		if (isDelete) {
			form.submit();
		} else {
			alert("It has been canceled.")
		}
	}
</script>
<div class="container">
	<div class="page-header">
		<h3>Local engine connection management page</h3>
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
								<button class="btn btn-primary">Add connection</button>
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
						<th style="text-align:center">No</th>
						<th style="text-align:center">DB name</th>
						<th style="text-align:center">Connection type</th>
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
									} else if (dataConnectionList.get(index).getType().toString().equalsIgnoreCase("JNDI")){
										readID = "L105";
									} else if (dataConnectionList.get(index).getType().toString().equalsIgnoreCase("SAP")) {
										readID = "L106";
									}
								%>
								<input type="hidden" name="ClipID" value="<%=readID%>">
								<input type="hidden" name="dbName" value="<%=dataConnectionList.get(index).getDBName()%>">
								<button type="submit" class="btn btn-link">Edit</button>
							</form>
						</td>
						<td style="text-align:center">
							<form style="display:inline" action="index.jsp" method="post">
								<input type="hidden" name="ClipID" value="L202">
								<input type="hidden" name="dbName" value="<%=dataConnectionList.get(index).getDBName()%>"> 
								<button type="button" class="btn btn-link" onclick="deleteDataConnection(this.form)">Delete</button>
							</form>
						</td>
					</tr>
					<% } } else {%>
					<tr>
						<td colspan="5" style="text-align:center">Connection information does not exist, please add a new connection.</td>
					</tr>	
					<% } %>	
				</tbody> <!-- tbody -->
				
			</table> <!-- table -->
		</div>
	</div>
</div> <!-- container -->
