package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 신구병 통계현황 Mapper
 * @author 이내희
 *
 */
@Mapper("epce6172401Mapper")
public interface EPCE6172401Mapper {  
	
	/**
	 * 신구병 통계현황 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epce6172401_select(Map<String, String> data) ;
	
	/**
	 * 신구병 통계현황 리스트 카운트
	 * @return
	 * @
	 */
	public List<?> epce6172401_select_cnt(Map<String, String> data) ;
	
	/**
	 * 신구병 통계현황 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epce61724012_select(Map<String, String> data) ;

	/**
	 * 신구병 통계현황 상세조회
	 * @return
	 * @
	 */
	 public HashMap<?, ?> epce6172442_select(Map<String, String> data) ;
	 
	 /**
	 * 상세정보 수정
	 * @return
	 * @
	 */
	 public void epce6172442_update(Map<String, String> data) ;
	 
	 /**
	 * 반환량조정 수정
	 * @return
	 * @
	 */
	 public void epce6172488_update(Map<String, String> data) ;
		
}
