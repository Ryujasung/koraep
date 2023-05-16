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
import egovframework.mapper.ce.ep.EPCE6645201Mapper; //직접회수정보조회

/**
 * 직접회수정보조회 Service
 * @author pc
 *
 */
@Service("epce6645201Service")
public class EPCE6645201Service {
	
	@Resource(name="epce6645201Mapper")
	private EPCE6645201Mapper epce6645201Mapper;
	
	@Resource(name="commonceService")
    private CommonCeService commonceService;
	
	/**
	 * 직접회수등록상태, 생산자 및 직매장/공장 리스트 조회
	 * @param data 
	 * @param model
	 * @param request
	 * @return
	 */
	public ModelMap epce6645201_select1(ModelMap model, HttpServletRequest request)  {
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
		
		Map<String, String> map = new HashMap<String, String>();
		
		String   title					= commonceService.getMenuTitle("EPCE6645201");	//타이틀
		
		Map<String, String> bizrMap = new HashMap<String, String>();
		bizrMap.put("BIZR_TP_CD", "M2"); //음료생산자
		List<?> mfc_bizrnm_sel 	= commonceService.mfc_bizrnm_select(request, bizrMap); 	// 생산자 콤보박스
		
		List<?> stat_cdList			= commonceService.getCommonCdListNew("D012");	//상태
		List<?> reg_se_sel			= commonceService.getCommonCdListNew("S004");	//등록구분
		List<?> grid_info				= commonceService.GRID_INFO_SELECT("EPCE6645201",request);		//그리드 컬럼 정보
		
		try {
			if(jmap != null){
				String BIZRID_NO = jmap.get("MFC_BIZRNM_SEL");
				if(BIZRID_NO != null && !BIZRID_NO.equals("")){
					map.put("BIZRID", BIZRID_NO.split(";")[0]);
					map.put("BIZRNO", BIZRID_NO.split(";")[1]);
				}else{
					map.put("BIZRID", "");
					map.put("BIZRNO", "");
				}
				
				List<?> mfc_brch_nm_sel	 = commonceService.brch_nm_select(request, map);
				model.addAttribute("mfc_brch_nm_sel", util.mapToJson(mfc_brch_nm_sel)); //직매장
			}else{
				model.addAttribute("mfc_brch_nm_sel", "{}");	//직매장
			}
			model.addAttribute("grid_info", util.mapToJson(grid_info));
			model.addAttribute("mfc_bizrnm_sel", util.mapToJson(mfc_bizrnm_sel));	//생산자구분 리스트
			model.addAttribute("stat_cdList", util.mapToJson(stat_cdList));
			model.addAttribute("reg_se_sel", util.mapToJson(reg_se_sel));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}           //등록구분
		model.addAttribute("titleSub", title);
		
		return model;
		
	}
	
