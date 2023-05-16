package egovframework.koraep.wh.ep.service;

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
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.wh.ep.EPWH0129801Mapper;

/**
 * 부서관리 서비스
 * @author Administrator
 *
 */
@Service("epwh0129801Service")
public class EPWH0129801Service {

	@Resource(name="epwh0129801Mapper")
	private EPWH0129801Mapper epwh0129801Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epwh0129801_select(ModelMap model, HttpServletRequest request) {
		
		List<?> dept_se_sel = commonceService.getCommonCdListNew("S007");//부서구분,표준여부
		List<?> bizr_tp_cd_sel = commonceService.getCommonCdListNew("B001");//사업자유형
		
		try {
			model.addAttribute("dept_se_sel", util.mapToJson(dept_se_sel));
			model.addAttribute("bizr_tp_cd_sel", util.mapToJson(bizr_tp_cd_sel));
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
	 * 부서관리 메뉴 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epwh0129801_select2(Map<String, String> data, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		if(vo != null){ //로그인 생산자 
			data.put("BIZRID", vo.getBIZRID());
			data.put("BIZRNO", vo.getBIZRNO_ORI());
		}
		
		List<?> menuList = epwh0129801Mapper.epwh0129801_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
			map.put("totalCnt", epwh0129801Mapper.epwh0129801_select_cnt(data));
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
	public ModelMap epwh0129831_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPWH0129831");
		model.addAttribute("titleSub", title);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		return model;
	}
	
	/**
	 * 업체명 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epwh0129831_select2(Map<String, String> data) {
		
		List<?> bizrNm = epwh0129801Mapper.epwh0129831_select2(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("bizrNm", util.mapToJson(bizrNm));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
	}
	
	/**
	 * 상위부서코드 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epwh0129831_select3(Map<String, String> data, HttpServletRequest request) {
		

		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");

		if(vo != null){
			data.put("BIZRID", vo.getBIZRID());
			data.put("BIZRNO", vo.getBIZRNO_ORI());
		}else{
			data.put("BIZRID", "");
			data.put("BIZRNO", "");
		}
		

		List<?> searchList = epwh0129801Mapper.epwh0129831_select3(data);
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(searchList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
	}
	
	/**
	 * 변경화면 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epwh0129842_select(ModelMap model, HttpServletRequest request) {
		
			String title = commonceService.getMenuTitle("EPWH0129842");
			model.addAttribute("titleSub", title);
			
			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"), "{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS", jParams);
			
			//상세조회
			HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
			model.addAttribute("searchDtl", util.mapToJson(epwh0129801Mapper.epwh0129842_select(map)));
			
			//상위부서 조회
			try {
				model.addAttribute("upDeptCdList", util.mapToJson(epwh0129801Mapper.epwh0129831_select3(map)));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}
			
			return model;
	}
	
	/**
	 * 부서관리 등록
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epwh0129831_insert(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}
				
		
				if(vo != null){
					data.put("BIZRID", vo.getBIZRID());
					data.put("BIZRNO", vo.getBIZRNO_ORI());
				}
				
				data.put("STD_YN", "N");
				
				
				if(!data.containsKey("UP_DEPT_CD")){
					data.put("UP_DEPT_CD", "");
					data.put("UP_STD_YN", "");
				}else{
					String[] UP_DEPT_CD = data.get("UP_DEPT_CD").split(";");
					data.put("UP_DEPT_CD", UP_DEPT_CD[0]);
					data.put("UP_STD_YN", UP_DEPT_CD[1]);
				}
				
				epwh0129801Mapper.epwh0129831_insert(data);	//등록 처리
				
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	/**
	 * 부서관리 변경
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epwh0129842_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}
				
				if(!data.containsKey("UP_DEPT_CD")){
					data.put("UP_DEPT_CD", "");
					data.put("UP_STD_YN", "");
				}else{
					String[] UP_DEPT_CD = data.get("UP_DEPT_CD").split(";");
					data.put("UP_DEPT_CD", UP_DEPT_CD[0]);
					data.put("UP_STD_YN", UP_DEPT_CD[1]);
				}
				
				epwh0129801Mapper.epwh0129842_update(data);	//수정 처리
				
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	/**
	 * 활동상태 변경
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epwh0129801_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		Map<String, String> map;
		String ssUserId  = "";   //사용자ID
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
				
				List<?> list = JSONArray.fromObject(data.get("list"));
				String execStatCd = data.get("exec_stat_cd");
				for(int i=0; i<list.size(); i++) {
					map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					map.put("EXEC_STAT_CD", execStatCd);
					
					epwh0129801Mapper.epwh0129801_update(map);	//수정 처리
					
				}
				
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
}

	
	

