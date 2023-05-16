package egovframework.koraep.ce.ep.service;

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
import egovframework.mapper.ce.ep.EPCE4738731Mapper;
import egovframework.mapper.ce.ep.EPCE2983931Mapper;

/**
 * 입고정정등록 /수정  /입고내역선택 Service
 * @author 양성수
 *
 */
@Service("epce4738731Service")
public class EPCE4738731Service {
	
	@Resource(name="epce4738731Mapper")
	private EPCE4738731Mapper epce4738731Mapper;  //입고정정등록 Mapper
	
	@Resource(name="epce2983931Mapper")
	private EPCE2983931Mapper epce2983931Mapper;  //입고정정 등록 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/***************************************************************************************************************************************************************************************
	 * 	 입고정정건별등록
	****************************************************************************************************************************************************************************************/
	/**
	 * 입고정정 등록 초기 화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4738731_select(ModelMap model, HttpServletRequest request) {
		  
		 	
	  	//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		String   title					= commonceService.getMenuTitle("EPCE4738731");		//타이틀
	
		Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS")); // 선택 row 값
		//빈용기테이블때문에//
		map.put("CUST_BIZRID", map.get("WHSDL_BIZRID"));	 			//도매업자 ID
		map.put("CUST_BIZRNO", map.get("WHSDL_BIZRNO_ORI"));	//도매업자 사업자번호
		map.put("CUST_BRCH_ID", map.get("WHSDL_BRCH_ID"));		//도매업자 지점 ID
		map.put("CUST_BRCH_NO", map.get("WHSDL_BRCH_NO"));	//도매업자 지점번호
		map.put("CTNR_SE", "2");													//빈용기 구분  구병/신병
				
		try {
			String bizrTpCd = util.null2void(commonceService.bizr_tp_cd_select(request, map), ""); //빈용기 구분 조회
			
			map.put("BIZR_TP_CD", bizrTpCd);

			if(map.get("BIZR_TP_CD").equals("W1") ){
				map.put("PRPS_CD", "0");												//빈용기 구분   	도매업자구분이 도매업자(W1)일경우 유흥/가정으로
			}
			else if(map.get("BIZR_TP_CD").equals("W2") ){
				map.put("PRPS_CD", "2");												//빈용기 구분		도매업자구분이 공병상(W2)일경우 직접반환하는자로
			}
			else {
				map.put("PRPS_CD", "X");
			}

			List<?> ctnr_se			= commonceService.getCommonCdListNew("E005");		//빈용기구분 구/신
			List<?> ctnr_seList		= commonceService.ctnr_se_select(request, map);						//빈용기구분 유흥/가정/직접 조회
			List<?> iniList			= epce4738731Mapper.epce4738731_select(map);		//상세내역 조회
			List<?> cfm_gridList 	= epce4738731Mapper.epce4738731_select2(map);		//그리드쪽 조회 입고정보 있을 경우 
			List<?> ctnr_nm			= commonceService.ctnr_cd_select(map);					//빈용기명 조회
			List<?> rmk_list		= commonceService.getCommonCdListNew("D025");	//소매수수료 적용여부 비고
			
			model.addAttribute("INQ_PARAMS",jParams);
			model.addAttribute("titleSub", title);
			model.addAttribute("iniList", util.mapToJson(iniList));	
			model.addAttribute("cfm_gridList", util.mapToJson(cfm_gridList));	
			model.addAttribute("ctnr_se", util.mapToJson(ctnr_se));	
			model.addAttribute("ctnr_seList", util.mapToJson(ctnr_seList));	
			model.addAttribute("ctnr_nm", util.mapToJson(ctnr_nm));
			model.addAttribute("rmk_list", util.mapToJson(rmk_list));	
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	   
		return model;    	
    }
  
	/**
	 * 입고정정 빈용기명
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce4738731_select2(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	try {
			rtnMap.put("ctnr_nm", util.mapToJson(commonceService.ctnr_cd_select(inputMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}    	 	//빈용기명 조회
    	return rtnMap;    	
    }

	/**
	 * 입고정정등록  저장
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4738731_insert(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		//Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		List<?> list_ori = JSONArray.fromObject(inputMap.get("list_ori"));
		String wrhs_crct_doc_no ="";
		boolean flag  =true;
		
		if (list != null) {
			try {
			
				// 각종 체크
				Map<String, String> check = (Map<String, String>) list.get(0);
				

				int sel = epce4738731Mapper.epce4738731_select6(check); // 적용기간 체크
				if(sel >0 ){
					throw new Exception("A017"); 
				}
				 
				/*
				 * 20180823, 이근표 : 사업관리팀 곽명진팀장 요청
				sel = epce4738731Mapper.epce4738731_select5(check); // 수량 체크

				if(sel != 1){
					throw new Exception("A016"); 
				}
				*/
				 
