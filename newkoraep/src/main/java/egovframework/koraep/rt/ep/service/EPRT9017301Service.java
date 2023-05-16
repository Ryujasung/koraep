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
import egovframework.mapper.rt.ep.EPRT9017301Mapper;
    
/**
 * 반환업무설정 Service     
 * @author 양성수  
 *
 */  
@Service("eprt9017301Service")   
public class EPRT9017301Service {   
	
	@Resource(name="eprt9017301Mapper")
	private EPRT9017301Mapper eprt9017301Mapper;  //반환업무설정조회 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**   
	 * 반환업무설정 초기화면
	 * @param inputMap  
	 * @param request   
	 * @return    
	 * @  
	 */
	  public ModelMap eprt9017301_select(ModelMap model, HttpServletRequest request) {
			
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);    
			Map<String, String> map = new HashMap<String, String>();   
			HttpSession session = request.getSession();      
			UserVO vo = (UserVO) session.getAttribute("userSession");    
			if(vo != null){                   
				map.put("BIZRID", vo.getBIZRID());  		     			
				map.put("BIZRNO", vo.getBIZRNO_ORI());  			  
				map.put("BRCH_ID", vo.getBRCH_ID());  				   
				map.put("BRCH_NO", vo.getBRCH_NO());  			  
			}  
			
			List<?>	initList_m 		= eprt9017301Mapper.eprt9017301_select(map);  //생산자
			List<?>	initList_w 		= eprt9017301Mapper.eprt9017301_select2(map);  //도매업자  
			try {
				model.addAttribute("initList_m", util.mapToJson(initList_m));	
				model.addAttribute("initList_w", util.mapToJson(initList_w));	    
				model.addAttribute("INQ_PARAMS",jParams);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	
			return model;    	
	    }
	  	  
		/**
		 *반환업무설정 도매업자 조회     
		 * @param inputMap         
		 * @param request
		 * @return
		 * @
		 */
		public HashMap eprt9017301_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	try {
	    		HttpSession session = request.getSession();      
				UserVO vo = (UserVO) session.getAttribute("userSession");    
				if(vo != null){                     
					inputMap.put("BIZRID", vo.getBIZRID());  		     			
					inputMap.put("BIZRNO", vo.getBIZRNO_ORI());  			  
					inputMap.put("BRCH_ID", vo.getBRCH_ID());  			  	   
					inputMap.put("BRCH_NO", vo.getBRCH_NO());  	   	  
				}  
				rtnMap.put("initList_w", util.mapToJson(eprt9017301Mapper.eprt9017301_select2(inputMap))); //도매업자조회
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}    	 
			return rtnMap;    	  
	    }  

	  	/**
		 *  반환업무설정 저장
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @   
		 */       
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String eprt9017301_insert(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
 				HttpSession session = request.getSession();      
				UserVO vo = (UserVO) session.getAttribute("userSession");   
				String errCd = "0000";   
				//Map<String, String> map;    
				List<?> list = JSONArray.fromObject(inputMap.get("list"));  
				if (list != null) {                          
					try {         
						for(int i=0; i<list.size(); i++){
								Map<String, String> map = (Map<String, String>) list.get(i);
								if(vo != null){		//로그인자 정보
									map.put("BIZRID", vo.getBIZRID());  					
									map.put("BIZRNO", vo.getBIZRNO_ORI());  			    
									map.put("BRCH_ID", vo.getBRCH_ID());  			  
									map.put("BRCH_NO", vo.getBRCH_NO());  
									map.put("REG_PRSN_ID", vo.getUSER_ID());	  
								}
								if(map.get("BIZR_TP_CD") !=null && map.get("BIZR_TP_CD").equals("M")){
									eprt9017301Mapper.eprt9017301_update(map);    
								}else if(map.get("BIZR_TP_CD") !=null && map.get("BIZR_TP_CD").equals("W")){
									eprt9017301Mapper.eprt9017301_update2(map);     
								}    
						}//end of for  
						   
					} catch (Exception e) {
						throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					}
				}//end of list
				return errCd;    
	    }      
	  
/***********************************************************************************************************************************************
*	거래처추가
************************************************************************************************************************************************/
		
		/**
		 * 거래처추가 초기화면
		 * @param inputMap
		 * @param request      
		 * @return   
		 * @
		 */   
		  public ModelMap eprt9017331_select(ModelMap model, HttpServletRequest request) {
			  
			  	//파라메터 정보
				String reqParams 			= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				Map<String, String> map = new HashMap<String, String>();
				String   title						= commonceService.getMenuTitle("EPRT9017331");		//타이틀
				List<?>	whsdlList 			= commonceService.mfc_bizrnm_select4(request, map);    			//도매업자 업체명조회
				try {    
					model.addAttribute("whsdlList", util.mapToJson(whsdlList));	      
					model.addAttribute("titleSub", title);        
				} catch (Exception e) {     
					// TODO Auto-generated catch block       
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	    
				return model;    	         
		    }     

		  	/**
			 * 거래처추가 도매업자지점
			 * @param inputMap
			 * @param request
			 * @return
			 * @
			 */
			public HashMap eprt9017331_select2(Map<String, String> inputMap, HttpServletRequest request) {
		    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		    	try {
					rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, inputMap))); //지점 조회
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}    	 
				return rtnMap;    	
		    }
		  
			
			/**
			 *  거래처추가 저장
			 * @param data
			 * @param request
			 * @return
			 * @throws Exception 
			 * @   
			 */       
		    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
			public String eprt9017331_insert(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
	 				HttpSession session = request.getSession();      
					UserVO vo = (UserVO) session.getAttribute("userSession");   
					String errCd = "0000";   
					try {         
							if(vo != null){		//로그인자 정보
								inputMap.put("BIZRID", vo.getBIZRID());  					
								inputMap.put("BIZRNO", vo.getBIZRNO_ORI());  			    
								inputMap.put("BRCH_ID", vo.getBRCH_ID());  			  
								inputMap.put("BRCH_NO", vo.getBRCH_NO());  
								inputMap.put("BIZRNM", vo.getBIZRNM());	 
								inputMap.put("BIZR_TP_CD", vo.getBIZR_TP_CD());	   
								inputMap.put("REG_PRSN_ID", vo.getUSER_ID());	    
							}
							int selCnt  = eprt9017301Mapper.eprt9017331_select(inputMap);    
							if( selCnt>0){
								throw new Exception("A020"); //이미 등록된 거래처 입니다.
							}
							 eprt9017301Mapper.eprt9017331_insert(inputMap);    
					} catch (Exception e) {
						 if(e.getMessage().equals("A020")){
							 throw new Exception(e.getMessage()); 
						 }else{
							 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
						 }
					}
					return errCd;    
		    }    
		
}
