package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE2308801Mapper;

/**
 * 수납확인내역조회 서비스
 * @author Administrator
 *
 */
@Service("epce2308801Service")
public class EPCE2308801Service {

	@Resource(name="epce2308801Mapper")
	private EPCE2308801Mapper epce2308801Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce2308801_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		try {
			List<?> bizrList 	= commonceService.mfc_bizrnm_select_y(request); // 생산자 콤보박스
			model.addAttribute("bizrList", util.mapToJson(bizrList));	//생산자 리스트
			
			List<?> billSeCdList = commonceService.getCommonCdListNew("D031");// 고지서구분
			List<?> acpCfmMnulYnList = commonceService.getCommonCdListNew("D036");// 수납확인수기여부
			model.addAttribute("billSeCdList", util.mapToJson(billSeCdList));
			model.addAttribute("acpCfmMnulYnList", util.mapToJson(acpCfmMnulYnList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 수납확인내역 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce2308801_select2(Map<String, Object> data) {

		String BIZRID_NO = String.valueOf(data.get("MFC_BIZR_SEL"));
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		data.put("BILL_SE_CD_SEL", JSONArray.fromObject(data.get("BILL_SE_CD_SEL")));
		
		List<?> menuList = epce2308801Mapper.epce2308801_select(data);

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
	 * 수납확인 상세조회 (고지서)
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce2308888_select(Map<String, String> data) {

		List<?> menuList = epce2308801Mapper.epce2308888_select(data);

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
	 * 수납확인 상세조회 (수납내역)
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce2308888_select2(Map<String, String> data) {

		List<?> menuList = epce2308801Mapper.epce2308888_select2(data);

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
	 *  엑셀저장
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce2308801_excel(HashMap<String, Object> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
			
			String BIZRID_NO = String.valueOf(data.get("MFC_BIZR_SEL"));
			if(BIZRID_NO != null && !BIZRID_NO.equals("")){
				data.put("BIZRID", BIZRID_NO.split(";")[0]);
				data.put("BIZRNO", BIZRID_NO.split(";")[1]);
			}
			
			data.put("BILL_SE_CD_SEL", JSONArray.fromObject(data.get("BILL_SE_CD_SEL")));
			
			data.put("excelYn", "Y");
			List<?> list = epce2308801Mapper.epce2308801_select(data);
								
			HashMap<String, String> map = new HashMap();
						
			map.put("fileName", data.get("fileName").toString());
			map.put("columns", data.get("columns").toString());
			
			//엑셀파일 저장
			commonceService.excelSave(request, map, list);

		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
}
