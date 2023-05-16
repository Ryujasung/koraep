package egovframework.koraep.ce.ep.service;

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
import egovframework.mapper.ce.ep.EPCE6658201Mapper; //출고정보조회

/**
 * 출고정보조회 Service
 * @author pc
 *
 */
@Service("epce6658201Service")
public class EPCE6658201Service {
	
	@Resource(name="epce6658201Mapper")
	private EPCE6658201Mapper epce6658201Mapper;
	
	@Resource(name="commonceService")
    private CommonCeService commonceService;
	
	/**
	 * 출고등록상태, 생산자 및 직매장/공장 리스트 조회
	 * @param data 
	 * @param model
	 * @param request
	 * @return
	 */
	public ModelMap epce6658201_select1(ModelMap model, HttpServletRequest request)  {
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
		
		Map<String, String> map = new HashMap<String, String>();
		
		String   title					= commonceService.getMenuTitle("EPCE6658201");	//타이틀
		List<?> mfc_bizrnm_sel 	= commonceService.mfc_bizrnm_select(request); // 생산자 콤보박스
		List<?> stat_cdList			= commonceService.getCommonCdListNew("D011");	//상태
		List<?> reg_se_sel			= commonceService.getCommonCdListNew("S004");	//등록구분
		List<?> grid_info			= commonceService.GRID_INFO_SELECT("EPCE6658201",request);	//그리드컬럼 조회
		
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
				
				List<?> mfc_brch_nm_sel	= commonceService.brch_nm_select(request, map);
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
	 * 출고정보 조회
	 * @param data
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce6658201_select2(Map<String, String> inputMap, HttpServletRequest request) {
		
		/*
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		if(vo != null){
			if(!vo.getBIZR_TP_CD().equals("T1")){
				inputMap.put("MFC_BIZRID", vo.getBIZRID());
				inputMap.put("MFC_BIZRNO", vo.getBIZRNO());
			}
		}
		*/
		
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
			rtnMap.put("selList", util.mapToJson(epce6658201Mapper.epce6658201_select2(inputMap)));
			rtnMap.put("totalList", util.mapToJson(epce6658201Mapper.epce6658201_select4(inputMap)));
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
	public HashMap<String, Object> epce6658201_select3(Map<String, String> data, HttpServletRequest request) {
		
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
	 * 출고정보 삭제
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce6658201_delete(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		
		if (list != null) {
			for(int i=0; i<list.size(); i++){
				map = (Map<String, String>) list.get(i);
				int stat = epce6658201Mapper.epce6658201_select3(map); //상태 체크
				 if(stat>0){
					throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
				 }
			}
		}	
		
		if (list != null) {
			try {
				for(int i=0; i<list.size(); i++){
					map = (Map<String, String>) list.get(i);
					epce6658201Mapper.epce6658201_delete(map); // 출고정보 삭제
				}
				
			}catch (Exception e) {
				String tempErrcd = e.getMessage();
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}return errCd;    	
		
	}

	/**
	 * 출고상세정보 초기화면
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce6658201_select4(ModelMap model, HttpServletRequest request) {
		Map<String, String> map = new HashMap<String, String>();
		  
	  	//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		JSONObject jParams2 =(JSONObject)jParams.get("PARAMS");
		
		map.put("MFC_BIZRID", jParams2.get("MFC_BIZRID").toString());				//생산자ID
		map.put("MFC_BIZRNO", jParams2.get("MFC_BIZRNO").toString());			//생산자 사업자번호
		map.put("MFC_BRCH_ID", jParams2.get("MFC_BRCH_ID").toString());			//생산자 지사 ID
		map.put("MFC_BRCH_NO", jParams2.get("MFC_BRCH_NO").toString());		//생산자 지사 번호
		map.put("DLIVY_DOC_NO", jParams2.get("DLIVY_DOC_NO").toString());		 // 출고문서번호
		
		String   title			= commonceService.getMenuTitle("EPCE66582641");	//타이틀
		List<?> iniList		= epce6658201Mapper.epce66582641_select(map);		//상세내역 조회 표시
		List<?> gridList		= epce6658201Mapper.epce66582641_select2(map);	//그리드쪽 조회

		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		if(vo != null){
			jParams.put("USER_NM", vo.getUSER_NM());
		}
		
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
	 * 출고상세정보 초기화면 (링크)
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce66582642_select(ModelMap model, HttpServletRequest request) {
		Map<String, String> map = new HashMap<String, String>();
		
	  	//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		JSONObject jParams2 =(JSONObject)jParams.get("PARAMS");
		
		map.put("MFC_BIZRID", jParams2.get("MFC_BIZRID").toString());					//생산자ID
		map.put("MFC_BIZRNO", jParams2.get("MFC_BIZRNO").toString());				//생산자 사업자번호
		
		if(jParams2.get("START_DT_SEL") != null && jParams2.get("END_DT_SEL") != null){
			map.put("START_DT_SEL", jParams2.get("START_DT_SEL").toString());		//생산자ID
			map.put("END_DT_SEL", jParams2.get("END_DT_SEL").toString());				//생산자 사업자번호
		}
		
		if(jParams2.get("DLIVY_DOC_NO") != null ){
			map.put("DLIVY_DOC_NO", jParams2.get("DLIVY_DOC_NO").toString());		//출고 문서번호
		}
		
		if(jParams2.get("STD_YEAR") != null ){
			map.put("STD_YEAR", jParams2.get("STD_YEAR").toString());		//기준년도
		}
		
		String   title			= commonceService.getMenuTitle("EPCE66582642");		//타이틀
		List<?> iniList		= epce6658201Mapper.epce66582641_select(map);			//상세내역 조회 표시
		List<?> gridList		= epce6658201Mapper.epce66582641_select2(map);		//그리드쪽 조회

		model.addAttribute("INQ_PARAMS", jParams);
		
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
	 * 출고상세정보 초기화면
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce66582641_excel(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";

		try {
			
			List<?> list = epce6658201Mapper.epce66582641_select2(data);

			//엑셀파일 저장
			commonceService.excelSave(request, data, list);

		}catch(Exception e){
			throw new Exception("A001"); //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	
	}
	
	/**
	 * 출고관리 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce6658201_excel(HashMap<String, String> data, HttpServletRequest request) {
		
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
			List<?> list = epce6658201Mapper.epce6658201_select2(data);

			//엑셀파일 저장
			commonceService.excelSave(request, data, list);

		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}

}
