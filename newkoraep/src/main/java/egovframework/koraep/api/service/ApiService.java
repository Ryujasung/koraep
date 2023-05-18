package egovframework.koraep.api.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.SocketException;
import java.net.URLDecoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.api.ApiMapper;
import egovframework.mapper.ce.ep.EPCE2910131Mapper;
import egovframework.mapper.ce.ep.EPCE2925801Mapper;
import egovframework.mapper.ce.ep.EPCE6645231Mapper;
import egovframework.mapper.ce.ep.EPCE6652931Mapper;
import egovframework.mapper.wh.ep.EPWH2910131Mapper;

/**
 * @author Administrator
 *
 */
@Service("apiService")
public class ApiService {

	private static final Logger log = LoggerFactory.getLogger(ApiService.class);

	@Resource(name = "apiMapper")
	private ApiMapper apiMapper;

	@Resource(name = "epce6652931Mapper")
	private EPCE6652931Mapper epce6652931Mapper;

	@Resource(name = "epce2925801Mapper")
	private EPCE2925801Mapper epce2925801Mapper;

	@Resource(name = "epce6645231Mapper")
	private EPCE6645231Mapper epce6645231Mapper;

	@Resource(name = "epwh2910131Mapper")
	private EPWH2910131Mapper epwh2910131Mapper;

	@Resource(name = "epce2910131Mapper")
	private EPCE2910131Mapper epce2910131Mapper; // 반환내역서등록 Mapper

	@Resource(name = "commonceService")
	private CommonCeService commonceService;

	/**
	 * API수신이력 순번 채번
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	public int regSnSeq() throws Exception {

		int seq = 0;

		try {

			seq = apiMapper.SELECT_EPCN_API_DTL_HIST_SEQ();

		}catch (IOException io) {
			io.printStackTrace();
		}catch (SQLException sq) {
			sq.printStackTrace();
		}catch (NullPointerException nu){
			nu.printStackTrace();
		} catch (Exception e) {
			seq = 999999999;
			; // "DB처리중 오류가 발생하였습니다. 관리자에게 문의하세요."
			throw new Exception("B003");
		} finally {

		}

		return seq; // 정상처리

	}

	/**
	 * API수신이력 등록
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	public String regApiDtlHist(HttpServletRequest request,
			Map<String, String> data) throws Exception {

		String errCd = "0000";

		try {

			apiMapper.INSERT_EPCN_API_DTL_HIST(data);

		} catch (SQLException e) {
			// log.debug("==================SQLException===============");
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			errCd = "B003"; // "DB처리중 오류가 발생하였습니다. 관리자에게 문의하세요."
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			throw new Exception(errCd);
		} catch (Exception e) {
			errCd = "B003"; // "DB처리중 오류가 발생하였습니다. 관리자에게 문의하세요."
			// log.debug("==================Exception===============" +
			// e.getMessage());
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			throw new Exception(errCd);
		} finally {
			// if(dis != null) dis.close();
		}

		return errCd;
	}

	/**
	 * API수신이력 결과 반영
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	public String updateApiDtlHist(HttpServletRequest request,
			Map<String, String> data) throws Exception {

		String errCd = "0000";

		try {

			apiMapper.UPDATE_EPCN_API_DTL_HIST_ANSR(data);

		}catch (IOException io) {
			io.printStackTrace();
		}catch (SQLException sq) {
			sq.printStackTrace();
		}catch (NullPointerException nu){
			nu.printStackTrace();
		} catch (Exception e) {
			errCd = "B003"; // "DB처리중 오류가 발생하였습니다. 관리자에게 문의하세요."
			// log.debug("==================Exception===============" +
			// e.getMessage());
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			throw new Exception(errCd);
		} finally {
			// if(dis != null) dis.close();
		}

		return errCd;
	}

	/**
	 * json data 수신
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	public String recvJsonData(HttpServletRequest request,
			Map<String, String> data) throws Exception {

		String errCd = "0000";
		boolean secure = request.isSecure();
		// if(!secure) return "B002"; //요청방식 오류 ##임시
		// 주석처리########################
		// BufferedReader dis = null;
		try {
			/*
			 * StringBuffer sb = new StringBuffer(); String str = ""; dis = new
			 * BufferedReader( new InputStreamReader( request.getInputStream() )
			 * ); while( (str = dis.readLine()) !=null) {
			 * sb.append(URLDecoder.decode(str, "utf-8")); }
			 */
			// data = JSONObject.fromObject(sb.toString());
			String erpCd = "";
			String busiNo = data.get("BIZRNO"); // 사업자번호
			String regDiv = data.get("REG_DIV"); // 등록구분 : I-신규,
			String recvKey = data.get("MBR_ISSU_KEY"); // 발급키
			String apiId = data.get("API_ID"); // 요청API
			System.out.println("data" + data);
			// 인증키 검증
			HashMap<String, String> keyMap = apiMapper
					.SELECT_API_MBR_ISSU_KEY(busiNo);
			if (keyMap == null || !keyMap.get("BIZR_STAT_CD").equals("Y")) {
				// return "B005"; //미등록 또는 활동정지 사업자 입니다.
				throw new Exception("B005");
			} else if (!keyMap.get("BIZR_ISSU_KEY").equals(recvKey)) {
				// return "B006"; //"발급키 인증 오류입니다."
				throw new Exception("B006");
			}
			if (apiId.equals("AP_R99"))
				return "0000"; // api 테스트인경우

			log.debug("==================start===============");

			// 수신이력(실행) 등록
			if (regDiv.equals("I")) {
				regDiv = "C";
			} else if (apiId.equals("AP_R07") && regDiv.equals("T")) { // 반환내역등록
																		// ERP_CD
																		// 등록요청
				erpCd = data.get("ERP_CD");
				if (erpCd == null || erpCd == "") {
					return "B001"; // "수신 데이터가 없습니다.";
				} else {
					apiMapper.UPDATE_AP_R07_ERP_CD(data);
				}
				return "0000";
			} else {
				throw new Exception("B010"); // 등록구분 오류
			}

			// 오류검색때 인서트함
			// this.insertRecvHist(busiNo, apiId, recvKey, request); //api호출
			// 이력등록

			// 데이타 읽기
			List<?> list = JSONArray.fromObject(data.get("REPT_REC"));

			System.out.println("list" + list);
			System.out.println("apiId" + apiId);
			if (list == null || list.size() == 0)
				return "B001"; // "수신 데이터가 없습니다.";
			if (apiId.equals("AP_R01")) {// 출고 자료 등록
				errCd = AP_R01(list, busiNo, data.get("TRMS_DT"),
						data.get("TRMS_TKTM"));
			} else if (apiId.equals("AP_R02")) { // 직접배송정보등록
				// errCd = AP_R02(list, busiNo, data.get("TRMS_DT"),
				// data.get("TRMS_TKTM"));
			} else if (apiId.equals("AP_R03") || apiId.equals("AP_R04")) { // 회수정보등록
																			// -
																			// 도매,
																			// 소매
				errCd = AP_R03(list, busiNo, data.get("TRMS_DT"), data.get("TRMS_TKTM"), regDiv);
			} else if (apiId.equals("AP_R06")) { // 직접회수정보등록
				errCd = AP_R06(list, busiNo, data.get("TRMS_DT"),
						data.get("TRMS_TKTM"));
			} else if (apiId.equals("AP_R07")) { // 반환내역등록
				errCd = AP_R07(list, busiNo, data.get("TRMS_DT"),
						data.get("TRMS_TKTM"), data.get("REG_SN"));
			} else if (apiId.equals("AP_R08")) { // 생산자 빈용기정보 등록
				errCd = AP_R08(list, busiNo, data.get("TRMS_DT"),
						data.get("TRMS_TKTM"));
			} else if (apiId.equals("AP_R09")) { // 생산자입고 등록
				errCd = AP_R09(list, busiNo, data.get("TRMS_DT"),
						data.get("TRMS_TKTM"));
			} else {
				// return "B007"; //미존재 api id
				throw new Exception("B007");
			}

