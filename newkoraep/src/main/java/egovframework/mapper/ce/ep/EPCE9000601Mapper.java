package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 반환관리 Mapper
 * @author 양성수
 *
 */
@Mapper("epce9000601Mapper")
public interface EPCE9000601Mapper {


	 /**
	  * 반환관리 도매업자 구분 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000601_select () ;

	 /**
	  * 반환관리 생산자 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000601_select2 (Map<String, String> map) ;

	 /**
	  * 반환관리 도매업자 업체명 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000601_select3 (Map<String, String> map) ;

	 /**
	  * 반환관리 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000601_select4 (Map<String, Object> map) ;

	 /**
	  * 반환내역서등록 상세 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000601_insert2 (Map<String, String> map) ;
	 
	 public void epce9000601_insert3 (Map<String, String> map) ;
	 
	 /**
	  *  중복체크   
	  * @param map
	  * @return
	  * @     
	  */
	 public int epce9000631_chk (Map<String, String> map);   
	 /**
	  *  중복체크   
	  * @param map
	  * @return
	  * @     
	  */
	 public int EPCE9000631_chk3 (Map<String, String> map);   
	 /**
	  * 엑셀 업로드 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000631_select4 (Map<String, String> map) ;
	 
	 /**
	  * 반환관리 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000601_select4_cnt (Map<String, Object> map) ;
	 
	 /**
	  * 반환내역상세조회(20200402추가)
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000601_select4_1 (Map<String, Object> map) ;
	 
	 /**
	  * 반환내역상세조회	카운트 (20200402추가)
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000601_select4_1_cnt (Map<String, Object> map) ;

	 /**
	  * 반환관리 실태조사시 상태값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce9000601_select5 (Map<String, String> map) ;

	 /**
	  * 반환관리 삭제시  변경시 반환상태 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce9000601_select6 (Map<String, String> map) ;

	 /**
	  * 반환등록요청 상태값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce9000601_select7 (Map<String, String> map) ;
	 
	 /**
	  * 반환관리 실태조사
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000601_insert (Map<String, String> map) ;
	 
	 
	 /**
	  * 톰라데이터입력
	  * @param map
	  * @return
	  * @
	  */
	 public void tomra_data_insert (Map<String, String> map) ;

	 /**
	  * 반환관리 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000601_delete (Map<String, String> map) ;
	 
	 public void epce9000601_delete2 (Map<String, String> map) ;

	 /**
	  * 반환관리 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000601_update (Map<String, String> map) ;
	 
	 /**
	  * 반환관리 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000601_update2 (Map<String, String> map) ;

	 /**
	  * 반환내역서 상세조회 공급 부분
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000664_select (Map<String, String> map) ;

	 /**
	  * 반환내역서 상세조회 그리드쪽
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000664_select2 (Map<String, String> map) ;

	public List<?> rtrvl_cd_list(HashMap<String, String> map);

	public List<?> dps_fee_list(HashMap<String, String> map);
	
	
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

	public List<?> epce9000642_select(Map<String, String> map);
	
	 /**
	  * 수정 저장
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000642_update(Map<String, String> map) ;

	public void epce9000642_delete(Map<String, String> map);

	public int SELECT_EPCN_RTRVL_CTNR_CD(Map<String, String> map) throws Exception;

	 
}
