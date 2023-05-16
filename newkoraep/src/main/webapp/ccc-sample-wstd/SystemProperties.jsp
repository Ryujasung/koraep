<%@ page language="java" import="java.util.*,java.io.*" %>
<%@ page contentType="text/html;charset=euc-kr" %>

<%
	Properties props = System.getProperties(); // get list of properties
	/*FileOutputStream output = null;
	
	String file_separator = (String)(props.get("file.separator"));
	String current_dir = "";
	String Path = "";
	String Full_path = request.getRealPath(request.getServletPath());
	if (file_separator.equals("\\"))	
	{
		current_dir = Full_path.substring(0,Full_path.lastIndexOf("\\")+1);
		Path = current_dir + "\\";
	}
	else								
	{
		current_dir = Full_path.substring(0,Full_path.lastIndexOf("/")+1);
		Path = current_dir + "/";
	}
	*/
	// START getprops
	try{
		//output = new FileOutputStream(new File(Path + "SystemProperties.txt"));
		// Print properties using Enumeration
		for (Enumeration enum1 = props.propertyNames(); enum1.hasMoreElements();) {
			String key = (String)enum1.nextElement();
			out.println(key + " = " + (String)(props.get(key)));
			out.println("<br>");
			//output.write(new String(key + " = " + (String)(props.get(key) + "\n")).getBytes());
			//output.flush();
		}
	}catch (IOException e){
		//e.printStackTrace();
		out.println("<br>");
		throw new Exception("IOException error !!!!");
	} finally {
		try {
			out.println("<br>");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
			out.println("<br>");
			throw new Exception("IOException error !!!!");
		}
	}
%>