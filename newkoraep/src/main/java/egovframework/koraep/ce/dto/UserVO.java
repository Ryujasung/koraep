/**
 * 
 */
package egovframework.koraep.ce.dto;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * @author Administrator
 *
 */
public class UserVO {

	private String USER_ID = "";
	private String USER_NM = "";
	private String BIZRID = "";
	private String BIZRNO = "";
	private String BIZRNO_ORI = "";
	private String BIZR_TP_CD = "";
	private String BRCH_ID = "";
	private String BRCH_NO = "";
//	private String MBR_SE_CD = "";
	private String USER_SE_CD = "";
	private String USER_STAT_CD = "";
	private String USER_PWD = "";
	private String EMAIL = "";
	private String MBIL_NO1 = "";
	private String MBIL_NO2 = "";
	private String MBIL_NO3 = "";
	private String TEL_NO1 = "";
	private String TEL_NO2 = "";
	private String TEL_NO3 = "";
	private String DEPT_CD = "";
	private String PWD_ALT_REQ_YN = "";
	private String PWD_ALT_REQ_DTTM = "";
	private String PWD_ALT_DT = "";
	private String LST_LGN_DTTM = "";
	private String RGST_PRSN_ID = "";
	private String RGST_DTTM = "";
	private String UPD_PRSN_ID = "";
	private String UPD_DTTM = "";
	private String REG_PRSN_ID = "";
	
	private String SYS_AGR_YN = "";
	private String PRSN_INFO_AGR_YN = ""; 
	private String PRSN_INFO_CMM_AGR_YN = "";

	private String BIZR_STAT_CD = "";	//사업자 활동상태
	
	private String GRP_CD = "";
	private String GRP_NM = "";
	private String CG_DTSS_NO = "";		//담당 직매장 정보
	private String CET_BRCH_CD = "";	//센터지부코드
	private int LGN_ERR_TMS = 0;	//패스워드 오류횟수 5회이상 제한
	private int PWD_CHG_MM = 0;	//패스워드 변경유지기간 - 6개월
	
	private String CNTR_DT = "";	//약정일자 - 관리자 패스워드 변경요청시 사용
	private String BIZRNM = "";	//회사명
	private String LAST_LGN_DTTM = "";	//최종 로그인 시간 yyyy-mm-dd hh24:mi:ss
	
	private String ALT_REQ_STAT_CD = "";	//가입변경요청상태코드 - 사업자정보
	private String PRSN_INFO_CHG_AGR_YN = ""; // 개인정보취급방침 변경 동의
	private String AFF_OGN_CD = "";
	private String ATH_GRP_NM = "";
	private String ATH_SE_CD = "";
	
	private String ERP_CD = "";
	private String ERP_LK_DT = "";
	private String ERP_CFM_YN = "";
	private String ERP_CD_NM = "";
	
	private List<?> USER_MENU_LIST = new ArrayList();
	private HashMap<String, String> USER_TEXT_LIST = new HashMap<String, String>();
	
	private String ATH_GRP_CD = "";	//권한코드
	
	public String getATH_GRP_CD() {
		return ATH_GRP_CD;
	}
	public void setATH_GRP_CD(String aTH_GRP_CD) {
		ATH_GRP_CD = aTH_GRP_CD;
	}
	
	/**
	 * @return the uSER_ID
	 */
	public String getUSER_ID() {
		if(this.USER_ID == null) USER_ID = "";
		return USER_ID;
	}
	/**
	 * @param uSER_ID the uSER_ID to set
	 */
	public void setUSER_ID(String uSER_ID) {
		USER_ID = uSER_ID;
	}
	/**
	 * @return the uSER_NM
	 */
	public String getUSER_NM() {
		return USER_NM;
	}
	/**
	 * @param uSER_NM the uSER_NM to set
	 */
	public void setUSER_NM(String uSER_NM) {
		USER_NM = uSER_NM;
	}
	
