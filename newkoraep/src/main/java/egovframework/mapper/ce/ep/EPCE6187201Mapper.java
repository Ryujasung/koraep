package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 기간별 대비 현황 Mapper
 * @author 이근표
 *
 */
@Mapper("epce6187201Mapper")
public interface EPCE6187201Mapper {  
	
	 /**
	  * 기간별 대비 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6187201_select(Map<String, String> map) ;
	 
	 public HashMap<?, ?> epce6187201_select1(Map<String, String> inputMap);
}
