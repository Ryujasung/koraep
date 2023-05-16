package egovframework.koraep.rt.ep.service;
  
import java.util.ArrayList;
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

import egovframework.common.EgovFileMngUtil;
import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE0121801Mapper;
import egovframework.mapper.rt.ep.EPRT9025801Mapper;
    
/**
 * 반환정보조회 Service     
 * @author 양성수  
 *
 */  
@Service("eprt9025801Service")   
public class EPRT9025801Service {   
	
	@Resource(name="eprt9025801Mapper")
	private EPRT9025801Mapper eprt9025801Mapper;  //반환정보조회 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**   
	 * 반환정보조회 초기화면
	 * @param inputMap  
	 * @param request   
	 * @return  
	 * @  
	 */
	  public ModelMap eprt9025801_select(ModelMap model, HttpServletRequest request) {
			
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			
			String title = commonceService.getMenuTitle("EPRT9025801");	//타이틀
			model.addAttribute("titleSub", title);
			
			try {
				model.addAttribute("INQ_PARAMS",jParams);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	
			return model;    	
	    }
		/**
		 * 반환정보조회  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap eprt9025801_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    		try {
	    			HttpSession session = request.getSession();
					UserVO vo = (UserVO) session.getAttribute("userSession");
					if(vo != null){
						inputMap.put("BIZRID", vo.getBIZRID());  					
						inputMap.put("BIZRNO", vo.getBIZRNO_ORI());  			
						inputMap.put("BRCH_ID", vo.getBRCH_ID());  				// 지점ID   
						inputMap.put("BRCH_NO", vo.getBRCH_NO());  			// 지점번호  
					}
					rtnMap.put("selList", util.mapToJson(eprt9025801Mapper.eprt9025801_select(inputMap))); 
					rtnMap.put("rtrvl_tot_list", util.mapToJson(eprt9025801Mapper.eprt9025801_select2(inputMap))); 
					
					rtnMap.put("totalList", util.mapToJson(eprt9025801Mapper.eprt9025801_select_cnt(inputMap))); 
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	  
	    	return rtnMap;    	
	    }
		   
		/**
		 * 반환정보조회 확인처리
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String eprt9025801_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");  
				try {
					
						inputMap.put("RTRVL_STAT_CD_CK", "A");
						int stat = eprt9025801Mapper.eprt9025801_select3(inputMap); //상태 체크
						if(stat>0){
							throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						 }
						if(vo !=null){
							inputMap.put("REG_PRSN_ID", vo.getUSER_ID());  		// 등록자
						}
						inputMap.put("RTRVL_STAT_CD", "RC");  						// 소매업자확인 상태
						eprt9025801Mapper.eprt9025801_update(inputMap); 	// 상태변경
  				}catch (Exception e) {
					 if(e.getMessage().equals("A012")){
						 throw new Exception(e.getMessage()); 
					 }else{
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					 }
				}  
			return errCd;    	  
	    }
		
		
/***********************************************************************************************************************************************
*	반환정보 상세조회
************************************************************************************************************************************************/
		
		/**
		 * 반환정보조회 상세조회 초기 화면
		 * @param inputMap
		 * @param request      
		 * @return   
		 * @
		 */   
		  public ModelMap eprt9025864_select(ModelMap model, HttpServletRequest request) {
			  
			  	//파라메터 정보
				String reqParams 			= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams 		= JSONObject.fromObject(reqParams);
				Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				if(vo != null){
					map.put("BIZRID", vo.getBIZRID());  					
					map.put("BIZRNO", vo.getBIZRNO_ORI());  			
					map.put("BRCH_ID", vo.getBRCH_ID());  				// 지점ID   
					map.put("BRCH_NO", vo.getBRCH_NO());  			// 지점번호  
				}
				List<?>	initList 				= eprt9025801Mapper.eprt9025864_select(map);   	//상세 그리드 값   
				String   title						= commonceService.getMenuTitle("EPRT9025864");	//타이틀
				  
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
  *	반환정보 등록
  ************************************************************************************************************************************************/
	
	/**
	 * 반환정보등록 초기 화면
	 * @param inputMap
	 * @param request
	 * @return  
	 * @
	 */
	  public ModelMap eprt9025831_select(ModelMap model, HttpServletRequest request) {
		      
		   
			String reqParams 				= util.null2void(request.getParameter("INQ_PARAMS"),"{}");	//파라메터 정보  
			JSONObject jParams 			= JSONObject.fromObject(reqParams);
			Map<String, String> map 		= new HashMap<String, String>();
			
			HttpSession session = request.getSession();   
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if(vo != null){  
				map.put("BIZRID", vo.getBIZRID());  		   			
				map.put("BIZRNO", vo.getBIZRNO_ORI());  			
				map.put("BRCH_ID", vo.getBRCH_ID());  				   
				map.put("BRCH_NO", vo.getBRCH_NO());  			
				map.put("BIZR_TP_CD", vo.getBIZR_TP_CD());    			  		
			}              
			List<?>	whsdl_cd_list 			= eprt9025801Mapper.eprt9025831_select2(map);   //도매업자 업체명조회
			List<?>	dps_fee_list 			= commonceService.rtrvl_ctnr_dps_fee_select(map);   //도매업자 업체명조회
			map.put("WORK_SE", "4"); 																	//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
			HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);		//등록일자제한설정
			
			String title = commonceService.getMenuTitle("EPRT9025831");	//타이틀
			model.addAttribute("titleSub", title);
		
			try {   
					model.addAttribute("INQ_PARAMS",jParams);
					model.addAttribute("whsdl_cd_list", util.mapToJson(whsdl_cd_list));	
					model.addAttribute("dps_fee_list", util.mapToJson(dps_fee_list));	
					model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));	  	    //등록일자제한설정
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	   
			return model;    	    
	    }       
		      
