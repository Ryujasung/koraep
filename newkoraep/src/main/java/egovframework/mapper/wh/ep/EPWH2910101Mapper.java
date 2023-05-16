package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 반환관리 Mapper
 * @author 양성수
 *
 */
@Mapper("epwh2910101Mapper")
public interface EPWH2910101Mapper {
	
	
	 /**
	  * 반환관리 도매업자 구분 조회
	  * @return
	  * @
	  */
	 public List<?> epwh2910101_select () ;

	 /**
	  * 반환관리 생산자 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2910101_select2 (Map<String, String> map) ;
	 
	 /**
	  * 반환관리 도매업자 업체명 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2910101_select3 (Map<String, String> map) ;
	 
	 /**
	  * 반환관리 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2910101_select4 (Map<String, Object> map) ;
	 
	 /**
	  * 반환관리 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2910101_select4_cnt (Map<String, Object> map) ;
	 
	 /**
	  * 반환내역상제조회(20200402추가)	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2910101_select4_1 (Map<String, Object> map) ;
	 
	 /**
	  * 반환내역상제조회 카운트(20200402추가)
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2910101_select4_1_cnt (Map<String, Object> map) ;
	 
	 /**
	  * 반환관리 실태조사시 상태값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epwh2910101_select5 (Map<String, String> map) ;
	 
	 /**
	  * 반환관리 삭제시  변경시 반환상태 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epwh2910101_select6 (Map<String, String> map) ;
	 
	 /**
	  * 반환등록요청 상태값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epwh2910101_select7 (Map<String, String> map) ;
	 
	 /**
	  * 반환관리 실태조사
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2910101_insert (Map<String, String> map) ;
	 
	 /**
	  * 반환관리 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2910101_delete (Map<String, String> map) ;
	 
	 /**
	  * 반환관리 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2910101_update (Map<String, String> map) ;
	 
	 /**
	  * 반환내역서 상세조회 공급 부분
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2910164_select (Map<String, String> map) ;
	 
	 /**
	  * 반환내역서 상세조회 그리드쪽 
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2910164_select2 (Map<String, String> map) ;
	 
	 /**
	  * 반환등록요청 일괄확인
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2910101_insert2 (Map<String, String> map) ;
}
