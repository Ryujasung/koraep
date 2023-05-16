package egovframework.koraep.mf.ep.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.mf.ep.EPMF6654201Mapper; //직접회수정보조회

/**
 * 직접회수정보조회 Service
 * @author pc
 *
 */
@Service("epmf6654201Service")
public class EPMF6654201Service {
	
	@Resource(name="epmf6654201Mapper")
	private EPMF6654201Mapper epmf6654201Mapper;
		
	@Resource(name="commonceService")
    private CommonCeService commonceService;
	
	/**
	 * 직접반환관리 페이지호출
	 * @param data 
	 * @param model
	 * @param request
	 * @return
	 */
	public ModelMap epmf6654201_select1(ModelMap model, HttpServletRequest request)  {
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
		
		Map<String, String> map = new HashMap<String, String>();
		
		Map<String, String> bizrMap = new HashMap<String, String>();

		List<?> mfc_bizrnm_sel 	= commonceService.mfc_bizrnm_select(request, bizrMap); // 생산자 콤보박스
		List<?> stat_cdList			= commonceService.getCommonCdListNew("D017");	 //상태
		//List<?> grid_info				= commonceService.GRID_INFO_SELECT("EPMF6654201",request); //그리드 컬럼 정보
		
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
			//model.addAttribute("grid_info", util.mapToJson(grid_info));
			model.addAttribute("mfc_bizrnm_sel", util.mapToJson(mfc_bizrnm_sel));	//생산자구분 리스트
			model.addAttribute("stat_cdList", util.mapToJson(stat_cdList));

		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
		
	}
	
