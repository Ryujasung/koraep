package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 실태조사 Mapper
 * @author 양성수
 *
 */
@Mapper("epwh2916401Mapper")
public interface EPWH2916401Mapper {
	
	
	 /**
	  * 실태조사 도매업자 구분 조회
	  * @return
	  * @
	  */
	 public List<?> epwh2916401_select () ;

	 /**
	  * 실태조사 생산자 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2916401_select2 (Map<String, String> map) ;
	 
	 /**
	  * 실태조사 도매업자 업체명 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2916401_select3 (Map<String, String> map) ;
	 
	 /**
	  * 실태조사 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2916401_select4 (Map<String, String> map) ;
	 
	 /**
	  * 실태조사 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2916401_select4_cnt (Map<String, String> map) ;
	 
	 /**
	  * 실태조사 상태체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epwh2916401_select5 (Map<String, String> map) ;
	 
	 /**
	  * 실태조사 상태조회
	  * @return
	  * @
	  */
	 public List<?> epwh2916401_select7 () ;

	 /**
	  * 실태조사 구분
	  * @return
	  * @
	  */
	 public List<?> epwh2916401_select8 () ;


	 /**
	  * 입고관리 반환마스터 상태변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2916401_update (Map<String, String> map) ;
	 
	 /**
	  * 입고관리  입고마스터 상태변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2916401_update2 (Map<String, String> map) ;
	 
	 /**
	  * 실태조사파일테이블 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2916401_delete (Map<String, String> map) ;
	 /**
	  * 실태조사정보테이블 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2916401_delete2 (Map<String, String> map) ;
	 
	//---------------------------------------------------------------------------------------------------------------------
	// 증빙파일등록
	//---------------------------------------------------------------------------------------------------------------------
	 
	 /**
	  * 증빙파일등록 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2916488_select (Map<String, String> map) ;

	 /**
	  * 증빙파일등록 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2916488_insert (Map<String, String> map) ;
	 
	 /**
	  * 증빙파일등록 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2916488_delete (Map<String, String> map) ;
	 
	 
	//---------------------------------------------------------------------------------------------------------------------
	// 증빙파일조회
	//---------------------------------------------------------------------------------------------------------------------
	 /**
	  * 증빙파일조회 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh29164882_select (Map<String, String> map) ;
	
	//---------------------------------------------------------------------------------------------------------------------
	// 실태조사요청정보
	//---------------------------------------------------------------------------------------------------------------------
	 /**
	  * 실태조사요청정보 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh29164883_select (Map<String, String> map) ;
	 
	 /**
	  * 실태조사요청정보 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh29164883_update (Map<String, String> map) ;

	 
	 /**
	  * 실태조사표 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh29164313_select (Map<String, String> map) ;
	 
	 
	 /**
	  * 실태조사표 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh29164313_update (Map<String, String> map) ;
}
