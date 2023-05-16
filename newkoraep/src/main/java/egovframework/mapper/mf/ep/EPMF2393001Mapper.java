package egovframework.mapper.mf.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 고지서조회 Mapper
 * @author Administrator
 *
 */

@Mapper("epmf2393001Mapper")
public interface EPMF2393001Mapper {
	
	/**
	 * 고지서 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epmf2393001_select(Map<String, Object> data) ;
	
	/**
	 * 생산자 상세조회
	 * @return
	 * @
	 */
	public HashMap<?, ?> epmf2393064_select(Map<String, String> data) ;
	
	/**
	 * 보증금 상세 그리드 조회
	 * @return
	 * @
	 */
	public List<?> epmf2393064_select2(Map<String, String> data) ;
	
	/**
	 * 취급수수료 상세 그리드 조회
	 * @return
	 * @
	 */
	public List<?> epmf2393064_select3(Map<String, String> data) ;
	
	/**
	 * 직접회수 상세 그리드 조회
	 * @return
	 * @
	 */
	public List<?> epmf2393064_select4(Map<String, String> data) ;
	
	/**
	 * 직접회수 상세 그리드 조회
	 * @return
	 * @
	 */
	public List<?> epmf2393064_select5(Map<String, String> data) ;
	
	/**
	 * 고지서 상태 조회
	 * @return
	 * @
	 */
	public Map<?, ?> epmf2393064_select6(Map<String, String> data) ;
	
	/**
	 * 취급수수료고지서 추가발급정보 초기화
	 * @return
	 * @
	 */
	public void epmf2393064_update(Map<String, String> data) ;
	
	/**
	 * 직접회수정보 상태 초기화
	 * @return
	 * @
	 */
	public void epmf2393064_update2(Map<String, String> data) ;
	
	/**
	 * 출고정보 상태 초기화
	 * @return
	 * @
	 */
	public void epmf2393064_update3(Map<String, String> data) ;
	
	/**
	 * 입고정보 상태 초기화
	 * @return
	 * @
	 */
	public int epmf2393064_update4(Map<String, String> data) ;
	
	/**
	 * 반환정보 상태 초기화
	 * @return
	 * @
	 */
	public int epmf2393064_update5(Map<String, String> data) ;
	
	/**
	 * 잔액내역 삭제
	 * @return
	 * @
	 */
	public int epmf2393064_delete(Map<String, String> data) ;
	
	/**
	 * 고지서 삭제
	 * @return
	 * @
	 */
	public int epmf2393064_delete2(Map<String, String> data) ;
	
	/**
	 * 취소요청 상태로 변경
	 * @return
	 * @
	 */
	public int epmf2393088_update(Map<String, String> data) ;
	
	/**
	 * 사유저장
	 * @return
	 * @
	 */
	public void epmf2393088_insert(Map<String, String> data) ;
	
}



