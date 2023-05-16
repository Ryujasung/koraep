package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 팝업관리 Mapper
 * @author Administrator
 *
 */

@Mapper("epce8149301Mapper")
public interface EPCE8149301Mapper {

	/**
	 * 팝업관리 리스트
	 * @return
	 * @
	 */
	public List<?> epce8149301_select1(Map<String, String> map) ;

	
	/**
	 * 팝업 상세조회
	 * @param map
	 * @return
	 * @
	 */
	public HashMap<String, String> epce8149301_select2(String POP_SEQ) ;
	
	
	
	/**
	 * 팝업 등록
	 * @param map
	 * @
	 */
	public void epce8149301_update1(Map<String, String> map) ;
	
	
	/**
	 * 팝업 수정
	 * @param map
	 * @
	 */
	public void epce8149301_update2(Map<String, String> map) ;
	
	
	/**
	 * 팝업 삭제
	 * @param map
	 * @
	 */
	public void epce8149301_delete(String POP_SEQ) ;
	
	/**
	 * 사용여부 변경
	 * @param map
	 * @
	 */
	public void epce8149301_update3(String POP_SEQ) ;


	public Map<String, Object> popRegId(HashMap<String, String> data);
}
