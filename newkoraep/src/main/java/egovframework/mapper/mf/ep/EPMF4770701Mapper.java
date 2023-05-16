package egovframework.mapper.mf.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 생산자정산발급 Mapper
 * @author Administrator
 *
 */

@Mapper("epmf4770701Mapper")
public interface EPMF4770701Mapper{

	/**
	 * 생산자 목록 조회
	 * @return
	 * @
	 */
	public List<?> epmf4770701_select();
	 
	/**
	 * 생산자 잔액 조회
	 * @return
	 * @
	 */
	public HashMap<?, ?> epmf4770701_select2(Map<String, String> data);
	
	/**
	 * 출고정정 조회
	 * @return
	 * @
	 */
	public List<?> epmf4770701_select3(Map<String, String> data);
	
	/**
	 * 입고정정 조회
	 * @return
	 * @
	 */
	public List<?> epmf4770701_select4(Map<String, String> data);
	
	/**
	 * 직접회수정정 조회
	 * @return
	 * @
	 */
	public List<?> epmf4770701_select5(Map<String, String> data);
	
	/**
	 * 연간혼비율조정 조회
	 * @return
	 * @
	 */
	public List<?> epmf4770701_select6(Map<String, String> data);
	
	/**
	 * 연간출고량조정 조회
	 * @return
	 * @
	 */
	public List<?> epmf4770701_select7(Map<String, String> data);
	
	/**
	 * 정산설정 조회
	 * @return
	 * @
	 */
	public List<?> epmf4770701_select8(Map<String, String> data);
	
	/**
	 * 정산대상금액
	 * @return
	 * @
	 */
	public HashMap<?, ?> epmf4770731_select(Map<String, String> data);
	
	/**
	 * 상세정보
	 * @return
	 * @
	 */
	public HashMap<?, ?> epmf4770731_select2(Map<String, String> data);
	
	/**
	 * 지급/수납 금액
	 * @return
	 * @
	 */
	public HashMap<?, ?> epmf4770731_select3(HashMap<String, String> data);
	
	/**
	 * 정산대상금액 - 교환정산
	 * @return
	 * @
	 */
	public HashMap<?, ?> epmf4770731_select4(Map<String, Object> data);
	
	/**
	 * 정산서발급 (보증금)
	 * @return
	 * @
	 */
	public void epmf4770731_insert(HashMap<String, String> data);
	
	/**
	 * 정산서발급 상세 (보증금)
	 * @return
	 * @
	 */
	public void epmf4770731_insert2(HashMap<String, String> data);
	
	/**
	 * 생산자보증금잔액 인서트
	 * @return
	 * @
	 */
	public void epmf4770731_insert3(HashMap<String, String> data);
	
	/**
	 * 정산서발급 (취급수수료)
	 * @return
	 * @
	 */
	public void epmf4770731_insert4(HashMap<String, String> data);
	
	/**
	 * 정산서발급 상세 (취급수수료)
	 * @return
	 * @
	 */
	public void epmf4770731_insert5(HashMap<String, String> data);
	
	/**
	 * 정정 및 정산연산조정 상태변경
	 * @return
	 * @
	 */
	public void epmf4770731_update(HashMap<String, String> data);
	
	/**
	 * 정정 및 정산연산조정 상태변경 (입고정정)
	 * @return
	 * @
	 */
	public void epmf4770731_update2(HashMap<String, String> data);
	
}