	/**
	 * @return the uSER_PWD
	 */
	public String getUSER_PWD() {
		return USER_PWD;
	}
	/**
	 * @param uSER_PWD the uSER_PWD to set
	 */
	public void setUSER_PWD(String uSER_PWD) {
		USER_PWD = uSER_PWD;
	}
	/**
	 * @return the BIZRID
	 */
	public String getBIZRID() {
		return BIZRID;
	}
	/**
	 * @param BIZRID the BIZRID to set
	 */
	public void setBIZRID(String bIZRID) {
		BIZRID = bIZRID;
	}
	/**
	 * @return the bIZRNO
	 */
	public String getBIZRNO() {
		return BIZRNO;
	}
	/**
	 * @param bIZRNO the bIZRNO to set
	 */
	public void setBIZRNO(String bIZRNO) {
		BIZRNO = bIZRNO;
	}

	public String getBIZRNO_ORI() {
		return BIZRNO_ORI;
	}
	public void setBIZRNO_ORI(String bIZRNO_ORI) {
		BIZRNO_ORI = bIZRNO_ORI;
	}
	
	/**
	 * @return the mBR_SE_CD
	 */
//	public String getMBR_SE_CD() {
//		return MBR_SE_CD;
//	}
	/**
	 * @param mBR_SE_CD the mBR_SE_CD to set
	 */
//	public void setMBR_SE_CD(String mBR_SE_CD) {
//		MBR_SE_CD = mBR_SE_CD;
//	}
	/**
	 * @return the uSER_SE_CD
	 */
	public String getUSER_SE_CD() {
		return USER_SE_CD;
	}
	/**
	 * @param uSER_SE_CD the uSER_SE_CD to set
	 */
	public void setUSER_SE_CD(String uSER_SE_CD) {
		USER_SE_CD = uSER_SE_CD;
	}
	/**
	 * @return the uSER_STAT_CD
	 */
	public String getUSER_STAT_CD() {
		return USER_STAT_CD;
	}
	/**
	 * @param uSER_STAT_CD the uSER_STAT_CD to set
	 */
	public void setUSER_STAT_CD(String uSER_STAT_CD) {
		USER_STAT_CD = uSER_STAT_CD;
	}
	/**
	 * @return the eMAIL
	 */
	public String getEMAIL() {
		return EMAIL;
	}
	/**
	 * @param eMAIL the eMAIL to set
	 */
	public void setEMAIL(String eMAIL) {
		EMAIL = eMAIL;
	}
	/**
	 * @return the mBIL_PHON1
	 */
	public String getMBIL_NO1() {
		return MBIL_NO1;
	}
	/**
	 * @param mBIL_PHON1 the mBIL_PHON1 to set
	 */
	public void setMBIL_NO1(String mBIL_PHON1) {
		MBIL_NO1 = mBIL_PHON1;
	}
	/**
	 * @return the mBIL_PHON2
	 */
	public String getMBIL_NO2() {
		return MBIL_NO2;
	}
	/**
	 * @param mBIL_PHON2 the mBIL_PHON2 to set
	 */
	public void setMBIL_NO2(String mBIL_PHON2) {
		MBIL_NO2 = mBIL_PHON2;
	}
	/**
	 * @return the mBIL_PHON3
	 */
	public String getMBIL_NO3() {
		return MBIL_NO3;
	}
	/**
	 * @param mBIL_PHON3 the mBIL_PHON3 to set
	 */
	public void setMBIL_NO3(String mBIL_PHON3) {
		MBIL_NO3 = mBIL_PHON3;
	}
	/**
	 * @return the tEL_NO1
	 */
	public String getTEL_NO1() {
		return TEL_NO1;
	}
	/**
	 * @param tEL_NO1 the tEL_NO1 to set
	 */
	public void setTEL_NO1(String tEL_NO1) {
		TEL_NO1 = tEL_NO1;
	}
	/**
	 * @return the tEL_NO2
	 */
	public String getTEL_NO2() {
		return TEL_NO2;
	}
	/**
	 * @param tEL_NO2 the tEL_NO2 to set
	 */
	public void setTEL_NO2(String tEL_NO2) {
		TEL_NO2 = tEL_NO2;
	}
	/**
	 * @return the tEL_NO3
	 */
	public String getTEL_NO3() {
		return TEL_NO3;
	}
	/**
	 * @param tEL_NO3 the tEL_NO3 to set
	 */
	public void setTEL_NO3(String tEL_NO3) {
		TEL_NO3 = tEL_NO3;
	}
	/**
	 * @return the dEPT_CD
	 */
	public String getDEPT_CD() {
		return DEPT_CD;
	}
	/**
	 * @param dEPT_CD the dEPT_CD to set
	 */
	public void setDEPT_CD(String dEPT_CD) {
		DEPT_CD = dEPT_CD;
	}
	/**
	 * @return the pWD_ALT_REQ_YN
	 */
	public String getPWD_ALT_REQ_YN() {
		return PWD_ALT_REQ_YN;
	}
	/**
	 * @param pWD_ALT_REQ_YN the pWD_ALT_REQ_YN to set
	 */
	public void setPWD_ALT_REQ_YN(String pWD_ALT_REQ_YN) {
		PWD_ALT_REQ_YN = pWD_ALT_REQ_YN;
	}
	/**
	 * @return the pWD_ALT_DT
	 */
	public String getPWD_ALT_DT() {
		return PWD_ALT_DT;
	}
	/**
	 * @param pWD_ALT_DT the pWD_ALT_DT to set
	 */
	public void setPWD_ALT_DT(String pWD_ALT_DT) {
		PWD_ALT_DT = pWD_ALT_DT;
	}
	/**
	 * @return the lST_LGN_DTTM
	 */
	public String getLST_LGN_DTTM() {
		return LST_LGN_DTTM;
	}
	/**
	 * @param lST_LGN_DTTM the lST_LGN_DTTM to set
	 */
	public void setLST_LGN_DTTM(String lST_LGN_DTTM) {
		LST_LGN_DTTM = lST_LGN_DTTM;
	}
	/**
	 * @return the rGST_PRSN_ID
	 */
	public String getRGST_PRSN_ID() {
		return RGST_PRSN_ID;
	}
	/**
	 * @param rGST_PRSN_ID the rGST_PRSN_ID to set
	 */
	public void setRGST_PRSN_ID(String rGST_PRSN_ID) {
		RGST_PRSN_ID = rGST_PRSN_ID;
	}
	/**
	 * @return the rGST_DTTM
	 */
	public String getRGST_DTTM() {
		return RGST_DTTM;
	}
	/**
	 * @param rGST_DTTM the rGST_DTTM to set
	 */
	public void setRGST_DTTM(String rGST_DTTM) {
		RGST_DTTM = rGST_DTTM;
	}
	/**
	 * @return the uPD_PRSN_ID
	 */
	public String getUPD_PRSN_ID() {
		return UPD_PRSN_ID;
	}
	/**
	 * @param uPD_PRSN_ID the uPD_PRSN_ID to set
	 */
	public void setUPD_PRSN_ID(String uPD_PRSN_ID) {
		UPD_PRSN_ID = uPD_PRSN_ID;
	}
	/**
	 * @return the uPD_DTTM
	 */
	public String getUPD_DTTM() {
		return UPD_DTTM;
	}
	/**
	 * @param uPD_DTTM the uPD_DTTM to set
	 */
	public void setUPD_DTTM(String uPD_DTTM) {
		UPD_DTTM = uPD_DTTM;
	}
	/**
	 * @return the uSER_MENU_LIST
	 */
	public List<?> getUSER_MENU_LIST() {
		return USER_MENU_LIST;
	}
	/**
	 * @param uSER_MENU_LIST the uSER_MENU_LIST to set
	 */
	public void setUSER_MENU_LIST(List<?> uSER_MENU_LIST) {
		USER_MENU_LIST = uSER_MENU_LIST;
	}
	/**
	 * @return the uSER_TEXT_LIST
	 */
	public HashMap<String, String> getUSER_TEXT_LIST() {
		return USER_TEXT_LIST;
	}
	/**
	 * @param uSER_TEXT_LIST the uSER_TEXT_LIST to set
	 */
	public void setUSER_TEXT_LIST(HashMap<String, String> uSER_TEXT_LIST) {
		USER_TEXT_LIST = uSER_TEXT_LIST;
	}
	/**
	 * @return the gRP_CD
	 */
	public String getGRP_CD() {
		return GRP_CD;
	}
	/**
	 * @param gRP_CD the gRP_CD to set
	 */
	public void setGRP_CD(String gRP_CD) {
		GRP_CD = gRP_CD;
	}
	/**
	 * @return the gRP_NM
	 */
	public String getGRP_NM() {
		return GRP_NM;
	}
	/**
	 * @param gRP_NM the gRP_NM to set
	 */
	public void setGRP_NM(String gRP_NM) {
		GRP_NM = gRP_NM;
	}
	
