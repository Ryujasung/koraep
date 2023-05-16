package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 연간출고량조정 Mapper
 * @author Administrator
 *
 */

@Mapper("epce4718501Mapper")
public interface EPCE4718501Mapper {

	/**
	 * 연간출고량조정 조회
	 * @return
	 * @
	 */
	public List<?> epce4718501_select(Map<String, String> data) ;
	
}



