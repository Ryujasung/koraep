package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * API전송상세이력조회 Mapper
 * @author 유병승
 *
 */
@Mapper("epce3961341Mapper")
public interface EPCE3961341Mapper {
	
	 /**
	  * API전송상세이력 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce3961341_select3 (Map<String, String> map) ;

	 /**
	  * API전송상세이력 조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce3961341_select3_cnt (Map<String, String> map) ;


	 /**
	  * API전송상세이력 PRAM 조회
	  * @param map
	  * @return
	  * @
	  */
	 public HashMap epce3961341_select4 (Map<String, String> map) ;

}
