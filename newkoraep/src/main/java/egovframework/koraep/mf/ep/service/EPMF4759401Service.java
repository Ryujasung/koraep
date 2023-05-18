package egovframework.koraep.mf.ep.service;

import java.io.IOException;
import java.sql.SQLException;
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
import egovframework.mapper.mf.ep.EPMF4759401Mapper;
import egovframework.mapper.mf.ep.EPMF6652931Mapper;

/**
 * 출고정정  서비스
 * @author Administrator
 *
 */
@Service("epmf4759401Service")
public class EPMF4759401Service {

	@Resource(name="epmf4759401Mapper")
	private EPMF4759401Mapper epmf4759401Mapper;
	
	@Resource(name="epmf6652931Mapper")
	private EPMF6652931Mapper epmf6652931Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf4759401_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
		
		Map<String, String> map = new HashMap<String, String>();
		
		List<?> stdMgntList = commonceService.std_mgnt_select(request, map); //정산기간
		List<?> statList = commonceService.getCommonCdListNew("C001");
		List<?> mfcSeCdList = commonceService.mfc_bizrnm_select_y(request); // 생산자 콤보박스
		List<?> whsdlSeCdList	= commonceService.whsdl_se_select(request, map); //도매업자구분
		//List<?> whsdlList =commonceService.mfc_bizrnm_select4(request, map); //도매업자 업체명조회
		try {
			model.addAttribute("stdMgntList", util.mapToJson(stdMgntList));
			model.addAttribute("statList", util.mapToJson(statList));
			model.addAttribute("mfcSeCdList", util.mapToJson(mfcSeCdList));
			model.addAttribute("whsdlSeCdList", util.mapToJson(whsdlSeCdList));
			//model.addAttribute("whsdlList", util.mapToJson(whsdlList));
			
			if(jmap != null){

				String BIZRID_NO = jmap.get("MFC_BIZR_SEL");
				if(BIZRID_NO != null && !BIZRID_NO.equals("")){
					map.put("BIZRID", BIZRID_NO.split(";")[0]);
					map.put("BIZRNO", BIZRID_NO.split(";")[1]);
					map.put("MFC_BIZRID", BIZRID_NO.split(";")[0]);
					map.put("MFC_BIZRNO", BIZRID_NO.split(";")[1]);
				}else{
					map.put("BIZRID", "");
					map.put("BIZRNO", "");
					map.put("MFC_BIZRID", "");
					map.put("MFC_BIZRNO", "");
				}
				
				String MFC_BRCH = jmap.get("MFC_BRCH_SEL");
				if(MFC_BRCH != null && !MFC_BRCH.equals("")){
					map.put("MFC_BRCH_ID", MFC_BRCH.split(";")[0]);
					map.put("MFC_BRCH_NO", MFC_BRCH.split(";")[1]);
				}else{
					map.put("MFC_BRCH_ID", "");
					map.put("MFC_BRCH_NO", "");
				}

				List<?> brchList = commonceService.brch_nm_select(request, map);
				List<?> ctnrList = commonceService.ctnr_nm_select(request, map);

				model.addAttribute("brchList", util.mapToJson(brchList));
				model.addAttribute("ctnrList", util.mapToJson(ctnrList));
				model.addAttribute("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, map))); 

			}else{
				model.addAttribute("brchList", "{}");	
				model.addAttribute("ctnrList", "{}");	
				model.addAttribute("whsdlList", "{}");	
			}
			
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
	 * 정정등록 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf4759431_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		HashMap<String, String> excaStdMap = commonceService.exca_std_mgnt_select(param); // 정산기간 조회
		
		List<?> mfcSeCdList = commonceService.mfc_bizrnm_select_y(request); // 생산자 콤보박스
		List<?> dlivyStatSeList = commonceService.getCommonCdListNew("D015");// 출고구분
		try {
			model.addAttribute("excaStdMap", util.mapToJson(excaStdMap));
			model.addAttribute("mfcSeCdList", util.mapToJson(mfcSeCdList));
			model.addAttribute("dlivyStatSeList", util.mapToJson(dlivyStatSeList));
			
			model.addAttribute("titleSub", commonceService.getMenuTitle("EPMF4759431")); //타이틀
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
	 * 정정 수정 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf4759442_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		HashMap<String, String> excaStdMap = commonceService.exca_std_mgnt_select(param); // 정산기간 조회
		
		Map<String, String> map = new HashMap<String, String>();
		model.addAttribute("titleSub", commonceService.getMenuTitle("EPMF4759442")); //타이틀
		
		List<?> dlivyStatSeList = commonceService.getCommonCdListNew("D015");// 출고구분
		
		map.put("BIZRID", param.get("MFC_BIZRID"));
		map.put("BIZRNO", param.get("MFC_BIZRNO"));
		List<?> brchList = commonceService.brch_nm_select(request, map);

		map.put("MFC_BIZRID", param.get("MFC_BIZRID"));
		map.put("MFC_BIZRNO", param.get("MFC_BIZRNO"));
		map.put("MFC_BRCH_ID", param.get("MFC_BRCH_ID"));
		map.put("MFC_BRCH_NO", param.get("MFC_BRCH_NO"));
		List<?> whsdlList = commonceService.mfc_bizrnm_select4(request, map);
		
		map.put("BIZR_TP_CD", param.get("BIZR_TP_CD"));
		map.put("DLIVY_DT", param.get("DLIVY_DT"));
		List<?> ctnrList = epmf6652931Mapper.epmf6652931_select5(map);

		try {
			model.addAttribute("excaStdMap", util.mapToJson(excaStdMap));
			
			model.addAttribute("dlivyStatSeList", util.mapToJson(dlivyStatSeList));
			
			model.addAttribute("brchList", util.mapToJson(brchList));
			model.addAttribute("ctnrList", util.mapToJson(ctnrList));
			model.addAttribute("whsdlList", util.mapToJson(whsdlList)); 
			
			model.addAttribute("searchDtl", util.mapToJson(epmf4759401Mapper.epmf4759442_select(param)));

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
	 * 출고정정 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epmf4759401_select2(Map<String, String> data, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		if(vo != null){ //로그인 생산자 
			data.put("MFC_BIZRID", vo.getBIZRID());
			data.put("MFC_BIZRNO", vo.getBIZRNO_ORI());
			if(!vo.getBRCH_NO().equals("9999999999")){
				data.put("S_BRCH_ID", vo.getBRCH_ID());
				data.put("S_BRCH_NO", vo.getBRCH_NO());
			}
		}
		
		String MFC_BRCH = data.get("MFC_BRCH_SEL");
		String CUST_BIZR = data.get("CUST_BIZR_SEL");

		if(MFC_BRCH != null && !MFC_BRCH.equals("")){
			data.put("MFC_BRCH_ID", MFC_BRCH.split(";")[0]);
			data.put("MFC_BRCH_NO", MFC_BRCH.split(";")[1]);
		}else{
			data.put("MFC_BRCH_ID", "");
			data.put("MFC_BRCH_NO", "");
		}
		if(CUST_BIZR != null && !CUST_BIZR.equals("")){
			data.put("CUST_BIZRID", CUST_BIZR.split(";")[0]);
			data.put("CUST_BIZRNO", CUST_BIZR.split(";")[1]);
		}else{
			data.put("CUST_BIZRID", "");
			data.put("CUST_BIZRNO", "");
		}
		
		List<?> list = epmf4759401Mapper.epmf4759401_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
			map.put("totalList", epmf4759401Mapper.epmf4759401_select_cnt(data));
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
	 * 출고정정 생산자선택시 
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epmf4759401_select3(Map<String, String> data, HttpServletRequest request) {
		
		String BIZRID_NO = data.get("BIZRID_NO");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
			data.put("MFC_BIZRID", BIZRID_NO.split(";")[0]);
			data.put("MFC_BIZRNO", BIZRID_NO.split(";")[1]);
		}else{
			data.put("BIZRID", "");
			data.put("BIZRNO", "");
			data.put("MFC_BIZRID", "");
			data.put("MFC_BIZRNO", "");
		}
		
		/*
		String BRCH_ID_NO = data.get("BRCH_ID_NO");
		if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
			data.put("MFC_BRCH_ID", BRCH_ID_NO.split(";")[0]);
			data.put("MFC_BRCH_NO", BRCH_ID_NO.split(";")[1]);
		}else{
			data.put("MFC_BRCH_ID", "");
			data.put("MFC_BRCH_NO", "");
		}
		*/

		List<?> brchList = commonceService.brch_nm_select(request, data);
		List<?> ctnrList = commonceService.ctnr_nm_select(request, data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("brchList", util.mapToJson(brchList));
			map.put("ctnrList", util.mapToJson(ctnrList));
			map.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, data))); 
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
	 * 도매업자 구분 선택시 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epmf4759401_select4(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	try {
	      		rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 생산자랑 거래중인 도매업자 업체명조회
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
    	
    	return rtnMap;    	
    }
	
	/**
	 * 출고정정 직매장 선택시
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epmf4759401_select5(Map<String, String> data, HttpServletRequest request) {
		
		String BIZRID_NO = data.get("BIZRID_NO");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
			data.put("MFC_BIZRID", BIZRID_NO.split(";")[0]);
			data.put("MFC_BIZRNO", BIZRID_NO.split(";")[1]);
		}else{
			data.put("BIZRID", "");
			data.put("BIZRNO", "");
			data.put("MFC_BIZRID", "");
			data.put("MFC_BIZRNO", "");
		}
		
		String BRCH_ID_NO = data.get("BRCH_ID_NO");
		if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
			data.put("MFC_BRCH_ID", BRCH_ID_NO.split(";")[0]);
			data.put("MFC_BRCH_NO", BRCH_ID_NO.split(";")[1]);
		}else{
			data.put("MFC_BRCH_ID", "");
			data.put("MFC_BRCH_NO", "");
		}

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, data))); 
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
	 * 출고정정 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epmf4759401_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";
		try {

			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			if(vo != null){ //로그인 생산자 
				data.put("MFC_BIZRID", vo.getBIZRID());
				data.put("MFC_BIZRNO", vo.getBIZRNO_ORI());
				if(!vo.getBRCH_NO().equals("9999999999")){
					data.put("S_BRCH_ID", vo.getBRCH_ID());
					data.put("S_BRCH_NO", vo.getBRCH_NO());
				}
			}
			
			String MFC_BRCH = data.get("MFC_BRCH_SEL");
			String CUST_BIZR = data.get("CUST_BIZR_SEL");

			if(MFC_BRCH != null && !MFC_BRCH.equals("")){
				data.put("MFC_BRCH_ID", MFC_BRCH.split(";")[0]);
				data.put("MFC_BRCH_NO", MFC_BRCH.split(";")[1]);
			}else{
				data.put("MFC_BRCH_ID", "");
				data.put("MFC_BRCH_NO", "");
			}
			if(CUST_BIZR != null && !CUST_BIZR.equals("")){
				data.put("CUST_BIZRID", CUST_BIZR.split(";")[0]);
				data.put("CUST_BIZRNO", CUST_BIZR.split(";")[1]);
			}else{
				data.put("CUST_BIZRID", "");
				data.put("CUST_BIZRNO", "");
			}
			
			data.put("excelYn", "Y");
			List<?> list = epmf4759401Mapper.epmf4759401_select(data);

			//엑셀파일 저장
			commonceService.excelSave(request, data, list);

			
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			return  "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		return errCd;
	}	
	
	/**
	 * 출고정정 등록
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epmf4759431_update(Map<String, Object> inputMap, HttpServletRequest request) throws Exception  {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		//Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));

		boolean keyCheck = false;
		
		String ssUserId  = "";   //사용자ID

		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
					
				//master
		 		String doc_psnb_cd ="OC"; //출고정정
		 		String dlivy_doc_no = commonceService.doc_psnb_select(doc_psnb_cd); //출고정정 문서번호 조회
				 
				for(int i=0; i<list.size(); i++){

					keyCheck = false;
					
					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					map.put("REG_PRSN_ID", ssUserId);  	//등록자
					
					String STD_YEAR = map.get("DLIVY_DT").substring(0, 4);
					map.put("STD_YEAR", STD_YEAR);
					
					if(map.get("CUST_SEL_CK").equals("Y")){
						
					}else{
					
						//존재하는지 체크
						Map<String, String> checkMap = (Map<String, String>) epmf6652931Mapper.epmf6652931_select7(map);
	
						if(checkMap != null && !checkMap.get("CUST_BIZRID").equals("") && !checkMap.get("CUST_BRCH_ID").equals("N") 
								&& !checkMap.get("CUST_BIZRNO").equals("")){ //사업자, 지점 둘다 등록상태
							
							//이미 해당 사업자번호로 사업자 및 지점이 등록되어있는 경우는 해당 데이터를 통해 거래처를 등록한다.  즉  작성한 거래처명, 사업자유형은 무시함
							//errCd = ""; //이미 등록된 소매거래처 지점정보로 저장된 건이 있습니다. 등록결과를 확인하시기 바랍니다.
							map.put("CUST_BIZRID", checkMap.get("CUST_BIZRID"));
	
						}else{

							//사업자데이터가 없을경우
							if(checkMap == null || (checkMap != null && checkMap.get("CUST_BIZRID").equals("")) ){ 
								
								String psnbSeq = commonceService.psnb_select("S0001"); //사업자ID 일련번호 채번
								map.put("CUST_BIZRID", "D1H"+psnbSeq); //사업자ID = 출고등록사업자(D1) - 수기(H)
	
								epmf6652931Mapper.epmf6652931_insert(map); //소매 사업자등록
								epmf6652931Mapper.epmf6652931_insert2(map); //소매 지점등록
							
							//지점데이터가 없을경우
							}else if(checkMap != null && checkMap.get("CUST_BRCH_ID").equals("N") ){ 
								
								map.put("CUST_BIZRID", checkMap.get("CUST_BIZRID")); //조회된 사업자ID로 등록
								epmf6652931Mapper.epmf6652931_insert2(map); //소매 지점등록
							}
						}
					}
					
					map.put("EXCA_STD_CD", inputMap.get("EXCA_STD_CD").toString());
					
					/*정산기간 진행 체크*/
					int sel2 = epmf4759401Mapper.epmf4759431_select2(map); //
					if(sel2 < 1){
						 throw new Exception("A017");
					}
					
					/*중복체크*/
					int sel = epmf4759401Mapper.epmf4759431_select(map); //
					if(sel > 0){
						 throw new Exception("A014");
					}
					/*중복체크*/

					if(!map.containsKey("RMK")){
						map.put("RMK", "");
					}
					
					//EXCA_STD_CD 가 필요!@!@
					map.put("DLIVY_CRCT_DOC_NO", dlivy_doc_no); //문서채번
					epmf4759401Mapper.epmf4759431_insert(map); //출고정정 등록

				}//end of for
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				if(e.getMessage().equals("A014") || e.getMessage().equals("A017") ){
					 throw new Exception(e.getMessage());
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
		}//end of list
		return errCd;
		
	}
	
	/**
	 * 출고정정 수정
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epmf4759442_update(Map<String, Object> inputMap, HttpServletRequest request) throws Exception  {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		//Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));

		boolean keyCheck = false;
		
		String ssUserId  = "";   //사용자ID

		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
					
				//master
		 		String dlivy_doc_no = inputMap.get("DLIVY_CRCT_DOC_NO").toString();

				for(int i=0; i<list.size(); i++){

					keyCheck = false;
					
					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					map.put("REG_PRSN_ID", ssUserId);  	//등록자
					
					String STD_YEAR = map.get("DLIVY_DT").substring(0, 4);
					map.put("STD_YEAR", STD_YEAR);
					
					if(map.get("CUST_SEL_CK").equals("Y")){
						
					}else{
					
						//존재하는지 체크
						Map<String, String> checkMap = (Map<String, String>) epmf6652931Mapper.epmf6652931_select7(map);
	
						if(checkMap != null && !checkMap.get("CUST_BIZRID").equals("") && !checkMap.get("CUST_BRCH_ID").equals("N") 
								&& !checkMap.get("CUST_BIZRNO").equals("")){ //사업자, 지점 둘다 등록상태
							
							//이미 해당 사업자번호로 사업자 및 지점이 등록되어있는 경우는 해당 데이터를 통해 거래처를 등록한다.  즉  작성한 거래처명, 사업자유형은 무시함
							//errCd = ""; //이미 등록된 소매거래처 지점정보로 저장된 건이 있습니다. 등록결과를 확인하시기 바랍니다.
							map.put("CUST_BIZRID", checkMap.get("CUST_BIZRID"));
	
						}else{

							//사업자데이터가 없을경우
							if(checkMap == null || (checkMap != null && checkMap.get("CUST_BIZRID").equals("")) ){ 
								
								String psnbSeq = commonceService.psnb_select("S0001"); //사업자ID 일련번호 채번
								map.put("CUST_BIZRID", "D1H"+psnbSeq); //사업자ID = 출고등록사업자(D1) - 수기(H)
	
								epmf6652931Mapper.epmf6652931_insert(map); //소매 사업자등록
								epmf6652931Mapper.epmf6652931_insert2(map); //소매 지점등록
							
							//지점데이터가 없을경우
							}else if(checkMap != null && checkMap.get("CUST_BRCH_ID").equals("N") ){ 
								
								map.put("CUST_BIZRID", checkMap.get("CUST_BIZRID")); //조회된 사업자ID로 등록
								epmf6652931Mapper.epmf6652931_insert2(map); //소매 지점등록
							}
						}
					}
					
					map.put("EXCA_STD_CD", inputMap.get("EXCA_STD_CD").toString());
					
					map.put("MFC_BIZRNO_KEY", inputMap.get("MFC_BIZRNO_KEY").toString());
					map.put("MFC_BRCH_NO_KEY", inputMap.get("MFC_BRCH_NO_KEY").toString());
					map.put("CUST_BIZRNO_KEY", inputMap.get("CUST_BIZRNO_KEY").toString());
					map.put("CUST_BIZRNO_DE_KEY", inputMap.get("CUST_BIZRNO_DE_KEY").toString());
					map.put("DLIVY_DT_KEY", inputMap.get("DLIVY_DT_KEY").toString());
					map.put("CTNR_CD_KEY", inputMap.get("CTNR_CD_KEY").toString());
					
					/*정산기간 진행 체크*/
					int sel2 = epmf4759401Mapper.epmf4759431_select2(map); //
					if(sel2 < 1){
						 throw new Exception("A017");
					}
					
					if(map.get("MFC_BIZRNO_KEY").equals(map.get("MFC_BIZRNO")) && map.get("MFC_BRCH_NO_KEY").equals(map.get("MFC_BRCH_NO"))
						&& (map.get("CUST_BIZRNO_KEY").equals(map.get("CUST_BIZRNO")) || map.get("CUST_BIZRNO_DE_KEY").equals(map.get("CUST_BIZRNO")))
						&& map.get("DLIVY_DT_KEY").equals(map.get("DLIVY_DT").replace("-",""))	
						&& map.get("CTNR_CD_KEY").equals(map.get("CTNR_CD"))	
					  )
					{//키값에 변동없으면 중복체크 안함
					}else{
						/*중복체크*/
						int sel = epmf4759401Mapper.epmf4759431_select(map); //
						if(sel > 0){
							 throw new Exception("A014");
						}
						/*중복체크*/
					}

					//EXCA_STD_CD 가 필요!@!@
					map.put("DLIVY_CRCT_DOC_NO", dlivy_doc_no); //문서채번

					epmf4759401Mapper.epmf4759442_update(map); //출고정정 수정

				}//end of for
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				if(e.getMessage().equals("A014") || e.getMessage().equals("A017") ){
					 throw new Exception(e.getMessage());
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
		}//end of list
		return errCd;
		
	}
	
	/**
	 * 출고정정 삭제
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epmf4759401_delete(Map<String, Object> inputMap, HttpServletRequest request) throws Exception{
		
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

				for(int i=0; i<list.size(); i++){

					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					
					epmf4759401Mapper.epmf4759401_delete(map); //출고정정 삭제

				}//end of for
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}//end of list
		return errCd;
		
	}
	
	/**
	 * 출고정정 상태변경
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epmf4759401_update(Map<String, Object> inputMap, HttpServletRequest request) throws Exception{
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		String dlivy_crct_stat_cd = inputMap.get("DLIVY_CRCT_STAT_CD").toString();

		String ssUserId  = "";   //사용자ID

		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}

				for(int i=0; i<list.size(); i++){

					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					map.put("DLIVY_CRCT_STAT_CD", dlivy_crct_stat_cd);
					
					epmf4759401Mapper.epmf4759401_update(map); //출고정정 수정

				}//end of for
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}//end of list
		return errCd;
		
	}
	
}
