package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 교환연간조정 Mapper
 * @author 이근표
 *
 */

@Mapper("epce4707901Mapper")
public interface EPCE4707901Mapper {

	/**
	 * 정산연간조정 조회	혼비율조정
	 * @return
	 * @
	 */
	public List<?> epce4707901_select(Map<String, String> data) ;
	
	/**
	 * 정산연간조정 조회  출고량조정
	 * @return
	 * @
	 */
	public List<?> epce4707901_select2(Map<String, String> data) ;
	
	
	//---------------------------------------------------------------------------------------------------------------------
	//	조정수량관리
	//---------------------------------------------------------------------------------------------------------------------
	/**
	 *	빈용기 보증금
	 * @return
	 * @
	 */
	public List<?> epce4707988_select(Map<String, String> data) ;

	/**
	 * 수정일 경우 데이터 값
	 * @return
	 * @
	 */
	public List<?> epce4707988_select3(Map<String, String> data) ;
	
	
	/**
	 *	조정수량관리 값 체크
	 * @return
	 * @
	 */
	public int epce4707988_select4(Map<String, String> data) ;
	
	
	/**
	 *	조정수량관리 저장
	 * @return
	 * @
	 */
	public void epce4707988_insert(Map<String, String> data) ;
	

	/**
	 *	조정수량관리 수정
	 * @return
	 * @
	 */
	public void epce4707988_update(Map<String, String> data) ;
	
	
	/**
	 *	조정수량관리 삭제
	 * @return
	 * @
	 */
	public void epce4707988_delete(Map<String, String> data) ;
	
	
}



