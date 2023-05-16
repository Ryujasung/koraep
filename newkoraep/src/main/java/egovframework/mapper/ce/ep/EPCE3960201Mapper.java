/**
 * 
 */
package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 메뉴 관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epce3960201Mapper")
public interface EPCE3960201Mapper {

	/**
	 * 메뉴 조회
	 * @return
	 * @
	 */
	public List<?> epce3960201_select(Map<String, String> data) ;

	/**
	 * 메뉴체크
	 * @return
	 * @
	 */
	public HashMap<String, String> epce3960201_select2(Map<String, String> data) ;
	
	/**
	 * 상위메뉴코드 조회
	 * @return
	 * @
	 */
	public List<?> epce3960201_select3(Map<String, String> data) ;

	
	/**
	 * 메뉴그룹 조회 - 사용 안 함
	 * @return
	 * @
	 */
	public List<?> SELECT_MENU_GRP_LIST() ;
	
	/**
	 * 메뉴 삭제
	 * @param map
	 * @
	 */
	public void epce3960201_delete(HashMap<String, String> map) ;
	
	
	/**
	 * 메뉴 등록 및 수정
	 * @param map
	 * @
	 */
	public void epce3960201_update(HashMap<String, String> map) ;
	
	
}
