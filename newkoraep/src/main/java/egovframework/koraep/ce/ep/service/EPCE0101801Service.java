package egovframework.koraep.ce.ep.service;

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
import egovframework.mapper.ce.ep.EPCE0101801Mapper;

/**
 * 상산자보증금잔액관리 서비스
 * @author Administrator
 *
 */
@Service("epce0101801Service")
public class EPCE0101801Service {

	@Resource(name="epce0101801Mapper")
	private EPCE0101801Mapper epce0101801Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0101801_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		return model;
	}
	
	/**
	 * 잔액 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce0101801_select2(Map<String, String> data) {
		
		List<?> menuList = epce0101801Mapper.epce0101801_select(data);

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
	 * 조정금액관리 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0101888_select(ModelMap model) {
		
		String title = commonceService.getMenuTitle("EPCE0101888");
		model.addAttribute("titleSub", title);
		
		List<?> adjItemList = commonceService.getCommonCdListNew("C041");// 조정항목
		try {
			model.addAttribute("adjItemList", util.mapToJson(adjItemList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		return model;
	}
	
	/**
	 * 조정금액관리 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce0101888_select2(Map<String, String> data) {
		
		List<?> menuList = epce0101801Mapper.epce0101888_select(data);

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
	 * 조정금액관리 저장
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce0101888_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}
				
				if(data.get("BAL_SN") != null && !data.get("BAL_SN").equals("")){
					epce0101801Mapper.epce0101888_update(data);	//수정
				}else{
					epce0101801Mapper.epce0101888_insert(data);	//등록
				}
				
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	/**
	 * 보증금관리 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce0101801_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
				
			List<?> list = epce0101801Mapper.epce0101801_select(data);

			//엑셀파일 저장
			commonceService.excelSave(request, data, list);

		}catch(Exception e){
			return  "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
}
