package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 출고자료등록현황 Mapper
 * @author 이내희
 *
 */
@Mapper("epce6120901Mapper")
public interface EPCE6120901Mapper {  

	/**
	 * 출고자료등록현황 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epce6120901_select(Map<String, String> data) ;
	
}
