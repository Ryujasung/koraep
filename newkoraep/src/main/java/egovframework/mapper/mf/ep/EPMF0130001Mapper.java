package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 입고정보생산자ERP대조 Mapper
 * @author 이근표
 *
 */
@Mapper("epmf0130001Mapper")
public interface EPMF0130001Mapper {
	
	
	 /**
	  * 입고정보생산자ERP대조 조회	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf0130001_select (Map<String, String> map) ;
	 
	 
	 /**
	  * 입고정보생산자ERP대조 총 카운트	
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf0130001_select_cnt(Map<String, String> map) ;
}
