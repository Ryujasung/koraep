package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 출고정보조회 Mapper
 * @author pc
 *
 */
@Mapper("epce6658201Mapper")
public interface EPCE6658201Mapper {
	
	/**
	  * 출고상세조회 빈용기재사용 생산자 정보 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce66582641_select (Map<String, String> map) ;
	
	 /**
	  * 출고 상세조회 그리드쪽 
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce66582641_select2 (Map<String, String> map) ;

	/**
	  * 출고관리 조회	
	  * @param map
	  * @return
	  * @
	  */
	public List<?> epce6658201_select2 (Map<String, String> map) ;
	
	
	/**
	  * 출고관리 삭제시  변경시 출고상태 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce6658201_select3 (Map<String, String> map) ;
	
	 /**
	  * 출고관리 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6658201_select4 (Map<String, String> map) ;
	 
	/**
	 * 출고정보 삭제
	 * @param map
	 * @
	 */
	public void epce6658201_delete(Map<String, String> map) ;

}
