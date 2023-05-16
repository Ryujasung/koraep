package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * API전송이력조회 Mapper
 * @author 김도연
 *
 */
@Mapper("epce3973901Mapper")
public interface EPCE3973901Mapper {

	
	 /**
	  * API전송이력 메뉴명 셋팅
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce3973901_select (Map<String, String> map) ;
	 
	 
	 /**
	  * API전송이력 버튼명 셋팅
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce3973901_select2 (Map<String, String> map) ;
	 

	 /**
	  * API전송이력 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce3973901_select3 (Map<String, String> map) ;

	 /**
	  * API전송이력 조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce3973901_select3_cnt (Map<String, String> map) ;

	 /**
	  * API전송이력 PRAM 조회
	  * @param map
	  * @return
	  * @
	  */
	 public HashMap epce3973901_select4 (Map<String, String> map) ;


	public List<?> epce3973901_excel(HashMap<String, String> data);

}
