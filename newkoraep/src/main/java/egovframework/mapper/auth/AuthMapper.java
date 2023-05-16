/**
 * 
 */
package egovframework.mapper.auth;

import java.util.HashMap;

import egovframework.koraep.ce.dto.UserVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * @author kwon
 *
 */

@Mapper("authMapper")
public interface AuthMapper {

	/**
	 * login check 용
	 * @param map
	 * @return
	 */
	public UserVO selectAuthCheckInfo(HashMap<String, String> map);
	
}
