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
import egovframework.mapper.ce.ep.EPCE6658201Mapper;
import egovframework.mapper.ce.ep.EPCE6658242Mapper;

/**
 * 출고정보변경 Service
 * @author pc
 *
 */
@Service("epce6658242Service")
public class EPCE6658242Service {
	
	@Resource(name="epce6658242Mapper")
	private EPCE6658242Mapper epce6658242Mapper;
	
	@Resource(name="epce6658201Mapper")
	private EPCE6658201Mapper epce6658201Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	@Resource(name="commonceMapper")
	private CommonCeMapper commonceMapper;
	
	
	/**
	 * 출고정보변경 초기화면
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce6658242_select1(ModelMap model, HttpServletRequest request)  {
		
		Map<String, String> map = new HashMap<String, String>(); 
		List<?> dlivy_stat_se = commonceService.getCommonCdListNew("D015");// 출고구분
		
		try {
			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);

			model.addAttribute("dlivy_stat_se", util.mapToJson(dlivy_stat_se));
			
			String  title = commonceService.getMenuTitle("EPCE6658242");		//타이틀
			List<?> mfcSeCdList = commonceService.mfc_bizrnm_select(request); // 생산자 콤보박스
			
			JSONObject jParams2 =(JSONObject)jParams.get("PARAMS");
			
			map.put("DLIVY_DOC_NO", jParams2.get("DLIVY_DOC_NO").toString());		// 출고문서번호
			
			map.put("WORK_SE", "1"); 																	//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
			HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);		//등록일자제한설정  
			
			List<?> initList	= epce6658242Mapper.epce6658242_select4(map);		//그리드쪽 조회

			model.addAttribute("titleSub", title);
			model.addAttribute("mfcSeCdList", util.mapToJson(mfcSeCdList));	//생산자구분 리스트
			model.addAttribute("initList", util.mapToJson(initList));
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
		}

		return model;
	}

	/**
	 * 출고정보 변경
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce6658242_update(Map<String, Object> inputMap, HttpServletRequest request) throws Exception  {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		//Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();
		boolean keyCheck = false;
		int cnt = 0; 
		
		if (list != null) {
			for(int i=0; i<list.size(); i++){
				if(i == 0){
					Map<String, String> map = (Map<String, String>) list.get(i);
					int stat = epce6658242Mapper.epce6658242_select5(map); //상태 체크
					if(stat>0){
						throw new Exception("A012"); //상태정보가 변경되어있습니다.
					}
				}else{
					break;
				}
			}
		}
		
		if (list != null) {
			try {
					
				for(int i=0; i<list.size(); i++){
					String dlivy_doc_no ="";
					keyCheck = false;
					Map<String, String> map = (Map<String, String>) list.get(i);

					map.put("REG_PRSN_ID", vo.getUSER_ID());  	//등록자
					map.put("UPD_PRSN_ID", vo.getUSER_ID());  	//등록자
					
					map.put("SDT_DT", map.get("DLIVY_DT"));		//등록일자제한설정  등록일자 1.DLIVY_DT,2.DRCT_RTRVL_DT, 3.EXCH_DT, 4.RTRVL_DT, 5.RTN_DT
					map.put("WORK_SE", "1"); 							//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
					int sel_ck =commonceService.rtc_dt_ck(map);	//등록일자제한설정
					if(sel_ck !=1){
						throw new Exception("A021"); //등록제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
					}
					
					for(int j=0 ;j<list2.size(); j++){
				 		Map<String, String> map2 = (Map<String, String>) list2.get(j);
				 		if( 
				 			map.get("MFC_BIZRID").equals(map2.get("MFC_BIZRID")) && map.get("MFC_BIZRNO").equals(map2.get("MFC_BIZRNO"))      //생산자
				 			&& map.get("MFC_BRCH_ID").equals(map2.get("MFC_BRCH_ID"))  && map.get("MFC_BRCH_NO").equals(map2.get("MFC_BRCH_NO"))  //생산자 지점
				 		 ){
				 			map.put("DLIVY_DOC_NO",map2.get("DLIVY_DOC_NO"));
				 			keyCheck = true;
				 			break;
				 		  }//end of if 
				 	}//end of for list2
					
				 	if(!keyCheck){

				 		if(cnt == 0){
				 			list2.add(map);
				 			epce6658242Mapper.epce6658242_delete(map); 	//모든 데이터 삭제
				 		 }else if(cnt > 1){// 잘못된 데이터로 정보가 다를 경우 
					 		throw new Exception("A008");
				 		 }
				 		 cnt++;
				 	}	

				 	/*중복체크*/
				 	int sel = epce6658242Mapper.epce6658242_select6(map);
					if(sel>0){
						throw new Exception("A014"); 
					}
					/*중복체크*/
				 	
					if(!map.containsKey("RMK")){
						map.put("RMK", "");
					}
					
				 	//detail
				 	epce6658242Mapper.epce6658242_insert(map); // 출고상세 등록
					 
				}//end of for
				
			 	for(int j=0 ;j<list2.size(); j++){
			 		Map<String, String> map = (Map<String, String>) list2.get(j);
			 		int result = epce6658242Mapper.epce6658242_update(map);
			 		if(result == 0){
			 			throw new Exception("A012"); //상태정보가 변경되어있습니다.
			 		}
			 	}
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				if(e.getMessage().equals("A008") || e.getMessage().equals("A012") || e.getMessage().equals("A014") || e.getMessage().equals("A021")){
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
	public HashMap<String, Object> epce6658242_select2(Map<String, String> data, HttpServletRequest request)  {

		HashMap<String, Object> rtnMap = new HashMap<String, Object>();

		//빈용기명 조회
    	//rtnMap.put("ctnr_nm", util.mapToJson(commonceService.ctnr_nm_select(request, data)));

    	if(null != data){
            
            //생산자코드 조회
            String bizr_tp_cd = commonceMapper.bizr_tp_cd_select((HashMap<String, String>) data);
         
            //생산자 기타코드(소주표준화병 제외하기 위해 처리) 
            //W1 주류 생산자 W2 음료생산자
            if(bizr_tp_cd == null || bizr_tp_cd.equals("")){
				data.put("BIZR_TP_CD", "");
			}else if(bizr_tp_cd.equals("M2")){
				data.put("BIZR_TP_CD", "M2");
			}else{
				data.put("BIZR_TP_CD", "M1");
			}
            
         } else {
        	 data = new HashMap<String, String>();
        	 data.put("BIZR_TP_CD", "");
         }
    	//빈용기명 조회
    	try {
			rtnMap.put("ctnr_nm", util.mapToJson(epce6658242Mapper.epce6658242_select1(data)));
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
	 * 도매업자 콤보박스 호출
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce6658242_select3(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

    	//도매업자 업체명
    	try {
			rtnMap.put("whsdl", util.mapToJson(commonceService.mfc_bizrnm_select4_y(request, inputMap)));
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
	 * 출고정보 그리드 컬럼 선택시
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce6658242_select4(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	try {
			rtnMap.put("ctnr_nm", util.mapToJson(epce6658242Mapper.epce6658242_select1(inputMap)));
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
	 * 반환내역서  삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce6658242_delete(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		String errCd = "0000";
		Map<String, String> map;

		int stat = epce6658242Mapper.epce6658242_select5(inputMap); //상태 체크 반환등록 상태 아닌거면 삭제 안되게
		 if(stat>0){
			 return "A009"; 
		 }
	
		try {
			epce6658201Mapper.epce6658201_delete(inputMap); // 반환내역서 삭제
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

}
