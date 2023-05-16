package egovframework.mapper.mf.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 생산자ERP입고정보 Mapper
 * @author 유병승
 *
 */
@Mapper("epmf0130201Mapper")
public interface EPMF0130201Mapper {

	 /**
	  * 생산자ERP입고정보 조회
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf0130201_select (Map<String, String> map) ;

	 /**
	  * 생산자ERP입고정보  조회	카운트
	  * @param map
	  * @return
	  * @
	  */
	 public List<?> epmf0130201_select_cnt (Map<String, String> map) ;

	 /**
	 * 생산자ERP입고정보 삭제
	 * @param map
	 * @
	 */
	public void epmf0130201_delete(HashMap<String, String> map) ;

}
