package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 오류코드 Mapper
 * @author 양성수
 *
 */
@Mapper("epce3965701Mapper")
public interface EPCE3965701Mapper {

	/**
	 * 오류코드관리 리스트 조회
	 * @param map
	 * @return
	 * @
	 */
	 public List<?>  epce3965701_select(Map<String, String> map) ;
		
	
	 /**
	  * 오류코드관리 조회시 입력값이 있을경우 수정 없을경우 저장
	  * @param map
	  * @return
	  * @
	  */
	 public int  epce3965701_select2(Map<String, String> map) ;
	 
	 /**
	  * 오류코드관리 저장
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce3965701_insert(Map<String, String> map) ;

	 /**
	  * 오류코드관리 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce3965701_update(Map<String, String> map) ;

	
}
