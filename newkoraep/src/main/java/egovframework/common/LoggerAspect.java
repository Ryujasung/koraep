/**
 * 
 */
package egovframework.common;

import java.io.IOException;
import java.net.SocketException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;

/**
 * @author kwon
 *
 */
@Component
@Aspect
public class LoggerAspect {
	
	private static final Logger log = LoggerFactory.getLogger(LoggerAspect.class);
	
	@Autowired
	private CommonCeService service;
	
	@Around("execution(* egovframework..web.*Controller.*(..)) or execution(* egovframework..service.*Service.*(..))")
	public Object logPrint(ProceedingJoinPoint joinPoint) throws Throwable {
		String name = "";
		String type = joinPoint.getSignature().getDeclaringTypeName();
		String method = joinPoint.getSignature().getName();
		Object[] param = joinPoint.getArgs();	//Arrays.toString(joinPoint.getArgs());
		/*
		if (type.indexOf("Controller") > -1) {
			name = "Controller  \t:  ";
		}else if (type.indexOf("Service") > -1) {
			name = "Service  \t:  ";
		}else if (type.indexOf("Mapper") > -1) {
			name = "Mapper  \t\t:  ";
		}
		
		log.debug("args====" + Arrays.toString(param));
		for(int i=0; i<param.length; i++){
			log.debug(param[i].toString());
		}
		*/
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();

		
		MultipartHttpServletRequest mptRequest = null;
//		MultipartHttpServletRequest mptRequest = WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
		/*
		if(request.getContentType() == null || request.getContentType().indexOf("multipart") == -1){
		}else{
			try{
			mptRequest = (MultipartHttpServletRequest)request;
			}catch(Exception e){
				java.lang.ClassCastException: egovframework.koraep.filter.XSSRequestWrapper cannot be cast to org.springframework.web.multipart.MultipartHttpServletRequest
			}
		}
		*/
		
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		
		boolean flag = true;
		String url = request.getRequestURI().toUpperCase();
		if(url.indexOf("SELECT") > - 1 || url.indexOf("LOG") > - 1
				 || url.indexOf("USER") > - 1 || url.indexOf("MAIN") > - 1) flag = false;
		
		url = url.substring(url.lastIndexOf("/")+1);
		String cd = url.substring(0,6);

		String BTN_CD = "";
		
		if(request.getParameter("PARAM_BTN_CD") != null){
			BTN_CD = request.getParameter("PARAM_BTN_CD").toLowerCase();
		//}else if(mptRequest != null && mptRequest.getParameter("PARAM_BTN_CD") != null){
			//BTN_CD = mptRequest.getParameter("PARAM_BTN_CD").toLowerCase();
		}

		try {
			if("".equals(BTN_CD)) {
				if(param.length > 0) {
					HashMap<String, String> map = new HashMap<String, String>();
					map = (HashMap<String, String>)param[0];
					BTN_CD = util.null2void(map.get("PARAM_BTN_CD"));
				}
			}
		}catch (IOException io) {
			io.printStackTrace();
		}catch (SQLException sq) {
			sq.printStackTrace();
		}catch (NullPointerException nu){
			nu.printStackTrace();
		}catch(Exception e){
			BTN_CD = "";
		}

		String MENU_GRP_CD = cd.substring(4);
		String MENU_CD = "";
		
		if(request.getParameter("PARAM_MENU_CD") != null){
			MENU_CD = request.getParameter("PARAM_MENU_CD");
		//}else if(mptRequest != null && mptRequest.getParameter("PARAM_MENU_CD") != null){
			//MENU_CD = mptRequest.getParameter("PARAM_MENU_CD");
		}else if(url.indexOf("_") > -1){
			MENU_CD = url.substring(0, url.indexOf("_"));
		}else{
			MENU_CD = url.substring(0, url.indexOf("."));
		}
		
		if(vo == null || !flag || BTN_CD.equals("")
				|| BTN_CD.indexOf("btn_sel") > -1 
				|| BTN_CD.indexOf("btn_page") > -1
				|| BTN_CD.indexOf("btn") < 0){
			return joinPoint.proceed();
		}
		
		String USER_ID = vo.getUSER_ID();
		/*
		Enumeration enm = request.getParameterNames();
		while(enm.hasMoreElements()){
			String key = (String)enm.nextElement();
			Object val = request.getParameter(key);
			//log.debug(key + "===" + val.toString());
			
			if(key.equals("BTN_CD")){
				BTN_CD = val.toString();
			}else if(key.equals("MENU_GRP_CD")){
				MENU_GRP_CD = val.toString();
			}else if(key.equals("MENU_CD")){
				MENU_CD = val.toString();
			}
		}
		*/
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("USER_ID", USER_ID);
		map.put("MENU_GRP_CD", MENU_GRP_CD);
		map.put("MENU_CD", MENU_CD);
		map.put("BTN_CD", BTN_CD);
		map.put("PRAM", Arrays.toString(param));
		map.put("ACSS_IP", request.getRemoteAddr());
		
		service.insertExecHist(map);
		//log.debug("=======================aspect logger===============================");
		//log.debug(name + type + "." + joinPoint.getSignature().getName() + "()");
		
		return joinPoint.proceed();
	}
	
}
