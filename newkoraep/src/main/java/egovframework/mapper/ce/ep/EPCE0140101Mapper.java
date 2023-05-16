/**
 * 
 */
package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 회원 관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epce0140101Mapper")
public interface EPCE0140101Mapper {

	/**
	 * 회원관리 조회
	 * @return
	 * @
	 */
	public List<?> epce0140101_select(Map<String, String> data) ;
	
	/**
	 * 회원관리 조회
	 * @return
	 * @
	 */
	public int epce0140101_select_cnt(Map<String, String> data) ;
	
	/**
	 * 회원상태 변경
	 * @param map
	 * @
	 */
	public void epce0140101_update(Map<String, String> map) ;
	
	/**
	 * 사용자 정보변경(등록) 이력
	 * @param map
	 * @
	 */
	public void epce0140101_insert(Map<String, String> map) ;
	
	/**
	 * 사업자 정보변경(등록) 이력
	 * @param map
	 * @
	 */
	public void epce0140101_insert2(Map<String, String> map) ;
	
	/**
	 * 사용자구분코드 변경
	 * @param map
	 * @
	 */
	public void epce0140101_update2(Map<String, String> map) ;
	
	/**
	 * 사업자정보 관리자변경
	 * @param map
	 * @
	 */
	public void epce0140101_update3(Map<String, String> map) ;
	
	/**
	 * 비밀번호변경승인
	 * @param map
	 * @
	 */
	public void epce0140101_update4(Map<String, String> map) ;
	
	/**
	 * 비밀번호오류초기화
	 * @param map
	 * @
	 */
	public void epce0140101_update5(Map<String, String> map) ;
	
	/**
	 * 권한그룹 조회
	 * @return
	 * @
	 */
	public List<?> epce0140188_select(Map<String, String> data) ;
	
	/**
	 * 메뉴 조회
	 * @return
	 * @
	 */
	public List<?> epce0140188_select2(Map<String, String> data) ;
	
	/**
	 * 권한그룹 저장
	 * @param map
	 * @
	 */
	public void epce0140188_update(Map<String, String> map) ;
	
	/**
	 * 사용자변경이력 조회
	 * @return
	 * @
	 */
	public List<?> epce01401882_select(Map<String, String> data) ;
	
	/**
	 * 회원 상세조회
	 * @return
	 * @
	 */
	public HashMap<?, ?> epce0140164_select(Map<String, String> data) ;
	
	/**
	 * 회원권한 삭제
	 * @param map
	 * @
	 */
	public void epce0140142_delete(Map<String, String> map) ;
	
	/**
	 * 회원정보 삭제
	 * @param map
	 * @
	 */
	public void epce0140142_delete2(Map<String, String> map) ;
	
	/**
	 * 회원정보변경 저장
	 * @param map
	 * @
	 */
	public void epce0140142_update(Map<String, String> map) ;
	
	/**
	 * 회원가입승인
	 * @param map
	 * @
	 */
	public void epce0140164_update(Map<String, String> map) ;
	
	/**
	 * 회원탈퇴
	 * @param map
	 * @
	 */
	public void epce0140164_update2(Map<String, String> map) ;
	
	/**
	 * 회원탈퇴시 변경이력 수정
	 * @param map
	 * @
	 */
	public void epce0140164_update3(Map<String, String> map) ;
	
	/**
	 * 비밀번호 조회
	 * @return
	 * @
	 */
	public String epce0140142_select(Map<String, String> map) ;

	public void epce0140164_insert2(HashMap<String, String> data);



}



