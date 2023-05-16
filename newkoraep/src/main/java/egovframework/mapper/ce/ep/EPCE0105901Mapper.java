package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 빈용기기준금액관리 Mapper
 * @author 양성수
 *
 */
@Mapper("epce0105901Mapper")
public interface EPCE0105901Mapper {
	
	
	 /**
	  * 빈용기기준금액관리
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0105901_select (Map<String, String> map) ;

	 /**
	  * 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0105901_select_cnt (Map<String, String> map) ;
	 

	 
	 
	 
}
