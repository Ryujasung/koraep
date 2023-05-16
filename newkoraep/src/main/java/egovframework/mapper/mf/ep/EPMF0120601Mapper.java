package egovframework.mapper.mf.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 직매장별거래처관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epmf0120601Mapper")
public interface EPMF0120601Mapper {

	/**
	 * 직매장별거래처관리 리스트 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epmf0120601_select(Map<String, String> map) ;
	
	/**
	 * 직매장별거래처관리 리스트 조회
	 * @param map
	 * @return
	 * @
	 */
	public int epmf0120601_select_cnt(Map<String, String> map) ;
	
	/**
	 * 직매장별거래처관리  거래처구분 조회
	 * @param 
	 * @return
	 * @
	 */
	public List<?> epmf0120601_select2() ;
	
	/**
	 * 직매장별거래처관리  거래처별 용기코드 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epmf0120601_select3(Map<String, String> map) ;
	
	/**
	 * 직매장별거래처관리 거래상태 수정
	 * @param map
	 * @
	 */
	public void epmf0120601_update(Map<String, String> map) ;
	
	/**
	 * 직매장별거래처관리 기준수수료등록여부 변경
	 ** @param map
	 * @
	 */
	public void epmf0120601_update2(Map<String, String> map) ;
	
	 
	 /**
	 * 개별취급수수료 등록
	 * @param map
	 * @
	 */
	public void epmf0120601_insert(Map<String, String> map) ;
	
	 /**
	 * 개별취급수수료이력 등록
	 * @param map
	 * @
	 */
	public void epmf0120601_insert2(Map<String, String> map) ;
	
	 /**
	 * 개별취급수수료 삭제
	 * @param map
	 * @
	 */
	public void epmf0120601_delete(Map<String, String> map) ;
	
	
	
	/**
	  * 직매장별거래처관리 등록 조회
 	  * @param map
	  * @return
	  * @
	  */
	public List<?> epmf0120631_select(Map<String, String> map) ;
	
	/**
	  * 직매장별거래처관리 등록 조회
 	  * @param map
	  * @return
	  * @
	  */
	public int epmf0120631_select_cnt(Map<String, String> map) ;

	 
	 /**
	 * 직매장별거래처관리 거래처 등록
 	  * @param map
	 * @param map
	 * @
	 */
	public void epmf0120631_insert(Map<String, String> map) ;
	
	/**
	  * 개별취급수수료등록   적용번호 조회
	  * @param map
	  * @return
	  * @
	  */
	 public String epmf0164331_select7 (Map<String, String> map) ;
	
}
