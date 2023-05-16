/**
 * 
 */
package egovframework.mapper.api;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * @author Administrator
 *
 */
@Mapper("apiMapper")
public interface ApiMapper {

	/**
	 * api 발급키 검증
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public HashMap<String, String> SELECT_API_MBR_ISSU_KEY(String BIZRNO) throws Exception;
	
	
	/**
	 * 출고등록 중복체크
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_DUPLE_CHECK_AP_R01(Map<String, String> map) throws Exception;
	
	/**
	 * 출고정보 요약정보 - AP_R01
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R01_EPDM_DLIVY_LST_TMP(Map<String, String> map) throws Exception;
	
	
	/**
	 * 출고정보 상세 등록 - AP_R01
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R01_EPDM_DLIVY_DTL_TMP(Map<String, String> map) throws Exception;
	
	/**
	 * 구병실행상세 등록 - AP_R01
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R01_EPCN_CAP_DTL(Map<String, String> map) throws Exception;
	
	/**
	 * 출고등록 처리결과 검증확인 - AP_R01
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_AP_R01_EPDM_DLIVY_RSLT(Map<String, String> map) throws Exception;
	
	/**
	 * 수신 출고 데이타 실제 출고정보 마스터 등록  - AP_R01
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R01_EPDM_DLIVY_MST(Map<String, String> map) throws Exception;
	
	/**
	 * 수신 출고 데이타 실제 출고정보 등록  - AP_R01
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R01_EPDM_DLIVY_INFO(Map<String, String> map) throws Exception;
		
	/**
	 * 직접배송 중복체크
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_DUPLE_CHECK_AP_R02(Map<String, String> map) throws Exception;
	
	/**
	 * 직접배송 요약 임시 데이타 등록 - AP_R02
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R02_EPDM_DRCT_DVRY_LST_TMP(Map<String, String> map) throws Exception;
	
	/**
	 * 직접배송 상세 임시 데이타 등록 - AP_R02
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R02_EPDM_DRCT_DVRY_DTL_TMP(Map<String, String> map) throws Exception;
	
	/**
	 * 직접배송 상세 임시 미반환수량, 출고보증금, 회수 보증금, 반환보증금, 미반환 보증금 계산 - AP_R02
	 * @param map
	 * @throws Exception
	 */
	public void UPDATE_AP_R02_EPDM_DRCT_DVRY_DTL_TMP(Map<String, String> map) throws Exception;
	
	/**
	 * 직접배송 처리결과 검증확인 - AP_R02
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_AP_R02_EPDM_DRCT_DVRY_RSLT(Map<String, String> map) throws Exception;
	
	/**
	 * 직배송 데이타 실제 등록 - AP_R02
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R02_EPDM_DRCT_DVRY_INFO(Map<String, String> map) throws Exception;
	
	/**
	 * 회수 중복체크
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_DUPLE_CHECK_AP_R03(Map<String, String> map) throws Exception;
	
	/**
	 * 회수 데이타 요약 임시등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_EPCM_RTRVL_LST_TMP(Map<String, String> map) throws Exception;
	
	/**
	 * 회수 데이타 상세 임시등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_EPCM_RTRVL_DTL_TMP(Map<String, String> map) throws Exception;
	
	/**
	 * 회수 데이타 처리결과 검증
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_AP_R03_EPCM_RTRVL_RSLT(Map<String, String> map) throws Exception;
	
	/**
	 * 회수 상태 조회
	 * @param map
	 * @throws Exception
	 */
	public String SELECT_AP_R03_EPCM_RTRVL_STAT_CD(Map<String, String> map) throws Exception;
	
	
	/**
	 * 회수 데이타 마스터 등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R03_EPCM_RTRVL_MST(Map<String, String> map) throws Exception;
	
	/**
	 * 회수 데이타 실제 등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R03_EPCM_RTRVL_INFO(Map<String, String> map) throws Exception;
	
	/**
	 * 회수 데이타 수정 - 기존데이타 삭제(후 등록)
	 * @param map
	 * @throws Exception
	 */
	public void DELETE_AP_R03_EPCM_RTRVL_DTL_TMP(Map<String, String> map) throws Exception;
	
