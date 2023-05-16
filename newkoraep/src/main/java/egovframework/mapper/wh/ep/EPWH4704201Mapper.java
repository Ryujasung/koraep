package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 입고정정확인 Mapper
 * @author 양성수
 *
 */
@Mapper("epwh4704201Mapper")
public interface EPWH4704201Mapper {
	
	 /**
	  * 입고정정확인 도매업자 구분 조회
	  * @return
	  * @
	  */
	 public List<?> epwh4704201_select () ;

	 /**
	  * 입고정정확인 생산자 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh4704201_select2 (Map<String, String> map) ;
	 
	 /**
	  * 입고정정확인 도매업자 업체명 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh4704201_select3 (Map<String, String> map) ;
	 
	 /**
	  * 입고정정확인 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh4704201_select4 (Map<String, Object> map) ;
	 
	 /**
	  * 입고정정확인 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh4704201_select4_cnt (Map<String, Object> map) ;
	 
	 /**
	  * 입고정정확인 상태체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epwh4704201_select5 (Map<String, String> map) ;
	 
	 /**
	  * 입고정정확인 상호확인상태로 변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh4704201_update (Map<String, String> map) ;
	 
	 /**
	  * 수기입고정정 내역조회 상세조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh4705664_select (Map<String, String> map) ;
	 /**
	  * 수기입고정정 내역조회 입고 그리드 부분
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh4705664_select2 (Map<String, String> map) ;
	 /**
	  * 수기입고정정 내역조회 수기입고정정  그리드 부분
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh4705664_select3 (Map<String, String> map) ;
	 
}
