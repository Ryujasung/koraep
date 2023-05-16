package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 입고정정확인 Mapper
 * @author 양성수
 *
 */
@Mapper("epce4704201Mapper")
public interface EPCE4704201Mapper {
	
	 /**
	  * 입고정정확인 도매업자 구분 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce4704201_select () ;

	 /**
	  * 입고정정확인 생산자 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce4704201_select2 (Map<String, String> map) ;
	 
	 /**
	  * 입고정정확인 도매업자 업체명 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce4704201_select3 (Map<String, String> map) ;
	 
	 /**
	  * 입고정정확인 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce4704201_select4 (Map<String, Object> map) ;
	 
	 /**
	  * 입고정정확인 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce4704201_select4_cnt (Map<String, Object> map) ;
	 
	 /**
	  * 입고정정확인 상태체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce4704201_select5 (Map<String, String> map) ;
	 
	 /**
	  * 입고정정확인 상태조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce4704201_select7 () ;


	 /**
	  * 입고정정확인 상호확인상태로 변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epce4704201_update (Map<String, String> map) ;
	 
	 
}