			// dis.close();

		} catch (IOException e) {
			errCd = "B999"; // "파일 수신오류"
			throw new Exception(errCd);
		} catch (SQLException e) {
			log.debug("==================SQLException===============");
			e.printStackTrace();
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			errCd = "B003"; // "DB처리중 오류가 발생하였습니다. 관리자에게 문의하세요."
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			throw new Exception(errCd);
		} catch (JSONException e) {
			errCd = "B009"; // "json 형식 불일치"
			throw new Exception(errCd);
		} catch (Exception e) {
			log.debug("==================Exception==============="+ e.getMessage());
			log.debug("==================Exception===============" + e.toString());
			e.printStackTrace();
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			if (e.getMessage() != null && e.getMessage().indexOf("A0") > -1)
				errCd = e.getMessage();
			if ("0000".equals(errCd))
				errCd = "B003"; // "DB처리중 오류가 발생하였습니다. 관리자에게 문의하세요."
			throw new Exception(errCd);
		} finally {
			// if(dis != null) dis.close();
		}

		return errCd; // 정상처리
	}

	/**
	 * 출고 정보 등록 - 전일 추고 일 마감 자료
	 * 
	 * @param list
	 * @param TRMS_DT
	 * @param TRMS_TKTM
	 * @return
	 * @throws Exception
	 */

	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String AP_R01(List<?> list, String busiNo, String TRMS_DT,
			String TRMS_TKTM) throws Exception {
		String sysSe = "A"; // 기타코드테이블(그룹코드: S004)(W:웹시스템, A:연계API)
		String statCd = "RG"; // 기타코드테이블(그룹코드: D011)(RG: 출고등록, IB: 고지등록, AC:
								// 수납확인)
		String rmk = "";
		String regDt = util.getShortDateString(); // 일자로 변경
													// util.getTodayString();
		String errCd = "0000";
		try {
			/*
			 * //중복 체크 Map<String, String> chkMap = new HashMap<String,
			 * String>(); chkMap.put("DLIVY_RGST_DT", regDt);
			 * chkMap.put("MFC_BIZRNO", busiNo); chkMap.put("SYS_SE", sysSe);
			 * int dupCnt = apiMapper.SELECT_DUPLE_CHECK_AP_R01(chkMap);
			 * if(dupCnt > 0){ errCd = "B008"; //이미 기존처리 데이타 존재 throw new
			 * Exception(errCd); }
			 */

			for (int i = 0; i < list.size(); i++) {
				Map<String, String> map = (Map<String, String>) list.get(i);
				map.put("DLIVY_REG_DT", regDt);
				map.put("MFC_BIZRNO", busiNo);
				map.put("REG_PRSN_ID", "API");

				/*
				 * int sel = apiMapper.SELECT_DUPLE_CHECK_AP_R01(map); //중복체크
				 * if(sel>0){ throw new Exception("B008"); //이미 기존처리 데이타 존재 }
				 */

				// 수량이 소수점으로 들어올경우 차단
				if (map.get("DLIVY_QTY").indexOf(".") > -1) {
					throw new Exception("B022"); // 소수점 등록이 불가능합니다.
				}

				if (map.get("DTSS_NO").equals("0000000000")
						&& map.get("WHSLD_BIZRNO").equals("0000000000")) { // 집계
																			// 데이타
																			// 인경우
					/*
					 * //MFC_BIZRNO ,DLIVY_DT ,STD_CTNR_CD
					 * ,DLIVY_QTY,RGST_PRSN_ID
					 * log.debug("=========집계 data================");
					 * log.debug("DLIVY_DT=========" + map.get("DLIVY_DT"));
					 * //출고일자 log.debug("STD_CTNR_CD=========" +
					 * map.get("STD_CTNR_CD")); //표준용기코드
					 * log.debug("DLIVY_QTY=========" + map.get("DLIVY_QTY"));
					 * //출고수량
					 */
					apiMapper.INSERT_AP_R01_EPDM_DLIVY_LST_TMP(map);

				} else { // 출고데이타
					/*
					 * //MFC_BIZRNO ,DTSS_NO, WHSLD_BIZRNO, DLIVY_DT,
					 * STD_CTNR_CD, SYS_SE //, DLIVY_STAT_CD, DLIVY_QTY,
					 * WHSLD_ENP_NM, RMK, RGST_PRSN_ID
					 * log.debug("=====row data========");
					 * log.debug("DLIVY_DT=========" + map.get("DLIVY_DT"));
					 * //출고일자 log.debug("DTSS_NO=========" +
					 * map.get("DTSS_NO")); //직매장번호(물류센터)
					 * log.debug("WHSLD_BIZRNO=========" +
					 * map.get("WHSLD_BIZRNO")); //거래처 사업자 번호
					 * log.debug("STD_CTNR_CD=========" +
					 * map.get("STD_CTNR_CD")); //표준용기코드
					 * log.debug("DLIVY_QTY=========" + map.get("DLIVY_QTY"));
					 * //출고수량 log.debug("WHSLD_ENP_NM=========" +
					 * map.get("WHSLD_ENP_NM")); //거래처명
					 */
					map.put("SYS_SE", sysSe);
					map.put("DLIVY_STAT_CD", statCd);
					map.put("RMK", rmk);
					apiMapper.INSERT_AP_R01_EPDM_DLIVY_DTL_TMP(map); // 출고등록 1번째 쿼리
				}
			}// row data for

			// 등록데이타 검증
			Map<String, String> map = new HashMap<String, String>();
			map.put("MFC_BIZRNO", busiNo);
			map.put("DLIVY_REG_DT", regDt);

			int rtn = apiMapper.SELECT_AP_R01_EPDM_DLIVY_RSLT(map);	// 출고등록 2번째 쿼리
			if (rtn != 0) {
				// return "B004"; //집계 데이터와 상세 데이터가 불일치.
				errCd = "B004";
				throw new Exception(errCd);
			}

			// 실데이타에 반영처리
			boolean keyCheck = false;
			List<Map<String, String>> chkList = new ArrayList<Map<String, String>>();

			for (int i = 0; i < list.size(); i++) {

				keyCheck = false;
				Map<String, String> listMap = (Map<String, String>) list.get(i);
				listMap.put("STD_YEAR", listMap.get("DLIVY_DT").substring(0, 4));
				listMap.put("MFC_BIZRNO", busiNo);

				if (listMap.get("DTSS_NO").equals("0000000000")
						&& listMap.get("WHSLD_BIZRNO").equals("0000000000")) { // 집계
																				// 데이타
																				// 인경우
					continue;
				}

				// 등록일자 제한
				Map<String, String> map2 = new HashMap<String, String>();
				map2.put("SDT_DT", listMap.get("DLIVY_DT")); // 등록일자제한설정 등록일자
																// 1.DLIVY_DT,2.DRCT_RTRVL_DT,
																// 3.EXCH_DT,
																// 4.RTRVL_DT,
																// 5.RTN_DT
				map2.put("WORK_SE", "1"); // 업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 ,
											// 5.반환

				int sel = commonceService.rtc_dt_ck(map2); // 등록일자제한설정

				if (sel != 1) {
					throw new Exception("A021"); // 등록일자제한일자 입니다. 다시 한 번 확인해주시기
													// 바랍니다.
				}

				// 직매장 확인
				if (!brchCheck(listMap)) {
					throw new Exception("B016"); // 직매장 미등록
				}

				// 사업자 확인
				listMap.put("CUST_BIZRNO", listMap.get("WHSLD_BIZRNO"));
				listMap.put("CUST_BIZRNM", listMap.get("WHSLD_ENP_NM"));
				bizrCheck("D1", listMap); // 출고등록사업자(D1)

				// 마스터 체크
				for (int j = 0; j < chkList.size(); j++) {
					Map<String, String> listMap2 = (Map<String, String>) chkList
							.get(j);

					if (listMap.get("MFC_BIZRNO").equals( listMap2.get("MFC_BIZRNO")) && 
						listMap.get("DTSS_NO").equals( listMap2.get("DTSS_NO"))	&& 
						listMap.get("STD_YEAR").equals( listMap2.get("STD_YEAR"))) {
						
							listMap.put("DLIVY_DOC_NO",	listMap2.get("DLIVY_DOC_NO"));
							keyCheck = true;
							break;
					}// end of if
				}// end of for list2

				if (!keyCheck) {
					// master
					String doc_psnb_cd = "OT";
					String dlivy_doc_no = commonceService
							.doc_psnb_select(doc_psnb_cd); // 출고문서번호 조회
					listMap.put("DLIVY_DOC_NO", dlivy_doc_no); // 문서채번

					apiMapper.INSERT_AP_R01_EPDM_DLIVY_MST(listMap); // 출고마스터 등록 	// 출고등록 3번째 쿼리
					chkList.add(listMap);
				}

				// detail
				apiMapper.INSERT_AP_R01_EPDM_DLIVY_INFO(listMap);		// 출고등록 4번째 쿼리
			}

			for (int j = 0; j < chkList.size(); j++) {// 마스터 합계 업데이트
				epce6652931Mapper
						.epce6652931_update3((Map<String, String>) chkList		// 출고등록 5번째 쿼리
								.get(j));
			}

			// 구병실행상세 등록
			// apiMapper.INSERT_AP_R01_EPCN_CAP_DTL(map);

		}catch (IOException io) {
			io.printStackTrace();
		}catch (NullPointerException nu){
			nu.printStackTrace();
		}catch(Exception e){
			throw new Exception();
		} catch (Exception e) {
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			if (e.getMessage() != null && e.getMessage().indexOf("A0") > -1)
				errCd = e.getMessage();

			if (e instanceof DataAccessException) {
				SQLException se = (SQLException) ((DataAccessException) e)
						.getRootCause();
				if (se.getErrorCode() == 1)
					errCd = "B008"; // 테이블 PK에러
									// System.out.println(se.getMessage());
			}

			// if(errCd.equals("0000")) errCd = "B003";
			throw new Exception(errCd);
		}

		return errCd;
	}

	/**
	 * 직접배송정보등록(센터 ← 생산자) - 전월 직접배송정보 마감내역
	 * 
	 * @param list
	 * @param TRMS_DT
	 * @param TRMS_TKTM
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String AP_R02(List<?> list, String busiNo, String TRMS_DT,
			String TRMS_TKTM) throws Exception {
		String sysSe = "B"; // 시스템구분 -기타코드테이블(그룹코드: C005) : A: 웹시스템, B: 연계API
		String statCd = "1"; // 직접배송상태코드 - 기타코드테이블(그룹코드: C014) : 1: EDP확인, 2:
								// 고지등록, 3: 수납확인
		String rmk = ""; // 비고
		String regDt = util.getTodayString();
		String errCd = "0000";

		try {

			/*
			 * //중복 체크 - 월1회성..중복체크 보류 Map<String, String> chkMap = new
			 * HashMap<String, String>(); chkMap.put("DVRY_RGST_DT", regDt);
			 * chkMap.put("MFC_BIZRNO", busiNo); chkMap.put("SYS_SE", sysSe);
			 * int dupCnt = apiMapper.SELECT_DUPLE_CHECK_AP_R02(chkMap);
			 * if(dupCnt > 0){ errCd = "B008"; //이미 기존처리 데이타 존재 throw new
			 * Exception(errCd); }
			 */

			for (int i = 0; i < list.size(); i++) {
				Map<String, String> map = (Map<String, String>) list.get(i);
				map.put("DVRY_RGST_DT", regDt);
				map.put("MFC_BIZRNO", busiNo);
				map.put("RGST_PRSN_ID", "API");

				/*
				 * log.debug("BSS_YM=========" + map.get("BSS_YM")); //기준년월
				 * log.debug("DTSS_NO=========" + map.get("DTSS_NO"));
				 * //직매장번호(물류센터) log.debug("RTL_BIZRNO=========" +
				 * map.get("RTL_BIZRNO")); //소매업자 사업자 번호
				 * log.debug("STD_CTNR_CD=========" + map.get("STD_CTNR_CD"));
				 * //표준용기코드 log.debug("DLIVY_QTY=========" +
				 * map.get("DLIVY_QTY")); //출고수량 log.debug("RTRVL_QTY========="
				 * + map.get("RTRVL_QTY")); //회수수량 log.debug("RTN_QTY========="
				 * + map.get("RTN_QTY")); //반환수량
				 * log.debug("RTL_PAY_GTN=========" + map.get("RTL_PAY_GTN"));
				 * //소매지급보증금 log.debug("RTL_PAY_FEE=========" +
				 * map.get("RTL_PAY_FEE")); //소매지급수수료
				 * log.debug("RTL_ENP_NM=========" + map.get("RTL_ENP_NM"));
				 * //거래처명
				 */

				if (map.get("DTSS_NO").equals("0000000000")
						&& map.get("RTL_BIZRNO").equals("0000000000")) { // 집계
																			// 데이타
																			// 인경우
					apiMapper.INSERT_AP_R02_EPDM_DRCT_DVRY_LST_TMP(map);
				} else { // 직배송 데이타
					map.put("DRCT_DVRY_STAT_CD", statCd); // 직접배송상태코드 - EDP확인
					map.put("SYS_SE", sysSe);
					map.put("RMK", rmk);

					apiMapper.INSERT_AP_R02_EPDM_DRCT_DVRY_DTL_TMP(map);
				}
			}// row data for

			// 미반환 수량 및 보증금 계산
			Map<String, String> map = new HashMap<String, String>();
			map.put("MFC_BIZRNO", busiNo);
			map.put("DVRY_RGST_DT", regDt);
			apiMapper.UPDATE_AP_R02_EPDM_DRCT_DVRY_DTL_TMP(map); // 미반환수량,
																	// 출고보증금, 회수
																	// 보증금,
																	// 반환보증금,
																	// 미반환 보증금
																	// 계산

			// 검증
			int rtn = apiMapper.SELECT_AP_R02_EPDM_DRCT_DVRY_RSLT(map);
			if (rtn != 0) {
				// return "B004"; //집계 데이터와 상세 데이터가 불일치.
				throw new Exception("B004");
			}

			// 실데이타에 반영처리
			apiMapper.INSERT_AP_R02_EPDM_DRCT_DVRY_INFO(map);

		}catch (IOException io) {
			io.printStackTrace();
		}catch (SQLException sq) {
			sq.printStackTrace();
		}catch (NullPointerException nu){
			nu.printStackTrace();
		}catch (Exception e) {
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			if (e.getMessage() != null && e.getMessage().indexOf("A0") > -1)
				errCd = e.getMessage();

			// if(errCd.equals("0000")) errCd = "B003";

			throw new Exception(errCd);
		}

		return errCd;
	}

	/**
	 * 회수정보등록(센터 ← 도매업자) - 전일 소매회수정보(도매업자, 소매업자) 동일 쿼리 사용함 - 소매업자인 경우 은행코드, 계좌번호
	 * 필드 추가되어서 옴. 도매일경우 두 개필드 빈값으로 강제로 넣어줌.
	 * 
	 * @param list
	 * @param TRMS_DT
	 * @param TRMS_TKTM
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String AP_R03(List<?> list, String busiNo, String TRMS_DT,
			String TRMS_TKTM, String histPrcsSe) throws Exception {

		String sysSe = "A"; // 기타코드테이블(그룹코드: S004) : W: 웹시스템, A: 연계API
		String rmk = ""; // 비고
		String regDt = util.getShortDateString(); // 일자로 변경
													// util.getTodayString();
		String errCd = "0000";

		try {
			/*
			 * //중복 체크 Map<String, String> chkMap = new HashMap<String,
			 * String>(); chkMap.put("RTRVL_RGST_DT", regDt);
			 * chkMap.put("WHSLD_BIZRNO", busiNo); chkMap.put("SYS_SE", sysSe);
			 * int dupCnt = apiMapper.SELECT_DUPLE_CHECK_AP_R03(chkMap);
			 * if(dupCnt > 0){ errCd = "B008"; //이미 기존처리 데이타 존재 throw new
			 * Exception(errCd); }
			 */

			for (int i = 0; i < list.size(); i++) {
				Map<String, String> map = (Map<String, String>) list.get(i);
				map.put("RTRVL_REG_DT", regDt);
				map.put("WHSLD_BIZRNO", busiNo); // 도매업자 사업자 번호
				map.put("REG_PRSN_ID", "API");

				/*
				 * int sel = apiMapper.SELECT_DUPLE_CHECK_AP_R03(map); //중복체크
				 * if(sel>0){ throw new Exception("B008"); //이미 기존처리 데이타 존재 }
				 */

				// 수량이 소수점으로 들어올경우 차단
				if (map.get("RTRVL_QTY").indexOf(".") > -1) {
					throw new Exception("B022"); // 소수점 등록이 불가능합니다.
				}

				/*
				 * log.debug("RTRVL_DT=========" + map.get("RTRVL_DT")); //회수일자
				 * log.debug("RTL_BIZRNO=========" + map.get("RTL_BIZRNO"));
				 * //소매업자 사업자 번호 log.debug("RTRVL_CTNR_CD=========" +
				 * map.get("RTRVL_CTNR_CD")); //회수용기코드
				 * log.debug("RTRVL_QTY=========" + map.get("RTRVL_QTY"));
				 * //회수수량 log.debug("RTRVL_GTN=========" +
				 * map.get("RTRVL_GTN")); //회수보증금 log.debug("RTL_FEE=========" +
				 * map.get("RTL_FEE")); //소매수수료 log.debug("BCNC_SE=========" +
				 * map.get("BCNC_SE")); //거래처구분(0: 유흥취급, 1: 가정취급)
				 * log.debug("RTL_ENP_NM=========" + map.get("RTL_ENP_NM"));
				 * //거래처명
				 * 
				 * log.debug("RTL_BANK_CD=========" + map.get("RTL_BANK_CD"));
				 * //소매 은행코드 - 소매만 필드존재 log.debug("RTL_ACCT_NO=========" +
				 * map.get("RTL_ACCT_NO")); //소매 계좌번호 - 소매만 필드존재
				 */
//				System.out.println("map"+map);
				int rtn = apiMapper.SELECT_AP_R03_EPCN_RTRVL_CTNR_CD(map);
				if (rtn == 0) {
					// errCd = "B999";
					throw new Exception("B023"); // 미등록된 회수용기코드입니다.
				}

				if (map.get("RTL_BIZRNO").equals("0000000000")) { // 집계 데이타 인경우
					apiMapper.INSERT_EPCM_RTRVL_LST_TMP(map);
				} else { // 회수 데이터
					map.put("SYS_SE", sysSe);
					map.put("RMK", rmk);
					if (!map.containsKey("RTL_BANK_CD")) {// 도매인 경우 해당필드 없어서
															// 추가해줌.
						map.put("RTL_BANK_CD", "");
						map.put("RTL_ACCT_NO", "");
					}
					apiMapper.INSERT_EPCM_RTRVL_DTL_TMP(map);

					Map<String, String> map2 = new HashMap<String, String>();
					map2.put("WHSLD_BIZRNO", map.get("WHSLD_BIZRNO"));
					map2.put("RTL_BIZRNO", map.get("RTL_BIZRNO"));
					map2.put("RTRVL_REG_DT", regDt.substring(0, 8));
					map2.put("RTRVL_DT", map.get("RTRVL_DT"));
					map2.put("RTRVL_CTNR_CD", map.get("RTRVL_CTNR_CD"));
					map2.put("DEL_YN", "N");
					if (histPrcsSe.toUpperCase().equals("U")) {
						map2.put("PROC_SE_CD", "2");
					} else {
						map2.put("PROC_SE_CD", "1");
					}
					map2.put("RTRVL_QTY", map.get("RTRVL_QTY"));
					map2.put("RGST_PRSN_ID", "API");
					// TOBE 임시주석처리 CAP등록?
					// epvsovdpMapper.insertData(map2);
				}

			}// row data for

			// 검증
			Map<String, String> map = new HashMap<String, String>();
			map.put("WHSLD_BIZRNO", busiNo);
			map.put("RTRVL_REG_DT", regDt);

			int rtn = apiMapper.SELECT_AP_R03_EPCM_RTRVL_RSLT(map);
			if (rtn != 0) {
				// return "B004"; //집계 데이터와 상세 데이터가 불일치.
				throw new Exception("B004");
			}

			// 실데이타에 반영처리
			boolean keyCheck = false;
			List<Map<String, String>> chkList = new ArrayList<Map<String, String>>();

			for (int i = 0; i < list.size(); i++) {

				keyCheck = false;
				Map<String, String> listMap = (Map<String, String>) list.get(i);
				listMap.put("WHSLD_BIZRNO", busiNo);
//				System.out.println("listMap : " + listMap);
				if (listMap.get("RTL_BIZRNO").equals("0000000000")) { // 집계 데이타
																		// 인경우
					continue;
				}

				// 등록일자 제한
				Map<String, String> map2 = new HashMap<String, String>();
				map2.put("SDT_DT", listMap.get("RTRVL_DT")); // 등록일자제한설정 등록일자
																// 1.DLIVY_DT,2.DRCT_RTRVL_DT,
																// 3.EXCH_DT,
																// 4.RTRVL_DT,
																// 5.RTN_DT
				map2.put("WORK_SE", "4"); // 업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 ,
											// 5.반환

				int sel = commonceService.rtc_dt_ck(map2); // 등록일자제한설정

				if (sel != 1) {
					throw new Exception("A021"); // 등록일자제한일자 입니다. 다시 한 번 확인해주시기
													// 바랍니다.
				}

				// 사업자 확인
				listMap.put("CUST_BIZRNO", listMap.get("RTL_BIZRNO"));
				listMap.put("CUST_BIZRNM", listMap.get("RTL_ENP_NM"));
				bizrCheck("D3", listMap); // 소매거래처등록사업자(D3)
//				System.out.println("listMap11 : " + listMap);
//				System.out.println("chkList.size()" + chkList.size());
				for (int j = 0; j < chkList.size(); j++) {
					Map<String, String> listMap2 = (Map<String, String>) chkList
							.get(j);
					System.out.println("listMap2 : " + listMap2);
					if (listMap.get("WHSLD_BIZRNO").equals(
							listMap2.get("WHSLD_BIZRNO"))
							&& listMap.get("RTL_BIZRNO").equals(
									listMap2.get("RTL_BIZRNO"))) {
						listMap.put("RTRVL_DOC_NO",
								listMap2.get("RTRVL_DOC_NO"));
						keyCheck = true;
						break;
					}// end of if
				}// end of for list2

				if (!keyCheck) {
					// master
					String doc_psnb_cd = "RV";
					String doc_no = commonceService
							.doc_psnb_select(doc_psnb_cd); // 문서번호 조회
					listMap.put("RTRVL_DOC_NO", doc_no); // 문서채번

					String rtrvl_stat_cd = apiMapper
							.SELECT_AP_R03_EPCM_RTRVL_STAT_CD(listMap); // 회수등록구분
					if (rtrvl_stat_cd == null) {
						rtrvl_stat_cd = "VC";
					}
					listMap.put("RTRVL_STAT_CD", rtrvl_stat_cd); // 회수상태코드

					apiMapper.INSERT_AP_R03_EPCM_RTRVL_MST(listMap); // 마스터 등록
					chkList.add(listMap);
				}

				// detail
				apiMapper.INSERT_AP_R03_EPCM_RTRVL_INFO(listMap);
			}

			for (int j = 0; j < chkList.size(); j++) {// 마스터 합계 업데이트
				epce2925801Mapper
						.epce2925831_update((Map<String, String>) chkList
								.get(j));
			}

		}catch (IOException io) {
			io.printStackTrace();
		}catch (SQLException sq) {
			sq.printStackTrace();
		}catch (NullPointerException nu){
			nu.printStackTrace();
		} catch (Exception e) {
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			if (e.getMessage() != null && e.getMessage().indexOf("A0") > -1)
				errCd = e.getMessage();

			if (e instanceof DataAccessException) {
				SQLException se = (SQLException) ((DataAccessException) e)
						.getRootCause();
				if (se.getErrorCode() == 1)
					errCd = "B008"; // 테이블 PK에러
									// System.out.println(se.getMessage());
			}

			// if(errCd.equals("0000")) errCd = "B003";
			throw new Exception(errCd);
		}

		return errCd;

	}

	/**
	 * 직접회수정보등록(센터 ← 생산자) - 전일 직접회수정보 마감등록
	 * 
	 * @param list
	 * @param TRMS_DT
	 * @param TRMS_TKTM
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String AP_R06(List<?> list, String busiNo, String TRMS_DT,
			String TRMS_TKTM) throws Exception {

		String stateCd = "RG"; // 기타코드테이블(그룹코드: D012)(RG: 직접회수등록, IB: 고지등록, AC:
								// 수납확인)
		String sysSe = "A"; // 기타코드테이블(그룹코드: S004)(W:웹시스템, A:연계API)
		String rmk = ""; // 비고
		String regDt = util.getShortDateString(); // 일자로 등록
													// util.getTodayString();
		String errCd = "0000";

		try {
			/*
			 * //중복 체크 Map<String, String> chkMap = new HashMap<String,
			 * String>(); chkMap.put("DRCT_RTRVL_RGST_DT", regDt);
			 * chkMap.put("MFC_BIZRNO", busiNo); chkMap.put("SYS_SE", sysSe);
			 * int dupCnt = apiMapper.SELECT_DUPLE_CHECK_AP_R06(chkMap);
			 * if(dupCnt > 0){ errCd = "B008"; //이미 기존처리 데이타 존재 throw new
			 * Exception(errCd); }
			 */

			for (int i = 0; i < list.size(); i++) {
				Map<String, String> map = (Map<String, String>) list.get(i);
				map.put("DRCT_RTRVL_REG_DT", regDt);
				map.put("MFC_BIZRNO", busiNo); // 생산자자 사업자 번호
				map.put("REG_PRSN_ID", "API");

				/*
				 * int sel = apiMapper.SELECT_DUPLE_CHECK_AP_R06(map); //중복체크
				 * if(sel>0){ throw new Exception("B008"); //이미 기존처리 데이타 존재 }
				 */

				// 수량이 소수점으로 들어올경우 차단
				if (map.get("DRCT_RTRVL_QTY").indexOf(".") > -1) {
					throw new Exception("B022"); // 소수점 등록이 불가능합니다.
				}

				/*
				 * log.debug("DRCT_RTRVL_DT=========" +
				 * map.get("DRCT_RTRVL_DT")); //직접회수일자
				 * log.debug("DTSS_NO=========" + map.get("DTSS_NO"));
				 * //직매장번호(물류센터번호) 집계 0000000000 log.debug("RTL_BIZRNO========="
				 * + map.get("RTL_BIZRNO")); //소매업자 사업자 번호 집계 0000000000
				 * log.debug("STD_CTNR_CD=========" + map.get("STD_CTNR_CD"));
				 * //표준용기코드 log.debug("DRCT_RTRVL_QTY=========" +
				 * map.get("DRCT_RTRVL_QTY")); //직접회수수량
				 * log.debug("DRCT_PAY_GTN=========" + map.get("DRCT_PAY_GTN"));
				 * //직접회수(지급)보증금 log.debug("DRCT_PAY_FEE=========" +
				 * map.get("DRCT_PAY_FEE")); //직접지급수수료
				 * log.debug("RTL_ENP_NM=========" + map.get("RTL_ENP_NM"));
				 * //거래처명
				 */

				if (map.get("DTSS_NO").equals("0000000000")
						&& map.get("RTL_BIZRNO").equals("0000000000")) { // 집계
																			// 데이타
																			// 인경우
					apiMapper.INSERT_AP_R06_EPDM_DRCT_RTRVL_LST_TMP(map);
				} else { // 회수 데이타
					map.put("SYS_SE", sysSe);
					map.put("RMK", rmk);
					map.put("DRCT_RTRVL_STAT_CD", stateCd);

					apiMapper.INSERT_AP_R06_EPDM_DRCT_RTRVL_DTL_TMP(map);
				}

				/*
				 * 2016.12.28 직접회수 등록여부 API Check Process 주석처리 String ctnrCd =
				 * map.get("STD_CTNR_CD");
				 * 
				 * //신병 여부 체크 if(dtssCd.charAt(1)== '3'){ Map<String, String>
				 * tempMap = new HashMap<String, String>();
				 * 
				 * tempMap.put("MFC_BIZRNO", map.get("MFC_BIZRNO"));
				 * tempMap.put("NEW_DTSS_CD", map.get("STD_CTNR_CD"));
				 * tempMap.put("OLD_DTSS_CD", ctnrCd.substring(0, 1));
				 * tempMap.put("OLD_DTSS_CD2", ctnrCd.substring(2));
				 * tempMap.put("WHSLD_BIZRNO", map.get("RTL_BIZRNO"));
				 * tempMap.put("CTNR_CD", ""); tempMap.put("MBR_SE", "");
				 * tempMap.put("AREA_CD", ""); tempMap.put("CAP_USE_YN", "Y");
				 * tempMap.put("USE_YN", "");
				 * 
				 * //구병기준정보 조회 String remainQty =
				 * epvsobdpMapper.searchRemainQty(tempMap); String rtnValue =
				 * "";
				 * 
				 * if(remainQty!="" && !"".equals(remainQty) &&
				 * remainQty!=null){ int tempRemainQty =
				 * Integer.parseInt(remainQty);
				 * 
				 * if(tempRemainQty2 > 0){ throw new Exception(""); //구병우선반환 오류
				 * } } }
				 */
				/*
				 * 2016.12.28 직접회수 등록여부 API Check Process 주석처리 Map<String,
				 * String> tempMap2 = new HashMap<String, String>();
				 * 
				 * tempMap2.put("MFC_BIZRNO", map.get("MFC_BIZRNO"));
				 * tempMap2.put("NEW_DTSS_CD", ""); tempMap2.put("OLD_DTSS_CD",
				 * ""); tempMap2.put("OLD_DTSS_CD2", "");
				 * tempMap2.put("WHSLD_BIZRNO", map.get("RTL_BIZRNO"));
				 * tempMap2.put("CTNR_CD", map.get("STD_CTNR_CD"));
				 * tempMap2.put("MBR_SE", ""); tempMap2.put("AREA_CD", "");
				 * tempMap2.put("CAP_USE_YN", "Y"); tempMap2.put("USE_YN", "");
				 * 
				 * //구병기준정보 조회 String remainQty2 =
				 * epvsobdpMapper.searchRemainQty(tempMap2); String rtnValue =
				 * "";
				 * 
				 * if(remainQty2!="" && !"".equals(remainQty2) &&
				 * remainQty2!=null){ int tempRemainQty2 =
				 * Integer.parseInt(remainQty2);
				 * 
				 * Map<String, Integer> tempMap4 = (Map<String, Integer>)
				 * list.get(i); int drctRtrvlQty2 =
				 * tempMap4.get("DRCT_RTRVL_QTY");
				 * 
				 * int chkQty2 = remainQty2 - drctRtrvlQty2;
				 * 
				 * if(chkQty2 < 0){ throw new Exception(""); // 구병등록가능수량 부족 오류 }
				 * }
				 */

			}// row data for

			// 검증
			Map<String, String> map = new HashMap<String, String>();
			map.put("MFC_BIZRNO", busiNo);
			map.put("DRCT_RTRVL_REG_DT", regDt);

			int rtn = apiMapper.SELECT_AP_R06_EPDM_DRCT_RTRVL_RSLT(map);
			if (rtn != 0) {
				// return "B004"; //집계 데이터와 상세 데이터가 불일치.
				throw new Exception("B004");
			}

			// 실데이타에 반영처리
			boolean keyCheck = false;
			List<Map<String, String>> chkList = new ArrayList<Map<String, String>>();

			for (int i = 0; i < list.size(); i++) {

				keyCheck = false;
				Map<String, String> listMap = (Map<String, String>) list.get(i);
				listMap.put("MFC_BIZRNO", busiNo);

				if (listMap.get("DTSS_NO").equals("0000000000")
						&& listMap.get("RTL_BIZRNO").equals("0000000000")) { // 집계
																				// 데이타
																				// 인경우
					continue;
				}

				// 등록일자 제한
				Map<String, String> map2 = new HashMap<String, String>();
				map2.put("SDT_DT", listMap.get("DRCT_RTRVL_DT")); // 등록일자제한설정
																	// 등록일자
																	// 1.DLIVY_DT,2.DRCT_RTRVL_DT,
																	// 3.EXCH_DT,
																	// 4.RTRVL_DT,
																	// 5.RTN_DT
				map2.put("WORK_SE", "2"); // 업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 ,
											// 5.반환

				int sel = commonceService.rtc_dt_ck(map2); // 등록일자제한설정

				if (sel != 1) {
					throw new Exception("A021"); // 등록일자제한일자 입니다. 다시 한 번 확인해주시기
													// 바랍니다.
				}

				// 직매장 확인
				if (!brchCheck(listMap)) {
					throw new Exception("B016"); // 직매장 미등록
				}

				// 사업자 확인
				listMap.put("CUST_BIZRNO", listMap.get("RTL_BIZRNO"));
				listMap.put("CUST_BIZRNM", listMap.get("RTL_ENP_NM"));
				bizrCheck("D2", listMap); // 직접회수등록사업자(D2)

				// 마스터 체크
				for (int j = 0; j < chkList.size(); j++) {
					Map<String, String> listMap2 = (Map<String, String>) chkList
							.get(j);

					if (listMap.get("MFC_BIZRNO").equals(
							listMap2.get("MFC_BIZRNO"))
							&& listMap.get("DTSS_NO").equals(
									listMap2.get("DTSS_NO"))
							&& listMap.get("DRCT_RTRVL_DT").equals(
									listMap2.get("DRCT_RTRVL_DT"))) {
						listMap.put("DRCT_RTRVL_DOC_NO",
								listMap2.get("DRCT_RTRVL_DOC_NO"));
						keyCheck = true;
						break;
					}// end of if
				}// end of for list2

				if (!keyCheck) {
					// master
					String doc_psnb_cd = "DR";
					String doc_no = commonceService
							.doc_psnb_select(doc_psnb_cd); // 문서번호 조회
					listMap.put("DRCT_RTRVL_DOC_NO", doc_no); // 문서채번

					apiMapper.INSERT_AP_R06_EPDM_DRCT_RTRVL_MST(listMap); // 마스터
																			// 등록
					chkList.add(listMap);
				}

				apiMapper.INSERT_AP_R06_EPDM_DRCT_RTRVL_INFO(listMap); // detail
			}

			for (int j = 0; j < chkList.size(); j++) {// 마스터 합계 업데이트
				epce6645231Mapper
						.epce6645231_update3((Map<String, String>) chkList
								.get(j));
			}

			// 구병실행상세 등록
			/*
			 * 2016.12.28 직접회수 등록여부 API Check Process 주석처리
			 * apiMapper.INSERT_AP_R06_EPCN_CAP_DTL(map);
			 */

		}catch (IOException io) {
			io.printStackTrace();
		}catch (SQLException sq) {
			sq.printStackTrace();
		}catch (NullPointerException nu){
			nu.printStackTrace();
		} catch (Exception e) {
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			if (e.getMessage() != null && e.getMessage().indexOf("A0") > -1)
				errCd = e.getMessage();

			if (e instanceof DataAccessException) {
				SQLException se = (SQLException) ((DataAccessException) e)
						.getRootCause();
				if (se.getErrorCode() == 1)
					errCd = "B008"; // 테이블 PK에러
									// System.out.println(se.getMessage());
			}

			// if(errCd.equals("0000")) errCd = "B003";
			throw new Exception(errCd);
		}

		return errCd;

	}

	/**
	 * 반환내역등록(센터 ← 도매업자) - 당일 반환 예정 내역등록
	 * 
	 * @param list
	 * @param TRMS_DT
	 * @param TRMS_TKTM
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String AP_R07(List<?> list, String busiNo, String TRMS_DT,
			String TRMS_TKTM, String REG_SN) throws Exception {

		String sysSe = "A"; // 기타코드테이블(그룹코드: S004)(W:웹시스템, A:연계API)
		String regDt = util.getShortDateString(); // 일자로 등록
													// util.getTodayString();
		String errCd = "0000";

		try {
//			System.out.println("list" + list);
//			System.out.println("list.size()" + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, String> map = (Map<String, String>) list.get(i);
				map.put("RTN_REG_DT", regDt);
				map.put("WHSLD_BIZRNO", busiNo); // 도매업자 사업자 번호
				map.put("REG_PRSN_ID", "API");
				map.put("REG_SN", REG_SN);

				// 수량이 소수점으로 들어올경우 차단
				if (map.get("RTRVL_QTY").indexOf(".") > -1) {
					throw new Exception("B022"); // 소수점 등록이 불가능합니다.
				}

//				System.out.println("map" + map);
				if (map.get("DTSS_NO").equals("0000000000")
						&& map.get("MFC_BIZRNO").equals("0000000000")) { // 집계
																			// 데이타
																			// 인경우
					apiMapper.INSERT_AP_R07_EPCM_RTN_LST_TMP(map);
				} else { // 회수 데이타
					map.put("SYS_SE", sysSe);
					map.put("MFC_BRCH_NO", "9999999999");

					apiMapper.INSERT_AP_R07_EPCM_RTN_DTL_TMP(map);
				}
			}// row data for

			// 검증
			Map<String, String> map = new HashMap<String, String>();
			map.put("WHSLD_BIZRNO", busiNo);
			map.put("RTN_REG_DT", regDt);
			map.put("REG_SN", REG_SN);

			int rtn = apiMapper.SELECT_AP_R07_EPCM_RTN_RSLT(map);

			if (rtn != 0) {
				// return "B004"; //집계 데이터와 상세 데이터가 불일치.
				throw new Exception("B004");
			}

			// 실데이타에 반영처리
			boolean keyCheck = false;
			List<Map<String, String>> chkList = new ArrayList<Map<String, String>>();

			HashMap<String, Object> inputMap = new HashMap<String, Object>();
			Map<String, String> checkMap = new HashMap<String, String>();
			Map<String, String> listMap = new HashMap<String, String>();

			for (int i = 0; i < list.size(); i++) {

				keyCheck = false;

				listMap = (Map<String, String>) list.get(i);

				if (listMap.get("DTSS_NO").equals("0000000000")
						&& listMap.get("MFC_BIZRNO").equals("0000000000")) { // 집계
																				// 데이타
																				// 인경우
					continue;
				}

				checkMap = (Map<String, String>) apiMapper
						.SELECT_MFC_BRCH_INFO(listMap);

				if (checkMap == null) { // 해당 직매장 데이터가 없을경우
					throw new Exception("B016"); // 직매장 미등록
				} else {
					listMap.put("MFC_BRCH_ID", checkMap.get("MFC_BRCH_ID"));
					listMap.put("MFC_BRCH_NO", checkMap.get("MFC_BRCH_NO"));
				}

				listMap.put("WHSLD_BIZRNO", busiNo);
				listMap.put("REG_PRSN_ID", "API");
				listMap.put("REG_SN", REG_SN);

				// 등록일자 제한
				Map<String, String> map2 = new HashMap<String, String>();
				map2.put("SDT_DT", listMap.get("RTN_DT")); // 등록일자제한설정 등록일자
															// 1.DLIVY_DT,2.DRCT_RTRVL_DT,
															// 3.EXCH_DT,
															// 4.RTRVL_DT,
															// 5.RTN_DT
				map2.put("WORK_SE", "5"); // 업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 ,
											// 5.반환

				int sel = commonceService.rtc_dt_ck(map2); // 등록일자제한설정

				if (sel != 1) {
					throw new Exception("A021"); // 등록일자제한일자 입니다. 다시 한 번 확인해주시기
													// 바랍니다.
				}

				for (int j = 0; j < chkList.size(); j++) {

					Map<String, String> listMap2 = (Map<String, String>) chkList
							.get(j);

					if (listMap.get("MFC_BIZRNO").equals(
							listMap2.get("MFC_BIZRNO")) // 생산자
							&& listMap.get("MFC_BRCH_NO").equals(
									listMap2.get("MFC_BRCH_NO")) // 생산자 지점
							&& listMap.get("CAR_NO").equals(
									listMap2.get("CAR_NO")) // 자동차,
							&& listMap.get("RTN_DT").equals(
									listMap2.get("RTN_DT")) // 반환일자
							&& listMap.get("REG_SN").equals(
									listMap2.get("REG_SN")) // API전송순번
					) {
						listMap.put("RTN_DOC_NO", listMap2.get("RTN_DOC_NO"));
						keyCheck = true;

						break;
					}// end of if

				}// end of for chkList

				List<?> feeList = apiMapper
						.SELECT_AP_R07_EPCN_INDV_FEE_MGNT(listMap);

				if (feeList.size() == 0) {
					throw new Exception("B021");
				}

				for (int j = 0; j < feeList.size(); j++) {

					Map<String, String> feeMap = (Map<String, String>) feeList
							.get(j);

					listMap.put("RTN_GTN",
							String.valueOf(feeMap.get("RTN_GTN")));
					listMap.put("RTN_WHSL_FEE",
							String.valueOf(feeMap.get("RTN_WHSL_FEE")));
					listMap.put("RTN_WHSL_FEE_STAX",
							String.valueOf(feeMap.get("RTN_WHSL_FEE_STAX")));
					listMap.put("RTN_RTL_FEE",
							String.valueOf(feeMap.get("RTN_RTL_FEE")));
					listMap.put("RTN_GTN_UTPC",
							String.valueOf(feeMap.get("RTN_GTN_UTPC")));
					listMap.put("RTN_WHSL_FEE_UTPC",
							String.valueOf(feeMap.get("RTN_WHSL_FEE_UTPC")));
					listMap.put("RTN_RTL_FEE_UTPC",
							String.valueOf(feeMap.get("RTN_RTL_FEE_UTPC")));
				}

				if (!keyCheck) {
					// master
					String doc_psnb_cd = "RT"; // RT :반환문서 ,IN :입고문서
					String rtn_doc_no = commonceService
							.doc_psnb_select(doc_psnb_cd); // 반환문서번호 조회

					listMap.put("RTN_DOC_NO", rtn_doc_no); // 문서채번
					listMap.put("SYS_SE", sysSe); // 시스템구분
					listMap.put("RTN_STAT_CD", "RA"); // 반환상태

					apiMapper.INSERT_AP_R07_EPCM_RTN_MST_TMP(listMap); // 반환마스터
																		// 등록

					chkList.add(listMap);
				}

				// detail
				apiMapper.INSERT_AP_R07_EPCM_RTN_INFO_TMP(listMap); // 반환상세 등록

			}// end of for

			for (int j = 0; j < chkList.size(); j++) {// 마스터 합계 업데이트
				Map<String, String> map2 = (Map<String, String>) chkList.get(j);
				apiMapper.UPDATE_AP_R07_EPCM_RTN_MST_TMP(map2);
			}

		}catch (IOException io) {
			io.printStackTrace();
		}catch (SQLException sq) {
			sq.printStackTrace();
		}catch (NullPointerException nu){
			nu.printStackTrace();
		} catch (Exception e) {
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			if (e.getMessage() != null && e.getMessage().indexOf("A0") > -1)
				errCd = e.getMessage();

			if (e instanceof DataAccessException) {
				SQLException se = (SQLException) ((DataAccessException) e)
						.getRootCause();
				if (se.getErrorCode() == 1)
					errCd = "B008"; // 테이블 PK에러
									// System.out.println(se.getMessage());
			}

			// if(errCd.equals("0000")) errCd = "B003";
			throw new Exception(errCd);
		}

		return errCd;
	}

	/**
	 * 생산자 빈용기정보 등록
	 * 
	 * @param list
	 * @param TRMS_DT
	 * @param TRMS_TKTM
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String AP_R08(List<?> list, String busiNo, String TRMS_DT,
			String TRMS_TKTM) throws Exception {

		String sysSe = "A"; // 기타코드테이블(그룹코드: S004)(W:웹시스템, A:연계API)
		String errCd = "0000";

		try {

			int rCnt = 0;

			for (int i = 0; i < list.size(); i++) {
				Map<String, String> map = (Map<String, String>) list.get(i);

				rCnt = apiMapper.SELECT_AP_R08_EPCN_STD_CTNR_CD_CNT(map);

				if (rCnt == 0) {
					errCd = "B011";
					throw new Exception("B011");
				}

				map.put("MFC_BIZRNO", busiNo);
				map.put("SYS_SE", sysSe);
				map.put("REG_PRSN_ID", "API");

				apiMapper.INSERT_AP_R08_EPCN_MFC_CTNR_TMP(map);
			}// row data for

			for (int i = 0; i < list.size(); i++) {

				rCnt = 0;

				Map<String, String> listMap = (Map<String, String>) list.get(i);

				listMap.put("MFC_BIZRNO", busiNo);

				if ("I".equals(listMap.get("REG_SE"))) {
					listMap.put("USE_YN", "Y");
					rCnt = apiMapper.INSERT_AP_R08_EPCN_MFC_CTNR_INFO(listMap);
				} else if ("D".equals(listMap.get("REG_SE"))) {
					listMap.put("USE_YN", "N");
					rCnt = apiMapper.DELETE_AP_R08_EPCN_MFC_CTNR_INFO(listMap);
				}

				if (rCnt == 0) {
					errCd = "B011";
					throw new Exception("B011");
				}

			}// end of for

		}catch (IOException io) {
			io.printStackTrace();
		}catch (SQLException sq) {
			sq.printStackTrace();
		}catch (NullPointerException nu){
			nu.printStackTrace();
		} catch (Exception e) {
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			if (e.getMessage() != null && e.getMessage().indexOf("A0") > -1)
				errCd = e.getMessage();

			// if(errCd.equals("0000")) errCd = "B003";
			throw new Exception(errCd);
		}

		return errCd;
	}

	/**
	 * 생산자입고 등록
	 * 
	 * @param list
	 * @param TRMS_DT
	 * @param TRMS_TKTM
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String AP_R09(List<?> list, String busiNo, String TRMS_DT,
			String TRMS_TKTM) throws Exception {

		String sysSe = "A"; // 기타코드테이블(그룹코드: S004)(W:웹시스템, A:연계API)
		String regDt = util.getShortDateString(); // 일자로 등록
													// util.getTodayString();
		String errCd = "0000";

		try {

			for (int i = 0; i < list.size(); i++) {
				Map<String, String> map = (Map<String, String>) list.get(i);
				map.put("MFC_CFM_REG_DT", regDt);
				map.put("MFC_BIZRNO", busiNo);
				map.put("REG_PRSN_ID", "API");

				// 수량이 소수점으로 들어올경우 차단
				if (map.get("CFM_QTY").indexOf(".") > -1) {
					throw new Exception("B022"); // 소수점 등록이 불가능합니다.
				}

				if (map.get("DTSS_NO").equals("0000000000")
						&& map.get("CUST_BIZRNO").equals("0000000000")) { // 집계
																			// 데이타
																			// 인경우
					apiMapper.INSERT_AP_R09_EPCN_MFC_CFM_LST_TMP(map);
				} else { // 회수 데이타
					map.put("SYS_SE", sysSe);

					apiMapper.INSERT_AP_R09_EPCN_MFC_CFM_DTL_TMP(map);
				}
			}// row data for

			// 검증
			Map<String, String> map = new HashMap<String, String>();
			map.put("MFC_BIZRNO", busiNo);
			map.put("MFC_CFM_REG_DT", regDt);

			int rtn = apiMapper.SELECT_AP_R09_EPCN_MFC_CFM_TMP(map);

			if (rtn != 1) {
				// return "B004"; //집계 데이터와 상세 데이터가 불일치.
				throw new Exception("B004");
			}

			for (int i = 0; i < list.size(); i++) {

				Map<String, String> listMap = (Map<String, String>) list.get(i);
				listMap.put("MFC_BIZRNO", busiNo);

				if (listMap.get("DTSS_NO").equals("0000000000")
						&& listMap.get("CUST_BIZRNO").equals("0000000000")) { // 집계
																				// 데이타
																				// 인경우
					continue;
				}

				// detail
				apiMapper.INSERT_AP_R09_EPCN_MFC_CFM_INFO(listMap); // 반환상세 등록

			}// end of for
		} catch (SQLException e) {
			if (e.getMessage().indexOf("ORA-00001") > -1) {
				errCd = "B008"; // PK 중복 오류
			} else {
				errCd = "B003";
			}
			throw new Exception(errCd);
		} catch (Exception e) {
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			if (e.getMessage() != null && e.getMessage().indexOf("A0") > -1)
				errCd = e.getMessage();

			// if(errCd.equals("0000")) errCd = "B003";

			if (e instanceof DataAccessException) {
				SQLException se = (SQLException) ((DataAccessException) e)
						.getRootCause();
				if (se.getErrorCode() == 1)
					errCd = "B008"; // 테이블 PK에러
									// System.out.println(se.getMessage());
			}

			throw new Exception(errCd);
		}

		return errCd;
	}

	/**
	 * 입고정보 조회
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public JSONArray searchData(HttpServletRequest request) throws Exception {

		String errCd = "0000";
		boolean secure = request.isSecure();
		if (!secure) {
			throw new Exception("B002");
		}

		BufferedReader dis = null;
		try {
			StringBuffer sb = new StringBuffer();
			String str = "";
			dis = new BufferedReader(new InputStreamReader(
					request.getInputStream()));
			while ((str = dis.readLine()) != null) {
				sb.append(URLDecoder.decode(str, "utf-8"));
			}
			dis.close();

			log.debug("===============================수신문자열=====================================");
			log.debug(sb.toString());
			log.debug("=============================================================================");

			Map<String, String> data = JSONObject.fromObject(sb.toString());
			String busiNo = data.get("BIZRNO"); // 사업자번호
			String recvKey = data.get("MBR_ISSU_KEY"); // 발급키
			String apiId = data.get("API_ID"); // 요청API

			// 인증키 검증
			HashMap<String, String> keyMap = apiMapper
					.SELECT_API_MBR_ISSU_KEY(busiNo);
			if (keyMap == null || !keyMap.get("STAT_CD").equals("Y")) {
				throw new Exception("B005"); // 미등록 또는 활동정지 사업자 입니다.
			} else if (!keyMap.get("MBR_ISSU_KEY").equals(recvKey)) {
				throw new Exception("B006"); // "발급키 인증 오류입니다."
			}

			if (!apiId.equals("AP_R05")) {
				throw new Exception("B007");
			}

			int rtn = apiMapper.SELECT_AP_R05_CHK_DT(data);
			if (Math.abs(rtn) > 7) {
				throw new Exception("B012"); // 조회기간은 최대 일주일(7일)을 초과할 수 없습니다.
			}

			List<?> list = apiMapper.SELECT_AP_R05_EPCM_RTN_INFO(data);
			if (list == null || list.size() == 0) {
				throw new Exception("B011"); // 검색 결과가 존재하지 않습니다.
			}

			JSONArray jArr = JSONArray.fromObject(list);
			return jArr;

		} catch (IOException e) {
			errCd = "B999"; // "파일 수신오류"
			throw new Exception(errCd);
		} catch (SQLException e) {
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			errCd = "B003"; // "DB처리중 오류가 발생하였습니다. 관리자에게 문의하세요."
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			throw new Exception(errCd);
		} catch (JSONException e) {
			errCd = "B009"; // "josn 형식 불일치"
			throw new Exception(errCd);
		} catch (Exception e) {
			errCd = "B003"; // "DB처리중 오류가 발생하였습니다. 관리자에게 문의하세요."
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			throw new Exception(errCd);
		} finally {
			if (dis != null)
				dis.close();
		}

	}

	/**
	 * 수신 히스토리 등록
	 * 
	 * @param busiNo
	 * @param apiCd
	 * @param acssIp
	 * @throws Exception
	 */
	public void insertRecvHist(String busiNo, String apiCd, String recvKey,
			HttpServletRequest request) throws Exception {
		HashMap<String, String> map = new HashMap<String, String>();

		map.put("BIZR_ISSU_KEY", recvKey);
		map.put("LK_API_CD", apiCd);
		map.put("ACSS_IP", request.getRemoteAddr());
		map.put("CALL_URL", request.getRequestURL().toString());

		apiMapper.INSERT_EPCN_EXEC_HIST(map);
	}

	/**
	 * 사업자 확인 및 등록
	 * 
	 * @param bizrTpCd
	 * @param listMap
	 * @throws Exception
	 */
	public void bizrCheck(String bizrTpCd, Map<String, String> listMap)
			throws Exception {

		listMap.put("BIZR_TP_CD", bizrTpCd);

		// 존재하는지 체크
		Map<String, String> checkMap = (Map<String, String>) apiMapper
				.SELECT_BIZR_INFO(listMap);

		if (checkMap != null && !checkMap.get("CUST_BIZRID").equals("")
				&& !checkMap.get("CUST_BRCH_ID").equals("N")
				&& !checkMap.get("CUST_BIZRNO").equals("")) { // 사업자, 지점 둘다 등록상태

			// 이미 해당 사업자번호로 사업자 및 지점이 등록되어있는 경우는 해당 데이터를 통해 거래처를 등록한다. 즉 작성한
			// 거래처명, 사업자유형은 무시함
			// errCd = ""; //이미 등록된 소매거래처 지점정보로 저장된 건이 있습니다. 등록결과를 확인하시기 바랍니다.
			listMap.put("CUST_BIZRID", checkMap.get("CUST_BIZRID"));

		} else {

			// 사업자데이터가 없을경우
			if (checkMap == null
					|| (checkMap != null && checkMap.get("CUST_BIZRID").equals(
							""))) {

				String psnbSeq = commonceService.psnb_select("S0001"); // 사업자ID
																		// 일련번호
																		// 채번
				listMap.put("CUST_BIZRID", bizrTpCd + "H" + psnbSeq); // 사업자ID =
																		// 출고등록사업자(D1)
																		// -
																		// 수기(H)

				apiMapper.INSERT_EPCN_BIZR_INFO(listMap); // 소매 사업자등록
				apiMapper.INSERT_EPCN_BRCH_INFO(listMap); // 소매 지점등록

				// 지점데이터가 없을경우
			} else if (checkMap != null
					&& checkMap.get("CUST_BRCH_ID").equals("N")) {

				listMap.put("CUST_BIZRID", checkMap.get("CUST_BIZRID")); // 조회된
																			// 사업자ID로
																			// 등록
				apiMapper.INSERT_EPCN_BRCH_INFO(listMap); // 소매 지점등록
			}
		}

	}

	/**
	 * 지점 확인 및 등록
	 * 
	 * @param bizrTpCd
	 * @param listMap
	 * @throws Exception
	 */
	public boolean brchCheck(Map<String, String> listMap) throws Exception {

		// 존재하는지 체크
		Map<String, String> checkMap = (Map<String, String>) apiMapper
				.SELECT_BRCH_INFO(listMap);

		if (checkMap == null) { // 해당 직매장 데이터가 없을경우

			// String psnbSeq = commonceService.psnb_select("S0007"); //지점ID
			// 일련번호 채번
			// checkMap.put("PSNB_SEQ", psnbSeq);

			// apiMapper.INSERT_EPCN_BRCH_INFO2(listMap); //직매장 등록

			return false;
		}

		return true;

	}

	/**
	 * 무인회수기 수신이력 순번 채번
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	public int urmRegSnSeq() throws Exception {

		int seq = 0;

		try {

			seq = apiMapper.SELECT_EPCN_URM_HIST_SEQ();

		} catch (IOException io) {
			io.printStackTrace();
		}catch (SQLException sq) {
			sq.printStackTrace();
		}catch (NullPointerException nu){
			nu.printStackTrace();
		}catch (Exception e) {
			seq = 999999999;
			; // "DB처리중 오류가 발생하였습니다. 관리자에게 문의하세요."
			throw new Exception("B003");
		} finally {

		}

		return seq; // 정상처리

	}

	/**
	 * 무인회수기 수신이력 등록
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	public String regUrmHist(HttpServletRequest request,
			Map<String, String> data) throws Exception {

		String errCd = "0000";

		try {

			apiMapper.INSERT_EPCN_URM_HIST(data);

		} catch (SQLException e) {
			// log.debug("==================SQLException===============");
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			errCd = "B003"; // "DB처리중 오류가 발생하였습니다. 관리자에게 문의하세요."
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			throw new Exception(errCd);
		} catch (Exception e) {
			errCd = "B003"; // "DB처리중 오류가 발생하였습니다. 관리자에게 문의하세요."
			// log.debug("==================Exception===============" +
			// e.getMessage());
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			throw new Exception(errCd);
		} finally {
			// if(dis != null) dis.close();
		}

		return errCd;
	}

	/**
	 * 무인회수기 수신이력 결과 반영
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	public String updateUrmHist(HttpServletRequest request,
			Map<String, String> data) throws Exception {

		String errCd = "0000";

		try {

			apiMapper.UPDATE_EPCN_URM_HIST_ANSR(data);

		}catch (IOException io) {
			io.printStackTrace();
		}catch (SQLException sq) {
			sq.printStackTrace();
		}catch (NullPointerException nu){
			nu.printStackTrace();
		} catch (Exception e) {
			errCd = "B003"; // "DB처리중 오류가 발생하였습니다. 관리자에게 문의하세요."
			// log.debug("==================Exception===============" +
			// e.getMessage());
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			throw new Exception(errCd);
		} finally {
			// if(dis != null) dis.close();
		}

		return errCd;
	}

	/**
	 * json data 수신
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	public String urmJsonData(HttpServletRequest request,
			Map<String, String> data) throws Exception {

		String errCd = "0000";
		boolean secure = request.isSecure();
		// if(!secure) return "B002"; //요청방식 오류 ##임시
		// 주석처리########################
		// BufferedReader dis = null;
		try {

			log.debug("=================={data:{[],[]}}===============");
			// 데이타 읽기
			List<?> list = JSONArray.fromObject(data.get("data"));
			errCd = urmInsertData(list);

//			log.debug("==================[],[]===============");

			// List<?> list = JSONArray.fromObject(data);
			// System.out.println("list 1 : "+list);
			// errCd = urmInsertData(list);

			// }catch(IOException e){
			// errCd = "B999"; //"파일 수신오류"
			// throw new Exception(errCd);
		} catch (SQLException e) {
			log.debug("==================SQLException===============");
			e.printStackTrace();
			errCd = "B003"; // "DB처리중 오류가 발생하였습니다. 관리자에게 문의하세요."
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			throw new Exception(errCd);
		} catch (JSONException e) {
			errCd = "B009"; // "json 형식 불일치"
			throw new Exception(errCd);
		} catch (Exception e) {
			log.debug("==================Exception==============="
					+ e.getMessage());
			log.debug("==================Exception==============="
					+ e.toString());
			e.printStackTrace();
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			if (e.getMessage() != null && e.getMessage().indexOf("A0") > -1)
				errCd = e.getMessage();
			if ("0000".equals(errCd))
				errCd = "B003"; // "DB처리중 오류가 발생하였습니다. 관리자에게 문의하세요."
			throw new Exception(errCd);
		} finally {
			// if(dis != null) dis.close();
		}

		return errCd; // 정상처리
	}

	/**
	 * 회수정보등록(센터 ← 도매업자) - 전일 소매회수정보(도매업자, 소매업자) 동일 쿼리 사용함 - 소매업자인 경우 은행코드, 계좌번호
	 * 필드 추가되어서 옴. 도매일경우 두 개필드 빈값으로 강제로 넣어줌.
	 * 
	 * @param list
	 * @param TRMS_DT
	 * @param TRMS_TKTM
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String urmInsertData(List<?> list) throws Exception {

		String sysSe = "A"; // 기타코드테이블(그룹코드: S004) : W: 웹시스템, A: 연계API
		// String rmk = ""; //비고
		String regDt = util.getShortDateString(); // 일자로 변경
													// util.getTodayString();
		String errCd = "0000";

		try {

			System.out.println("---------------start---------");
			for (int i = 0; i < list.size(); i++) {
				Map<String, String> map = (Map<String, String>) list.get(i);

				map.put("URM_RTRVL_REG_DT", regDt);
				map.put("RTRVL_CTNR_CD", map.get("container_code"));
				map.put("SYS_SE", sysSe);
				int sel = apiMapper.SELECT_DUPLE_CHECK_URM(map); // 중복체크
				if (sel > 0) {
					throw new Exception("B008"); // 이미 기존처리 데이타 존재
				}

				// 수량이 소수점으로 들어올경우 차단
				// if(map.get("qty").indexOf(".") > -1){
				// throw new Exception("B022"); //소수점 등록이 불가능합니다.
				// }

//				System.out.println("2");
				
				// 회수용기 체크
				int rtn = apiMapper.SELECT_AP_R03_EPCN_RTRVL_CTNR_CD(map);
				if (rtn == 0) {
					// errCd = "B999";
					throw new Exception("B023"); // 미등록된 회수용기코드입니다.
				}

				apiMapper.INSERT_EPCM_URM_MST_TMP(map);
				// if(map.get("sibling_seq").equals("1")){ //집계 데이타 인경우
				// apiMapper.INSERT_EPCM_URM_MST(map);
				// }else{ //회수 데이터
				// apiMapper.INSERT_EPCM_URM_LST(map);
				//
				// }

			}// row data for

			// 검증
			Map<String, String> map = new HashMap<String, String>();
			// map.put("WHSLD_BIZRNO", busiNo);
			// map.put("RTRVL_REG_DT", regDt);

			// 실데이타에 반영처리
			boolean keyCheck = false;
			List<Map<String, String>> chkList = new ArrayList<Map<String, String>>();
			for (int i = 0; i < list.size(); i++) {
				keyCheck = false;
				Map<String, String> listMap = (Map<String, String>) list.get(i);
				// listMap.put("WHSLD_BIZRNO", busiNo);
				// listMap.put("URM_RTRVL_DT", listMap.get("date"));
				// listMap.put("SERIAL_NO", listMap.get("serial_no"));
				// listMap.put("RTRVL_CTNR_CD", listMap.get("container_code"));
				// listMap.put("AREA_CD", listMap.get("area_code"));
				// listMap.put("URM_NM", listMap.get("branch_name"));
				// listMap.put("URM_CODE_NO", listMap.get("branch_code"));
				// listMap.put("URM_RECEIPT_NO", listMap.get("receipt_no"));
				// listMap.put("RECEIPT_SN", listMap.get("sibling_seq"));
				// listMap.put("URM_GTN_TOT", listMap.get("deposit_value"));
				// listMap.put("URM_QTY_TOT", listMap.get("qty"));
				// listMap.put("REG_PRSN_ID", listMap.get("reg_id"));
				// if(listMap.get("RECEIPT_SN").equals("1")){ //집계 데이타 인경우
				// continue;
				// }

				// 등록일자 제한
				// Map<String, String> map2 = new HashMap<String, String>();
				// map2.put("SDT_DT", listMap.get("RTRVL_DT")); //등록일자제한설정 등록일자
				// 1.DLIVY_DT,2.DRCT_RTRVL_DT, 3.EXCH_DT, 4.RTRVL_DT, 5.RTN_DT
				// map2.put("WORK_SE", "4"); //업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 ,
				// 5.반환

				// int sel = commonceService.rtc_dt_ck(map2); //등록일자제한설정
				//
				// if(sel !=1){
				// throw new Exception("A021"); //등록일자제한일자 입니다. 다시 한 번 확인해주시기
				// 바랍니다.
				// }

				// 사업자 확인
				// listMap.put("CUST_BIZRNO", listMap.get("RTL_BIZRNO"));
				// listMap.put("CUST_BIZRNM", listMap.get("RTL_ENP_NM"));
				// bizrCheck("D3", listMap); //소매거래처등록사업자(D3)

				for (int j = 0; j < chkList.size(); j++) {
					Map<String, String> listMap2 = (Map<String, String>) chkList
							.get(j);

					if (listMap.get("branch_code").equals(
							listMap2.get("branch_code"))
							&& listMap.get("serial_no").equals(
									listMap2.get("serial_no"))
							&& listMap.get("date").equals(listMap2.get("date"))
							&& listMap.get("receipt_no").equals(
									listMap2.get("receipt_no"))) {
						listMap.put("URM_DOC_NO", listMap2.get("URM_DOC_NO"));
						keyCheck = true;
						break;
					}// end of if
				}// end of for list2

				if (!keyCheck) {
					String urm_doc_no = listMap.get("date")
							+ listMap.get("serial_no")
							+ listMap.get("receipt_no");
					listMap.put("URM_DOC_NO", urm_doc_no);
					apiMapper.INSERT_EPCM_URM_MST(listMap);
					chkList.add(listMap);
				}
				// if(listMap.get("RECEIPT_SN").equals("1")){
				// //master
				//
				// listMap.put("RTRVL_DOC_NO", urm_doc_no);
				// apiMapper.INSERT_EPCM_URM_MST(map);
				// chkList.add(listMap);
				// }

				// detail
				apiMapper.INSERT_EPCM_URM_LST(listMap);
			}

			for (int j = 0; j < chkList.size(); j++) {// 마스터 합계 업데이트
				apiMapper.EPCM_URM_SUM_UPDATE((Map<String, String>) chkList
						.get(j));
			}

		} catch (IOException io) {
			io.printStackTrace();
		}catch (SQLException sq) {
			sq.printStackTrace();
		}catch (NullPointerException nu){
			nu.printStackTrace();
		}catch (Exception e) {
			// org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			if (e.getMessage() != null && e.getMessage().indexOf("B0") > -1)
				errCd = e.getMessage();
			if (e.getMessage() != null && e.getMessage().indexOf("A0") > -1)
				errCd = e.getMessage();

			if (e instanceof DataAccessException) {
				SQLException se = (SQLException) ((DataAccessException) e)
						.getRootCause();
				if (se.getErrorCode() == 1)
					errCd = "B008"; // 테이블 PK에러
									// System.out.println(se.getMessage());
			}

			// if(errCd.equals("0000")) errCd = "B003";
			throw new Exception(errCd);
		}

		return errCd;

	}

}
