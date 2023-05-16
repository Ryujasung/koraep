package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 배치관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epce3969301Mapper")
public interface EPCE3969301Mapper {

	/**
	 * 프로시저 목록 조회
	 * @return
	 * @
	 */
	public List<?> epce3969301_select() ;
	
	/**
	 * 배치 목록 조회
	 * @return
	 * @
	 */
	public List<?> epce3969301_select2() ;
	
	/**
	 * 배치관리 저장
	 * @param map
	 * @
	 */
	public void epce3969301_update(HashMap<String, String> map) ;
	
	/**
	 * 스케줄러 생성
	 * @param map
	 * @
	 */
	public void epce3969301_update2(HashMap<String, String> map) ;
	
	/**
	 * 스케줄러 변경
	 * @param map
	 * @
	 */
	public void epce3969301_update3(HashMap<String, String> map) ;
}

