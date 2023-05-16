package egovframework.common;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Locale;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import egovframework.com.cmm.EgovWebUtil;

/**
 * @Class Name  : EgovFileMngUtil.java
 * @Description : 메시지 처리 관련 유틸리티
 * @Modification Information
 *
 *     수정일         수정자                   수정내용
 *     -------          --------        ---------------------------
 *   2009.02.13       이삼섭                  최초 생성
 *   2011.08.09       서준식                  utl.fcc패키지와 Dependency제거를 위해 getTimeStamp()메서드 추가
 * @author 공통 서비스 개발팀 이삼섭
 * @since 2009. 02. 13
 * @version 1.0
 * @see
 *
 */
@Component("EgovFileMngUtil")
public class EgovFileMngUtil {

	public static final int BUFF_SIZE = 2048;

	private static final long MAX_FILE_SIZE = 200000000; 
	
	/**
	 * 공지사항 첨부파일 등록
	 * @param file
	 * @return
	 * @throws Exception
	 */
	public static HashMap<String, String> uploadNotiFile(MultipartFile file) throws Exception {
		String stordFilePath = CommonProperties.NOTI_FILE_PATH + File.separator;
		return uploadFiles(file, stordFilePath);
	}
	
	public static HashMap<String, String> uploadNotiFile(String appFileStr, String orgFileNm) throws Exception {
		String stordFilePath = CommonProperties.NOTI_FILE_PATH + File.separator;
		return uploadFiles(appFileStr, stordFilePath, orgFileNm);
	}
	
	
	/**
	 * 일반 파일업로드
	 * @param file
	 * @return
	 * @throws Exception
	 */
	public static HashMap<String, String> uploadFile(MultipartFile file, String bizNo) throws Exception {
		String stordFilePath = CommonProperties.FILE_UPLOAD_PATH + File.separator + bizNo;
		return uploadFiles(file, stordFilePath);
	}
	
	public static HashMap<String, String> uploadFile(String appFileStr, String bizNo, String orgFileNm) throws Exception {
		String stordFilePath = CommonProperties.FILE_UPLOAD_PATH + File.separator + bizNo;
		return uploadFiles(appFileStr, stordFilePath, orgFileNm);
	}

	
	/**
	 * 사업자 등록증 사본
	 * @param file
	 * @return
	 * @throws Exception
	 */
	public static HashMap<String, String> uploadBizFile(MultipartFile file) throws Exception {
		String stordFilePath = CommonProperties.BIZ_FORM_PATH + File.separator;
		return uploadFiles(file, stordFilePath);
	}
	