	/**
	 * 직접회수정보 조회
	 * @param data
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce6645201_select2(Map<String, String> inputMap, HttpServletRequest request) {
		
		String MFC_BIZRNM = inputMap.get("MFC_BIZRNM_SEL");
		String MFC_BRCH_NM = inputMap.get("MFC_BRCH_NM_SEL");

		if(MFC_BIZRNM != null && !MFC_BIZRNM.equals("")){
			inputMap.put("MFC_BIZRID", MFC_BIZRNM.split(";")[0]);
			inputMap.put("MFC_BIZRNO", MFC_BIZRNM.split(";")[1]);
		}else{
			inputMap.put("MFC_BIZRID", "");
			inputMap.put("MFC_BIZRNO", "");
		}
		if(MFC_BRCH_NM != null && !MFC_BRCH_NM.equals("")){
			inputMap.put("BRCH_ID", MFC_BRCH_NM.split(";")[0]);
			inputMap.put("BRCH_NO", MFC_BRCH_NM.split(";")[1]);
		}else{
			inputMap.put("BRCH_ID", "");
			inputMap.put("BRCH_NO", "");
		}

		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		
		try {
			rtnMap.put("selList", util.mapToJson(epce6645201Mapper.epce6645201_select(inputMap)));
			rtnMap.put("totalList", util.mapToJson(epce6645201Mapper.epce6645201_select_cnt(inputMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return rtnMap;
		
	}
	
	/**
	 * 직매장별거래처관리 직매장/공장 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce6645201_select3(Map<String, String> data, HttpServletRequest request) {
		
		String BIZRID_NO = data.get("BIZRID_NO");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}else{
			data.put("BIZRID", "");
			data.put("BIZRNO", "");
		}

		List<?> menuList = commonceService.brch_nm_select(request, data);

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
	 * 직접회수정보 삭제
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce6645201_delete(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		
		if (list != null) {
			for(int i=0; i<list.size(); i++){
				map = (Map<String, String>) list.get(i);
				int stat = epce6645201Mapper.epce6645201_select3(map); //상태 체크
				if(stat>0){
					return "A012"; //정보가 변경되었습니다. 다시 조회하시기 바랍니다.
				}
			}
		}
		
		if (list != null) {
			try {
				for(int i=0; i<list.size(); i++){
					map = (Map<String, String>) list.get(i);
					epce6645201Mapper.epce6645201_delete(map); // 직접회수정보 삭제
				}
			}catch (Exception e) {
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}
		
		return errCd;    	
		
	}

	/**
	 * 직접회수상세정보 초기화면
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce6645201_selec4(ModelMap model, HttpServletRequest request) {
		Map<String, String> map = new HashMap<String, String>();
		  
	  	//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		JSONObject jParams2 =(JSONObject)jParams.get("PARAMS");

		map.put("DRCT_RTRVL_DOC_NO", jParams2.get("DRCT_RTRVL_DOC_NO").toString());		 	// 직접회수문서번호
		
		String   title		= commonceService.getMenuTitle("EPCE6645264");		//타이틀
		List<?> iniList	= epce6645201Mapper.epce6645264_select(map);		//상세내역 조회 표시
		List<?> gridList	= epce6645201Mapper.epce6645264_select2(map);		//그리드쪽 조회

		model.addAttribute("INQ_PARAMS",jParams);
		
		try {
			model.addAttribute("iniList", util.mapToJson(iniList));	
			model.addAttribute("gridList", util.mapToJson(gridList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	
		model.addAttribute("titleSub", title);

		return model;    	
	}
	
	/**
	 * 직접회수관리 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce6645201_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
			
			String MFC_BIZRNM = data.get("MFC_BIZRNM_SEL");
			String MFC_BRCH_NM = data.get("MFC_BRCH_NM_SEL");

			if(MFC_BIZRNM != null && !MFC_BIZRNM.equals("")){
				data.put("MFC_BIZRID", MFC_BIZRNM.split(";")[0]);
				data.put("MFC_BIZRNO", MFC_BIZRNM.split(";")[1]);
			}else{
				data.put("MFC_BIZRID", "");
				data.put("MFC_BIZRNO", "");
			}
			if(MFC_BRCH_NM != null && !MFC_BRCH_NM.equals("")){
				data.put("BRCH_ID", MFC_BRCH_NM.split(";")[0]);
				data.put("BRCH_NO", MFC_BRCH_NM.split(";")[1]);
			}else{
				data.put("BRCH_ID", "");
				data.put("BRCH_NO", "");
			}
					
			data.put("excelYn", "Y");
			List<?> list = epce6645201Mapper.epce6645201_select(data);

			//엑셀파일 저장
			commonceService.excelSave(request, data, list);

		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}

	
	/**
	 * 직접회수 상세조회 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce6645264_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
					
			List<?> list = epce6645201Mapper.epce6645264_select2(data);

			//엑셀파일 저장
			commonceService.excelSave(request, data, list);

		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
}
