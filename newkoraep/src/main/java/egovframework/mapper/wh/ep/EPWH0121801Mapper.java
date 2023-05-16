package egovframework.mapper.wh.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 소매거래처 관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epwh0121801Mapper")
public interface EPWH0121801Mapper {
	
	/**
	 * 거래처구분 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epwh0121801_select() ;
		
	/**
	 * 소매거래처관리 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epwh0121801_select2(Map<String, String> map) ;
	
	/**
	 * 소매거래처관리 리스트 조회
	 * @return
	 * @
	 */
	public int epwh0121801_select2_cnt(Map<String, String> map) ;
	
	/**
	 * 소매거래처관리 사업자 및 지점 등록 여부
	 * @return
	 * @
	 */
	public HashMap<String, String> epwh0121831_select(Map<String, String> map) ;
	
	/**
	 * 소매거래처관리 데이터 체크
	 * @return
	 * @
	 */
	public List<?> epwh0121831_select2(Map<String, String> map) ;
	
	/**
	  * 소매거래처관리 데이터 체크 (엑셀저장용)
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh0121831_select3(Map<String, String> map) ;
	
	/**
	 * 소매거래처관리 사업자 등록
	 * @param map
	 * @
	 */
	public void epwh0121831_insert(Map<String, String> map) ;
	
	/**
	 * 소매거래처관리 지점 등록
	 * @param map
	 * @
	 */
	public void epwh0121831_insert2(Map<String, String> map) ;
	
	/**
	 * 소매거래처관리 거래처 등록
	 * @param map
	 * @
	 */
	public void epwh0121831_insert3(Map<String, String> map) ;
	
	/**
	  * 소매거래처관리 데이터 확인
	  * @param map
	  * @return
	  * @
	  */
	public int epwh0121831_select4(Map<String, String> map) ;
	
	/**
	 * 가맹점 거래처 등록/수정
	 * @param map
	 * @
	 */
	public void epwh0121831_update(Map<String, String> map) ;
	
	/**
	 * 소매거래처관리 거래상태 수정
	 * @param map
	 * @
	 */
	public void epwh0121801_update(Map<String, String> map) ;
	
	/**
	 * 사업자정보 변경
	 * @param map
	 * @
	 */
	public int epwh0121888_update(Map<String, String> map) ;
	
	/**
	 * 지점정보 변경
	 * @param map
	 * @
	 */
	public void epwh0121888_update2(Map<String, String> map) ;
	
	/**
	 * 거래처정보 변경
	 * @param map
	 * @
	 */
	public void epwh0121888_update3(Map<String, String> map) ;
}
