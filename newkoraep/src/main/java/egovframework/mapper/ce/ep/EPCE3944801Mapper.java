package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 다국어관리 Mapper
 * @author 양성수
 * 
 */
@Mapper("epce3944801Mapper")
public interface EPCE3944801Mapper {

	
	/**
	 * 다국어관리 용어구분 리스트
	 * @param map
	 * @return
	 * @
	 */
 public List<?>  epce3944801_select(Map<String, String> map) ;
	
 /**
  * 다국어관리 조회
  * @param map
  * @return
  * @
  */
 public List<?>  epce3944801_select2(Map<String, String> map) ;

 
 /**
  * 다국어관리 조회시 입력값이 있을경우 수정 없을경우 저장
  * @param map
  * @return
  * @
  */
 public int  epce3944801_select3(Map<String, String> map) ;
 
 /**
  * 다국어관리 저장
  * @param map
  * @return
  * @
  */
 public void  epce3944801_insert(Map<String, String> map) ;

 /**
  * 다국어관리 수정
  * @param map
  * @return
  * @
  */
 public void  epce3944801_update(Map<String, String> map) ;

}
