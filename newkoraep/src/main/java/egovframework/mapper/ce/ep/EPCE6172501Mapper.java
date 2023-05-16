package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


/**
 * 회수대비반환 통계현황 Mapper
 * @author 이근표
 *
 */
@Mapper("epce6172501Mapper")
public interface EPCE6172501Mapper {  
	
	/**
	 * 회수대비반환 통계현황 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epce6172501_select(Map<String, String> data) ;
	
	/**
	 * 회수대비반환 통계현황 리스트 카운트
	 * @return
	 * @
	 */
	public List<?> epce6172501_select_cnt(Map<String, String> data) ;
	
	/**
	 * 회수대비반환 통계현황 상세조회
	 * @return
	 * @
	 */
	public HashMap<?, ?> epce6172542_select(Map<String, String> data) ;
	 
	/**
	 * 상세정보 수정
	 * @return
	 * @
	 */
	public void epce6172542_update(Map<String, String> data) ;
	 
	/**
	 * 반환량조정 수정
	 * @return
	 * @
	 */
	public void epce6172588_update(Map<String, String> data) ;

}
