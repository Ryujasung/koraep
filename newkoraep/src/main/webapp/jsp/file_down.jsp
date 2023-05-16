<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.net.URLEncoder, java.net.URLDecoder" %>
<%@ page import="java.io.*" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<title>File Download</title>
</head>
<body>

<%
	request.setCharacterEncoding("UTF-8");
	String path = request.getSession().getServletContext().getRealPath("/data_file/");	// request.getRealPath("/")deprecated
	
	if(request.getRequestURL().indexOf("localhost") > -1 || request.getRequestURL().indexOf("127.0.0.1") > -1){
		//개발중 임시 path
		path = "C:/egov/workspace/newkoraep/src/main/webapp/data_file/";
	}
	
	// 2017-02-20, 파일명 변경 추가 시작
 	String tmpName = request.getParameter("fileName");
	//취약점점검 3175 류제성
	String[] arrName = null;
	if (tmpName != null){
		arrName = tmpName.split("/");	
	}
	String fileName = arrName[arrName.length-1];

	//String fileName = (null == request.getParameter("fileName")) ? "" : request.getParameter("fileName");
	String saveFileName = request.getParameter("saveFileName");
	if(saveFileName == null || saveFileName.equals("")) saveFileName = fileName;
	
	//fileName = fileName.replaceAll("\0", "").replaceAll("\\\\r", "").replaceAll("\\\\n", "").replaceAll("\\\\t", "").replaceAll("/", "").replaceAll("..", "");
	
	//CHECKPOINT	취약점/널 역참조	류제성
	if(fileName != null && fileName != ""){
		fileName = fileName.replaceAll("\0", "").replaceAll("\\\\r", "").replaceAll("\\\\n", "").replaceAll("\\\\t", "").replaceAll("/", "");
		saveFileName = saveFileName.replaceAll("\0", "").replaceAll("\\\\r", "").replaceAll("\\\\n", "").replaceAll("\\\\t", "");	
	}
	
	String busiNo = request.getParameter("busiNo");
	String div = request.getParameter("downDiv");
	
	
	if(path.indexOf("jsp") > -1) path= path.replace("\\jsp", "");
	path= path.replace("\\", "/") + "/";
	
	if(div == null || div.equals("")){
		div = "file_dn/";
		path= path + div + fileName;
	}else if(div.equals("noti")){
		div = "file_noti/";
		path= path + div + fileName;
	}else if(div.equals("up")){
		div = "file_up/";
		path= path + div + busiNo + "/" + fileName;
	}else if(div.equals("bizlic")){
		div = "file_bizlic/";
		path= path + div + fileName;
	}else if(div.equals("excel")){
		div = "file_excel/";
		path= path + div + fileName;
	}
	
	BufferedInputStream fis = null;
	BufferedOutputStream fos = null;
	try{
		
		//System.out.println(path);
		File file = new File(path);
		response.setContentType("application/download; utf-8");
		
		response.setHeader("Content-Disposition", "attachment;filename="+URLEncoder.encode(saveFileName,"UTF-8"));
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Pargma","no-cache");
		
		//cache에서 해당 페이지 읽기방지 ! 로딩시마다 새로고침한것 !
		response.setContentLength((int)file.length());
		response.setHeader("Pargma","no-cache");
		response.setHeader("Expires","-1");
		
		Long s = file.length();
		if((s/1024/1024) > 256) throw new IOException(); 
		
		//취약점점검 3164 류제성
		if ((int)file.length() < 0) return;
		byte[] data = new byte[(int)file.length()];
		fis = new BufferedInputStream(new FileInputStream(file));
		fos = new BufferedOutputStream(response.getOutputStream());
		
		int count = 0;
		while((count = fis.read(data))!= -1){
			fos.write(data);
		}
					
		fis.close();
		fos.flush();
		fos.close();
	}catch(IOException e){
		out.println("io error : download size over !!!");
	}catch(Exception e){
		out.println("download error" + e);
	}finally{
		if(fis != null) fis.close();
		if(fos != null) fos.close();
		
		//엑셀저장시 파일생성->암호화->파일다운->파일 삭제
		if(div.equals("file_excel/")){
			new File(path).delete();
		}
	}

	out.clear();
	out = pageContext.pushBody();
%>

</body>
</html>