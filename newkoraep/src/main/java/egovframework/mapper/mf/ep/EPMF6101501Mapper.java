package egovframework.mapper.mf.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 출고현황 Mapper
 * @author 이내희
 *
 */
@Mapper("epmf6101501Mapper")
public interface EPMF6101501Mapper {  
	
	/**
	 * 출고현황 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epmf6101501_select(Map<String, String> data) ;
	
	/**
	 * 출고현황 리스트 카운트
	 * @return
	 * @
	 */
	public List<?> epmf6101501_select_cnt(Map<String, String> data) ;
	
	/**
	 * 출고현황 리스트 조회 (챠트)
	 * @return
	 * @
	 */
	public List<?> epmf6101501_select2(Map<String, String> data) ;
	
}