	/**
	 * 직접반환정보 조회
	 * @param data
	 * @return
	 * @
	 */
	public HashMap<String, Object> epmf6654201_select2(Map<String, String> inputMap, HttpServletRequest request) {
		
		String MFC_BRCH_NM = inputMap.get("MFC_BRCH_NM_SEL");

		if(MFC_BRCH_NM != null && !MFC_BRCH_NM.equals("")){
			inputMap.put("BRCH_ID", MFC_BRCH_NM.split(";")[0]);
			inputMap.put("BRCH_NO", MFC_BRCH_NM.split(";")[1]);
		}else{
			inputMap.put("BRCH_ID", "");
			inputMap.put("BRCH_NO", "");
		}
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		inputMap.put("MFC_BIZRID", vo.getBIZRID());
		inputMap.put("MFC_BIZRNO", vo.getBIZRNO_ORI());
		if(!vo.getBRCH_NO().equals("9999999999")){
			inputMap.put("S_BRCH_ID", vo.getBRCH_ID());
			inputMap.put("S_BRCH_NO", vo.getBRCH_NO());
		}

		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		
		try {
			rtnMap.put("selList", util.mapToJson(epmf6654201Mapper.epmf6654201_select(inputMap)));
			rtnMap.put("totalList", util.mapToJson(epmf6654201Mapper.epmf6654201_select_cnt(inputMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return rtnMap;
		
	}
	
	/**
	 * 직접반환정보 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epmf6654201_excel(HashMap<String, String> inputMap, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
			
			String MFC_BRCH_NM = inputMap.get("MFC_BRCH_NM_SEL");

			if(MFC_BRCH_NM != null && !MFC_BRCH_NM.equals("")){
				inputMap.put("BRCH_ID", MFC_BRCH_NM.split(";")[0]);
				inputMap.put("BRCH_NO", MFC_BRCH_NM.split(";")[1]);
			}else{
				inputMap.put("BRCH_ID", "");
				inputMap.put("BRCH_NO", "");
			}
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			inputMap.put("MFC_BIZRID", vo.getBIZRID());
			inputMap.put("MFC_BIZRNO", vo.getBIZRNO_ORI());
			if(!vo.getBRCH_NO().equals("9999999999")){
				inputMap.put("S_BRCH_ID", vo.getBRCH_ID());
				inputMap.put("S_BRCH_NO", vo.getBRCH_NO());
			}
				
			inputMap.put("excelYn", "Y");
			List<?> list = epmf6654201Mapper.epmf6654201_select(inputMap);

			//엑셀파일 저장
			commonceService.excelSave(request, inputMap, list);

		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	/**
	 * 직접반환정보 상센 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epmf6654264_excel(HashMap<String, String> inputMap, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
			
			List<?> list = epmf6654201Mapper.epmf6654264_select(inputMap); //상세내역 조회 표시

			//엑셀파일 저장
			commonceService.excelSave(request, inputMap, list);

		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	/**
	 * 직접반환 등록페이지
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf6654231_select(ModelMap model, HttpServletRequest request)  {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		Map<String, String> map = new HashMap<String, String>();
		
		String title = commonceService.getMenuTitle("EPMF6654231"); //타이틀
		model.addAttribute("titleSub", title);
		
		Map<String, String> bizrMap = new HashMap<String, String>();
		bizrMap.put("BIZR_STAT_CD", "Y"); //사용Y
		List<?> mfcSeCdList = commonceService.mfc_bizrnm_select(request, bizrMap); //생산자 콤보박스
		
		map.put("WORK_SE", "6"); 																//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환, 6.소매직접반환
		HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);	//등록일자제한설정  
		
		List<?> rtlRtnSeList = commonceService.getCommonCdListNew("D018");	 //구분
		
		try {
			model.addAttribute("rtlRtnSeList", util.mapToJson(rtlRtnSeList));
			model.addAttribute("mfcSeCdList", util.mapToJson(mfcSeCdList));
			model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));	  	    //등록일자제한설정
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	//생산자 리스트
		
		return model;
		
	}
	
	/**
	 * 직접반환 변경페이지
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf6654242_select(ModelMap model, HttpServletRequest request)  {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);
		HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		
		Map<String, String> map = new HashMap<String, String>();
		
		String title = commonceService.getMenuTitle("EPMF6654242"); //타이틀
		model.addAttribute("titleSub", title);
		
		map.put("WORK_SE", "6"); //업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환, 6.소매직접반환
		HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);	//등록일자제한설정  
		
		List<?> rtlRtnSeList = commonceService.getCommonCdListNew("D018"); //구분
		
		List<?> list = epmf6654201Mapper.epmf6654242_select(param); //상세리스트
		
		try {
			model.addAttribute("rtlRtnSeList", util.mapToJson(rtlRtnSeList));
			model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list)); //등록일자제한설정
			model.addAttribute("searchList", util.mapToJson(list));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	//생산자 리스트
		
		return model;
		
	}
	
	/**
	 * 직접반환정보 등록
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epmf6654231_insert(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		String ssUserId  = "";   //사용자ID
		
		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
					
				String doc_no ="";
				for(int i=0; i<list.size(); i++){
					
					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					
					map.put("SDT_DT", map.get("RTL_RTN_DT"));	//등록일자제한설정
					map.put("WORK_SE", "6"); 									//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환, 6.소매직접반환
					int sel_ck = commonceService.rtc_dt_ck(map);		//등록일자제한설정
					if(sel_ck !=1){
						throw new Exception("A021"); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
					}
					
					if(map.containsKey("RTL_RTN_BIZRNO") && !map.get("RTL_RTN_BIZRNO").equals("")){
						//직접반환구분 조회
						String drctRtnSe = epmf6654201Mapper.epmf6654231_select(map);
						if(drctRtnSe != null && drctRtnSe.equals("D")){ //반환업무설정 직접등록
							throw new Exception("A023"); //직접 등록하도록 설정된 소매업자입니다. 대행등록이 불가합니다.
						}
					}
					
					if(i == 0){
				 		//master
				 		String doc_psnb_cd ="RR"; 				   								
				 		doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 직접반환문서번호 조회
						map.put("RTL_RTN_DOC_NO", doc_no);	 //문서채번
						 
						epmf6654201Mapper.epmf6654231_insert(map); // 직접반환마스터 등록
					}else{
						map.put("RTL_RTN_DOC_NO", doc_no);	 //문서채번
					}

				 	//detail
				 	epmf6654201Mapper.epmf6654231_insert2(map); // 직접반환상세 등록
					 
				}//end of for
				
				epmf6654201Mapper.epmf6654231_update(doc_no);
				
			} catch (Exception e) {
				 if(e.getMessage().equals("A023") || e.getMessage().equals("A021") ){
					 throw new Exception(e.getMessage());
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
		}//end of list
		
		return errCd;
		
	}
	
	/**
	 * 직접반환정보 삭제
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epmf6654201_delete(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		
		if (list != null) {
			for(int i=0; i<list.size(); i++){
				map = (Map<String, String>) list.get(i);
				int stat = epmf6654201Mapper.epmf6654201_select2(map); //상태 체크
				if(stat>0){
					return "A012"; //정보가 변경되었습니다. 다시 조회하시기 바랍니다.
				}
			}
		}
		
		if (list != null) {
			try {
				for(int i=0; i<list.size(); i++){
					map = (Map<String, String>) list.get(i);
					epmf6654201Mapper.epmf6654201_delete(map); // 직접회수정보 삭제
				}
			}catch (Exception e) {
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}
		
		return errCd;    	
		
	}
	
	/**
	 * 엑셀 업로드 후처리
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epmf6654231_select2(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	try {
			rtnMap.put("selList", util.mapToJson(epmf6654201Mapper.epmf6654231_select2(inputMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}    	 
    	return rtnMap;    	
    }
	
	/**
	 * 직접반환정보 변경
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epmf6654242_update(Map<String, Object> inputMap, HttpServletRequest request) throws Exception  {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		JSONObject jparams = JSONObject.fromObject(inputMap.get("PARAMS"));
		HashMap<String, String> jmap = util.jsonToMap(jparams);
		
		//Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();
		boolean keyCheck = false;
		int cnt = 0; 
		
		/*상태 체크*/
		int stat = epmf6654201Mapper.epmf6654242_select2(jmap);
		if(stat>0){
			throw new Exception("A012"); 
		}
		/*상태 체크*/

		String ssUserId = "";
		
		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
					
				String doc_no ="";
				for(int i=0; i<list.size(); i++){
					
					Map<String, String> map = (Map<String, String>) list.get(i);
					
					map.put("S_USER_ID", ssUserId);
					
					map.put("RTL_RTN_DOC_NO", jmap.get("RTL_RTN_DOC_NO"));
					map.put("MFC_BIZRID", jmap.get("MFC_BIZRID"));
					map.put("MFC_BIZRNO", jmap.get("MFC_BIZRNO"));
					map.put("MFC_BRCH_ID", jmap.get("MFC_BRCH_ID"));
					map.put("MFC_BRCH_NO", jmap.get("MFC_BRCH_NO"));

					map.put("SDT_DT", map.get("RTL_RTN_DT"));			//등록일자제한설정
					map.put("WORK_SE", "6"); 									//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환, 6.소매직접반환
					int sel_ck = commonceService.rtc_dt_ck(map);		//등록일자제한설정
					if(sel_ck !=1){
						throw new Exception("A021"); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
					}
					
					if(map.containsKey("RTL_RTN_BIZRNO") && !map.get("RTL_RTN_BIZRNO").equals("")){
						//직접반환구분 조회
						String drctRtnSe = epmf6654201Mapper.epmf6654231_select(map);
						if(drctRtnSe != null && drctRtnSe.equals("D")){ //반환업무설정 직접등록
							throw new Exception("A023"); //직접 등록하도록 설정된 소매업자입니다. 대행등록이 불가합니다.
						}
					}
					
					if(i == 0){
			 			epmf6654201Mapper.epmf6654242_delete(map); //모든 데이터 삭제
			 		 }
					
				 	//detail
				 	epmf6654201Mapper.epmf6654231_insert2(map); // 직접반환상세 등록
					 
				}//end of for
				
				epmf6654201Mapper.epmf6654231_update(doc_no);
				
			} catch (Exception e) {
				 if(e.getMessage().equals("A023") || e.getMessage().equals("A021") ){
					 throw new Exception(e.getMessage());
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
		}//end of list
		
		
		return errCd;
	}
	
	/**
	 * 직접반환상세정보 초기화면
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf6654264_select(ModelMap model, HttpServletRequest request) {
		Map<String, String> map = new HashMap<String, String>();
		  
	  	//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		JSONObject jParams2 =(JSONObject)jParams.get("PARAMS");

		map.put("RTL_RTN_DOC_NO", jParams2.get("RTL_RTN_DOC_NO").toString());		 // 직접회수문서번호
		
		String   title		= commonceService.getMenuTitle("EPMF6654264");		//타이틀
		List<?> iniList	= epmf6654201Mapper.epmf6654264_select(map);		//상세내역 조회 표시

		model.addAttribute("INQ_PARAMS",jParams);
		
		try {
			model.addAttribute("iniList", util.mapToJson(iniList));	
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	
		model.addAttribute("titleSub", title);

		return model;    	
	}
	
}


