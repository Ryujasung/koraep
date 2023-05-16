package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 입고확인취소요청조회 Mapper
 * @author 양성수
 *
 */
@Mapper("epce6622201Mapper")
public interface EPCE6622201Mapper {

	
	 /**
	  * 입고확인취소요청조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6622201_select2 (Map<String, String> map) ;
	 
	 /**
	  * 입고확인취소요청조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce6622201_select2_cnt (Map<String, String> map) ;

	 /**
	  * 입고확인취소요청조회 사유 팝업
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6622201_select3 (Map<String, String> map) ;

}
