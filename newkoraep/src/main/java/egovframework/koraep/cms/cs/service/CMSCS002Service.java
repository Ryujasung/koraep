package egovframework.koraep.cms.cs.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.cms.CMSCS002Mapper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 지급내역조회 서비스
 * 
 * @author Administrator
 *
 */
@Service("cmscs002Service")
public class CMSCS002Service {

	@Resource(name = "cmscs002Mapper")
	private CMSCS002Mapper cmscs002Mapper;

	@Resource(name = "commonceService")
	private CommonCeService commonceService;

	/**
	 * 예금주조회결과상세 페이지 초기화
	 * 
	 * @param model
	 * @param request
	 * @return @
	 */
	public ModelMap cmscs002_select(ModelMap model, HttpServletRequest request) {
		String title = commonceService.getMenuTitle("CMSCS002");
		List<?> ahRltNmList = commonceService.getCommonCdListNew("D061"); // 이체실행상태
		model.addAttribute("titleSub", title);
		model.addAttribute("ahRltNmList", util.mapToJson(ahRltNmList));

		// 파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"), "{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);
		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));

		List<?> searchList = cmscs002Mapper.cmscs002_select(map);

		try {
			model.addAttribute("searchList", util.mapToJson(searchList));
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class)
					.debug("Exception Error");
		}

		return model;
	}

	/**
	 * 예금주조회결과상세
	 * 
	 * @param model
	 * @param request
	 * @return @
	 */
	public HashMap<String, Object> cmscs002_select2(Map<String, String> data) {

		List<?> searchList = cmscs002Mapper.cmscs002_select(data);
		List<?> countList = cmscs002Mapper.cmscs002_select_cnt(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(searchList));
			map.put("countList", util.mapToJson(countList));
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}
	
	/**
	 * 예금주조회결과상세 실행여부 변경
	 * 
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception @
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cmscs002_update(Map<String, Object> data, HttpServletRequest request) throws Exception {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";

		List<?> list = JSONArray.fromObject(data.get("list"));
		Map<String, Object> row = (Map<String, Object>) list.get(0);
		
		if (list == null || list.size() == 0)
			throw new Exception();

		String ssUserId = "";
		if (vo != null) {
			ssUserId = vo.getUSER_ID();
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("TX_EXEC_CD", "TY");
		map.put("UPD_PRSN_ID", ssUserId);
		map.put("LIST", list);
		map.put("REG_IDX", row.get("REG_IDX"));
		
		if (row.get("PAY_DOC_NO") != null) {
			// 지급
			cmscs002Mapper.cmscs002_update21(map);
			cmscs002Mapper.cmscs002_update22(map);
		} else {
			// 정산
			cmscs002Mapper.cmscs002_update31(map);
			cmscs002Mapper.cmscs002_update32(map);
		}

		return errCd;
	}

	/**
	 * 이체가능상태 변경(조회중)
	 * 
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception @
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cmscs002_update4(Map<String, String> data, HttpServletRequest request) throws Exception {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";

		List<?> list = JSONArray.fromObject(data.get("list"));
		if (list == null || list.size() == 0)
			throw new Exception();

		String ssUserId = "";
		if (vo != null) {
			ssUserId = vo.getUSER_ID();
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("TX_EXEC_CD", "TI");
		map.put("UPD_PRSN_ID", ssUserId);

		int start = 0; 
		int end = (list.size() < 1000) ? list.size() : 1000;
		
		while(end <= list.size()) {
			map.put("LIST", list.subList(start, end));
			
			if (((Map<String, String>) list.get(0)).get("PAY_DOC_NO") != null) {
				cmscs002Mapper.cmscs002_update22(map);	// 지급
			} else {
				cmscs002Mapper.cmscs002_update32(map);	// 정산
			}
			
			if(end == list.size()) {
				break;
			}
			
			start += 1000;
			end = (list.size() < end + 1000) ? list.size() : end + 1000;
		}
		
		return errCd;
	}

}
