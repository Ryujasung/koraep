package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

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
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE0085201Mapper;
import egovframework.mapper.ce.ep.EPCE0160101Mapper;

/**
 * 회원관리 서비스
 * @author Administrator
 *
 */
@Service("epce0085201Service")
public class EPCE0085201Service {

	@Resource(name="epce0085201Mapper")
	private EPCE0085201Mapper epce0085201Mapper;
	
	@Resource(name="epce0160101Mapper")
	private EPCE0160101Mapper epce0160101Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 사업자번호 확인
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce00852012_select(Map<String, String> data) {
		
		List<?> bizrInfo = epce0085201Mapper.epce00852012_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("bizrInfo", util.mapToJson(bizrInfo));
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
	}
	
	/**
	 * 정보등록
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0085201_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);

		HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		
		try {
			
			model.addAttribute("CNTR_DT", util.getShortDateString());	//약정일자 시스템 현재일자 리턴
			
			List<?> bankCdList = commonceService.getCommonCdListNew("S090");//은행리스트
			model.addAttribute("bankCdList", util.mapToJson(bankCdList));
			
			List<?> areaList = commonceService.getCommonCdListNew("B010");//지역
			model.addAttribute("areaList", util.mapToJson(areaList));
			
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 정보등록2
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0085201_select2(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);

		HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		
		try {
			
			model.addAttribute("CNTR_DT", util.getShortDateString());	//약정일자 시스템 현재일자 리턴
			
			if(param.get("BIZR_TP_CD").equals("T1")){
				List<?> brchList = commonceService.getCommonCdListNew("B009");//센터지부
				model.addAttribute("brchList", util.mapToJson(brchList));
			}else{
				List<?> brchList = epce0085201Mapper.epce00852012_select2(param); //지점
				model.addAttribute("brchList", util.mapToJson(brchList));
			}
			
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}

	/**
	 * @throws Exception 
	 * 정보 등록
	 * @param 
	 * @param 
	 * @throws 
	 */
	@SuppressWarnings("unused")
	@Transactional
	public String epce00852013_insert(HttpServletRequest request, String corpState) throws Exception  {
		
			String errCd = "0000";
		
			try {
					
				String ssUserId   = "";		//세션사용자ID
				
				AES256Util aes = null;
				try {
					aes = new AES256Util();
				} catch (UnsupportedEncodingException e) {
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}
				//크로스 사이트 스크립트 수정 후 변경
//				MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
				MultipartHttpServletRequest mptRequest = WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
				
				Map<String, String> map = new HashMap<String, String>();
				
				String BIZRNO = mptRequest.getParameter("BIZRNO1") + mptRequest.getParameter("BIZRNO2") + mptRequest.getParameter("BIZRNO3");
				String CNTR_DT = util.getShortDateString();
				
				//회원 API 발급키 암호화 - AES256 (사업자번호 + "|" + 약정일자 + "|" + 회원구분 + "|" + 관리자ID)
				String BIZR_ISSU_KEY = BIZRNO + "|" +CNTR_DT + "|" + mptRequest.getParameter("BIZR_TP_CD") + "|" + mptRequest.getParameter("ADMIN_ID");	
				try {
					if (aes != null) {
						map.put("BIZR_ISSU_KEY", aes.encrypt(BIZR_ISSU_KEY));
					}
				} catch (UnsupportedEncodingException | GeneralSecurityException e) {
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}

				
				map.put("BIZRNO", BIZRNO);
				map.put("BIZRNM", util.null2void(mptRequest.getParameter("BIZRNM")));
				map.put("BIZR_TP_CD", util.null2void(mptRequest.getParameter("BIZR_TP_CD")));
				map.put("BIZR_SE_CD", "S");
				map.put("RPST_NM", util.null2void(mptRequest.getParameter("RPST_NM")));
				map.put("ACP_BANK_CD", util.null2void(mptRequest.getParameter("ACP_BANK_CD")));
				map.put("ACP_ACCT_NO", util.null2void(mptRequest.getParameter("ACP_ACCT_NO")));
				map.put("ACP_ACCT_DPSTR_NM", util.null2void(mptRequest.getParameter("ACP_ACCT_DPSTR_NM")));
				map.put("BIZR_STAT_CD", "W"); //승인대기
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
				map.put("RPST_MBIL_NO1", util.null2void(mptRequest.getParameter("TMP_PHON1")));
				map.put("RPST_MBIL_NO2", util.null2void(mptRequest.getParameter("TMP_PHON2")));
				map.put("RPST_MBIL_NO3", util.null2void(mptRequest.getParameter("TMP_PHON3")));
				map.put("PNO", util.null2void(mptRequest.getParameter("PNO")));
				map.put("ADMIN_ID", util.null2void(mptRequest.getParameter("ADMIN_ID")));
				map.put("ADMIN_NM", util.null2void(mptRequest.getParameter("ADMIN_NM")));
				map.put("ADDR1", util.null2void(mptRequest.getParameter("ADDR1")));
				map.put("ADDR2", util.null2void(mptRequest.getParameter("ADDR2")));
				map.put("BCS_NM", util.null2void(mptRequest.getParameter("BCS_NM")));
				map.put("TOB_NM", util.null2void(mptRequest.getParameter("TOB_NM")));
				map.put("CNTR_DT", CNTR_DT);
				map.put("REG_PRSN_ID", ssUserId);
				map.put("EMAIL", util.null2void(mptRequest.getParameter("EMAIL")));
				map.put("ASTN_EMAIL", util.null2void(mptRequest.getParameter("ASTN_EMAIL")));
				map.put("MFC_VACCT_BANK_CD", "");
				map.put("ELTR_SIGN", util.null2void(mptRequest.getParameter("ELTR_SIGN")));
				map.put("ELTR_SIGN_LENG", util.null2void(mptRequest.getParameter("ELTR_SIGN_LENG")));
				
				map.put("AREA_CD", util.null2void(mptRequest.getParameter("AREA_CD")));
				
				//ERP사업자코드 채번
				String erpBizrCd = "2" + commonceService.psnb_select("S0002"); 
				map.put("ERP_BIZR_CD", erpBizrCd); //ERP사업자코드

				map.put("MFC_DPS_VACCT_NO", util.null2void(mptRequest.getParameter("MFC_DPS_VACCT_NO")));
				map.put("MFC_FEE_VACCT_NO", util.null2void(mptRequest.getParameter("MFC_FEE_VACCT_NO")));
				map.put("ALT_REQ_STAT_CD", "1"); //신규가입
				map.put("S_USER_ID", ssUserId);
				map.put("USER_ID", util.null2void(mptRequest.getParameter("ADMIN_ID")));
				map.put("ADMIN_ID",mptRequest.getParameter("ADMIN_ID"));
				
				map.put("RUN_STAT_CD", util.null2void(corpState));
				
				String BIZRID = "";
				//사업자 확인
				List<?> bizrInfo = epce0085201Mapper.epce00852012_select3(map);
				if(bizrInfo.size() > 0){
					
					Map<String, String> bizrMap = (Map<String, String>)bizrInfo.get(0);
					map.put("BIZRID", bizrMap.get("BIZRID"));
					BIZRID = bizrMap.get("BIZRID");
					
					epce0160101Mapper.epce0160131_update(map); //사업자 정보 업데이트
					epce0160101Mapper.epce0160131_update2(map); //지점 정보 업데이트
					
					List<?> brchInfo = epce0085201Mapper.epce00852012_select4(map);
					
					if(brchInfo.size() > 0){
						Map<String, String> brchMap = (Map<String, String>)brchInfo.get(0);
						
						map.put("BRCH_ID", brchMap.get("BRCH_ID"));
						map.put("BRCH_NO", brchMap.get("BRCH_NO"));
					}
					else {
						throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					}
					
					
				}else{
					
					//사업자 아이디 일련번호
					String psnbSeq = commonceService.psnb_select("S0001");
					
					map.put("PSNB_SEQ", psnbSeq);
					BIZRID = mptRequest.getParameter("BIZR_TP_CD") + "S" + map.put("PSNB_SEQ", psnbSeq);
					
					map.put("BIZRID", BIZRID);
					
					epce0160101Mapper.epce0160131_insert(map);		//사업자 정보 등록
					epce0160101Mapper.epce0160131_insert6(map);		//지점 정보 등록
				}
				
				epce0160101Mapper.epce0160131_insert2(map);		//사업자 변경이력 등록

				map.put("USER_PWD", util.encrypt(util.null2void(mptRequest.getParameter("PWD"))));
				map.put("USER_STAT_CD", "W");
				map.put("USER_SE_CD", "D");
				map.put("CET_BRCH_CD", "");
				epce0160101Mapper.epce0160131_insert7(map);  //담당자 등록

				//메뉴권한 부여
				Map<String, String> athMap = new HashMap<String, String>();
				athMap.put("USER_ID", map.get("USER_ID"));
				athMap.put("S_USER_ID", ssUserId);
				athMap.put("BIZR_TP_CD", map.get("BIZR_TP_CD"));
				commonceService.ath_grp_insert(athMap);
				
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
						}catch (IOException io) {
							io.getMessage();
						}catch (SQLException sq) {
							sq.getMessage();
						}catch (NullPointerException nu){
							nu.getMessage();
						}catch (Exception e) {
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
						fileMap.put("REG_PRSN_ID", ssUserId);

						if(nRow == 0){
							if(!FILE_NM.equals("")){
								epce0160101Mapper.epce0160116_delete2(fileMap);
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
			}catch (IOException io) {
				io.getMessage();
			}catch (SQLException sq) {
				sq.getMessage();
			}catch (NullPointerException nu){
				nu.getMessage();
			}catch(Exception e){
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return errCd;

	}
	
	/**
	 * @throws Exception 
	 * 정보 등록
	 * @param 
	 * @param 
	 * @throws 
	 */
	@SuppressWarnings("unused")
	@Transactional
	public String epce00852015_insert(HttpServletRequest request) throws Exception  {
		
			String errCd = "0000";
		
			try {
					
				String ssUserId   = "";		//세션사용자ID

				Map<String, String> map = new HashMap<String, String>();

				String BIZRNO = request.getParameter("BIZRNO1") + request.getParameter("BIZRNO2") + request.getParameter("BIZRNO3");
				String BRCH_ID_NO = request.getParameter("BRCH");

				if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
					String[] aStr = BRCH_ID_NO.split(";");
					
					if(aStr.length > 1) {
						map.put("BRCH_ID", BRCH_ID_NO.split(";")[0]);
						map.put("BRCH_NO", BRCH_ID_NO.split(";")[1]);
						map.put("CET_BRCH_CD", "");
					}
					else {
						map.put("BRCH_ID", "T100001321");
						map.put("BRCH_NO", "9999999999");
						map.put("CET_BRCH_CD", BRCH_ID_NO);
					}
				}
				
				map.put("BIZR_TP_CD", util.null2void(request.getParameter("BIZR_TP_CD")));
				map.put("BIZRID", util.null2void(request.getParameter("BIZRID")));
				map.put("BIZRNO", BIZRNO);
				map.put("TEL_NO1", util.null2void(request.getParameter("TEL_NO1")));
				map.put("TEL_NO2", util.null2void(request.getParameter("TEL_NO2")));
				map.put("TEL_NO3", util.null2void(request.getParameter("TEL_NO3")));
				map.put("MBIL_NO1", util.null2void(request.getParameter("MBIL_NO1")));
				map.put("MBIL_NO2", util.null2void(request.getParameter("MBIL_NO2")));
				map.put("MBIL_NO3", util.null2void(request.getParameter("MBIL_NO3")));

				map.put("ADMIN_NM", util.null2void(request.getParameter("ADMIN_NM")));
				map.put("EMAIL", util.null2void(request.getParameter("EMAIL")));
				map.put("REG_PRSN_ID", ssUserId);
				
				map.put("ALT_REQ_STAT_CD", util.null2void(request.getParameter("ALT_REQ_STAT_CD"),"0"));
				map.put("S_USER_ID", ssUserId);
				map.put("USER_ID", util.null2void(request.getParameter("ADMIN_ID")));

				map.put("USER_PWD", util.encrypt(util.null2void(request.getParameter("PWD"))));
				map.put("USER_STAT_CD", "W");
				map.put("USER_SE_CD", "S");
				epce0160101Mapper.epce0160131_insert7(map);  //담당자 등록

				//메뉴권한 부여
				/* 업무사용자는 부여안함
				Map<String, String> athMap = new HashMap<String, String>();
				athMap.put("USER_ID", map.get("USER_ID"));
				athMap.put("S_USER_ID", ssUserId);
				athMap.put("BIZR_TP_CD", map.get("BIZR_TP_CD"));
				commonceService.ath_grp_insert(athMap);
				*/
				
			}catch (IOException io) {
				io.getMessage();
			}catch (SQLException sq) {
				sq.getMessage();
			}catch (NullPointerException nu){
				nu.getMessage();
			}catch(Exception e){
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return errCd;

	}
}
