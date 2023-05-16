package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 직접회수현황 Mapper
 * @author 이내희
 *
 */
@Mapper("epmf6150601Mapper")
public interface EPMF6150601Mapper {  
	
	/**
	 * 직접회수현황 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epmf6150601_select(Map<String, String> data) ;
	
	/**
	 * 직접회수현황 리스트 카운트
	 * @return
	 * @
	 */
	public List<?> epmf6150601_select_cnt(Map<String, String> data) ;
	
	/**
	 * 직접회수현황 리스트 조회 (챠트)
	 * @return
	 * @
	 */
	public List<?> epmf6150601_select2(Map<String, String> data) ;
	
}
