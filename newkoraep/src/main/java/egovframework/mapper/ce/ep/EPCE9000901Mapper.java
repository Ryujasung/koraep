package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 정산서조회 Mapper
 * @author Administrator
 *
 */

@Mapper("epce9000901Mapper")
public interface EPCE9000901Mapper{

	/**
	 * 사업자구분
	 * @return
	 * @
	 */
	public List<?> epce9000901_select();

	/**
	 * 상계처리관리 조회
	 * @return
	 * @
	 */
	
	public List<?> epce9000901_select2(Map<String, String> data);
	
	/**
	 * 상계처리관리 상태
	 * @return
	 * @
	 */
	
	public List<?> epce9000901_select3();


	/**
	 * 지급정보생성 대상 조회
	 * @return
	 * @
	 */
//	public List<?> epce9000902_select(Map<String, String> data) ;
	
	/**
	  * 상계처리 상세조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000902_select (Map<String, String> map);

	/**
	 * 지급정보 마스터 인서트
	 * @return
	 * @
	 */
	public int epce9000902_insert(Map<String, String> data) ;
	
	/**
	 * 지급정보 상세 인서트
	 * @return
	 * @
	 */
	public int epce9000902_insert2(Map<String, String> data) ;
	
	/**
	 * 지급정보 마스터 금액 업데이트
	 * @return
	 * @
	 */
	public void epce9000902_update(Map<String, String> data) ;
	
	/**
	 * 입고 및 반환 마스터 상태 변경
	 * @return
	 * @
	 */
	public void epce9000902_update2(Map<String, String> data) ;
	
	/**
	 * 상계처리상세 엑셀
	 * @return
	 * @
	 */
	public List<Map<String, String>> epce9000902_select2(HashMap<String, String> data) ;
	
	/**
	 * 회수상세 리스트
	 * @return
	 * @
	 */
	public List<Map<String, String>> epce9000902_select3(Map<String, String> data) ;
	
	/**
	 * 회수입고연결 인서트
	 * @return
	 * @
	 */
	public int epce9000902_insert5(Map<String, String> data) ;
	
	/**
	 * 회수상태 및 잔여량 업데이트
	 * @return
	 * @
	 */
	public void epce9000902_update3(Map<String, String> data) ;
	
	/**
	 * 지급대상 회수 리스트
	 * @return
	 * @
	 */
	public List<Map<String, String>> epce9000902_select4(Map<String, String> data) ;
	
	/**
	 * 소매 지급정보 마스터 인서트
	 * @return
	 * @
	 */
	public int epce9000902_insert3(Map<String, String> data) ;
	
	/**
	 * 소매 지급정보 상세 인서트
	 * @return
	 * @
	 */
	public int epce9000902_insert4(Map<String, String> data) ;
	
	/**
	 * 지급정보 상세 인서트 (소매적용)
	 * @return
	 * @
	 */
	public int epce9000902_insert6(Map<String, String> data) ;
	
	/**
	 * 입고 및 반환 마스터 상태 변경 (소매적용)
	 * @return
	 * @
	 */
	public void epce9000902_update4(Map<String, String> data) ;
	
}
