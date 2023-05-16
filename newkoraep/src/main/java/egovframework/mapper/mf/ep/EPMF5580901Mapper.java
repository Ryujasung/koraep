package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 마이메뉴 관리
 * @author Administrator
 *
 */

@Mapper("epmf5580901Mapper")
public interface EPMF5580901Mapper {

	/**
	 * 사용자 권한 메뉴 모두 조회
	 * @param param
	 * @return
	 * @
	 */
	public List<?> epmf5580901_select1(Map<String, String> param) ;
	
	
	/**
	 * 사용자 마이메뉴 조회
	 * @param param
	 * @return
	 * @
	 */
	public List<?> epmf5580901_select2(Map<String, String> param) ;
	
	
	/**
	 * 사용자 마이메뉴 추가
	 * @param param
	 * @
	 */
	public void epmf5580901_insert(Map<String, String> param) ;
	
	
	/**
	 * 사용자 마이메뉴 삭제
	 * @param param
	 * @
	 */
	public void epmf5580901_delete(Map<String, String> param) ;
}



