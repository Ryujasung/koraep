package egovframework.mapper.cms;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 회원가입 Mapper
 * @author Administrator
 *
 */

@Mapper("cmscs001Mapper")
public interface CMSCS001Mapper {

	/**
	 * 사업자번호 확인
	 * @return
	 * @
	 */
	public List<?> cmscs001_select(Map<String, String> data);
	
}



