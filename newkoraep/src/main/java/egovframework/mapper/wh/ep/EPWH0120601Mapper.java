/**
 *
 */
package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 직매장별거래처관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epwh0120601Mapper")
public interface EPWH0120601Mapper {

	/**
	 * 직매장별거래처관리 리스트 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh0120601_select(Map<String, String> map) ;

	/**
	 * 직매장별거래처관리 리스트 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh0120601_excel(Map<String, Object> map) ;

	/**
	 * 직매장별거래처관리 리스트 조회
	 * @param map
	 * @return
	 * @
	 */
	public int epwh0120601_select_cnt(Map<String, String> map) ;

	/**
	 * 직매장별거래처관리  거래처구분 조회
s	 * @return
	 * @
	 */
	public List<?> epwh0120601_select2() ;

	/**
	 * 직매장별거래처관리  거래처별 용기코드 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh0120601_select3(Map<String, String> map) ;

	/**
	  * 개별취급수수료등록   적용번호 조회
	  * @param map
	  * @return
	  * @
	  */
	 public String epwh0120601_select4 (Map<String, String> map) ;

	/**
	 * 직매장별거래처관리 거래상태 수정
	 * @param map
	 * @
	 */
	public void epwh0120601_update(Map<String, String> map) ;

	/**
	 * 직매장별거래처관리 기준수수료등록여부 변경
	 ** @param map
	 * @
	 */
	public void epwh0120601_update2(Map<String, String> map) ;


	 /**
	 * 개별취급수수료 등록
	 * @param map
	 * @
	 */
	public void epwh0120601_insert(Map<String, String> map) ;

	 /**
	 * 개별취급수수료이력 등록
	 * @param map
	 * @
	 */
	public void epwh0120601_insert2(Map<String, String> map) ;

	 /**
	 * 개별취급수수료 삭제
	 * @param map
	 * @
	 */
	public void epwh0120601_delete(Map<String, String> map) ;

	/**
	  * 직매장별거래처관리 등록 조회
 	  * @param map
	  * @return
	  * @
	  */
	public List<?> epwh0120631_select(Map<String, String> map) ;


	 /**
	 * 직매장별거래처관리 거래처 등록
	 * @param map
	 * @
	 */
	public void epwh0120631_insert(Map<String, String> map) ;

}
