package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 입고정정등록 Mapper
 * @author 양성수
 *
 */
@Mapper("epmf4738731Mapper")
public interface EPMF4738731Mapper {
	
	 /**
	  * 입고정정등록 등록 공급 부분
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf4738731_select (Map<String, String> map) ;  
	 
	 /**
	  * 입고정정등록 등록 그리드쪽 
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf4738731_select2 (Map<String, String> map) ;  
	 
	 
	 /**
	  * 입고정정등록 중복 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf4738731_select4 (Map<String, String> map) ;	 
	 
	 /**
	  * 입고정정등록 수량 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf4738731_select5 (Map<String, String> map) ;	 

	 
	 /**
	  * 입고정정등록 적용기간 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf4738731_select6 (Map<String, String> map) ;	 

	
	 /**
	  * 입고정정등록 
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf4738731_insert (Map<String, String> map) ;
	 
	 /**
	  * 입고정정등록  입고정보마스터에 입고정정문서 update
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf4738731_update (Map<String, String> map) ;
	    
/***************************************************************************************************************************************************************************************
* 	 입고정정 일괄등록
****************************************************************************************************************************************************************************************/
	
	 /**
	  * 엑셀 업로드 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf47387312_select (Map<String, String> map) ;  
	 
	 
	 
	    
/***************************************************************************************************************************************************************************************
* 	 입고정정수정
****************************************************************************************************************************************************************************************/
	
	 /**
	  * 입고정정수정 입고정정등록 그리드쪽 
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf4738742_select (Map<String, String> map) ;  //122
	 
	 /**
	  * 입고정정 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf4738742_delete (Map<String, String> map) ;
	 
		
/***************************************************************************************************************************************************************************************
* 	 입고내역선택 
****************************************************************************************************************************************************************************************/
	 
	 /**
	  * 입고내역선택  조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf47387642_select (Map<String, Object> map) ;
	 
	 /**
	  * 입고내역선택  조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf47387642_select_cnt (Map<String, Object> map) ;
	 
	 
}
