/**
 * 
 */
package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE3960201Mapper;

/**
 * 메뉴관리 서비스
 * @author Administrator
 *
 */
@Service("epce3960201Service")
public class EPCE3960201Service {

	@Resource(name="epce3960201Mapper")
	private EPCE3960201Mapper epce3960201Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3960201_select(ModelMap model) {

		List<?> langSeList = commonceService.getLangSeCdList();
		List<?> menuSetList = commonceService.getCommonCdListNew("M001");//메뉴SET
		List<?> menuGrpList = commonceService.getCommonCdListNew("M002");//메뉴그룹
		List<?> menuSeList = commonceService.getCommonCdListNew("M003");//메뉴구분 M003

		try {
			model.addAttribute("langSeList", util.mapToJson(langSeList));
			model.addAttribute("menuSetList", util.mapToJson(menuSetList));
			model.addAttribute("menuGrpList", util.mapToJson(menuGrpList));
			model.addAttribute("menuSeList", util.mapToJson(menuSeList));
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
	public HashMap<String, Object> epce3960201_select2(Map<String, String> data) {
		
		List<?> menuList = epce3960201Mapper.epce3960201_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
	}
	
	/**
	 * 메뉴체크
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public String epce3960201_select3(Map<String, String> data) {
		
		if(!data.containsKey("UP_MENU_CD")){
			data.put("UP_MENU_CD", "");
		}
		
		HashMap<String, String> menuCheck = epce3960201Mapper.epce3960201_select2(data);

		String errCd = "0000";
		
		if(data.get("GUBUN").equals("reg")){//저장
			
			if(!data.get("MENU_LVL").equals("1") && !menuCheck.get("UP_MENU_YN").equals("Y")){//상위메뉴코드에 해당하는 메뉴코드 존재 여부
				errCd = "M001";
			}else if(menuCheck.get("MENU_LVL_CHECK").equals("N")){ //메뉴레벨은 수정불가... 꼬임
				errCd = "M004";
			}else if(menuCheck.get("MENU_YN").equals("Y")){ //이미 존재하는 메뉴코드는 수정안내
				errCd = "A003";
			}else if(data.get("MENU_LVL").equals("1") && menuCheck.get("MENU_LVL_1").equals("Y")){//1레벨 메뉴 등록시 이미 1레벨 메뉴가 존재하면 등록 불가
				errCd = "M003";
			}
			
		}else if(data.get("GUBUN").equals("del")){//삭제
			
			if(menuCheck.get("LOWER_MENU_YN").equals("Y")){//삭제시 하위메뉴 존재 여부
				errCd = "M002";
			}
			
		}
		
		return errCd;
	}
	
	/**
	 * 상위메뉴코드 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce3960201_select4(Map<String, String> data) {
		
		List<?> menuList = epce3960201Mapper.epce3960201_select3(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
	}
	
	/**
	 * 메뉴 삭제
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce3960201_delete(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";
		
		try {
			
			epce3960201Mapper.epce3960201_delete(data);//메뉴 삭제
			
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	/**
	 * 메뉴 등록/수정
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce3960201_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				data.put("UPD_PRSN_ID", "");
				data.put("REG_PRSN_ID", "");
				if(vo != null){
					data.put("UPD_PRSN_ID", vo.getUSER_ID());
					data.put("REG_PRSN_ID", vo.getUSER_ID());
				}
				
				if(!data.containsKey("UP_MENU_CD")){
					data.put("UP_MENU_CD", "");
				}
				
				epce3960201Mapper.epce3960201_update(data);	//등록 수정처리
				
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	
}
