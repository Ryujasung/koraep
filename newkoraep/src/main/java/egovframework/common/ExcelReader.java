package egovframework.common;

import java.io.FileInputStream;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.MultipartFile;

import egovframework.com.cmm.EgovWebUtil;



public class ExcelReader {

	/** 엑셀 오브젝트 */
	Workbook wb; 
	
	/** 엑셀 시트 */
	Sheet sheet;
	
	
	public ExcelReader(){}
	
	
	/**
	 * xlsx sample
	 * @param fileNm
	 * @param firstRowColumYn
	 * @return
	 * @throws Exception
	 */
	public ArrayList<HashMap<String, String>> getDataStreamXlsx(String fileNm, boolean firstRowColumYn) throws Exception {
		fileNm = EgovWebUtil.filePathReplaceAll(fileNm);
		InputStream file = new FileInputStream(CommonProperties.FILE_UPLOAD_PATH + "/" + fileNm);
		try{
			return getDataStreamXlsx(file, firstRowColumYn);
		}catch(Exception e){
			throw new Exception();
		}finally{
			if(file != null) file.close();
		}
	}
	
	public ArrayList<HashMap<String, String>> getDataStreamXlsx(MultipartFile mFile, boolean firstRowColumYn) throws Exception {
		InputStream file = mFile.getInputStream();
		try{
			 return getDataStreamXlsx(file, firstRowColumYn);
		}catch(Exception e){
			throw new Exception();
		}finally{
			if(file != null) file.close();
		}
	}
	
	public ArrayList<HashMap<String, String>> getDataStreamXlsx(InputStream file, boolean firstRowColumYn) throws Exception {
		
		ArrayList<HashMap<String, String>> list = new ArrayList<HashMap<String,String>>();
		
		
		XSSFWorkbook xworkBook = new XSSFWorkbook(file);
		XSSFSheet xsheet = null;
	    XSSFRow xrow = null;
	    XSSFCell xcell = null;
	    
	    String cellValue  = "";
	    ArrayList<String> key = new ArrayList<String>();
	    
	    //FormulaEvaluator evaluator = xworkBook.getCreationHelper().createFormulaEvaluator();
	    
	    //int sheetnum = xworkBook.getNumberOfSheets();   //시트개수
	    xsheet = xworkBook.getSheetAt(0);   //첫 시트
	 
	    int rows = xsheet.getPhysicalNumberOfRows();  //행의 수
	    for( int i=0;i<rows; i++ ){
	    	xrow = xsheet.getRow(i);          //row에 입력 된 값이 없을 경우 null을 리턴함.
	    	int cells = xrow.getPhysicalNumberOfCells();//cell count
	    	
	    	if(i==0 && firstRowColumYn){//첫번째 로우를 컬럼명으로 사용할 경우
				for(int k=0; k<cells; k++){
					xcell = xrow.getCell(k);
					//CellValue value = evaluator.evaluate( xcell ) ;
					//key.add(value.toString());
					if ((xcell==null || xcell.toString().trim().equals(""))) break; //no data
					key.add(getCellString(xcell));
				}
				continue;
			}
			
			HashMap<String, String> map = new HashMap<String, String>(); 
	    	for( int j=0;j<key.size();j++ ){
	    		xcell = xrow.getCell(j);
				cellValue = getCellString(xcell);
				if(key != null && key.size()>0){
					map.put(key.get(j), cellValue.trim());
				}else{
					map.put(j+"", cellValue.trim());
				}
	    	}//cell
	    	
	    	list.add(map);
	    	
	    }//row
	    
	    return list;
	}
	
	
	
	
	/**
	 * xls sample
	 * @param fileNm
	 * @param firstRowColumYn
	 * @return
	 * @throws Exception
	 */
	public ArrayList<HashMap<String, String>> getDataStream(String fileNm, boolean firstRowColumYn) throws Exception {
		fileNm = EgovWebUtil.filePathReplaceAll(fileNm);
		InputStream file = new FileInputStream(CommonProperties.FILE_UPLOAD_PATH + "/" + fileNm);
		try{
			return getDataStream(file, firstRowColumYn);
		}catch(Exception e){
			throw new Exception();
		}finally{
			if(file != null) file.close();
		}
	}
	
	public ArrayList<HashMap<String, String>> getDataStream(MultipartFile mFile, boolean firstRowColumYn) throws Exception {
		InputStream file = mFile.getInputStream();
		try{
			 return getDataStream(file, firstRowColumYn);
		}catch(Exception e){
			throw new Exception();
		}finally{
			if(file != null) file.close();
		}
	}
	
	public ArrayList<HashMap<String, String>> getDataStream(InputStream file, boolean firstRowColumYn) throws Exception {

		ArrayList<HashMap<String, String>> list = new ArrayList<HashMap<String,String>>();
		
		
		POIFSFileSystem fs = new POIFSFileSystem(file);
		HSSFWorkbook wb = new HSSFWorkbook(fs);
		
		//HSSFWorkbook wb = (HSSFWorkbook) WorkbookFactory.create(file);
		HSSFSheet sheet = null;
		HSSFRow row = null;
		HSSFCell cell = null;
		String cellValue  = "";
		
		ArrayList<String> key = new ArrayList<String>();
		
		int sheetCnt = wb.getNumberOfSheets();
		if(sheetCnt == 0) return list;
		
		sheet = wb.getSheetAt(0);
		//for(int i=0; i<wb.getNumberOfSheets(); i++ ) {
			sheet = wb.getSheetAt(0);
			int rowCnt = sheet.getPhysicalNumberOfRows();
			
			for(int j = 0; j<rowCnt; j++){
				row = sheet.getRow(j);
				int cellCnt = row.getPhysicalNumberOfCells();
				
				if(j==0 && firstRowColumYn){//첫번째 로우를 컬럼명으로 사용할 경우
					for(int k=0; k<cellCnt; k++){
						cell = row.getCell(k);
						if ((cell==null || cell.toString().trim().equals(""))) break; //data not found
						key.add(getCellStringValue(cell));
					}
					continue;
				}
				
				HashMap<String, String> map = new HashMap<String, String>(); 
				for(int k=0; k<key.size(); k++){
					cell = row.getCell(k);
			//		if ((k==0)) break; //data not found	
					cellValue = getCellStringValue(cell);
					if(key != null && key.size()>0){
						map.put(key.get(k), cellValue.trim());
					}else{
						map.put(k+"", cellValue.trim());
					}
				}//cell
				list.add(map);
				
			}//row
		//}//sheet
			
		return list;
	}
	
	
	
	
	
