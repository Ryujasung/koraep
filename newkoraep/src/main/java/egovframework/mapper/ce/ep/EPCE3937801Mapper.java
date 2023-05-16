package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 권한그룹관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epce3937801Mapper")
public interface EPCE3937801Mapper {

	/**
	 * 권한그룹 조회
	 * @return
	 * @
	 */
	public List<?> epce3937801_select(Map<String, String> data) ;
	
	/**
	 * 권한그룹 상세조회
	 * @return
	 * @
	 */
	public HashMap<?, ?> epce3937842_select(HashMap<String, String> data) ;
	
	/**
	 * 권한그룹 중복체크
	 * @return
	 * @
	 */
	public int epce3937831_select(Map<String, String> data) ;
	
	/**
	 * 권한그룹 등록
	 * @param map
	 * @
	 */
	public void epce3937831_insert(HashMap<String, String> map) ;
	
	/**
	 * 권한그룹 수정
	 * @param map
	 * @
	 */
	public void epce3937842_update(HashMap<String, String> map) ;
}
