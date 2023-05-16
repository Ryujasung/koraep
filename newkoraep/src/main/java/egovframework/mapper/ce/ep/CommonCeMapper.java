package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.koraep.ce.dto.UserVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("commonceMapper")
public interface CommonCeMapper {

	/**
	 * 사용자 조회 VO
	 * @param map
	 * @return
	 * @
	 */
	public UserVO SELECT_USER_VO(HashMap<String, String> map) ;

	/**
	 * 회원 아이디 찾기
	 * @param map
	 * @return
	 * @
	 */
	public HashMap<String, String> SELECT_SEARCH_USER_ID(HashMap<String, String> map) ;


	/**
	 * 사용자 메뉴 그룹/메뉴
	 * @param vo
	 * @return
	 * @
	 */
	public List<?> SELECT_USER_MENU_LIST(UserVO vo) ;

	/**
	 * 사용자 메뉴 그룹/메뉴 - 모바일용
	 * @param vo
	 * @return
	 * @
	 */
	public List<?> SELECT_USER_MENU_LIST_M(UserVO vo) ;


	/**
	 * 인증키 생성을 위한 사업자정보 조회(약정일자,회원구분,관리자id)
	 * @param map
	 * @return
	 * @
	 */
	public HashMap<String, String> SELECT_MBR_ISSU_KEY_INFO(String BIZRNO) ;



	/**
	 * 비밀번호 오류횟수 +1
	 * @param map
	 * @
	 */
	public void UPDATE_PW_ERR_ADD(HashMap<String, String> map);

	/**
	 * 비밀번호 변경요청
	 * @param map
	 * @
	 */
	public void UPDATE_USER_PWDCHG(HashMap<String, String> map) ;


	/**
	 * 관리자 패스워드 변경
	 * @param map
	 * @
	 */
	public void UPDATE_USER_ADMIN_PWDCHG(HashMap<String, String> map) ;


	/**
	 * 언어구분
	 * @return
	 * @
	 */
	public List<?> SELECT_LANG_SE_CD_LIST() ;


	/**
	 * 공통코드 조회 - singleton
	 * @return
	 * @
	 */
	public List<?> SELECT_COMMON_CD_LIST_NEW(HashMap<String, String> map) ;

	/**
	 * 공통코드 조회 - singleton
	 * @return
	 * @
	 */
	public List<?> SELECT_COMMON_CD_LIST_NEW2(HashMap<String, String> map) ;


	/**
	 * 공통코드 조회 - singleton
	 * @return
	 * @
	 */
	public List<?> SELECT_COMMON_CD_LIST() ;


	/**
	 * 은행코드 조회 - singleton
	 * @return
	 * @
	 */
	public List<?> SELECT_BANK_CD_LIST() ;


	/**
	 * 에러코드 조회 - singleton
	 * @return
	 * @
	 */
	public List<?> SELECT_ERR_CD_LIST() ;

	/**
	 * 에러코드 조회 - singleton
	 * @return
	 * @
	 */
	public List<?> SELECT_ERR_CD_LIST_NEW(HashMap<String, String> map) ;




	/**
	 * 로그인 이력 등록
	 * @param map
	 * @
	 */
	public void INSERT_LOGIN_HIST(HashMap<String, String> map) ;


	/**
	 * 최종 로그인 시간 등록
	 * @param map
	 * @
	 */
	public void UPDATE_LAST_LOGIN_DTTM(HashMap<String, String> map) ;

	/**
	 * 로그인 등록(로그인 이력 업데이트)
	 * @param map
	 * @
	 */
	public void UPDATE_LOGIN_HIST(HashMap<String, String> map) ;


	/**
	 * 로그아웃 등록(로그인 이력 업데이트)
	 * @param map
	 * @
	 */
	public void UPDATE_FORCE_LOGOUT_HIST(HashMap<String, String> map) ;


	/**
	 * 프로그램 실행이력
	 * @param map
	 * @
	 */
	public void INSERT_EPCN_EXEC_HIST(HashMap<String, String> map) ;


