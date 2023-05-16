package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 회수대비초과반환현황 Mapper
 * @author 양성수
 *
 */
@Mapper("epwh9001001Mapper")
public interface EPWH9001001Mapper {

	 /**
	  * 회수대비초과반환현황 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh9001001_select (Map<String, Object> map) ;

	 /**
	  * 차트 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh9001001_select2 (Map<String, Object> map) ;

	 /**
	  * 차트 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh9001001_select3 (Map<String, Object> map) ;

}
