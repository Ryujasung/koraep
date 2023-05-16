package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 회수정보조회 Mapper
 * @author 양성수
 *  
 */    
@Mapper("epwh2924601Mapper")
public interface EPWH2924601Mapper {
	  
	 
	 /**
	  * 회수정보조회 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2924601_select (Map<String, Object> map) ;
	   
	 /**
	  * 회수정보조회 조회 카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2924601_select_cnt (Map<String, Object> map) ;
	 
	 /**
	  * 회수정보조회 회수량
	  * @param map
	  * @return
	  * @
	  */
	 public List<?>  epwh2924601_select2 (Map<String, Object> map) ;
	 
	 /**
	  * 회수정보조회 상태값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epwh2924601_select3 (Map<String, String> map) ;
	 
	 /**
	  * 회수정보조회 회수등록구분
	  * @param map
	  * @return
	  * @
	  */
	 public String epwh2924601_select4 (Map<String, String> map) ;
	 
	 
	 /**
	  * 회수정보조회 회수등록일괄확인
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2924601_update (Map<String, String> map) ;
	 
}
