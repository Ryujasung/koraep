package egovframework.mapper.rt.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 반환정보관리 Mapper
 * @author 양성수
 *  
 */    
@Mapper("eprt9025801Mapper")
public interface EPRT9025801Mapper {
	  
	 
	 /**
	  * 반환정보관리 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> eprt9025801_select (Map<String, String> map) ;  //
	 
	 /**
	  * 반환정보관리 조회 카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> eprt9025801_select_cnt (Map<String, String> map) ;  //
	   
	 /**
	  * 반환정보관리 회수량
	  * @param map
	  * @return
	  * @
	  */
	 public List<?>  eprt9025801_select2 (Map<String, String> map) ;//
	 
	 
	 /**
	  * 반환정보관리 상태값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int eprt9025801_select3 (Map<String, String> map) ;
	 
	 /**
	  * 반환정보관리 회수등록구분      
	  * @param map
	  * @return
	  * @
	  */
	 public int eprt9025801_select4 (Map<String, String> map) ; //
	 
	 
	 /**
	  * 반환정보관리 확인처리 및 상태 변경
	  * @param map
	  * @return
	  * @
	  */
	 public void eprt9025801_update (Map<String, String> map) ; 

  /***********************************************************************************************************************************************
  *	반환정보상세조회
  ************************************************************************************************************************************************/
	
	 /**
	  * 반환정보상세조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?>  eprt9025864_select (Map<String, String> map) ; //
	 
  /***********************************************************************************************************************************************
  *	반환정보 등록
  ************************************************************************************************************************************************/
	 /** 
	  * 반환정보저장 중복체크   
	  * @param map
	  * @return
	  * @     
	  */
	 public int eprt9025831_select (Map<String, String> map);   //
	 
	 /** 
	  * 반환정보저장 도매업자조회 
	  * @param map
	  * @return
	  * @     
	  */
	 public List<?>  eprt9025831_select2 (Map<String, String> map);   //

	 /**
	  * 반환정보저장 마스터 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void eprt9025831_insert (Map<String, String> map) ; //
	 
	 /**
	  * 반환정보저장 상세 등록 
	  * @param map
	  * @return
	  * @
	  */
	 public void eprt9025831_insert2 (Map<String, String> map) ; //
	    
	 /**
	  * 반환정보저장 마스터 update    
	  * @param map   
	  * @return   
	  * @
	  */
	 public void eprt9025831_update (Map<String, String> map) ; //
	 
  /***********************************************************************************************************************************************
  *	반환정보 수정
  ************************************************************************************************************************************************/
	 
	 /**
	  * 반환정보수정 그리드 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> eprt9025842_select (Map<String, String> map); //
	 
 
	 /**
	  * 반환정보수정 info 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void eprt9025842_delete (Map<String, String> map); //
	 
	 /**
	  * 반환정보수정 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void eprt9025842_delete2 (Map<String, String> map); //
	 
}
