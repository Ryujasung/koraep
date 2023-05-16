package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 출고대비초과회수현황 Mapper
 * @author 양성수
 *
 */
@Mapper("epce6198401Mapper")
public interface EPCE6198401Mapper {  
	
	 /**
	  * 출고대비초과회수현황 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6198401_select (Map<String, Object> map) ;
	 
	 /**
	  * 출고대비초과회수현황 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public int epce6198401_select_cnt (Map<String, Object> map) ;
	 
	 /**
	  * 차트 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6198401_select2 (Map<String, Object> map) ;
	 
	 
}