	@SuppressWarnings("deprecation")
	private static String getCellStringValue(HSSFCell cell){
		//cell.setCellType(Cell.CELL_TYPE_STRING);
		if(cell == null) return "";

		String value = "";

		switch( cell.getCellType() ) {
        case HSSFCell.CELL_TYPE_STRING:
        	value = cell.getRichStringCellValue().getString();
            break;
        case HSSFCell.CELL_TYPE_NUMERIC:
            if( HSSFDateUtil.isCellDateFormatted(cell) ) {
                java.util.Date dateValue = cell.getDateCellValue();
                SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

                int year = dateValue.getYear(); // or getYear
                if (year != -1){
                	value = dateFormat1.format(dateValue);
                }
            }
            else {

            	DecimalFormat dft = new DecimalFormat("########################.########");
                value = dft.format(cell.getNumericCellValue());
            }
            break;

        case HSSFCell.CELL_TYPE_FORMULA:
        	value =  cell.getCellFormula();  break;

        case HSSFCell.CELL_TYPE_BOOLEAN:
        	value = new Boolean(cell.getBooleanCellValue()).toString();  	break;

        case HSSFCell.CELL_TYPE_ERROR:
           cell.getErrorCellValue();  break;

        case HSSFCell.CELL_TYPE_BLANK: break;

        default: break;
		}
		return value;
	}
	
	@SuppressWarnings("unused")
	private String getCellString(XSSFCell cell){
		String val = "";
		if(cell == null) return "";
		switch( cell.getCellType() ) {
			case XSSFCell.CELL_TYPE_STRING:
				val = cell.getRichStringCellValue().getString();
			    break;
			case XSSFCell.CELL_TYPE_NUMERIC:
			    if( HSSFDateUtil.isCellDateFormatted(cell) ) {
			        java.util.Date dateValue = cell.getDateCellValue();
			        SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
				    Integer year = dateValue.getYear();
				    if (year != -1){
				    	val = dateFormat1.format(dateValue);
				    }
			    }else {
					DecimalFormat dft = new DecimalFormat("########################.########");
					val = dft.format(cell.getNumericCellValue());
			    }
			    break;
			
			case XSSFCell.CELL_TYPE_FORMULA:
				val =  cell.getCellFormula();  break;
			
			case XSSFCell.CELL_TYPE_BOOLEAN:
				val = new Boolean(cell.getBooleanCellValue()).toString();  	break;
			
			case XSSFCell.CELL_TYPE_ERROR:
			   cell.getErrorCellValue();  break;
			
			case XSSFCell.CELL_TYPE_BLANK: break;
			
			default: break;
		}
		return val;
	}
	
	
	/* JXL을 사용한 excelRead */
	/*
	public TDataSet simpleExcelReadJxl(File targetFile, boolean firstRowColumYn) throws Exception {
		jxl.Workbook workbook = null;
		jxl.Sheet sheet = null;
		TDataSet ds = new TDataSet();
		
		ArrayList<String> key = new ArrayList<String>();

		try {
			workbook = jxl.Workbook.getWorkbook(targetFile); // 존재하는 엑셀파일 경로를 지정
			sheet = workbook.getSheet(0); // 첫번째 시트를 지정합니다.
			int rowCount = sheet.getRows(); // 총 로우수를 가져옵니다.
			int colCount = sheet.getColumns(); // 총 열의 수를 가져옵니다.
			if (rowCount <= 0) {
				ds.setValue("01","데이터가 존재하지 않습니다.");
				return ds;
			}
			
			ds.setValue("EXCEL_ROWS", rowCount);
			ds.setValue("EXCEL_COLS", colCount);
			if(firstRowColumYn) ds.setValue("EXCEL_ROWS", rowCount-1);
			
			// 엑셀데이터를 배열에 저장
			for (int i = 0; i < rowCount; i++) {
				if(i==0 && firstRowColumYn){//첫번째 로우를 컬럼명으로 사용할 경우
					for(int k=0; k<colCount; k++){
						jxl.Cell cell = sheet.getCell(k, i);
						key.add(cell.getContents());
					}
					continue;
				}
				
				for (int k = 0; k < colCount; k++) {
					jxl.Cell cell = sheet.getCell(k, i); // 해당위치의 셀을 가져오는 부분입니다.
					if (k==0 && cell == null) continue;
					
					if(key != null && key.size()>0){
						ds.setValue(key.get(k), i-1, cell.getContents());
					}else{
						ds.setValue(k+"", i, cell.getContents());
					}
				}
			}
			
		}catch (Exception e) {
			ds.setValue("01","엑셀 읽기 오류");
		}finally {
			try {
				if (workbook != null) workbook.close();
			} catch (Exception e) { 
				
			}
		}

		return ds;

	}
	*/

	


}
