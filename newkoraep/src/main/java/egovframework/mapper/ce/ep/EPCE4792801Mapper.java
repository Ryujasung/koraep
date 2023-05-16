package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 도매업자정산발급 Mapper
 * @author Administrator
 *
 */

@Mapper("epce4792801Mapper")
public interface EPCE4792801Mapper{

	/**
	 * 정산기간 조회
	 * @return
	 * @
	 */
	public HashMap<?, ?> epce4792801_select();
	
	/**
	 * 도매업자정산발급 조회
	 * @return
	 * @
	 */
	public List<?> epce4792801_select2(Map<String, String> data);
	 
	/**
	 * 정산서발급
	 * @return
	 * @
	 */
	public void epce4792801_insert(Map<String, String> data);
	
	/**
	 * 정산서발급 상세
	 * @return
	 * @
	 */
	public void epce4792801_insert2(Map<String, String> data);
	
	/**
	 * 입고정정 상태변경
	 * @return
	 * @
	 */
	public void epce4792801_update(Map<String, String> data);
	
	/**
	 * 도매업자정산내역 조회
	 * @return
	 * @
	 */
	public List<?> epce4792864_select(Map<String, String> data);
	
}



