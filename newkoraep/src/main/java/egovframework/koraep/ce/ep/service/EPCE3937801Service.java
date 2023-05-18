package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE3937801Mapper;

/**
 * 권한그룹관리 서비스
 * @author Administrator
 *
 */
@Service("epce3937801Service")
public class EPCE3937801Service {

	@Resource(name="epce3937801Mapper")
	private EPCE3937801Mapper epce3937801Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3937801_select(ModelMap model, HttpServletRequest request) {
		
		List<?> stdYnList = commonceService.getCommonCdListNew("S007");//표준여부
		List<?> menuSetList = commonceService.getCommonCdListNew("M001");//메뉴SET
		List<?> bizrTpList = commonceService.getCommonCdListNew("B001");//사업자유형
		List<?> useYnList = commonceService.getCommonCdListNew("S008");//사용여부
		
		
		try {
			model.addAttribute("stdYnList", util.mapToJson(stdYnList));
			model.addAttribute("menuSetList", util.mapToJson(menuSetList));
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
			model.addAttribute("useYnList", util.mapToJson(useYnList));
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
	public HashMap<String, Object> epce3937801_select2(Map<String, String> data) {
		
		List<?> menuList = epce3937801Mapper.epce3937801_select(data);

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
	 * 등록화면 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3937831_select(ModelMap model, HttpServletRequest request) {
		
		List<?> menuSetList = commonceService.getCommonCdListNew("M001");//메뉴SET
		List<?> bizrTpList = commonceService.getCommonCdListNew("B001");//사업자유형
		List<?> athSeList = commonceService.getCommonCdListNew("S130");//권한구분
		
		try {
			model.addAttribute("menuSetList", util.mapToJson(menuSetList));
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
			model.addAttribute("athSeList", util.mapToJson(athSeList));
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
		
		String title = commonceService.getMenuTitle("EPCE3937831");
		model.addAttribute("titleSub", title);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		return model;
	}
	
	/**
	 * 변경화면 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3937842_select(ModelMap model, HttpServletRequest request) {
		
		List<?> menuSetList = commonceService.getCommonCdListNew("M001");//메뉴SET
		List<?> bizrTpList = commonceService.getCommonCdListNew("B001");//사업자유형
		List<?> athSeList = commonceService.getCommonCdListNew("S130");//권한구분
		
		try {
			model.addAttribute("menuSetList", util.mapToJson(menuSetList));
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
			model.addAttribute("athSeList", util.mapToJson(athSeList));
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
		
		String title = commonceService.getMenuTitle("EPCE3937842");
		model.addAttribute("titleSub", title);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		//상세조회
		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		model.addAttribute("searchDtl", util.mapToJson(epce3937801Mapper.epce3937842_select(map)));

		return model;
	}
	
	/**
	 * 권한그룹 등록
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce3937831_insert(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}
				
				//중복체크
				int chk = epce3937801Mapper.epce3937831_select(data);
				if(chk > 0){
					return "A003";
				}
				
				epce3937801Mapper.epce3937831_insert(data);	//등록 처리
				
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
	 * 권한그룹 변경
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce3937842_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}
				epce3937801Mapper.epce3937842_update(data);	//수정 처리
				
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
