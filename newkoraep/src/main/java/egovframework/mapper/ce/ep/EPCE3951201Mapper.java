package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


@Mapper("epce3951201Mapper")
public interface EPCE3951201Mapper {

	
	 /**
	  * 표준용기코드관리  조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?>  epce3951201_select(Map<String, String> map) ;
	
	 
	 /**
	  * 표준용기코드관리 조회시 입력값이 있을경우 수정 없을경우 저장
	  * @param map
	  * @return
	  * @
	  */
	 public int  epce3951201_select2(Map<String, String> map) ;

	 /**
	  * 표준용기코드관리 저장
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce3951201_insert(Map<String, String> map) ;

	 /**
	  * 표준용기코드관리 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce3951201_update(Map<String, String> map) ;

	 
	 
	
	
}
