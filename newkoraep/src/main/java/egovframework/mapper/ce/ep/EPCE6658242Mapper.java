package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 출고정보등록 Mapper
 * @author pc
 *
 */
@Mapper("epce6658242Mapper")
public interface EPCE6658242Mapper {
	
	/**
	 * 빈용기명 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> epce6658242_select1(Map<String, String> inputMap) ;
	
	/**
	  * 출고등록 등록시 검색 등록한 용기명 있는지 조회(중복체크)
	  * @param map
	  * @return
	  * @
	  */
	 public int epce6658242_select2 (Map<String, String> map) ;
	
	 /**
	 * 소매거래처관리 사업자 및 지점 등록 여부
	 * @return
	 * @
	 */
	 public HashMap<String, String> epce6658242_select3(Map<String, String> map) ;
	 
	 /**
	  * 출고정보변경  그리드 초기값
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6658242_select4 (Map<String, String> map) ;
	 
	 /**
	  * 출고정보변경 저장시 출고등록상태인지 조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce6658242_select5 (Map<String, String> map) ;
	 
	 /**
	  * 반환내역서변경  변경시 중복값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce6658242_select6 (Map<String, String> map) ;
	 
	 
	 /**
	  * 출고정보변경 상세 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epce6658242_insert (Map<String, String> map) ;
	 
	 /**
	  * 출고정보변경 sum 수정
	  * @param map
	  * @return
	  * @
	  */
	 public int epce6658242_update (Map<String, String> map) ;
	 
	 
	 /**
	  * 출고정보변경 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce6658242_delete(Map<String, String> map) ;

}
