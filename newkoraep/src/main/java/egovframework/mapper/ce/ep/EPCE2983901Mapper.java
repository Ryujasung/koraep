package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 입고관리 Mapper
 * @author 양성수
 *
 */
@Mapper("epce2983901Mapper")
public interface EPCE2983901Mapper {  
	
	 /**
	  * 입고관리 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce2983901_select4 (Map<String, String> map) ;
	 
	 /**
	  * 입고관리 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce2983901_select4_cnt (Map<String, String> map) ;
	 
	 /**
	  * 입고관리 상태체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce2983901_select5 (Map<String, String> map) ;

	 /**
	  * 입고내역서 마스터 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983901_insert (Map<String, String> map) ;
	 
	 /**
	  * 입고내역서 상세 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983901_insert2 (Map<String, String> map) ;
	 
	 /**
	  * 실태조사테이블에 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983901_insert3 (Map<String, String> map) ;
	 
	 /**
	  * 입고관리 반환마스터 상태변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983901_update (Map<String, String> map) ;
	 
	 /**
	  * 입고관리  입고마스터 상태변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983901_update2 (Map<String, String> map) ;
	 
	 /**
	  * 입고내역서 마스터 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983901_update3 (Map<String, String> map) ;
	 
	 /**
	  * 반환내역서 마스터 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983901_update4 (Map<String, String> map) ;
	 
	//---------------------------------------------------------------------------------------------------------------------
	//	입고내역서 상세
	//---------------------------------------------------------------------------------------------------------------------
	 
	 /**
	  * 입고내역서 상세조회 공급 부분
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce2983964_select (Map<String, String> map) ;
	 
	 /**
	  * 입고내역서 상세조회 반환문서 그리드쪽 
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce2983964_select2 (Map<String, String> map) ;
	 
	 /**
	  * 입고내역서 상세조회 입고문서 그리드쪽 
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce2983964_select3 (Map<String, String> map) ;
	 
	 /**
	  * 반환마스테 테이블 반환등록으로 상태 변경하고 입고정보 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983964_update (Map<String, String> map) ;
	 
	 /**
	  * 입고확인취소요청정보 테이블 요청상태코드 상태변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983964_update2 (Map<String, String> map) ;
	 
	 /**
	  * 입고증빙파일 테이블 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983964_delete (Map<String, String> map) ;
	 
	 /**
	  * 입고상세 테이블 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983964_delete2 (Map<String, String> map) ;
	 
	 
	 /**
	  * 입고관리 마스터 테이블 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983964_delete3 (Map<String, String> map) ;
	 
	 
	 /**
	  * 실태조사증빙파일 테이블 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983964_delete4 (Map<String, String> map) ;
	 
	 /**
	  * 실태조사요청정보 테이블 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983964_delete5 (Map<String, String> map) ;
	 
	//---------------------------------------------------------------------------------------------------------------------
	//	 조사확인요청사유서 (도매업자);
	//---------------------------------------------------------------------------------------------------------------------
	 /**
	  *  조사확인요청사유서 (도매업자)  저장
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983988_insert (Map<String, String> map) ;
	 
	 
	 /**
	  *  조사확인요청사유서 (도매업자)  반환관리,입고관리 반환상태 조사요청으로 변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epce2983988_update (Map<String, String> map) ;
	 
	//---------------------------------------------------------------------------------------------------------------------
	//	증빙사진 페이지
	//---------------------------------------------------------------------------------------------------------------------
			  	 
	 /**
	  * 입고내역서 상세조회에서 증빙사진 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce29839883_select (Map<String, String> map) ;
	 
	 
	 /**
	  * 취소요청 사유저장
	  * @param map
	  * @return
	  * @
	  */
	 public void epce29839884_insert(Map<String, String> map) ;
	 
}
