package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 지역별출고회수현황 Mapper
 * @author 양성수
 *
 */
@Mapper("epce6190101Mapper")
public interface EPCE6190101Mapper {

	 /**
	  * 지역별출고회수현황 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6190101_select (Map<String, Object> map) ;

	 /**
	  * 지역별_생산자별출고회수현황 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6190101_select2 (Map<String, Object> map) ;

}