	public static HashMap<String, String> uploadBizFile(String appFileStr, String orgFileNm) throws Exception {
		String stordFilePath = CommonProperties.BIZ_FORM_PATH + File.separator;
		return uploadFiles(appFileStr, stordFilePath, orgFileNm);
	}
	
	
	/**
	 * 첨부로 등록된 파일을 서버에 업로드한다.
	 *
	 * @param file
	 * @return
	 * @throws Exception
	 */
	public static HashMap<String, String> uploadFiles(MultipartFile file, String stordFilePath) throws Exception {

		HashMap<String, String> map = new HashMap<String, String>();
		
		String newName = "";
		String orginFileName = file.getOriginalFilename();

		int index = orginFileName.lastIndexOf(".");
		if(index < 0) throw new Exception("올바른 확장자가 아닙니다.");
		
		String fileExt = orginFileName.substring(index + 1);
		long size = file.getSize();
		
		if(size > MAX_FILE_SIZE){
			throw new Exception("허용되지 않는 파일크기 등록 시도!!");
		}
		
		if(fileExt.toLowerCase().equals("exe") || fileExt.toLowerCase().equals("com") || fileExt.toLowerCase().equals("bat")
			|| fileExt.toLowerCase().equals("jsp") || fileExt.toLowerCase().equals("js") || fileExt.toLowerCase().equals("java")
			|| fileExt.toLowerCase().equals("class") || fileExt.toLowerCase().equals("sql") || fileExt.toLowerCase().equals("vs")
			|| fileExt.toLowerCase().equals("asp") || fileExt.toLowerCase().equals("php") || fileExt.toLowerCase().equals("cgi")
			|| fileExt.toLowerCase().equals("in") || fileExt.toLowerCase().equals("pl") || fileExt.toLowerCase().equals("php3")
			|| fileExt.toLowerCase().equals("html") || fileExt.toLowerCase().equals("htm") || fileExt.toLowerCase().equals("shtml")
		){
			throw new Exception("허용되지 않는 파일등록 시도!!");
		}
		
		
		//newName 은 Naming Convention에 의해서 생성
		newName = getTimeStamp() + "." + fileExt; // 2012.11 KISA 보안조치
		writeFile(file, newName, stordFilePath);
		
		//2015-01-05 kwonsy 수정
		map.put("originalFileName", orginFileName); //originalFileName
		map.put("uploadFileName", newName);	//uploadFileName
		map.put("fileExtension", fileExt);			//fileExtension
		map.put("filePath", stordFilePath);	//filePath
		map.put("fileSize", String.valueOf(size));	//fileSize
		
		return map;
	}
	
	
	/**
	 * 첨부로 등록된 파일을 서버에 업로드한다.(앱용 Base64 문자열0
	 * @param appFileStr
	 * @param stordFilePath
	 * @param orginFileName
	 * @return
	 * @throws Exception
	 */
	public static HashMap<String, String> uploadFiles(String appFileStr, String stordFilePath, String orginFileName) throws Exception {

		HashMap<String, String> map = new HashMap<String, String>();
		
		String newName = "";
		
		int index = orginFileName.lastIndexOf(".");
		String fileExt = orginFileName.substring(index + 1);

		if(fileExt.toLowerCase().equals("exe") || fileExt.toLowerCase().equals("com") || fileExt.toLowerCase().equals("bat")
			|| fileExt.toLowerCase().equals("jsp") || fileExt.toLowerCase().equals("js") || fileExt.toLowerCase().equals("java")
			|| fileExt.toLowerCase().equals("class") || fileExt.toLowerCase().equals("sql") || fileExt.toLowerCase().equals("vs")
			|| fileExt.toLowerCase().equals("asp") || fileExt.toLowerCase().equals("php") || fileExt.toLowerCase().equals("cgi")
			|| fileExt.toLowerCase().equals("in") || fileExt.toLowerCase().equals("pl") || fileExt.toLowerCase().equals("php3")
			|| fileExt.toLowerCase().equals("html") || fileExt.toLowerCase().equals("htm") || fileExt.toLowerCase().equals("shtml")
		){
			throw new Exception("허용되지 않는 파일등록 시도!!");
		}
		
		//newName 은 Naming Convention에 의해서 생성
		newName = getTimeStamp() + "." + fileExt; // 2012.11 KISA 보안조치
		writeFile(appFileStr, newName, stordFilePath);
		
		map.put("originalFileName", orginFileName); //originalFileName
		map.put("uploadFileName", newName);	//uploadFileName
		map.put("fileExtension", fileExt);			//fileExtension
		map.put("filePath", stordFilePath);	//filePath
		
		return map;
	}

