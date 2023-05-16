package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 회수수수료 Mapper
 * @author 양성수
 *
 */
@Mapper("epce0182901Mapper")
public interface EPCE0182901Mapper {
	
	
	 /**
	  * 회수수수료관리
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0182901_select (Map<String, String> map) ;

	 /**
	  * 회수수수료관리  삭제여부 조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0182901_select2 (Map<String, String> map) ;

	 
	 /**
	  * 회수수수료관리 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce0182901_delete (Map<String, String> map) ;
	 
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//	회수수수료 등록
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
 
		
	 /**
	  * 회수수수료등록 저장 및 수정 시 중복 적용기간조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0182931_select (Map<String, String> map) ;

	 /**
	  * 회수수수료등록 등록순번
	  * @param map
	  * @return
	  * @
	  */
	 public String epce0182931_select2 (Map<String, String> map) ;

	 /**
	  * 회수수수료등록 적용기간 시작날짜 끝날짜 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0182931_select3 (Map<String, String> map) ;

	 /**
	  * 회수수수료등록
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce0182931_insert(Map<String, String> map) ;

	 /**
	  * 회수수수료이력 저장
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce0182931_insert2(Map<String, String> map) ;
	 
	//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	//	회수수수료 수정
	//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 

	 /**
	  * 회수수수료수정 초기 값
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0182942_select (Map<String, String> map) ;
	 
	 /**
	  * 회수수수료수정 
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce0182942_update(Map<String, String> map) ;

	 
	
	 

}
