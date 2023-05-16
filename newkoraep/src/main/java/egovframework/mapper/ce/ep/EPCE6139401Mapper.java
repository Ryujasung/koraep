package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 상세입고현황 Mapper      
 * @author 양성수   
 *
 */
@Mapper("epce6139401Mapper")
public interface EPCE6139401Mapper {     
	
	 /**
	  * 상세입고현황 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6139401_select (Map<String, Object> map) ;
	 
	 /**
	  * 상세입고현황 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6139401_select_cnt (Map<String, Object> map) ;
	 
	 /**
	  * 차트 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6139401_select2 (Map<String, Object> map) ;
	 
	 /**
	  * 상태
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6139401_select3 () ;

	public void epce6139401_update();
	
}
