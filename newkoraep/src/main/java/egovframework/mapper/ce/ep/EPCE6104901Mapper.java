package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 상세출고현황 Mapper
 * @author 이내희
 *  
 */
@Mapper("epce6104901Mapper")
public interface EPCE6104901Mapper {  
	
	/**
	 * 상세출고현황 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epce6104901_select(Map<String, Object> data) ;
	
	/**
	 * 상세출고현황 리스트 카운트
	 * @return
	 * @
	 */
	public List<?> epce6104901_select_cnt(Map<String, Object> data) ;
	
	/**
	 * 상세출고현황 리스트 조회 (챠트)
	 * @return
	 * @
	 */
	public List<?> epce6104901_select2(Map<String, Object> data) ;
	
}
