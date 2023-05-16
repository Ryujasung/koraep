package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * FAQ 상세조회 Mapper
 * @author pc
 *
 */
@Mapper("epce8169997Mapper")
public interface EPCE8169997Mapper {
	
	/**
	 * FAQ 상세조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce8169997_select1(Map<String, String> map) ;
	
	/**
	 * FAQ 이전글 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce8169997_select2(Map<String, String> map) ;
	
	/**
	 * FAQ 다음글 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce8169997_select3(Map<String, String> map) ;
	
	/**
	 * FAQ 첨부파일 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce8169997_select4(Map<String, String> map) ;
	
	/**
	 * 첨부파일 리스트 삭제
	 * @param map
	 * @return
	 * @
	 */
	public int epce8169997_delete1(Map<String, String> map) ;
	
	/**
	 * FAQ 삭제
	 * @param map
	 * @return
	 * @
	 */
	public int epce8169997_delete2(Map<String, String> map) ;

}
