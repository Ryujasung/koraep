package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 고지서취소요청내역조회 Mapper
 * @author 이근표
 *
 */
@Mapper("epce2371302Mapper")
public interface EPCE2371302Mapper {

	
	 /**
	  * 입고확인취소요청조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce2371302_select2 (Map<String, String> map) ;
	 
	 /**
	  * 입고확인취소요청조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce2371302_select2_cnt (Map<String, String> map) ;

	 /**
	  * 입고확인취소요청조회 사유 팝업
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce2371302_select3 (Map<String, String> map) ;

}
