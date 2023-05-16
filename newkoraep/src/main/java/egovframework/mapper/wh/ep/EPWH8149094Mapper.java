package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 공지사항 등록 Mapper
 * @author pc
 *
 */
@Mapper("epwh8149094Mapper")
public interface EPWH8149094Mapper {
	
	/**
	 * 공지사항 등록 순번 조회
	 * @return
	 * @
	 */
	public List<?> epwh8149094_select1() ;
	
	/**
	 * 공지사항 등록
	 * @param map
	 * @
	 */
	public void epwh8149094_update1(Map<String, String> map) ;
	
	/**
	 * 공지사항 첨부파일 등록
	 * @param map
	 * @
	 */
	public void epwh8149094_update2(Map<String, String> map) ;
	
	/**
	 * 공지사항 수정
	 * @param map
	 * @
	 */
	public void epwh8149094_update3(Map<String, String> map) ;
	
	/**
	 * 공지사항 상세조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8149094_select2(Map<String, String> map) ;
	
	/**
	 * 공지사항 첨부파일 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8149094_select3(Map<String, String> map) ;
	
	/**
	 * 삭제할 공지사항 첨부파일 이름조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8149094_select4(Map<String, String> map) ;
	
	/**
	 * 공지사항 첨부파일 이름삭제
	 * @param map
	 * @return
	 * @
	 */
	public void epwh8149094_delete(Map<String, String> map) ;
	
	/**
	 * 공지사항 기존 첨부파일 리스트 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8149094_select5(Map<String, String> map) ;

	/**
	 * 공지사항 기존 첨부파일 순번 재조정
	 * @param map
	 * @
	 */
	public void epwh8149094_update4(Map<String, String> map) ;
}
