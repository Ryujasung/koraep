/**
 * 
 */
package egovframework.mapper.mf.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 직매장/공장관리 Mapper
 * @author 양성수
 *
 */
@Mapper("epmf0150201Mapper")
public interface EPMF0150201Mapper {
	
	
	 /**
	  * 직매장/공장관리 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf0150201_select (Map<String, String> map) ;
	 
	 /**
	  * 직매장/공장관리 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf0150201_select_cnt (Map<String, String> map) ;
	 
	 /**
	  * 직매장/공장관리 상태체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf0150201_select2 (Map<String, String> map) ;
	
	 /**
	  * 상태 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf0150201_select3() ;

	 /**
	  * 직매장/공장관리  활동복원 ,비활동처리
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf0150201_update (Map<String, String> map) ;
	 
 /***************************************************************************************************************************************************************************************
 * 		직매장 저장/변경
 ****************************************************************************************************************************************************************************************/
	 
	 /**
	  * 직매장변경시
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf0150231_select(Map<String, String> map) ;
	 
	 /**
	 * 직매장 등록
	 * @param map
	 * @
	 */
	public void epmf0150231_insert(HashMap<String, String> map) ;
	
	/**
	 * 사업자 등록
	 * @param map
	 * @
	 */
	public void epmf0150231_insert2(HashMap<String, String> map) ;
	
	/**
	 * 직매장 수정
	 * @param map
	 * @
	 */
	public void epmf0150242_update(HashMap<String, String> map) ;
	
	/**
	 * 사업자정보 수정
	 * @param map
	 * @
	 */
	public void epmf0150242_update2(HashMap<String, String> map) ;
	
	/**
	 * 사업자정보 비활성화
	 * @param map
	 * @
	 */
	public void epmf0150242_update3(HashMap<String, String> map) ;
	
	/**
	  * 직매장/공장관리 상세조회
	  * @param map
	  * @return
	  * @
	  */
	 public HashMap<?, ?> epmf0150231_select2 (Map<String, String> map) ;
	 
	 /**
	  * 지점번호 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf0150231_select3 (Map<String, String> map) ;
	 
	 /**
	  * 사업자번호 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf0150231_select4 (Map<String, String> map) ;
	 
	 
 /***************************************************************************************************************************************************************************************
 * 					지역 일괄 설정
 ****************************************************************************************************************************************************************************************/
		
	 /**
	  * 지역일괄설정 저장/수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf0150288_update (Map<String, String> map) ;
	 
	 
}
