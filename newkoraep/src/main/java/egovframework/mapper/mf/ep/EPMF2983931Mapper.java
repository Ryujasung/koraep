package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 입고내역서 등록 Mapper
 * @author 양성수
 *
 */
@Mapper("epmf2983931Mapper")
public interface EPMF2983931Mapper {
	
	 /**
	  * 입고내역서 등록 공급 부분
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf2983931_select (Map<String, String> map) ;
	 
	 /**
	  * 입고내역서 등록 그리드쪽 
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf2983931_select2 (Map<String, String> map) ;
	 
	
	 
	 /**
	  * 입고내역서 반환상태 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf2983931_select4 (Map<String, String> map) ;
	 
	 /**
	  * 입고내역서 반환량 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf2983931_select5 (Map<String, String> map) ;

	 /**
	  * 입고내역서 데이터  있는지 확인
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf2983931_select6 (Map<String, String> map) ;


	 /**
	  * 입고내역서 입고 데이터 있을경우 입고테이블에서 데이터 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf2983931_select7 (Map<String, String> map) ;

	
	 /**
	  * 입고내역서 마스터 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf2983931_insert (Map<String, String> map) ;
	 
	 /**
	  * 입고내역서 상세 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf2983931_insert2 (Map<String, String> map) ;
	 
	 /**
	  * 입고내역서 마스터 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf2983931_update (Map<String, String> map) ;
	 
	 /**
	  * 반환내역서 마스터 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf2983931_update2 (Map<String, String> map) ;
	 
	 /**
	  * 입고상세 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf2983931_delete (Map<String, String> map) ;
	 
		
//----------------------------------------------------------------------------------------------------------------------
//						 증빙사진
//----------------------------------------------------------------------------------------------------------------------
		
	 
	 /**
	  * 증빙사진 초기 값 
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf29839882_select (Map<String, String> map) ;

	 /**
	  * 증빙사진 해당 아이디 &문서번호 왜 아이디 있을경우
	  * @param map
	  * @return
	  * @
	  */
	 public int epmf29839882_select2 (Map<String, String> map) ;

	 /**
	  * 증빙사진 저장 
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf29839882_insert (Map<String, String> map) ;
	 
	 /**
	  * 입고등록 첫페이지 시작시 ORI 테이블  정보 복사
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf29839882_insert2 (Map<String, String> map) ;
	 
	 /**
	  * 증빙사진 TMP에서 ORI테이블로 복사
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf29839882_insert3 (Map<String, String> map) ;
	 
	 
	 /**
	  * 입고관리 증빙파일 삭제  
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf29839882_delete (Map<String, String> map) ;
	 
	 /**
	  * 입고관리 증빙파일 삭제   취소 또는 등록시 해당 문서 템프 정리
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf29839882_delete2 (Map<String, String> map) ;
	 
	 /**
	  * 입고관리 증빙파일 삭제   tmp에 데이터 있어서..
	  * @param map
	  * @return
	  * @
	  */
	 public void epmf29839882_delete3 (Map<String, String> map) ;
	 
	 
	 
}
