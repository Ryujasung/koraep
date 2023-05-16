/**
 * 
 */
package egovframework.common;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import egovframework.com.cmm.EgovWebUtil;

/**
 * @author Administrator
 *
 */
public class ExcelSave {
	
	public String makeExcel(String[] col, List<String[]> list, String fileNm) throws IOException{
		//Excel Write
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet("Sheet1");
		
		//Row 생성
		HSSFRow row = sheet.createRow(0);
		//Cell 생성
		HSSFCell cell;
		
		//String title = "Admin ID,User Name,E-mail";
		//String[] col = title.split(",");
		for(int i=0; i<col.length; i++){
			 cell = row.createCell(i);
			 cell.setCellValue(col[i]);
		}
		
		if(list == null || list.size() < 1) return null;
		for(int cnt=0; cnt<list.size(); cnt++){
			//String value = "sdsadmin01,sdsadmin@samsung.com,홍길동";
			//String[] val = value.split(",");

			String[] val = list.get(cnt);
			row = sheet.createRow(1);
			for(int i=0; i<col.length; i++){
				 cell = row.createCell(i);
				 cell.setCellValue(val[i]);
			}
		}
		
		
		// 실제로 저장될 파일 풀 경로
		fileNm = EgovWebUtil.filePathReplaceAll(fileNm);
		File file = new File(CommonProperties.FILE_UPLOAD_PATH +"/", fileNm);
		FileOutputStream fileOutput = new FileOutputStream(file);
		try {
			workbook.write(fileOutput);
			fileOutput.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			return "";
		}finally{
			if(fileOutput != null) fileOutput.close();
		}

		return fileNm;
	}
	
}
