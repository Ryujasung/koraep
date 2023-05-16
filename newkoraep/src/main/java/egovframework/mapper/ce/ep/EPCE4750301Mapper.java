package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 생산자정산지급내역 Mapper
 * @author Administrator
 *
 */

@Mapper("epce4750301Mapper")
public interface EPCE4750301Mapper {

	/**
	 * 생산자정산지급내역 조회
	 * @return
	 * @
	 */
	public List<?> epce4750301_select(Map<String, String> data) ;
	
	/**
	 * 정산서 상태변경
	 * @return
	 * @
	 */
	public int epce4750301_update(Map<String, String> data) ;
	
	/**
	 * 정산서 상태변경 - 연계처리완료
	 * @return
	 * @
	 */
	public int epce4750301_update2(Map<String, String> data) ;

    /**
     * 연계자료 생성 - 생산자
     * @param map
     * @return
     * @throws Exception
     */
    public void INSERT_FI_Z_KORA_ECDOCU(Map<String, String> map) throws Exception;
    
    /**
     * 연계자료 생성 - 생산자 (교환정산)
     * @param map
     * @return
     * @throws Exception
     */
    public void INSERT_FI_Z_KORA_ECDOCU_C(Map<String, String> map) throws Exception;
    
}



