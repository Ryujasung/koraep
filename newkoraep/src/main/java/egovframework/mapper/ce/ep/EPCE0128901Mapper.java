package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 회수용기기준금액관리 Mapper
 * @author 양성수
 *
 */
@Mapper("epce0128901Mapper")
public interface EPCE0128901Mapper {
	
	
	 /**
	  * 회수용기기준금액관리
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0128901_select (Map<String, String> map) ;
	 
	 /**
	  * 회수용기기준금액관리 카운트
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0128901_select_cnt (Map<String, String> map) ;
	 
}
