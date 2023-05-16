package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 정산기간관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epce4791401Mapper")
public interface EPCE4791401Mapper{

	/**
	 * 정산기간관리 조회
	 * @return
	 * @
	 */
	public List<?> epce4791401_select(Map<String, String> data);
	
	/**
	 * 생산자 조회
	 * @return
	 * @
	 */
	public List<?> epce4791431_select();
	
	/**
	 * 생산자 조회2
	 * @return
	 * @
	 */
	public List<?> epce4791431_select2(Map<String, String> data);
	
	/**
	 *정산기간 상세조회
	 * @return
	 * @
	 */
	public List<?> epce4791464_select(Map<String, String> data);
	
	/**
	 * 등록
	 * @param map
	 * @
	 */
	public void epce4791431_insert(HashMap<String, String> map) ;
	
	/**
	 * 대상등록
	 * @param map
	 * @
	 */
	public void epce4791431_insert2(Map<String, String> map) ;
	
	/**
	 * 대상삭제
	 * @param map
	 * @
	 */
	public void epce4791442_delete(Map<String, String> map) ;
	
	/**
	 * 삭제
	 * @param map
	 * @
	 */
	public void epce4791442_delete2(Map<String, String> map) ;
	
	/**
	 * 수정
	 * @param map
	 * @
	 */
	public void epce4791442_update(HashMap<String, String> map) ;
	
	/**
	 * 상태변경
	 * @param map
	 * @
	 */
	public void epce4791464_update(HashMap<String, String> map) ;
	
}



