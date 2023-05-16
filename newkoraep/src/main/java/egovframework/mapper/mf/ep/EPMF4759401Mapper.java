package egovframework.mapper.mf.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 출고정정 Mapper
 * @author Administrator
 *
 */

@Mapper("epmf4759401Mapper")
public interface EPMF4759401Mapper {

	/**
	 * 출고정정 조회
	 * @return
	 * @
	 */
	public List<?> epmf4759401_select(Map<String, String> data) ;
	
	/**
	 * 출고정정 카운트
	 * @return
	 * @
	 */
	public List<?> epmf4759401_select_cnt(Map<String, String> data) ;
	

	/**
	  * 출고정정 등록시 검색 등록한 용기명 있는지 조회(중복체크)
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf4759431_select(Map<String, String> map) ;
	 
	 /**
	  * 정산기간 진행 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf4759431_select2(Map<String, String> map) ;
	 
	 /**
	  * 출고정정 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf4759431_insert(Map<String, String> map) ;
	 
	 /**
	  * 출고정정 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf4759442_update(Map<String, String> map) ;
	 
	 /**
	  * 출고정정 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf4759401_delete(Map<String, String> map) ;
	 
	 /**
	  * 출고정정 상태변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf4759401_update(Map<String, String> map) ;
	 
	 /**
	 * 출고정정 수정조회
	 * @return
	 * @
	 */
	 public HashMap<?, ?> epmf4759442_select(Map<String, String> data) ;
	 
}



