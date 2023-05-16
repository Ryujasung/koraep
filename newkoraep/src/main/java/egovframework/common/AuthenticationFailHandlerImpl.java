/**
 * 
 */
package egovframework.common;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

/**
 * @author kwon
 *
 */
public class AuthenticationFailHandlerImpl implements
		AuthenticationFailureHandler {

	private static final Logger log = LoggerFactory.getLogger(AuthenticationFailHandlerImpl.class);
	/* (non-Javadoc)
	 * @see org.springframework.security.web.authentication.AuthenticationFailureHandler#onAuthenticationFailure(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, org.springframework.security.core.AuthenticationException)
	 */
	@Override
	public void onAuthenticationFailure(HttpServletRequest request,
			HttpServletResponse response, AuthenticationException exception)
			throws IOException, ServletException {
		
		//log.debug("AuthenticationException====" + exception.getMessage());
		log.info("onAuthentititi");

		request.getRequestDispatcher("/loginfail.do").forward(request, response);
	}

}
