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
import egovframework.mapper.mf.ep.EPMF6645231Mapper;
import egovframework.mapper.mf.ep.EPMF6658201Mapper;
import egovframework.mapper.mf.ep.EPMF6645242Mapper;

/**
 * 직접회수정보변경 Service
 * @author pc
 *
 */
@Service("epmf6645242Service")
public class EPMF6645242Service {
	
	@Resource(name="epmf6645231Mapper")
	private EPMF6645231Mapper epmf6645231Mapper;
	
	@Resource(name="epmf6645242Mapper")
	private EPMF6645242Mapper epmf6645242Mapper;
	
	@Resource(name="epmf6658201Mapper")
	private EPMF6658201Mapper epmf6658201Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	@Resource(name="commonceMapper")
	private CommonCeMapper commonceMapper;
	
	
	/**
	 * 직접회수정보변경 초기화면
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf6645242_select1(ModelMap model, HttpServletRequest request)  {
		
		Map<String, String> map = new HashMap<String, String>(); 

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);

		String  title = commonceService.getMenuTitle("EPMF6645242");		//타이틀

		JSONObject jParams2 =(JSONObject)jParams.get("PARAMS");
		map.put("DRCT_RTRVL_DOC_NO", jParams2.get("DRCT_RTRVL_DOC_NO").toString());	// 직접회수문서번호
		
		List<?> initList	= epmf6645242Mapper.epmf6645242_select4(map);	//그리드쪽 조회

		
    	try {
    		model.addAttribute("titleSub", title);
    		model.addAttribute("initList", util.mapToJson(initList));

    		map.put("BIZR_TP_CD", jParams2.get("BIZR_TP_CD").toString());
    		map.put("MFC_BIZRNO", jParams2.get("MFC_BIZRNO").toString());
    		map.put("DRCT_RTRVL_DT", jParams2.get("DRCT_RTRVL_DT").toString());
    		
        	//빈용기명 조회
			model.addAttribute("ctnr_nm", util.mapToJson(epmf6645242Mapper.epmf6645242_select1(map)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
    	
		return model;
	}

	/**
	 * 직접회수정보 변경
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epmf6645242_update(Map<String, Object> inputMap, HttpServletRequest request) throws Exception  {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		JSONObject jparams = JSONObject.fromObject(inputMap.get("PARAMS"));
		HashMap<String, String> jmap = util.jsonToMap(jparams);
		
		//Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();
		boolean keyCheck = false;
		int cnt = 0; 
		
		/*상태 체크*/
		int stat = epmf6645242Mapper.epmf6645242_select5(jmap);
		if(stat>0){
			throw new Exception("A012"); 
		}
		/*상태 체크*/

