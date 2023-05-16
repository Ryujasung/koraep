package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 버튼권한관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epce3991801Mapper")
public interface EPCE3991801Mapper {

	/**
	 * 메뉴 조회
	 * @return
	 * @
	 */
	public List<?> epce3991801_select(Map<String, String> data) ;
	
	/**
	 * 버튼 조회
	 * @return
	 * @
	 */
	public List<?> epce3991801_select2(Map<String, String> data) ;
	
	/**
	 * 권한그룹 삭제
	 * @param map
	 * @
	 */
	public void epce3991801_delete(Map<String, String> map) ;
	
	/**
	 * 권한그룹 등록
	 * @param map
	 * @
	 */
	public void epce3991801_insert(Map<String, String> map) ;
	
	/**
	 * 버튼일괄적용 목록 조회
	 * @return
	 * @
	 */
	public List<?> epce3991888_select(Map<String, String> data) ;
	
	/**
	 * 버튼권한 일괄제거
	 * @param map
	 * @
	 */
	public void epce3991888_delete(Map<String, String> map) ;
	
	/**
	 * 버튼권한 일괄부여
	 * @param map
	 * @
	 */
	public void epce3991888_insert(Map<String, String> map) ;
	
}

