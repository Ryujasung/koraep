package egovframework.koraep.wh.ep.service;
  
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.WebUtils;

import egovframework.common.EgovFileMngUtil;
import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.wh.ep.EPWH0121801Mapper;
import egovframework.mapper.wh.ep.EPWH9000101Mapper;
    
/**
 * 회수정보관리 Service     
 * @author 양성수  
 *
 */  
@Service("EPWH9000101Service")   
public class EPWH9000101Service {   
	
	@Resource(name="EPWH9000101Mapper")
	private EPWH9000101Mapper EPWH9000101Mapper; //회수정보관리 Mapper

	@Resource(name="epwh0121801Mapper")
	private EPWH0121801Mapper epwh0121801Mapper; //소매거래처등록

	  
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**   
	 * 회수정보관리 초기화면
	 * @param inputMap  
	 * @param request   
	 * @return  
	 * @  
	 */
	  public ModelMap EPWH9000101_select(ModelMap model, HttpServletRequest request) {
			
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
			
			Map<String, String> map= new HashMap<String, String>();
			List<?> bizr_tp_cd_list	= commonceService.whsdl_se_select(request, map);  		 			//도매업자구분
			List<?> stat_cd_list		= commonceService.getCommonCdListNew("S200");						//상태
			String   title					= commonceService.getMenuTitle("EPWH9000101");						//타이틀
			  
			try {
					//상세 들어갔다가 다시 관리 페이지로 올경우
					if(jParams.get("SEL_PARAMS") !=null){//상세 볼경우
						Map<String, String> paramMap = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
						map.put("BIZR_TP_CD", paramMap.get("BIZR_TP_CD"));											//상세갔다올경우  구분 넣기
						if(paramMap.get("WHSDL_BIZRID") !=null && !paramMap.get("WHSDL_BIZRID").equals("") ){//도매업자 선택시
							paramMap.put("BIZRNO", paramMap.get("WHSDL_BIZRID"));					// 도매업자ID
							paramMap.put("BIZRID", paramMap.get("WHSDL_BIZRNO"));					// 도매업자사업자번호
							List<?> brch_cd_List = commonceService.brch_nm_select(request, paramMap);	 	// 도매업자 지점 조회	
							model.addAttribute("brch_cd_List", util.mapToJson(brch_cd_List));	
						}  
					}  
					//List<?>	whsdl_cd_list = commonceService.rtl_select( map);    			//도매업자 업체명조회
					List<?>	whsdl_cd_list = pbox_bizr_select(request, map);    			//도매업자 업체명조회
					
					List<?> langSeList = commonceService.getLangSeCdList();  // 언어코드
					
					HashMap<String, String> map2 = new HashMap<String, String>();
					
					map2 = (HashMap<String, String>)langSeList.get(0);       // 표준인놈으로 기타코드 가져오기
					map2.put("GRP_CD", "E002");
					List<?> prpsCdList  = commonceService.getCommonCdListNew2(map2);   // 기타코드 용어코드
					
					model.addAttribute("stat_cd_list", util.mapToJson(stat_cd_list));	
					model.addAttribute("bizr_tp_cd_list", util.mapToJson(bizr_tp_cd_list));	
					model.addAttribute("whsdl_cd_list", util.mapToJson(whsdl_cd_list));	
					model.addAttribute("prpsCdList", util.mapToJson(prpsCdList));					
					model.addAttribute("titleSub", title);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	
			return model;    	
	    }
	  
	  /**
		 *	 도매업자 조회
		 * @param data
		 * @param request
		 * @return
		 * @
		 */ 
		public List<?> pbox_bizr_select(HttpServletRequest request, Map<String, String> data)  {
			
			HttpSession session = request.getSession();
			UserVO uvo = (UserVO) session.getAttribute("userSession");
			
			List<?> selList=null;
			Map<String, String> map =new HashMap<String, String>();
			map.put("BIZRNO", uvo.getBIZRNO_ORI()); 
			//로그인자가 도매업자 일경우
				selList = EPWH9000101Mapper.pbox_bizr_select((HashMap<String, String>) map);
			
			return selList;
		}
	  
		/**
		 * 회수정보관리 업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap EPWH9000101_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
		      	rtnMap.put("whsdl_cd_list", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 도매업자 업체명조회
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	 	 //사업자 직매장/공장 조회	
			return rtnMap;    	
	    }
	  
		/**
		 * 회수정보관리 지점조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap EPWH9000101_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    		try {
    			rtnMap.put("brch_cd_List", util.mapToJson(commonceService.brch_nm_select(request, inputMap))); 		// 도매업자 지점
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	  //업체명 조회	
			return rtnMap;    	
	    }
	
		/**
		 * 회수정보관리  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap EPWH9000101_select4(Map<String, Object> inputMap, HttpServletRequest request) {
			
		    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		    	
		    	HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
	
				//로그인자가 센터일경우
				if(vo != null ){
					inputMap.put("T_USER_ID", vo.getUSER_ID());
				}
	    	
	    		try {
					rtnMap.put("selList", util.mapToJson(EPWH9000101Mapper.EPWH9000101_select(inputMap))); 
//					rtnMap.put("totalList", util.mapToJson(EPWH9000101Mapper.EPWH9000101_select_cnt(inputMap)));
//					rtnMap.put("amt_tot_list", util.mapToJson(EPWH9000101Mapper.EPWH9000101_select2(inputMap))); 
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	  
	    	return rtnMap;    	
	    }
		/**
		 * 회수정보관리 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String EPWH9000101_excel(HashMap<String, Object> data, HttpServletRequest request) {
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null ){
				data.put("T_USER_ID", vo.getUSER_ID());
			}
			
			String errCd = "0000";
			try {
				List<?> list = EPWH9000101Mapper.EPWH9000101_select(data);
				
				//object라 String으로 담아서 보내기
				HashMap<String, String> map = new HashMap<String, String>(); 
				map.put("fileName", data.get("fileName").toString());
				map.put("columns", data.get("columns").toString());
				
				//엑셀파일 저장
				commonceService.excelSave(request, map, list);
			}catch(Exception e){
				return  "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			return errCd;
		}	
		
		/**
		 * 회수정보관리  삭제
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String EPWH9000101_delete(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
	
			if (list != null) {
				try {
					for (int i = 0; i < list.size(); i++) {
						map = (Map<String, String>) list.get(i);
						/*int stat = EPWH9000101Mapper.EPWH9000101_select3(map); // 상태 체크
						if (stat > 0) {
							throw new Exception("A012"); // 상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						}*/
						EPWH9000101Mapper.EPWH9000101_delete(map); //  삭제
					}
	
				} catch (Exception e) {
					if (e.getMessage().equals("A012")) {
						 throw new Exception(e.getMessage()); 
					} else {
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					}
				}
			}
			return errCd;
		}
		
		/**
		 * 회수정보관리  등록일괄확인
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception    
		 * @
		 */
		public String EPWH9000101_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserId =""; 
			if(vo != null){
				ssUserId = vo.getUSER_ID();
			}
			            
			if (list != null) {     
				try {     
					for(int i=0; i<list.size(); i++){
						 map = (Map<String, String>) list.get(i);
						 int stat = EPWH9000101Mapper.EPWH9000101_select3(map); //상태 체크
						 if(stat>0){
								throw new Exception("A012"); // 상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						 }
						 
						 if(map.get("RTRVL_STAT_CD").equals("RG") ||  map.get("RTRVL_STAT_CD").equals("WJ") ){
							 map.put("RTRVL_STAT_CD", "WC");
						 }else  if(map.get("RTRVL_STAT_CD").equals("WG") ||  map.get("RTRVL_STAT_CD").equals("RJ") ){
							 map.put("RTRVL_STAT_CD", "RC");  
						 }    

						 map.put("UPD_PRSN_ID", ssUserId);  	//요청자
						 EPWH9000101Mapper.EPWH9000101_update(map);
					}       
				}catch (Exception e) {
					 if(e.getMessage().equals("A012")){
						 throw new Exception(e.getMessage());
					 }else if(e.getMessage().equals("A018")){
						 throw new Exception(e.getMessage());
					 }else{   
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					 }             
				}      
			}        
		        
			return errCd;    	
	    }
		
