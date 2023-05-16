package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 개별취급수수료관리 Mapper
 * @author 양성수
 *
 */
@Mapper("epce0164301Mapper")
public interface EPCE0164301Mapper {
	
	
	 /**
	  * 개별취급수수료관리
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0164301_select (Map<String, String> map) ;
	 
	 /**
	  * 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0164301_select_cnt (Map<String, String> map);
	 

	 /**
	  * 개별취급수수료관리 삭제여부조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0164301_select2 (Map<String, String> map) ;
	 
	 /**
	  * 개별취급수수료관리 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce0164301_delete (Map<String, String> map) ;
	 /**
	  * 개별취급수수료관리 이력 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce0164301_delete2 (Map<String, String> map) ;


	 
	 /**
	  * 개별취급수수료등록  거래처구분 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0164331_select() ;
	 
	 /**
	  * 개별취급수수료등록  직매장/공장 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0164331_select2 (Map<String, String> map) ;


	 /**
	  * 개별취급수수료등록  적용기간 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0164331_select3 (Map<String, String> map) ;
	 
	 /**
	  * 개별취급수수료등록  기준취급수수료 선택  조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0164331_select4 (Map<String, String> map) ;
	 
	 /**
	  * 개별취급수수료등록   일괄적용대상 설정 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0164331_select5 (Map<String, String> map) ;

	 /**
	  * 개별취급수수료등록   등록순번 조회
	  * @param map
	  * @return
	  * @
	  */
	 public String epce0164331_select6 (Map<String, String> map) ;
	 
	 /**
	  * 개별취급수수료등록   적용번호 조회
	  * @param map
	  * @return
	  * @
	  */
	 public String epce0164331_select7 (Map<String, String> map) ;
	 
	 /**
	  * 개별취급수수료등록   중복체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0164331_select8 (Map<String, String> map) ;
	 
	 /**
	  * 개별취급수수료등록   기준취급수수료 날짜 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce0164331_select9 (Map<String, String> map) ;
	
	 /**
	  * 개별취급수수료등록   기준보증금 저장
	  * @param map
	  * @return
	  * @
	  */
	 public void epce0164331_insert (Map<String, String> map) ;
	 
	 /**
	  * 개별취급수수료등록   기준보증금이력 저장
	  * @param map
	  * @return
	  * @
	  */
	 public void epce0164331_insert2 (Map<String, String> map) ;
	 
	 /**
	  * 개별취급수수료등록   채번순번 저장
	  * @param map
	  * @return
	  * @
	  */
	 public void epce0164331_insert3 (Map<String, String> map) ;
	 
	 
	 /**
	  * 개별취급수수료변경 그리드1 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce0164342_select (Map<String, String> map) ;

	 /**
	  * 개별취급수수료변경   변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epce0164342_update (Map<String, String> map) ;



}
