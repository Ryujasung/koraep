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
@Mapper("EPWH9000101Mapper")
public interface EPWH9000101Mapper {
	  
	 
	 /**
	  * 회수정보관리 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> EPWH9000101_select (Map<String, Object> map) ;
	   
	 /**
	  * 회수정보관리 조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> EPWH9000101_select_cnt (Map<String, Object> map) ;
	 
	 /**
	  * 회수정보관리 회수량
	  * @param map
	  * @return
	  * @
	  */
	 public List<?>  EPWH9000101_select2 (Map<String, Object> map) ;
	 
	 /**
	  * 회수정보저장 중복체크   
	  * @param map
	  * @return
	  * @     
	  */
	 public int EPWH9000131_chk (Map<String, String> map);   
	 
	 
	 /**
	  * 회수정보관리 상태값 체크
	  * @param map
	  * @return
	  * @
	  */
	 public int EPWH9000101_select3 (Map<String, String> map) ;
	 
	 public List<?> pbox_bizr_select(Map<String, String> inputMap) ;
	 /**
	  * 회수정보관리 회수등록구분
	  * @param map
	  * @return
	  * @
	  */
	 public String EPWH9000101_select4 (Map<String, String> map) ;
	 
	 
	 /**
	  * 회수정보관리 회수등록일괄확인
	  * @param map
	  * @return
	  * @
	  */
	 public void EPWH9000101_update (Map<String, String> map) ;
	 
	 /**
	  * 회수정보관리 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void EPWH9000101_delete (Map<String, String> map) ;
	 
  /***********************************************************************************************************************************************
  *	회수정보 등록
  ************************************************************************************************************************************************/
	 
	    
	 /**
	  * 회수정보저장  소매거래처 조회
	  * @param map
	  * @return
	  * @       
	  */    
	 public HashMap<String, String> EPWH9000131_select (Map<String, String> map);
	 
	 /**
	  * 회수정보저장 중복체크   
	  * @param map
	  * @return
	  * @     
	  */
	 public int EPWH9000131_select2 (Map<String, String> map);   
	        
	 /**
	  * 회수정보저장  도매업자 지점아이디 조회
	  * @param map
	  * @return
	  * @  
	  */
	 public HashMap<String, String> EPWH9000131_select3 (Map<String, String> map);
	    
	 /**
	  * 회수정보저장 엑셀등록 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> EPWH9000131_select4 (Map<String, String> map);
	 
	 /**
	  * 소매 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> EPWH9000131_select5 (Map<String, String> map);
	 
	 /**
	  * 회수정보저장 마스터 등록
	  * @param map
	  * @return
	  * @
	  */
	 public void EPWH9000131_insert (Map<String, String> map) ;
	 
	 /**
	  * 회수정보저장 상세 등록 
	  * @param map
	  * @return
	  * @
	  */
	 public void EPWH9000131_insert2 (Map<String, String> map) ;
	 
	 /**
	  * 회수정보저장 상세 등록 
	  * @param map
	  * @return
	  * @
	  */
	 public void EPWH9000142_update (Map<String, String> map) ;
	 
	 /**
	  * 회수정보저장 마스터 update
	  * @param map
	  * @return
	  * @
	  */
	 
  /***********************************************************************************************************************************************
  *	회수정보 수정
  ************************************************************************************************************************************************/
	 
	 /**
	  * 회수정보수정 그리드 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> EPWH9000142_select (Map<String, String> map);
	 
 
	 /**
	  * 회수정보수정 info 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void EPWH9000142_delete (Map<String, String> map);

  /***********************************************************************************************************************************************
  *	회수정보 조정
  ************************************************************************************************************************************************/
	 
	 /**
	  * 회수조정 마스터 상태변경
	  * @param map
	  * @return
	  * @
	  */
	 public void EPWH90001422_update (Map<String, String> map);
	 
 /***********************************************************************************************************************************************
  *회수증빙자료관리
  ************************************************************************************************************************************************/
	 /**
	  * 회수정보수정 그리드 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> EPWH9000197_select (Map<String, Object> map);

	 /**
	  * 회수증빙자료 삭제
	  * @param map
	  * @return
	  * @
	  */
	 public void EPWH9000197_delete (Map<String, String> map);
	 
	 
 /***********************************************************************************************************************************************
  *회수증빙자료관리 저장
  ************************************************************************************************************************************************/
	 
	 /**
	  * 회수증빙자료관리 저장
	  * @param map
	  * @return
	  * @
	  */
	 public void EPWH9000188_insert (Map<String, String> map);

	public Long epCE9000131_SN(String doc_no);


	public void EPWH9000131_update(Map<String, Object> cntmap);


	public HashMap<String, String> EPWH9000131_tot(Map<String, String> map);
	 
	 
}
