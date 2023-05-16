package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 반환관리 Mapper
 * @author 양성수
 *
 */
@Mapper("epce9000301Mapper")
public interface EPCE9000301Mapper {


	 /**
	  * 반환관리 도매업자 구분 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000301_select () ;

	 /**
	  * 반환관리 생산자 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000301_select2 (Map<String, String> map) ;

	 /**
	  * 반환관리 도매업자 업체명 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000301_select3 (Map<String, String> map) ;

	 /**
	  * 반환관리 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000301_select4 (Map<String, Object> map) ;

	 /**
	  * 반환관리 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000301_select4_cnt (Map<String, Object> map) ;
	 
	 /**
	  * 반환내역상세조회(20200402추가)
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000301_select4_1 (Map<String, Object> map) ;
	 
	 /**
	  * 반환내역상세조회	카운트 (20200402추가)
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000301_select4_1_cnt (Map<String, Object> map) ;

	 /**
	  * 반환관리 실태조사시 상태값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce9000301_select5 (Map<String, String> map) ;

	 /**
	  * 반환관리 삭제시  변경시 반환상태 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce9000301_select6 (Map<String, String> map) ;

	 /**
	  * 반환등록요청 상태값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce9000301_select7 (Map<String, String> map) ;
	 
	 /**
	  * 반환관리 실태조사
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000301_insert (Map<String, String> map) ;

	 /**
	  * 반환관리 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000301_delete (Map<String, String> map) ;

	 /**
	  * 반환관리 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000301_update (Map<String, String> map) ;

	 /**
	  * 반환내역서 상세조회 공급 부분
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000364_select (Map<String, String> map) ;

	 /**
	  * 반환내역서 상세조회 그리드쪽
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000364_select2 (Map<String, String> map) ;

	 /**
	  * 반환내역서등록 상세 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000301_insert2 (Map<String, String> map) ;
	 
	 /**
	  * 반환내역서등록 검사
	  * @param map
	  * @return
	  * @
	  */
	 public int epce9000301_check (Map<String, String> map) ;
	 
	 /**
	  * 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000342_update (Map<String, String> map) ;
	 
	 /**
	  * 엑셀 업로드 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000331_select4 (Map<String, String> map) ;
	 /**
	 * 도매업자 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> rcs_nm_select(Map<String, String> inputMap) ;
	/**
	 * 도매업자 조회 센터
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> rcs_nm_select_all(Map<String, String> inputMap) ;
	
	public List<?> whsdlList(Map<String, String> inputMap) ;
}
