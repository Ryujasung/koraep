package egovframework.common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasoo.fcwpkg.packager.WorkPackager;

public class encrypt {
	private static final Logger log = LoggerFactory.getLogger(encrypt.class);
	
	public static String FileTypeStr(int i) 
	{
		String ret = null;
		switch(i)
		{
	    	case 20 : ret = "파일을 찾을 수 없습니다."; break;
	    	case 21 : ret = "파일 사이즈가 0 입니다.";  break;
	    	case 22 : ret = "파일을 읽을 수 없습니다."; break;
	    	case 29 : ret = "암호화 파일이 아닙니다.";  break;
	    	case 26 : ret = "FSD 파일입니다.";       	break;
	    	case 105: ret = "Wrapsody 파일입니다.";  	break;
	    	case 106: ret = "NX 파일입니다.";			break;	    	
	    	case 101: ret = "MarkAny 파일입니다.";   	break;
	    	case 104: ret = "INCAPS 파일입니다.";    	break;
	    	case 103: ret = "FSN 파일입니다.";       	break;
		}
		return ret;		
	}

    public static void main(String[] args, String[] user) {

		boolean iret = false; 
		int retVal = 0;

		//DRM Config Information
		String strFsdinitPath = "/tmax/APP/koraepse/fsdinit"; // fsdinit(DRM Key)폴더 FullPath 설정    //실서버변경필요!@
		//String strFsdinitPath = "/tmax/APP/koraeps2/fsdinit"; // fsdinit(DRM Key)폴더 FullPath 설정 
		String strCPID = "0100000000001428"; // 
		String strOrgFilePath = args[1]; // 복호화 대상 문서 FullPath + FileName
		String strFileName = args[0]; // 파일명
		String strEncFilePath = args[1]; // 복호화 된 문서 FullPath + FileName

		WorkPackager objWorkPackager = new WorkPackager();
		//objWorkPackager.setCharset("eucKR");

		//복호화 된문서가 암호화된 문서를 덮어쓰지 않음  true/false
		objWorkPackager.setOverWriteFlag(true);

		//에러난다  java.lang.UnsatisfiedLinkError: no f_fcwpkg_jni in java.library.path
		retVal = objWorkPackager.GetFileType(strOrgFilePath);

		log.debug("파일형태는 " + FileTypeStr(retVal) + "["+retVal+"]"+" 입니다.");
		/*
		log.debug("strFsdinitPath : " + strFsdinitPath);
		log.debug("strCPID : " + strCPID);
		log.debug("strOrgFilePath : " + strOrgFilePath);
		log.debug("strEncFilePath : " + strEncFilePath);
		log.debug("strFileName : " + strFileName);
		*/
		//일반 파일의 경우
		if (retVal == 29) {
			
				//파일 암호화
				iret = objWorkPackager.DoPackaging( 
												  strFsdinitPath,	//fsdinit 폴더 FullPath 설정
												  strCPID,			//고객사 Key(default) 
												  strOrgFilePath,		//암호화 대상 문서 FullPath + FileName
												  strEncFilePath,		//암호화 된 문서 FullPath + FileName
												  strFileName,					//파일 명
												  user[0],						//작성자 ID
												  user[1],						//작성자 명
												  "KORA", 
												  "ACLID", "FILEID", "ECT4", "ETC5"
												  );
				
				log.debug("암호화 결과값 : " + iret);
				log.debug("암호화 문서 : " + objWorkPackager.getContainerFilePathName());
				log.debug("오류코드 : " + objWorkPackager.getLastErrorNum());
				log.debug("오류값 : " + objWorkPackager.getLastErrorStr());
		}
		
		else {
			log.debug("일반 파일이 아닌경우 암호화 불가능 합니다.["+ retVal + "]");
		}
	}
}