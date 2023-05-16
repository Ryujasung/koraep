package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 회수보증금관리 Mapper
 * @author 양성수
 *
 */
@Mapper("epce0198201Mapper")
public interface EPCE0198201Mapper {
	
	
	 /**
	  * 회수보증금관리 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0198201_select (Map<String, String> map) ;

	 /**
	  * 회수보증금관리 삭제 가능 한지 조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0198201_select2 (Map<String, String> map) ;

	 
	 /**
	  * 회수보증금관리 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce0198201_delete (Map<String, String> map) ;
		
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//	회수보증금등록
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	 /**
	  * 회수보증금등록 저장 및 수정 시 중복 적용기간조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0198231_select (Map<String, String> map) ;

	 /**
	  * 회수보증금등록 등록순번
	  * @param map
	  * @return
	  * @
	  */
	 public String epce0198231_select2 (Map<String, String> map) ;

	 /**
	  * 회수보증금등록 적용기간 시작날짜 끝날짜 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0198231_select3 (Map<String, String> map) ;

	 
	 /**
	  * 회수보증금등록
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce0198231_insert(Map<String, String> map) ;

	 /**
	  * 회수보증금관리이력 저장
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce0198231_insert2(Map<String, String> map) ;
	 
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//		회수보증금수정
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
	 
	 	
	 /**
	  * 회수보증금수정 초기 값
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0198242_select (Map<String, String> map) ;
	 
	 
	 /**
	  * 회수보증금수정 
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce0198242_update(Map<String, String> map) ;

	 
	 
	 

}