	/**
	 * 사업장 정보 및 계좌정보 ERP 연계 프로시저 호출
	 * @param map
	 * @
	 */
	public void UPDATE_ERP_PROC_BSNM_SEND_INFO(HashMap<String, String> map) ;


	/**
	 * 정산 기준 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> SELECT_EPCN_EXCA_BSS_MGNT_LIST() ;


	/**
	 * 빈용기명 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> ctnr_nm_select(Map<String, String> inputMap) ;

	/**
	 * 빈용기명 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> ctnr_nm_std_dps_select(Map<String, String> inputMap) ;
	
	/**
	 * 빈용기명 조회 거래중인 것들만
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> ctnr_nm_select2(Map<String, String> inputMap) ;


	/**
	 * 빈용기명 구분조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> ctnr_se_select(Map<String, String> inputMap) ;

	/**
	 * 용기코드제한여부 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public String ctnr_cd_rtc_yn(Map<String, String> inputMap) ;
	
	/**
	 * 빈용기 취급수수료 + 보증금 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> ctnr_cd_select(Map<String, String> inputMap) ;
	
	/**
	 * 빈용기 취급수수료 + 보증금 조회 (전체 생산자)
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> ctnr_cd_select_all(Map<String, String> inputMap) ;

	/**
	 * 조건별 사업자 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> bizr_select(Map<String, String> inputMap) ;

	/**
	 * 생산자 조회 모든생산자 조회
	 * @param
	 * @return
	 * @
	 */
	public List<?> mfc_bizrnm_select(Map<String, String> inputMap) ;

	/**
	 * 총괄직매장
	 * @param
	 * @return
	 * @
	 */
	public List<?> grp_brch_no_select(Map<String, String> inputMap) ;

	/**
	 * 도매업자로그인 생산자조회
	 * @param
	 * @return
	 * @
	 */
	public List<?> mfc_bizrnm_select_wh(Map<String, String> inputMap) ;

	/**
	 * 생산자 로그인 생산자조회
	 * @param
	 * @return
	 * @
	 */
	public List<?> mfc_bizrnm_select_mf(Map<String, String> inputMap) ;


	/**
	 * 사업자유형코드 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public String bizr_tp_cd_select(Map<String, String> inputMap) ;

	/**
	 * 도매업자,공병상이랑 거래중인 생산자 조회    STAT_CD  에따라 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> mfc_bizrnm_select2(Map<String, String> inputMap) ;

	/**
	 * 도매업자,공병상이랑 거래중인 생산자 조회    STAT_CD  에따라 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> mfc_bizrnm_select6(Map<String, String> inputMap) ;

	/**
	 * 도매업자,공병상이랑 거래중인 생산자의 직매장 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> mfc_bizrnm_select3(Map<String, String> inputMap) ;

	/**
	 * 생산자랑 거래중인 도매업자 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> mfc_bizrnm_select4(Map<String, String> inputMap) ;

	/**
	 * 생산자랑 거래중인 도매업자 직매장 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> mfc_bizrnm_select5(Map<String, String> inputMap) ;



	/**
	 * 사업자 유형에 따른 도매업자 업체명 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> enp_nm_select(Map<String, String> inputMap) ;

	/**
	 * 도매업자 구분 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> whsdl_se_select(Map<String, String> inputMap) ;

	/**
	 * 소매업자 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> rtl_select(Map<String, String> inputMap) ;


	/**
	 * 도매랑 거래중인 소매업자  (소매거래처정보 테이블에서 가져오기)
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> rtl_cust_select(Map<String, String> inputMap) ;

	/**
	 * 도매업자 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> whsdl_select(Map<String, String> inputMap) ;

	/**
	 * 사업자에 따른 지점 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> brch_nm_select(Map<String, String> inputMap) ;

	/**
	 * 문서채번 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public String doc_psnb_select(Map<String, String> inputMap) ;
	
	/**
	 * 문서채번 조회 (회수)
	 * @param inputMap
	 * @return
	 * @
	 */
	public String doc_psnb_select_rv(Map<String, String> inputMap) ;