	/**
	 * 파일을 실제 물리적인 경로에 생성한다.
	 *
	 * @param file
	 * @param newName
	 * @param stordFilePath
	 * @throws Exception
	 */
	protected static void writeFile(MultipartFile file, String newName, String stordFilePath) throws Exception {
		InputStream stream = null;
		OutputStream bos = null;
		try {
			stream = file.getInputStream();
			File cFile = new File(EgovWebUtil.filePathBlackList(stordFilePath));
			if (cFile != null) {
				if(cFile.getParentFile().canWrite()){	//상위디렉토리(파일) 쓰기권한 여부체크
					if (!cFile.isDirectory())
						cFile.mkdir();

					newName = EgovWebUtil.filePathReplaceAll(newName);
					bos = new FileOutputStream(EgovWebUtil.filePathBlackList(stordFilePath + File.separator + newName));

					int bytesRead = 0;
					byte[] buffer = new byte[BUFF_SIZE];

					while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
						bos.write(buffer, 0, bytesRead);
					}
					
					//크리스마스 끝나고 테스트 함하자..
					/*
					if(!stordFilePath.equals(CommonProperties.BIZ_FORM_PATH + File.separator)
							&& !stordFilePath.equals(CommonProperties.NOTI_FILE_PATH + File.separator)){
						if(cFile.exists()){	//저장파일 생성된경우
							cFile.setExecutable(false, true);		//실행권한 - 소유자
							cFile.setReadable(true);		//읽기 권한 - 모두있음
							cFile.setWritable(false, true);	//쓰기권한 - 소유자.
						}
					}
					*/
				}	//if
			}
		} finally {
			EgovResourceCloseHelper.close(bos, stream);
		}
	}
	
	
	
	/**
	 * 모바일 앱용 Base64 이미지 저장
	 * @param appFileStr
	 * @param newName
	 * @param stordFilePath
	 * @throws Exception
	 */
	protected static void writeFile(String appFileStr, String newName, String stordFilePath) throws Exception {
		OutputStream bos = null;

		try {
			Base64 decoder = new Base64();
			byte[] imgBytes = decoder.decode(appFileStr);
			
			File cFile = new File(EgovWebUtil.filePathBlackList(stordFilePath));

			if (!cFile.isDirectory())
				cFile.mkdir();

			newName = EgovWebUtil.filePathReplaceAll(newName);
			bos = new FileOutputStream(EgovWebUtil.filePathBlackList(stordFilePath + File.separator + newName));
			bos.write(imgBytes);
		} finally {
			EgovResourceCloseHelper.close(bos);
		}
	}

	
	
	
	
	
	

	/**
	 * 서버 파일에 대하여 다운로드를 처리한다.
	 *
	 * @param response
	 * @param streFileNm 파일저장 경로가 포함된 형태
	 * @param orignFileNm
	 * @throws Exception
	 */
	public void downFile(HttpServletResponse response, String streFileNm, String orignFileNm) throws Exception {
		String downFileName = streFileNm;
		String orgFileName = orignFileNm;
		orgFileName = EgovWebUtil.filePathReplaceAll(orgFileName);

		File file = new File(EgovWebUtil.filePathBlackList(downFileName));
		
		if (!file.exists()) {
			throw new FileNotFoundException(downFileName);
		}

		if (!file.isFile()) {
			throw new FileNotFoundException(downFileName);
		}

		int fSize = (int) file.length();
		if (fSize > 0) {
			BufferedInputStream in = null;

			try {
				in = new BufferedInputStream(new FileInputStream(file));

				String mimetype = "application/x-msdownload";

				//response.setBufferSize(fSize);
				response.setContentType(mimetype);
				response.setHeader("Content-Disposition:", "attachment; filename=" + orgFileName);
				response.setContentLength(fSize);
				//response.setHeader("Content-Transfer-Encoding","binary");
				//response.setHeader("Pragma","no-cache");
				//response.setHeader("Expires","0");
				FileCopyUtils.copy(in, response.getOutputStream());
			} finally {
				EgovResourceCloseHelper.close(in);
			}
			response.getOutputStream().flush();
			response.getOutputStream().close();
		}

		/*
		String uploadPath = propertiesService.getString("fileDir");

		File uFile = new File(uploadPath, requestedFile);
		int fSize = (int) uFile.length();

		if (fSize > 0) {
		    BufferedInputStream in = new BufferedInputStream(new FileInputStream(uFile));

		    String mimetype = "text/html";

		    //response.setBufferSize(fSize);
		    response.setContentType(mimetype);
		    response.setHeader("Content-Disposition", "attachment; filename=\"" + requestedFile + "\"");
		    response.setContentLength(fSize);

		    FileCopyUtils.copy(in, response.getOutputStream());
		    in.close();
		    response.getOutputStream().flush();
		    response.getOutputStream().close();
		} else {
		    response.setContentType("text/html");
		    PrintWriter printwriter = response.getWriter();
		    printwriter.println("<html>");
		    printwriter.println("<br><br><br><h2>Could not get file name:<br>" + requestedFile + "</h2>");
		    printwriter.println("<br><br><br><center><h3><a href='javascript: history.go(-1)'>Back</a></h3></center>");
		    printwriter.println("<br><br><br>&copy; webAccess");
		    printwriter.println("</html>");
		    printwriter.flush();
		    printwriter.close();
		}
		//*/

		/*
		response.setContentType("application/x-msdownload");
		response.setHeader("Content-Disposition:", "attachment; filename=" + new String(orgFileName.getBytes(),"UTF-8" ));
		response.setHeader("Content-Transfer-Encoding","binary");
		response.setHeader("Pragma","no-cache");
		response.setHeader("Expires","0");

		BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file));
		BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
		int read = 0;

		while ((read = fin.read(b)) != -1) {
		    outs.write(b,0,read);
		}
		log.debug(this.getClass().getName()+" BufferedOutputStream Write Complete!!! ");

		outs.close();
		fin.close();
		//*/
	}
	
	
	/**
	 * 공지, faq 파일삭제
	 * @param fileNm : 파일명
	 * @return
	 * @throws Exception
	 */
	public boolean deleteNotiFile(String fileNm) throws Exception{
		fileNm = CommonProperties.NOTI_FILE_PATH + File.separator + fileNm;
		return deleteFile(fileNm);
	}
	
	/**
	 * 일반 업로드 파일 삭제
	 * @param fileNm : 파일명
	 * @param bizNo : 사업자번호
	 * @return
	 * @throws Exception
	 */
	public boolean deleteUpFile(String fileNm, String bizNo) throws Exception{
		fileNm = CommonProperties.FILE_UPLOAD_PATH + File.separator + bizNo + File.separator + fileNm;
		return deleteFile(fileNm);
	}
	
	/**
	 * 일반 업로드 파일 삭제
	 * @param fileNm : 파일명
	 * @param bizNo : 사업자번호
	 * @return
	 * @throws Exception
	 */
	public boolean deleteBizFile(String fileNm) throws Exception{
		fileNm = CommonProperties.BIZ_FORM_PATH + File.separator + fileNm;
		return deleteFile(fileNm);
	}
	
	
	/**
	 * 실제 파일삭제
	 * @param fileNm
	 * @return
	 * @throws Exception
	 */
	public boolean deleteFile(String fileNm) throws Exception{
		
		//파일경로가 사라짐..
		//fileNm = EgovWebUtil.filePathReplaceAll(fileNm);
		
		File file = new File(fileNm);
		boolean flag = false;
	    if(file.exists()){
	    	flag = file.delete();
	    }
	    
	    return flag;
	}
	
	
	
	
	
	
	
	
	
	
	

	/**
	 * 공통 컴포넌트 utl.fcc 패키지와 Dependency제거를 위해 내부 메서드로 추가 정의함
	 * 응용어플리케이션에서 고유값을 사용하기 위해 시스템에서17자리의TIMESTAMP값을 구하는 기능
	 *
	 * @param
	 * @return Timestamp 값
	 * @see
	 */
	private static String getTimeStamp() {

		String rtnStr = null;

		// 문자열로 변환하기 위한 패턴 설정(년도-월-일 시:분:초:초(자정이후 초))
		String pattern = "yyyyMMddhhmmssSSS";

		SimpleDateFormat sdfCurrent = new SimpleDateFormat(pattern, Locale.KOREA);
		Timestamp ts = new Timestamp(System.currentTimeMillis());

		rtnStr = sdfCurrent.format(ts.getTime());

		return rtnStr;
	}

	
	
	

}
