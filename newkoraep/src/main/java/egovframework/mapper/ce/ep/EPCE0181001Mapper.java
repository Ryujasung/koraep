/**
 * 
 */
package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 도매업자 지점관리 Mapper
 * @author 양성수
 *
 */
@Mapper("epce0181001Mapper")
public interface EPCE0181001Mapper {
	
	
	 /**
	  * 도매업자 지점관리 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0181001_select (Map<String, String> map) ;
	 
	 /**
	  * 도매업자 지점관리 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0181001_select_cnt (Map<String, String> map) ;
	 
	 /**
	  * 도매업자 지점관리 상태체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0181001_select2 (Map<String, String> map) ;
	
	 /**
	  * 상태 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0181001_select3() ;

	 /**
	  * 도매업자 지점관리  활동복원 ,비활동처리
	  * @param map
	  * @return
	  * @
	  */
	 public void epce0181001_update (Map<String, String> map) ;
	 
 /***************************************************************************************************************************************************************************************
 * 		지점 저장/변경
 ****************************************************************************************************************************************************************************************/
	 
	 /**
	  *  총괄지점 검색
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0181031_select(Map<String, String> map) ;
	 
	 /**
	  *   상세조회
	  * @param map
	  * @return
	  * @
	  */
	 public HashMap<?, ?> epce0181031_select2 (Map<String, String> map) ;
	 
	 /**
	  * 지점번호 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0181031_select3 (Map<String, String> map) ;
	 
	 /**
	 * 지점 등록
	 * @param map
	 * @
	 */
	public void epce0181031_insert(HashMap<String, String> map) ;
	
	/**
	 * 지점 수정
	 * @param map
	 * @
	 */
	public void epce0181042_update(HashMap<String, String> map) ;
	
	 
 /***************************************************************************************************************************************************************************************
 * 					지역 일괄 설정
 ****************************************************************************************************************************************************************************************/
		
	 /**
	  * 지역일괄설정 저장/수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epce0181088_update (Map<String, String> map) ;
	
 /***************************************************************************************************************************************************************************************
  * 					단체 설정
  ****************************************************************************************************************************************************************************************/
 		
 	 /**
 	  * 지역일괄설정 저장/수정
 	  * @param map
 	  * @return
 	  * @
 	  */
 	 public void epce01810882_update (Map<String, String> map) ;	 
 	 
 	 /**
 	  * ERP설정 저장/수정
 	  * @param map
 	  * @return
 	  * @
 	  */
 	 public void epce01810884_update (Map<String, String> map) ;	 
 
	 
}
