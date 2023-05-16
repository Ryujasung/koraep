package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 반환내역등록 Mapper
 * @author 양성수
 *
 */
@Mapper("epwh2910142Mapper")
public interface EPWH2910142Mapper {
	

	 /**
	  * 반환내역서변경  그리드 초기값
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2910142_select2 (Map<String, String> map) ;
	
	 /**
	  * 반환내역서변경  변경시 중복값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epwh2910142_select3 (Map<String, String> map) ;
	 
	 /**
	  * 반환내역서변경  변경시 반환상태 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epwh2910142_select4 (Map<String, String> map) ;
	 
	 
	 /**
	  * 반환내역서변경 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2910142_insert (Map<String, String> map) ;

	 /**
	  * 반환내역서변경 반환문서 sum 수정
	  * @param map
	  * @return
	  * @
	  */
	 public int epwh2910142_update (Map<String, String> map) ;

	 /**
	  * 반환내역서변경 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2910142_delete(Map<String, String> map) ;


	 
	 
}
