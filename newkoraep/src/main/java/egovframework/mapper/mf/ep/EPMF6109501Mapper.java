package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 교환현황 Mapper
 * @author 이내희
 *
 */
@Mapper("epmf6109501Mapper")
public interface EPMF6109501Mapper {  
	
	/**
	 * 교환현황 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epmf6109501_select(Map<String, Object> data) ;
	
	/**
	 * 교환현황 리스트 카운트
	 * @return
	 * @
	 */
	public List<?> epmf6109501_select_cnt(Map<String, Object> data) ;
	
	/**
	 * 교환현황 리스트 조회 (챠트)
	 * @return
	 * @
	 */
	public List<?> epmf6109501_select2(Map<String, Object> data) ;
	
}
