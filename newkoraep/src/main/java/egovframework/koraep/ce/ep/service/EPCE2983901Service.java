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
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE2983901Mapper;

/**
 * 입고관리 Service
 * @author 양성수
 *
 */
@Service("epce2983901Service")
public class EPCE2983901Service {  
	
	
	@Resource(name="epce2983901Mapper")
	private EPCE2983901Mapper epce2983901Mapper;  //입고관리 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 입고관리 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce2983901_select(ModelMap model, HttpServletRequest request) {
		  
		  
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
		    
			Map<String, String> map= new HashMap<String, String>();
			List<?> dtList				= commonceService.getCommonCdListNew("D022");	//반환등록일자구분
			List<?> stat_cdList		= commonceService.getCommonCdListNew("D021");	//상태
			List<?> mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); 	 				//생산자
			List<?> whsl_se_cdList	= commonceService.whsdl_se_select(request, map);  		 		//도매업자구분
			List<?> sys_seList		= commonceService.getCommonCdListNew("S004");		//등록구분
			List<?> areaList			= commonceService.getCommonCdListNew("B010");		//지역
			String   title					= commonceService.getMenuTitle("EPCE2983901");		//타이틀
			List<?>	whsdlList		= commonceService.mfc_bizrnm_select4(request, map);    			// 생산자랑 거래중인 도매업자 업체명조회
			String   detail 				= "F";
			List<?> grid_info			= commonceService.GRID_INFO_SELECT("EPCE2983901",request);		//그리드 컬럼 정보
			
			//반환내역상세 들어갔다가 다시 관리 페이지로 올경우
			Map<String, String> paramMap = new HashMap<String, String>();
	
			try {
				if(jParams.get("SEL_PARAMS") !=null){//반환상세 볼경우
					JSONObject param2 =(JSONObject)jParams.get("SEL_PARAMS");
					if(param2.get("MFC_BIZRID") !=null){	//생산자사업자 선택시
						paramMap.put("BIZRNO", param2.get("MFC_BIZRNO").toString());					//생산자ID
						paramMap.put("BIZRID", param2.get("MFC_BIZRID").toString());					//생산자 사업자번호
						List<?> brch_nmList = commonceService.brch_nm_select(request, paramMap);	 	  	//사업자 직매장/공장 조회	
						model.addAttribute("brch_nmList", util.mapToJson(brch_nmList));	
					}
						detail = "T"; 
				}
				model.addAttribute("grid_info", util.mapToJson(grid_info));
				model.addAttribute("dtList", util.mapToJson(dtList));	
				model.addAttribute("sys_seList", util.mapToJson(sys_seList));	
				model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));		
				model.addAttribute("stat_cdList", util.mapToJson(stat_cdList));	
				model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));	
				model.addAttribute("whsdlList", util.mapToJson(whsdlList));	
				model.addAttribute("areaList", util.mapToJson(areaList));
				model.addAttribute("titleSub", title);
				model.addAttribute("detail", detail);

			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	
			
			return model;    	
	    }
	  
		/**
		 * 입고관리 생산자변경시  생산자에맞는 직매장 조회  ,업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce2983901_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	try {
		      		rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap))); // 생산자랑 거래중인 도매업자 업체명조회
			    	inputMap.put("BIZR_TP_CD", "");
					rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, inputMap)));	 //사업자 직매장/공장 조회	
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	 
	    	
			return rtnMap;    	
	    }
	  
		/**
		 * 입고관리 생산자 직매장/공장 선택시  업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce2983901_select3(Map<String, String> inputMap, HttpServletRequest request) {
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
		 * 입고관리 도매업자 구분 선택시 업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce2983901_select4(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
		      		rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap))); // 생산자랑 거래중인 도매업자 업체명조회
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}
	    	
	    	return rtnMap;    	
	    }
	
		/**
		 * 입고관리  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce2983901_select5(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null ){
				inputMap.put("T_USER_ID", vo.getUSER_ID());
			}
	    	
	    		try {
					rtnMap.put("selList", util.mapToJson(epce2983901Mapper.epce2983901_select4(inputMap)));
					rtnMap.put("totalList", util.mapToJson(epce2983901Mapper.epce2983901_select4_cnt(inputMap)));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	  
	    	return rtnMap;    	
	    }
		
		/**
		 * 입고관리 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epce2983901_excel(HashMap<String, String> data, HttpServletRequest request) {
			
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null ){
				data.put("T_USER_ID", vo.getUSER_ID());
			}
			
			String errCd = "0000";
			try {
						
				List<?> list = epce2983901Mapper.epce2983901_select4(data);
				//엑셀파일 저장
				commonceService.excelSave(request, data, list);
			}catch(Exception e){
				return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			return errCd;
		}	
		
		/**
		 * 입고관리  반환상태 변경
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epce2983901_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {

			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			String reqRsn = "";
			if(inputMap.containsKey("REQ_RSN")){
				reqRsn = inputMap.get("REQ_RSN"); //사유
			}
	
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String rsrc_doc_no ="";
			
			if (list != null) {  // 중복, 상태 확인
				for(int i=0; i<list.size(); i++){
					map = (Map<String, String>) list.get(i);
					int stat = epce2983901Mapper.epce2983901_select5(map); //상태 체크
					 if(stat>0){
						return "A012"; //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
					 }
				}
			}	
			
			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);
						map.put("UPD_PRSN_ID", vo.getUSER_ID());  									//등록자
						
						//실태조사일경우 실태조사 테이블에 등록
						if(map.get("RTN_STAT_CD").equals("RR")){
							String doc_psnb_cd ="RC"; 								   						//	RC 실태조사
							rsrc_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	//문서번호 가져오기
							map.put("RSRC_DOC_NO", rsrc_doc_no);					//	문서채번
							map.put("REQ_ID", vo.getUSER_ID());  						//요청자
							map.put("REQ_BIZRID", vo.getBIZRID());  					//요청지점ID	
							map.put("REQ_BIZRNO", vo.getBIZRNO_ORI());  				//요청지점번호	
							map.put("REQ_BRCH_ID", vo.getBRCH_ID());  			//요청사업자ID	
							map.put("REQ_BRCH_NO", vo.getBRCH_NO());  		//요청사업자등록번호	
							map.put("REQ_BIZR_TP_CD", vo.getBIZR_TP_CD());  	//요청회원구분코드	
							epce2983901Mapper.epce2983901_insert3(map); 		//실태조사요청정보 테이블에 등록
						}
						
						//실태조사중 반환등록 상태인경우 입고등록 이 안되있어서 반환내역서에만 반환상태 변경
						epce2983901Mapper.epce2983901_update(map); 	// 반환내역서 반환상태 변화

						if(map.get("CFM_CHECK").equals("T")){
							//입고조정 및 입고확인은 입고등록이 되어있어서 입고내역서도 반환상태 변경을 해야한다.
							epce2983901Mapper.epce2983901_update2(map); 	// 입고내역서 반환상태 변화
						}
						
						//취소요청 사유저장
						if(map.containsKey("CNL_REQ_YN") && map.get("CNL_REQ_YN").equals("Y")){
							map.put("REQ_RSN", reqRsn);
							epce2983901Mapper.epce29839884_insert(map);
							
							if(map.get("RTN_STAT_CD").equals("FC") &&  i == 0){ //취소요청시 한번만 보냄
								
								//commonceService.send_anc("B5000001"); //센터 업무담당자에게 알림 보내기
							}
						}
						
					}
				}catch (Exception e) {
					throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			}return errCd;    	
	    }
		
		/**
		 * 입고관리  일괄확인
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epce2983901_update2(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();
			String errCd = "0000";
			String wrhs_doc_no ="";
			
			if (list != null) {  // 중복, 상태 확인
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = (Map<String, String>) list.get(i);
					int stat = epce2983901Mapper.epce2983901_select5(map); //상태 체크
					 if(stat>0){
						return "A012"; //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
					 }
				}
			}	
			
			if (list != null) {
				try {
					
					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>) list.get(i);
						map.put("REG_PRSN_ID", vo.getUSER_ID());  								//등록자
						map.put("UPD_PRSN_ID", vo.getUSER_ID());  								//등록자

			 			//master
						String doc_psnb_cd ="IN"; 								   						//	RT :반환문서 ,IN :입고문서
				 		wrhs_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	//	입고문서번호 조회
						map.put("WRHS_DOC_NO", wrhs_doc_no);									//	문서채번
						
						//상태 먼저 변경함.. 데이터 변조 대비
						epce2983901Mapper.epce2983901_update4(map); 			//반환 마스터  상태변경
						
						epce2983901Mapper.epce2983901_insert(map); 				//	입고마스터	  등록

						//detail
				 		epce2983901Mapper.epce2983901_insert2(map); 			// 입고상세
				 		list2.add(map); //list2에는 마스터에 등록된 문서 번호가 저장. 나중에 문서번호로만 업로드
						 
					}//end of for
					
				 	for(int j=0 ;j<list2.size(); j++){
				 		Map<String, String> map_list2 = (Map<String, String>) list2.get(j);
				 		map_list2.put("UPD_PRSN_ID", vo.getUSER_ID());  					//수정자
				 		epce2983901Mapper.epce2983901_update3(map_list2);			//입고 마스터 총값 넣기
				 		//epce2983901Mapper.epce2983901_update4(map_list2); 			//반환 마스터  상태변경
				 	}
					
				} catch (Exception e) {
					throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			}//end of list
			return errCd;   
		}
		
		//---------------------------------------------------------------------------------------------------------------------
		//	입고상세 페이지 
		//---------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 입고관리 상세조회 초기 화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epce2983964_select(ModelMap model, HttpServletRequest request) {
			  
			 	Map<String, String> map = new HashMap<String, String>();
			    
			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				JSONObject jParams2 =(JSONObject)jParams.get("PARAMS");
				
				/*
				map.put("MFC_BIZRID", jParams2.get("MFC_BIZRID").toString());				//생산자ID
				map.put("MFC_BIZRNO", jParams2.get("MFC_BIZRNO").toString());			//생산자 사업자번호
				map.put("MFC_BRCH_ID", jParams2.get("MFC_BRCH_ID").toString());			//생산자 지사 ID
				map.put("MFC_BRCH_NO", jParams2.get("MFC_BRCH_NO").toString());		//생산자 지사 번호
				map.put("WHSDL_BIZRID", jParams2.get("WHSDL_BIZRID").toString());	 	//도매업자 ID
				map.put("WHSDL_BIZRNO", jParams2.get("WHSDL_BIZRNO").toString());	//도매업자 사업자번호
           		*/
				
				map.put("RTN_DOC_NO", jParams2.get("RTN_DOC_NO").toString());		 	// 반환문서번호  
				map.put("WRHS_DOC_NO", jParams2.get("WRHS_DOC_NO").toString());		// 입고문서번호
				
				String   title					= commonceService.getMenuTitle("EPCE2983964");		//타이틀
				List<?> iniList				= epce2983901Mapper.epce2983964_select(map);		//상세내역 조회
				List<?> rtn_gridList			= epce2983901Mapper.epce2983964_select2(map);		//반환 그리드쪽 조회
				List<?> cfm_gridList		= epce2983901Mapper.epce2983964_select3(map);		//입고 그리드쪽 조회
				    
				try {   
					model.addAttribute("INQ_PARAMS",jParams);
					model.addAttribute("iniList", util.mapToJson(iniList));	
					model.addAttribute("rtn_gridList", util.mapToJson(rtn_gridList));	
					model.addAttribute("cfm_gridList", util.mapToJson(cfm_gridList));
					model.addAttribute("titleSub", title);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	
				

				return model;    	
		    }
		  
		  /**
			 * 입고관리  조정확인후 다시 상태값 셋팅
			 * @param inputMap
			 * @param request
			 * @return
			 * @
			 */
			public HashMap epce2983964_select2(Map<String, String> inputMap, HttpServletRequest request) {
		    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		    		try {
						rtnMap.put("iniList", util.mapToJson(epce2983901Mapper.epce2983964_select  (inputMap)));
					} catch (Exception e) {
						// TODO Auto-generated catch block
						org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
					}	  
				return rtnMap;    	
		    }
		  
			/**
			 * 입고관리 상세내역  조정확인   입고조정 >> 입고확인
			 * @param inputMap
			 * @param request
			 * @return
			 * @throws Exception 
			 * @
			 */
			public String epce2983964_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
				String errCd = "0000";
				Map<String, String> map;
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				
					try {
							int stat = epce2983901Mapper.epce2983901_select5(inputMap); //상태 체크
							 if(stat>0){
								throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
							 }
							inputMap.put("UPD_PRSN_ID", vo.getUSER_ID());  				// 등록자
							inputMap.put("WRHS_CFM_DT_IN", "T");  						// 입고문서 입고확인일자 등록
							epce2983901Mapper.epce2983901_update2(inputMap); 	// 입고내역서 반환상태 변화
							epce2983901Mapper.epce2983901_update4(inputMap); 	// 반환내역서 반환상태 변화
							
					}catch (Exception e) {
						 if(e.getMessage().equals("A012")){
							 throw new Exception(e.getMessage()); 
						 }else{
							 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
						 }
					}  
				return errCd;    	  
		    }      
			
			/**     
			 * 입고관리 상세내역  입고확인취소   반환상태로 변경 입고삭제 관련 사진 삭제
			 * @param inputMap
			 * @param request
			 * @return
			 * @throws Exception 
			 * @   
			 */    
			public String epce2983964_update2(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
				String errCd = "0000";  
				Map<String, String> map;           
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				List<?> list = JSONArray.fromObject(inputMap.get("list"));        
				if (list != null) {                
						try {       
								for(int i=0; i<list.size(); i++){
										map = (Map<String, String>) list.get(i);
										int stat = epce2983901Mapper.epce2983901_select5(map); //상태 체크
										if(stat>0){
											throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
										}
										inputMap.put("UPD_PRSN_ID", vo.getUSER_ID());  		//등록자
										
										epce2983901Mapper.epce2983964_update(map); 	//반환내역서 반환상태 변화

										map.put("PRCS_ID"    ,vo.getUSER_ID());
										map.put("REQ_STAT_CD","C");
										epce2983901Mapper.epce2983964_update2(map); 	//입고확인취소요청정보 요청상태코드 변경
										
										epce2983901Mapper.epce2983964_delete(map); 		//입고증빙파일 테이블 삭제
										
										epce2983901Mapper.epce2983964_delete2(map); 	//입고상세 테이블 삭제
										
										epce2983901Mapper.epce2983964_delete3(map); 	//입고마스터 테이블 삭제
										
										if(map.get("RSRC_DOC_NO") !=null){
											epce2983901Mapper.epce2983964_delete4(map);	//실태조사증빙파일 테이블 삭제
											epce2983901Mapper.epce2983964_delete5(map);	//실태조사요청정보 테이블 삭제
										}
								}  
						}catch (Exception e) {
							 if(e.getMessage().equals("A012")){
								 throw new Exception(e.getMessage()); 
							 }else{
								 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
							 }
						}
					
				}return errCd;    	//end of if (list != null)
		    }
			
	//---------------------------------------------------------------------------------------------------------------------
	//	 조사확인요청사유서 (도매업자);
	//---------------------------------------------------------------------------------------------------------------------
		  /**
		 *  조사확인요청사유서 (도매업자) 초기값
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce2983988_select(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		String   title					= commonceService.getMenuTitle("EPCE2983988");		//타이틀
	    		rtnMap.put("titleSub", title);	
			return rtnMap;    	
	    }	
		
		/**
		 *  조사확인요청사유서 (도매업자)  저장
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epce2983988_insert(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			
				try {
						String doc_psnb_cd ="RC"; 								   									//	RC 실태조사
						String rsrc_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);		// 문서번호 가져오기
						inputMap.put("BIZRID", vo.getBIZRID());  													// 사업자ID
						inputMap.put("BIZRNO", vo.getBIZRNO_ORI());  										// 사업자번호
						inputMap.put("BRCH_ID", vo.getBRCH_ID());  											// 지점ID
						inputMap.put("BRCH_NO", vo.getBRCH_NO());  										// 지점번호
						inputMap.put("BIZR_TP_CD", vo.getBIZR_TP_CD());										// 요청회원구분코드
						inputMap.put("REG_PRSN_ID", vo.getUSER_ID());  										// 등록자
						inputMap.put("RTN_STAT_CD","SW" );  													// 실태조사요청(도매업자)상태
						inputMap.put("RSRC_DOC_NO", rsrc_doc_no);											//	문서채번
						epce2983901Mapper.epce2983988_insert(inputMap);								// 실태조사요청 저장
						epce2983901Mapper.epce2983988_update(inputMap);							// 반환관리,입고관리 반환상태 조사요청으로 변경
												
				}catch (Exception e) {
					throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			return errCd;    	
	    }
			
			
	//---------------------------------------------------------------------------------------------------------------------
	//	증빙사진 페이지
	//---------------------------------------------------------------------------------------------------------------------
		  
		  /**
			 * 입고관리상세에서 증빙사진 조회
			 * @param inputMap
			 * @param request
			 * @return
			 * @
			 */
			public HashMap epce29839883_select(Map<String, String> inputMap, HttpServletRequest request) {
		    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		    		String   title					= commonceService.getMenuTitle("EPCE29839883");		//타이틀
		    		try {
						rtnMap.put("selList", util.mapToJson(epce2983901Mapper.epce29839883_select (inputMap)));
					} catch (Exception e) {
						// TODO Auto-generated catch block
						org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
					}
		    		rtnMap.put("titleSub", title);	
				return rtnMap;    	
		    }
		
		
}