		/**
		 * 반환정보등록 날짜 변경시 보증금,수수료조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap eprt9025831_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
  		try {
	  			HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				if(vo != null){
					inputMap.put("BIZR_TP_CD", vo.getBIZR_TP_CD());  	   				
				}   
  				rtnMap.put("dps_fee_list", util.mapToJson(commonceService.rtrvl_ctnr_dps_fee_select(inputMap))); 	//회수용기 보증금 취급수수료
			} catch (Exception e) {   
				// TODO Auto-generated catch block   
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	  
			return rtnMap;    	   
	    }
		   
				    
		/**   
		 *  반환정보등록  저장   
		 * @param data    
		 * @param request  
		 * @return 
		 * @throws Exception 
		 * @
		 */
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String eprt9025831_insert(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
				String errCd = "0000";
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				//Map<String, String> map;
				List<?> list = JSONArray.fromObject(inputMap.get("list"));
				List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();
				boolean keyCheck = false;
				String doc_no ="";	//문서번호
				   
				if (list != null) {  
					try {   
							  
						for(int i=0; i<list.size(); i++){
							Map<String, String> map = (Map<String, String>) list.get(i);
							if(vo != null){		//로그인자 정보
								map.put("BIZRID", vo.getBIZRID());  					
								map.put("BIZRNO", vo.getBIZRNO_ORI());  			    
								map.put("BIZRNM", vo.getBIZRNM());  
								map.put("BRCH_ID", vo.getBRCH_ID());  			
								map.put("BRCH_NO", vo.getBRCH_NO());  
								map.put("REG_PRSN_ID", vo.getUSER_ID());	
							}
							int sel = eprt9025801Mapper.eprt9025831_select(map); //중복체크    
							if(sel>0){  
									inputMap.put("ERR_CTNR_NM", map.get("CTNR_NM").toString());
									throw new Exception("A003"); 		//중복된 데이터 입니다. 다시 한번 확인해주시기 바랍니다.
							}    

							map.put("SDT_DT", map.get("RTRVL_DT"));	//등록일자제한설정  등록일자 1.DLIVY_DT,2.DRCT_RTRVL_DT, 3.EXCH_DT, 4.RTRVL_DT, 5.RTN_DT
							map.put("WORK_SE", "4"); 							//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
							sel =commonceService.rtc_dt_ck(map);		//등록일자제한설정
							if(sel !=1){
								throw new Exception("A021"); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
							}      
							
						 	if(!keyCheck){        
							 		int selCnt= eprt9025801Mapper.eprt9025801_select4(map); //회수등록구분
									if(selCnt <1) {
										throw new Exception("A019"); 	//반환등록이 가능한 거래처가 아닙니다. 다시 한번 확인해주시기 바랍니다.
									}
									map.put("RTRVL_STAT_CD", "RG");	//회수상태코드          
							 		//master  
						 			String doc_psnb_cd ="RV"; 		  						   					
							 		doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 문서번호조회
									map.put("RTRVL_DOC_NO", doc_no);									// 문서채번
									eprt9025801Mapper.eprt9025831_insert(map); 						// 회수마스터  등록
							 		list2.add(map);
							 		keyCheck = true;
						 	}else{
						 		map.put("RTRVL_DOC_NO", doc_no);										// 문서채번
						 	}
						 	//detail
						 	eprt9025801Mapper.eprt9025831_insert2(map); 							// 회수상세
							 
						}//end of for
						
						//마스터 등록 length 길이만큼   회수량, 수수료 SUM update
					 	for(int j=0 ;j<list2.size(); j++){
					 		Map<String, String> map = (Map<String, String>) list2.get(j);
					 		eprt9025801Mapper.eprt9025831_update(map);
					 	}   
						   
					} catch (Exception e) {
						 if(e.getMessage().equals("A003")){
							 throw new Exception(e.getMessage()); 
						 }else  if(e.getMessage().equals("A019")){
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
   *	반환정보수정
   ************************************************************************************************************************************************/
 	     
 	/**
 	 * 반환정보수정 초기 화면
 	 * @param inputMap
 	 * @param request   
 	 * @return   
 	 * @          
 	 */  
 	  public ModelMap eprt9025842_select(ModelMap model, HttpServletRequest request) {
 		                      
 		  	//파라메터 정보       
 			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");      
 			JSONObject jParams = JSONObject.fromObject(reqParams);    
 			Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));   
 			String   title					= commonceService.getMenuTitle("EPRT9025842");		//타이틀   
 			List<?>	initList 			= eprt9025801Mapper.eprt9025842_select(map);    		//상세 그리드 값  
 			map.put("WORK_SE", "4");    				   														//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
			HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);		//등록일자제한설정  
 			try {  
 				model.addAttribute("initList", util.mapToJson(initList));	      
 				model.addAttribute("INQ_PARAMS",jParams);
 				model.addAttribute("titleSub", title);                         
 				model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));	  	    //등록일자제한설정
 			} catch (Exception e) {
 				// TODO Auto-generated catch block
 				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
 			}	               
 			return model;    	  
 	    }        
  		
 	 /**
		 *  반환정보수정  저장
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @   
		 */       
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String eprt9025842_insert(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
   				HttpSession session = request.getSession();      
				UserVO vo = (UserVO) session.getAttribute("userSession");   
				String errCd = "0000";   
				   
				//Map<String, String> map;    
				List<?> list = JSONArray.fromObject(inputMap.get("list"));
				List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();       
				boolean keyCheck = false;
				  
				if (list != null) {                      
					try {     
						for(int i=0; i<list.size(); i++){
								Map<String, String> map = (Map<String, String>) list.get(i);
								if(vo != null){		//로그인자 정보
									map.put("BIZRID", vo.getBIZRID());  					
									map.put("BIZRNO", vo.getBIZRNO_ORI());  			    
									map.put("BIZRNM", vo.getBIZRNM());  
									map.put("BRCH_ID", vo.getBRCH_ID());  			  
									map.put("BRCH_NO", vo.getBRCH_NO());  
									map.put("REG_PRSN_ID", vo.getUSER_ID());	
								}
								int sel = eprt9025801Mapper.eprt9025831_select(map); //중복체크       
								if(sel>0){
										inputMap.put("ERR_CTNR_NM", map.get("CTNR_NM").toString());
										throw new Exception("A003"); 		//중복된 데이터 입니다. 다시 한번 확인해주시기 바랍니다.
								}            
								
								map.put("SDT_DT", map.get("RTRVL_DT"));	//등록일자제한설정  등록일자 1.DLIVY_DT,2.DRCT_RTRVL_DT, 3.EXCH_DT, 4.RTRVL_DT, 5.RTN_DT
								map.put("WORK_SE", "4"); 							//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
								sel =commonceService.rtc_dt_ck(map);		//등록일자제한설정
								if(sel !=1){
									throw new Exception("A021"); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
								}    
							   
							 	if(!keyCheck){       
							 			map.put("RTRVL_STAT_CD_CK", "C");  
										int stat = eprt9025801Mapper.eprt9025801_select3(map); //상태 체크
										if(stat>0){
											throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
										 } 
							 			if(map.get("RTRVL_STAT_CD").equals("WG") ){//상태가  도매업자등록인경우 소매업자회수조정으로 변경
							 				map.put("RTRVL_STAT_CD", "RJ");
							 				eprt9025801Mapper.eprt9025801_update(map);		//mst상태변경
							 			}
							 			eprt9025801Mapper.eprt9025842_delete(map); 			// info삭제
								 		list2.add(map);
								 		keyCheck = true;   
							 	}//end of if(!keyCheck)
							 	//detail
							 	eprt9025801Mapper.eprt9025831_insert2(map); 					// 회수상세
						}//end of for  
						
						//마스터 등록 length 길이만큼   회수량, 수수료 SUM update
					 	for(int j=0 ;j<list2.size(); j++){
					 		Map<String, String> map3 = (Map<String, String>) list2.get(j);
					 		eprt9025801Mapper.eprt9025831_update(map3);
					 	}   
						   
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
		
	    /**
		 * 반환정보변경 삭제
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String eprt9025842_delete(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");  
				try {
						inputMap.put("RTRVL_STAT_CD_CK", "B");
						int stat = eprt9025801Mapper.eprt9025801_select3(inputMap); //상태 체크
						if(stat>0){
							throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						 }
						eprt9025801Mapper.eprt9025842_delete2(inputMap); 	//삭제
  				}catch (Exception e) {
					 if(e.getMessage().equals("A012")){
						 throw new Exception(e.getMessage()); 
					 }else{
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					 }
				}  
			return errCd;    	  
	    } 
	    
	    
}
