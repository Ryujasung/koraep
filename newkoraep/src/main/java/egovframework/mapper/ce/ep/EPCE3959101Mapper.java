package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 사업자권한관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epce3959101Mapper")
public interface EPCE3959101Mapper {

	/**
	 * 권한그룹 조회
	 * @return
	 * @
	 */
	public List<?> epce3959101_select() ;
	
	/**
	 * 권한목록 조회
	 * @return
	 * @
	 */
	public List<?> epce3959101_select2(Map<String, String> data) ;
	
	/**
	 * 지역 조회
	 * @return
	 * @
	 */
	public List<?> epce3959131_select(HashMap<String, String> data) ;
	
	/**
	 * 소속단체 조회
	 * @return
	 * @
	 */
	public List<?> epce39591312_select(HashMap<String, String> data) ;

	/**
	 * 지점 조회
	 * @return
	 * @
	 */
	public List<?> epce39591313_select(Map<String, String> data) ;
	
	/**
	 * 권한 삭제
	 * @param map
	 * @
	 */
	public void epce3959131_delete(Map<String, String> map) ;
	
	/**
	 * 권한 저장
	 * @param map
	 * @
	 */
	public void epce3959131_insert(Map<String, String> map) ;
}
