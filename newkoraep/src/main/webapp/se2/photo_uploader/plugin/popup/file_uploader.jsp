<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.apache.commons.io.IOUtils"%>
<!--
<%@page import="org.apache.tomcat.util.codec.binary.Base64"%>
  -->
<%@page import="org.apache.commons.codec.binary.Base64"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.UUID"%>
<%@page import="java.io.File"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>

<%
String return1="";
String return2="";
String return3="";
String name = "";
if (ServletFileUpload.isMultipartContent(request)){
    ServletFileUpload uploadHandler = new ServletFileUpload(new DiskFileItemFactory());
    //UTF-8 인코딩 설정
    uploadHandler.setHeaderEncoding("UTF-8");
    List<FileItem> items = uploadHandler.parseRequest(request);
    //각 필드태그들을 FOR문을 이용하여 비교를 합니다.
    for (FileItem item : items) {
        if(item.getFieldName().equals("callback")) {
            return1 = item.getString("UTF-8");
        } else if(item.getFieldName().equals("callback_func")) {
            return2 = "?callback_func="+item.getString("UTF-8");
        } else if(item.getFieldName().equals("Filedata")) {
            //FILE 태그가 1개이상일 경우
            if(item.getSize() > 0) {
            	
                String ext = item.getName().substring(item.getName().lastIndexOf(".")+1);
                ///////////////// 서버에 파일쓰기 ///////////////// 
                InputStream is = item.getInputStream();
                byte b[] = IOUtils.toByteArray(is);
                
                String base64DataString = Base64.encodeBase64String(b);
                base64DataString = "data:image/" + ext + ";base64," + base64DataString;
                
                if(is != null)  is.close();
                
                return3 += "&bNewLine=true&sFileName="+name+"&sFileURL="+ base64DataString;
            }else {
                return3 += "&errstr=error";
            }
        }
    }
}
response.sendRedirect(return1+return2+return3);
%>