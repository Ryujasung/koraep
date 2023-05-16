package egovframework.koraep.ce.ep.service;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.security.GeneralSecurityException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Iterator;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.WebUtils;

import egovframework.common.AES256Util;
import egovframework.common.EgovFileMngUtil;
import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE0140101Mapper;
import egovframework.mapper.ce.ep.EPCE0160101Mapper;


@Service("epce0160131Service")
public class EPCE0160131Service {
	
	@Resource(name="epce0160101Mapper")
	private EPCE0160101Mapper epce0160101Mapper;
	
	@Resource(name="epce0140101Mapper")
	private EPCE0140101Mapper epce0140101Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 사업자등록화면 페이지
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0160131_select(ModelMap model, HttpServletRequest request)  {
		
		List<?> BizrStatList = commonceService.getCommonCdListNew("B002");//사업자구분
		List<?> BizrTpList = commonceService.getCommonCdListNew("B001");//사업자유형
		List<?> BankCdList = commonceService.getCommonCdListNew("S090");//은행리스트
		
		String title = commonceService.getMenuTitle("EPCE0160131");
		
		try {
			model.addAttribute("titleSub", title);
			model.addAttribute("BizrStatList", util.mapToJson(BizrStatList));
			model.addAttribute("BizrTpList", util.mapToJson(BizrTpList));
			model.addAttribute("BankCdList", util.mapToJson(BankCdList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		
		//조회조건 파라메터 정보
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);
		
		return model;
		
	}
	
	/**
	 * @throws Exception 
	 * 사업자등록
	 * @param 
	 * @param 
	 * @throws 
	 */
	@SuppressWarnings("unused")
	@Transactional
	public String epce0160131_insert(HttpServletRequest request, String corpState) throws Exception  {
		
			String errCd = "0000";
		
			try {
					
				//세션정보 가져오기
				HttpSession session = request.getSession();
				UserVO uvo = (UserVO)session.getAttribute("userSession");
				String ssUserId   = uvo.getUSER_ID();		//세션사용자ID
				
				AES256Util aes = null;
				try {
					aes = new AES256Util();
				} catch (UnsupportedEncodingException e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}
				//크로스 사이트 스크립트 수정 후 변경
//				MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
				MultipartHttpServletRequest mptRequest = WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
				Map<String, String> map = new HashMap<String, String>();
				
//				String pwd = uvo.getUSER_PWD();
				String BIZRNO = mptRequest.getParameter("BIZRNO1") + mptRequest.getParameter("BIZRNO2") + mptRequest.getParameter("BIZRNO3");
				
				/*
				String EMAIL = mptRequest.getParameter("EMAIL1") + "@" + mptRequest.getParameter("EMAIL2");
				if("EMAIL2" == null){
					EMAIL = mptRequest.getParameter("EMAIL1") + "@" + mptRequest.getParameter("DOMAIN");
				}
				
				String ASTN_EMAIL = mptRequest.getParameter("ASTN_EMAIL1") + "@" + mptRequest.getParameter("ASTN_EMAIL2");
				if("ASTN_EMAIL2" == null){
					ASTN_EMAIL = mptRequest.getParameter("ASTN_EMAIL1") + "@" + mptRequest.getParameter("ASTN_EMAIL_DOMAIN");
				}
				*/
				
//				if(ASTN_EMAIL.equals("@")) ASTN_EMAIL = "";
				
				String CNTR_DT = util.getShortDateString();
				
				//회원 API 발급키 암호화 - AES256 (사업자번호 + "|" + 약정일자 + "|" + 회원구분 + "|" + 관리자ID)
				String BIZR_ISSU_KEY = BIZRNO + "|" +CNTR_DT + "|" + mptRequest.getParameter("BIZR_TP_CD") + "|" + mptRequest.getParameter("USER_ID");	
				try {
					if(aes == null) throw new UnsupportedEncodingException();
					map.put("BIZR_ISSU_KEY", aes.encrypt(BIZR_ISSU_KEY));
				} catch (UnsupportedEncodingException | GeneralSecurityException e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}
				map.put("BIZR_TP_CD", mptRequest.getParameter("BIZR_TP_CD"));
				map.put("ADMIN_ID",mptRequest.getParameter("ADMIN_ID"));
				
				String sUserId   = uvo.getUSER_ID();
				
				//사업자 등록정보 셋팅
				String psnbSeq = commonceService.psnb_select("S0001");
				
				map.put("PSNB_SEQ", psnbSeq);
				String BIZRID = mptRequest.getParameter("BIZR_TP_CD") + mptRequest.getParameter("BIZR_SE_CD") + map.put("PSNB_SEQ", psnbSeq);
				map.put("BIZRID", BIZRID);
				map.put("BIZRNO", BIZRNO);
				map.put("BIZRNM", util.null2void(mptRequest.getParameter("BIZRNM")));
				map.put("BIZR_TP_CD", util.null2void(mptRequest.getParameter("BIZR_TP_CD")));
				map.put("BIZR_SE_CD", util.null2void(mptRequest.getParameter("BIZR_SE_CD")));
				map.put("RPST_NM", util.null2void(mptRequest.getParameter("RPST_NM")));
				map.put("ACP_BANK_CD", util.null2void(mptRequest.getParameter("AcpBankCdList_SEL")));
				map.put("ACP_ACCT_NO", util.null2void(mptRequest.getParameter("ACP_ACCT_NO")));
				map.put("ACP_ACCT_DPSTR_NM", util.null2void(mptRequest.getParameter("ACP_ACCT_DPSTR_NM")));
				map.put("BIZR_STAT_CD", util.null2void(mptRequest.getParameter("BIZR_STAT_CD"),"Y"));
				map.put("RPST_TEL_NO1", util.null2void(mptRequest.getParameter("RPST_TEL_NO1")));
				map.put("RPST_TEL_NO2", util.null2void(mptRequest.getParameter("RPST_TEL_NO2")));
				map.put("RPST_TEL_NO3", util.null2void(mptRequest.getParameter("RPST_TEL_NO3")));
				map.put("FAX_NO1", util.null2void(mptRequest.getParameter("FAX_NO1")));
				map.put("FAX_NO2", util.null2void(mptRequest.getParameter("FAX_NO2")));
				map.put("FAX_NO3", util.null2void(mptRequest.getParameter("FAX_NO3")));
				
				map.put("TEL_NO1", util.null2void(mptRequest.getParameter("TEL_NO1")));
				map.put("TEL_NO2", util.null2void(mptRequest.getParameter("TEL_NO2")));
				map.put("TEL_NO3", util.null2void(mptRequest.getParameter("TEL_NO3")));
				map.put("MBIL_NO1", util.null2void(mptRequest.getParameter("MBIL_NO1")));
				map.put("MBIL_NO2", util.null2void(mptRequest.getParameter("MBIL_NO2")));
				map.put("MBIL_NO3", util.null2void(mptRequest.getParameter("MBIL_NO3")));
				map.put("RPST_MBIL_NO1", util.null2void(mptRequest.getParameter("RPST_MBIL_NO1")));
				map.put("RPST_MBIL_NO2", util.null2void(mptRequest.getParameter("RPST_MBIL_NO2")));
				map.put("RPST_MBIL_NO3", util.null2void(mptRequest.getParameter("RPST_MBIL_NO3")));
				
				map.put("PNO", util.null2void(mptRequest.getParameter("PNO")));
				map.put("ADMIN_ID", util.null2void(mptRequest.getParameter("ADMIN_ID")));
				map.put("ADMIN_NM", util.null2void(mptRequest.getParameter("ADMIN_NM")));
				map.put("ADDR1", util.null2void(mptRequest.getParameter("ADDR1")));
				map.put("ADDR2", util.null2void(mptRequest.getParameter("ADDR2")));
				map.put("BCS_NM", util.null2void(mptRequest.getParameter("BCS_NM")));
				map.put("CNTR_DT", util.getShortDateString());
				map.put("REG_PRSN_ID", ssUserId);
				map.put("EMAIL", util.null2void(mptRequest.getParameter("EMAIL")));
				map.put("ASTN_EMAIL", util.null2void(mptRequest.getParameter("ASTN_EMAIL")));
				map.put("MFC_VACCT_BANK_CD", "003");
				map.put("ELTR_SIGN", util.null2void(mptRequest.getParameter("ELTR_SIGN")));
				map.put("ELTR_SIGN_LENG", util.null2void(mptRequest.getParameter("ELTR_SIGN_LENG")));
				
				//ERP사업자코드 채번
				String erpBizrCd = "2" + commonceService.psnb_select("S0002"); 
				map.put("ERP_BIZR_CD", erpBizrCd); //ERP사업자코드
				
				map.put("MFC_DPS_VACCT_NO", util.null2void(mptRequest.getParameter("MFC_DPS_VACCT_NO")));
				map.put("MFC_FEE_VACCT_NO", util.null2void(mptRequest.getParameter("MFC_FEE_VACCT_NO")));
				map.put("TOB_NM", util.null2void(mptRequest.getParameter("TOB_NM")));
				map.put("ALT_REQ_STAT_CD", util.null2void(mptRequest.getParameter("ALT_REQ_STAT_CD"),"0"));
				map.put("S_USER_ID", sUserId);
				map.put("USER_ID", util.null2void(mptRequest.getParameter("ADMIN_ID")));
				
				map.put("RUN_STAT_CD", util.null2void(corpState)); //휴폐업상태
				
				epce0160101Mapper.epce0160131_insert(map);		//사업자 정보 등록
				epce0160101Mapper.epce0160131_insert2(map);		//사업자 변경이력 등록
				epce0160101Mapper.epce0160131_insert6(map);		//지점 정보 등록
				
				if(map.containsKey("ADMIN_ID") && !map.get("ADMIN_ID").equals("") && map.get("BIZR_SE_CD").equals("S")){
					map.put("USER_PWD", util.encrypt("12345678"));
					map.put("USER_STAT_CD", "Y");
					map.put("CET_BRCH_CD", "");
					map.put("USER_SE_CD", "D");
					epce0160101Mapper.epce0160131_insert7(map);  //담당자 등록
				}
				
				/*
				UserVO userVo = new UserVO();
				userVo.setUSER_ID(util.null2void(mptRequest.getParameter("USER_ID")));
				userVo.setUSER_ID(ssUserId);
				userVo.setUSER_NM(util.null2void(mptRequest.getParameter("USER_NM")));
//				userVo.setBIZRNO(BIZRNO);
				userVo.setUSER_SE_CD(util.null2void(mptRequest.getParameter("USER_SE_CD"),"1"));
				userVo.setUSER_STAT_CD(util.null2void(mptRequest.getParameter("USER_STAT_CD"),"1"));
				userVo.setCET_BRCH_CD(util.null2void(mptRequest.getParameter("CET_BRCH_CD")));
//				userVo.setUSER_PWD(util.encrypt(pwd));
				userVo.setEMAIL(EMAIL);
				userVo.setMBIL_PHON1(util.null2void(mptRequest.getParameter("MBIL_PHON1")));
				userVo.setMBIL_PHON2(util.null2void(mptRequest.getParameter("MBIL_PHON2")));
				userVo.setMBIL_PHON3(util.null2void(mptRequest.getParameter("MBIL_PHON3")));
				userVo.setTEL_NO1(util.null2void(mptRequest.getParameter("TEL_NO1")));
				userVo.setTEL_NO2(util.null2void(mptRequest.getParameter("TEL_NO2")));
				userVo.setTEL_NO3(util.null2void(mptRequest.getParameter("TEL_NO3")));
				userVo.setDEPT_CD(util.null2void(mptRequest.getParameter("DEPT_NM")));
				userVo.setREG_PRSN_ID(sUserId);
				userVo.setSYS_AGR_YN("Y");
				userVo.setPRSN_INFO_AGR_YN("Y");
				userVo.setPRSN_INFO_CMM_AGR_YN("Y");
				*/
				
				//epce0160101Mapper.epce0160101_update4(map);
				//epce0160101Mapper.epce0160131_insert5(map);	
				
				//사업자 등록증 등록
				String FILE_NM = "";
				String SAVE_FILE_NM = "";
				String FILE_PATH = "";
		    	Iterator fileIter = mptRequest.getFileNames();
		    	int nRow = 0;
				while (fileIter.hasNext()) {
					MultipartFile mFile = mptRequest.getFile((String)fileIter.next());
					
					if (mFile.getSize() > 0) {
				    	HashMap map2 = new HashMap();
						try {
							map2 = EgovFileMngUtil.uploadBizFile(mFile);
						} catch (Exception e) {
							// TODO Auto-generated catch block
							org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
						}	//파일저장
				    	SAVE_FILE_NM = (String)map2.get("uploadFileName");
				    	FILE_NM      = (String)map2.get("originalFileName");
				    	FILE_PATH    = (String)map2.get("filePath");
				    	
				    	HashMap<String, String> fileMap = new HashMap<String, String>(); 
						fileMap.put("BIZRID", BIZRID);
						fileMap.put("BIZRNO", BIZRNO);
						fileMap.put("FILE_NM", FILE_NM);
						fileMap.put("SAVE_FILE_NM", SAVE_FILE_NM);
						fileMap.put("FILE_PATH", FILE_PATH);
						fileMap.put("REG_PRSN_ID", uvo.getUSER_ID());

						if(nRow == 0){
							if(!FILE_NM.equals("")){
								epce0160101Mapper.epce0160131_insert3(fileMap);
							}
						}
						else{
							if(!FILE_NM.equals("")){
								epce0160101Mapper.epce0160131_insert4(fileMap);
							}
						}
						
					}
					
					nRow++;
					
				}
				
				//메뉴권한 부여 필요..
				
				//메뉴권한그룹 등록
//				HashMap<String, String> map3 = new HashMap<String, String>();
//				map3.put("BIZRID", BIZRID);
//				map3.put("BIZRNO", BIZRNO);
//				map3.put("ATH_GRP_CD", mptRequest.getParameter("BIZR_SE_CD") + "01");	//관리자
//				map3.put("USER_ID", uvo.getUSER_ID());
//				map3.put("S_USER_ID", sUserId);
//				map3.put("REG_PRSN_ID", sUserId);
//				map3.put("S_USER_ID", "");
//				if(uvo != null){
//					map3.put("S_USER_ID", uvo.getUSER_ID());
//				}
//				epce0140101Mapper.epce0140188_update(map3);
				
			}catch(Exception e){
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return errCd;

	}
	
	/**
	 * 관리자 아이디 중복체크
	 * @param model
	 * @param request
	 * @
	 */

	public String epce0160131_2_check(HashMap<String, String> map) {
		
		String rtn = "Y";
		
		int cnt = epce0160101Mapper.epce01601311_select(map);
		if(cnt > 0) rtn = "N";
		
		return rtn;
	}

	/**
	 * 사업자번호 중복체크
	 * @param model
	 * @param request
	 * @
	 */

	public String epce0160131_3_check(HashMap<String, String> map) {
		String rtn = "Y";
		
		int cnt = epce0160101Mapper.epce01601311_select2(map);
		if(cnt > 0) rtn = "N";
		
		return rtn;
	}
	
	/**
	 * 휴대번호 중복체크
	 * @param model
	 * @param request
	 * @
	 */

	public String epce0160131_4_check(HashMap<String, String> map) {
		
		String rtn = "Y";
		
		int cnt = epce0160101Mapper.epce01601311_select3(map);
		if(cnt > 0) rtn = "N";
		
		return rtn;
	}
	
}