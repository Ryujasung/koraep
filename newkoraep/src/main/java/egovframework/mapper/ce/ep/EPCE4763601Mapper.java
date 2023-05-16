package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 직접회수정정 Mapper
 * @author Administrator
 *
 */

@Mapper("epce4763601Mapper")
public interface EPCE4763601Mapper {

	/**
	 * 직접회수정정 조회
	 * @return
	 * @
	 */
	public List<?> epce4763601_select(Map<String, String> data) ;
	
	/**
	 * 직접회수정정 조회
	 * @return
	 * @
	 */
	public List<?> epce4763601_select_cnt(Map<String, String> data) ;
	
	/**
	  * 정산기간 진행 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce4763631_select(Map<String, String> map) ;
	 
	 /**
	  * 직접회수정정 저장시 중복값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce4763631_select2(Map<String, String> map) ;
	 
	 /**
	  * 직접회수정정 저장
	  * @param map
	  * @return
	  * @
	  */
	 public int epce4763631_insert(Map<String, String> map) ;
	 
	 /**
	 * 직접회수정정 수정조회
	 * @return
	 * @
	 */
	 public HashMap<?, ?> epce4763642_select(Map<String, String> data) ;
	 
	 /**
	  * 직접회수정정 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epce4763642_update(Map<String, String> map) ;
	 
	 /**
	  * 직접회수정정 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce4763601_delete(Map<String, String> map) ;
	 
	 /**
	  * 직접회수정정 상태변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epce4763601_update(Map<String, String> map) ;
	 
}



