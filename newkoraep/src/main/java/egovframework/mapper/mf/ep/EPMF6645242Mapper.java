package egovframework.mapper.mf.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 직접회수정보등록 Mapper
 * @author pc
 *
 */
@Mapper("epmf6645242Mapper")
public interface EPMF6645242Mapper {
	
	/**
	 * 빈용기명 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> epmf6645242_select1(Map<String, String> inputMap) ;
	
	/**
	  * 직접회수등록 등록시 검색 등록한 용기명 있는지 조회(중복체크)
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf6645242_select2 (Map<String, String> map) ;
	
	 /**
	 * 소매거래처관리 사업자 및 지점 등록 여부
	 * @return
	 * @
	 */
	 public HashMap<String, String> epmf6645242_select3(Map<String, String> map) ;
	 
	 /**
	  * 직접회수정보변경  그리드 초기값
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf6645242_select4 (Map<String, String> map) ;
	 
	 /**
	  * 직접회수정보변경 저장시 직접회수등록상태인지 조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf6645242_select5 (Map<String, String> map) ;
	 
	 /**
	  * 직접회수정보변경 저장시 중복값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf6645242_select6 (Map<String, String> map) ;
	 
	 
	 /**
	  * 직접회수정보변경 상세 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf6645242_insert (Map<String, String> map) ;
	 
	 /**
	  * 직접회수정보변경 sum 수정
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf6645242_update (Map<String, String> map) ;
	 
	 
	 /**
	  * 직접회수정보변경 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf6645242_delete(Map<String, String> map) ;

}
