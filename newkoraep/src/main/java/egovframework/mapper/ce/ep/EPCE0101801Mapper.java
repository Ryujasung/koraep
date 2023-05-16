package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 생산자보증금잔액관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epce0101801Mapper")
public interface EPCE0101801Mapper {

	/**
	 * 잔액 조회
	 * @return
	 * @
	 */
	public List<?> epce0101801_select(Map<String, String> data) ;
	
	/**
	 * 조정금액관리 조회
	 * @return
	 * @
	 */
	public List<?> epce0101888_select(Map<String, String> data) ;
	
	/**
	 * 조정금액관리 저장
	 * @param map
	 * @
	 */
	public void epce0101888_insert(HashMap<String, String> map) ;
	
	/**
	 * 조정금액관리 수정
	 * @param map
	 * @
	 */
	public void epce0101888_update(HashMap<String, String> map) ;
	
}



