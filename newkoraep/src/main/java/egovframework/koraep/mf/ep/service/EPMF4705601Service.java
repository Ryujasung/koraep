package egovframework.koraep.mf.ep.service;

import java.io.IOException;
import java.sql.SQLException;
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
import egovframework.mapper.mf.ep.EPMF4705601Mapper;

/**
 * 수기입고정정 Service
 * @author 양성수
 *
 */
@Service("epmf4705601Service")
public class EPMF4705601Service {
	
	@Resource(name="epmf4705601Mapper")
	private EPMF4705601Mapper epmf4705601Mapper;  //수기입고정정  Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 수기입고정정  초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epmf4705601_select(ModelMap model, HttpServletRequest request) {
		  
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
		    
			Map<String, String> map= new HashMap<String, String>();
			   
			//상세 들어갔다가 다시 관리 페이지로 올 경우
			Map<String, String> paramMap = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
			try {
						if(jParams.get("SEL_PARAMS") !=null){//상세 볼경우
								if(paramMap.get("EXCA_STD_CD") !=null){//정산기준일자 선택시 생산자 리스트
								
									if(paramMap.get("EXCA_TRGT_SE").equals("W")	){
										List<?>	mfc_bizrnmList =commonceService.mfc_bizrnm_select(request);//모든생산자
										model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));	
									}else{
										List<?>	mfc_bizrnmList =commonceService.std_mgnt_mfc_select(request, paramMap);	//정산기간중인 생산자
										model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));	
									}
								}
								if(paramMap.get("MFC_BIZRID") !=null){//생산자사업자 선택시
									paramMap.put("BIZRNO", paramMap.get("MFC_BIZRNO"));					//생산자ID
									paramMap.put("BIZRID", paramMap.get("MFC_BIZRID"));						//생산자 사업자번호
									model.addAttribute("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, paramMap)));	
								}
						}
						
						model.addAttribute("std_mgnt_list", util.mapToJson(commonceService.std_mgnt_select(request, map)));  	//정산기준관리 조회
						model.addAttribute("stat_cdList", util.mapToJson(commonceService.getCommonCdListNew("C002")));			//상태
						model.addAttribute("whsl_se_cdList", util.mapToJson(commonceService.whsdl_se_select(request, map)));  //도매업자 구분
						model.addAttribute("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, map)));		//도매업자 업체명조회	
						model.addAttribute("titleSub", commonceService.getMenuTitle("EPMF4705601"));										//타이틀
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
		 * 수기입고정정 정산기준날짜 변경시 생산자 리스트
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf4705601_select5(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	try {
	    		
	    		if(inputMap.get("EXCA_TRGT_SE").equals("W")	){
					rtnMap.put("mfc_bizrnmList", util.mapToJson(commonceService.mfc_bizrnm_select(request))); //모든 생산자
	    		}else{	
	    			rtnMap.put("mfc_bizrnmList", util.mapToJson(commonceService.std_mgnt_mfc_select(request, inputMap))); 
	    		}
					
			} catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	 	 
			return rtnMap;    	
	    }
		
		/**
		 * 진행중인 정산기간 존재 여부 체크
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf4705601_select6(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	try {
	    		rtnMap.put("chkCnt", epmf4705601Mapper.epmf4705601_select7(inputMap));
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
		 * 빈용기구분코드 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf4705601_select7(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
	    		String bizrTpCd = util.null2void(commonceService.bizr_tp_cd_select(request, inputMap), ""); //빈용기 구분 조회
	    		
	    		inputMap.put("BIZR_TP_CD", bizrTpCd);
	    		
				rtnMap.put("bizr_tp_cd", bizrTpCd); //사업자유형코드
				rtnMap.put("ctnr_seList", util.mapToJson(commonceService.ctnr_se_select(request, inputMap))); //빈용기 구분 조회
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
		 * 수기입고정정 생산자변경시  생산자에맞는 직매장 조회  ,업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf4705601_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
			      	rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));   //도매업자 업체명조회
			      	inputMap.put("BIZR_TP_CD", "");
			      	rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, inputMap)));
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	 	 //사업자 직매장/공장 조회	
			return rtnMap;    	
	    }
	  
		/**
		 * 수기입고정정  생산자 직매장/공장 선택시  업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf4705601_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
					rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	  //업체명 조회	
			return rtnMap;    	
	    }
	
		/**
		 * 수기입고정정 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf4705601_select4(Map<String, Object> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
	    			
	    			HttpSession session = request.getSession();
	    			UserVO vo = (UserVO) session.getAttribute("userSession");
	    			inputMap.put("MFC_BIZRID", vo.getBIZRID());
	    			inputMap.put("MFC_BIZRNO", vo.getBIZRNO_ORI());
	    			
	    			List<?> list = JSONArray.fromObject(inputMap.get("MFC_BIZRNM_RETURN"));
	    			inputMap.put("MFC_BIZRNM_RETURN", list);  
					rtnMap.put("selList", util.mapToJson(epmf4705601Mapper.epmf4705601_select4(inputMap)));
					rtnMap.put("totalList", epmf4705601Mapper.epmf4705601_select4_cnt(inputMap));
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
		 * 수기입고정정 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epmf4705601_excel(HashMap<String, Object> data, HttpServletRequest request) {
			
			String errCd = "0000";
			try {
						
				HttpSession session = request.getSession();
    			UserVO vo = (UserVO) session.getAttribute("userSession");
    			data.put("MFC_BIZRID", vo.getBIZRID());
    			data.put("MFC_BIZRNO", vo.getBIZRNO_ORI());
				
				List<?> list2 = JSONArray.fromObject(data.get("MFC_BIZRNM_RETURN"));
    			data.put("MFC_BIZRNM_RETURN", list2);  
    			
				List<?> list = epmf4705601Mapper.epmf4705601_select4(data);
				
				//object라 String으로 담아서 보내기
				HashMap<String, String> map = new HashMap<String, String>(); 
				map.put("fileName", data.get("fileName").toString());
				map.put("columns", data.get("columns").toString());
				
				//엑셀파일 저장
				commonceService.excelSave(request, map, list);
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch(Exception e){
				return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			return errCd;
		}	
		
		/**
		 * 수기입고정정  수기입고정정  정정확인,정정반려,확인취소 상태 변경
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epmf4705601_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			
			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);
						int stat = epmf4705601Mapper.epmf4705601_select6(map); //상태 체크
						 if(stat>0){
							throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						 }
						 map.put("REG_PRSN_ID", vo.getUSER_ID());  		//등록자
						 epmf4705601Mapper.epmf4705601_update(map);//수기입고정정  정정확인,정정반려,확인취소 상태 변경
					}
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				}catch (Exception e) {
					if(e.getMessage().equals("A012") ){
						 throw new Exception(e.getMessage()); 
					 }else{
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					 }
				}
			}
			
			return errCd;    	
	    }
	
		//---------------------------------------------------------------------------------------------------------------------
		//	수기입고정정 내역조회
		//---------------------------------------------------------------------------------------------------------------------
					
		/**
		 * 입고관리 상세조회 초기 화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epmf4705664_select(ModelMap model, HttpServletRequest request) {
			  
			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
				
				String   title					= commonceService.getMenuTitle("EPMF4705664");		//타이틀
				List<?> iniList				= epmf4705601Mapper.epmf4705664_select(map);		//상세내역 조회
				List<?> cfm_gridList		= null;
				if(map.containsKey("WRHS_CRCT_DOC_NO")){
					cfm_gridList = epmf4705601Mapper.epmf4705664_select2(map);		//입고 그리드쪽 조회
				}
				List<?> crct_gridList		= epmf4705601Mapper.epmf4705664_select3(map);		//수기입고정정 그리드쪽 조회
				
				try {
					model.addAttribute("INQ_PARAMS",jParams);
					model.addAttribute("iniList", util.mapToJson(iniList));	
					model.addAttribute("cfm_gridList", util.mapToJson(cfm_gridList));	
					model.addAttribute("crct_gridList", util.mapToJson(crct_gridList));
					model.addAttribute("titleSub", title);
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
			 * 수기입고정정내역조회 삭제
			 * @param inputMap
			 * @param request
			 * @return
		 * @throws Exception 
			 * @
			 */
			public String epmf4705664_delete(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
				
				String errCd = "0000";
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");

				try {
					 int stat = epmf4705601Mapper.epmf4705601_select5(inputMap); //상태 체크
					 if(stat>0){
							throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
					 }
					 
					 inputMap.put("UPD_PRSN_ID", vo.getUSER_ID());
					 epmf4705601Mapper.epmf4705664_delete(inputMap); 	// 수기입고정정테이블 삭제
					 
					 if(inputMap.containsKey("WRHS_DOC_NO")){//문서번호가 없는건 수기등록임..
						 epmf4705601Mapper.epmf4705664_update(inputMap); 	// 연결정정문서번호 삭제
					 }
					 
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				}catch(Exception e){
					if(e.getMessage().equals("A012") ){
						 throw new Exception(e.getMessage()); 
					 }else{
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					 }
				}
				return errCd;
				
		    }
			
			
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
				  public ModelMap epmf4705631_select(ModelMap model, HttpServletRequest request) {

					  	//파라메터 정보
						String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
						JSONObject jParams = JSONObject.fromObject(reqParams);
						String title = commonceService.getMenuTitle("EPMF4705631"); //타이틀
					
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
							List<?> ctnr_seList		= commonceService.ctnr_se_select(request, map);		//빈용기구분 유흥/가정/직접 조회
							List<?> iniList			= epmf4705601Mapper.epmf4705631_select(map);		//상세내역 조회
							List<?> cfm_gridList 	= epmf4705601Mapper.epmf4705631_select2(map);		//그리드쪽 조회 입고정정 데이터
							List<?> ctnr_nm			= commonceService.ctnr_cd_select(map);					//빈용기명 조회
							List<?> rmk_list			= commonceService.getCommonCdListNew("D025");		//소매수수료 적용여부 비고

							model.addAttribute("INQ_PARAMS",jParams);
							model.addAttribute("titleSub", title);
							model.addAttribute("iniList", util.mapToJson(iniList));	
							model.addAttribute("cfm_gridList", util.mapToJson(cfm_gridList));	
							model.addAttribute("ctnr_se", util.mapToJson(ctnr_se));	
							model.addAttribute("ctnr_seList", util.mapToJson(ctnr_seList));	
							model.addAttribute("ctnr_nm", util.mapToJson(ctnr_nm));
							model.addAttribute("rmk_list", util.mapToJson(rmk_list));	
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
					 * 입고정정 빈용기명
					 * @param inputMap
					 * @param request
					 * @return
					 * @
					 */
					public HashMap epmf4705631_select2(Map<String, String> inputMap, HttpServletRequest request) {
				    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
				    	try {
							rtnMap.put("ctnr_nm", util.mapToJson(commonceService.ctnr_cd_select(inputMap)));
						}catch (IOException io) {
							System.out.println(io.toString());
						}catch (SQLException sq) {
							System.out.println(sq.toString());
						}catch (NullPointerException nu){
							System.out.println(nu.toString());
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
					public String epmf4705631_insert(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
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
											/*
											 int sel = epmf4705601Mapper.epmf4705631_select6(check); // 적용기간 체크
											 if(sel >0 ){
												 throw new Exception("A017"); 
											 }
											 */
											 
											int sel = epmf4705601Mapper.epmf4705631_select5(check); // 수량 체크
												if(sel != 1){
													 throw new Exception("A016"); 
											}
											
											List<?>  gridList	= util.mapToJson(epmf4705601Mapper.epmf4705631_select2(check));// 입고정보 초기 값 데이터 비교
											//System.out.println("gridList :  " +gridList.size()  +  "  :  list_ori  :" +list_ori.size() );
											if(list_ori.size() == gridList.size() ){
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
											
											wrhs_crct_doc_no = commonceService.doc_psnb_select("IC"); //	입고정정문서번호
											    
											//입고정정 재등록 실행
											for(int i=0; i<list.size(); i++){
												Map<String, String> map = (Map<String, String>) list.get(i);
												/*
												sel = epmf4705601Mapper.epmf4705631_select4(map); //중복 체크 
												if(sel>0){
													throw new Exception("A014"); 
												}
												*/
												
												if(vo != null){
													map.put("REG_PRSN_ID", vo.getUSER_ID()); // 등록자
												}
												
												map.put("MNUL_EXCA_SE", "R");
												map.put("WRHS_CRCT_DOC_NO_RE", wrhs_crct_doc_no); // 문서채번

												epmf4705601Mapper.epmf4705631_insert(map); // 입고정정 등록
												
												
												if(flag){ //한번만 실행
													epmf4705601Mapper.epmf4705631_update(map);	//연결입고정정문서번호 업데이트
													flag = false;
												}
												
												
											}//end of for
								 	
									}catch (IOException io) {
										System.out.println(io.toString());
									}catch (SQLException sq) {
										System.out.println(sq.toString());
									}catch (NullPointerException nu){
										System.out.println(nu.toString());
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
			 * 	 수기정산등록
			****************************************************************************************************************************************************************************************/
				    		 		    
			    /**
				 * 수기정산등록 초기화면
				 * @param inputMap
				 * @param request
				 * @return
				 * @
				 */
				  public ModelMap epmf47056312_select(ModelMap model, HttpServletRequest request) {
					  
					  	//파라메터 정보
						String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
						JSONObject jParams = JSONObject.fromObject(reqParams);
						model.addAttribute("INQ_PARAMS",jParams);
						Map<String, String> map = util.jsonToMap(jParams.getJSONObject("EXCA_PARAM"));
						Map<String, String> map2 = new HashMap<String, String>();
						
						List<?>	mfc_bizrnmList =null; 
						if(map.get("EXCA_TRGT_SE").equals("I")){
							mfc_bizrnmList =commonceService.std_mgnt_mfc_select(request, map);					//정산기간중인 생산자
						}else{
							mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); 	 						//모든생산자
						}
						List<?> std_mgnt_list 	= commonceService.std_mgnt_select(request, map2);				//정산기간
						
						String title = commonceService.getMenuTitle("EPMF47056312");	 

						List<?> ctnr_se_list		= commonceService.getCommonCdListNew("E005");		//빈용기구분 구/신
						List<?> ctnr_prps_list	= commonceService.ctnr_se_select(request, map);		//빈용기구분 유흥/가정/직접 조회
						List<?> rmk_list			= commonceService.getCommonCdListNew("D025");		//소매수수료 적용여부 비고
						
						try {
							
							model.addAttribute("std_mgnt_list", util.mapToJson(std_mgnt_list));  		//정산기준관리 조회 
							model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));   
							model.addAttribute("titleSub", title);
							
							model.addAttribute("ctnr_se_list", util.mapToJson(ctnr_se_list));   
							model.addAttribute("ctnr_prps_list", util.mapToJson(ctnr_prps_list));   
							model.addAttribute("rmk_list", util.mapToJson(rmk_list));   
							
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
					 * 수기정산등록 저장
					 * @param data
					 * @param request
					 * @return
					 * @throws Exception 
					 * @
					 */
				    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
					public String epmf47056312_insert(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
							HttpSession session = request.getSession();
							UserVO vo = (UserVO) session.getAttribute("userSession");
							String errCd = "0000";

							List<?> list = JSONArray.fromObject(inputMap.get("list"));
							String wrhs_crct_doc_no ="";
							boolean flag  =true;
							
							if (list != null) {
								try {
											Map<String, String> check = (Map<String, String>) list.get(0);

											wrhs_crct_doc_no = commonceService.doc_psnb_select("IC"); //입고정정문서번호
											    
											//입고정정 재등록 실행
											for(int i=0; i<list.size(); i++){
												Map<String, String> map = (Map<String, String>) list.get(i);
												
												if(vo != null){
													map.put("REG_PRSN_ID", vo.getUSER_ID()); //등록자
												}
												
												map.put("MNUL_EXCA_SE", "M"); //수기등록
												map.put("WRHS_CRCT_DOC_NO_RE", wrhs_crct_doc_no); //문서채번
												map.put("WRHS_DOC_NO", "IN-0"); //입고확인 문서번호 없음
												map.put("CRCT_WRHS_CFM_DT", map.get("CRCT_RTN_DT")); //입고확인일자 없음
												map.put("WRHS_CRCT_DOC_NO", ""); //연결입고정정정문서번호 없음

												epmf4705601Mapper.epmf4705631_insert(map); //입고정정 등록
												
											}//end of for
								 	
									}catch (IOException io) {
										System.out.println(io.toString());
									}catch (SQLException sq) {
										System.out.println(sq.toString());
									}catch (NullPointerException nu){
										System.out.println(nu.toString());
									} catch (Exception e) {
										 throw new Exception("A001"); //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
									}
							}//end of list
							return errCd;
				    }
					
					  
					  
			/***************************************************************************************************************************************************************************************
			 * 	 입고정정수정
			****************************************************************************************************************************************************************************************/
				    
				    /**
					 * 수기정산 수정 초기화면
					 * @param inputMap
					 * @param request
					 * @return
					 * @
					 */
					  public ModelMap epmf47056422_select(ModelMap model, HttpServletRequest request) {
						  
						  	//파라메터 정보
							String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
							JSONObject jParams = JSONObject.fromObject(reqParams);
							model.addAttribute("INQ_PARAMS",jParams);
							Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
							
							String title = commonceService.getMenuTitle("EPMF47056422");	 

							List<?> ctnr_se_list		= commonceService.getCommonCdListNew("E005");		//빈용기구분 구/신
							List<?> ctnr_prps_list	= commonceService.ctnr_se_select(request, map);		//빈용기구분 유흥/가정/직접 조회
							List<?> rmk_list			= commonceService.getCommonCdListNew("D025");		//소매수수료 적용여부 비고
							List<?> crct_gridList 	= epmf4705601Mapper.epmf47056422_select(map);		//입고정정재등록 그리드쪽 조회 
							
							try {
								
								model.addAttribute("titleSub", title);
								
								model.addAttribute("ctnr_se_list", util.mapToJson(ctnr_se_list));   
								model.addAttribute("ctnr_prps_list", util.mapToJson(ctnr_prps_list));   
								model.addAttribute("rmk_list", util.mapToJson(rmk_list));
								model.addAttribute("crct_gridList", util.mapToJson(crct_gridList));
								
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
					 * 입고정정 등록 초기 화면
					 * @param inputMap
					 * @param request
					 * @return
					 * @
					 */
					  public ModelMap epmf4705642_select(ModelMap model, HttpServletRequest request) {
						 	
						  	//파라메터 정보
							String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
							JSONObject jParams = JSONObject.fromObject(reqParams);
							String title = commonceService.getMenuTitle("EPMF4705642"); //타이틀
						
							Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS")); // 선택 row 값
							
							//빈용기테이블때문에//
							map.put("CUST_BIZRID", map.get("WHSDL_BIZRID"));	 			//도매업자 ID
							map.put("CUST_BIZRNO", map.get("WHSDL_BIZRNO_ORI"));	//도매업자 사업자번호
							map.put("CUST_BRCH_ID", map.get("WHSDL_BRCH_ID"));		//도매업자 지점 ID
							map.put("CUST_BRCH_NO", map.get("WHSDL_BRCH_NO"));	//도매업자 지점번호
							map.put("CTNR_SE", "2");													//빈용기 구분  구병/신병
							
							if(map.get("BIZR_TP_CD").equals("W1") ){
								map.put("PRPS_CD", "0");												//빈용기 구분   	도매업자구분이 도매업자(W1)일경우 유흥/가정으로
							}else{
								map.put("PRPS_CD", "2");												//빈용기 구분		도매업자구분이 공병상(W2)일경우 직접반환하는자로
							}
							map.put("RTN_DT", map.get("CRCT_RTN_DT"));						//빈용기 조회기준
							
							List<?> ctnr_se			= commonceService.getCommonCdListNew("E005");		//빈용기구분 구/신
							List<?> ctnr_seList		= commonceService.ctnr_se_select(request, map);		//빈용기구분 유흥/가정/직접 조회
							List<?> iniList			= epmf4705601Mapper.epmf4705631_select(map);		//상세내역 조회
							List<?> cfm_gridList 	= epmf4705601Mapper.epmf4705631_select2(map);		//입고정정 그리드쪽 조회 
							List<?> crct_gridList 	= epmf4705601Mapper.epmf4705642_select(map);		//입고정정재등록 그리드쪽 조회 
							List<?> ctnr_nm			= commonceService.ctnr_cd_select(map);					//빈용기명 조회
							List<?> rmk_list			= commonceService.getCommonCdListNew("D025");		//소매수수료 적용여부 비고
						
							try {
								model.addAttribute("INQ_PARAMS",jParams);
								model.addAttribute("titleSub", title);
								model.addAttribute("iniList", util.mapToJson(iniList));	
								model.addAttribute("cfm_gridList", util.mapToJson(cfm_gridList));
								model.addAttribute("crct_gridList", util.mapToJson(crct_gridList));
								model.addAttribute("ctnr_se", util.mapToJson(ctnr_se));	
								model.addAttribute("ctnr_seList", util.mapToJson(ctnr_seList));	
								model.addAttribute("ctnr_nm", util.mapToJson(ctnr_nm));
								model.addAttribute("rmk_list", util.mapToJson(rmk_list));	
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
						 * 입고정정등록  수정 - 수기등록
						 * @param data
						 * @param request
						 * @return
						 * @throws Exception 
						 * @
						 */
					    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
						public String epmf47056422_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception  {
								HttpSession session = request.getSession();
								UserVO vo = (UserVO) session.getAttribute("userSession");
								String errCd = "0000";
								//Map<String, String> map;
								List<?> list = JSONArray.fromObject(inputMap.get("list"));
								
								if (list != null) {
									try {
											Map<String, String> check = (Map<String, String>) list.get(0);
											check.put("WRHS_DOC_NO", "IN-0");
											epmf4705601Mapper.epmf4705642_delete(check); // 입고정정 삭제
											
											//입고정정등록 실행
											for(int i=0; i<list.size(); i++){
												Map<String, String> map = (Map<String, String>) list.get(i);
												map.put("UPD_PRSN_ID", vo.getUSER_ID()); //등록자, REG_PRSN_ID :최초등록자

												map.put("MNUL_EXCA_SE", "M"); //수기등록
												map.put("WRHS_DOC_NO", "IN-0"); //입고확인 문서번호 없음
												map.put("CRCT_WRHS_CFM_DT", map.get("CRCT_RTN_DT")); //입고확인일자 없음
												map.put("WRHS_CRCT_DOC_NO", ""); //연결입고정정정문서번호 없음
												
												epmf4705601Mapper.epmf4705631_insert(map); // 입고정정 등록
											}//end of for
									 	
										}catch (IOException io) {
											System.out.println(io.toString());
										}catch (SQLException sq) {
											System.out.println(sq.toString());
										}catch (NullPointerException nu){
											System.out.println(nu.toString());
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
					    
						/**
						 * 입고정정등록  수정
						 * @param data
						 * @param request
						 * @return
						 * @throws Exception 
						 * @
						 */
					    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
						public String epmf4705642_update(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
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
												 int sel = epmf4705601Mapper.epmf4705631_select5(check); // 수량 체크
												 if(sel != 1){
													 throw new Exception("A016"); 
												 }
												 /*
												 sel = epmf4705601Mapper.epmf4705631_select6(check); // 적용기간 체크
												 if(sel >0 ){
													 throw new Exception("A017"); 
												 }
												 */
												List<?>  gridList	= util.mapToJson(epmf4705601Mapper.epmf4705642_select(check));// 입고정정 초기 값 데이터 비교
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
												
												epmf4705601Mapper.epmf4705642_delete(check); // 입고정정 삭제
												
												//입고정정등록 실행
												for(int i=0; i<list.size(); i++){
													Map<String, String> map = (Map<String, String>) list.get(i);
													map.put("UPD_PRSN_ID", vo.getUSER_ID()); //등록자, REG_PRSN_ID :최초등록자
													map.put("MNUL_EXCA_SE", "R"); //재정산등록
													epmf4705601Mapper.epmf4705631_insert(map); // 입고정정 등록
												}//end of for
									 	
										}catch (IOException io) {
											System.out.println(io.toString());
										}catch (SQLException sq) {
											System.out.println(sq.toString());
										}catch (NullPointerException nu){
											System.out.println(nu.toString());
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
			  public ModelMap epmf47056642_select(ModelMap model, HttpServletRequest request) {
				  
				  	//파라메터 정보
					String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
					JSONObject jParams = JSONObject.fromObject(reqParams);
					model.addAttribute("INQ_PARAMS",jParams);
				    
					Map<String, String> map2 = new HashMap<String, String>();
					Map<String, String> map = util.jsonToMap(jParams.getJSONObject("EXCA_PARAM"));
				 	
					List<?>	mfc_bizrnmList =null; 
					if(map.get("EXCA_TRGT_SE").equals("I")){
						mfc_bizrnmList = commonceService.std_mgnt_mfc_select(request, map);			//정산기간중인 생산자
					}else{
						mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); 	 				//모든생산자
					}
					
					List<?> std_mgnt_list 	= commonceService.std_mgnt_select(request, map2);			//정산기간
					List<?> whsl_se_cdList	= commonceService.whsdl_se_select(request, map);  		 //도매업자구분
					String   title					= commonceService.getMenuTitle("EPMF47056642");		//타이틀
					List<?> whsdlList			= commonceService.mfc_bizrnm_select4(request, map);    //도매업자 업체명조회
					
					//상세 들어갔다가 다시 관리 페이지로 올경우
					Map<String, String> paramMap = new HashMap<String, String>();
			
					try {
						/*
						if(jParams.get("SEL_PARAMS") !=null){//상세 볼경우
							JSONObject param2 =(JSONObject)jParams.get("SEL_PARAMS");
							if(param2.get("MFC_BIZRID") !=null){	//생산자사업자 선택시
								paramMap.put("BIZRNO", param2.get("MFC_BIZRNO").toString());					//생산자ID
								paramMap.put("BIZRID", param2.get("MFC_BIZRID").toString());					//생산자 사업자번호
								List<?> brch_nmList = commonceService.brch_nm_select(request, paramMap);	 	  	//사업자 직매장/공장 조회	
								model.addAttribute("brch_nmList", util.mapToJson(brch_nmList));	
							}
						}
						*/
						
						model.addAttribute("std_mgnt_list", util.mapToJson(std_mgnt_list));  		//정산기준관리 조회 
						model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));		
						model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));	
						model.addAttribute("whsdlList", util.mapToJson(whsdlList));	
						model.addAttribute("titleSub", title);
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
				 * 입고내역선택 생산자변경시  생산자에맞는 직매장 조회  ,업체명 조회
				 * @param inputMap
				 * @param request
				 * @return
				 * @
				 */
				public HashMap epmf47056642_select2(Map<String, String> inputMap, HttpServletRequest request) {
			    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
			    	
			    	try {
				      		rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap))); // 생산자랑 거래중인 도매업자 업체명조회
					    	inputMap.put("BIZR_TP_CD", "");
							rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, inputMap)));	 //사업자 직매장/공장 조회	
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
				 *  생산자 직매장/공장 선택시  업체명 조회
				 * @param inputMap
				 * @param request
				 * @return
				 * @
				 */
				public HashMap epmf47056642_select3(Map<String, String> inputMap, HttpServletRequest request) {
			    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
			    		try {
							rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap))); //업체명 조회	
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
				 *  도매업자 구분 선택시 업체명 조회
				 * @param inputMap
				 * @param request
				 * @return
				 * @
				 */
				public HashMap epmf47056642_select4(Map<String, String> inputMap, HttpServletRequest request) {
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
				 *  조회
				 * @param inputMap
				 * @param request
				 * @return
				 * @
				 */
				public HashMap epmf47056642_select5(Map<String, Object> inputMap, HttpServletRequest request) {
			    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
			    		try {
			    			
			    			HttpSession session = request.getSession();
			    			UserVO vo = (UserVO) session.getAttribute("userSession");
			    			inputMap.put("MFC_BIZRID", vo.getBIZRID());
			    			inputMap.put("MFC_BIZRNO", vo.getBIZRNO_ORI());
			    			
			    			List<?> list = JSONArray.fromObject(inputMap.get("MFC_BIZRNM_RETURN"));
			    			inputMap.put("MFC_BIZRNM_RETURN", list);  
			    			
							rtnMap.put("selList", util.mapToJson(epmf4705601Mapper.epmf47056642_select(inputMap)));
							rtnMap.put("totalCnt", epmf4705601Mapper.epmf47056642_select_cnt(inputMap));
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
		
				
}
