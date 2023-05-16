package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 회원가입 Mapper
 * @author Administrator
 *
 */

@Mapper("epce0085201Mapper")
public interface EPCE0085201Mapper {

	/**
	 * 사업자번호 확인
	 * @return
	 * @
	 */
	public List<?> epce00852012_select(Map<String, String> data) ;
	
	/**
	 * 지점조회
	 * @return
	 * @
	 */
	public List<?> epce00852012_select2(Map<String, String> data) ;
	
	/**
	 * 사업자번호 확인
	 * @return
	 * @
	 */
	public List<?> epce00852012_select3(Map<String, String> data) ;
	
	/**
	 * 사업장번호 확인
	 * @return
	 * @
	 */
	public List<?> epce00852012_select4(Map<String, String> data) ;
	
}



