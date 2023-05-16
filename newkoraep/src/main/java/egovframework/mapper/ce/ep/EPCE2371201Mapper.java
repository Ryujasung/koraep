package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 취급수수료고지서 Mapper
 * @author Administrator
 *
 */

@Mapper("epce2371201Mapper")
public interface EPCE2371201Mapper {
	
	/**
	 * 구분 조회
	 * @return
	 * @
	 */
	public List<?> epce2371201_select() ;
	
	/**
	 * 취급수수료고지서 조회
	 * @return
	 * @
	 */
	public List<?> epce2371201_select2(Map<String, String> data) ;

	
	/**
	 * 고지서 마스터 등록
	 * @param map
	 * @
	 */
	 public int epce2371201_insert(Map<String, String> map) ; 
	 
	/**
	 * 고지서 상세 등록
	 * @param map
	 * @
	 */
	 public int epce2371201_insert2(Map<String, String> map) ;
	 
	 /**
	 * 잔액 인서트
	 * @param map
	 * @
	 */
	 public int epce2371201_insert3(Map<String, String> map) ;
	 
	 /**
	 * 취급수수료 체크 조회
	 * @param map
	 * @
	 */
	 public Map<String, String> epce2371201_select3(Map<String, String> map) ;
	 
	 /**
	 * 입고 및 반환 마스터 상태 변경
	 * @param map
	 * @
	 */
	 public int epce2371201_update(Map<String, String> map) ;
	 
	 /**
	 * 고지서마스터 합계 업데이트
	 * @param map
	 * @
	 */
	 public int epce2371201_update2(Map<String, String> map) ;
}



