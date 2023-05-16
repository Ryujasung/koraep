package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 공지사항 Mapper
 * @author pc
 *
 */
@Mapper("epwh8149001Mapper")
public interface EPWH8149001Mapper {
	
	/**
	 * 공지사항 총 게시글 수 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8149001(Map<String, String> map) ;
	
	/**
	 * 공지사항 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8149001_select1(Map<String, String> map) ;
	
	/**
	 * 공지사항 첨부파일 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8149001_select2(Map<String, String> map) ;

}
