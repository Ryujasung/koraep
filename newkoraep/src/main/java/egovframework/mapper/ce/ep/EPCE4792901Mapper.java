package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 교환정산 Mapper
 * @author Administrator
 *
 */

@Mapper("epce4792901Mapper")
public interface EPCE4792901Mapper{

	/**
	 * 교환정산 조회
	 * @return
	 * @
	 */
	public List<?> epce4792901_select(Map<String, String> data);
	
	/**
	 * 교환정산 내역조회
	 * @return
	 * @
	 */
	public List<?> epce4792964_select(HashMap<String, String> data);
	
	/**
	 * 교환정산 상세조회
	 * @return
	 * @
	 */
	public List<?> epce4792964_select2(HashMap<String, String> data);
	
	/**
	 * 교환정산 상세조회
	 * @return
	 * @
	 */
	public List<?> epce4792964_select3(HashMap<String, String> data);
	
	/**
	 * 교환정산등록 조회
	 * @return
	 * @
	 */
	public List<?> epce4792931_select(Map<String, String> data);
	
	/**
	 * 교환정산등록
	 * @return
	 * @
	 */
	public void epce4792931_insert(Map<String, String> data);
	
	/**
	 * 교환요청정보 수정
	 * @return
	 * @
	 */
	public void epce4792931_update(Map<String, String> data);
	
	/**
	 * 교환확인정보 수정
	 * @return
	 * @
	 */
	public void epce4792931_update2(Map<String, String> data);

	/**
	  * 교환정산 상태변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epce4792901_update(Map<String, String> map) ;
	 
	 /**
	  * 교환정산 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public int epce4792901_delete(Map<String, String> map) ;
	
	 /**
	  * 교환요청정보 리셋
	  * @param map
	  * @return
	  * @
	  */
	 public void epce4792901_update2(Map<String, String> map) ;
	 
	 /**
	  * 교환확인정보 리셋
	  * @param map
	  * @return
	  * @
	  */
	 public void epce4792901_update3(Map<String, String> map) ;
	 
	/**
	 * 교환정산서등록 상세정보
	 * @return
	 * @
	 */
	public HashMap<?, ?> epce47929312_select(Map<String, String> data);
	 
	/**
	 * 교환정산 조회
	 * @return
	 * @
	 */
	public List<?> epce47929312_select2(Map<String, Object> data);
	
	/**
	 * 지급/수납 금액
	 * @return
	 * @
	 */
	public HashMap<?, ?> epce47929312_select3(HashMap<String, String> data);
	
	/**
	 * 정산서발급 (보증금)
	 * @return
	 * @
	 */
	public void epce47929312_insert(HashMap<String, String> data);
	
	/**
	 * 정산서발급 상세 (보증금)
	 * @return
	 * @
	 */
	public void epce47929312_insert2(Map<String, Object> data);

	/**
	 * 교환 상태 변경
	 * @return
	 * @
	 */
	public void epce47929312_update(Map<String, Object> data);
	
	/**
	 * 생산자보증금잔액 인서트
	 * @return
	 * @
	 */
	public void epce47929312_insert3(HashMap<String, String> data);
	
	/**
	 *  교환정산 상세목록
	 * @return
	 * @
	 */
	public List<?> epce47929643_select(Map<String, String> data);
	
	/**
	 * 정산서 상태 체크
	 * @return
	 * @
	 */
	public int epce47929643_select2(Map<String, String> data);
	
	/**
	 * 정산서 관련문서 상태 변경
	 * @return
	 * @
	 */
	public void epce47929643_update(Map<String, String> data);

	/**
	 * 정산서 삭제
	 * @return
	 * @
	 */
	public void epce47929643_delete(Map<String, String> data);
	
	/**
	 * 교환정산서등록 가능여부 조회
	 * @return
	 * @
	 */
	public HashMap<?, ?> epce4792901_regPsblYn();
}