	public void DELETE_AP_R03_EPCM_RTRVL_LST_TMP(Map<String, String> map) throws Exception;
	
	public void DELETE_AP_R03_EPCM_RTRVL_INFO(Map<String, String> map) throws Exception;
	
	/**
	 * 입고 정보조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<?> SELECT_AP_R05_EPCM_RTN_INFO(Map<String, String> map) throws Exception;
	
	/**
	 * 입고정보 조회기간 체크
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_AP_R05_CHK_DT(Map<String, String> map) throws Exception;
	
	/**
	 * 직접회수 중복체크
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_DUPLE_CHECK_AP_R06(Map<String, String> map) throws Exception;
	
	
	/**
	 * 직접회수 데이타 요약 임시등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R06_EPDM_DRCT_RTRVL_LST_TMP(Map<String, String> map) throws Exception;
	
	
	/**
	 * 직접회수 데이타 상세 임시등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R06_EPDM_DRCT_RTRVL_DTL_TMP(Map<String, String> map) throws Exception;
	
	
	/**
	 * 직접회수 데이타 처리결과 검증
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_AP_R06_EPDM_DRCT_RTRVL_RSLT(Map<String, String> map) throws Exception;
	
	
	/**
	 * 직접회수 등록순번 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_RGST_SN_EPDM_DRCT_RTRVL_INFO(Map<String, String> map) throws Exception;
	
	/**
	 * 직접회수 데이타 마스터 등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R06_EPDM_DRCT_RTRVL_MST(Map<String, String> map) throws Exception;
	
	/**
	 * 직접회수 데이타 실제 등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R06_EPDM_DRCT_RTRVL_INFO(Map<String, String> map) throws Exception;
	
	/**
	 * 구병실행상세 등록 - AP_R06
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R06_EPCN_CAP_DTL(Map<String, String> map) throws Exception;
	
	/**
	 * 반환정보 목록 중복체크 - AP_R07
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_DUPLE_CHECK_AP_R07(Map<String, String> map) throws Exception;
	
	
	/**
	 * 반환정보 목록 임시등록 - AP_R07
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R07_EPCM_RTN_LST_TMP(Map<String, String> map) throws Exception;
	
	
	/**
	 * 반환정보 상세 상세 임시등록 - AP_R07
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R07_EPCM_RTN_DTL_TMP(Map<String, String> map) throws Exception;
	
	/**
	 * 반환정보 데이타 처리결과 검증
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_AP_R07_EPCM_RTN_RSLT(Map<String, String> map) throws Exception;
	
	/**
	 * 반환관리 마스터 등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R07_EPCM_RTN_MST_TMP(Map<String, String> map) throws Exception;
	
	/**
	 * 반환관리 상세 등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_AP_R07_EPCM_RTN_INFO_TMP(Map<String, String> map) throws Exception;
	
	/**
	 * 반환관리 마스터 sum 수정
	 * @param map
	 * @throws Exception
	 */
	public void UPDATE_AP_R07_EPCM_RTN_MST_TMP(Map<String, String> map) throws Exception;
	
	/**
	 * 용기코드조회
	 * @param map
	 * @throws Exception
	 */
	public List<?> SELECT_AP_R07_EPCN_INDV_FEE_MGNT(Map<String, String> map) throws Exception;
	
	/**
	 * 표준용기코드 등록여부 확인
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_AP_R08_EPCN_STD_CTNR_CD_CNT(Map<String, String> map) throws Exception;

	/**
	 * 생산자빈용기상세 임시 등록
	 * @param map
	 * @throws Exception
	 */
	public int INSERT_AP_R08_EPCN_MFC_CTNR_TMP(Map<String, String> map) throws Exception;

	/**
	 * 생산자빈용기정보 등록
	 * @param map
	 * @throws Exception
	 */
	public int INSERT_AP_R08_EPCN_MFC_CTNR_INFO(Map<String, String> map) throws Exception;

