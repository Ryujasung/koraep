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
import egovframework.mapper.ce.ep.EPCE3989701Mapper;

/**
 * 알림관리 서비스
 * @author Administrator
 *
 */
@Service("epce3989701Service")
public class EPCE3989701Service {

	@Resource(name="epce3989701Mapper")
	private EPCE3989701Mapper epce3989701Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3989701_select(ModelMap model) {

		List<?> ancSeList = commonceService.getCommonCdListNew("S019");//알림대상

		try {
			model.addAttribute("ancSeList", util.mapToJson(ancSeList));
			model.addAttribute("searchList", util.mapToJson(epce3989701Mapper.epce3989701_select()));
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return model;
	}
	
	/**
	 * 알림관리 사용여부 수정
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce3989701_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		try {
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			String ssUserId = "";
			
			if(vo != null){
				ssUserId = vo.getUSER_ID();
			}
			
			for(String key : data.keySet() ){
				if(data.get(key).equals("Y") || data.get(key).equals("N")){
					Map<String, String> map = new HashMap<String, String>();
					map.put("ANC_STD_CD", key);
					map.put("ANC_USE_YN", data.get(key));
					map.put("S_USER_ID", ssUserId);
					epce3989701Mapper.epce3989701_update(map);	//수정처리
				}
			}
			
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	/**
	 * 알림관리 메세지 등록
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce3989701_insert(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		try {
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			
			data.put("S_USER_ID", "");
			if(vo != null){
				data.put("S_USER_ID", vo.getUSER_ID());
			}
			
			//알림코드 채번
			String ancStdCd = epce3989701Mapper.epce3989701_select2(data);
			data.put("ANC_STD_CD", ancStdCd);
			
			data.put("LK_INFO", "5589775.do?ANC_STD_CD="+ancStdCd); //url
			
			epce3989701Mapper.epce3989701_insert(data);
			epce3989701Mapper.epce3989701_insert2(data);

		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3989775_select(ModelMap model, HttpServletRequest request, HashMap<String, String> data) {

		try {
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			if(vo != null){ //로그인 생산자 
				data.put("USER_ID", vo.getUSER_ID());
			}
			
			if(!data.containsKey("ANC_STD_CD")){
				data.put("ANC_STD_CD", "");
			}
			
			model.addAttribute("searchList", util.mapToJson(epce3989701Mapper.epce3989775_select(data)));
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return model;
	}
	
	/**
	 * 공지알림이력조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3989776_select(ModelMap model, HttpServletRequest request, HashMap<String, String> data) {

		try {
			List<?> lk_api_cd_sel = commonceService.getCommonCdListNew("S020");
			model.addAttribute("lk_api_cd_sel", util.mapToJson(lk_api_cd_sel));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return model;
	}
	
	/**
	 * 공지알림이력조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce5589776_selectList(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	if(!inputMap.containsKey("ANC_STD_CD")){
    		inputMap.put("ANC_STD_CD", "");
		}
    	if(!"".equals(inputMap.get("START_DT"))){
    		inputMap.put("START_DT", inputMap.get("START_DT").replace("-", ""));
		}  

		if(!"".equals(inputMap.get("END_DT"))){
			inputMap.put("END_DT", inputMap.get("END_DT").replace("-", ""));
		} 

    	try {
			rtnMap.put("execHistList", util.mapToJson(epce3989701Mapper.epce3989776_select(inputMap)));
			rtnMap.put("totalCnt", epce3989701Mapper.epce3989776_select_cnt(inputMap));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}    
    	
		return rtnMap;
    }
	
}
