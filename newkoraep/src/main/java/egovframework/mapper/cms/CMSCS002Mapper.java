package egovframework.mapper.cms;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 예금주조회 Mapper
 * @author Administrator
 *
 */

@Mapper("cmscs002Mapper")
public interface CMSCS002Mapper{

	/**
	 * 예금주조회결과상세
	 * @return
	 * @
	 */
	public List<?> cmscs002_select(Map<String, String> data) ;
	
	/**
	 * 예금주조회결과상세 count
	 * @return
	 * @
	 */
	public List<?> cmscs002_select_cnt(Map<String, String> data) ;
		
	/**
	 * 예금주조회결과 실행결과 업데이트 - 지급
	 * @return
	 * @
	 */
	public int cmscs002_update21(Map<String, Object> data) ;
	
	public int cmscs002_update22(Map<String, Object> data) ;
	
	/**
	 * 예금주조회결과 실행결과 업데이트 - 정산
	 * @return
	 * @
	 */
	public int cmscs002_update31(Map<String, Object> data) ;
	
	public int cmscs002_update32(Map<String, Object> data) ;
}
