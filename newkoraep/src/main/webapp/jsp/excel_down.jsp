<%@page language="java" contentType="application/vnd.ms-excel; name='excel',text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="common.*,java.lang.StringBuffer,java.net.URLEncoder"%>
<%@ page import="jxl.*, java.net.URLDecoder"%>
<%@ page import="jxl.write.*, java.util.List" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="org.apache.poi.ss.usermodel.Cell" %>
<%@ page import="org.apache.poi.ss.usermodel.Row" %>
<%@ page import="org.apache.poi.ss.usermodel.Sheet" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="org.apache.poi.hssf.record.crypto.Biff8EncryptionKey" %>

<%@ page import="java.util.Map" %>

<%
	String fileName = (request.getAttribute("EXCEL_NAME") == null) ? "" : URLEncoder.encode((String)request.getAttribute("EXCEL_NAME"), "UTF-8");
	
	if (fileName.equals("")){
		java.text.SimpleDateFormat df1 = new java.text.SimpleDateFormat("yyyy-MM-dd");
		fileName = df1.format(new java.util.Date())+"";
	}
	
	response.setHeader("Content-Disposition", "attachment; filename=" + fileName.replaceAll("\r", "").replaceAll("\n", "") + ".xls" );
	response.setContentType("application/vnd.ms-excel;charset=UTF-8");
	response.setHeader("Pragma", "no-cache;");
	response.setHeader("Expires", "-1;");

