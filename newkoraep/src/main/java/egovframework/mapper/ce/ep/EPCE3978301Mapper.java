package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 메뉴권한관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epce3978301Mapper")
public interface EPCE3978301Mapper {

	/**
	 * 사업자유형별 권한그룹 조회
	 * @return
	 * @
	 */
	public List<?> epce3978301_select(Map<String, String> data) ;
	
	/**
	 * 권한그룹 조회
	 * @return
	 * @
	 */
	public List<?> epce3978301_select2(Map<String, String> data) ;
	
	/**
	 * 메뉴 조회
	 * @return
	 * @
	 */
	public List<?> epce3978301_select3(Map<String, String> data) ;
	
	/**
	 * 권한저장
	 * @param map
	 * @
	 */
	public void epce3978301_update(HashMap<String, String> map) ;
	
	/**
	 * 권한그룹 메뉴 삭제
	 * @param map
	 * @
	 */
	public void epce3978301_delete(Map<String, String> map) ;
	
	/**
	 * 권한그룹 메뉴 등록
	 * @param map
	 * @
	 */
	public void epce3978301_insert(Map<String, String> map) ;
}