	/**
	 * 문서채번 저장
	 * @param inputMap
	 * @return
	 * @
	 */
	public void doc_psnb_insert(Map<String, String> inputMap) ;

	/**
	 * 채번 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public String psnb_select(Map<String, String> inputMap) ;

	/**
	 * 채번 저장
	 * @param inputMap
	 * @return
	 * @
	 */
	public void psnb_insert(Map<String, String> inputMap) ;


	/**
	 * 사업자에 따른 부서 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> dept_nm_select(Map<String, String> inputMap) ;

	/**
	 * 언어목록 조회
	 * @param
	 * @return
	 * @
	 */
	public List<?> SELECT_TEXT_LIST() ;

	/**
	 * 타이틀명 조회
	 * @param
	 * @return
	 * @
	 */
	public String SELECT_MENU_TITLE(HashMap<String, String> map) ;

	/**
	 * 버튼 조회
	 * @param
	 * @return
	 * @
	 */
	public List<?> SELECT_BTN_LIST(Map<String, String> map) ;

	/**
	 * 오류 이력발생 이력 등록
	 * @param map
	 * @
	 */
	public void INSERT_EPCN_ERR_HIST(HashMap<String, String> map) ;

	/**
	 * API 이력 등록
	 * @param map
	 * @
	 */
	public void INSERT_EPCN_API_HIST(HashMap<String, String> map) ;

	/**
	 * 그리드컬럼 조회
	 * @param map
	 * @
	 */
	public List<?> GRID_INFO_SELECT(Map<String, String> map) ;

	/**
	 * 그리드컬럼 저장
	 * @param map
	 * @
	 */
	public void GRID_INFO_INSERT(Map<String, String> map) ;


	/**
	 * 정산기준관리 조회
	 * @param map
	 * @
	 */
	public List<?> std_mgnt_select(Map<String, String> map) ;

	/**
	 * 정산기준관리 생산자 조회
	 * @param map
	 * @
	 */
	public List<?> std_mgnt_mfc_select(Map<String, String> map) ;


	/**
	 * 회수용기코드
	 * @param map
	 * @
	 */
	public List<?> rtrvl_ctnr_cd_select(Map<String, String> map) ;

	/**
	 * 회수용기코드 조건 추가
	 * @param map
	 * @
	 */
	public List<?> rtrvl_ctnr_cd_select2(Map<String, String> map) ;

	/**
	 * 회수용기코드 보증금 ,취급수수료
	 * @param map
	 * @
	 */
	public List<?> rtrvl_ctnr_dps_fee_select(Map<String, String> map) ;

	/**
	 * 등록일자제한설정
	 * @param map
	 * @
	 */
	public HashMap<?,?> rtc_dt_list_select(Map<String, String> map) ;

	/**
	 * 등록일자제한설정 입력일 체크
	 * @param map
	 * @
	 */
	public int rtc_dt_ck(Map<String, String> map) ;

	/**
	 * 사용자권한 인서트
	 * @param map
	 * @
	 */
	public void ath_grp_insert(Map<String, String> map) ;

	/**
	 * 알림코드 채번
	 * @param map
	 * @
	 */
	public String anc_std_cd_select(Map<String, String> map) ;

	/**
	 * 알림 인서트
	 * @param map
	 * @
	 */
	public void anc_mgnt_insert(Map<String, String> map) ;

	/**
	 * 알림 인서트
	 * @param map
	 * @
	 */
	public void anc_info_insert(Map<String, String> map) ;

	/**
	 * 알림 인서트
	 * @param map
	 * @
	 */
	public void anc_insert(Map<String, String> map) ;

	/**
	 * 메인 알림조회
	 * @param
	 * @return
	 * @
	 */
	public List<?> SELECT_ANC_LIST(String userId) ;

	/**
	 * 메인 알림조회 모바일
	 * @param
	 * @return
	 * @
	 */
	public List<?> SELECT_ANC_LIST_M(String userId) ;

	/**
	 * 알림 확인 처리
	 * @param map
	 * @
	 */
	public void confirm_anc(Map<String, String> map) ;

