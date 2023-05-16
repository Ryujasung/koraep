package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 오류이력조회 Mapper
 * @author 김도연
 *
 */
@Mapper("epce3961301Mapper")
public interface EPCE3961301Mapper {

	
	 /**
	  * 오류이력 메뉴명 셋팅
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce3961301_select (Map<String, String> map) ;
	 
	 
	 /**
	  * 오류이력 버튼명 셋팅
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce3961301_select2 (Map<String, String> map) ;
	 

	 /**
	  * 오류이력 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce3961301_select3 (Map<String, String> map) ;

	 /**
	  * 오류이력 조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce3961301_select3_cnt (Map<String, String> map) ;


	 /**
	  * 오류이력 PRAM 조회
	  * @param map
	  * @return
	  * @
	  */
	 public HashMap epce3961301_select4 (Map<String, String> map) ;

}
