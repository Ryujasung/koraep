package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 실행이력조회 Mapper
 * @author 양성수
 *
 */
@Mapper("epce3961201Mapper")
public interface EPCE3961201Mapper {

	
	 /**
	  * 실행이력 메뉴명 셋팅
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce3961201_select (Map<String, String> map) ;
	 
	 
	 /**
	  * 실행이력 버튼명 셋팅
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce3961201_select2 (Map<String, String> map) ;
	 

	 /**
	  * 실행이력 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce3961201_select3 (Map<String, String> map) ;

	 /**
	  * 실행이력 조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce3961201_select3_cnt (Map<String, String> map) ;

	 /**
	  * 실행이력 PRAM 조회
	  * @param map
	  * @return
	  * @
	  */
	 public String epce3961201_select4 (Map<String, String> map) ;


	public List<?> epce3961201_excel(HashMap<String, String> data);

}
