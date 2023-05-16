<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="./loginCheck.jsp" %>
<%
	String value = (null == request.getQueryString()) ? "" : request.getQueryString();
	value = value.replaceAll("\0", "").replaceAll("\\\\r", "").replaceAll("\\\\n", "").replaceAll("\\\\t", "");
%>
<form style="float:left; padding-top:20px;" action="index.jsp" method="post">
	<div class="control-group">
		<input type="hidden" name="ClipID" value="A02">
		<input type="hidden" name="page" value="<%=value%>" />
		<a class="btn btn-primary" href="index.jsp?ClipID=A02"><i class="icon-off icon-white"></i> Logout</a>
	</div>
</form>