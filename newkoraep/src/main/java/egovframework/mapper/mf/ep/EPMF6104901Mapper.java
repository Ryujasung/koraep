package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 상세출고현황 Mapper
 * @author 이내희
 *
 */
@Mapper("epmf6104901Mapper")
public interface EPMF6104901Mapper {  
	
	/**
	 * 상세출고현황 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epmf6104901_select(Map<String, String> data) ;
	
	/**
	 * 상세출고현황 리스트 카운트
	 * @return
	 * @
	 */
	public List<?> epmf6104901_select_cnt(Map<String, String> data) ;
	
	/**
	 * 상세출고현황 리스트 조회 (챠트)
	 * @return
	 * @
	 */
	public List<?> epmf6104901_select2(Map<String, String> data) ;
	
}
