package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 수납확인내역조회 Mapper
 * @author Administrator
 *
 */

@Mapper("epce2308801Mapper")
public interface EPCE2308801Mapper {
	
	/**
	 * 수납확인내역 조회
	 * @return
	 * @
	 */
	public List<?> epce2308801_select(Map<String, Object> data) ;
	
	/**
	 * 수납확인 상세조회 (고지서)
	 * @return
	 * @
	 */
	public List<?> epce2308888_select(Map<String, String> data) ;
	
	/**
	 * 수납확인 상세조회 (수납내역)
	 * @return
	 * @
	 */
	public List<?> epce2308888_select2(Map<String, String> data) ;
	
}



