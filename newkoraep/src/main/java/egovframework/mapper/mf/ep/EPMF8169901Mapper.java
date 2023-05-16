package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * FAQ Mapper
 * @author pc
 *
 */
@Mapper("epmf8169901Mapper")
public interface EPMF8169901Mapper {
	
	/**
	 * FAQ 총 게시글 수 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epmf8169901_select1(Map<String, String> map) ;
	
	/**
	 * FAQ 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epmf8169901_select2(Map<String, String> map) ;
	
	/**
	 * FAQ 첨부파일 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epmf8169901_select3(Map<String, String> map) ;

}
