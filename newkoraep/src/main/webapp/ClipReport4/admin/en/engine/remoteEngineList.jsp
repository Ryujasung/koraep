<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.clipsoft.clipreport.common.server.beans.engine.Engine" %>
<% 
	ArrayList<Engine> remoteEngineList = (ArrayList<Engine>) request.getAttribute("remoteEngineList");
%>
							
<script type="text/javascript">
	function deleteEngine(form) {
		var isDelete = confirm("삭제하시겠습니까?");
		if (isDelete) {
			form.submit();
		} else {
			alert("취소되었습니다.");
		}
	}
</script>							
<div class="container">
	<div class="page-header">
		<h3>원격엔진 관리 페이지</h3>
	</div>
	<div style="width:1200px; margin:0px auto;">
		<div class="table-responsive">
			<table class="table table-hover">
			<!-- <caption>EngineServer List Table</caption> -->
			
			<!-- Table Header-->
	        <thead>
	          <tr>
	          	<th colspan="7"></th>
	          </tr>
	        </thead>
	        
	       
	        <tfoot>
	        	<tr>
	        		<td colspan="7">
	        			<a href="index.clip?ClipID=M51">
	        				<button class="btn btn-primary">엔진서버 추가</button>
	        			</a>
	        		</td>
	        	</tr>
	        </tfoot>  <!-- Table Footer -->
	        
	        <tbody>
	        <tr>
	        	<th style="text-align:center">번호</th>
	            <th style="text-align:center">이름</th>
	            <th style="text-align:center">주소</th>
	            <th style="text-align:center">포트번호</th>
	            <th colspan="2" style="text-align:center">관리</th>
	        </tr>
	        <% int count = remoteEngineList.size(); if (count > 0) { for (int i = 0; i < count; i++) { Engine engine = remoteEngineList.get(i); %>
	          <tr>
	            <td style="text-align:center"><%= i+1 %></td>
	            <td style="text-align:center"><%= engine.getName() %></td>
	            <td style="text-align:center"><%= engine.getAddress() %></td>
	            <td style="text-align:center"><%= engine.getPortNumber() %></td>
	            <%--
	            <td style="text-align:center"> 
	            	<a class="btn btn-link" href="index.jsp?page=engine/cleanRemoteEngine&name=<%= engine.getName() %>">도구</a>
				</td>
				 --%>
	            <td style="text-align:center">
					<form style="display:inline;" action="index.clip" method="post">
						<input type="hidden" name="ClipID" value="M103">
						<input type="hidden" name="name" value="<%= engine.getName() %>"/>
						<button type="submit"class="btn btn-link">설정</button>
					</form>	            	
            	</td>
	            <td style="text-align:center">
	            	<form style="display:inline;" action="index.clip" method="post">
	            		<input type="hidden" name="ClipID" value="M201">
	            		<input type="hidden" name="name" value="<%= engine.getName() %>"/>
						<button type="button" class="btn btn-link" onclick="deleteEngine(this.form)">삭제</button>
					</form>
				</td>
	          </tr>
	          <% } } else { %>
	          <tr class="warning">
	          	<td colspan="7" style="text-align:center">엔진서버 정보가 존재하지 않습니다. 새로운 엔진서버를 추가해주세요.</td>
	          </tr>
	          <% } %>
	        </tbody> <!-- Table Body -->
	      </table>
		</div>
	</div>
</div>
