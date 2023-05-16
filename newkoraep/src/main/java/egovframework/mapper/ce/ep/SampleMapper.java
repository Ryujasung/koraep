package egovframework.mapper.ce.ep;


import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 공지사항 Mapper
 * @author pc
 *
 */
@Mapper("sampleMapper")
public interface SampleMapper {
	
	/**
	 * 공지사항 총 게시글 수 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> totalCntList(Map<String, String> map) ;
	
	
	/**
	 * 빈용기명 조회
	 * @param inputMap
	 * @return
	 * @
	 */
	public List<?> SELECT_EPCN_STD_CTNR_CD_LIST(Map<String, String> inputMap) ;
	
	
	/**
	 * 공지사항 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> searchList(Map<String, String> map) ;
	
	/**
	 * 공지사항 첨부파일 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> chkFile(Map<String, String> map) ;

}
