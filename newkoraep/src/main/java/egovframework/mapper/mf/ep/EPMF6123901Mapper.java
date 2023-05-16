package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 생산자별 출고/회수 현황 Mapper
 * @author 이내희
 *
 */
@Mapper("epmf6123901Mapper")
public interface EPMF6123901Mapper {  
	
	/**
	 * 생산자별 출고/회수 현황 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epmf6123901_select(Map<String, String> data) ;

}
