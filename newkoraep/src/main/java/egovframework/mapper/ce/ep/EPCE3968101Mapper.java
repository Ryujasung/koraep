package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 *  기타코드 Mapper
 * @author 양성수
 *
 */
@Mapper("epce3968101Mapper")
public interface EPCE3968101Mapper {
	
	
	/**
	 * 기타코드관리 그룹코드 조회
	 * @param map
	 * @return
	 * @
	 */
 public List<?>  epce3968101_select(Map<String, String> map) ;
	
	/**
	 * 기타코드관리  그룹코드 저장 및 수정 여부확인
	 * @param map
	 * @return
	 * @
	 */
 public int epce3968101_select2(Map<String, String>map) ;
	
	/**
	 * 기타코드관리 상세코드 조회
	 * @param map
	 * @return
	 * @
	 */
public List<?>  epce3968101_select3(Map<String, String> map) ;
	
/**
 * 기타코드관리 상세코드 저장 및 수정 여부 확인
 * @param map
 * @return
 * @
 */
public int  epce3968101_select4(Map<String, String> map) ;


 
 /**
  * 기타코드관리 그룹코드 저장
  * @param map
  * @
  */
 public void  epce3968101_insert(Map<String, String>map) ;
	
 /**
  * 기타코드관리 상세코드 저장
  * @param map
  * @
  */
 public void  epce3968101_insert2(Map<String, String>map) ;
	
 /**
  * 기타코드관리 그룹코드 수정
  * @param map
  * @
  */
 public void  epce3968101_update(Map<String, String>map) ;
	
 /**
  * 기타코드관리 상세코드 수정
  * @param map
  * @
  */
 public void  epce3968101_update2(Map<String, String>map) ;
	
 /**
  * 기타코드관리 상세코드 상대순번 수정
  * @param map
  * @
  */
 public void  epce3968101_update3(Map<String, String>map) ;
	
}
