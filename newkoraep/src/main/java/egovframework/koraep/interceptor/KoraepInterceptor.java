package egovframework.koraep.interceptor;

import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.mvc.WebContentInterceptor;

import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;

public class KoraepInterceptor extends WebContentInterceptor {

	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException {
//		System.out.println(request.getRequestURI().toUpperCase());
		String url = request.getRequestURI().toUpperCase();
		String tmpUrl = url;
		System.out.println("인셉url"+tmpUrl);
		if(tmpUrl.lastIndexOf("/") > -1){
			tmpUrl = tmpUrl.substring(tmpUrl.lastIndexOf("/")+1, tmpUrl.length());
//			System.out.println("if tmpUrl"+tmpUrl);
		}

		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		
		
		
		
		/*
		if(session.getAttribute("userSession") != null && (vo.getUSER_TEXT_LIST() == null || vo.getUSER_TEXT_LIST().isEmpty()) ){
			try {
				List<?> list = commonceService.selectTextList();
				HashMap<String, String> map = new HashMap<String, String>();
				for(int i=0; i<list.size(); i++){
					HashMap<String, String> listMap = (HashMap<String, String>)list.get(i);
					map.put(listMap.get("LANG_CD"), listMap.get("LANG_NM"));   
				}
				vo.setUSER_TEXT_LIST(map);
				
			} catch (Exception e) {
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}
		}
		*/
		
		/*
		if(tmpUrl.indexOf("PRINT") > -1 || tmpUrl.indexOf("INSERT") > -1
				 || tmpUrl.indexOf("UPDATE") > -1 || tmpUrl.indexOf("DELETE") > -1 || tmpUrl.indexOf("SAVE") > -1){
			
			String menuId = tmpUrl.replace(".DO", "");
			if(tmpUrl.indexOf("_") > -1) menuId = tmpUrl.substring(0, tmpUrl.indexOf("_"));
			
			String userId = "";
			if(session.getAttribute("userSession") != null){
				userId = ((UserVO)session.getAttribute("userSession")).getUSER_ID();
			}
			
			if(userId.equals("")) return true;
			//로그 등록처리
			try {
				insertLog(userId, url, tmpUrl, request.getRemoteAddr(), menuId);
			} catch (Exception e) { 
				log.debug("============로그이력 등록중 오류 발생=============");
			}
		}
		 */
		return true;
	}
	
	public void insertLog(String userId, String url, String chgUrl, String acssIp, String menuId) {
		HashMap<String, String> map = new HashMap<String, String>();
		
		/*
		String sysSe = "A";		//시스템구분 -기타코드테이블(그룹코드: C005) : A: 웹시스템, B: 연계API
		String histPrcsSe = "";	//기타코드테이블(그룹코드: C006) : S:처리,  C:등록, U:수정, D:삭제, P:출력, X:엑셀저장
		if(chgUrl.indexOf("PRINT") > -1){
			histPrcsSe = "P";
		}else if(chgUrl.indexOf("EXCEL") > -1){
			histPrcsSe = "X";
		}else if(chgUrl.indexOf("SAVE") > -1){
			histPrcsSe = "S";
		}else if(chgUrl.indexOf("INSERT") > -1){
			histPrcsSe = "C";
		}else if(chgUrl.indexOf("UPDATE") > -1){
			histPrcsSe = "U";
		}else if(chgUrl.indexOf("DELETE") > -1){
			histPrcsSe = "D";
		}
		*/

		map.put("USER_ID", userId);
		//map.put("SYS_SE", sysSe);
		//map.put("HIST_PRCS_SE", histPrcsSe);
		map.put("MENU_GRP_CD", chgUrl.substring(0, 4));
		map.put("MENU_CD", menuId);
		map.put("LK_API_CD", "");
		map.put("ACSS_IP", acssIp);
		map.put("CALL_URL", url);
		
		commonceService.insertExecHist(map);
	}

}
