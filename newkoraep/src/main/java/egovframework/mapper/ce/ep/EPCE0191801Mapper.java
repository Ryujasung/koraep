package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 기준취급수수료 Mapper
 * @author 양성수
 *
 */
@Mapper("epce0191801Mapper")
public interface EPCE0191801Mapper {
	
	
	 /**
	  * 기준취급수수료관리
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0191801_select (Map<String, String> map) ;

	 /**
	  * 기준취급수수료관리  삭제여부 조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0191801_select2 (Map<String, String> map) ;

	 
	 /**
	  * 기준취급수수료관리 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce0191801_delete (Map<String, String> map) ;
	 
		
	 /**
	  * 기준취급수수료등록 저장 및 수정 시 중복 적용기간조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0191831_select (Map<String, String> map) ;

	 /**
	  * 기준취급수수료등록 등록순번
	  * @param map
	  * @return
	  * @
	  */
	 public String epce0191831_select2 (Map<String, String> map) ;

	 /**
	  * 기준취급수수료등록 적용기간 시작날짜 끝날짜 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0191831_select3 (Map<String, String> map) ;

	 /**
	  * 기준취급수수료등록
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce0191831_insert(Map<String, String> map) ;

	 /**
	  * 기준취급수수료이력 저장
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce0191831_insert2(Map<String, String> map) ;

	 /**
	  * 기준취급수수료수정 
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce0191842_update(Map<String, String> map) ;

	 
	 
	 

}
