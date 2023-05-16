/**
 * 
 */
package egovframework.koraep.filter;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import egovframework.common.UserSessionManager;
import egovframework.koraep.ce.dto.UserVO;

/**
 * @author Administrator
 *
 */
public class KoraFilter implements Filter {

	private FilterConfig config;
	
	/* (non-Javadoc)
	 * @see javax.servlet.Filter#destroy()
	 */
	@Override
	public void destroy() {
		// TODO Auto-generated method stub

	}

	/* (non-Javadoc)
	 * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
	 */
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		
		//로그인 처리 필터링
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;

/*	
		try {
			StringBuffer sb = new StringBuffer();
		    Enumeration eNames = req.getParameterNames();
			
			if (eNames.hasMoreElements()) {
				
				System.out.println("======================= doFilter =======================");
				
				while (eNames.hasMoreElements()) {
					String name = (String) eNames.nextElement();
					String[] values = req.getParameterValues(name);
					
					if (values.length > 0) {
						String value = values[0];
						for (int i = 1; i < values.length; i++) {
							value += "," + values[i];
							System.out.println("value : ["+values[i]+"]");
						}
						
						sb.append(name);
						
						if(!("").equals(value)){
							sb.append(":");
							sb.append(value);
						}
						
						System.out.println("request : ["+name+"]:["+value+"],") ;
					}
				}
				
				System.out.println("======================= doFilter =======================");
				
			}
		}
		catch (Exception e) {
	        System.out.println("[GODCOM] request err");
		}
*/		
//		System.out.println("korafilter");
		System.out.println("doFilter :: " + req.getRequestURI().toUpperCase());
		String reqUrl = req.getRequestURI().toUpperCase();
		
		boolean flag = false;
		String sendUrl = "/login.do";		//"/MAIN.do";
		HttpSession session = req.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");

		if(reqUrl.indexOf("EPCE00") > -1 || reqUrl.indexOf("EPCE87") > -1 || reqUrl.indexOf("/EP/") > -1 
				|| reqUrl.indexOf("/MAIN/APP_INFO") > -1 || reqUrl.indexOf("/MBL_LOGIN") > -1 || reqUrl.indexOf("/MAIN/APP_IMG_SAVE") > -1
				|| reqUrl.indexOf("USER_LOGIN_CHECK") > -1 || reqUrl.indexOf("USER_LOGOUT") > -1
				|| reqUrl.indexOf("SAMPLE") > -1 || reqUrl.indexOf("ZIPCODE") > -1 || reqUrl.indexOf("API") > -1
				|| reqUrl.indexOf("SELECT_USER_MENU_LIST") > -1 || reqUrl.indexOf("MAGICSSO") > -1 
				|| reqUrl.indexOf("SSO_LOGIN") > -1 || reqUrl.indexOf("POPUP") > -1 || reqUrl.indexOf("VESTCERTSETUP") > -1
				|| reqUrl.indexOf("ERROR") > -1 || reqUrl.indexOf("LOGIN") > -1 || reqUrl.indexOf("_M") > -1
				|| reqUrl.indexOf("/JSP/TERMS.JSP") > -1 || reqUrl.indexOf("/JSP/PRIVACY") > -1){
			flag = true;
			//System.out.println("GODCOM : 1" + flag);
		}else{
			//flag = true;
			
			//System.out.println("GODCOM : 2" + flag);
			UserSessionManager usm = UserSessionManager.getInstance();
			if(vo != null && !vo.getUSER_ID().equals("") && usm.isUsing(session.getId())){
				flag = true;
				//System.out.println("GODCOM : 3" + flag);
				//권한메뉴 체크 - get인경우만 체크, 마이메뉴에 들어가는 것은 제외
				String method = req.getMethod();
				if(method.toUpperCase().equals("GET")){
					//System.out.println("GODCOM : 4" + flag);
					flag = this.chkMenuAuth(vo.getUSER_MENU_LIST(), reqUrl);
					flag = true;
				}
				
			}else{
				//System.out.println("GODCOM : 5" + flag);
				session.invalidate();	//세션이 없거나 다른 접속이 있으면 강제 종료
			}
		}
		
		if(flag){
			//System.out.println("GODCOM : 6" + flag);
			chain.doFilter(new XSSRequestWrapper((HttpServletRequest)request), response);
			//chain.doFilter(new HTMLTagFilterRequestWrapper((HttpServletRequest)request), response);

		}else{
			//System.out.println("GODCOM : 7" + flag);
			if(reqUrl.indexOf("POP") > -1) sendUrl = "/jsp/closePopup.jsp";
			if(reqUrl.indexOf("EPCE72") > -1) sendUrl = "/MAIN_M.do";	//모바일접속인 경우
			
			if(isAjaxRequest(req)){
				//System.out.println("GODCOM : 8" + flag);
				//System.out.println("ajax=============" + HttpServletResponse.SC_UNAUTHORIZED);
				res.sendError(HttpServletResponse.SC_UNAUTHORIZED);
			}else{
				//((HttpServletRequest)request).setAttribute("message", "메뉴에 대한 접근권한이 존재하지 않습니다.");
				//RequestDispatcher dispatcher = req.getRequestDispatcher(sendUrl);
				//dispatcher.forward(request, response);
				//System.out.println("GODCOM : 9" + flag);
				res.sendRedirect(sendUrl);
			}
		}

	}

	/* (non-Javadoc)
	 * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
	 */
	@Override
	public void init(FilterConfig config) throws ServletException {
		this.config = config;

	}
	
	/**
	 * ajax호출 여부
	 * @param req
	 * @return
	 */
	private boolean isAjaxRequest(HttpServletRequest req) {
        return req.getHeader("AJAX") != null && req.getHeader("AJAX").equals(Boolean.TRUE.toString());
	}
	
	/**
	 * 메뉴 접근권한 체크
	 * @param list
	 * @param url
	 * @return
	 */
	public boolean chkMenuAuth(List<?> list, String url){
		
		if(url.indexOf("CLIPREPORT") > -1 || url.indexOf("EPCE55") > -1
				|| url.indexOf("ALERT") > -1 || url.indexOf("ERROR") > -1
				|| url.indexOf("HTML") > -1 || url.equals("") 
				|| url.indexOf("POP") > -1 || url.indexOf("MAIN") > -1 ){
			return true;
		}
		
		if(list == null || list.size() == 0) return false;
		
		if(url.lastIndexOf("/") > -1) url = url.substring(url.lastIndexOf("/")+1, url.length());
		if(url.lastIndexOf(".") > -1) url = url.substring(0, url.lastIndexOf("."));
		
		boolean flag = false;
		for(int i=0; i<list.size(); i++){
			HashMap<String, String> map = (HashMap<String, String>)list.get(i);
			String tmpUrl = map.get("MENU_URL").replace(".do", "");
			if(tmpUrl.indexOf(url) < 0) continue;
			flag = true;
			break;
		}
		
		return flag;
	}
}
