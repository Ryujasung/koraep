package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 지역별출고회수현황 Mapper
 * @author 양성수
 *
 */
@Mapper("epce9000401Mapper")
public interface EPCE9000401Mapper {

	 /**
	  * 지역별출고회수현황 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000401_select (Map<String, Object> map) ;

	 /**
	  * 지역별_생산자별출고회수현황 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000401_select2 (Map<String, Object> map) ;

}
