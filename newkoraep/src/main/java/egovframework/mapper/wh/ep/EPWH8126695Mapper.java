package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 문의/답변상세조회 Mapper
 * @author pc
 *
 */
@Mapper("epwh8126695Mapper")
public interface EPWH8126695Mapper {
	
	/**
	 * 문의/답변 상세조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8126695_select1(Map<String, String> map) ;
	
	/**
	 * 문의/답변 답변글 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8126695_select2(Map<String, String> map) ;
	
	/**
	 * 문의/답변 삭제
	 * @param map
	 * @return
	 * @
	 */
	public int epwh8126695_delete(Map<String, String> map) ;

}
