package egovframework.mapper.wh.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 회수정보관리 Mapper
 * @author 양성수
 *  
 */    
@Mapper("epwh2925801Mapper")
public interface EPWH2925801Mapper {
	  
	 
	 /**
	  * 회수정보관리 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2925801_select (Map<String, Object> map) ;
	   
	 /**
	  * 회수정보관리 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2925801_select_cnt (Map<String, Object> map) ;
	 
	 /**
	  * 회수정보관리 회수량
	  * @param map
	  * @return
	  * @
	  */
	 public List<?>  epwh2925801_select2 (Map<String, Object> map) ;
	 
	 /**
	  * 회수정보관리 상태값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int epwh2925801_select3 (Map<String, String> map) ;
	 
	 /**
	  * 회수정보관리 회수등록구분
	  * @param map
	  * @return
	  * @
	  */
	 public String epwh2925801_select4 (Map<String, String> map) ;
	 
	 
	 /**
	  * 회수정보관리 회수등록일괄확인
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2925801_update (Map<String, String> map) ;
	 
	 /**
	  * 회수정보관리 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2925801_delete (Map<String, String> map) ;
	 
  /***********************************************************************************************************************************************
  *	회수정보 등록
  ************************************************************************************************************************************************/
	 
	    
	 /**
	  * 회수정보저장  소매거래처 조회
	  * @param map
	  * @return
	  * @       
	  */    
	 public HashMap<String, String> epwh2925831_select (Map<String, String> map);
	 
	 /**
	  * 회수정보저장 중복체크   
	  * @param map
	  * @return
	  * @     
	  */
	 public int epwh2925831_select2 (Map<String, String> map);   
	        
	 /**
	  * 회수정보저장  도매업자 지점아이디 조회
	  * @param map
	  * @return
	  * @  
	  */
	 public HashMap<String, String> epwh2925831_select3 (Map<String, String> map);
	    
	 /**
	  * 회수정보저장 엑셀등록 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2925831_select4 (Map<String, String> map);
	 
	 /**
	  * 소매 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2925831_select5 (Map<String, String> map);
	 
	 /**
	  * 회수정보저장 마스터 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2925831_insert (Map<String, String> map) ;
	 
	 /**
	  * 회수정보저장 상세 등록 
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2925831_insert2 (Map<String, String> map) ;
	 
	 /**
	  * 회수정보저장 마스터 update
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2925831_update (Map<String, String> map) ;
	 
  /***********************************************************************************************************************************************
  *	회수정보 수정
  ************************************************************************************************************************************************/
	 
	 /**
	  * 회수정보수정 그리드 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2925842_select (Map<String, String> map);
	 
 
	 /**
	  * 회수정보수정 info 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2925842_delete (Map<String, String> map);

  /***********************************************************************************************************************************************
  *	회수정보 조정
  ************************************************************************************************************************************************/
	 
	 /**
	  * 회수조정 마스터 상태변경
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh29258422_update (Map<String, String> map);
	 
 /***********************************************************************************************************************************************
  *회수증빙자료관리
  ************************************************************************************************************************************************/
	 /**
	  * 회수정보수정 그리드 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epwh2925897_select (Map<String, Object> map);

	 /**
	  * 회수증빙자료 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2925897_delete (Map<String, String> map);
	 
	 
 /***********************************************************************************************************************************************
  *회수증빙자료관리 저장
  ************************************************************************************************************************************************/
	 
	 /**
	  * 회수증빙자료관리 저장
	  * @param map
	  * @return
	  * @
	  */
	 public void epwh2925888_insert (Map<String, String> map);
	 
	 
}
