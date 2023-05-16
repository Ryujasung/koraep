package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 회원가입 Mapper
 * @author Administrator
 *
 */

@Mapper("epce0098201Mapper")
public interface EPCE0098201Mapper {

	/***************************************************************************************************************************************************************************************
	* 			문의하기 공지항
	****************************************************************************************************************************************************************************************/

	/**
	 * 문의하기 공지사항 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce0098201_select(Map<String, String> map) ;
	
	/**
	 * 문의하기 공지사항 조회 총 카운터
	 * @param map
	 * @return
	 * @
	 */
	public int epce0098201_select_cnt(Map<String, String> map) ;

/***************************************************************************************************************************************************************************************
* 			문의하기 FAQ
****************************************************************************************************************************************************************************************/
	
	/**
	 * 문의하기 FAQ 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce00982882_select(Map<String, String> map) ;
	
	/**
	 * 문의하기 FAQ 조회 총 카운터
	 * @param map
	 * @return
	 * @
	 */
	public int epce00982882_select_cnt(Map<String, String> map) ;

	
}



