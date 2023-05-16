package egovframework.mapper.rt.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 지급내역조회 Mapper
 * @author 양성수
 *  
 */    
@Mapper("eprt9071301Mapper")
public interface EPRT9071301Mapper {
	  
	 
	 /**
	  * 지급내역조회 조회	
	  * @param map  
	  * @return
	  * @
	  */
	 public List<?> eprt9071301_select (Map<String, String> map) ;  //
	  
	 /**
	  * 지급내역 상세조회
	  * @return
	  * @
	  */
	 public List<?> eprt9071364_select(Map<String, String> data) ;
		
	 /**
	  * 지급내역 상세조회 - 세부내역
	  * @return
	  * @
	  */
	 public List<?> eprt9071364_select2(Map<String, String> data) ;
	 
}