	/**
	 * 생산자빈용기정보 삭제
	 * @param map
	 * @throws Exception
	 */
	public int DELETE_AP_R08_EPCN_MFC_CTNR_INFO(Map<String, String> map) throws Exception;


	/**
	 * 생산자입고정보 목록 임시 등록
	 * @param map
	 * @throws Exception
	 */
	public int INSERT_AP_R09_EPCN_MFC_CFM_LST_TMP(Map<String, String> map) throws Exception;

	/**
	 * 생산자입고정보 상세 임시 등록
	 * @param map
	 * @throws Exception
	 */
	public int INSERT_AP_R09_EPCN_MFC_CFM_DTL_TMP(Map<String, String> map) throws Exception;

	/**
	 * 생산자입고 요약 및 상세 데이타 검증
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_AP_R09_EPCN_MFC_CFM_TMP(Map<String, String> map) throws Exception;
	
	/**
	 * 생산자입고확인정보 등록
	 * @param map
	 * @throws Exception
	 */
	public int INSERT_AP_R09_EPCN_MFC_CFM_INFO(Map<String, String> map) throws Exception;
	
	/**
	 * API 이력 인서트
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_EPCN_EXEC_HIST(Map<String, String> map) throws Exception;
	
	/**
	 * 사업자 확인
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public HashMap<String, String> SELECT_BIZR_INFO(Map<String, String> map) throws Exception;
	
	/**
	 * 사업자등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_EPCN_BIZR_INFO(Map<String, String> map) throws Exception;
	
	/**
	 * 지점등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_EPCN_BRCH_INFO(Map<String, String> map) throws Exception;
	
	/**
	 * 직매장 확인
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public HashMap<String, String> SELECT_BRCH_INFO(Map<String, String> map) throws Exception;
	
	/**
	 * 직매장등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_EPCN_BRCH_INFO2(Map<String, String> map) throws Exception;
	
	/**
	 * API수신 순번 채번
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_EPCN_API_DTL_HIST_SEQ() throws Exception;
	
	/**
	 * API수신 등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_EPCN_API_DTL_HIST(Map<String, String> map) throws Exception;

	/**
	 * API수신 후 처리결과 반영
	 * @param map
	 * @throws Exception
	 */
	public void UPDATE_EPCN_API_DTL_HIST_ANSR(Map<String, String> map) throws Exception;

	/**
	 * 직매장 정보 확인
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public HashMap<String, String> SELECT_MFC_BRCH_INFO(Map<String, String> map) throws Exception;
	
	/**
	 * ERP_CD 등록 - AP_R07
	 * @param map
	 * @throws Exception
	 */
	public void UPDATE_AP_R07_ERP_CD(Map<String, String> map) throws Exception;


	public int SELECT_AP_R03_EPCN_RTRVL_CTNR_CD(Map<String, String> map) throws Exception;


	/**
	 * 무인회수기 수신 순번 채번
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_EPCN_URM_HIST_SEQ() throws Exception;
	
	/**
	 * 무인회수기 수신 등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_EPCN_URM_HIST(Map<String, String> map) throws Exception;

	/**
	 * 무인회수기 수신 후 처리결과 반영
	 * @param map
	 * @throws Exception
	 */
	public void UPDATE_EPCN_URM_HIST_ANSR(Map<String, String> map) throws Exception;


	/**
	 * 무인회수기 회수 데이타 상세 임시등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_EPCM_URM_MST_TMP(Map<String, String> map) throws Exception;
	
	
	/**
	 * 무인회수기 회수 데이타 마스터 등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_EPCM_URM_MST(Map<String, String> map) throws Exception;
	
	/**
	 * 무인회수기 회수 데이타 실제 등록
	 * @param map
	 * @throws Exception
	 */
	public void INSERT_EPCM_URM_LST(Map<String, String> map) throws Exception;


	public void EPCM_URM_SUM_UPDATE(Map<String, String> map) throws Exception;
	
	/**
	 * 회수 중복체크
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int SELECT_DUPLE_CHECK_URM(Map<String, String> map) throws Exception;
	
	
	
}
