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
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE2350901Mapper;

/**
 * 지급정보생성 서비스
 * @author Administrator
 *
 */
@Service("epce2350901Service")
public class EPCE2350901Service {

	@Resource(name="epce2350901Mapper")
	private EPCE2350901Mapper epce2350901Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce2350901_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		List<?> bizrList 	= commonceService.mfc_bizrnm_select_y(request); // 생산자 콤보박스
		
		HashMap<String, String> map = new HashMap<String, String>();
		//map.put("BIZR_TP_CD","W1");//도매업자
		//List<?> bizrListW = commonceService.bizr_select(map);
		List<?> whsdlSeCdList	= commonceService.whsdl_se_select(request, map); //도매업자구분
		
		try {
			model.addAttribute("bizrList", util.mapToJson(bizrList));
			//model.addAttribute("bizrListW", util.mapToJson(bizrListW));
			model.addAttribute("whsdlSeCdList", util.mapToJson(whsdlSeCdList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	//생산자 리스트

		HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
		HashMap<String, String> map2 = new HashMap<String, String>();
		if(jmap != null){
				
			String BIZRID_NO = jmap.get("MFC_BIZR_SEL");
			if(BIZRID_NO != null && !BIZRID_NO.equals("")){
				map.put("BIZRID", BIZRID_NO.split(";")[0]);
				map.put("BIZRNO", BIZRID_NO.split(";")[1]);
				map.put("MFC_BIZRID", BIZRID_NO.split(";")[0]);
				map.put("MFC_BIZRNO", BIZRID_NO.split(";")[1]);
			}else{
				map.put("BIZRID", "");
				map.put("BIZRNO", "");
				map.put("MFC_BIZRID", "");
				map.put("MFC_BIZRNO", "");
			}
			
			String BRCH_ID_NO = jmap.get("MFC_BRCH_SEL");
			if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
				map.put("MFC_BRCH_ID", BRCH_ID_NO.split(";")[0]);
				map.put("MFC_BRCH_NO", BRCH_ID_NO.split(";")[1]);
			}


			List<?> brchList = commonceService.brch_nm_select(request, map);
			List<?> ctnrList = commonceService.ctnr_nm_select(request, map);

			model.addAttribute("brchList", util.mapToJson(brchList));
			model.addAttribute("ctnrList", util.mapToJson(ctnrList));
			model.addAttribute("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, map))); 

		}else{
			model.addAttribute("brchList", "{}");	
			model.addAttribute("ctnrList", "{}");	
			model.addAttribute("whsdlList", "{}");	
		}
		return model;
	}
	
	/**
	 * 지급정보생성 대상 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce2350901_select2(Map<String, String> data) {
		
		String BIZRID_NO = data.get("MFC_BIZR_SEL");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("MFC_BIZRID", BIZRID_NO.split(";")[0]);
			data.put("MFC_BIZRNO", BIZRID_NO.split(";")[1]);
		}
		String BRCH_ID_NO = data.get("MFC_BRCH_SEL");
		if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
			data.put("MFC_BRCH_ID", BRCH_ID_NO.split(";")[0]);
			data.put("MFC_BRCH_NO", BRCH_ID_NO.split(";")[1]);
		}
		String BIZRID_NO2 = data.get("WHSDL_BIZR_SEL");
		if(BIZRID_NO2 != null && !BIZRID_NO2.equals("")){
			data.put("WHSDL_BIZRID", BIZRID_NO2.split(";")[0]);
			data.put("WHSDL_BIZRNO", BIZRID_NO2.split(";")[1]);
		}
		
		List<?> menuList = epce2350901Mapper.epce2350901_select(data);
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
	}
	
	/**
	 * 지급정보생성
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce2350901_insert(Map<String, Object> inputMap, HttpServletRequest request) throws Exception{
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		String ssUserId  = "";   //사용자ID
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		List<Map<String, String>>list2 = new ArrayList<Map<String,String>>();

		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
				
				for(int i=0; i<list.size(); i++){

					String pay_doc_no ="";
					int cnt = 0;
					boolean keyCheck = false;
					
					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					
					for(int j=0 ;j<list2.size(); j++){
						
						Map<String, String> map2 = (Map<String, String>) list2.get(j);
						
				 		if( map.get("WHSDL_BIZRID").equals(map2.get("WHSDL_BIZRID")) && map.get("WHSDL_BIZRNO").equals(map2.get("WHSDL_BIZRNO")) 
				 			&& map.get("WHSDL_BRCH_ID").equals(map2.get("WHSDL_BRCH_ID")) && map.get("WHSDL_BRCH_NO").equals(map2.get("WHSDL_BRCH_NO")) 
				 			&& map.get("STD_YEAR").equals(map2.get("STD_YEAR")) 
				 			&& map.get("MFC_BIZRID").equals(map2.get("MFC_BIZRID")) && map.get("MFC_BIZRNO").equals(map2.get("MFC_BIZRNO")) 
				 			//&& map.get("MFC_BRCH_ID").equals(map2.get("MFC_BRCH_ID")) && map.get("MFC_BRCH_NO").equals(map2.get("MFC_BRCH_NO")) 
				 			)
				 	      {
				 			map.put("PAY_DOC_NO", map2.get("PAY_DOC_NO"));
				 			keyCheck = true;
				 			break;
				 		  }
					}
					
					if(!keyCheck){
				 		
				 		String doc_psnb_cd ="PY"; 
				 		pay_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 문서번호 조회
						map.put("PAY_DOC_NO", pay_doc_no);										//문서채번

						//master
						int rcnt = epce2350901Mapper.epce2350901_insert(map); 			// 마스터 등록
						if(rcnt == 0){
							throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						}

				 		list2.add(map);
				 	}	
					
					//detail
					cnt = epce2350901Mapper.epce2350901_insert2(map); 		// 상세 등록
					
					if(cnt == 0){
						throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
					}

					map.put("RTN_STAT_CD", "PP"); //지급예정 상태로 변경
					epce2350901Mapper.epce2350901_update2(map); 		// 입고 및 반환 마스터 상태 변경
					
				}//end of for
				
				for(int j=0 ;j<list2.size(); j++){
					Map<String, String> map2 = (Map<String, String>) list2.get(j);
					epce2350901Mapper.epce2350901_update(map2); //마스터 테이블 합계데이터 업데이트
				}
				
			} catch (Exception e) {
				 if(e.getMessage().equals("A012") ){
					 throw new Exception(e.getMessage());
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
		}//end of list
		
		return errCd;
		
	}
	
	/**
	 * 소매지급정보생성
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce2350901_insert2(Map<String, Object> inputMap, HttpServletRequest request) throws Exception{
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		String ssUserId  = "";   //사용자ID
		List<Map<String, String>> list = JSONArray.fromObject(inputMap.get("list"));
		List<Map<String, String>> list2 = new ArrayList<Map<String,String>>();
		List<Map<String, String>> rtlList2 = new ArrayList<Map<String,String>>();
		
		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
				
				//소매지급처리
				for(int i=0; i<list.size(); i++){
					
					Map<String, String> map = (Map<String, String>) list.get(i);
					
					//입고상세리스트
					List<Map<String, String>> cfmList = epce2350901Mapper.epce2350901_select2(map);
					
					for(int c=0; c<cfmList.size(); c++){
						Map<String, String> cfmMap = (Map<String, String>) cfmList.get(c);
						int cfmQty = Integer.parseInt(String.valueOf(cfmMap.get("CFM_QTY"))); //입고량
						
						//회수리스트, 지급대상 소매업자만 조회
						List<Map<String, String>> rtrvlList = epce2350901Mapper.epce2350901_select3(cfmMap);
						
						for(int r=0; r<rtrvlList.size(); r++){
							Map<String, String> rtrvlMap = (Map<String, String>) rtrvlList.get(r);
							int rtrvlQty = Integer.parseInt(String.valueOf(rtrvlMap.get("RTRVL_QTY"))); //회수량
							int rtrvlRmnQty = 0;
							
							if(cfmQty > 0){
								
								if((cfmQty - rtrvlQty) < 0){
									rtrvlRmnQty = rtrvlQty - cfmQty; //회수잔여수량
									rtrvlMap.put("RTRVL_QTY", String.valueOf(cfmQty)); //회수적용 수량
									cfmQty = 0;
								}else{
									cfmQty = cfmQty - rtrvlQty;
								}
								
								rtrvlMap.put("WRHS_DOC_NO", cfmMap.get("WRHS_DOC_NO"));
								rtrvlMap.put("CTNR_CD", cfmMap.get("CTNR_CD"));
								rtrvlMap.put("CFM_QTY", String.valueOf(cfmMap.get("CFM_QTY")));
								rtrvlMap.put("RTRVL_RMN_QTY", String.valueOf(rtrvlRmnQty));
								rtrvlMap.put("S_USER_ID", ssUserId);
								if(!rtrvlMap.containsKey("DRCT_PAY_SE")) rtrvlMap.put("DRCT_PAY_SE", "");

								epce2350901Mapper.epce2350901_insert5(rtrvlMap); //회수입고연결 인서트
								
								epce2350901Mapper.epce2350901_update3(rtrvlMap); //회수 잔여량 업데이트
								
							}else{
								break;
							}
						}
						
					}
					
					//소매 지급정보생성 - M: 도매업자위임 은 제외
					List<Map<String, String>> rtlList = epce2350901Mapper.epce2350901_select4(map);
					
					for(int k=0; k<rtlList.size(); k++){
						
						String pay_doc_no ="";
						int cnt = 0;
						boolean keyCheck = false;
						
						Map<String, String> rtlMap = (Map<String, String>) rtlList.get(k);
						rtlMap.put("S_USER_ID", ssUserId);
						
						if(String.valueOf(rtlMap.get("TBL_CNT_1")).equals(String.valueOf(rtlMap.get("TBL_CNT_2")))){
							
							for(int j=0 ;j<rtlList2.size(); j++){
								
								Map<String, String> rtlMap2 = (Map<String, String>) rtlList2.get(j);
								
						 		if( rtlMap.get("RTL_CUST_BIZRID").equals(rtlMap2.get("RTL_CUST_BIZRID")) && rtlMap.get("RTL_CUST_BIZRNO").equals(rtlMap2.get("RTL_CUST_BIZRNO")) 
						 			&& rtlMap.get("RTL_CUST_BRCH_ID").equals(rtlMap2.get("RTL_CUST_BRCH_ID")) && rtlMap.get("RTL_CUST_BRCH_NO").equals(rtlMap2.get("RTL_CUST_BRCH_NO")) 
						 			&& rtlMap.get("STD_YEAR").equals(rtlMap2.get("STD_YEAR")) 
						 			&& rtlMap.get("MFC_BIZRID").equals(rtlMap2.get("MFC_BIZRID")) && rtlMap.get("MFC_BIZRNO").equals(rtlMap2.get("MFC_BIZRNO")) 
						 			//&& rtlMap.get("MFC_BRCH_ID").equals(rtlMap2.get("MFC_BRCH_ID")) && rtlMap.get("MFC_BRCH_NO").equals(rtlMap2.get("MFC_BRCH_NO")) 
						 			)
						 	      {
						 			rtlMap.put("PAY_DOC_NO", rtlMap2.get("PAY_DOC_NO"));
						 			keyCheck = true;
						 			break;
						 		  }
							}
							
							if(!keyCheck){
						 		
						 		String doc_psnb_cd ="PY"; 
						 		pay_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 문서번호 조회
						 		rtlMap.put("PAY_DOC_NO", pay_doc_no);									//문서채번

								//master
								int rcnt = epce2350901Mapper.epce2350901_insert3(rtlMap); 		// 마스터 등록
								if(rcnt == 0){
									throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
								}

								rtlList2.add(rtlMap);
						 	}
							
							//detail
							cnt = epce2350901Mapper.epce2350901_insert4(rtlMap); 		// 상세 등록

							//상태는 아래에서 한꺼번에 업데이트함
							
						}else{ // 단가, 수수료 테이블 조인 에러
							throw new Exception("A001"); //
						}
						
					}
					
				}
				
				for(int j=0 ;j<rtlList2.size(); j++){
					Map<String, String> map2 = (Map<String, String>) rtlList2.get(j);
					epce2350901Mapper.epce2350901_update(map2); //마스터 테이블 합계데이터 업데이트
				}

				
				//도매 지급정보 생성
				for(int i=0; i<list.size(); i++){

					String pay_doc_no ="";
					int cnt = 0;
					boolean keyCheck = false;
					
					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					
					for(int j=0 ;j<list2.size(); j++){
						
						Map<String, String> map2 = (Map<String, String>) list2.get(j);
						
				 		if( map.get("WHSDL_BIZRID").equals(map2.get("WHSDL_BIZRID")) && map.get("WHSDL_BIZRNO").equals(map2.get("WHSDL_BIZRNO")) 
				 			&& map.get("WHSDL_BRCH_ID").equals(map2.get("WHSDL_BRCH_ID")) && map.get("WHSDL_BRCH_NO").equals(map2.get("WHSDL_BRCH_NO")) 
				 			&& map.get("STD_YEAR").equals(map2.get("STD_YEAR")) 
				 			&& map.get("MFC_BIZRID").equals(map2.get("MFC_BIZRID")) && map.get("MFC_BIZRNO").equals(map2.get("MFC_BIZRNO")) 
				 			//&& map.get("MFC_BRCH_ID").equals(map2.get("MFC_BRCH_ID")) && map.get("MFC_BRCH_NO").equals(map2.get("MFC_BRCH_NO")) 
				 			)
				 	      {
				 			map.put("PAY_DOC_NO", map2.get("PAY_DOC_NO"));
				 			keyCheck = true;
				 			break;
				 		  }
					}
					
					if(!keyCheck){
				 		
				 		String doc_psnb_cd ="PY"; 
				 		pay_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 문서번호 조회
						map.put("PAY_DOC_NO", pay_doc_no);										//문서채번

						//master
						int rcnt = epce2350901Mapper.epce2350901_insert(map); 			// 마스터 등록
						if(rcnt == 0){
							throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						}

				 		list2.add(map);
				 	}	
					
					//detail
					cnt = epce2350901Mapper.epce2350901_insert6(map); 		// 상세 등록 (소매적용)
					if(cnt == 0){
						throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
					}

					map.put("RTN_STAT_CD", "PP"); //지급예정 상태로 변경
					epce2350901Mapper.epce2350901_update4(map); 		// 입고 및 반환 마스터 상태 변경 (소매적용)
					
				}//end of for
				
				for(int j=0 ;j<list2.size(); j++){
					Map<String, String> map2 = (Map<String, String>) list2.get(j);
					epce2350901Mapper.epce2350901_update(map2); //마스터 테이블 합계데이터 업데이트
				}
				
			} catch (Exception e) {
				 if(e.getMessage().equals("A012") ){
					 throw new Exception(e.getMessage());
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
		}//end of list
		
		return errCd;
		
	}
	
	/**
	 * 지급정보생성 상계처리
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce2350901_insert7(Map<String, Object> inputMap, HttpServletRequest request) throws Exception{
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		String ssUserId  = "";   //사용자ID
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		List<Map<String, String>>list2 = new ArrayList<Map<String,String>>();

		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
				
				for(int i=0; i<list.size(); i++){

					String pay_doc_no ="";
					int cnt = 0;
					boolean keyCheck = false;
					
					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					
					for(int j=0 ;j<list2.size(); j++){
						
						Map<String, String> map2 = (Map<String, String>) list2.get(j);
						
				 		if( map.get("WHSDL_BIZRID").equals(map2.get("WHSDL_BIZRID")) && map.get("WHSDL_BIZRNO").equals(map2.get("WHSDL_BIZRNO")) 
				 			&& map.get("WHSDL_BRCH_ID").equals(map2.get("WHSDL_BRCH_ID")) && map.get("WHSDL_BRCH_NO").equals(map2.get("WHSDL_BRCH_NO")) 
				 			&& map.get("STD_YEAR").equals(map2.get("STD_YEAR")) 
				 			&& map.get("MFC_BIZRID").equals(map2.get("MFC_BIZRID")) && map.get("MFC_BIZRNO").equals(map2.get("MFC_BIZRNO")) 
				 			)
				 	      {
				 			//map.put("WHSDL_BIZRNO",map2.get("WHSDL_BIZRNO"));
				 			//map.put("PAY_DOC_NO", map2.get("PAY_DOC_NO"));
				 			keyCheck = true;
				 			break;
				 		  }
					}
					
					if(!keyCheck){
				 		
				 		String doc_psnb_cd ="PY"; 
				 		pay_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 문서번호 조회
				 		
						map.put("PAY_DOC_NO", pay_doc_no);										//문서채번
								
						//master
						int rcnt = epce2350901Mapper.epce2350901_insert7(map); 			// 마스터 등록
						if(rcnt == 0){
							throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						}

				 		list2.add(map);
				 	}	
					
				}//end of for
				
			} catch (Exception e) {
				 if(e.getMessage().equals("A012") ){
					 throw new Exception(e.getMessage());
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
		}//end of list
		
		return errCd;
		
	}
	
	/**
	 *  엑셀저장
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce2350901_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
			
			String BIZRID_NO = data.get("MFC_BIZR_SEL");
			if(BIZRID_NO != null && !BIZRID_NO.equals("")){
				data.put("MFC_BIZRID", BIZRID_NO.split(";")[0]);
				data.put("MFC_BIZRNO", BIZRID_NO.split(";")[1]);
			}
			String BRCH_ID_NO = data.get("MFC_BRCH_SEL");
			if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
				data.put("MFC_BRCH_ID", BRCH_ID_NO.split(";")[0]);
				data.put("MFC_BRCH_NO", BRCH_ID_NO.split(";")[1]);
			}
			String BIZRID_NO2 = data.get("WHSDL_BIZR_SEL");
			if(BIZRID_NO2 != null && !BIZRID_NO2.equals("")){
				data.put("WHSDL_BIZRID", BIZRID_NO2.split(";")[0]);
				data.put("WHSDL_BIZRNO", BIZRID_NO2.split(";")[1]);
			}
			
			data.put("excelYn", "Y");
			List<?> list = epce2350901Mapper.epce2350901_select(data);

			HashMap<String, String> map = new HashMap();
						
			map.put("fileName", data.get("fileName").toString());
			map.put("columns", data.get("columns").toString());
			
			//엑셀파일 저장
			commonceService.excelSave(request, map, list);

		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
}
