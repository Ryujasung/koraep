<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.clipsoft.clipreport.common.server.beans.printer.*" %>
<%
	ArrayList<Printer> printerList = (ArrayList<Printer>) request.getAttribute("printerList");
%>
<script type="text/javascript">
	function deletePrinter(form) {
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
		<h3>프린터 환경설정 페이지</h3>
	</div>
	
	<div style="width:100%; margin:0px auto;">
		<div class="table-responsive">
			<table class="table table-hover">
				
				<thead>
					<tr>
						<th colspan="4"></th>
					</tr>	
				</thead> <!-- thead -->
				
				<tfoot>
					<tr>
						<td colspan="5">
							<a href="index.jsp?ClipID=E50">
								<button class="btn btn-primary"><i class="icon-edit icon-white"></i> 프린터 추가</button>
							</a>
						</td>
					</tr>
				</tfoot> <!-- tfoot -->
				
				<tbody>
					<tr>
						<th width="5%"style="text-align:center">번호</th>
						<th width="35%" style="text-align:center">프린터 이름</th>
						<th width="50%" style="text-align:center">드라이버 명</th>
						<th width="10%" style="text-align:center"></th>
					</tr>
					
					<% int count = printerList.size(); if (count > 0) { for (int index = 0; index < count; index++) {%>
					<tr>
						<td width="5%" style="text-align:center"><%=index+1%> </td>
						<td width="35%" style="text-align:center"><%=printerList.get(index).getName() %></td>
						<td width="50%" style="text-align:center"><%=printerList.get(index).getDriver() %></td>
						<td width="10%" style="text-align:center">
							<form style="display:inline" action="index.jsp" method="post">
								<input type="hidden" name="ClipID" value="E200">
								<input type="hidden" name="printerName" value="<%=printerList.get(index).getName()%>"> 
								<button type="button" class="btn btn-link" onclick="deletePrinter(this.form)">삭제</button>
							</form>
						</td>
					</tr>
					<% } } else {%>
					<tr>
						<td colspan="4" style="text-align:center">프린터 정보가 존재하지 않습니다. 새로운 프린터를 추가 해주세요</td>
					</tr>	
					<% } %>	
				</tbody> <!-- tbody -->
				
			</table> <!-- table -->
		</div>
	</div>
</div> <!-- container -->
