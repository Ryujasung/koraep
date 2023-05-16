package egovframework.mapper.ce.ep;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 지급내역조회 Mapper
 * @author Administrator
 *
 */

@Mapper("epce2371301Mapper")
public interface EPCE2371301Mapper {
	
	/**
	 * 지급내역조회
	 * @return
	 * @
	 */
	public List<?> epce2371301_select(Map<String, String> data) ;
	
	/**
	 * 지급내역 상세조회
	 * @return
	 * @
	 */
	public List<?> epce2371364_select(Map<String, String> data) ;
	
	/**
	 * 지급내역 상세조회 - 세부내역
	 * @return
	 * @
	 */
	public List<?> epce2371364_select2(Map<String, String> data) ;
	
	/**
	 * 지급정보 상태변경
	 * @return
	 * @
	 */
	public int epce2371331_update(Map<String, String> data) ;

	/**
	 * 연계전송
	 * @return
	 * @
	 */
	public int epce2371331_update2(Map<String, String> data) ;
	
	/**
	 * 지급정보 상태변경
	 * @return
	 * @
	 */
	public int epce2371331_update3(Map<String, String> data) ;
	
	/**
	 * 지급확인 상태변경
	 * @return
	 * @
	 */
	public int epce2371331_update4(Map<String, String> data) ;
}



