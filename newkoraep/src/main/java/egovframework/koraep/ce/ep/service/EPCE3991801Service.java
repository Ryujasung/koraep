package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE3991801Mapper;

/**
 * 버튼권한관리 서비스
 * @author Administrator
 *
 */
@Service("epce3991801Service")
public class EPCE3991801Service {

	@Resource(name="epce3991801Mapper")
	private EPCE3991801Mapper epce3991801Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3991801_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE3991801");
		model.addAttribute("titleSub", title);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		List<?> list = epce3991801Mapper.epce3991801_select(map);
		try {
			model.addAttribute("menuList", util.mapToJson(list));
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 버튼 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce3991801_select2(Map<String, String> data) {
		
		List<?> list = epce3991801Mapper.epce3991801_select2(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
	}
	
	/**
	 * 권한저장
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce3991801_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		String sUserId = "";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				sUserId = vo.getUSER_ID();
				
				List<?> list = JSONArray.fromObject(data.get("list"));
				
				if(list != null && list.size() > 0){
					
					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);
			    		
			    		map.put("S_USER_ID", sUserId);
			    		map.put("ATH_GRP_CD", data.get("ATH_GRP_CD"));
			    		map.put("BIZRID", data.get("BIZRID"));
			    		map.put("BIZRNO", data.get("BIZRNO"));
			    		
			    		if(i == 0){
			    			epce3991801Mapper.epce3991801_delete(map);//기존권한 그룹메뉴 모두 삭제
			    		}
			    		
			    		String selected = (map.get("SELECTED") == null)? "": String.valueOf(map.get("SELECTED"));
			    		if(!selected.equals("Y")) continue;
			    		epce3991801Mapper.epce3991801_insert(map);	//등록
			    	}

				}else{
					errCd = "A007"; //저장할 데이타가 없습니다.
				}
				
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
		
	}
	
	/**
	 * 팝업 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3991888_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE3991888");
		model.addAttribute("titleSub", title);
		
		return model;
	}
	
	/**
	 * 권한목록 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce3991888_select2(Map<String, String> data) {
		
		List<?> list = epce3991801Mapper.epce3991888_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
	}
	
	/**
	 * 버튼권한 일괄저장
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce3991888_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		String sUserId = "";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				sUserId = vo.getUSER_ID();
				
				List<?> list = JSONArray.fromObject(data.get("list"));
				
				if(list != null && list.size() > 0){
					
					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);
			    		
			    		map.put("S_USER_ID", sUserId);
			    		map.put("BTN_CD", data.get("BTN_CD"));
			    		map.put("MENU_CD", data.get("MENU_CD"));
			    		map.put("LANG_SE_CD", data.get("LANG_SE_CD"));
			    		
			    		String selected = (map.get("SELECTED") == null)? "": String.valueOf(map.get("SELECTED"));
			    		if(!selected.equals("Y")) continue;
			    		
			    		if(data.get("BTN_ATH_BTCH_SEL").equals("DEL")){
			    			epce3991801Mapper.epce3991888_delete(map);//제거
			    		}else if(data.get("BTN_ATH_BTCH_SEL").equals("ADD")){
			    			epce3991801Mapper.epce3991888_insert(map);	//부여
			    		}
			    	}

				}else{
					errCd = "A007"; //저장할 데이타가 없습니다.
				}
				
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
		
	}
	
}
