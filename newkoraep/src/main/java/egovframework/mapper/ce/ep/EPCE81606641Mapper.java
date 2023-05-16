package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 설문 문항 및 선택 옵션 관리 Mapper
 * @author kwon
 *
 */
@Mapper("epce81606641Mapper")
public interface EPCE81606641Mapper {
	
	/**
	 * 설문조사 설명 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce81606641_select(Map<String, String> map) ;

	/**
	 * 선택설문의 문항조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce81606641_select1(Map<String, String> map) ;
	
	/**
	 * 조사문항 저장
	 * @param map
	 * @
	 */
	public void epce81606641_update1(Map<String, String> map) ;
	
	/**
	 * 조사문항 삭제
	 * @param map
	 * @
	 */
	public void epce81606641_delete1(Map<String, String> map) ;
	
	
	
	
	/**
	 * 선택문항의 옵션조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce81606641_select2(Map<String, String> map) ;
	
	/**
	 * 선택문항의 옵션 저장
	 * @param map
	 * @
	 */
	public void epce81606641_update2(Map<String, String> map) ;
	
	/**
	 * 선택문항의 옵션 삭제
	 * @param map
	 * @
	 */
	public void epce81606641_delete2(Map<String, String> map) ;
	

	/**
	 * 설명 저장
	 * @param map
	 * @
	 */
	public void epce81606641_update3(Map<String, String> map) ;

}
