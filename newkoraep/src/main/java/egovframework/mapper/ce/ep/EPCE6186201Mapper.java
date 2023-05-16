package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 주간누계현황 Mapper
 * @author 양성수
 *
 */
@Mapper("epce6186201Mapper")
public interface EPCE6186201Mapper {  
	
	 /**
	  * 주간누계 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6186201_select(Map<String, String> map) ;

}
