<%@page import="java.util.*,java.text.*,java.net.InetAddress,java.text.SimpleDateFormat" %><%
	response.setContentType("text/html;charset=UTF-8");
	
	SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyy/MM/dd");
	String sCurrDate = simpledateformat.format(new Date());
	//out.println("<h2>System Information</h2>");
	//out.println("- Date : " + sCurrDate + "<br><br>");

	Runtime runtime = Runtime.getRuntime();
	int iCpu = runtime.availableProcessors();

	//out.println("- CPU Count : " + iCpu + "<br><br>");
	
	String sIpAddr = InetAddress.getLocalHost().getHostAddress();	
	
	//out.println("- IP Address : " + sIpAddr + "<br><br>");
	//out.println("- Remote Address : " + request.getRemoteAddr() + "<br><br>");
	//out.println("- Server Info : " + request.getSession().getServletContext().getServerInfo() + "<br><br>");
	//out.println("- Server RealPath : " + request.getRealPath("/") + "<br><br>");
%>