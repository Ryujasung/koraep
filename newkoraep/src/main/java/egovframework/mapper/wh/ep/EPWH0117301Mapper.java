package egovframework.mapper.wh.ep;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 소매거래처 관리 Mapper
 * @author Administrator
 *
 */

@Mapper("EPWH0117301Mapper")
public interface EPWH0117301Mapper {

	/**
	 * 도매업자 사업자번호 조회
	 * @return
	 * @
	 */
	public String epwh0117342_select(HashMap<String, String> data) ;
	
	/**
	 * 적용대상 조회
	 * @return
	 * @
	 */
	public List<?> epwh0117342_select2(HashMap<String, String> data) ;
	
	/**
	 *  업무설정 적용
	 * @return
	 * @
	 */
	public void epwh0117342_update(HashMap<String, String> data) ;
	
}
