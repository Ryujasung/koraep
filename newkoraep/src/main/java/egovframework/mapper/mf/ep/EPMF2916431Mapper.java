package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 입고내역서 등록 Mapper
 * @author 양성수
 *
 */
@Mapper("epmf2916431Mapper")
public interface EPMF2916431Mapper {
	
	 /**
	  * 입고내역서 등록 공급 부분
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf2916431_select (Map<String, String> map) ;
	 
	 /**
	  * 입고내역서 등록 그리드쪽 
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf2916431_select2 (Map<String, String> map) ;
	 

	 /**
	  * 입고내역서 반환상태 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf2916431_select4 (Map<String, String> map) ;
	 
	 /**
	  * 입고내역서 반환량 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf2916431_select5 (Map<String, String> map) ;

	 /**
	  * 입고내역서 데이터  있는지 확인
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf2916431_select6 (Map<String, String> map) ;


	 /**
	  * 입고내역서 입고 데이터 있을경우 입고테이블에서 데이터 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf2916431_select7 (Map<String, String> map) ;

	
	 /**
	  * 입고내역서 마스터 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf2916431_insert (Map<String, String> map) ;
	 
	 /**
	  * 입고내역서 상세 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf2916431_insert2 (Map<String, String> map) ;
	 
	 /**
	  * 입고내역서 마스터 수량 업로드
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf2916431_update (Map<String, String> map) ;
	 
	 /**
	  * 반환내역서 마스터 상태변경및 입고확인입력
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf2916431_update2 (Map<String, String> map) ;
	 
	 /**
	  * 실태조사 상태변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf2916431_update3 (Map<String, String> map) ;
	 
	 /**
	  * 입고마스터 상태변경및 입고확인입력
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf2916431_update4 (Map<String, String> map) ;
	 
	 
	 /**
	  * 입고상세 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf2916431_delete (Map<String, String> map) ;
	 
	 
}