	public String getBIZR_STAT_CD() {
		return BIZR_STAT_CD;
	}
	public void setBIZR_STAT_CD(String bIZR_STAT_CD) {
		BIZR_STAT_CD = bIZR_STAT_CD;
	}
	/**
	 * @return the sYS_AGR_YN
	 */
	public String getSYS_AGR_YN() {
		return SYS_AGR_YN;
	}
	/**
	 * @param sYS_AGR_YN the sYS_AGR_YN to set
	 */
	public void setSYS_AGR_YN(String sYS_AGR_YN) {
		SYS_AGR_YN = sYS_AGR_YN;
	}
	/**
	 * @return the pRSN_INFO_AGR_YN
	 */
	public String getPRSN_INFO_AGR_YN() {
		return PRSN_INFO_AGR_YN;
	}
	/**
	 * @param pRSN_INFO_AGR_YN the pRSN_INFO_AGR_YN to set
	 */
	public void setPRSN_INFO_AGR_YN(String pRSN_INFO_AGR_YN) {
		PRSN_INFO_AGR_YN = pRSN_INFO_AGR_YN;
	}
	/**
	 * @return the cG_DTSS_NO
	 */
	public String getCG_DTSS_NO() {
		return CG_DTSS_NO;
	}
	/**
	 * @param cG_DTSS_NO the cG_DTSS_NO to set
	 */
	public void setCG_DTSS_NO(String cG_DTSS_NO) {
		CG_DTSS_NO = cG_DTSS_NO;
	}
	/**
	 * @return the cET_BRCH_CD
	 */
	public String getCET_BRCH_CD() {
		return CET_BRCH_CD;
	}
	/**
	 * @param cET_BRCH_CD the cET_BRCH_CD to set
	 */
	public void setCET_BRCH_CD(String cET_BRCH_CD) {
		CET_BRCH_CD = cET_BRCH_CD;
	}
	/**
	 * @return the lGN_ERR_TMS
	 */
	public int getLGN_ERR_TMS() {
		return LGN_ERR_TMS;
	}
	/**
	 * @param lGN_ERR_TMS the lGN_ERR_TMS to set
	 */
	public void setLGN_ERR_TMS(int lGN_ERR_TMS) {
		LGN_ERR_TMS = lGN_ERR_TMS;
	}
	/**
	 * @return the pWD_CHG_MM
	 */
	public int getPWD_CHG_MM() {
		return PWD_CHG_MM;
	}
	/**
	 * @param pWD_CHG_MM the pWD_CHG_MM to set
	 */
	public void setPWD_CHG_MM(int pWD_CHG_MM) {
		PWD_CHG_MM = pWD_CHG_MM;
	}
	/**
	 * @return the cNTR_DT
	 */
	public String getCNTR_DT() {
		return CNTR_DT;
	}
	/**
	 * @param cNTR_DT the cNTR_DT to set
	 */
	public void setCNTR_DT(String cNTR_DT) {
		CNTR_DT = cNTR_DT;
	}
	
