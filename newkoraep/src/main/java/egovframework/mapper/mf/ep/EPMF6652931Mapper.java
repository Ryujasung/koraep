package egovframework.mapper.mf.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 출고정보등록 Mapper
 * @author pc
 *
 */
@Mapper("epmf6652931Mapper")
public interface EPMF6652931Mapper {
	
	/**
	 * 생산자코드 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> epmf6652931_select1(Map<String, String> inputMap) ;
	
	/**
	 * 생산자코드 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public String epmf6652931_select2(Map<String, String> inputMap) ;
	
	/**
	 * 직매장/공장 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> epmf6652931_select3(Map<String, String> inputMap) ;
	
	/**
	 * 판매처 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> epmf6652931_select4(Map<String, String> inputMap) ;
	
	/**
	 * 빈용기명 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> epmf6652931_select5(Map<String, String> inputMap) ;
	
	/**
	  * 출고등록 등록시 검색 등록한 용기명 있는지 조회(중복체크)
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf6652931_select6 (Map<String, String> map) ;
	
	 /**
	 * 소매거래처관리 사업자 및 지점 등록 여부
	 * @return
	 * @
	 */
	 public HashMap<String, String> epmf6652931_select7(Map<String, String> map) ;
	 
	 /**
	  * 출고정보등록 엑셀 업로드 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf6652931_select8 (Map<String, String> map) ;
	 
	 /**
	  * 출고등록 마스터 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf6652931_update1 (Map<String, String> map) ;
	 
	 /**
	  * 출고등록 상세 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf6652931_update2 (Map<String, String> map) ;
	 
	 /**
	  * 출고등록 sum 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf6652931_update3 (Map<String, String> map) ;
	 
	 /**
	 * 소매거래처관리 사업자 등록
	 * @param map
	 * @
	 */
	 public void epmf6652931_insert(Map<String, String> map) ; 
	 
	/**
	 * 소매거래처관리 지점 등록
	 * @param map
	 * @
	 */
	 public void epmf6652931_insert2(Map<String, String> map) ;

}
