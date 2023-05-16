package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 알림 관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epce3989701Mapper")
public interface EPCE3989701Mapper {

	/**
	 * 알림관리 목록
	 * @return
	 * @
	 */
	public List<?> epce3989701_select() ;

	/**
	 * 알림관리 사용여부 수정
	 * @param map
	 * @
	 */
	public void epce3989701_update(Map<String, String> map) ;
	
	/**
	 * 알림코드 채번
	 * @param map
	 * @
	 */
	public String epce3989701_select2(Map<String, String> map) ;
	
	/**
	 * 알림관리 등록
	 * @param map
	 * @
	 */
	public void epce3989701_insert(Map<String, String> map) ;
	
	/**
	 * 알림관리 대상 등록
	 * @param map
	 * @
	 */
	public void epce3989701_insert2(Map<String, String> map) ;
	
	/**
	 * 알림확인
	 * @return
	 * @
	 */
	public List<?> epce3989775_select(Map<String, String> map) ;
	
	/**
	 * 공지알림이력조회
	 * @return
	 * @
	 */
	public List<?> epce3989776_select(Map<String, String> map) ;
	
	/**
	  * API전송이력 조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce3989776_select_cnt (Map<String, String> map) ;
}


