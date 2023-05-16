package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 정산연간조정 Mapper
 * @author Administrator
 *
 */

@Mapper("epce4707801Mapper")
public interface EPCE4707801Mapper {

	/**
	 * 정산연간조정 조회	혼비율조정
	 * @return
	 * @
	 */
	public List<?> epce4707801_select(Map<String, String> data) ;
	
	/**
	 * 정산연간조정 조회  출고량조정
	 * @return
	 * @
	 */
	public List<?> epce4707801_select2(Map<String, String> data) ;
	
	
	//---------------------------------------------------------------------------------------------------------------------
	//	조정수량관리
	//---------------------------------------------------------------------------------------------------------------------
	/**
	 *	빈용기 보증금
	 * @return
	 * @
	 */
	public List<?> epce4707888_select(Map<String, String> data) ;

	/**
	 * 수정일 경우 데이터 값
	 * @return
	 * @
	 */
	public List<?> epce4707888_select3(Map<String, String> data) ;
	
	
	/**
	 *	조정수량관리 값 체크
	 * @return
	 * @
	 */
	public int epce4707888_select4(Map<String, String> data) ;
	
	
	/**
	 *	조정수량관리 저장
	 * @return
	 * @
	 */
	public void epce4707888_insert(Map<String, String> data) ;
	

	/**
	 *	조정수량관리 수정
	 * @return
	 * @
	 */
	public void epce4707888_update(Map<String, String> data) ;
	
	
	/**
	 *	조정수량관리 삭제
	 * @return
	 * @
	 */
	public void epce4707888_delete(Map<String, String> data) ;
	
	
}



