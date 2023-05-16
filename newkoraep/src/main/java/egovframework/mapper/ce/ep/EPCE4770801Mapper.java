package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 연도별정산발급 Mapper
 * @author Administrator
 *
 */

@Mapper("epce4770801Mapper")
public interface EPCE4770801Mapper{

	/**
	 * 생산자 목록 조회
	 * @return
	 * @
	 */
	public List<?> epce4770801_select();
	 
	/**
	 * 생산자 잔액 조회
	 * @return
	 * @
	 */
	public HashMap<?, ?> epce4770801_select2(Map<String, String> data);
	
	/**
	 * 연간입고량조정 조회
	 * @return
	 * @
	 */
	public List<?> epce4770801_select9(Map<String, String> data);
	
	
	/**
	 * 입고정정 조회
	 * @return
	 * @
	 */
	public List<?> epce4770801_select4(Map<String, String> data);
	
	/**
	 * 입고정정 조회
	 * @return
	 * @
	 */
	public List<?> epce4770801_select4_2(Map<String, String> data);
	
	/**
	 * 정산대상금액
	 * @return
	 * @
	 */
	public HashMap<?, ?> EPCE4770831_select(Map<String, String> data);
	
	/**
	 * 정산대상금액
	 * @return
	 * @
	 */
	public HashMap<?, ?> EPCE4770831_select_2(Map<String, String> data);
	
	/**
	 * 상세정보
	 * @return
	 * @
	 */
	public HashMap<?, ?> EPCE4770831_select2(Map<String, String> data);
	
	/**
	 * 지급/수납 금액
	 * @return
	 * @
	 */
	public HashMap<?, ?> EPCE4770831_select3(HashMap<String, String> data);
	
	/**
	 * 지급/수납 금액
	 * @return
	 * @
	 */
	public HashMap<?, ?> EPCE4770831_select3_2(HashMap<String, String> data);
	
	/**
	 * 정산대상금액 - 교환정산
	 * @return
	 * @
	 */
	public HashMap<?, ?> EPCE4770831_select4(Map<String, Object> data);
	
	/**
	 * 정산설정 조회
	 * @return
	 * @
	 */
	public List<?> epce4770801_select8(Map<String, String> data);
	
	/**
	 * 정산설정 조회
	 * @return
	 * @
	 */
	public List<?> epce4770801_select8_2(Map<String, String> data);
	
	/**
	 * 정산서발급 (보증금)
	 * @return
	 * @
	 */
	public void EPCE4770831_insert(HashMap<String, String> data);
	
	/**
	 * 정산서발급 상세 (보증금)
	 * @return
	 * @
	 */
	public void EPCE4770831_insert2(HashMap<String, String> data);
	
	/**
	 * 생산자보증금잔액 인서트
	 * @return
	 * @
	 */
	public void EPCE4770831_insert3(HashMap<String, String> data);
	
	/**
	 * 정산서발급 (취급수수료)
	 * @return
	 * @
	 */
	public void EPCE4770831_insert4(HashMap<String, String> data);
	
	/**
	 * 정산서발급 상세 (취급수수료)
	 * @return
	 * @
	 */
	public void EPCE4770831_insert5(HashMap<String, String> data);
	
	/**
	 * 정정 및 정산연산조정 상태변경
	 * @return
	 * @
	 */
	public void EPCE4770831_update(HashMap<String, String> data);
	
	/**
	 * 정정 및 정산연산조정 상태변경 (입고정정)
	 * @return
	 * @
	 */
	public void EPCE4770831_update2(HashMap<String, String> data);
}