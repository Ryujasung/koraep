/**
 * 
 */
package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 버튼 관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epce3959301Mapper")
public interface EPCE3959301Mapper {

	/**
	 * 메뉴 조회
	 * @return
	 * @
	 */
	public List<?> epce3959301_select(Map<String, String> data) ;
	
	/**
	 * 버튼 조회
	 * @return
	 * @
	 */
	public List<?> epce3959301_select2(Map<String, String> data) ;
	
	/**
	 * 버튼 등록 및 수정
	 * @param map
	 * @
	 */
	public void epce3959301_update(HashMap<String, String> map) ;
	
	/**
	 * 버튼 삭제
	 * @param map
	 * @
	 */
	public void epce3959301_update2(HashMap<String, String> map) ;
}
