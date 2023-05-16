package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 공지사항 Mapper
 * @author pc
 *
 */
@Mapper("epwh8160653Mapper")
public interface EPWH8160653Mapper {
	
	/**
	 * 등록설문 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8160653_select1(Map<String, String> map) ;
	
	/**
	 * 선택설문 문항
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8160653_select2(Map<String, String> map) ;
	
	/**
	 * 설문조사 설명 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8160653_select22(Map<String, String> map) ;
	
	/**
	 * 선택설문 참여결과저장
	 * @param param
	 * @
	 */
	public void epwh8160653_insert(Map<String, String> param) ;
	
	
	/**
	 * 선택 설문 참가수
	 * @param map
	 * @return
	 * @
	 */
	public String epwh8160653_select3(Map<String, String> map) ;
	
	
	/**
	 * 문항별/옵션별 참여수
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8160653_select4(Map<String, String> map) ;
	
}
