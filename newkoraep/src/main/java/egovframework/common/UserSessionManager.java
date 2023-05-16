/**
 * 
 */
package egovframework.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Administrator
 *
 */
public class UserSessionManager implements HttpSessionBindingListener {
	private static UserSessionManager loginManager = null;
	private static final Logger log = LoggerFactory.getLogger(UserSessionManager.class);
	private static List<HashMap<String, String>> sessionUserList = new ArrayList<HashMap<String, String>>();
	
	public UserSessionManager(){
		super();
	}
	
	/**
	 * 싱글톤 처리
	 * @return
	 */
	public static synchronized UserSessionManager getInstance(){
		if(loginManager == null){
			loginManager = new UserSessionManager();
		}
		return loginManager;
	}
	
	

	@Override
	public void valueBound(HttpSessionBindingEvent event){
		//log.debug(event.getName());
		log.debug("==============valueBound 호출안된다 TT;;;=====================");
	}
	
	@Override
	public void valueUnbound(HttpSessionBindingEvent event){
		//log.debug(event.getName());
		log.debug("==============valueUnbound 호출안된다 TT;;;=====================");
	}
	
	/**
	 * 세션정보 추가
	 * @param sessionId
	 * @param userId
	 */
	public void addSession(String sessionId, String userId){
		//log.debug("addSession=================" + sessionId);
		HashMap<String, String> map = new HashMap<String, String>();
		map.put(sessionId, userId);
		sessionUserList.add(map);
	}
	
	/**
	 * 세션 아이디로 세션정보 삭제
	 * @param sessionId
	 */
	public void removeSession(String sessionId){
		for(int i=sessionUserList.size()-1; i>=0; i--){
			if(!sessionUserList.get(i).containsKey(sessionId)) continue;
			sessionUserList.remove(i);
		}
	};
	
	
	/**
	 * 실제 사용자 아이디로 세션정보 삭제
	 * @param userId
	 */
	public void removeSessionValue(String userId){
		for(int i=sessionUserList.size()-1; i>=0; i--){
			if(!sessionUserList.get(i).containsValue(userId)) continue;
			sessionUserList.remove(i);
		}
	}
	
	/**
	 * 사용자 아이디 로그인 중인지 여부
	 * @param userId
	 * @return
	 */
	public boolean isUsingValue(String userId){
		boolean flag = false;
		for(int i=0; i<sessionUserList.size(); i++){
			if(!sessionUserList.get(i).containsValue(userId)) continue;
			flag = true;
			break;
		}
		return flag;
	};
	
	/**
	 * 세션아이디로 사용중인지 확인
	 * @param sessionId
	 * @return
	 */
	public boolean isUsing(String sessionId){
		//log.debug("isUsing=================" + sessionId);
		boolean flag = false;
		for(int i=0; i<sessionUserList.size(); i++){
			HashMap<String, String> map = sessionUserList.get(i);

			if(!map.containsKey(sessionId)) continue;
			
			flag = true;
			break;
		}
		
		return flag;
	};

}