	public String getBIZRNM() {
		return BIZRNM;
	}
	public void setBIZRNM(String bIZRNM) {
		BIZRNM = bIZRNM;
	}
	/**
	 * @return the lAST_LGN_DTTM
	 */
	public String getLAST_LGN_DTTM() {
		return LAST_LGN_DTTM;
	}
	/**
	 * @param lAST_LGN_DTTM the lAST_LGN_DTTM to set
	 */
	public void setLAST_LGN_DTTM(String lAST_LGN_DTTM) {
		LAST_LGN_DTTM = lAST_LGN_DTTM;
	}
	/**
	 * @return the aLT_REQ_STAT_CD
	 */
	public String getALT_REQ_STAT_CD() {
		return ALT_REQ_STAT_CD;
	}
	/**
	 * @param aLT_REQ_STAT_CD the aLT_REQ_STAT_CD to set
	 */
	public void setALT_REQ_STAT_CD(String aLT_REQ_STAT_CD) {
		ALT_REQ_STAT_CD = aLT_REQ_STAT_CD;
	}
	/**
	 * @return the PRSN_INFO_CHG_AGR_YN
	 */
	public String getPRSN_INFO_CHG_AGR_YN() {
		return PRSN_INFO_CHG_AGR_YN;
	}
	/**
	 * @param PRSN_INFO_CHG_AGR_YN the PRSN_INFO_CHG_AGR_YN to set
	 */
	public void setPRSN_INFO_CHG_AGR_YN(String pRSN_INFO_CHG_AGR_YN) {
		PRSN_INFO_CHG_AGR_YN = pRSN_INFO_CHG_AGR_YN;
	}
	
