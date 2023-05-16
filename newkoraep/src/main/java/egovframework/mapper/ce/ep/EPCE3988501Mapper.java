package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 등록일자제한설정 Mapper
 * @author 양성수
 *
 */
@Mapper("epce3988501Mapper")
public interface EPCE3988501Mapper {
	 
	 /**
	  * 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce3988501_select ();   
	 
	 /**
	  *  저장 및 수정
	  * @param map
	  * @return
	  * @
	  */
	 public void epce3988501_insert (Map<String, String> map) ;

}
