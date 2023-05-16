package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 직접회수정보조회 Mapper
 * @author pc
 *
 */
@Mapper("epce6645201Mapper")
public interface EPCE6645201Mapper {
	
	/**
	  * 직접회수관리 조회	
	  * @param map
	  * @return
	  * @
	  */
	public List<?> epce6645201_select (Map<String, String> map) ;
	
	/**
	  * 직접회수관리 조회	
	  * @param map
	  * @return
	  * @
	  */
	public List<?> epce6645201_select_cnt (Map<String, String> map) ;


	/**
	  * 상세조회
	  * @param map
	  * @return
	  * @
	  */
	public List<?> epce6645264_select (Map<String, String> map) ;
	
	/**
	  * 상세조회 (그리드)
	  * @param map
	  * @return
	  * @
	  */
	public List<?> epce6645264_select2 (Map<String, String> map) ;
	
	/**
	  * 상태체크
	  * @param map
	  * @return
	  * @
	  */
	public int epce6645201_select3 (Map<String, String> map) ;
	
	/**
	  * 정보삭제
	  * @param map
	  * @return
	  * @
	  */
	public void epce6645201_delete (Map<String, String> map) ;
	
}
