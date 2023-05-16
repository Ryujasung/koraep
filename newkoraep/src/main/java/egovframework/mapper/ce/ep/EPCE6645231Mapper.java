package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 직접회수정보등록 Mapper
 * @author pc
 *
 */
@Mapper("epce6645231Mapper")
public interface EPCE6645231Mapper {
	
	/**
	 * 생산자코드 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> epce6645231_select1(Map<String, String> inputMap) ;
	
	/**
	 * 생산자코드 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public String epce6645231_select2(Map<String, String> inputMap) ;
	
	/**
	 * 직매장/공장 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> epce6645231_select3(Map<String, String> inputMap) ;
	
	/**
	 * 판매처 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> epce6645231_select4(Map<String, String> inputMap) ;
	
	/**
	 * 빈용기명 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> epce6645231_select5(Map<String, String> inputMap) ;
	
	/**
	  * 직접회수등록 등록시 검색 등록한 용기명 있는지 조회(중복체크)
	  * @param map
	  * @return
	  * @
	  */
	 public int epce6645231_select6 (Map<String, String> map) ;
	
	 /**
	 * 소매거래처관리 사업자 및 지점 등록 여부
	 * @return
	 * @
	 */
	 public HashMap<String, String> epce6645231_select7(Map<String, String> map) ;
	 
	 /**
	  * 직접회수정보등록 엑셀 업로드 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6645231_select8 (Map<String, String> map) ;
	 
	 /**
	  * 직접회수정보변경 저장시 중복값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce6645231_select9 (Map<String, String> map) ;
	 
	 /**
	  * 직접회수등록 마스터 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epce6645231_update1 (Map<String, String> map) ;
	 
	 /**
	  * 직접회수등록 상세 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epce6645231_update2 (Map<String, String> map) ;
	 
	 /**
	  * 직접회수등록 sum 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epce6645231_update3 (Map<String, String> map) ;
	 
	 /**
	 * 소매거래처관리 사업자 등록
	 * @param map
	 * @
	 */
	 public void epce6645231_insert(Map<String, String> map) ; 
	 
	/**
	 * 소매거래처관리 지점 등록
	 * @param map
	 * @
	 */
	 public void epce6645231_insert2(Map<String, String> map) ;

}