	/**
	 * @return the AFF_OGN_CD
	 */
	public String getAFF_OGN_CD() {
		return AFF_OGN_CD;
	}
	/**
	 * @param AFF_OGN_CD the aFF_OGN_CD to set
	 */
	public void setAFF_OGN_CD(String aFF_OGN_CD) {
		AFF_OGN_CD = aFF_OGN_CD;
	}
	
	/**
	 * @return the ATH_GRP_NM
	 */
	public String getATH_GRP_NM() {
		return ATH_GRP_NM;
	}
	/**
	 * @param ATH_GRP_NM the aTH_GRP_NM to set
	 */
	public void setATH_GRP_NM(String aTH_GRP_NM) {
		ATH_GRP_NM = aTH_GRP_NM;
	}
	
	/**
	 * @return the ATH_SE_CD
	 */
	public String getATH_SE_CD() {
		return ATH_SE_CD;
	}
	/**
	 * @param ATH_SE_CD the aTH_SE_CD to set
	 */
	public void setATH_SE_CD(String aTH_SE_CD) {
		ATH_SE_CD = aTH_SE_CD;
	}
	
	
	/**
	 * @return the pRSN_INFO_CMM_AGR_YN
	 */
	public String getPRSN_INFO_CMM_AGR_YN() {
		return PRSN_INFO_CMM_AGR_YN;
	}
	/**
	 * @param pRSN_INFO_CMM_AGR_YN the pRSN_INFO_CMM_AGR_YN to set
	 */
	public void setPRSN_INFO_CMM_AGR_YN(String pRSN_INFO_CMM_AGR_YN) {
		PRSN_INFO_CMM_AGR_YN = pRSN_INFO_CMM_AGR_YN;
	}
	public String getBIZR_TP_CD() {
		return BIZR_TP_CD;
	}
	public void setBIZR_TP_CD(String bIZR_TP_CD) {
		BIZR_TP_CD = bIZR_TP_CD;
	}
	public String getBRCH_ID() {
		return BRCH_ID;
	}
	public void setBRCH_ID(String bRCH_ID) {
		BRCH_ID = bRCH_ID;
	}
	public String getBRCH_NO() {
		return BRCH_NO;
	}
	public void setBRCH_NO(String bRCH_NO) {
		BRCH_NO = bRCH_NO;
	}
	public String getREG_PRSN_ID() {
		return REG_PRSN_ID;
	}
	public void setREG_PRSN_ID(String rEG_PRSN_ID) {
		REG_PRSN_ID = rEG_PRSN_ID;
	}
	public String getPWD_ALT_REQ_DTTM() {
		return PWD_ALT_REQ_DTTM;
	}
	public void setPWD_ALT_REQ_DTTM(String pWD_ALT_REQ_DTTM) {
		PWD_ALT_REQ_DTTM = pWD_ALT_REQ_DTTM;
	}
	
	public String getERP_CD() {
		return ERP_CD;
	}
	public void setERP_CD(String eRP_CD) {
		ERP_CD = eRP_CD;
	}
	public String getERP_LK_DT() {
		return ERP_LK_DT;
	}
	public void setERP_LK_DT(String eRP_LK_DT) {
		ERP_LK_DT = eRP_LK_DT;
	}
	public String getERP_CFM_YN() {
		return ERP_CFM_YN;
	}
	public void setERP_CFM_YN(String eRP_CFM_YN) {
		ERP_CFM_YN = eRP_CFM_YN;
	}
	public String getERP_CD_NM() {
		return ERP_CD_NM;
	}
	public void setERP_CD_NM(String eRP_CD_NM) {
		ERP_CD_NM = eRP_CD_NM;
	}
	
}
