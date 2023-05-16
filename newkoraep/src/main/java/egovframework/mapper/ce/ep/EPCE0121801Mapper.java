/**
 * 
 */
package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 소매거래처 관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epce0121801Mapper")
public interface EPCE0121801Mapper {
	
	/**
	 * 거래처구분 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epce0121801_select() ;
		
	/**
	 * 소매거래처관리 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epce0121801_select2 (Map<String, String> map) ;
	
	/**
	 * 소매거래처관리 리스트 조회
	 * @return
	 * @
	 */
	public int epce0121801_select2_cnt(Map<String, String> map) ;
	
	/**
	 * 소매거래처관리 사업자 및 지점 등록 여부
	 * @return
	 * @
	 */
	public HashMap<String, String> epce0121831_select(Map<String, String> map) ;
	
	/**
	 * 소매거래처관리 데이터 체크
	 * @return
	 * @
	 */
	public List<?> epce0121831_select2(Map<String, String> map) ;
	
	/**
	  * 소매거래처관리 데이터 체크 (엑셀저장용)
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0121831_select3(Map<String, String> map) ;
	
	/**
	 * 소매거래처관리 사업자 등록
	 * @param checkMap
	 * @
	 */
	public void epce0121831_insert(Map<String, String> checkMap) ;
	
	/**
	 * 소매거래처관리 지점 등록
	 * @param checkMap
	 * @
	 */
	public void epce0121831_insert2(Map<String, String> checkMap) ;
	
	/**
	 * 소매거래처관리 거래처 등록
	 * @param map
	 * @
	 */
	public void epce0121831_insert3(Map<String, String> map) ;
	
	/**
	 * 소매거래처관리 데이터 확인
	 * @return
	 * @
	 */
	public int epce0121831_select4(Map<String, String> map) ;
	
	
	/**
	 * 가맹점 거래처 등록/수정
	 * @param map
	 * @
	 */
	public void epce0121831_update(Map<String, String> map) ;
	
	/**
	 * 소매거래처관리 거래상태 수정
	 * @param map
	 * @
	 */
	public void epce0121801_update(Map<String, String> map) ;
	
	/**
	 * 사업자정보 변경
	 * @param map
	 * @
	 */
	public int epce0121888_update(Map<String, String> map) ;
	
	/**
	 * 지점정보 변경
	 * @param map
	 * @
	 */
	public void epce0121888_update2(Map<String, String> map) ;
	
	/**
	 * 거래처정보 변경
	 * @param map
	 * @
	 */
	public void epce0121888_update3(Map<String, String> map) ;

	
	
	 /**
	  * 회수증빙자료 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2925897_delete (Map<String, String> map);
	 
	 
/***********************************************************************************************************************************************
 *회수증빙자료관리 저장
 ************************************************************************************************************************************************/
	 
	 /**
	  * 회수증빙자료관리 저장
	  * @param map
	  * @return
	  * @
	  */
	 public void epce01218881_insert (Map<String, String> map);

	public void epce0121801_delete(Map<String, String> map);

}
