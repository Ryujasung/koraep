package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 생산자별 출고/회수 현황 Mapper
 * @author 이내희
 *
 */  
@Mapper("epce6123901Mapper")
public interface EPCE6123901Mapper {  
	
	/**
	 * 생산자별 출고/회수 현황 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epce6123901_select(Map<String, String> data) ;

}
