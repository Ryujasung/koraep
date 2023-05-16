package egovframework.mapper.wh.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 정산서조회 Mapper
 * @author Administrator
 *
 */

@Mapper("epwh4707201Mapper")
public interface EPWH4707201Mapper{

	/**
	 * 사업자구분
	 * @return
	 * @
	 */
	public List<?> epwh4707201_select();

	/**
	 * 정산서조회
	 * @return
	 * @
	 */
	public List<?> epwh4707201_select2(Map<String, String> data);

	/**
	 * 정산서 상태 체크
	 * @return
	 * @
	 */
	public int epwh4707201_select3(Map<String, Object> data);

	/**
	 * 정산서 관련문서 상태 변경
	 * @return
	 * @
	 */
	public void epwh4707201_update(Map<String, Object> data);

	/**
	 * 정산서 삭제
	 * @return
	 * @
	 */
	public void epwh4707201_delete(Map<String, Object> data);

	/**
	 * 정산서상세조회
	 * @return
	 * @
	 */
	public HashMap<?, ?> epwh4707264_select(Map<String, String> data);

	/**
	 * 정산세부내역 조회 (보증금)
	 * @return
	 * @
	 */
	public List<?> epwh4707264_select2(Map<String, String> data);

	/**
	 * 정산세부내역 조회 (취급수수료)
	 * @return
	 * @
	 */
	public List<?> epwh4707264_select8(Map<String, String> data);

	/**
	 * 출고정정
	 * @return
	 * @
	 */
	public List<?> epwh4707264_select3(Map<String, String> data);

	/**
	 * 입고정정
	 * @return
	 * @
	 */
	public List<?> epwh4707264_select4(Map<String, String> data);

	/**
	 * 직접회수정정
	 * @return
	 * @
	 */
	public List<?> epwh4707264_select5(Map<String, String> data);

	/**
	 * 연간혼비율조정
	 * @return
	 * @
	 */
	public List<?> epwh4707264_select6(Map<String, String> data);

	/**
	 * 연간출고량조정
	 * @return
	 * @
	 */
	public List<?> epwh4707264_select7(Map<String, String> data);

	/**
	 * 연간입고량조정 조회
	 * @return
	 * @
	 */
	public List<?> epwh4707264_select10(Map<String, String> data);
	
	/**
	 * 연간교환량조정 조회
	 * @return
	 * @
	 */
	public List<?> epwh4707264_select11(Map<String, String> data);
	

	/**
	 * 교환정산
	 * @return
	 * @
	 */
	public List<?> epwh4707264_select9(Map<String, String> data);

	
	/**
	 * 수납확인 상세조회 (고지서)
	 * @return
	 * @
	 */
	public List<?> epwh4707288_select(Map<String, String> data) ;

	/**
	 * 수납확인 상세조회 (수납내역)
	 * @return
	 * @
	 */
	public List<?> epwh4707288_select2(Map<String, String> data) ;

}


