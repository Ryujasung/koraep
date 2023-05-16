package egovframework.mapper.wh.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 공지사항 상세조회 Mapper
 * @author pc
 *
 */
@Mapper("epwh8149093Mapper")
public interface EPWH8149093Mapper {
	
	/**
	 * 공지사항 상세조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8149093_select1(Map<String, String> map) ;
	//SELECT_EPCN_NOTI_INFO
	/**
	 * 공지사항 조회수 증가
	 * @param map
	 * @
	 */
	public void epwh8149093_update(Map<String, String> map) ;
	//UPDATE_EPCN_NOTI_CNT
	/**
	 * 공지사항 이전글 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8149093_select2(Map<String, String> map) ;
	//SELECT_EPCN_NOTI_PRE
	/**
	 * 공지사항 다음글 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8149093_select3(Map<String, String> map) ;
	//SELECT_EPCN_NOTI_NEXT
	/**
	 * 공지사항 첨부파일 조회
	 * @param map
	 * @return
	 * @
	 */
	public List<?> epwh8149093_select4(Map<String, String> map) ;
	//SELECT_EPCN_NOTI_ATCH_FILE_LIST
	/**
	 * 첨부파일 리스트 삭제
	 * @param map
	 * @return
	 * @
	 */
	public int epwh8149093_delete1(Map<String, String> map) ;
	//deleteFileData
	/**
	 * 공지사항 삭제
	 * @param map
	 * @return
	 * @
	 */
	public int epwh8149093_delete2(Map<String, String> map) ;
	//deleteData
}