				List<?>  gridList	= util.mapToJson(epce4738731Mapper.epce4738731_select2(check));// 입고정보 초기 값 데이터 비교

				if(list_ori.size() ==gridList.size() ){
					 for(int k =0;k<list_ori.size();k++){
						 Map<String, String> list_ori_map = new HashMap<String, String>();
						 Map<String, String> gridList_map = new HashMap<String, String>();
						 list_ori_map = (Map<String, String>) list_ori.get(k);
						 gridList_map = (Map<String, String>) gridList.get(k);
						 
						 list_ori_map.put("rm_internal_uid", "");
						 list_ori_map.put("ADD_FILE", "");
						 gridList_map.put("rm_internal_uid", "");
						 gridList_map.put("ADD_FILE", "");
						 
						 if(!list_ori_map.toString().equals(gridList_map.toString())){
							 throw new Exception("A008");   //변조된 데이터
						 }
					 }										
				}else{
						 throw new Exception("A008");   //변조된 데이터
				}
				
				wrhs_crct_doc_no = commonceService.doc_psnb_select("IC");			 //	입고정정문서번호
				    
				//입고정정등록 실행
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = (Map<String, String>) list.get(i);
					
					sel = epce4738731Mapper.epce4738731_select4(map); //중복 체크 
					if(sel>0){
						throw new Exception("A014"); 
					}
					
					if(vo != null){
						map.put("REG_PRSN_ID", vo.getUSER_ID());  								// 등록자
					}
					
					map.put("WRHS_CRCT_DOC_NO", wrhs_crct_doc_no);					// 문서채번
					epce4738731Mapper.epce4738731_insert(map); 							// 입고정정 등록
					if(flag){
						epce4738731Mapper.epce4738731_update(map);						//입고마스터 update
						flag = false;
					}
				}//end of for
	 	
			} catch (Exception e) {
				 if(e.getMessage().equals("A008") || e.getMessage().equals("A014") || e.getMessage().equals("A016")  || e.getMessage().equals("A017") ){
					 throw new Exception(e.getMessage()); 
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
		}//end of list
		return errCd;
    }
