package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 상세입고현황 Mapper
 * @author 양성수
 *
 */
@Mapper("epmf6139401Mapper")
public interface EPMF6139401Mapper {  
	
	 /**
	  * 상세입고현황 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf6139401_select (Map<String, String> map) ;
	 
	 /**
	  * 상세입고현황 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf6139401_select_cnt (Map<String, String> map) ;
	 
	 /**
	  * 차트 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf6139401_select2 (Map<String, String> map) ;
	 
	 /**
	  * 상태
	  * @return
	  * @
	  */
	 public List<?> epmf6139401_select3 () ;
	
}
