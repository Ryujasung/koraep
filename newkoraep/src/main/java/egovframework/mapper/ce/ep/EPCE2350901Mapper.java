package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 지급정보생성 Mapper
 * @author Administrator
 *
 */

@Mapper("epce2350901Mapper")
public interface EPCE2350901Mapper {

	/**
	 * 지급정보생성 대상 조회
	 * @return
	 * @
	 */
	public List<?> epce2350901_select(Map<String, String> data) ;
	
	/**
	 * 입고상세 리스트
	 * @return
	 * @
	 */
	public List<Map<String, String>> epce2350901_select2(Map<String, String> data) ;
	
	/**
	 * 회수상세 리스트
	 * @return
	 * @
	 */
	public List<Map<String, String>> epce2350901_select3(Map<String, String> data) ;
	
	/**
	 * 지급대상 회수 리스트
	 * @return
	 * @
	 */
	public List<Map<String, String>> epce2350901_select4(Map<String, String> data) ;
	
	/**
	 * 지급정보 마스터 인서트
	 * @return
	 * @
	 */
	public int epce2350901_insert(Map<String, String> data) ;
	
	/**
	 * 지급정보 상세 인서트
	 * @return
	 * @
	 */
	public int epce2350901_insert2(Map<String, String> data) ;
	
	/**
	 * 소매 지급정보 마스터 인서트
	 * @return
	 * @
	 */
	public int epce2350901_insert3(Map<String, String> data) ;
	
	/**
	 * 소매 지급정보 상세 인서트
	 * @return
	 * @
	 */
	public int epce2350901_insert4(Map<String, String> data) ;
	
	/**
	 * 회수입고연결 인서트
	 * @return
	 * @
	 */
	public int epce2350901_insert5(Map<String, String> data) ;
	
	/**
	 * 지급정보 상세 인서트 (소매적용)
	 * @return
	 * @
	 */
	public int epce2350901_insert6(Map<String, String> data) ;
	
	/**
	 * 지급정보 상계처리 인서트
	 * @return
	 * @
	 */
	public int epce2350901_insert7(Map<String, String> data) ;
	
	/**
	 * 지급정보 마스터 금액 업데이트
	 * @return
	 * @
	 */
	public void epce2350901_update(Map<String, String> data) ;
	
	/**
	 * 입고 및 반환 마스터 상태 변경
	 * @return
	 * @
	 */
	public void epce2350901_update2(Map<String, String> data) ;
	
	/**
	 * 회수상태 및 잔여량 업데이트
	 * @return
	 * @
	 */
	public void epce2350901_update3(Map<String, String> data) ;
	
	/**
	 * 입고 및 반환 마스터 상태 변경 (소매적용)
	 * @return
	 * @
	 */
	public void epce2350901_update4(Map<String, String> data) ;
	
}



