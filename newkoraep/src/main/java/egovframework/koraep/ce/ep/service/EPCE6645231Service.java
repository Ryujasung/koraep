package egovframework.koraep.ce.ep.service;

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
import egovframework.mapper.ce.ep.CommonCeMapper;
import egovframework.mapper.ce.ep.EPCE6645231Mapper;

/**
 * 직접회수정보등록 Service
 * @author pc
 *
 */
@Service("epce6645231Service")
public class EPCE6645231Service {
	
	@Resource(name="epce6645231Mapper")
	private EPCE6645231Mapper epce6645231Mapper;
		
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
	public ModelMap epce6645231_select1(ModelMap model, HttpServletRequest request)  {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		Map<String, String> map = new HashMap<String, String>();
		
		String   title		= commonceService.getMenuTitle("EPCE6645231"); //타이틀
		
		Map<String, String> bizrMap = new HashMap<String, String>();
		bizrMap.put("BIZR_TP_CD", "M2"); //음료생산자
		bizrMap.put("BIZR_STAT_CD", "Y"); //사용Y
		List<?> mfcSeCdList = commonceService.mfc_bizrnm_select(request, bizrMap); //생산자 콤보박스
		
		map.put("WORK_SE", "2"); 																	//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
		HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);		//등록일자제한설정  
		
