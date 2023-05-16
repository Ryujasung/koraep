package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 공지사항 Mapper
 * @author pc
 *
 */
@Mapper("epmf8160601Mapper")
public interface EPMF8160601Mapper {
	
	/**
	 * 설문 마스터 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epmf8160601_select1(Map<String, String> map) ;
	
	
	/**
	 * 설문 마스터 등록/수정
	 * @param map
	 * @
	 */
	public void epmf8160601_update(Map<String, String> map) ;

}
