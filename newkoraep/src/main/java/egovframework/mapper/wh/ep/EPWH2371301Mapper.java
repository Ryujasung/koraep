package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 지급내역조회 Mapper
 * @author Administrator
 *
 */

@Mapper("epwh2371301Mapper")
public interface EPWH2371301Mapper {
	
	/**
	 * 지급내역조회
	 * @return
	 * @
	 */
	public List<?> epwh2371301_select(Map<String, String> data) ;
	
	/**
	 * 지급내역 상세조회
	 * @return
	 * @
	 */
	public List<?> epwh2371364_select(Map<String, String> data) ;
	
	/**
	 * 지급내역 상세조회 - 세부내역
	 * @return
	 * @
	 */
	public List<?> epwh2371364_select2(Map<String, String> data) ;
	
	/**
	 * 지급정보 상태변경
	 * @return
	 * @
	 */
	public int epwh2371331_update(Map<String, String> data) ;

	/**
	 * 연계전송
	 * @return
	 * @
	 */
	public int epwh2371331_update2(Map<String, String> data) ;
	
	/**
	 * 지급정보 상태변경
	 * @return
	 * @
	 */
	public int epwh2371331_update3(Map<String, String> data) ;
	
}



