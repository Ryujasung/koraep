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
import egovframework.mapper.ce.ep.EPCE2910101Mapper;
import egovframework.mapper.ce.ep.EPCE2910142Mapper;


/**
 * 반환내역서수정 Service
 * @author 양성수
 *
 */
@Service("epce2910142Service")
public class EPCE2910142Service {
	
	
	@Resource(name="epce2910142Mapper")
	private EPCE2910142Mapper epce2910142Mapper;  //반환내역서등록 Mapper
	
	@Resource(name="epce2910101Mapper")
	private EPCE2910101Mapper epce2910101Mapper;  //반환내역서등록 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 반환내역서수정 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce2910142_select(ModelMap model, HttpServletRequest request) {
		   Map<String, String>map = new HashMap<String, String>();
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
			JSONObject jParams2 =(JSONObject)jParams.get("PARAMS");
			System.out.println("jParams2"+jParams2);
			map.put("MFC_BIZRID", jParams2.get("MFC_BIZRID").toString());				//생산자ID
			map.put("MFC_BIZRNO", jParams2.get("MFC_BIZRNO").toString());			//생산자 사업자번호
			map.put("MFC_BRCH_ID", jParams2.get("MFC_BRCH_ID").toString());			//생산자 지점ID
			map.put("MFC_BRCH_NO", jParams2.get("MFC_BRCH_NO").toString());		//생산자 지점 사업자번호
			map.put("CUST_BIZRID", jParams2.get("WHSDL_BIZRID").toString());			//도매업자 ID
			map.put("CUST_BIZRNO", jParams2.get("WHSDL_BIZRNO_ORI").toString());//도매업자 사업자번호
			map.put("CUST_BRCH_ID", jParams2.get("WHSDL_BRCH_ID").toString());	//도매업자 지점 ID
			map.put("CUST_BRCH_NO", jParams2.get("WHSDL_BRCH_NO").toString());	//도매업자 지점번호
			map.put("RTN_DOC_NO", jParams2.get("RTN_DOC_NO").toString());			// 반환문서번호
			map.put("CTNR_SE", "2");		  															//빈용기 구분  신병
			map.put("RTN_DT", jParams2.get("RTN_DT_ORI").toString());					//반환일자
			map.put("GBN", jParams2.get("GBN").toString());					//임시구분
			String   title				= commonceService.getMenuTitle("EPCE2910142");	//화면 타이틀
			try {     
				String  bizrTpCd    = util.null2void(commonceService.bizr_tp_cd_select(request, map), "W1"); //빈용기 구분 조회
				map.put("BIZR_TP_CD", bizrTpCd);		//도매업자 구분

				if(map.get("BIZR_TP_CD").equals("W1") ){   
					map.put("PRPS_CD", "0");																//빈용기 구분   	도매업자구분이 도매업자(W1)일경우 유흥/가정으로
				}
				else if(map.get("BIZR_TP_CD").equals("W2") ){
					map.put("PRPS_CD", "2");																//빈용기 구분		도매업자구분이 공병상(W2)일경우 직접반환하는자로
				} 
				else {
					map.put("PRPS_CD", "X");																//빈용기 구분
				}
				
				List<?> ctnr_se			= commonceService.getCommonCdListNew("E005");	//빈용기구분 구/신
				List<?> ctnr_seList		= commonceService.ctnr_se_select(request, map);	//빈용기구분 유흥/가정/직접 조회
				List<?> ctnr_nm			= commonceService.ctnr_cd_select(map);				//빈용기명 조회
				List<?> initList			= epce2910142Mapper.epce2910142_select2(map);	//반환내역서 변경 그리드 초기값
				List<?> rmk_list			= commonceService.getCommonCdListNew("D025");	//소매수수료 적용여부 비고

				model.addAttribute("titleSub", title);        
				model.addAttribute("ctnr_se", util.mapToJson(ctnr_se));    	   
				model.addAttribute("ctnr_seList", util.mapToJson(ctnr_seList));       
				model.addAttribute("ctnr_nm", util.mapToJson(ctnr_nm));	         
				model.addAttribute("initList", util.mapToJson(initList));   
				model.addAttribute("rmk_list", util.mapToJson(rmk_list));             
			} catch (Exception e) {
				// TODO Auto-generated catch block
				/*e.printStackTrace();*/
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	
			return model;    	
	    }
	  
		
		/**
		 * 반환내역서등록 빈용기구분 선택시 빈용기명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce2910142_select2(Map<String, String> inputMap, HttpServletRequest request) {
			HashMap<String, Object> rtnMap = new HashMap<String, Object>();
			try {
				inputMap.put("SOJU_STD_EXT", "Y");
				rtnMap.put("ctnr_nm", util.mapToJson(commonceService.ctnr_cd_select(inputMap)));//빈용기명 조회
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}    	 	
	    	return rtnMap;    	
	    }
		/**
		 * 반환내역서등록 그리드 컬럼 선택시
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce2910142_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	try {
	    		inputMap.put("SOJU_STD_EXT", "Y");
				rtnMap.put("ctnr_nm", util.mapToJson(commonceService.ctnr_cd_select(inputMap)));//빈용기명 조회	
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}    	 	
	    	return rtnMap;    	
	    }
		
		/**
		 * 반환내역서변경 수정
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String epce2910142_update(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				
				String errCd = "0000";
				
				//Map<String, String> map;
				List<?> list = JSONArray.fromObject(inputMap.get("list"));
				List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();
				boolean keyCheck = false;
				int cnt = 0; 
				
				if (list != null) {
					try {
						
						for(int i=0; i<list.size(); i++){
							keyCheck = false;
							Map<String, String> map = (Map<String, String>) list.get(i);

							int stat = epce2910142Mapper.epce2910142_select4(map); //상태 체크
							if(stat>0){
								throw new Exception("A009"); 
							}
							
							int sel = epce2910142Mapper.epce2910142_select3(map); //중복체크
							if(sel>0){
								throw new Exception("A003"); 
							}
							 
							map.put("UPD_PRSN_ID", vo.getUSER_ID());  						//수정 등록자
						 	for(int j=0 ;j<list2.size(); j++){
						 		Map<String, String> map2 = (Map<String, String>) list2.get(j);
						 		if( 		 map.get("MFC_BIZRID").equals(map2.get("MFC_BIZRID"))  		 && map.get("MFC_BIZRNO").equals(map2.get("MFC_BIZRNO"))       //생산자
						 			&&map.get("MFC_BRCH_ID").equals(map2.get("MFC_BRCH_ID"))  && map.get("MFC_BRCH_NO").equals(map2.get("MFC_BRCH_NO"))  //생산자 지점
						 			&&map.get("CAR_NO").equals(map2.get("CAR_NO"))  				 &&  map.get("RTN_DT").equals(map2.get("RTN_DT")) )    				  //자동차 ,	 반환일자
						 	      {
						 			map.put("RTN_DOC_NO",map2.get("RTN_DOC_NO"));
						 			keyCheck = true;
						 			break;
						 		   }//end of if 
						 		
						 	}//end of for list2
						 	if(!keyCheck){
						 		 if(cnt == 0){
						 			 list2.add(map);
						 			 epce2910142Mapper.epce2910142_delete(map); 		//모든 데이터 삭제
						 		 }else	 if(cnt > 1){// 잘못된 데이터로 정보가 다를 경우 
							 		errCd = "A008";
							 		return errCd;
						 		 }
						 		 cnt++;
						 	}	
						 	
						 	//detail
						 	epce2910142Mapper.epce2910142_insert(map); 		// 반환상세
							 
						}//end of for
						
					 	for(int j=0 ;j<list2.size(); j++){
					 		Map<String, String> map = (Map<String, String>) list2.get(j);
					 		int result = epce2910142Mapper.epce2910142_update(map);
					 		if(result == 0){
					 			throw new Exception("A012"); 
					 		}
					 	}
					 	
					} catch (Exception e) {

						 if(e.getMessage().equals("A009") || e.getMessage().equals("A003")){
							 throw new Exception(e.getMessage());
						 }else{
							 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
						 }
						
					}
				}//end of list
				return errCd;
	    }

	    
	    /**
		 * 반환내역서  삭제
		 * @param inputMap
		 * @param request
		 * @return
	     * @throws Exception 
		 * @
		 */
		public String epce2910142_delete(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			
				int stat = epce2910142Mapper.epce2910142_select4(inputMap); //상태 체크 반환등록 상태 아닌거면 삭제 안되게
				 if(stat>0){
					 return "A009"; 
				 }
			
				try {
					epce2910101Mapper.epce2910101_delete(inputMap); // 반환내역서 삭제
					
				}catch (Exception e) {
					throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			return errCd;    	
	    }
	    
	    
}
