package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("epce3944888Mapper")
public interface EPCE3944888Mapper {

	/**
	 * 언어구분관리 리스트
	 * @param map
	 * @return
	 * @
	 */
 public List<?>  epce3944888_select() ;
	
 /**
  * 언어구분관리 저장시 중복체크
  * @param map
  * @return
  * @
  */

    public int epce3944888_select2(Map<String, String>map) ;
	
	/**
	 *  다국어관리 페이지 에서 호출시 표준여부 기준으로 검색 
	 * @param map
	 * @return
	 * @
	 */
    public List<?>  epce3944888_select3(Map<String, String> map) ;
	
/**
 * 언어구분관리 저장
 * @param map
 * @return
 * @
 */
 public void epce3944888_insert(Map<String, String> map) ;
 
 
 /**
  * 언어구분관리 표준여부변경
  * @param map
  * @
  */
 public void epce3944888_update(Map<String, String> map) ;

 /**
  * 언어구분관리 수정
  * @param map
  * @
  */
 public void epce3944888_update2(Map<String, String> map) ;

/**
 *  언어구분관리 표시순서 변경
 * @param map
 * @
 */
public void epce3944888_update3(Map<String, String> map) ;
}
