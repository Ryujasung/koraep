package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 직접반환 정보조회 Mapper
 * @author pc
 *
 */
@Mapper("epmf6654201Mapper")
public interface EPMF6654201Mapper {
	
	/**
	  * 직접반환 조회	
	  * @param map
	  * @return
	  * @
	  */
	public List<?> epmf6654201_select(Map<String, String> map) ;
	
	/**
	  * 직접반환 조회	
	  * @param map
	  * @return
	  * @
	  */
	public List<?> epmf6654201_select_cnt(Map<String, String> map) ;
	
	/**
	  * 직접반환 상태체크
	  * @param map
	  * @return
	  * @
	  */
	public int epmf6654201_select2(Map<String, String> map) ;
	
	/**
	  * 직접반환 마스터 인서트
	  * @param map
	  * @return
	  * @
	  */
	public void epmf6654231_insert(Map<String, String> map) ;
	
	/**
	  * 직접반환 상세 인서트
	  * @param map
	  * @return
	  * @
	  */
	public void epmf6654231_insert2(Map<String, String> map) ;
	
	/**
	  * 직접반환 마스터 업데이트
	  * @param doc_no
	  * @return
	  * @
	  */
	public void epmf6654231_update(String doc_no) ;

	/**
	  * 직접반환구분 조회
	  * @param map
	  * @return
	  * @
	  */
	public String epmf6654231_select(Map<String, String> map) ;
	
	/**
	  * 정보삭제
	  * @param map
	  * @return
	  * @
	  */
	public void epmf6654201_delete(Map<String, String> map) ;
	
	/**
	  * 직접반환정보등록 엑셀 업로드 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf6654231_select2(Map<String, String> map) ;
	 
	 /**
	  * 직접반환 변경 상세리스트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf6654242_select(Map<String, String> map) ;
	 
	 /**
	  * 상태조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf6654242_select2(Map<String, String> map) ;
	 
	 /**
	  * 정보삭제
	  * @param map
	  * @return
	  * @
	  */
	public void epmf6654242_delete(Map<String, String> map) ;
	
	/**
	  * 직접반환 상세리스트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf6654264_select(Map<String, String> map) ;

	
}
