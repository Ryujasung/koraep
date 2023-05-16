package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 생산자정산발급 Mapper
 * @author Administrator
 *
 */

@Mapper("epce4793901Mapper")
public interface EPCE4793901Mapper{

	/**
	 * 생산자 목록 조회
	 * @return
	 * @
	 */
	public List<?> epce4793901_select();
	 
	/**
	 * 생산자 잔액 조회
	 * @return
	 * @
	 */
	public HashMap<?, ?> epce4793901_select2(Map<String, String> data);

	/**
	 * 정산설정 조회
	 * @return
	 * @
	 */
	public List<?> epce4793901_select3(Map<String, String> data);

	/**
	 * 상세정보
	 * @return
	 * @
	 */
	public HashMap<?, ?> epce4793931_select2(Map<String, String> data);
	
	/**
	 * 정산서발급 (보증금)
	 * @return
	 * @
	 */
	public void epce4793931_insert(HashMap<String, String> data);
	
	/**
	 * 정산서발급 상세 (보증금)
	 * @return
	 * @
	 */
	public void epce4793931_insert2(HashMap<String, String> data);
	
	/**
	 * 생산자보증금잔액 인서트
	 * @return
	 * @
	 */
	public void epce4793931_insert3(HashMap<String, String> data);
	
	/**
	 * 정산서발급 (취급수수료)
	 * @return
	 * @
	 */
	public void epce4793931_insert4(HashMap<String, String> data);
}



