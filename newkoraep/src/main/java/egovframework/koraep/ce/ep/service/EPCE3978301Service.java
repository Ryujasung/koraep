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
import egovframework.mapper.ce.ep.EPCE3978301Mapper;

/**
 * 메뉴권한관리 서비스
 * @author Administrator
 *
 */
@Service("epce3978301Service")
public class EPCE3978301Service {

	@Resource(name="epce3978301Mapper")
	private EPCE3978301Mapper epce3978301Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3978301_select(ModelMap model, HttpServletRequest request) {
		
		//Map<String, String> map = new HashMap<String, String>();
		List<?> athGrpList = epce3978301Mapper.epce3978301_select(null);
		List<?> menuSetList = commonceService.getCommonCdListNew("M001");//메뉴SET
		List<?> bizrTpList = commonceService.getCommonCdListNew("B001");//사업자유형
	
		try {
			model.addAttribute("athGrpList", util.mapToJson(athGrpList));
			model.addAttribute("menuSetList", util.mapToJson(menuSetList));
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
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

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		return model;
	}
	
	/**
	 * 권한그룹 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce3978301_select2(Map<String, String> data) {
		
		List<?> list = epce3978301Mapper.epce3978301_select2(data);

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
	 * 메뉴 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce3978301_select3(Map<String, String> data) {
		
		List<?> list = epce3978301Mapper.epce3978301_select3(data);

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
	public String epce3978301_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
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
			    			epce3978301Mapper.epce3978301_delete(map);//기존권한 그룹메뉴 모두 삭제
			    		}
			    		
			    		String selected = (map.get("SELECTED") == null)? "": String.valueOf(map.get("SELECTED"));
			    		if(!selected.equals("Y")) continue;
			    		epce3978301Mapper.epce3978301_insert(map);	//등록
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
