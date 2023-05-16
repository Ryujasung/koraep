/**
 * @title : CommonProperties.java
 * @package : egovframework.common.service
 * @auth : Administrator
 * @date : 2014. 12. 29.
 */
package egovframework.common;

import org.springframework.stereotype.Component;


/**
 * @title : CommonProperties
 * @desc : TODO
 * @author : kwonsy
 * @date: 2014. 12. 29. 
 */
@Component
public class CommonProperties {
	/* 파일 업로드 패스 */
	public static String FILE_UPLOAD_PATH = "";
	
	public static String NOTI_FILE_PATH = "";
	
	public static String SAMPLE_FILE_DOWN_PATH = "";
	
	public static String TOUCHEN_NXKEY_PATH = "";
	
	public static String BIZ_FORM_PATH = "";
	
	public static String APP_INFO_PATH = "";
	
	public static String EXCEL_PATH = "";
	
	public static String CENTER_BIZNO = "";
	
	public static String PASSPHRASE = "";
	
	/**
	 * @param fILE_UPLOAD_PATH the fILE_UPLOAD_PATH to set
	 */
	public void setFILE_UPLOAD_PATH(String fileUploadPath) {
		 this.FILE_UPLOAD_PATH = fileUploadPath;
	}
	
	public void setTOUCHEN_NXKEY_PATH(String certiFilePath) {
		 this.TOUCHEN_NXKEY_PATH = certiFilePath;
	}


	/**
	 * @param nOTI_FILE_PATH the nOTI_FILE_PATH to set
	 */
	public  void setNOTI_FILE_PATH(String notiFilePath) {
		NOTI_FILE_PATH = notiFilePath;
	}
	
	public  void setSAMPLE_FILE_DOWN_PATH(String sampleFileDownPath) {
		SAMPLE_FILE_DOWN_PATH = sampleFileDownPath;
	}
	
	public void setBIZ_FORM_PATH(String bizFormPath){
		BIZ_FORM_PATH = bizFormPath;
	}
	
	public void setAPP_INFO_PATH(String appInfoPath){
		APP_INFO_PATH = appInfoPath;
	}
	
	public void setEXCEL_PATH(String excelPath){
		EXCEL_PATH = excelPath;
	}
	
	public void setCENTER_BIZNO(String bizNo){
		this.CENTER_BIZNO = bizNo;
	}

	public void setPASSPHRASE(String passphrase){
		this.PASSPHRASE = passphrase;
	}
}
