<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.clipsoft.clipreport.reportinfo.ReportInfo" %>
<div style="width:100%; height:75%;">
	<!--  class="hero-unit" --> 
	<div style="height:100%; text-align: center; background:#FFFFFF;">
		<h3>CLIP report Server</h3>
		<h5>Version : <%= ReportInfo.version %> &nbsp;&nbsp; (<%= ReportInfo.buildDay %>)</h5>
		<div id="content_home"></div>
	</div>
</div>