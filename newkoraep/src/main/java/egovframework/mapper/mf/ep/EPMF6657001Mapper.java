package egovframework.mapper.mf.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 연간출고회수현황확인서 Mapper
 * @author pc
 *
 */
@Mapper("epmf6657001Mapper")
public interface EPMF6657001Mapper {
	
	/**
	 * 연간출고회수현황확인서 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epmf6657001_select(Map<String, Object> data) ;
	
	/**
	 * 연간출고회수현황확인서 리스트 카운트
	 * @return
	 * @
	 */
	public List<?> epmf6657001_select_cnt(Map<String, Object> data) ;
	

}
