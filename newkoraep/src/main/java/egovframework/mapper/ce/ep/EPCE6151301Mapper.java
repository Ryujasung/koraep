package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 상세직접회수현황 Mapper
 * @author 이내희
 *
 */
@Mapper("epce6151301Mapper")
public interface EPCE6151301Mapper {  
	
	/**
	 * 상세직접회수현황 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epce6151301_select(Map<String, Object> data) ;
	
	/**
	 * 상세직접회수현황 리스트 카운트
	 * @return
	 * @
	 */
	public List<?> epce6151301_select_cnt(Map<String, Object> data) ;
	
	/**
	 * 상세직접회수현황 리스트 조회 (챠트)
	 * @return
	 * @
	 */
	public List<?> epce6151301_select2(Map<String, Object> data) ;
	
}
