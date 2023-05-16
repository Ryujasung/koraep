package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 출고자료등록현황 Mapper
 * @author 이내희
 *
 */
@Mapper("epmf6120901Mapper")
public interface EPMF6120901Mapper {  

	/**
	 * 출고자료등록현황 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epmf6120901_select(Map<String, String> data) ;
	
}