/*
	HSSFWorkbook workbook = new HSSFWorkbook();
	HSSFSheet worksheet = null;
	HSSFRow row = null;
	
	//workbook.writeProtectWorkbook("password", "owner");
	//Biff8EncryptionKey.setCurrentUserPassword("12345");
	
	
	String[] colName = ((String)request.getAttribute("COLUMN")).split(",");
	String[] colTitle = ((String)request.getAttribute("TITLE")).split(",");

	List list = (List)request.getAttribute("resultList");
	int colCnt = colName.length;
	int rowCnt = list.size();
   
	worksheet = workbook.createSheet("Sheet1");
	row = worksheet.createRow(0);
	for(int i = 0; i < colCnt; i++){
		Cell c = row.createCell(i);
		c.setCellValue(colTitle[i]);
	}
    
	for(int i=0; i<list.size(); i++){
		row = worksheet.createRow(i);
		EgovMap map = (EgovMap)list.get(i);
		for(int j = 0; j < colCnt; j++){
 			Cell c = row.createCell(j);
 			String s1 = j + "";
			if(!colName[j].equals("num")) s1 = (String)map.get(colName[j]);
			if(s1 == null) s1 = "";
 			
			s1 = s1.replaceAll("\r\n", "\n");
			s1 = s1.replaceAll("\r", "\n");
			c.setCellValue(s1);
		}
	}
	
	out.clear();
	out = pageContext.pushBody();
	
	
	OutputStream os = response.getOutputStream();
	workbook.write(os);
	os.close();
*/
/*
	// 새로운 엑셀 워크 시트 생성
	XSSFWorkbook wb = new XSSFWorkbook();
	wb.lockWindows()
	Sheet sheet = wb.createSheet();
	
	String[] colName = ((String)request.getAttribute("COLUMN")).split(",");
	String[] colTitle = ((String)request.getAttribute("TITLE")).split(",");

	List list = (List)request.getAttribute("resultList");
	
	int colCnt = colName.length;
	int rowCnt = list.size();
	
	//헤드
	Row hRow = sheet.createRow(0);
	for(int i = 0; i < colCnt; i++){
		Cell c = hRow.createCell(i);
		c.setCellValue(colTitle[i]);
	}
	
	//데이타
	for(int row = 0; row < rowCnt; row++){
 		Row r = sheet.createRow(row+1);
 		EgovMap map = (EgovMap)list.get(row);
 		
 		for(int i = 0; i < colCnt; i++){
 			Cell c = r.createCell(i);
 			String s1 = row + "";
			if(!colName[i].equals("num")) s1 = (String)map.get(colName[i]);
			if(s1 == null) s1 = "";
 			
			s1 = s1.replaceAll("\r\n", "\n");
			s1 = s1.replaceAll("\r", "\n");
			c.setCellValue(s1);
		}
 	}

	out.clear();
	out = pageContext.pushBody();
	
	//System.out.println("fileName====" + fileName);
	
		
	OutputStream os = response.getOutputStream();
	wb.write(os);
	os.close();
*/


	WritableWorkbook workbook = null;
	out.clear();
	out=pageContext.pushBody();
	workbook = Workbook.createWorkbook(response.getOutputStream());
	try{

		WritableSheet sheet = null;
	
		Label label;
	
		WritableFont title_font = new WritableFont(WritableFont.ARIAL , 12, WritableFont.BOLD, false);
		jxl.write.WritableCellFormat  f_title = new WritableCellFormat(title_font);
		f_title.setBackground(jxl.format.Colour.WHITE );
		f_title.setAlignment(jxl.format.Alignment.CENTRE);
	
		WritableFont col_font = new WritableFont(WritableFont.ARIAL , 10, WritableFont.BOLD , false);
		jxl.write.WritableCellFormat  f_colname = new WritableCellFormat(col_font);
		f_colname.setBackground(jxl.format.Colour.GREY_25_PERCENT  );
		f_colname.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN );
		f_colname.setAlignment(jxl.format.Alignment.CENTRE);
	
		WritableFont data_font = new WritableFont(WritableFont.ARIAL , 10, WritableFont.NO_BOLD , false);
		jxl.write.WritableCellFormat  f_data_l = new WritableCellFormat(data_font);
		jxl.write.WritableCellFormat  f_data_c = new WritableCellFormat(data_font);
		jxl.write.WritableCellFormat  f_data_r = new WritableCellFormat(data_font);
		f_data_l.setAlignment(jxl.format.Alignment.LEFT);
		f_data_c.setAlignment(jxl.format.Alignment.CENTRE);
		f_data_r.setAlignment(jxl.format.Alignment.RIGHT);
		f_data_l.setBackground(jxl.format.Colour.WHITE  );
		f_data_c.setBackground(jxl.format.Colour.WHITE  );
		f_data_r.setBackground(jxl.format.Colour.WHITE  );
		f_data_l.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN );
		f_data_c.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN );
		f_data_r.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN );
		f_data_l.setWrap(true);
		f_data_c.setWrap(true);
		f_data_r.setWrap(true);

		int row = 0;
	
		sheet = workbook.createSheet("Sheet1", 0);
	
		//System.out.println("==================" + (String)request.getAttribute("COLUMN"));
		//System.out.println("==================" + (String)request.getAttribute("TITLE"));
		
		String[] colName = ((String)request.getAttribute("COLUMN")).split(",");
		String[] colTitle = ((String)request.getAttribute("TITLE")).split(",");
		int colCnt = 0;
		int rowCnt = 0;
		if (colName!=null && colName.length>0) colCnt = colName.length;

		if (colCnt > 0){
			for (int k=0;k<colCnt;k++){
				label = new Label(k, row, colTitle[k], f_colname);
				sheet.addCell(label);
				sheet.setColumnView(k, 16);
			}
		}
		List list = (List)request.getAttribute("resultList");
		rowCnt = list.size();
		//System.out.println("row cnt =====" + rowCnt);
		
		if (rowCnt > 0){
			if (colCnt > 0) row++;
			
			for (int i=0;i<rowCnt;i++){
				Map<String, Object> map = (Map<String, Object>)list.get(i);
				//System.out.println("row =====" + i);
				for (int k=0;k<colCnt;k++){
					String s1 = (map.get(colName[k]) == null) ? "" : map.get(colName[k])+"";
					
					s1 = s1.replaceAll("\r\n", "\n");
					s1 = s1.replaceAll("\r", "\n");
					label = new Label(k, i+row, s1, f_data_l);
					
					sheet.addCell(label);
				}
			}
		}
		
		workbook.write();
	
	}catch(Exception e){
		throw new Exception("error !!!!");
		//return;
		//System.out.println("error !!!!");
	}
	finally{
		if(workbook != null) { 
			try { 
				workbook.close(); 
			} catch(Exception e) {
				throw new Exception("workbook close error !!!!");
				//return;
				//System.out.println("workbook close error !!!!");
			} 
		}
	}

%>
