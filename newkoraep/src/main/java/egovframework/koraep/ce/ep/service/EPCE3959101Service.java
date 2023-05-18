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
import egovframework.mapper.ce.ep.EPCE3959101Mapper;

/**
 * 사업자권한관리 서비스
 * @author Administrator
 *
 */
@Service("epce3959101Service")
public class EPCE3959101Service {

	@Resource(name="epce3959101Mapper")
	private EPCE3959101Mapper epce3959101Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3959101_select(ModelMap model, HttpServletRequest request) {

		List<?> athGrpList = epce3959101Mapper.epce3959101_select();
		
		try {
			model.addAttribute("athGrpList", util.mapToJson(athGrpList));
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
		model.addAttribute("INQ_PARAMS", jParams);

		return model;
	}
	
	/**
	 * 권한목록 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce3959101_select2(Map<String, String> data) {
		
		List<?> menuList = epce3959101Mapper.epce3959101_select2(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
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
	 * 지역권한설정 페이지
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3959131_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE3959131");
		model.addAttribute("titleSub", title);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
		List<?> areaList = epce3959101Mapper.epce3959131_select(map);
		try {
			model.addAttribute("areaList", util.mapToJson(areaList));
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
	 * 소속단체권한설정 페이지
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce39591312_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE39591312");
		model.addAttribute("titleSub", title);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
		List<?> affOgnList = epce3959101Mapper.epce39591312_select(map);
		try {
			model.addAttribute("affOgnList", util.mapToJson(affOgnList));
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
	 * 개별사업자권한설정 페이지
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce39591313_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE39591313");
		model.addAttribute("titleSub", title);
		
		List<?> bizrTpList = commonceService.getCommonCdListNew("B001");//사업자유형
		List<?> areaList = commonceService.getCommonCdListNew("B010");//지역구분
		List<?> affOgnList = commonceService.getCommonCdListNew("B004");//소속단체

		try {
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
			model.addAttribute("areaList", util.mapToJson(areaList));
			model.addAttribute("affOgnList", util.mapToJson(affOgnList));
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
	 * 지점 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce39591313_select2(Map<String, String> data) {
		
		List<?> menuList = epce3959101Mapper.epce39591313_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
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
	 * 지역권한 저장
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce3959131_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				String sUserId = "";
				String bizrAthSe = data.get("BIZR_ATH_SE");

				if(vo != null){
					sUserId = vo.getUSER_ID();
				}
				
				List<?> list = JSONArray.fromObject(data.get("list"));
				if(list != null && list.size() > 0){
					for(int i=0; i<list.size(); i++){
						
						Map<String, String> map = (Map<String, String>)list.get(i);
						
						map.put("S_USER_ID", sUserId);
			    		map.put("BIZR_ATH_SE", bizrAthSe);
			    		
						if(i==0) epce3959101Mapper.epce3959131_delete(map); //해당 구분 전체 삭제 후 인서트

			    		epce3959101Mapper.epce3959131_insert(map);
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
	 * 개별사업자권한 저장
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce3959131_insert(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				String sUserId = "";
				String bizrAthSe = data.get("BIZR_ATH_SE");

				if(vo != null){
					sUserId = vo.getUSER_ID();
				}
				
				List<?> list = JSONArray.fromObject(data.get("list"));
				if(list != null && list.size() > 0){
					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);
			    		
			    		map.put("S_USER_ID", sUserId);
			    		map.put("BIZR_ATH_SE", bizrAthSe); 
			    		
			    		epce3959101Mapper.epce3959131_insert(map);
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
