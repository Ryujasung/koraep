package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 기준보증금관리 Mapper
 * @author 양성수
 *
 */
@Mapper("epce0122701Mapper")
public interface EPCE0122701Mapper {
	
	
	 /**
	  * 기준보증금관리 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0122701_select (Map<String, String> map) ;

	 /**
	  * 기준보증금관리 삭제 가능 한지 조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0122701_select2 (Map<String, String> map) ;

	 
	 /**
	  * 기준보증금관리 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce0122701_delete (Map<String, String> map) ;
	 
		
	 /**
	  * 기준보증금등록 저장 및 수정 시 중복 적용기간조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0122731_select (Map<String, String> map) ;

	 /**
	  * 기준보증금등록 등록순번
	  * @param map
	  * @return
	  * @
	  */
	 public String epce0122731_select2 (Map<String, String> map) ;

	 /**
	  * 기준보증금등록 적용기간 시작날짜 끝날짜 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0122731_select3 (Map<String, String> map) ;

	 
	 /**
	  * 기준보증금등록
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce0122731_insert(Map<String, String> map) ;

	 /**
	  * 기준보증금관리이력 저장
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce0122731_insert2(Map<String, String> map) ;

	 /**
	  * 기준보증금수정 
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce0122742_update(Map<String, String> map) ;

	 
	 
	 

}
