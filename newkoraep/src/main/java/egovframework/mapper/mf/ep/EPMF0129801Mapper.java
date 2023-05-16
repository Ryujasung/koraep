package egovframework.mapper.mf.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 메뉴 관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epmf0129801Mapper")
public interface EPMF0129801Mapper {

	/**
	 * 부서관리 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epmf0129801_select(Map<String, String> data) ;
	
	/**
	 * 부서관리 리스트 조회
	 * @return
	 * @
	 */
	public int epmf0129801_select_cnt(Map<String, String> data) ;
	
	/**
	 * 부서관리 상세조회
	 * @return
	 * @
	 */
	public HashMap<?, ?> epmf0129842_select(HashMap<String, String> data) ;
	
	/**
	 * 업체명 조회
	 * @return
	 * @
	 */
	public List<?> epmf0129831_select2(Map<String, String> data) ;

	/**
	 * 상위부서코드 조회
	 * @return
	 * @
	 */
	public List<?> epmf0129831_select3(Map<String, String> data) ;

	/**
	 * 부서관리 등록
	 * @param map
	 * @
	 */
	public void epmf0129831_insert(HashMap<String, String> map) ;
	
	/**
	 * 부서관리 변경
	 * @param map
	 * @
	 */
	public void epmf0129801_update1(HashMap<String, String> map) ;
	
	/**
	 * 부서관리 수정
	 * @param map
	 * @
	 */
	public void epmf0129842_update(HashMap<String, String> map) ;
	
	/**
	 * 활동상태 수정
	 * @param map
	 * @
	 */
	public void epmf0129801_update(Map<String, String> map) ;
	
}
