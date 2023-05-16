package egovframework.mapper.rt.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

   
/**
 * 반환업무설정 Mapper
 * @author 양성수
 *  
 */    
@Mapper("eprt9017301Mapper")
public interface EPRT9017301Mapper {
	  
	 
	 /**
	  * 반환업무설정 생산자 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> eprt9017301_select (Map<String, String> map) ;  //
	 
	 /**
	  * 반환업무설정
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> eprt9017301_select2 (Map<String, String> map) ;  //
	 
	 
	 /**
	  * 반환업무설정 생산자직접반환 상태변경
	  * @param map
	  * @return
	  * @
	  */
	 public void eprt9017301_update (Map<String, String> map) ;  //
	 
	 
	 
	 /**
	  * 반환업무설정  반환등록구분 수납방식 상태변경
	  * @param map
	  * @return
	  * @
	  */
	 public void eprt9017301_update2 (Map<String, String> map) ;  //
	       
  /***********************************************************************************************************************************************
  *	 거래처추가
  ************************************************************************************************************************************************/
		   
	 /**
	  * 거래처추가 중복확인
	  * @param map
	  * @return
	  * @
	  */
	 public int eprt9017331_select (Map<String, String> map) ;  //
	 
	 /**
	  * 거래처추가 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void eprt9017331_insert (Map<String, String> map) ;  //
}
