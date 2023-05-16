/**
 * 
 */
package egovframework.common;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import egovframework.rte.fdl.cmmn.exception.handler.ExceptionHandler;

/**
 * @author kwon
 *
 */
public class EgovServiceExceptionHandler implements ExceptionHandler {

	private static final Logger log = LoggerFactory.getLogger(EgovServiceExceptionHandler.class);
	
	/* (non-Javadoc)
	 * @see egovframework.rte.fdl.cmmn.exception.handler.ExceptionHandler#occur(java.lang.Exception, java.lang.String)
	 */
	@Override
	public void occur(Exception exception, String packageName) {
		// TODO Auto-generated method stub
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		log.debug("================EgovServiceExceptionHandler=========");
	}

}
