package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 문의/답변 Mapper
 * @author pc
 *
 */
@Mapper("epwh8126601Mapper")
public interface EPWH8126601Mapper {
	
	/**
	 * 문의/답변 총 게시글 수 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8126601(Map<String, String> map) ;

	/**
	 * 문의/답변 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8126601_select(Map<String, String> map) ;

}