		model.addAttribute("titleSub", title);
		try {
			model.addAttribute("mfcSeCdList", util.mapToJson(mfcSeCdList));
			model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));	  	    //등록일자제한설정
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	//생산자 리스트
		
		return model;
		
	}

	/**
	 * 직접회수정보 등록
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce6645231_update(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();
		boolean keyCheck = false;
		String ssUserId  = "";   //사용자ID
		
		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
					
				for(int i=0; i<list.size(); i++){
					String doc_no ="";
					keyCheck = false;
					
					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					
					map.put("SDT_DT", map.get("DRCT_RTRVL_DT"));	//등록일자제한설정  등록일자 1.DLIVY_DT,2.DRCT_RTRVL_DT, 3.EXCH_DT, 4.RTRVL_DT, 5.RTN_DT
					map.put("WORK_SE", "2"); 									//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
					int sel_ck = commonceService.rtc_dt_ck(map);		//등록일자제한설정
					if(sel_ck !=1){
						throw new Exception("A021"); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
					}    
					
					//존재하는지 체크
					Map<String, String> checkMap = (Map<String, String>) epce6645231Mapper.epce6645231_select7(map);
					//확인필요
	
					if(checkMap != null && !checkMap.get("CUST_BIZRID").equals("") && !checkMap.get("CUST_BRCH_ID").equals("N") 
							&& !checkMap.get("CUST_BIZRNO").equals("")){ //사업자, 지점 둘다 등록상태
						
						//이미 해당 사업자번호로 사업자 및 지점이 등록되어있는 경우는 해당 데이터를 통해 거래처를 등록한다.  즉  작성한 거래처명, 사업자유형은 무시함
						//errCd = ""; //이미 등록된 소매거래처 지점정보로 저장된 건이 있습니다. 등록결과를 확인하시기 바랍니다.
						map.put("CUST_BIZRID", checkMap.get("CUST_BIZRID"));

					}else{

						//사업자데이터가 없을경우
						if(checkMap == null || (checkMap != null && checkMap.get("CUST_BIZRID").equals("")) ){ 
							
							String psnbSeq = commonceService.psnb_select("S0001"); //사업자ID 일련번호 채번
							map.put("CUST_BIZRID", "D2H"+psnbSeq); //사업자ID = 직접회수등록사업자(D2) - 수기(H)

							epce6645231Mapper.epce6645231_insert(map); //소매 사업자등록
							epce6645231Mapper.epce6645231_insert2(map); //소매 지점등록
						
						//지점데이터가 없을경우
						}else if(checkMap != null && checkMap.get("CUST_BRCH_ID").equals("N") ){ 
							
							map.put("CUST_BIZRID", checkMap.get("CUST_BIZRID")); //조회된 사업자ID로 등록
							epce6645231Mapper.epce6645231_insert2(map); //소매 지점등록
						}
					}
					
				 	for(int j=0 ;j<list2.size(); j++){
				 		Map<String, String> map2 = (Map<String, String>) list2.get(j);
				 		if( 
				 			map.get("MFC_BIZRID").equals(map2.get("MFC_BIZRID"))	&& map.get("MFC_BIZRNO").equals(map2.get("MFC_BIZRNO"))      //생산자
				 			&&map.get("MFC_BRCH_ID").equals(map2.get("MFC_BRCH_ID"))  && map.get("MFC_BRCH_NO").equals(map2.get("MFC_BRCH_NO"))  //생산자 지점
				 			&&  map.get("DRCT_RTRVL_DT").equals(map2.get("DRCT_RTRVL_DT")) )   //	 직접회수일자
				 	      {
				 			map.put("DRCT_RTRVL_DOC_NO", map2.get("DRCT_RTRVL_DOC_NO"));
				 			keyCheck = true;
				 			break;
				 		   }//end of if
				 		
				 	}//end of for list2
				 	
				 	if(!keyCheck){
				 		//master
				 		 String doc_psnb_cd ="DR"; 				   								
				 		 doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 직접회수문서번호 조회
						 map.put("DRCT_RTRVL_DOC_NO", doc_no);						//문서채번
						 
						 epce6645231Mapper.epce6645231_update1(map); 			// 직접회수마스터 등록
				 		 list2.add(map);
				 	}
				 	
				 	/*중복체크*/
				 	int sel = epce6645231Mapper.epce6645231_select9(map);
					if(sel>0){
						throw new Exception("A014"); 
					}
					/*중복체크*/
				 	
					if(!map.containsKey("RMK")){
						map.put("RMK", "");
					}
					
				 	//detail
				 	epce6645231Mapper.epce6645231_update2(map); 		// 직접회수상세 등록
					 
				}//end of for
				
				
			 	for(int j=0 ;j<list2.size(); j++){
			 		Map<String, String> map = (Map<String, String>) list2.get(j);
			 		epce6645231Mapper.epce6645231_update3(map);
			 	}
			 	
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
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
	 * 직접회수생산자 선택시 직매장/공장 조회 ,빈용기명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce6645231_select3(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

    	if(!inputMap.containsKey("BIZRID")){
    		inputMap.put("BIZRID", "");
    	}
    	if(!inputMap.containsKey("BIZRNO")){
    		inputMap.put("BIZRNO", "");
    	}
    	
    	//지점 조회
    	try {
			rtnMap.put("brch_dtssList", util.mapToJson(commonceService.brch_nm_select_y(request, inputMap)));
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
    	
    	//빈용기명 조회
    	//rtnMap.put("ctnr_nm", util.mapToJson(commonceService.ctnr_nm_select(request, inputMap)));
    	
    	if(null != inputMap){
            
            //생산자코드 조회
            String bizr_tp_cd = commonceMapper.bizr_tp_cd_select((HashMap<String, String>) inputMap);
         
            //생산자 기타코드(소주표준화병 제외하기 위해 처리) 
            //W1 주류 생산자 W2 음료생산자
            if(bizr_tp_cd == null || bizr_tp_cd.equals("")){
            	inputMap.put("BIZR_TP_CD", "");
			}else if(bizr_tp_cd.equals("M2")){
				inputMap.put("BIZR_TP_CD", "M2");
			}else{
				inputMap.put("BIZR_TP_CD", "M1");
			}
            
         }
    	
    	//빈용기명 조회
    	try {
			rtnMap.put("ctnr_nm", util.mapToJson(epce6645231Mapper.epce6645231_select5(inputMap)));
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
	 * 직접회수일자 변경시 빈용기명 재조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce6645231_select4(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

    	if(!inputMap.containsKey("BIZRID")){
    		inputMap.put("BIZRID", "");
    	}
    	if(!inputMap.containsKey("BIZRNO")){
    		inputMap.put("BIZRNO", "");
    	}
    	
    	if(null != inputMap){
            
            //생산자코드 조회
            String bizr_tp_cd = commonceMapper.bizr_tp_cd_select((HashMap<String, String>) inputMap);
         
            //생산자 기타코드(소주표준화병 제외하기 위해 처리) 
            //W1 주류 생산자 W2 음료생산자
            if(bizr_tp_cd == null || bizr_tp_cd.equals("")){
            	inputMap.put("BIZR_TP_CD", "");
			}else if(bizr_tp_cd.equals("M2")){
				inputMap.put("BIZR_TP_CD", "M2");
			}else{
				inputMap.put("BIZR_TP_CD", "M1");
			}
            
         }
    	
    	//빈용기명 조회
    	try {
			rtnMap.put("ctnr_nm", util.mapToJson(epce6645231Mapper.epce6645231_select5(inputMap)));
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
	 * 직접회수정보 그리드 컬럼 선택시
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce6645231_select5(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	try {
			rtnMap.put("ctnr_nm", util.mapToJson(epce6645231Mapper.epce6645231_select5(inputMap)));
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
	 * 엑셀 업로드 후처리
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce6645231_select6(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	try {
			rtnMap.put("selList", util.mapToJson(epce6645231Mapper.epce6645231_select8(inputMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}    	 
    	return rtnMap;    	
    }
	
}
