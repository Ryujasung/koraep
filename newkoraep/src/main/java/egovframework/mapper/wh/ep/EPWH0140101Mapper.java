package egovframework.mapper.wh.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 회원 관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epwh0140101Mapper")
public interface EPWH0140101Mapper {

	/**
	 * 회원관리 조회
	 * @return
	 * @
	 */
	public List<?> epwh0140101_select(Map<String, String> data) ;
	
	/**
	 * 회원관리 조회
	 * @return
	 * @
	 */
	public int epwh0140101_select_cnt(Map<String, String> data) ;
	
	/**
	 * 회원상태 변경
	 * @param map
	 * @
	 */
	public void epwh0140101_update(Map<String, String> map) ;
	
	/**
	 * 사용자 정보변경(등록) 이력
	 * @param map
	 * @
	 */
	public void epwh0140101_insert(Map<String, String> map) ;
	
	/**
	 * 사업자 정보변경(등록) 이력
	 * @param map
	 * @
	 */
	public void epwh0140101_insert2(Map<String, String> map) ;
	
	/**
	 * 사용자구분코드 변경
	 * @param map
	 * @
	 */
	public void epwh0140101_update2(Map<String, String> map) ;
	
	/**
	 * 사업자정보 관리자변경
	 * @param map
	 * @
	 */
	public void epwh0140101_update3(Map<String, String> map) ;
	
	/**
	 * 비밀번호변경승인
	 * @param map
	 * @
	 */
	public int epwh0140101_update4(Map<String, String> map) ;
	
	/**
	 * 권한그룹 조회
	 * @return
	 * @
	 */
	public List<?> epwh0140188_select(Map<String, String> data) ;
	
	/**
	 * 메뉴 조회
	 * @return
	 * @
	 */
	public List<?> epwh0140188_select2(Map<String, String> data) ;
	
	/**
	 * 권한그룹 저장
	 * @param map
	 * @
	 */
	public void epwh0140188_update(Map<String, String> map) ;
	
	/**
	 * 사용자변경이력 조회
	 * @return
	 * @
	 */
	public List<?> epwh01401882_select(Map<String, String> data) ;
	
	/**
	 * 회원 상세조회
	 * @return
	 * @
	 */
	public HashMap<?, ?> epwh0140164_select(Map<String, String> data) ;
	
	/**
	 * 회원정보변경 저장
	 * @param map
	 * @
	 */
	public void epwh0140142_update(Map<String, String> map) ;
	
	/**
	 * 회원가입승인
	 * @param map
	 * @
	 */
	public void epwh0140164_update(Map<String, String> map) ;
	
	/**
	 * 회원탈퇴
	 * @param map
	 * @
	 */
	public void epwh0140164_update2(Map<String, String> map) ;
	
	/**
	 * 회원탈퇴시 변경이력 수정
	 * @param map
	 * @
	 */
	public void epwh0140164_update3(Map<String, String> map) ;
	
	/**
	 * 비밀번호 조회
	 * @return
	 * @
	 */
	public String epwh0140142_select(Map<String, String> map) ;

	public void epwh0140164_insert2(HashMap<String, String> data);
}



