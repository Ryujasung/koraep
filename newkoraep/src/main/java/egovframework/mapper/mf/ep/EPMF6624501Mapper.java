package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 교환관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epmf6624501Mapper")
public interface EPMF6624501Mapper {

	/**
	 * 교환관리 조회
	 * @return
	 * @
	 */
	public List<?> epmf6624501_select(Map<String, String> data) ;
	
	/**
	 * 교환관리 조회 카운트
	 * @return
	 * @
	 */
	public List<?> epmf6624501_select_cnt(Map<String, String> data) ;
	
	/**
	 * 교환상세조회
	 * @return
	 * @
	 */
	public List<?> epmf6624564_select(Map<String, String> data) ;
	
	/**
	 * 교환상세조회
	 * @return
	 * @
	 */
	public List<?> epmf6624564_select2(Map<String, String> data) ;
	
	/**
	 * 교환확인취소
	 * @param map
	 * @
	 */
	public int epmf6624564_update(Map<String, String> map) ;
	
	/**
	 * 교환관리 데이터 체크
	 * @return
	 * @
	 */
	public List<?> epmf6624531_select(Map<String, String> map) ;
	
	/**
	 * 생산자별 빈용기명 콤보박스 목록조회
	 * @return
	 * @
	 */
	public List<?> epmf6624531_select2(Map<String, String> map) ;
	
	/**
	 * 교환 삭제
	 * @param map
	 * @
	 */
	public void epmf6624501_delete(Map<String, String> map) ;
	
	/**
	 * 교환 등록 마스터 insert
	 * @param map
	 * @
	 */
	public void epmf6624531_insert(Map<String, String> map) ;
	
	/**
	 * 교환 등록 디테일 insert
	 * @param map
	 * @
	 */
	public void epmf6624531_insert2(Map<String, String> map) ;
	
	/**
	 * 교환 마스터 합계 업데이트
	 * @param map
	 * @
	 */
	public int epmf6624531_update(Map<String, String> map) ;
	
	/**
	 * 교환 변경 디테일 update
	 * @param map
	 * @
	 */
	public void epmf6624542_update(Map<String, String> map) ;
	
	/**
	 * 교환 변경 디테일 delete
	 * @param map
	 * @
	 */
	public void epmf6624542_delete(Map<String, String> map) ;
	
}



