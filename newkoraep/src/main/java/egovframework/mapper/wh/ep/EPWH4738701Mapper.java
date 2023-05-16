package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 입고정정 Mapper
 * @author 양성수
 *
 */
@Mapper("epwh4738701Mapper")
public interface EPWH4738701Mapper {
	
	 /**
	  * 입고정정 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh4738701_select4 (Map<String, Object> map) ;
	 
	 /**
	  * 입고정정 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public int epwh4738701_select4_cnt (Map<String, Object> map) ;
	 
	 /**
	  * 입고정정 상태체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epwh4738701_select5 (Map<String, String> map) ;
	 
	 
	 /**
	  * 입고정정  정정확인,정정반려,확인취소 상태 변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh4738701_update(Map<String, String> map) ;
	 
	 
		//---------------------------------------------------------------------------------------------------------------------
		//	입고정정 내역조회
		//---------------------------------------------------------------------------------------------------------------------
			

		 /**
		  * 입고정정 내역조회 상세조회
		  * @param map
		  * @return
		  * @
		  */
		 public List<?> epwh4738764_select (Map<String, String> map) ;
		 /**
		  * 입고정정 내역조회 입고 그리드 부분
		  * @param map
		  * @return
		  * @
		  */
		 public List<?> epwh4738764_select2 (Map<String, String> map) ;
		 /**
		  * 입고정정 내역조회 입고정정  그리드 부분
		  * @param map
		  * @return
		  * @
		  */
		 public List<?> epwh4738764_select3 (Map<String, String> map) ;

		 /**
		  * 입고정정 내역조회 삭제
		  * @param map
		  * @return
		  * @
		  */
		 public void epwh4738764_delete (Map<String, String> map) ;
		 
		 /**
		  * 입고관리마스터  입고정정문서번호  삭제
		  * @param map
		  * @return
		  * @
		  */
		 public void epwh4738764_update  (Map<String, String> map) ;
		 
	 
	 
	 
}
