package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 보증금고지서 Mapper
 * @author Administrator
 *
 */

@Mapper("epce2351901Mapper")
public interface EPCE2351901Mapper {

	/**
	 * 출고 조회
	 * @return
	 * @
	 */
	public List<?> epce2351901_select(Map<String, String> data) ;
	
	/**
	 * 취급수수료고지서 조회
	 * @return
	 * @
	 */
	public List<?> epce2351901_select2(Map<String, String> data) ;
	
	/**
	 * 직접회수내역 조회
	 * @return
	 * @
	 */
	public List<?> epce2351901_select3(Map<String, String> data) ;
	
	/**
	 * 출고량 체크 조회
	 * @return
	 * @
	 */
	public Map<String, String> epce2351901_select4(Map<String, String> data) ;
	
	/**
	 * 잔액 조회
	 * @return
	 * @
	 */
	public Map<String, String> epce2351901_select5(Map<String, String> data) ;
	
	/**
	 * 취급수수료 체크 조회
	 * @return
	 * @
	 */
	public Map<String, String> epce2351901_select6(Map<String, String> data) ;
	
	/**
	 * 직접회수 체크 조회
	 * @return
	 * @
	 */
	public Map<String, String> epce2351901_select7(Map<String, String> data) ;
	
	/**
	 * 고지서 마스터 등록
	 * @param map
	 * @
	 */
	 public int epce2351901_insert(Map<String, String> map) ; 
	 
	/**
	 * 고지서 상세 등록 (출고정보)
	 * @param map
	 * @
	 */
	 public int epce2351901_insert2(Map<String, String> map) ;
	 
	 /**
	 * 출고마스터 상태값 변경
	 * @param map
	 * @
	 */
	 public int epce2351901_update(Map<String, String> map) ;
	 
	 /**
	 * 취급수수료고지서 상태 변경 (추가고지서)
	 * @param map
	 * @
	 */
	 public int epce2351901_update2(Map<String, String> map) ;
	 
	 /**
	 * 직접회수내역 상태 변경
	 * @param map
	 * @
	 */
	 public int epce2351901_update3(Map<String, String> map) ;
	 
	 /**
	 * 고지서 마스터 등록 (추가보증금)
	 * @param map
	 * @
	 */
	 public int epce2351901_insert3(Map<String, String> map) ; 
	 
	 /**
	 * 고지서 상세 등록 (직접회수)
	 * @param map
	 * @
	 */
	 public int epce2351901_insert4(Map<String, String> map) ;
	 
	 /**
	 * 생산자잔액 인터트
	 * @param map
	 * @
	 */
	 public int epce2351901_insert5(Map<String, String> map) ;
	 
	 /**
	 * 잔액 인서트
	 * @param map
	 * @
	 */
	 public int epce2351901_update6(Map<String, String> map) ;
}




