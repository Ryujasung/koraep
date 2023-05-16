package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 입고현황 Mapper
 * @author 양성수
 *
 */
@Mapper("epwh6110401Mapper")
public interface EPWH6110401Mapper {  
	
	 /**
	  * 입고현황 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh6110401_select (Map<String, String> map) ;
	 
	 /**
	  * 입고현황 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh6110401_select_cnt (Map<String, String> map) ;
	 
	 /**
	  * 차트 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh6110401_select2 (Map<String, String> map) ;
	 
	 
}
