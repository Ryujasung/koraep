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
import egovframework.mapper.ce.ep.CommonCeMapper;
import egovframework.mapper.mf.ep.EPMF6652931Mapper;

/**
 * 출고정보등록 Service
 * @author pc
 *
 */
@Service("epmf6652931Service")
public class EPMF6652931Service {
	
	@Resource(name="epmf6652931Mapper")
	private EPMF6652931Mapper epmf6652931Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	@Resource(name="commonceMapper")
	private CommonCeMapper commonceMapper;
	
	
	/**
	 * 직매장/공장, 판매처 및 빈용기명 리스트 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf6652931_select1(ModelMap model, HttpServletRequest request)  {
		
		Map<String, String> map = new HashMap<String, String>(); 
		List<?> dlivy_stat_se = commonceService.getCommonCdListNew("D015");// 출고구분
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		
		model.addAttribute("INQ_PARAMS",jParams);
		try {
			model.addAttribute("dlivy_stat_se", util.mapToJson(dlivy_stat_se));

			map.put("MFC_BIZRNM", "");		//출고생산자
			map.put("START_DT", "");		//출고일자
			map.put("MFC_BRCH_NM", "");		//직매장공장
			map.put("dlivy_se", "");		//출고구분
			map.put("CUST", "");			//판매처
			map.put("WHSDL", "");   		//도매업자
			map.put("CUST_BIZR_NO", "");	//판매처사업자번호
			map.put("CUST_NM", "");			//판매처명
			map.put("CTNR_NM", "");			//빈용기명
			map.put("DLIVY_QTY", "");		//출고량
			map.put("RMK", "");				//비고
			
			String   title		= commonceService.getMenuTitle("EPMF6652931");	//타이틀
			List<?> mfcSeCdList = commonceService.mfc_bizrnm_select_y(request); // 생산자 콤보박스
			map.put("WORK_SE", "1"); 																	//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
			HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);		//등록일자제한설정  
			
			model.addAttribute("titleSub", title);
			model.addAttribute("mfcSeCdList", util.mapToJson(mfcSeCdList));	//생산자구분 리스트
			model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));	  	    //등록일자제한설정
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
		
	}

	/**
	 * 출고정보 등록
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epmf6652931_update(Map<String, Object> inputMap, HttpServletRequest request) throws Exception  {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		//Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		List<Map<String, String>>list2 = new ArrayList<Map<String,String>>();
		boolean keyCheck = false;
		
		String ssUserId  = "";   //사용자ID

		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
					
				for(int i=0; i<list.size(); i++){
					String dlivy_doc_no ="";
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
							map.put("CUST_BRCH_ID", checkMap.get("CUST_BRCH_ID"));
							map.put("CUST_BRCH_NO", checkMap.get("CUST_BRCH_NO"));
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
					
					/*중복체크*/
					int sel = epmf6652931Mapper.epmf6652931_select6(map); //
					if(sel>0){
						 throw new Exception("A014");
					}
					
					map.put("SDT_DT", map.get("DLIVY_DT"));	//등록일자제한설정  등록일자 1.DLIVY_DT,2.DRCT_RTRVL_DT, 3.EXCH_DT, 4.RTRVL_DT, 5.RTN_DT
					map.put("WORK_SE", "1"); 							//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
					sel =commonceService.rtc_dt_ck(map);		//등록일자제한설정
					if(sel !=1){
						throw new Exception("A021"); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
					}      
					
					/*중복체크*/
				 	for(int j=0 ;j<list2.size(); j++){
				 		Map<String, String> map2 = (Map<String, String>) list2.get(j);
				 
				 		if( 
				 			map.get("MFC_BIZRID").equals(map2.get("MFC_BIZRID")) && map.get("MFC_BIZRNO").equals(map2.get("MFC_BIZRNO"))      //생산자
				 			&& map.get("MFC_BRCH_ID").equals(map2.get("MFC_BRCH_ID")) && map.get("MFC_BRCH_NO").equals(map2.get("MFC_BRCH_NO"))  //생산자 지점
				 			&& map.get("STD_YEAR").equals(map2.get("STD_YEAR"))
				 			)  
				 	      {
				 			map.put("DLIVY_DOC_NO",map2.get("DLIVY_DOC_NO"));
				 			keyCheck = true;
				 			break;
				 		   }//end of if 
				 	}//end of for list2
				 	
