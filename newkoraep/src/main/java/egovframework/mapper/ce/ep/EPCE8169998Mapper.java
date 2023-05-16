package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * FAQ 등록 Mapper
 * @author pc
 *
 */
@Mapper("epce8169998Mapper")
public interface EPCE8169998Mapper {
	
	/**
	 * FAQ 등록 순번 조회
	 * @return
	 * @
	 */
	public List<?> epce8169998_select1() ;
	
	/**
	 * FAQ 등록
	 * @param map
	 * @
	 */
	public void epce8169998_update1(Map<String, String> map) ;
	
	/**
	 * FAQ 첨부파일 등록
	 * @param map
	 * @
	 */
	public void epce8169998_update2(Map<String, String> map) ;
	
	/**
	 * FAQ 수정
	 * @param map
	 * @
	 */
	public void epce8169998_update3(Map<String, String> map) ;
	
	/**
	 * FAQ 상세조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce8169998_select2(Map<String, String> map) ;
	
	/**
	 * FAQ 첨부파일 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce8169998_select3(Map<String, String> map) ;
	
	/**
	 * 삭제할 FAQ 첨부파일 이름조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce8169998_select4(Map<String, String> map) ;
	
	/**
	 * FAQ 첨부파일 이름삭제
	 * @param map
	 * @return
	 * @
	 */
	public void epce8169998_delete(Map<String, String> map) ;
	
	/**
	 * FAQ 기존 첨부파일 리스트 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce8169998_select5(Map<String, String> map) ;
	
	/**
	 * FAQ 기존 첨부파일 순번 재조정
	 * @param map
	 * @
	 */
	public void epce8169998_update4(Map<String, String> map) ;

	public Map<String, Object> faqRegId(HashMap<String, String> data);

}
