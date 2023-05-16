package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 수기입고정정 Mapper
 * @author 양성수
 *
 */
@Mapper("epce4705601Mapper")
public interface EPCE4705601Mapper {
	
	 /**
	  * 수기입고정정 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce4705601_select4 (Map<String, Object> map) ;
	 
	 /**
	  * 수기입고정정 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce4705601_select4_cnt (Map<String, Object> map) ;
	 
	 /**
	  * 수기입고정정 상태체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce4705601_select5 (Map<String, String> map) ;
	 
	 /**
	  * 수기입고정정 확인 상태체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce4705601_select6 (Map<String, String> map) ;
	 
	 /**
	  * 진행중인 정산기간 존재 여부 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce4705601_select7 (Map<String, String> map) ;
	 
	 
	 /**
	  * 수기입고정정  정정확인,정정반려,확인취소 상태 변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epce4705601_update(Map<String, String> map) ;
	 
	 
		//---------------------------------------------------------------------------------------------------------------------
		//	수기입고정정 내역조회
		//---------------------------------------------------------------------------------------------------------------------
			

		 /**
		  * 수기입고정정 내역조회 상세조회
		  * @param map
		  * @return
		  * @
		  */
		 public List<?> epce4705664_select (Map<String, String> map) ;
		 /**
		  * 수기입고정정 내역조회 입고 그리드 부분
		  * @param map
		  * @return
		  * @
		  */
		 public List<?> epce4705664_select2 (Map<String, String> map) ;
		 /**
		  * 수기입고정정 내역조회 수기입고정정  그리드 부분
		  * @param map
		  * @return
		  * @
		  */
		 public List<?> epce4705664_select3 (Map<String, String> map) ;

		 /**
		  * 수기입고정정 내역조회 삭제
		  * @param map
		  * @return
		  * @
		  */
		 public void epce4705664_delete (Map<String, String> map) ;
		 
		 /**
		  * 입고관리마스터  수기입고정정문서번호  삭제
		  * @param map
		  * @return
		  * @
		  */
		 public void epce4705664_update (Map<String, String> map) ;
		 
	 
		 /**
		  * 입고정정등록 등록 공급 부분
		  * @param map
		  * @return
		  * @
		  */
		 public List<?> epce4705631_select (Map<String, String> map) ;  
		 
		 /**
		  * 입고정정등록 등록 그리드쪽 
		  * @param map
		  * @return
		  * @
		  */
		 public List<?> epce4705631_select2 (Map<String, String> map) ;  
		 
		 
		 /**
		  * 입고정정등록 중복 체크
		  * @param map
		  * @return
		  * @
		  */
		 public int epce4705631_select4 (Map<String, String> map) ;	 
		 
		 /**
		  * 입고정정등록 수량 체크
		  * @param map
		  * @return
		  * @
		  */
		 public int epce4705631_select5 (Map<String, String> map) ;	 

		 
		 /**
		  * 입고정정등록 적용기간 체크
		  * @param map
		  * @return
		  * @
		  */
		 public int epce4705631_select6 (Map<String, String> map) ;	 

		
		 /**
		  * 입고정정등록 
		  * @param map
		  * @return
		  * @
		  */
		 public void epce4705631_insert (Map<String, String> map) ;
		 
		 /**
		  * 입고정정등록  입고정보마스터에 입고정정문서 update
		  * @param map
		  * @return
		  * @
		  */
		 public void epce4705631_update (Map<String, String> map) ;
		    
	/***************************************************************************************************************************************************************************************
	* 	 입고정정 일괄등록
	****************************************************************************************************************************************************************************************/
		
		 /**
		  * 엑셀 업로드 조회
		  * @param map
		  * @return
		  * @
		  */
		 public List<?> epce47056312_select (Map<String, String> map) ;  
		 
		 
		 
		    
	/***************************************************************************************************************************************************************************************
	* 	 입고정정수정
	****************************************************************************************************************************************************************************************/
		
		 /**
		  * 입고정정수정 입고정정등록 그리드쪽 
		  * @param map
		  * @return
		  * @
		  */
		 public List<?> epce47056422_select (Map<String, String> map) ;
		 
		 /**
		  * 입고정정수정 입고정정등록 그리드쪽 
		  * @param map
		  * @return
		  * @
		  */
		 public List<?> epce4705642_select(Map<String, String> map) ;
		 
		 /**
		  * 입고정정 삭제
		  * @param map
		  * @return
		  * @
		  */
		 public void epce4705642_delete(Map<String, String> map) ;
		 
			
	/***************************************************************************************************************************************************************************************
	* 	 입고내역선택 
	****************************************************************************************************************************************************************************************/
		 
		 /**
		  * 입고내역선택  조회	
		  * @param map
		  * @return
		  * @
		  */
		 public List<?> epce47056642_select (Map<String, Object> map) ;
		 
		 /**
		  * 입고내역선택  조회	카운트
		  * @param map
		  * @return
		  * @
		  */
		 public int epce47056642_select_cnt (Map<String, Object> map) ;
		 
		 
	 
}
