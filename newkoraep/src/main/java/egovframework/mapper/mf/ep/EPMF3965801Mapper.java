package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 생산자제품코드관리 Mapper
 * @author 유병승
 *
 */
@Mapper("epmf3965801Mapper")
public interface EPMF3965801Mapper {

	/**
	 * 생산자제품코드관리관리 리스트 조회
	 * @param map
	 * @return
	 * @
	 */
	 public List<?>  epmf3965801_select(Map<String, String> map) ;
		
	
	 /**
	  * 생산자제품코드관리관리 조회시 입력값이 있을경우 수정 없을경우 저장
	  * @param map
	  * @return
	  * @
	  */
	 public int  epmf3965801_select2(Map<String, String> map) ;
	 
	 /**
	  * 생산자제품코드관리관리 저장
	  * @param map
	  * @return
	  * @
	  */
	 public void  epmf3965801_insert(Map<String, String> map) ;

	 /**
	  * 생산자제품코드관리관리 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void  epmf3965801_update(Map<String, String> map) ;

	 /**
	 * 빈용기명 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> epmf3965801_select5(Map<String, String> inputMap) ;
}