/***************************************************************************************************************************************************************************************
 * 	 입고정정일괄등록
****************************************************************************************************************************************************************************************/
	    		 		    
    /**
	 * 입고정정일괄등록  초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce47387312_select(ModelMap model, HttpServletRequest request) {
			  
	  	//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		Map<String, String> map = util.jsonToMap(jParams.getJSONObject("EXCA_PARAM"));
		List<?>	mfc_bizrnmList =null; 
		if(map.get("EXCA_TRGT_SE").equals("I")){
			mfc_bizrnmList =commonceService.std_mgnt_mfc_select(request, map);					//정산기간중인 생산자
		}else{
			mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); 	 						//모든생산자
		}
		List<?> std_mgnt_list 	= commonceService.std_mgnt_select(request, map);					//정산기간
		String   title					= commonceService.getMenuTitle("EPCE47387312");		//타이틀
		try {
			model.addAttribute("std_mgnt_list", util.mapToJson(std_mgnt_list));  		//정산기준관리 조회 
			model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));   
			model.addAttribute("titleSub", title);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	
		
		return model;    	
    }

    /**
	 * 엑셀 업로드 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce47387312_select2(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	try {
	      		rtnMap.put("selList", util.mapToJson(epce4738731Mapper.epce47387312_select(inputMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	 
    	
		return rtnMap;    	
    }
  
	
	/**
	 * 입고정정등록 (일괄등록)
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce47387312_insert(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		//Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();
		String wrhs_crct_doc_no ="";
		boolean keyCheck  =false;
		
		if (list != null) {
			try {
			
				// 각종 체크
				Map<String, String> check = (Map<String, String>) list.get(0);
				int sel = epce4738731Mapper.epce4738731_select6(check); // 적용기간 체크
				if(sel >0 ){
					 throw new Exception("A017"); 
				 }
				    
				//입고정정등록 실행
				for(int i=0; i<list.size(); i++){
					keyCheck = false;
					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("CTNR_CD",map.get("CRCT_CTNR_CD"));;// 같은 insert 탈려고 ...''' 입고확인용기코드 >> 정정용기코드로
					
					sel = epce4738731Mapper.epce4738731_select4(map); //중복 체크 
					if(sel>0){
						throw new Exception("A014"); 
					}
					for(int j=0 ;j<list2.size(); j++){// list2에 있는 입고문서번호랑 같을경우  입고정정문서 같은것으로 적용
						Map<String, String> map2 = (Map<String, String>) list2.get(j);
						if(map.get("WRHS_DOC_NO").equals(map2.get("WRHS_DOC_NO"))){
							map.put("WRHS_CRCT_DOC_NO",map2.get("WRHS_CRCT_DOC_NO"));
							keyCheck = true;
							break;
						}
					}
					if(!keyCheck){//false면 문서채번 등록  같은 입고문서번호가 list2에 있을경우 문서채번 안받는다.
						wrhs_crct_doc_no = commonceService.doc_psnb_select("IC");	 //	입고정정문서번호
						map.put("WRHS_CRCT_DOC_NO", wrhs_crct_doc_no);			 //문서채번
						list2.add(map);
					}
					if(vo != null){
						map.put("REG_PRSN_ID", vo.getUSER_ID());  					// 등록자
					}
					epce4738731Mapper.epce4738731_insert(map); 				// 입고정정 등록
				}//end of for
				
				for(int j=0 ;j<list2.size(); j++){//list2에 있는 입고문서번호 수만큼 입고마스터에 입고정정문서번호 입력
			 		Map<String, String> map3 = (Map<String, String>) list2.get(j);
			 		
			 		/*
			 		 * 20180823, 이근표 : 사업관리팀 곽명진팀장 요청
			 		sel = epce4738731Mapper.epce4738731_select5(map3); 	// 수량 체크
					if(sel != 1){	
							 throw new Exception("A016"); 
					}
					*/
					
			 		epce4738731Mapper.epce4738731_update(map3);			//입고마스터 update
			 	}
		 	
			} catch (Exception e) {
				 if(e.getMessage().equals("A008") || e.getMessage().equals("A014") || e.getMessage().equals("A016")  || e.getMessage().equals("A017") ){
					 throw new Exception(e.getMessage()); 
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
		}//end of list
		return errCd;
    }
			
		  
		  
