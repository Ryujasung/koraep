package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 로그인이력 조회 Mapper
 * @author 양성수
 *
 */
@Mapper("epce3920201Mapper")
public interface EPCE3920201Mapper {
	
	
	 /**
	  * 로그인이력 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce3920201_select (Map<String, String> map) ;

		
	 /**
	  * 로그인이력 조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce3920201_select_cnt (Map<String, String> map) ;




}
