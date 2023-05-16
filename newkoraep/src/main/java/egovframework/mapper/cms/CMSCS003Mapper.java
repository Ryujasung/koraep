package egovframework.mapper.cms;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 계좌거래내역조회 Mapper
 * @author Administrator
 *
 */

@Mapper("cmscs003Mapper")
public interface CMSCS003Mapper{

	/**
	 * 계좌목록
	 * @return
	 * @
	 */
	public List<?> cmscs003_select0(Map<String, String> data) ;
	
	/**
	 * 계좌거래내역조회	- 수납
	 * @return
	 * @
	 */
	public List<?> cmscs003_select(Map<String, String> data) ;
	
	/**
	 * 계좌거래내역조회 - 정산
	 * @return
	 * @
	 */
	public List<?> cmscs003_select2(Map<String, String> data) ;

	/**
	 * 계좌잔액조회
	 * @return
	 * @
	 */
	public List<?> cmscs003_select3(Map<String, String> data) ;
}
