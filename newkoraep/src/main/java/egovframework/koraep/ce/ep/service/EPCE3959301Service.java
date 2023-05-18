/**
 * 
 */
package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE3959301Mapper;

/**
 * 버튼관리 서비스
 * @author Administrator
 *
 */
@Service("epce3959301Service")
public class EPCE3959301Service {

	@Resource(name="epce3959301Mapper")
	private EPCE3959301Mapper epce3959301Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3959301_select(ModelMap model) {
		
		//model.addAttribute("btnList", util.mapToJson(commonceService.getBtnList("EPCE3959301")));
		
		List<?> langSeList = commonceService.getLangSeCdList();
		List<?> menuSetList = commonceService.getCommonCdListNew("M001");//메뉴SET
		List<?> menuGrpList = commonceService.getCommonCdListNew("M002");//메뉴그룹
		List<?> menuSeList = commonceService.getCommonCdListNew("M003");//메뉴구분
		List<?> btnSeList = commonceService.getCommonCdListNew("M004");//버튼구분
		List<?> btnLcSeList = commonceService.getCommonCdListNew("M006");//버튼위치구분

		try {
			model.addAttribute("langSeList", util.mapToJson(langSeList));
			model.addAttribute("menuSetList", util.mapToJson(menuSetList));
			model.addAttribute("menuGrpList", util.mapToJson(menuGrpList));
			model.addAttribute("menuSeList", util.mapToJson(menuSeList));
			model.addAttribute("btnSeList", util.mapToJson(btnSeList));
			model.addAttribute("btnLcSeList", util.mapToJson(btnLcSeList));
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
	 * 메뉴 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce3959301_select2(Map<String, String> data) {
		
		List<?> menuList = epce3959301Mapper.epce3959301_select(data);

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
	 * 버튼 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce3959301_select3(Map<String, String> data) {
		
		List<?> menuList = epce3959301Mapper.epce3959301_select2(data);

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
	 * 버튼 등록/수정
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce3959301_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}
				epce3959301Mapper.epce3959301_update(data);	//등록 수정처리
				
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
	 * 버튼 삭제
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce3959301_update2(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}
				
				epce3959301Mapper.epce3959301_update2(data);	//삭제처리
				
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
