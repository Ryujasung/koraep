package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 반환내역등록 Mapper
 * @author 양성수
 *
 */
@Mapper("epwh2910131Mapper")
public interface EPWH2910131Mapper {
	
	
	 /**
	  * 반환내역서등록 도매업자 구분
	  * @return
	  * @
	  */
	 public List<?> epwh2910131_select () ;

	 /**
	  * 반환내역서등록 등록시 검색 등록한 용기명 있는지 조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epwh2910131_select3 (Map<String, String> map) ;
	 
	 /**
	  * 반환내역서등록 엑셀 업로드 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2910131_select4 (Map<String, String> map) ;
	 
	 /**
	  * 반환내역서등록 마스터 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2910131_insert (Map<String, String> map) ;
	 
	 /**
	  * 반환내역서등록 상세 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2910131_insert2 (Map<String, String> map) ;

	 /**
	  * 반환내역서등록 반환문서 sum 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2910131_update (Map<String, String> map) ;
	 
}
