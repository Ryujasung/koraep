package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 도매업자정산지급내역 Mapper
 * @author Administrator
 *
 */

@Mapper("epce4730601Mapper")
public interface EPCE4730601Mapper {

	/**
	 * 도매업자정산지급내역 조회
	 * @return
	 * @
	 */
	public List<?> epce4730601_select(Map<String, String> data) ;
	
	/**
	 * 정산서 상태변경
	 * @return
	 * @
	 */
	public int epce4730601_update(Map<String, String> data) ;
	
	/**
	 * 정산서 상태변경 - 연계처리완료
	 * @return
	 * @
	 */
	public int epce4730601_update2(Map<String, String> data) ;
	
	/**
     * 연계자료 생성 - 도매업자
     * @param map
     * @return
     * @throws Exception
     */
    public void INSERT_FI_Z_KORA_ECDOCU_W(Map<String, String> map) throws Exception;
    
}



