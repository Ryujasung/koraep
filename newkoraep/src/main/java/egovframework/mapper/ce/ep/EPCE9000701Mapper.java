package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 지역별무인회수기현황 Mapper
 * @author 양성수
 *
 */
@Mapper("epce9000701Mapper")
public interface EPCE9000701Mapper {

	 /**
	  * 지역별무인회수기현황 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000701_select (Map<String, Object> map) ;

	 /**
	  * 지역별_생산자별출고회수현황 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000701_select2 (Map<String, Object> map) ;
	 
	 
	 public List<Map<String, Object>> epce9000761_select();

}
