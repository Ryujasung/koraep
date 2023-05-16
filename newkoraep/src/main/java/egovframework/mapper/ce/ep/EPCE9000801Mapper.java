package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 반환관리 Mapper
 * @author 양성수
 *
 */
@Mapper("epce9000801Mapper")
public interface EPCE9000801Mapper {


	 /**
	  * 반환관리 도매업자 구분 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000801_select () ;

	 /**
	  * 반환관리 생산자 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000801_select2 (Map<String, String> map) ;

	 /**
	  * 반환관리 도매업자 업체명 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000801_select3 (Map<String, String> map) ;

	 /**
	  * 반환관리 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000801_select4 (Map<String, Object> map) ;

	 /**
	  * 반환내역서등록 상세 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000801_insert2 (Map<String, String> map) ;
	 
	 public void epce9000801_insert3 (Map<String, String> map) ;
	 
	 /**
	  * 엑셀 업로드 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000831_select4 (Map<String, String> map) ;
	 
	 /**
	  * 반환관리 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000801_select4_cnt (Map<String, Object> map) ;
	 
	 /**
	  * 반환내역상세조회(20200402추가)
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000801_select4_1 (Map<String, Object> map) ;
	 
	 /**
	  * 반환내역상세조회	카운트 (20200402추가)
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000801_select4_1_cnt (Map<String, Object> map) ;

	 /**
	  * 반환관리 실태조사시 상태값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce9000801_select5 (Map<String, String> map) ;

	 /**
	  * 반환관리 삭제시  변경시 반환상태 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce9000801_select6 (Map<String, String> map) ;

	 /**
	  * 반환등록요청 상태값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epce9000801_select7 (Map<String, String> map) ;
	 
	 /**
	  * 반환관리 실태조사
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000801_insert (Map<String, String> map) ;
	 
	 
	 /**
	  * 톰라데이터입력
	  * @param map
	  * @return
	  * @
	  */
	 public void tomra_data_insert (Map<String, String> map) ;

	 /**
	  * 반환관리 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000801_delete (Map<String, String> map) ;
	 
	 public void epce9000801_delete2 (Map<String, String> map) ;

	 /**
	  * 반환관리 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000801_update (Map<String, String> map) ;
	 
	 /**
	  * 반환관리 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epce9000801_update2 (Map<String, String> map) ;

	 /**
	  * 반환내역서 상세조회 공급 부분
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000864_select (Map<String, String> map) ;

	 /**
	  * 반환내역서 상세조회 그리드쪽
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce9000864_select2 (Map<String, String> map) ;
	 
	 /**
	  * 적용기간
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> period_list(Map<String, String> inputMap) ;

	public HashMap<?, ?> epce9000842_select(Map<String, String> map) ;
	
	public void epce9000831_update(HashMap<String, String> data) ;
	
	/**
	  * 소모품단가관리
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce90008011_select (Map<String, String> map) ;
	 
	 
	 /**
	  * 소모품단가관리 적용기간 시작날짜 끝날짜 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce900080131_select3 (Map<String, String> map) ;

	 
	 /**
	  * 소모품단가관리 저장 및 수정 시 중복 적용기간조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce900080131_select (Map<String, String> map) ;
	 
	 /**
	  * 소모품단가관리 등록순번
	  * @param map
	  * @return
	  * @
	  */
	 public String epce900080131_select2 (Map<String, String> map) ;

	 /**
	  * 소모품단가관리등록
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce900080131_insert(Map<String, String> map) ;

	 
	 /**
	  * 소모품 공금단가 수정 
	  * @param map
	  * @return
	  * @
	  */
	 public void  epce900080142_update(Map<String, String> map) ;
	 
	 
	 /**
	  * 공금단가 삭제여부 조회
	  * @param map
	  * @return
	  * @
	  */
	 public int epce90008011_select2 (Map<String, String> map) ;

	 
	 /**
	  * 공금단가 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epce90008011_delete (Map<String, String> map) ;
	 
	 
}