				 	if(!keyCheck){
				 		//master
				 		 String doc_psnb_cd ="OT"; 
				 		 dlivy_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 출고문서번호 조회
						 map.put("DLIVY_DOC_NO", dlivy_doc_no);									//문서채번

						 epmf6652931Mapper.epmf6652931_update1(map); 			// 출고마스터 등록
				 		 list2.add(map);
				 	}	
				 	
				 	if(!map.containsKey("RMK")){
				 		map.put("RMK", "");
				 	}
				 	
				 	//detail
				 	epmf6652931Mapper.epmf6652931_update2(map); 		// 출고상세 등록
				 	
				}//end of for
				
			 	for(int j=0 ;j<list2.size(); j++){
			 		Map<String, String> map = (Map<String, String>) list2.get(j);
			 		epmf6652931Mapper.epmf6652931_update3(map);
			 	}
				
			} catch (Exception e) {
				/*e.printStackTrace();*/
				if(e.getMessage().equals("A014") ){
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
	 * 생산자별 빈용기명 콤보박스 목록조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epmf6652931_select2(Map<String, String> data, HttpServletRequest request)  {

				//세션정보 가져오기
				HttpSession session = request.getSession();
				UserVO uvo = (UserVO)session.getAttribute("userSession");
				
				HashMap<String, Object> map = new HashMap<String, Object>();
				
		return map;
	}
	
	/**
	 * 출고생산자 선택시 직매장/공장 조회 ,빈용기명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epmf6652931_select3(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

    	//지점 조회
    	try {
			rtnMap.put("brch_dtssList", util.mapToJson(commonceService.brch_nm_select_y(request, inputMap)));
			
	
	    	if(null != inputMap){
	            
	            //생산자코드 조회
	            String bizr_tp_cd = commonceMapper.bizr_tp_cd_select((HashMap<String, String>) inputMap);
	         
	            //생산자 기타코드(소주표준화병 제외하기 위해 처리) 
	            //W1 주류 생산자 W2 음료생산자
	            if(bizr_tp_cd == null || bizr_tp_cd.equals("")){
	            	//빈용기명 조회
			       	 rtnMap.put("ctnr_nm", "");
	            }else{
	            
	            	if(bizr_tp_cd.equals("M2")){
	                	inputMap.put("BIZR_TP_CD", "M2");
	                } else {
	                	inputMap.put("BIZR_TP_CD", "M1");
	                }
	            	
			         //빈용기명 조회
			       	 rtnMap.put("ctnr_nm", util.mapToJson(epmf6652931Mapper.epmf6652931_select5(inputMap)));
	            }
	         }
    	} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	
    	
    	return rtnMap;    	
    }
	
	
	/**
	 * 직매장/공장 선택시 도매업자 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epmf6652931_select4(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

    	//도매업자 업체명
    	try {
			rtnMap.put("whsdl", util.mapToJson(commonceService.mfc_bizrnm_select4_y(request, inputMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

    	return rtnMap;    	
    }
	
	/**
	 * 출고정보 그리드 컬럼 선택시
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epmf6652931_select5(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	try {
			rtnMap.put("ctnr_nm", util.mapToJson(epmf6652931Mapper.epmf6652931_select5(inputMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		} //빈용기명 조회
    	return rtnMap;    	
    }
	
	/**
	 * 출고정보등록 엑셀 업로드 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epmf6652931_select6(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	try {
			rtnMap.put("selList", util.mapToJson(epmf6652931Mapper.epmf6652931_select8(inputMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}    	 
    	return rtnMap;    	
    }

	
	/**
	 * 출고일자 변경시 빈용기명 재조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epmf6652931_select7(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

    	if(null != inputMap){
            
            //생산자코드 조회
            String bizr_tp_cd = commonceMapper.bizr_tp_cd_select((HashMap<String, String>) inputMap);
         
            //생산자 기타코드(소주표준화병 제외하기 위해 처리) 
            //W1 주류 생산자 W2 음료생산자
            if(bizr_tp_cd == null || bizr_tp_cd.equals("")){
            	//빈용기명 조회
		       	 rtnMap.put("ctnr_nm", "");
            }else{
            
            	if(bizr_tp_cd.equals("M2")){
                	inputMap.put("BIZR_TP_CD", "M2");
                } else {
                	inputMap.put("BIZR_TP_CD", "M1");
                }
            	
		         //빈용기명 조회
		       	 try {
					rtnMap.put("ctnr_nm", util.mapToJson(epmf6652931Mapper.epmf6652931_select5(inputMap)));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}
            }
         }
    	
    	return rtnMap;    	
    }
}
