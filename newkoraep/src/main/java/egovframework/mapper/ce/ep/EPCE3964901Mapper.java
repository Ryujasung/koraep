package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


@Mapper("epce3964901Mapper")
public interface EPCE3964901Mapper {

	
	 /**
	  * 회수용기관리 초기값 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?>  epce3964901_select(Map<String, String> map) ;
	
	 
	 /**
	  * 회수용기코드관리 조회시 입력값이 있을경우 수정 없을경우 저장
	  * @param map
	  * @return
	  * @
	  */
	 public int  epce3964901_select2(Map<String, String> map) ;

	 /**
	  * 회수용기관리 저장
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce3964901_insert(Map<String, String> map) ;

	 /**
	  * 회수용기관리 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce3964901_update(Map<String, String> map) ;

	 
	 
	
	
}