/***********************************************************************************************************************************************
*	회수정보 상세조회
************************************************************************************************************************************************/
		
		/**
		 * 회수정보관리 상세조회 초기 화면
		 * @param inputMap
		 * @param request      
		 * @return   
		 * @
		 */   
		  public ModelMap EPWH9000164_select(ModelMap model, HttpServletRequest request) {
			  
			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
				List<?>	initList 			= EPWH9000101Mapper.EPWH9000142_select(map);    	//상세 그리드 값   
				String   title					= commonceService.getMenuTitle("EPWH9000164");		//타이틀
				  
				try {
					model.addAttribute("initList", util.mapToJson(initList));	
					model.addAttribute("INQ_PARAMS",jParams);
					model.addAttribute("titleSub", title);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	
				return model;    	
		    }  
		  
  /***********************************************************************************************************************************************
  *	회수정보 등록
  ************************************************************************************************************************************************/
	
	/**
	 * 회수정보등록 초기 화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap EPWH9000131_select(ModelMap model, HttpServletRequest request) {
		      
		  	//파라메터 정보   
			String reqParams 				= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams 			= JSONObject.fromObject(reqParams);
			Map<String, String> map 		= new HashMap<String, String>();
			String   	title						= commonceService.getMenuTitle("EPWH9000131");	//타이틀
			//List<?>	whsdl_cd_list 			= commonceService.whsdl_select(map);    				//도매업자 업체명조회
			List<?> whsdl_cd_list = pbox_bizr_select(request, map); 
			List<?> stat_cd_list		= commonceService.getCommonCdListNew("S200");						//상태
			List<?> AreaCdList = commonceService.getCommonCdListNew("B010");
			map.put("WORK_SE", "4"); 																				//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
			HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);					//등록일자제한설정  
			
			try {
					model.addAttribute("titleSub", title);
					model.addAttribute("INQ_PARAMS",jParams);
					model.addAttribute("whsdl_cd_list", util.mapToJson(whsdl_cd_list));	
					model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));	  	 
					model.addAttribute("stat_cd_list", util.mapToJson(stat_cd_list));	  	 
					model.addAttribute("AreaCdList", util.mapToJson(AreaCdList));
					
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	
			return model;    	
	    }       
		      
		/**
		 * 회수정보등록도매업자 변경시    지점 & 보증금,수수료 조회
		 * @param inputMap
		 * @param request
		 * @return   
		 * @
		 */
		public HashMap EPWH9000131_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
  		try {
	  			rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, inputMap))); 				// 도매업자 지점
	  			rtnMap.put("dps_fee_list", util.mapToJson(commonceService.rtrvl_ctnr_dps_fee_select(inputMap))); 	//회수용기 보증금 취급수수료
	  			rtnMap.put("dps_pbox_list", util.mapToJson(commonceService.pbox_select(inputMap))); 	//회수용기 보증금 취급수수료
	  			rtnMap.put("stat_cd_list", util.mapToJson(commonceService.getCommonCdListNew("S200"))); 	//상태코드
  		} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	  //업체명 조회	
			return rtnMap;    	
	    }

		/**
		 * 회수정보등록 날짜 변경시 보증금,수수료조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap EPWH9000131_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
  		try {
  				rtnMap.put("dps_fee_list", util.mapToJson(commonceService.rtrvl_ctnr_dps_fee_select(inputMap))); 	//회수용기 보증금 취급수수료
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	  
			return rtnMap;    	
	    }
		
		/**
		 * 회수정보등록 엑셀업로드 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap EPWH9000131_select4(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
  		try {  
  				rtnMap.put("selList", util.mapToJson(EPWH9000101Mapper.EPWH9000131_select4(inputMap))); 	
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	  
			return rtnMap;    	
	    }
		    
		/**
		 * 소매업자 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap EPWH9000131_select5(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
 			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(inputMap == null) {
				if(vo != null){
					inputMap.put("WHSDL_BIZRID", vo.getBIZRID());
					inputMap.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());
				}
			}
	    	
	    	try {  
  				rtnMap.put("selList", util.mapToJson(EPWH9000101Mapper.EPWH9000131_select5(inputMap))); 	
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	  
			return rtnMap;
	    }
		
		/**
		 *  회수정보등록  저장
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String EPWH9000131_insert(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				String errCd = "0000";
				String ssUserId  = "";   //사용자ID
				
				List<?> list = JSONArray.fromObject(inputMap.get("list"));
				List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();
				boolean keyCheck = false;
				String doc_no ="";
				Map<String, String> totsum = new HashMap<String, String>();
				if (list != null) {
					try {
						for(int i=0; i<list.size(); i++){
							keyCheck = false;
							Map<String, String> map = (Map<String, String>) list.get(i);
							
							if(vo != null){
								ssUserId = vo.getUSER_ID();   
								map.put("S_USER_ID", ssUserId);  
							}
							
							int sel = EPWH9000101Mapper.EPWH9000131_chk(map); //중복체크
							if(sel>0){  
								inputMap.put("ERR_CTNR_NM", map.get("CUST_BIZRNM"));
								
								throw new Exception("A003"); 		//중복된 데이터 입니다. 다시 한번 확인해주시기 바랍니다.
							}    

						 	EPWH9000101Mapper.EPWH9000131_insert2(map); 					// 회수상세
							
						
						}
					} catch (Exception e) {
						/*e.printStackTrace();*/
						//취약점점검 6292 기원우
						 if(e.getMessage().equals("A003")){
							 throw new Exception(e.getMessage()); 
						 }else if(e.getMessage().equals("A021")){
								throw new Exception(e.getMessage()); 
						 }else{  
							 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
						 }
					}
				}//end of list
				return errCd;
	    }
		
		
  /***********************************************************************************************************************************************
   *	회수정보수정
   ************************************************************************************************************************************************/
 	     
 	/**
 	 * 회수정보수정 초기 화면
 	 * @param inputMap
 	 * @param request   
 	 * @return   
 	 * @          
 	 */  
 	  public ModelMap EPWH9000142_select(ModelMap model, HttpServletRequest request) {
 		    
 		   //파라메터 정보   
			String reqParams 				= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams 			= JSONObject.fromObject(reqParams);
			Map<String, String> map 		= new HashMap<String, String>();
			Map<String, String> map2 = util.jsonToMap(jParams.getJSONObject("PARAMS"));
			String   	title						= commonceService.getMenuTitle("EPWH9000142");	//타이틀
			List<?>	whsdl_cd_list 			= commonceService.whsdl_select(map);    				//도매업자 업체명조회
			List<?> stat_cd_list		= commonceService.getCommonCdListNew("S200");						//상태
			List<?> AreaCdList = commonceService.getCommonCdListNew("B010");
			map.put("WORK_SE", "4"); 																				//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
			HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);					//등록일자제한설정  
			
			try {
					model.addAttribute("titleSub", title);
//					model.addAttribute("INQ_PARAMS",jParams);
					model.addAttribute("INQ_PARAMS",util.mapToJson((HashMap<?, ?>) map2));
					model.addAttribute("whsdl_cd_list", util.mapToJson(whsdl_cd_list));	
					model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));	  	 
					model.addAttribute("stat_cd_list", util.mapToJson(stat_cd_list));	  	 
					model.addAttribute("AreaCdList", util.mapToJson(AreaCdList));
					
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	
			return model;  
 		  
 	    }        
  		
 	 /**
		 *  회수정보수정  저장
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @   
		 */       
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String EPWH9000142_update(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				String errCd = "0000";
				String ssUserId  = "";   //사용자ID     

				//Map<String, String> map;    
				List<?> list = JSONArray.fromObject(inputMap.get("list"));
				List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();       
				boolean keyCheck = false;

				if (list != null) {                      
					try {

						for(int i=0; i<list.size(); i++){
								Map<String, String> map = (Map<String, String>) list.get(i);
								
								
								if(vo != null){
									ssUserId = vo.getUSER_ID();   
									map.put("S_USER_ID", ssUserId);  
								}

								/*int sel = EPWH9000101Mapper.EPWH9000131_select2(map); //중복체크       
								if(sel>0){
									inputMap.put("ERR_CTNR_NM", map.get("CTNR_NM").toString());
									throw new Exception("A003"); //중복된 데이터 입니다. 다시 한번 확인해주시기 바랍니다.
								}*/
								
								//map.put("SDT_DT", map.get("RTRVL_DT"));	//등록일자제한설정  등록일자 1.DLIVY_DT,2.DRCT_RTRVL_DT, 3.EXCH_DT, 4.RTRVL_DT, 5.RTN_DT
								
							 	/*if(!keyCheck){   
							 			EPWH9000101Mapper.EPWH9000142_delete(map); 	// info삭제
								 		list2.add(map);
								 		keyCheck = true;   
								 		if(map.get("ADJ").equals("T")){
									 			if(map.get("RTRVL_STAT_CD").equals("RG") || map.get("RTRVL_STAT_CD").equals("WG") || map.get("RTRVL_STAT_CD").equals("RJ") || map.get("RTRVL_STAT_CD").equals("WJ") ){								 				
												 			if(map.get("RTRVL_STAT_CD").equals("RG")){
												 				map.put("RTRVL_STAT_CD", "WJ");
												 			}else if(map.get("RTRVL_STAT_CD").equals("WG")){
												 				map.put("RTRVL_STAT_CD", "RJ");
												 			}   
												 			EPWH9000101Mapper.EPWH90001422_update(map); //회수조정일경우 마스터 상태값 변경
									 			}
								 		}//end of if(map.get("ADJ").equals("T"))
							 	}//end of if(!keyCheck)
*/							 	//detail
							 	EPWH9000101Mapper.EPWH9000142_update(map); // 회수상세
						}//end of for  
						
						//마스터 등록 length 길이만큼   회수량, 수수료 SUM update
					 	/*for(int j=0 ;j<list2.size(); j++){
					 		Map<String, String> map3 = (Map<String, String>) list2.get(j);
//					 		EPWH9000101Mapper.EPWH9000131_update(map3);
					 	}*/
						   
					} catch (Exception e) {
						 if(e.getMessage().equals("A003")){
							 throw new Exception(e.getMessage()); 
						 }else if(e.getMessage().equals("A021")){
							 throw new Exception(e.getMessage()); 
						 }else{
							 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
						 }
					}
				}//end of list
				return errCd;
	    }
	    
	    
		  
  /***********************************************************************************************************************************************
   *	회수조정  
   ************************************************************************************************************************************************/
 	    
 	/**
 	 * 회수조정 초기 화면
 	 * @param inputMap  
 	 * @param request         
 	 * @return  
 	 * @     
 	 */     
 	  public ModelMap EPWH90001422_select(ModelMap model, HttpServletRequest request) {
 		        
 			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");      
			JSONObject jParams = JSONObject.fromObject(reqParams);    
			Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));   
			String   title					= commonceService.getMenuTitle("EPWH90001422");		//타이틀   
			List<?>	initList 			= EPWH9000101Mapper.EPWH9000142_select(map);    	//상세 그리드 값   
			map.put("BIZRID", map.get("WHSDL_BIZRID"));
 			map.put("BIZRNO", map.get("WHSDL_BIZRNO"));
 			List<?>	brch_nmList 	= commonceService.brch_nm_select(request, map);   			 	//도매업자지점
			  
			try {  
				model.addAttribute("brch_nmList", util.mapToJson(brch_nmList));	   
				model.addAttribute("initList", util.mapToJson(initList));	      
				model.addAttribute("INQ_PARAMS",jParams);
				model.addAttribute("titleSub", title);                         
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	               
			return model;    	   	
 	    }
 	  
 	    
  /***********************************************************************************************************************************************
   *	회수증빙자료관리
   ************************************************************************************************************************************************/
 	     
 	/**     
 	 * 회수증빙자료관리	초기 화면      
 	 * @param inputMap  
 	 * @param request   
 	 * @return  
 	 * @
 	 */  
 	  public ModelMap EPWH9000197_select(ModelMap model, HttpServletRequest request) {
 		      
 		  	//파라메터 정보
 			String reqParams 			= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
 			JSONObject jParams 		= JSONObject.fromObject(reqParams);   
 			Map<String, String> map = new HashMap<String, String>();
 			String   title						= commonceService.getMenuTitle("EPWH9000197");		//타이틀  
 			List<?>	whsdl_cd_list 		= commonceService.whsdl_select(map);    					//도매업자 업체명조회
 			try {
 				model.addAttribute("whsdl_cd_list", util.mapToJson(whsdl_cd_list));	   
 				model.addAttribute("INQ_PARAMS",jParams);
 				model.addAttribute("titleSub", title);
 			} catch (Exception e) {
 				// TODO Auto-generated catch block
 				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
 			}	
 			return model;    	
 	    }		  
 	           
 		/**   
		 * 회수증빙자료관리	조회      
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */   
		public HashMap EPWH9000197_select2(Map<String, Object> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null ){
				inputMap.put("T_USER_ID", vo.getUSER_ID());
			}
	    	
	    		try {
					rtnMap.put("selList", util.mapToJson(EPWH9000101Mapper.EPWH9000197_select(inputMap))); 
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	  
	    	return rtnMap;    	
	    }
 
		/**
		 * 회수증빙관리 삭제
		 * @param inputMap  
		 * @param request    
		 * @return    
		 * @throws Exception       
		 * @    
		 */    
		public String EPWH9000197_delete(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
			String errCd = "0000";
				try {  
						EPWH9000101Mapper.EPWH9000197_delete(inputMap); //  삭제  
				} catch (Exception e) {
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}    
			return errCd;  
		}  
		
  /***********************************************************************************************************************************************
   *	회수증빙자료등록
   ************************************************************************************************************************************************/
 	  
 	/**     
 	 * 회수증빙자료등록	초기 화면
 	 * @param inputMap
 	 * @param request     
 	 * @return    
 	 * @  
 	 */     
 	  public ModelMap EPWH9000188_select(ModelMap model, HttpServletRequest request) {
 		     
 		  	//파라메터 정보   
 			String reqParams 			= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
 			JSONObject jParams 		= JSONObject.fromObject(reqParams);
 			Map<String, String> map = new HashMap<String, String>();
 			String   title						= commonceService.getMenuTitle("EPWH9000188");		//타이틀
 			try {
 				model.addAttribute("INQ_PARAMS",jParams);   
 				model.addAttribute("titleSub", title);
 			} catch (Exception e) {
 				// TODO Auto-generated catch block
 				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
 			}	
 			return model;    	  
 	    }
 	  
 	 /**
		 * 증빙파일등록  저장
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String EPWH9000188_insert(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");

			String fileName = "";
			String tmpFileName = "";
			String errCd = "0000";

			inputMap.put("WHSDL_BIZRID" ,request.getParameter("WHSDL_BIZRID"));
			inputMap.put("WHSDL_BIZRNO"  ,request.getParameter("WHSDL_BIZRNO"));
			inputMap.put("RTRVL_DT"  ,request.getParameter("RTRVL_DT"));
			//크로스
//			MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
			MultipartHttpServletRequest mptRequest = WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
			Iterator fileIter = mptRequest.getFileNames();
			try {	
					while (fileIter.hasNext()) {
						MultipartFile mFile = mptRequest.getFile((String)fileIter.next());

						fileName = mFile.getOriginalFilename();
						if(fileName != null && !fileName.equals("")){
							tmpFileName = fileName.toLowerCase();
							HashMap map = EgovFileMngUtil.uploadFile(mFile, vo.getBIZRNO());	//파일저장
							fileName = (String)map.get("uploadFileName");
							inputMap.put("FILE_NM"      ,(String)map.get("originalFileName"));
							inputMap.put("SAVE_FILE_NM" ,(String)map.get("uploadFileName"));
							inputMap.put("FILE_PATH"    ,(String)map.get("filePath"));
							inputMap.put("REG_PRSN_ID" ,vo.getUSER_ID());
							EPWH9000101Mapper.EPWH9000188_insert(inputMap);	
						}
					}
					
			}catch (Exception e) {
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			return errCd;
	    }

	    /**
	     * 증빙사진 등록(모바일)
	     * @param model
	     * @param request
	     * @return
	     * @throws Exception
	     */
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	    public String saveEpcmRtnPrfFileApp(HttpServletRequest request) throws Exception{
			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			
			String userId = "";
			if(vo != null) userId = vo.getUSER_ID();
			
			String errCd    = "0000";
			String fileName = "";
			String tmpFileName = "";
			String fileData = "";

/*
			// 헤더 전체정보 보기
			Enumeration<String> em = request.getHeaderNames();
		 
		    while(em.hasMoreElements()){
		        String name = em.nextElement() ;
		        String val = request.getHeader(name) ;
		         
		        System.out.println("header : " + name + " : " + val) ;
		    }
*/		    
		    
		    StringBuffer sb = new StringBuffer();

		    Enumeration eNames = request.getParameterNames();
			
			if (eNames.hasMoreElements()) {

				while (eNames.hasMoreElements()) {
					String name = (String) eNames.nextElement();
					String[] values = request.getParameterValues(name);
					
					//System.out.println("request : [" + name + "], length : [" + values.length +"]") ;
					
					if (values.length > 0) {
						String value = values[0];
						for (int i = 1; i < values.length; i++) {
							value += "," + values[i];
							//System.out.println("value : ["+values[i]+"]");
						}
						
						sb.append(name);
						
						if(!("").equals(value)){
							sb.append(":");
							sb.append(value);
						}
						
						//System.out.println(name+":"+value);
					}
				}
			}
			
            //System.out.println("[GODCOM] request1 : [" + sb.toString() + "]");
			
	        try {
		        Map<String, String> data = JSONObject.fromObject(sb.toString());

		        List<?> list = JSONArray.fromObject(data.get("ATC_REC"));

		        for(int i=0; i<list.size(); i++){
	        	
	        		//System.out.println("[GODCOM] list : " + list.get(i).toString());
	        		
	            	Map<String, String> inputMap = (Map<String, String>)list.get(i);
	            	inputMap.put("WHSDL_BIZRID"  ,data.get("WHSDL_BIZRID"));
	    			inputMap.put("WHSDL_BIZRNO"  ,data.get("WHSDL_BIZRNO"));
	    			inputMap.put("RTRVL_DT"      ,data.get("RTRVL_DT").replaceAll("-", "") );

	    			fileName = inputMap.get("FILE_NM");
	            	fileData = inputMap.get("FILE_DATA");
	            	fileData = fileData.replace(" ", "+");
	            	fileData = fileData.replace(":", "=");
	            	
	            	tmpFileName = fileName.toLowerCase();
	            	
	            	if((tmpFileName.endsWith(".jpg") || tmpFileName.endsWith(".png") || tmpFileName.endsWith(".bmp") || tmpFileName.endsWith(".gif") || tmpFileName.endsWith(".tiff"))) {
	            		
	            		//System.out.println("[GODCOM] fileData : " + fileData);
	            		
	            		HashMap<String, String> fMap = EgovFileMngUtil.uploadFile(fileData, vo.getBIZRNO(), fileName);
						inputMap.put("FILE_NM"      ,(String)fMap.get("originalFileName"));
						inputMap.put("SAVE_FILE_NM" ,(String)fMap.get("uploadFileName"));
						inputMap.put("FILE_PATH"    ,(String)fMap.get("filePath"));
	            		inputMap.put("REG_PRSN_ID"  ,userId);
	            		
	            		//System.out.println("[GODCOM] InputMap : " + inputMap);
	            		
	            		EPWH9000101Mapper.EPWH9000188_insert(inputMap);
	            	}
	            }		
	        }
	        catch (Exception e) {
	        	
	        	if(sb.equals(null) || sb == null || sb.toString().equals("")) {
	        		return "A007";
	        	}
	        	
	        	throw new Exception("A001");
			}

	        return errCd;  
	    }	    
	    
 	  
 /***********************************************************************************************************************************************
   *	회수증빙자료다운로드
   ************************************************************************************************************************************************/
 	
 	/**   
 	 * 회수증빙자료다운로드	초기 화면
 	 * @param inputMap
 	 * @param request  
 	 * @return   
 	 * @          
 	 */
 	  public ModelMap EPWH90001882_select(@RequestParam Map<String, Object> param, ModelMap model, HttpServletRequest request) {
 		    
 		  	//파라메터 정보
 			String reqParams 		= util.null2void(request.getParameter("INQ_PARAMS"),"{}");  
 			JSONObject jParams 	= JSONObject.fromObject(reqParams);	 
 			
	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null ){
				param.put("T_USER_ID", vo.getUSER_ID());
			}
 			
 			List<?>	initList 			= EPWH9000101Mapper.EPWH9000197_select (param); 
 			String   	title				= commonceService.getMenuTitle("EPWH90001882");		//타이틀
 			try {
 				model.addAttribute("initList", util.mapToJson(initList));	   
 				model.addAttribute("INQ_PARAMS",jParams);  
 				model.addAttribute("titleSub", title);
 			} catch (Exception e) {
 				// TODO Auto-generated catch block
 				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
 			}	
 			return model;    	
 	    } 	  
}
