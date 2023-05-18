package egovframework.koraep.wh.ep.service;
  
import java.io.IOException;
import java.sql.SQLException;
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
import org.springframework.web.util.WebUtils;

import egovframework.common.EgovFileMngUtil;
import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.wh.ep.EPWH0121801Mapper;
import egovframework.mapper.wh.ep.EPWH2925801Mapper;
    
/**
 * 회수정보관리 Service     
 * @author 양성수  
 *
 */  
@Service("epwh2925801Service")   
public class EPWH2925801Service {   
	
	@Resource(name="epwh2925801Mapper")
	private EPWH2925801Mapper epwh2925801Mapper; //회수정보관리 Mapper

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
	  public ModelMap epwh2925801_select(ModelMap model, HttpServletRequest request) {
			
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
			
			Map<String, String> map= new HashMap<String, String>();
			List<?> bizr_tp_cd_list	= commonceService.whsdl_se_select(request, map);  		 			//도매업자구분
			List<?> stat_cd_list		= commonceService.getCommonCdListNew("D020");						//상태
			String   title					= commonceService.getMenuTitle("EPWH2925801");						//타이틀
			  
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
					List<?>	whsdl_cd_list = commonceService.mfc_bizrnm_select4(request, map);    			//도매업자 업체명조회
					
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
		 * 회수정보관리 업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2925801_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
		      	rtnMap.put("whsdl_cd_list", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 도매업자 업체명조회
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
		 * 회수정보관리 지점조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2925801_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    		try {
    			
    			HttpSession session = request.getSession();
    			UserVO vo = (UserVO) session.getAttribute("userSession");
    			if(vo != null){
    				inputMap.put("BIZRID", vo.getBIZRID());
    				inputMap.put("BIZRNO", vo.getBIZRNO_ORI());
    				if(!vo.getBRCH_NO().equals("9999999999")){
    					inputMap.put("BRCH_ID", vo.getBRCH_ID());
    					inputMap.put("BRCH_NO", vo.getBRCH_NO());
    				}
    			}
    			
    			rtnMap.put("brch_cd_List", util.mapToJson(commonceService.brch_nm_select_all(inputMap))); // 도매업자 지점
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
		 * 회수정보관리  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2925801_select4(Map<String, Object> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    		try {
	    			
	    			HttpSession session = request.getSession();
	    			UserVO vo = (UserVO) session.getAttribute("userSession");
	    			if(vo != null){
	    				inputMap.put("WHSDL_BIZRID", vo.getBIZRID());
	    				inputMap.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());
	    				if(!vo.getBRCH_NO().equals("9999999999")){
	    					inputMap.put("S_BRCH_ID", vo.getBRCH_ID());
	    					inputMap.put("S_BRCH_NO", vo.getBRCH_NO());
	    				}
	    			}
	    			
					rtnMap.put("selList", util.mapToJson(epwh2925801Mapper.epwh2925801_select(inputMap))); 
					rtnMap.put("totalList", util.mapToJson(epwh2925801Mapper.epwh2925801_select_cnt(inputMap)));
					rtnMap.put("amt_tot_list", util.mapToJson(epwh2925801Mapper.epwh2925801_select2(inputMap))); 
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
		 * 회수정보관리 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epwh2925801_excel(HashMap<String, Object> data, HttpServletRequest request) {
			
			String errCd = "0000";
			try {
				
				HttpSession session = request.getSession();
    			UserVO vo = (UserVO) session.getAttribute("userSession");
    			if(vo != null){
    				data.put("WHSDL_BIZRID", vo.getBIZRID());
    				data.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());
    				if(!vo.getBRCH_NO().equals("9999999999")){
    					data.put("S_BRCH_ID", vo.getBRCH_ID());
    					data.put("S_BRCH_NO", vo.getBRCH_NO());
    				}
    			}
				
				List<?> list = epwh2925801Mapper.epwh2925801_select(data);
				
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
		public String epwh2925801_delete(Map<String, String> inputMap, HttpServletRequest request) throws Exception  {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));

			try {

				if (list != null && list.size() > 0 && !list.get(0).equals(null) && !list.get(0).equals("null") ) {

					for (int i = 0; i < list.size(); i++) {
						map = (Map<String, String>) list.get(i);
						int stat = epwh2925801Mapper.epwh2925801_select3(map); // 상태 체크
						if (stat > 0) {
							throw new Exception("A012"); // 상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						}
						epwh2925801Mapper.epwh2925801_delete(map); //  삭제
					}

				}else{ //단건 삭제
					
					int stat = epwh2925801Mapper.epwh2925801_select3(inputMap); // 상태 체크
					if (stat > 0) {
						throw new Exception("A012"); // 상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
					}
					epwh2925801Mapper.epwh2925801_delete(inputMap); // 삭제
				}
			
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				if (e.getMessage().equals("A012")) {
					 throw new Exception(e.getMessage()); 
				} else {
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
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
		public String epwh2925801_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
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
						 int stat = epwh2925801Mapper.epwh2925801_select3(map); //상태 체크
						 if(stat>0){
								throw new Exception("A012"); // 상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						 }
						 
						 if(map.get("RTRVL_STAT_CD").equals("RG") ||  map.get("RTRVL_STAT_CD").equals("WJ") ){
							 map.put("RTRVL_STAT_CD", "WC");
						 }else  if(map.get("RTRVL_STAT_CD").equals("WG") ||  map.get("RTRVL_STAT_CD").equals("RJ") ){
							 map.put("RTRVL_STAT_CD", "RC");  
						 }    

						 map.put("UPD_PRSN_ID", ssUserId);  	//요청자
						 epwh2925801Mapper.epwh2925801_update(map);
					}       
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
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
		  public ModelMap epwh2925864_select(ModelMap model, HttpServletRequest request) {
			  
			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
				List<?>	initList = epwh2925801Mapper.epwh2925842_select(map); //상세 그리드 값   
				String title = commonceService.getMenuTitle("EPWH2925864");	//타이틀
				
				try {
					model.addAttribute("initList", util.mapToJson(initList));	
					model.addAttribute("INQ_PARAMS",jParams);
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
	  public ModelMap epwh2925831_select(ModelMap model, HttpServletRequest request) {
		      
		  	//파라메터 정보   
			String reqParams 				= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams 			= JSONObject.fromObject(reqParams);
			Map<String, String> map 		= new HashMap<String, String>();
			String   	title						= commonceService.getMenuTitle("EPWH2925831");			//타이틀
			List<?>	whsdl_cd_list 			= commonceService.mfc_bizrnm_select4(request, map);    //도매업자 업체명조회
			map.put("WORK_SE", "4"); 																					//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
			HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);						//등록일자제한설정  
			
			try {
					model.addAttribute("titleSub", title);
					model.addAttribute("INQ_PARAMS",jParams);
					model.addAttribute("whsdl_cd_list", util.mapToJson(whsdl_cd_list));	
					model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));	  	 
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
		 * 회수정보등록도매업자 변경시    지점 & 보증금,수수료 조회
		 * @param inputMap
		 * @param request
		 * @return   
		 * @
		 */
		public HashMap epwh2925831_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	  		try {
	  			
	  			HttpSession session = request.getSession();
    			UserVO vo = (UserVO) session.getAttribute("userSession");
    			String brchIdNo = "";
    			if(vo != null){
    				inputMap.put("BIZRID", vo.getBIZRID());
					inputMap.put("BIZRNO", vo.getBIZRNO_ORI());
    				brchIdNo = vo.getBRCH_ID()+";"+vo.getBRCH_NO();
    				if(!vo.getBRCH_NO().equals("9999999999")){
    					inputMap.put("BRCH_ID", vo.getBRCH_ID());
    					inputMap.put("BRCH_NO", vo.getBRCH_NO());
    				}
    			}
	  			
	  			rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select_all(inputMap))); // 도매업자 지점
	  			rtnMap.put("dps_fee_list", util.mapToJson(commonceService.rtrvl_ctnr_dps_fee_select(inputMap))); //회수용기 보증금 취급수수료
	  			rtnMap.put("brchIdNo", brchIdNo);
	  			
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
		 * 회수정보등록 날짜 변경시 보증금,수수료조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2925831_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
  		try {
  				rtnMap.put("dps_fee_list", util.mapToJson(commonceService.rtrvl_ctnr_dps_fee_select(inputMap))); 	//회수용기 보증금 취급수수료
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
		 * 회수정보등록 엑셀업로드 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2925831_select4(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	String brchIdNo = "";
 			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if(vo != null){
				inputMap.put("WHSDL_BIZRID", vo.getBIZRID());
				inputMap.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());
				inputMap.put("S_BRCH_ID", vo.getBRCH_ID());
				inputMap.put("S_BRCH_NO", vo.getBRCH_NO());
			}
	    	
	    	try {  
  				  
	    		if(!inputMap.get("S_BRCH_NO").equals(inputMap.get("WHSDL_BRCH_NO"))){ //로그인 사용자의 지점번호만 등록 가능
	    			return rtnMap;
	    		}
	    		
  				Map<String, String> map = epwh2925801Mapper.epwh2925831_select3(inputMap);
  				inputMap.put("WHSDL_BRCH_ID", map.get("BRCH_ID"));		//도매업자지점 아이디
  				inputMap.put("WHSDL_BRCH_NM", map.get("BRCH_NM"));	//도매업자 지점이름
  			    
  				rtnMap.put("selList", util.mapToJson(epwh2925801Mapper.epwh2925831_select4(inputMap))); 	
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
		 * 소매업자 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2925831_select5(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
 			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if(vo != null){
				inputMap.put("WHSDL_BIZRID", vo.getBIZRID());
				inputMap.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());
			}
	    	
	    	try {  
  				rtnMap.put("selList", util.mapToJson(epwh2925801Mapper.epwh2925831_select5(inputMap))); 	
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
		 *  회수정보등록  저장
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String epwh2925831_insert(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
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
							String doc_no ="";
							keyCheck = false;
							Map<String, String> map = (Map<String, String>) list.get(i);
							
							if(!map.containsKey("RMK")) {
								map.put("RMK", "");
							}
							
							if(vo != null){
								ssUserId = vo.getUSER_ID();   
								map.put("S_USER_ID", ssUserId);  
								map.put("WHSDL_BIZRID", vo.getBIZRID());
								map.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());
								//로그인사 지점정보로 처리
								map.put("WHSDL_BRCH_ID", vo.getBRCH_ID());
								map.put("WHSDL_BRCH_NO", vo.getBRCH_NO());
							}
							
							//존재하는지 체크
							Map<String, String> checkMap= new HashMap<String, String>(); 
							checkMap = epwh2925801Mapper.epwh2925831_select(map); //소매정보 조회

							if(checkMap !=null) {
								if(!checkMap.get("BIZRID").equals("") && !checkMap.get("BRCH_ID").equals("N") ){ //사업자, 지점 둘다 등록상태
									//이미 해당 사업자번호로 사업자 및 지점이 등록되어있는 경우는 해당 데이터를 통해 거래처를 등록한다.  즉  작성한 거래처명, 사업자유형은 무시함
									//errCd = ""; //이미 등록된 소매거래처 지점정보로 저장된 건이 있습니다. 등록결과를 확인하시기 바랍니다.
									map.put("RTL_CUST_BIZRNO",checkMap.get("BIZRNO"));     
									map.put("RTL_CUST_BIZRID",checkMap.get("BIZRID")); 
									map.put("RTL_CUST_BRCH_ID",checkMap.get("BRCH_ID") );     
									map.put("RTL_CUST_BRCH_NO",checkMap.get("BRCH_NO"));     
								}
								else{ //소매정보 없을경우
									String bizrTpCd = "D3";
									checkMap.put("S_USER_ID", ssUserId);
									checkMap.put("BIZR_TP_CD", bizrTpCd);
									checkMap.put("BIZRNM", map.get("REG_CUST_NM"));

									epwh0121801Mapper.epwh0121831_insert2(checkMap); //소매 지점등록
									
									map.put("RTL_CUST_BIZRNO",checkMap.get("BIZRNO"));     
									map.put("RTL_CUST_BIZRID",checkMap.get("BIZRID")); 
									map.put("RTL_CUST_BRCH_ID","9999999999");     
									map.put("RTL_CUST_BRCH_NO","9999999999");
								}
							}
							else {
								checkMap = new HashMap<String, String>();
								
								String bizrTpCd = "D3";
								checkMap.put("S_USER_ID", ssUserId);
								checkMap.put("BIZR_TP_CD", bizrTpCd);
								checkMap.put("BIZRNO", map.get("RTL_CUST_BIZRNO"));
								checkMap.put("BIZRNM", map.get("REG_CUST_NM"));

								String psnbSeq = commonceService.psnb_select("S0001"); //사업자ID 일련번호 채번

								//map.put("BIZRID", "D3H"+psnbSeq); //사업자ID = 소매거래처등록사업자(D3) - 수기(H)
								checkMap.put("BIZRID", bizrTpCd+"H"+psnbSeq); 		//사업자ID = R1 가정용;R2 영업용 - 수기(H)
								epwh0121801Mapper.epwh0121831_insert(checkMap); 	//소매 사업자등록
								epwh0121801Mapper.epwh0121831_insert2(checkMap); 	//소매 지점등록
								
								map.put("RTL_CUST_BIZRID", checkMap.get("BIZRID"));
								map.put("RTL_CUST_BRCH_ID", "9999999999");
								map.put("RTL_CUST_BRCH_NO", "9999999999");
							}
							
							int sel=0;
							
							//20200921정제영주임요청으로 비지에프리테일 담당자 로그인시 중복체크 생략
							if(ssUserId.equals("bgfretail2") || ssUserId.equals("gsretail2006") || ssUserId.equals("gsretail2018")) {
							}
							else {
								sel = epwh2925801Mapper.epwh2925831_select2(map); //중복체크
							}
							
							if(sel>0){  
									inputMap.put("ERR_CTNR_NM", map.get("CTNR_NM").toString());
									throw new Exception("A003"); //중복된 데이터 입니다. 다시 한번 확인해주시기 바랍니다.
							}    
							        
							map.put("SDT_DT", map.get("RTRVL_DT"));	//등록일자제한설정  등록일자 1.DLIVY_DT,2.DRCT_RTRVL_DT, 3.EXCH_DT, 4.RTRVL_DT, 5.RTN_DT
							map.put("WORK_SE", "4"); 						//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
							sel =commonceService.rtc_dt_ck(map);	//등록일자제한설정
							if(sel !=1){
								throw new Exception("A021"); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
							}
							
							String rtrvl_stat_cd = epwh2925801Mapper.epwh2925801_select4(map); //회수등록구분
							if(rtrvl_stat_cd ==null){      
								 rtrvl_stat_cd ="VC";       
							}
							map.put("RTRVL_STAT_CD", rtrvl_stat_cd);	//회수상태코드          
							              
						 	for(int j=0 ;j<list2.size(); j++){
							 		Map<String, String> map2 = (Map<String, String>) list2.get(j); 
							 		if( 		 map.get("RTL_CUST_BIZRNO").equals(map2.get("RTL_CUST_BIZRNO")) && map.get("RTL_CUST_BIZRID").equals(map2.get("RTL_CUST_BIZRID"))       //회수처 지점
									 			&&map.get("RTL_CUST_BRCH_ID").equals(map2.get("RTL_CUST_BRCH_ID"))  && map.get("RTL_CUST_BRCH_ID").equals(map2.get("RTL_CUST_BRCH_ID")) ) //회수처
							 	    {   
							 			map.put("RTRVL_DOC_NO",map2.get("RTRVL_DOC_NO"));  
							 			keyCheck = true;      
							 			break;          
							 		}//end of if   
						 	}//end of for list2     
						 	if(!keyCheck){        
							 		//master  
						 			String doc_psnb_cd ="RV"; 		  						   					
							 		doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 문서번호조회
									map.put("RTRVL_DOC_NO", doc_no);									// 문서채번
									epwh2925801Mapper.epwh2925831_insert(map); 				// 회수마스터  등록
							 		list2.add(map);
						 	}	
						 	//detail
						 	epwh2925801Mapper.epwh2925831_insert2(map); 					// 회수상세
							 
						}//end of for
						
						//마스터 등록 length 길이만큼   회수량, 수수료 SUM update
					 	for(int j=0 ;j<list2.size(); j++){
					 		Map<String, String> map = (Map<String, String>) list2.get(j);
					 		epwh2925801Mapper.epwh2925831_update(map);
					 	}     
						   
					}catch (IOException io) {
						System.out.println(io.toString());
					}catch (SQLException sq) {
						System.out.println(sq.toString());
					}catch (NullPointerException nu){
						System.out.println(nu.toString());
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
   *	회수정보수정
   ************************************************************************************************************************************************/
 	     
 	/**
 	 * 회수정보수정 초기 화면
 	 * @param inputMap
 	 * @param request   
 	 * @return   
 	 * @          
 	 */  
 	  public ModelMap epwh2925842_select(ModelMap model, HttpServletRequest request) {

 		  	//파라메터 정보  
 			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");      
 			JSONObject jParams = JSONObject.fromObject(reqParams);    
 			Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));   
 			
 			String brchIdNo = "";
 			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if(vo != null){
				map.put("WHSDL_BIZRID", vo.getBIZRID());
				map.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());
				brchIdNo = vo.getBRCH_ID()+";"+vo.getBRCH_NO();
				if(!vo.getBRCH_NO().equals("9999999999")){
					map.put("BRCH_ID", vo.getBRCH_ID());
					map.put("BRCH_NO", vo.getBRCH_NO());
				}
			}
 			
 			String title	= commonceService.getMenuTitle("EPWH2925842");	 //타이틀   
 			List<?>	initList = epwh2925801Mapper.epwh2925842_select(map); //상세 그리드 값  
 			map.put("WORK_SE", "4"); 																			//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
			HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);				//등록일자제한설정  
			
			map.put("BIZRID", map.get("WHSDL_BIZRID"));
 			map.put("BIZRNO", map.get("WHSDL_BIZRNO"));
 			//List<?>	brch_nmList = commonceService.brch_nm_select_all(map);    				//도매업자지점
 			
 			model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));	  	  
 			try {  
 				//model.addAttribute("brch_nmList", util.mapToJson(brch_nmList));	     
 				model.addAttribute("initList", util.mapToJson(initList));	      
 				model.addAttribute("INQ_PARAMS",jParams);
 				model.addAttribute("titleSub", title);
 				model.addAttribute("brchIdNo", brchIdNo);
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
		 *  회수정보수정  저장
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @   
		 */       
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String epwh2925842_insert(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
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
								
								if(!map.containsKey("RMK")) {
									map.put("RMK", "");
								}
								
								if(vo != null){
									ssUserId = vo.getUSER_ID();   
									map.put("S_USER_ID", ssUserId);  
								}

								int sel = epwh2925801Mapper.epwh2925831_select2(map); //중복체크       
								if(sel>0){
									inputMap.put("ERR_CTNR_NM", map.get("CTNR_NM").toString());
									throw new Exception("A003"); //중복된 데이터 입니다. 다시 한번 확인해주시기 바랍니다.
								}
								
								map.put("SDT_DT", map.get("RTRVL_DT"));	//등록일자제한설정  등록일자 1.DLIVY_DT,2.DRCT_RTRVL_DT, 3.EXCH_DT, 4.RTRVL_DT, 5.RTN_DT
								map.put("WORK_SE", "4"); 						//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
								sel = commonceService.rtc_dt_ck(map);		//등록일자제한설정
								if(sel !=1){
									throw new Exception("A021"); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
								}          
								
							 	if(!keyCheck){   
							 			epwh2925801Mapper.epwh2925842_delete(map); 	// info삭제
								 		list2.add(map);
								 		keyCheck = true;   
								 		if(map.get("ADJ").equals("T")){
									 			if(map.get("RTRVL_STAT_CD").equals("RG") || map.get("RTRVL_STAT_CD").equals("WG") || map.get("RTRVL_STAT_CD").equals("RJ") || map.get("RTRVL_STAT_CD").equals("WJ") ){								 				
												 		if(map.get("RTRVL_STAT_CD").equals("RG")){
												 			map.put("RTRVL_STAT_CD", "WJ");
												 		}else if(map.get("RTRVL_STAT_CD").equals("WG")){
												 			map.put("RTRVL_STAT_CD", "RJ");
												 		}   
												 		epwh2925801Mapper.epwh29258422_update(map); //회수조정일경우 마스터 상태값 변경
									 			}
								 		}//end of if(map.get("ADJ").equals("T"))
							 	}//end of if(!keyCheck)
							 								 	
							 	//detail
							 	epwh2925801Mapper.epwh2925831_insert2(map); // 회수상세
						}//end of for  
						
						//마스터 등록 length 길이만큼   회수량, 수수료 SUM update
					 	for(int j=0 ;j<list2.size(); j++){
					 		Map<String, String> map3 = (Map<String, String>) list2.get(j);
					 		epwh2925801Mapper.epwh2925831_update(map3);
					 	}
						   
					}catch (IOException io) {
						System.out.println(io.toString());
					}catch (SQLException sq) {
						System.out.println(sq.toString());
					}catch (NullPointerException nu){
						System.out.println(nu.toString());
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
 	  public ModelMap epwh29258422_select(ModelMap model, HttpServletRequest request) {
 		        
 			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");      
			JSONObject jParams = JSONObject.fromObject(reqParams);    
			Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));   
			String   title					= commonceService.getMenuTitle("EPWH29258422");		//타이틀   
			List<?>	initList 			= epwh2925801Mapper.epwh2925842_select(map);    	//상세 그리드 값   
			map.put("BIZRID", map.get("WHSDL_BIZRID"));
 			map.put("BIZRNO", map.get("WHSDL_BIZRNO"));
 			List<?>	brch_nmList 	= commonceService.brch_nm_select(request, map);   			 	//도매업자지점
			  
			try {  
				model.addAttribute("brch_nmList", util.mapToJson(brch_nmList));	   
				model.addAttribute("initList", util.mapToJson(initList));	      
				model.addAttribute("INQ_PARAMS",jParams);
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
 	  public ModelMap epwh2925897_select(ModelMap model, HttpServletRequest request) {
 		      
 		  	//파라메터 정보
 			String reqParams 			= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
 			JSONObject jParams 		= JSONObject.fromObject(reqParams);   
 			Map<String, String> map = new HashMap<String, String>();
 			String   title					= commonceService.getMenuTitle("EPWH2925897");		//타이틀  
 			List<?>	whsdl_cd_list 		= commonceService.mfc_bizrnm_select4(request, map);    					//도매업자 업체명조회
 			try {
 				model.addAttribute("whsdl_cd_list", util.mapToJson(whsdl_cd_list));	   
 				model.addAttribute("INQ_PARAMS",jParams);
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
		 * 회수증빙자료관리	조회      
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */   
		public HashMap epwh2925897_select2(Map<String, Object> inputMap, HttpServletRequest request) {
	    		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
	    			
	    			HttpSession session = request.getSession();
	    			UserVO vo = (UserVO) session.getAttribute("userSession");
	    			if(vo != null){
	    				inputMap.put("WHSDL_BIZRID", vo.getBIZRID());
	    				inputMap.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());
	    			}
	    			
					rtnMap.put("selList", util.mapToJson(epwh2925801Mapper.epwh2925897_select (inputMap))); 
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
		 * 회수증빙관리 삭제
		 * @param inputMap  
		 * @param request    
		 * @return    
		 * @throws Exception       
		 * @    
		 */    
		public String epwh2925897_delete(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
			String errCd = "0000";
				try {  
						epwh2925801Mapper.epwh2925897_delete(inputMap); //  삭제  
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
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
 	  public ModelMap epwh2925888_select(ModelMap model, HttpServletRequest request) {
 		     
 		  	//파라메터 정보   
 			String reqParams 			= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
 			JSONObject jParams 		= JSONObject.fromObject(reqParams);
 			Map<String, String> map = new HashMap<String, String>();
 			String   title						= commonceService.getMenuTitle("EPWH2925888");		//타이틀
 			try {
 				model.addAttribute("INQ_PARAMS",jParams);   
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
		 * 증빙파일등록  저장
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String epwh2925888_insert(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");

			String fileName = "";
			String tmpFileName = "";
			String errCd = "0000";

			inputMap.put("WHSDL_BIZRID" ,request.getParameter("WHSDL_BIZRID"));
			inputMap.put("WHSDL_BIZRNO"  ,request.getParameter("WHSDL_BIZRNO"));
			inputMap.put("RTRVL_DT"  ,request.getParameter("RTRVL_DT"));
			//크로스추가
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
							epwh2925801Mapper.epwh2925888_insert(inputMap);	
						}
					}
					
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch (Exception e) {
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
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
 	  public ModelMap epwh29258882_select(@RequestParam Map<String, Object> param, ModelMap model, HttpServletRequest request) {
 		    
 		  	//파라메터 정보
 			String reqParams 	= util.null2void(request.getParameter("INQ_PARAMS"),"{}");  
 			JSONObject jParams 	= JSONObject.fromObject(reqParams);	
 			
 			List<?>	initList 			= epwh2925801Mapper.epwh2925897_select (param);
 			String  title    = commonceService.getMenuTitle("EPWH29258882");	 //타이틀
 			try {
 				model.addAttribute("initList", util.mapToJson(initList));
 				model.addAttribute("INQ_PARAMS",jParams);  
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
}
