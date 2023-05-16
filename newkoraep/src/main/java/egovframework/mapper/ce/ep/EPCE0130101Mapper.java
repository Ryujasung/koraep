package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 지급관리시스템입고정보 Mapper
 * @author 유병승
 *
 */
@Mapper("epce0130101Mapper")
public interface EPCE0130101Mapper {  
	
	 /**
	  * 지급관리시스템입고정보 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0130101_select (Map<String, String> map) ;
	 
	 /**
	  * 지급관리시스템입고정보 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0130101_select_cnt (Map<String, String> map) ;
	 
	 
}
