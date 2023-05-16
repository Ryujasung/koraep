package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 문의/답변 등록 Mapper
 * @author pc
 *
 */
@Mapper("epwh8126696Mapper")
public interface EPWH8126696Mapper {
	
	/**
	 * 문의/답변 상세조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8126696_select1(Map<String, String> map) ;
	
	/**
	 * 문의 등록 순번 조회
	 * @return
	 * @
	 */
	public List<?> epwh8126696_select2() ;
	
	/**
	 * 문의 등록
	 * @param map
	 * @
	 */
	public void epwh8126696_update1(Map<String, String> map) ;
	
	/**
	 * 답변 등록인지 수정인지 확인 조회
	 * @return
	 * @
	 */
	public List<?> epwh8126696_select3(Map<String, String> map) ;
	
	/**
	 * 답변 등록
	 * @param map
	 * @
	 */
	public void epwh8126696_update2(Map<String, String> map) ;
	
	/**
	 * 문의/답변 수정
	 * @param map
	 * @
	 */
	public void epwh8126696_update3(Map<String, String> map) ;

}
