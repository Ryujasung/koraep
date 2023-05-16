package egovframework.mapper.rt.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 회원 관리 Mapper
 * @author Administrator
 *
 */

@Mapper("eprt0140101Mapper")
public interface EPRT0140101Mapper {

	/**
	 * 회원 상세조회
	 * @return
	 * @
	 */
	public HashMap<?, ?> eprt0140164_select(Map<String, String> data) ;
	
	/**
	 * 회원정보변경 저장
	 * @param map
	 * @
	 */
	public void eprt0140142_update(Map<String, String> map) ;

	/**
	 * 회원탈퇴
	 * @param map
	 * @
	 */
	public void eprt0140164_update2(Map<String, String> map) ;
	
	/**
	 * 회원탈퇴시 변경이력 수정
	 * @param map
	 * @
	 */
	public void eprt0140164_update3(Map<String, String> map) ;
	
	/**
	 * 비밀번호 조회
	 * @return
	 * @
	 */
	public String eprt0140142_select(Map<String, String> map) ;
	
	/**
	 * 사용자 정보변경(등록) 이력
	 * @param map
	 * @
	 */
	public void eprt0140101_insert(Map<String, String> map) ;
}



