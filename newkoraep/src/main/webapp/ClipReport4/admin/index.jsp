<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="com.clipsoft.clipreport.server.service.admin.AdminController" %>
<%@include file="../Property.jsp"%>
<%
	if (request.getSession().getAttribute("clipreport_propertyPath") == null) {
		request.getSession().setAttribute("clipreport_propertyPath", propertyPath);
	}
	AdminController.getInstance().execute(request, response, propertyPath);
%>

