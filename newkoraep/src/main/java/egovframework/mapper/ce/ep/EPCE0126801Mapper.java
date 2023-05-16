/**
 * 
 */
package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 소매 직매장/공장관리 Mapper
 * @author 양성수
 *
 */
@Mapper("epce0126801Mapper")
public interface EPCE0126801Mapper {
	
	
	 /**
	  * 직매장/공장관리 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0126801_select (Map<String, String> map) ;
	 
	 /**
	  * 직매장/공장관리 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0126801_select_cnt (Map<String, String> map) ;
	 
	 /**
	  * 직매장/공장관리 상태체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0126801_select2 (Map<String, String> map) ;
	
	 /**
	  * 상태 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0126801_select3() ;

	 /**
	  * 직매장/공장관리  활동복원 ,비활동처리
	  * @param map
	  * @return
	  * @
	  */
	 public void epce0126801_update (Map<String, String> map) ;
	 
 /***************************************************************************************************************************************************************************************
 * 		직매장 저장/변경
 ****************************************************************************************************************************************************************************************/
	 
	 /**
	  *  총괄지점 검색
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0126831_select(Map<String, String> map) ;
	 
	 /**
	  * 직매장/공장관리 상세조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0126831_select2 (Map<String, String> map) ;
	 
	 /**
	  * 지점번호 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0126831_select3 (Map<String, String> map) ;
	 
	 /**
	 * 직매장 등록
	 * @param map
	 * @
	 */
	public void epce0126831_insert(HashMap<String, String> map) ;
	
	/**
	 * 직매장 수정
	 * @param map
	 * @
	 */
	public void epce0126842_update(HashMap<String, String> map) ;
	
	 
 /***************************************************************************************************************************************************************************************
 * 					지역 일괄 설정
 ****************************************************************************************************************************************************************************************/
		
	 /**
	  * 지역일괄설정 저장/수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epce0126888_update (Map<String, String> map) ;
	
 /***************************************************************************************************************************************************************************************
  * 					단체 설정
  ****************************************************************************************************************************************************************************************/
 		
 	 /**
 	  * 지역일괄설정 저장/수정
 	  * @param map
 	  * @return
 	  * @
 	  */
 	 public void epce01268882_update (Map<String, String> map) ;	 
 
	 
}
