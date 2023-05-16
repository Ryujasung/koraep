package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 공지사항 Mapper
 * @author pc
 *
 */
@Mapper("epce8160601Mapper")
public interface EPCE8160601Mapper {
	
	/**
	 * 설문 마스터 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce8160601_select1(Map<String, String> map) ;
	
	/**
	 * 설문 참여자 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epce81606012_select1(Map<String, String> map) ;
	
	
	/**
	 * 설문 마스터 등록/수정
	 * @param map
	 * @
	 */
	public void epce8160601_update(Map<String, String> map) ;

}
