package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 공지사항 Mapper
 * @author pc
 *
 */
@Mapper("epce8149001Mapper")
public interface EPCE8149001Mapper {
	
	/**
	 * 공지사항 총 게시글 수 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce8149001(Map<String, String> map) ;
	
	/**
	 * 공지사항 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce8149001_select1(Map<String, String> map) ;
	
	/**
	 * 공지사항 첨부파일 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce8149001_select2(Map<String, String> map) ;
	
	
/***************************************************************************************************************************************************************************************
* 			문의하기
****************************************************************************************************************************************************************************************/

	/**
	 * 문의하기 공지사항 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce8149088_select(Map<String, String> map) ;
	
	/**
	 * 문의하기 공지사항 조회 총 카운터
	 * @param map
	 * @return
	 * @
	 */
	public int epce8149088_select_cnt(Map<String, String> map) ;

}