		if (list != null) {
			try {
					
				for(int i=0; i<list.size(); i++){
					keyCheck = false;
					Map<String, String> map = (Map<String, String>) list.get(i);

					map.put("S_USER_ID", vo.getUSER_ID());  	//등록자
					map.put("DRCT_RTRVL_DOC_NO", jmap.get("DRCT_RTRVL_DOC_NO"));
					map.put("DRCT_RTRVL_DT", jmap.get("DRCT_RTRVL_DT"));
					map.put("MFC_BIZRID", jmap.get("MFC_BIZRID"));
					map.put("MFC_BIZRNO", jmap.get("MFC_BIZRNO"));
					map.put("MFC_BRCH_ID", jmap.get("MFC_BRCH_ID"));
					map.put("MFC_BRCH_NO", jmap.get("MFC_BRCH_NO"));
					
					//존재하는지 체크
					Map<String, String> checkMap = (Map<String, String>) epmf6645231Mapper.epmf6645231_select7(map);
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

							epmf6645231Mapper.epmf6645231_insert(map); //소매 사업자등록
							epmf6645231Mapper.epmf6645231_insert2(map); //소매 지점등록
						
						//지점데이터가 없을경우
						}else if(checkMap != null && checkMap.get("CUST_BRCH_ID").equals("N") ){ 
							
							map.put("CUST_BIZRID", checkMap.get("CUST_BIZRID")); //조회된 사업자ID로 등록
							epmf6645231Mapper.epmf6645231_insert2(map); //소매 지점등록
						}
					}
					
					
					for(int j=0 ;j<list2.size(); j++){
				 		Map<String, String> map2 = (Map<String, String>) list2.get(j);
				 		if( 
				 			map.get("MFC_BIZRID").equals(map2.get("MFC_BIZRID")) && map.get("MFC_BIZRNO").equals(map2.get("MFC_BIZRNO"))      //생산자
				 			&& map.get("MFC_BRCH_ID").equals(map2.get("MFC_BRCH_ID"))  && map.get("MFC_BRCH_NO").equals(map2.get("MFC_BRCH_NO"))  //생산자 지점
				 			&& map.get("DRCT_RTRVL_DT").equals(map2.get("DRCT_RTRVL_DT")) )   // 직접회수일자
				 	      {
				 			map.put("DRCT_RTRVL_DOC_NO", map2.get("DRCT_RTRVL_DOC_NO"));
				 			keyCheck = true;
				 			break;
				 		  }
				 	}
					
				 	if(!keyCheck){
				 		if(cnt == 0){
				 			list2.add(map);
				 			epmf6645242Mapper.epmf6645242_delete(map); 		//모든 데이터 삭제
				 		 }else if(cnt > 1){// 잘못된 데이터로 정보가 다를 경우 
					 		throw new Exception("A008"); 
				 		 }
				 		 cnt++;
				 	}
				 	
				 	/*중복체크*/
				 	int sel = epmf6645242Mapper.epmf6645242_select6(map);
					if(sel>0){
						throw new Exception("A014"); 
					}
					/*중복체크*/

				 	//detail
				 	epmf6645242Mapper.epmf6645242_insert(map); 		// 직접회수상세 등록
					 
				}//end of for
				
			 	for(int j=0 ;j<list2.size(); j++){
			 		Map<String, String> map = (Map<String, String>) list2.get(j);
			 		int result = epmf6645242Mapper.epmf6645242_update(map);
			 		if(result == 0){
			 			throw new Exception("A012"); //상태정보가 변경되어있습니다.
			 		}
			 		
			 	}
				
			} catch (Exception e) {
				if(e.getMessage().equals("A014") || e.getMessage().equals("A008") ){
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
	public HashMap<String, Object> epmf6645242_select2(Map<String, String> data, HttpServletRequest request)  {

		HashMap<String, Object> rtnMap = new HashMap<String, Object>();

		//빈용기명 조회
    	try {
			rtnMap.put("ctnr_nm", util.mapToJson(commonceService.ctnr_nm_select(request, data)));
		
	
	    	if(data.size()!=0){
	            
	            //생산자코드 조회
	            String bizr_tp_cd = commonceMapper.bizr_tp_cd_select((HashMap<String, String>) data);
	         
	            //생산자 기타코드(소주표준화병 제외하기 위해 처리) 
	            //W1 주류 생산자 W2 음료생산자
	            if(bizr_tp_cd.equals("M2")){
	            	data.put("BIZR_TP_CD", "M2");
	            
	            } else {
	            	data.put("BIZR_TP_CD", "M1");
	            }
	            
	         } else {
	        	 data.put("BIZR_TP_CD", "");
	         }
	    	//빈용기명 조회
	    	rtnMap.put("ctnr_nm", util.mapToJson(epmf6645242Mapper.epmf6645242_select1(data)));
	    	
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
	public HashMap epmf6645242_select3(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

    	//도매업자 업체명
    	try {
			rtnMap.put("whsdl", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));
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
	public HashMap epmf6645242_select4(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	try {
			rtnMap.put("ctnr_nm", util.mapToJson(epmf6645242Mapper.epmf6645242_select1(inputMap)));
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
	public String epmf6645242_delete(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		String errCd = "0000";
		Map<String, String> map;
		
		
			int stat = epmf6645242Mapper.epmf6645242_select5(inputMap); //상태 체크 반환등록 상태 아닌거면 삭제 안되게
			 if(stat>0){
				throw new Exception("A009"); 
			 }
		
			try {
				epmf6658201Mapper.epmf6658201_delete(inputMap); // 반환내역서 삭제
				
			}catch (Exception e) {
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		return errCd;    	
    }

}