/***************************************************************************************************************************************************************************************
 * 	 입고정정수정
****************************************************************************************************************************************************************************************/
	    
    /**
	 * 입고정정 등록 초기 화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4738742_select(ModelMap model, HttpServletRequest request) {
	 	
	  	//파라메터 정보
		String reqParams 	 = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		String   title				 = commonceService.getMenuTitle("EPCE4738742");		//타이틀
	
		Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS")); // 선택 row 값
		
		//빈용기테이블때문에//
		map.put("CUST_BIZRID", map.get("WHSDL_BIZRID"));	 			//도매업자 ID
		map.put("CUST_BIZRNO", map.get("WHSDL_BIZRNO_ORI"));	//도매업자 사업자번호
		map.put("CUST_BRCH_ID", map.get("WHSDL_BRCH_ID"));		//도매업자 지점 ID
		map.put("CUST_BRCH_NO", map.get("WHSDL_BRCH_NO"));	//도매업자 지점번호
		map.put("RTN_DT", map.get("CRCT_RTN_DT"));						//빈용기 조회기준
	
		try {
			String bizrTpCd = util.null2void(commonceService.bizr_tp_cd_select(request, map), ""); //빈용기 구분 조회
			
			map.put("BIZR_TP_CD", bizrTpCd);
			map.put("CTNR_SE", "2");																	//빈용기 구분  구병/신병
			
			if(map.get("BIZR_TP_CD").equals("W1") ){
				map.put("PRPS_CD", "0");																//빈용기 구분   	도매업자구분이 도매업자(W1)일경우 유흥/가정으로
			}
			else if(map.get("BIZR_TP_CD").equals("W2") ){
				map.put("PRPS_CD", "2");																//빈용기 구분		도매업자구분이 공병상(W2)일경우 직접반환하는자로
			}
			else {
				map.put("PRPS_CD", "X");																//빈용기 구분
			}
			
			List<?> ctnr_se			= commonceService.getCommonCdListNew("E005");		//빈용기구분 구/신
			List<?> ctnr_seList		= commonceService.ctnr_se_select(request, map);						//빈용기구분 유흥/가정/직접 조회
			List<?> iniList			= epce4738731Mapper.epce4738731_select(map);		//상세내역 조회
			List<?> cfm_gridList 	= epce4738731Mapper.epce4738731_select2(map);		// 입고정보	 그리드쪽 조회 
			List<?> crct_gridList 	= epce4738731Mapper.epce4738742_select(map);		// 입고정정  그리드쪽 조회 
			List<?> ctnr_nm			= commonceService.ctnr_cd_select(map);					//빈용기명 조회
			List<?> rmk_list		= commonceService.getCommonCdListNew("D025");	//소매수수료 적용여부 비고

			model.addAttribute("INQ_PARAMS",jParams);
			model.addAttribute("titleSub", title);
			model.addAttribute("iniList", util.mapToJson(iniList));	
			model.addAttribute("cfm_gridList", util.mapToJson(cfm_gridList));
			model.addAttribute("crct_gridList", util.mapToJson(crct_gridList));
			model.addAttribute("ctnr_se", util.mapToJson(ctnr_se));	
			model.addAttribute("ctnr_seList", util.mapToJson(ctnr_seList));	
			model.addAttribute("ctnr_nm", util.mapToJson(ctnr_nm));
			model.addAttribute("rmk_list", util.mapToJson(rmk_list));	
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	
		return model;    	
    }
  
    
	/**
	 * 입고정정등록  수정
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4738742_update(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		//Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		List<?> list_ori = JSONArray.fromObject(inputMap.get("list_ori"));
		
		if (list != null) {
			try {
				
				// 각종 체크
				Map<String, String> check = (Map<String, String>) list.get(0);
				
				/* 
				 * 20180823, 이근표 : 사업관리팀 곽명진팀장 요청
				int sel = epce4738731Mapper.epce4738731_select5(check); // 수량 체크
				if(sel != 1){
					throw new Exception("A016"); 
				}
				 */
				
				int sel = epce4738731Mapper.epce4738731_select6(check); // 적용기간 체크
				if(sel >0 ){
					throw new Exception("A017"); 
				}

				List<?>  gridList	= util.mapToJson(epce4738731Mapper.epce4738742_select(check));// 입고정정 초기 값 데이터 비교
				//System.out.println("gridList :  " +gridList.size()  +  "  :  list_ori  :" +list_ori.size() );
				if(list_ori.size() ==gridList.size() ){
					for(int k =0;k<list_ori.size();k++){
						Map<String, String> list_ori_map = new HashMap<String, String>();
						Map<String, String> gridList_map = new HashMap<String, String>();
						list_ori_map = (Map<String, String>) list_ori.get(k);
						gridList_map = (Map<String, String>) gridList.get(k);
						 
						list_ori_map.put("rm_internal_uid", "");
						list_ori_map.put("ADD_FILE", "");
						gridList_map.put("rm_internal_uid", "");
						gridList_map.put("ADD_FILE", "");
						 
						if(!list_ori_map.toString().equals(gridList_map.toString())){
							throw new Exception("A008");   //변조된 데이터
						}
					}										
				}else{
						 throw new Exception("A008");   //변조된 데이터
				}
				
				epce4738731Mapper.epce4738742_delete(check); // 입고정정 삭제
				
				//입고정정등록 실행
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("UPD_PRSN_ID", vo.getUSER_ID());  						// 등록자     ,REG_PRSN_ID :최초등록자
					epce4738731Mapper.epce4738731_insert(map); 					// 입고정정 등록
				}//end of for
		 	
			} catch (Exception e) {
				if(e.getMessage().equals("A008") || e.getMessage().equals("A014") || e.getMessage().equals("A016")  || e.getMessage().equals("A017") ){
					throw new Exception(e.getMessage()); 
				}else{
					throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			}
		}//end of list
		return errCd;
    }   
	    
