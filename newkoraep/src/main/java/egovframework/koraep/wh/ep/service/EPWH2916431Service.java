package egovframework.koraep.wh.ep.service;

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
import egovframework.mapper.wh.ep.EPWH2916431Mapper;
import egovframework.mapper.wh.ep.EPWH2983931Mapper;

/**
 * 입고내역서 등록 Service
 * @author 양성수
 *
 */
@Service("epwh2916431Service")
public class EPWH2916431Service {
	
	
	@Resource(name="epwh2916431Mapper")
	private EPWH2916431Mapper epwh2916431Mapper;  //실태조사 입고내역서조정 Mapper
	
	@Resource(name="epwh2983931Mapper")
	private EPWH2983931Mapper epwh2983931Mapper;  //입고내역서 등록 Mapper
	
			
			
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
		/**
		 * 입고내역서 등록 초기 화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epwh2916431_select(ModelMap model, HttpServletRequest request) {
			  
			 	Map<String, String> map = new HashMap<String, String>();
			 	int selCnt = 0;
			 	List<?> cfm_gridList = null;
			 	
			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				JSONObject jParams2 =(JSONObject)jParams.get("PARAMS");
				
				map.put("MFC_BIZRID", jParams2.get("MFC_BIZRID").toString());				//생산자ID
				map.put("MFC_BIZRNO", jParams2.get("MFC_BIZRNO").toString());			//생산자 사업자번호
				map.put("MFC_BRCH_ID", jParams2.get("MFC_BRCH_ID").toString());			//생산자 지사 ID
				map.put("MFC_BRCH_NO", jParams2.get("MFC_BRCH_NO").toString());		//생산자 지사 번호
				map.put("CUST_BIZRID", jParams2.get("WHSDL_BIZRID").toString());	 			//도매업자 ID
				map.put("CUST_BIZRNO", jParams2.get("WHSDL_BIZRNO_ORI").toString());	//도매업자 사업자번호
				map.put("CUST_BRCH_ID", jParams2.get("WHSDL_BRCH_ID").toString());		//도매업자 지점 ID
				map.put("CUST_BRCH_NO", jParams2.get("WHSDL_BRCH_NO").toString());		//도매업자 지점번호
				map.put("RTN_DOC_NO", jParams2.get("RTN_DOC_NO").toString());		 	// 반환문서번호
				map.put("RTN_DT", jParams2.get("RTN_DT").toString());					//반환일자
				                 
				try {
					String title	= commonceService.getMenuTitle("EPWH2916431");		//타이틀
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
					
					
					List<?> iniList				= epwh2916431Mapper.epwh2916431_select(map);		//상세내역 조회
					selCnt 						= epwh2916431Mapper.epwh2916431_select6(map); 	
					if(selCnt>0){
						cfm_gridList			= epwh2916431Mapper.epwh2916431_select7(map);		//그리드쪽 조회 입고정보 있을 경우 
					}
					List<?>  gridList			= epwh2916431Mapper.epwh2916431_select2(map);		//그리드쪽 조회  
					List<?> ctnr_se			= commonceService.getCommonCdListNew("E005");		//빈용기구분 구/신
					List<?> ctnr_seList		= commonceService.ctnr_se_select(request, map);						//빈용기구분 유흥/가정/직접 조회
					List<?> ctnr_nm			= commonceService.ctnr_cd_select(map);					//빈용기명 조회
					List<?> rmk_list		= commonceService.getCommonCdListNew("D025");		//소매수수료 적용여부 비고

					model.addAttribute("INQ_PARAMS",jParams);
					model.addAttribute("titleSub", title);
					model.addAttribute("iniList", util.mapToJson(iniList));	
					model.addAttribute("gridList", util.mapToJson(gridList));	
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
			 * 입고내역서 그리드 컬럼 선택시
			 * @param inputMap
			 * @param request
			 * @return
			 * @
			 */
			public HashMap epwh2916431_select2(Map<String, String> inputMap, HttpServletRequest request) {
		    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		    	try {
					rtnMap.put("ctnr_nm", util.mapToJson(commonceService.ctnr_cd_select(inputMap)));//빈용기명 조회
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
			 * 입고내역서등록  저장
			 * @param data
			 * @param request
			 * @return
			 * @throws Exception 
			 * @
			 */
		    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
			public String epwh2916431_insert(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
					HttpSession session = request.getSession();
					UserVO vo = (UserVO) session.getAttribute("userSession");
					
					String errCd = "0000";
					
					//Map<String, String> map;
					List<?> list = JSONArray.fromObject(inputMap.get("list"));
					List<?> list_ori = JSONArray.fromObject(inputMap.get("list_ori"));
					List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();
					String wrhs_doc_no ="";
					boolean keyCheck = false;
					
					if (list != null) {
						try {
							
							// 각종 체크
							Map<String, String> check = (Map<String, String>) list.get(0);
							int stat = epwh2916431Mapper.epwh2916431_select4(check); //상태 체크
							 if(stat>0){
								throw new Exception("A009"); 
							 }
							 int sel = epwh2916431Mapper.epwh2916431_select5(check); // 수량 체크
							 if(sel != 1){
								 throw new Exception("A008"); 
							 }
			
							 List<?>  gridList	= util.mapToJson(epwh2916431Mapper.epwh2916431_select2(check));// 입고 정보 초기 값 데이터 비교

								if(list_ori.size() ==gridList.size() ){
										 for(int k =0;k<list_ori.size();k++){
											 Map<String, String> list_ori_map = new HashMap<String, String>();
											 Map<String, String> gridList_map = new HashMap<String, String>();
											 list_ori_map = (Map<String, String>) list_ori.get(k);
											 gridList_map = (Map<String, String>) gridList.get(k);
											 list_ori_map.put("ADD_FILE", "");
											 gridList_map.put("ADD_FILE", "");
											 if(!list_ori_map.toString().equals(gridList_map.toString())){
												 throw new Exception("A008");   //변조된 데이터
											 }
										 }										
								}else{
									 throw new Exception("A008");   //변조된 데이터
								}
							
							//입고문서등록 실행
							for(int i=0; i<list.size(); i++){
							
								Map<String, String> map = (Map<String, String>) list.get(i);
								map.put("REG_PRSN_ID", vo.getUSER_ID());  											//등록자
							 	map.put("WRHS_DOC_NO",wrhs_doc_no);
						 		
							 	if(!keyCheck){
							 			//master
								 		 String doc_psnb_cd ="IN"; 								   						//	RT :반환문서 ,IN :입고문서
								 		 wrhs_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	//	입고문서번호 조회
										 map.put("WRHS_DOC_NO", wrhs_doc_no);									//	문서채번
										 epwh2916431Mapper.epwh2916431_insert(map); 							//	입고마스터	  등록
										 epwh2916431Mapper.epwh2916431_update3(map);						// 실태조사확인상태 up 
								 		 list2.add(map);
								 		 keyCheck = true;
							 	}	
							 	//detail  
							 	epwh2916431Mapper.epwh2916431_insert2(map); 			// 입고상세
							 	epwh2983931Mapper.epwh29839882_insert3(map);		//  증빙사진 첨부 up
								 
							}//end of for
							
						 	for(int j=0 ;j<list2.size(); j++){
						 		Map<String, String> map = (Map<String, String>) list2.get(j);
						 		epwh2916431Mapper.epwh2916431_update(map);			//입고 마스터 총값 넣기
						 		epwh2916431Mapper.epwh2916431_update2(map); 		//반환 마스터  상태변경
						 		map.put("REG_PRSN_ID_CHK", vo.getUSER_ID());
						 		epwh2983931Mapper.epwh29839882_delete2(map);		// 템프 증빙사진 삭제
						 	}
						 	
						}catch (IOException io) {
							System.out.println(io.toString());
						}catch (SQLException sq) {
							System.out.println(sq.toString());
						}catch (NullPointerException nu){
							System.out.println(nu.toString());
						} catch (Exception e) {
							 if(e.getMessage().equals("A008") || e.getMessage().equals("A009") ){
								 throw new Exception(e.getMessage()); 
							 }else{
								 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
							 }
						}
					}//end of list
					return errCd;
		    }
		    
		    /**
			 * 입고내역서등록  수정
			 * @param data
			 * @param request
			 * @return
		     * @throws Exception 
			 * @
			 */
		    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
			public String epwh2916431_update(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
					HttpSession session = request.getSession();
					UserVO vo = (UserVO) session.getAttribute("userSession");
					
					String errCd = "0000";
					
					//Map<String, String> map;
					List<?> list = JSONArray.fromObject(inputMap.get("list"));
					List<?> list_ori = JSONArray.fromObject(inputMap.get("list_ori"));
					List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();
					boolean keyCheck = false;
					
					if (list != null) {
						try {
							
							// 각종 체크
							Map<String, String> check = (Map<String, String>) list.get(0);
							int stat = epwh2916431Mapper.epwh2916431_select4(check); //상태 체크
							 if(stat>0){
								throw new Exception("A009"); 
							 }
							 int sel = epwh2916431Mapper.epwh2916431_select5(check); // 수량 체크
							 if(sel != 1){
								 throw new Exception("A008"); 
							 }
							 List<?>  gridList	= util.mapToJson(epwh2916431Mapper.epwh2916431_select2(check));// 입고 정보 초기 값 데이터 비교
								System.out.println("gridList :  " +gridList.size()  +  "  :  list_ori  :" +list_ori.size() );
								if(list_ori.size() ==gridList.size() ){
										 for(int k =0;k<list_ori.size();k++){
											 Map<String, String> list_ori_map = new HashMap<String, String>();
											 Map<String, String> gridList_map = new HashMap<String, String>();
											 list_ori_map = (Map<String, String>) list_ori.get(k);
											 gridList_map = (Map<String, String>) gridList.get(k);
											 list_ori_map.put("ADD_FILE", "");
											 gridList_map.put("ADD_FILE", "");
											 if(!list_ori_map.toString().equals(gridList_map.toString())){
												 throw new Exception("A008");   //변조된 데이터
											 }
										 }										
								}else{
									 throw new Exception("A008");   //변조된 데이터
								}
							  
							for(int i=0; i<list.size(); i++){
								Map<String, String> map = (Map<String, String>) list.get(i);
								map.put("UPD_PRSN_ID", vo.getUSER_ID());  					//로그인 수정 등록자 ,   REG_PRSN_ID : 최초등록자
							 	if(!keyCheck){
								 		 list2.add(map);
								 		 keyCheck = true;
								 		epwh2983931Mapper.epwh29839882_delete3(map);	// 증빙사진 삭제
								 		epwh2916431Mapper.epwh2916431_delete(map);		// 입고상세 삭제
								 		epwh2916431Mapper.epwh2916431_update4(map); 	//입고 마스터  상태변경및 입고확인입력
								 		epwh2916431Mapper.epwh2916431_update2(map); 	//반환 마스터  상태변경및 입고확인입력
								 		epwh2916431Mapper.epwh2916431_update3(map);	//실태조사확인상태
							 	}	 
							 	//detail
							 	epwh2916431Mapper.epwh2916431_insert2(map); 				// 입고상세
							 	epwh2983931Mapper.epwh29839882_insert3(map); 			// 증빙사진 등록  UPD_PRSN_ID-로그인자 
							}//end of for
						 	for(int j=0 ;j<list2.size(); j++){
						 		Map<String, String> last_map = (Map<String, String>) list2.get(j);
						 		epwh2916431Mapper.epwh2916431_update(last_map);		//입고 마스터 총값 넣기
						 		last_map.put("REG_PRSN_ID_CHK","CHK");
						 		last_map.put("REG_PRSN_ID", vo.getUSER_ID());  				//등록자
						 		epwh2983931Mapper.epwh29839882_delete2(last_map);		// 템프 증빙사진 삭제
						 	}
							
						}catch (IOException io) {
							System.out.println(io.toString());
						}catch (SQLException sq) {
							System.out.println(sq.toString());
						}catch (NullPointerException nu){
							System.out.println(nu.toString());
						} catch (Exception e) {
							if(e.getMessage().equals("A008") || e.getMessage().equals("A009") ){
								 throw new Exception(e.getMessage()); 
							 }else{
								 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
							 }
						}
					}//end of list
					return errCd;
		    }
		    
}
