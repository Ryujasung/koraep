/**
 * 
 */
package egovframework.common;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.UncategorizedDataAccessException;
import org.springframework.jdbc.UncategorizedSQLException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.transaction.TransactionException;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.rte.fdl.cmmn.exception.EgovBizException;

/**
 * @author kwon
 *
 */

@EnableWebMvc
@ControllerAdvice
public class KoraExceptionController {

	private static final Logger log = LoggerFactory.getLogger(KoraExceptionController.class);
	
	@Autowired
	private CommonCeService service;
	
	@ExceptionHandler(value = {SQLException.class
			,DataAccessResourceFailureException.class
			,DataIntegrityViolationException.class
			,UncategorizedDataAccessException.class
			,UncategorizedSQLException.class
			,DataAccessException.class
			,TransactionException.class
			,EgovBizException.class
			,Exception.class })
	public String Exception(HttpServletRequest request, Exception e) throws Exception{
		//log.debug("=======KoraExceptionController Exception============");
		//log.debug("name===" + e.getClass().getSimpleName());
		//log.debug("message===" + e.getMessage());
		//log.debug("url===" + request.getRequestURL());
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		if(vo != null){
			String USER_ID = vo.getUSER_ID();
			
			String MENU_GRP_CD = "";
			String MENU_CD = "";
			String BTN_CD = "";
			String ERR_CD = "";
			String ERR_MSG = "";
			String ACPT_ERR = (e.getMessage() == null) ? "" : e.getMessage().toString();
			if(ACPT_ERR.length() > 450) ACPT_ERR = ACPT_ERR.substring(0, 450);
			Map<String, Object> PRAM = request.getParameterMap();
			String ACSS_IP = request.getRemoteAddr();
			
			
			boolean flag = true;
			String url = request.getRequestURI().toUpperCase();
			if(url.indexOf("SELECT") > - 1 || url.indexOf("LOG") > - 1
					 || url.indexOf("USER") > - 1 || url.indexOf("MAIN") > - 1) flag = false;
			
			url = url.substring(url.lastIndexOf("/")+1);
			String cd = url.substring(0,6);
			if(flag){
				BTN_CD = (null == request.getParameter("PARAM_BTN_CD")) ? "" : request.getParameter("PARAM_BTN_CD");
				MENU_GRP_CD = cd.substring(4);
				if(url.indexOf("_") > -1){
					MENU_CD = url.substring(0, url.indexOf("_"));
				}else{
					MENU_CD = url.substring(0, url.indexOf("."));
				}
			}
			/*
			Enumeration enm = request.getParameterNames();
			while(enm.hasMoreElements()){
				String key = (String)enm.nextElement();
				Object val = request.getParameter(key);
				PRAM = PRAM + "|" + val.toString();
				
				if(key.equals("MENU_GRP_CD")){
					MENU_GRP_CD = val.toString();
				}else if(key.equals("MENU_CD")){
					MENU_CD = val.toString();
				}else if(key.equals("BTN_CD")){
					BTN_CD = val.toString();
				}
			}
			*/
			
			if(e instanceof DataAccessResourceFailureException){
				ERR_CD = "E004";
			}else if(e instanceof DataIntegrityViolationException){
				ERR_CD = "E005";
			}else if(e instanceof UncategorizedDataAccessException){
				ERR_CD = "E006";
			}else if(e instanceof UncategorizedSQLException){
				ERR_CD = "E002";
			}else if(e instanceof DataAccessException){
				ERR_CD = "E003";
			}else if(e instanceof SQLException){
				ERR_CD = "E001";
			}else if(e instanceof TransactionException){
				ERR_CD = "E007";
			}else if(e instanceof EgovBizException){
				ERR_CD = "E008";
			}else{
				ERR_CD = "E099";
			}
			ERR_MSG = service.getErrorMsg("A", ERR_CD);
			
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("USER_ID", USER_ID);
			map.put("MENU_GRP_CD", MENU_GRP_CD);
			map.put("MENU_CD", MENU_CD);
			map.put("BTN_CD", BTN_CD);
			map.put("ERR_CD", ERR_CD);
			map.put("ERR_MSG", ERR_MSG);
			map.put("ACPT_ERR", ACPT_ERR);
			map.put("PRAM", JSONObject.fromObject(PRAM).toString());
			map.put("ACSS_IP", ACSS_IP);
			service.insertErrHist(map);
		}
		
		ModelMap model = new ModelMap();
		model.addAttribute("name", e.getClass().getSimpleName());
		model.addAttribute("message", e.getMessage());
		model.addAttribute("msg", e.getClass().getSimpleName());
		model.addAttribute("url", request.getRequestURL());

		return "/common/error";
	}
	
	
	
	@ExceptionHandler(value = {AuthenticationException.class
			,AccessDeniedException.class })
	public String AccessDeny(HttpServletRequest req, Exception e) throws Exception{
		log.debug("=======KoraExceptionController AccessDeny============");
		return "login";
	}
	
}