/***************************************************************************************************************************************************************************************
 * 	 입고내역선택 
****************************************************************************************************************************************************************************************/
	    	
	/**
	 * 입고내역선택  초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce47387642_select(ModelMap model, HttpServletRequest request) {

	    //파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
	    
	//	Map<String, String> map= new HashMap<String, String>();
		Map<String, String> map = util.jsonToMap(jParams.getJSONObject("EXCA_PARAM"));
	 	
		List<?>	mfc_bizrnmList =null; 
		if(map.get("EXCA_TRGT_SE").equals("I")){
			mfc_bizrnmList =commonceService.std_mgnt_mfc_select(request, map);			//정산기간중인 생산자
		}else{
			mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); 	 				//모든생산자
		}
		List<?> std_mgnt_list 	= commonceService.std_mgnt_select(request, map);					//정산기간
		List<?> whsl_se_cdList	= commonceService.whsdl_se_select(request, map);  		 		//도매업자구분
		String   title					= commonceService.getMenuTitle("EPCE47387642");		//타이틀
		List<?> whsdlList			= commonceService.mfc_bizrnm_select4(request, map);    			//도매업자 업체명조회
		
		//상세 들어갔다가 다시 관리 페이지로 올경우
		Map<String, String> paramMap = new HashMap<String, String>();

		try {
			if(jParams.get("SEL_PARAMS") !=null){//상세 볼경우
				JSONObject param2 =(JSONObject)jParams.get("SEL_PARAMS");
				if(param2.get("MFC_BIZRID") !=null){	//생산자사업자 선택시
					paramMap.put("BIZRNO", param2.get("MFC_BIZRNO").toString());					//생산자ID
					paramMap.put("BIZRID", param2.get("MFC_BIZRID").toString());					//생산자 사업자번호
					List<?> brch_nmList = commonceService.brch_nm_select(request, paramMap);	 	  	//사업자 직매장/공장 조회	
					model.addAttribute("brch_nmList", util.mapToJson(brch_nmList));	
				}
			}
			
			model.addAttribute("std_mgnt_list", util.mapToJson(std_mgnt_list));  		//정산기준관리 조회 
			model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));		
			model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));	
			model.addAttribute("whsdlList", util.mapToJson(whsdlList));	
			model.addAttribute("titleSub", title);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	
		
		return model;    	
    }
  
	/**
	 * 입고내역선택 생산자변경시  생산자에맞는 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce47387642_select2(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	try {
	      		rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 생산자랑 거래중인 도매업자 업체명조회
		    	inputMap.put("BIZR_TP_CD", "");
				rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, inputMap)));	 //사업자 직매장/공장 조회	
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	 
    	
		return rtnMap;    	
    }
  
	/**
	 *  생산자 직매장/공장 선택시  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce47387642_select3(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    		try {
				rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap))); //업체명 조회	
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	 
		return rtnMap;    	
    }
	
	/**
	 *  도매업자 구분 선택시 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce47387642_select4(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	try {
    		rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 생산자랑 거래중인 도매업자 업체명조회
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
    	return rtnMap;    	
    }

	/**
	 *  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce47387642_select5(Map<String, Object> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    		try {
    			
    			List<?> list = JSONArray.fromObject(inputMap.get("MFC_BIZRNM_RETURN"));
    			inputMap.put("MFC_BIZRNM_RETURN", list);  
    			
				rtnMap.put("selList", util.mapToJson(epce4738731Mapper.epce47387642_select  (inputMap)));
				rtnMap.put("totalCnt", epce4738731Mapper.epce47387642_select_cnt(inputMap));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	  
    	return rtnMap;    	
    }
}