	/**
	 * 메인 출고량 조회
	 * @param
	 * @return
	 * @
	 */
	public String SELECT_MAIN_DLIVY_CNT(Map<String, String> map) ;

	/**
	 * 메인 입고량 조회
	 * @param
	 * @return
	 * @
	 */
	public String SELECT_MAIN_CFM_CNT(Map<String, String> map) ;

	/**
	 * 메인 출고량 조회
	 * @param
	 * @return
	 * @
	 */
	public String SELECT_MAIN_DLIVY_CNT_T(Map<String, String> map) ;

	/**
	 * 메인 입고량 조회
	 * @param
	 * @return
	 * @
	 */
	public String SELECT_MAIN_CFM_CNT_T(Map<String, String> map) ;

	/**
	 * 메인 회수현황건수 조회
	 * @param
	 * @return
	 * @
	 */
	public String SELECT_MAIN_RTRVL_CNT(Map<String, String> map) ;

	/**
	 * 메인 입고현황건수 조회
	 * @param
	 * @return
	 * @
	 */
	public String SELECT_MAIN_RTN_CNT(Map<String, String> map) ;

	/**
	 * 메인 지급금액 조회
	 * @param
	 * @return
	 * @
	 */
	public String SELECT_MAIN_PAY_AMT(Map<String, String> map) ;

	/**
	 * 메인 입고관리 조회
	 * @param
	 * @return
	 * @
	 */
	public List<?> SELECT_MAIN_CFM_LIST(Map<String, String> map) ;

	/**
	 * 메인 입고정정확인 조회
	 * @param
	 * @return
	 * @
	 */
	public List<?> SELECT_MAIN_CFM_CRCT_LIST(Map<String, String> map) ;

	/**
	 * 메인 교환관리 조회
	 * @param
	 * @return
	 * @
	 */
	public List<?> SELECT_MAIN_EXCH_LIST(Map<String, String> map) ;

	/**
	 * 메인 공지사항 조회
	 * @param
	 * @return
	 * @
	 */
	public List<?> SELECT_MAIN_NOTI_LIST(Map<String, String> map) ;

	/**
	 * 메인 문의/답변 조회
	 * @param
	 * @return
	 * @
	 */
	public List<?> SELECT_MAIN_ASK_LIST(Map<String, String> map) ;

	/**
	 * 메인 알림내역 조회
	 * @param
	 * @return
	 * @
	 */
	public List<?> SELECT_MAIN_ANC_LIST(String userId) ;

	/**
	 * 모바일사용자정보 업데이트
	 * @param map
	 * @
	 */
	public void updateMblUserInfo(HashMap<String, String> map) ;

	/**
	 * 정산기간정보 조회
	 * @param
	 * @return
	 * @
	 */
	public HashMap<String, String> SELECT_EXCA_STD_MGNT(HashMap<String, String> map) ;

	/**
	 * 알림 보내기
	 * @param map
	 * @
	 */
	public void send_anc(String ANC_STD_CD) ;

	/**
	 * 개인정보취급방침 변경 동의
	 * @param map
	 * @
	 */
	public void UPDATE_PRSN_INFO_CHG_AGR_YN(HashMap<String, String> map) ;
	
	
	/**
	 * 직매장별거래처정보 사업자유형코드 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public String SELECT_BIZR_TP_CD(Map<String, String> inputMap) ;
	
	/**
	 * 20200317 보나뱅크 ERP 설문
	 * @param
	 * @return
	 * @
	 */
	public List<?> SELECT_SVY_MST_LIST2(UserVO vo) ;
	
	/**
	 * 참여하지 않은 설문조사 조회
	 * @param
	 * @return
	 * @
	 */
	public List<?> SELECT_SVY_MST_LIST(UserVO vo) ;


	public int loginErrCnt(HashMap<String, String> map);

	public String loginPwdChg(HashMap<String, String> map);

	public Long privacycnt();

	public void insertPrivacy(HashMap<String, Object> data);

	public List<?> pbox_select(HashMap<String, String> map);
	
	
	
}
