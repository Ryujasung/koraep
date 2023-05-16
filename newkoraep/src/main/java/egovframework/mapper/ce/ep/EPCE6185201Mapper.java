package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 연도별출고회수현황 Mapper
 * @author 양성수
 *
 */
@Mapper("epce6185201Mapper")
public interface EPCE6185201Mapper {  
	
	 /**
	  * 연도별출고회수현황 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6185201_select(Map<String, String> map) ;
	 
	 /**
	  * 연도별출고회수현황 그래프 조회	- 주종별
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6185201_select5(Map<String, String> map) ;
	 
	 /**
	  * 연도별출고회수현황 그래프 조회	- 용도별
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6185201_select6(Map<String, String> map) ;
	 
	 /**
	  * 연도별출고회수현황 그래프 조회	- 주종별
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6185201_select7(Map<String, String> map) ;
	 
	 /**
	  * 연도별출고회수현황 그래프 조회	- 월별
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6185201_select8(Map<String, String> map) ;
	 
	 /**
	  * 연도별출고회수현황 그래프 조회	- 월별 회수율
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6185201_select9(Map<String, String> map) ;
	 
	 /**
	  * 연도별출고회수현황 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6185201_select2(Map<String, String> map) ;
	 
	 /**
	  * 연도별출고회수현황 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6185201_select3(Map<String, String> map) ;
	 
	 /**
	  * 연도별출고회수현황 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6185201_select4(Map<String, String> map) ;


	 /**
	  * 연도별출고회수현황 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epce6185201_select10(Map<String, String> map) ;
}
