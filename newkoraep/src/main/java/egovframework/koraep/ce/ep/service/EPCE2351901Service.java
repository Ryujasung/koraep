package egovframework.koraep.ce.ep.service;

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
import egovframework.mapper.ce.ep.EPCE2351901Mapper;

/**
 * 보증금고지서 서비스
 * @author Administrator
 *
 */
@Service("epce2351901Service")
public class EPCE2351901Service {

	@Resource(name="epce2351901Mapper")
	private EPCE2351901Mapper epce2351901Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce2351901_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		List<?> bizrList 	= commonceService.mfc_bizrnm_select(request); // 생산자 콤보박스
		try {
			model.addAttribute("bizrList", util.mapToJson(bizrList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	//생산자 리스트
		
		return model;
	}
	
	/**
	 * 보증금고지서 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce2351901_select2(Map<String, String> data) {
		
		List<?> list = epce2351901Mapper.epce2351901_select(data);
		List<?> list2 = epce2351901Mapper.epce2351901_select2(data);
		List<?> list3 = epce2351901Mapper.epce2351901_select3(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		
		try {
			map.put("searchList", util.mapToJson(list));
			map.put("searchList2", util.mapToJson(list2));
			map.put("searchList3", util.mapToJson(list3));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
	}
	
	/**
	 * 보증금고지서 발급
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce2351901_insert(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		String ssUserId  = "";   //사용자ID
		
		if(vo != null){
			ssUserId = vo.getUSER_ID();
		}
		
		String errCd = "0000";
		List<?> list = JSONArray.fromObject(inputMap.get("list"));		//출고정보
		List<?> list2 = JSONArray.fromObject(inputMap.get("list2"));	//취급수수료
		List<?> list3 = JSONArray.fromObject(inputMap.get("list3"));	//직접회수

		if (list != null) {
			try {
				
				for(int i=0; i<list.size(); i++){
					
					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					
					Map<String, String> checkMap = epce2351901Mapper.epce2351901_select4(map); //출고정보 재조회

					if(!checkMap.get("DLIVY_QTY_TOT").equals(map.get("DLIVY_QTY_TOT")) 
							|| !checkMap.get("DLIVY_GTN_TOT").equals(map.get("DLIVY_GTN_TOT"))
							|| !checkMap.get("DLIVY_CNT").equals(map.get("DLIVY_CNT")) )
					{
						//출고정보가 일치하지 않습니다. 재조회 후 처리 바랍니다.
						throw new Exception("D001");
					}
					
					double DLIVY_QTY_TOT = Double.parseDouble(map.get("DLIVY_QTY_TOT")); //출고량
					double DLIVY_GTN_TOT = Double.parseDouble(map.get("DLIVY_GTN_TOT")); //출고보증금
					
					double WRHS_QTY = 0; 				//입고량
					double WRHS_NOTY_AMT = 0;		//취급수수료 고지금액
					double ADD_BILL_REFN_GTN = 0;	//취급수수료 지급예정보증금
					for(int j=0 ;j<list2.size(); j++){
						Map<String, String> listMap = (Map<String, String>) list2.get(j);
						
						Map<String, String> checkMap2 = epce2351901Mapper.epce2351901_select6(listMap); //취급수수료 고지서 재조회
						
						if(checkMap2 != null){
							if(!checkMap2.get("WRHS_NOTY_AMT").equals(listMap.get("WRHS_NOTY_AMT")) 
									|| !checkMap2.get("ADD_BILL_REFN_GTN").equals(listMap.get("ADD_BILL_REFN_GTN")) )
							{
								//취급수수료정보가 일치하지 않습니다. 재조회 후 처리 바랍니다.
								throw new Exception("D002");
							}
						}
						
						if(map.get("MFC_BIZRID").equals(listMap.get("MFC_BIZRID")) && map.get("MFC_BIZRNO").equals(listMap.get("MFC_BIZRNO"))
								&& map.get("STD_YEAR").equals(listMap.get("STD_YEAR")) )
						{
							WRHS_QTY += Double.parseDouble(listMap.get("WRHS_QTY"));
							WRHS_NOTY_AMT += Double.parseDouble(listMap.get("WRHS_NOTY_AMT"));
							ADD_BILL_REFN_GTN += Double.parseDouble(listMap.get("ADD_BILL_REFN_GTN"));
						}

					}
					
					double DRCT_RTRVL_QTY_TOT = 0;			//직접회수량
					double DRCT_PAY_GTN_TOT = 0;				//직접회수보증금
					double DRCT_RTRVL_CNT = list3.size();		//직접회수건수
					for(int j=0 ;j<list3.size(); j++){
						Map<String, String> listMap = (Map<String, String>) list3.get(j);
						
						Map<String, String> checkMap2 = epce2351901Mapper.epce2351901_select7(listMap); // 직접회수 재조회
						
						if(checkMap2 != null){
							if(!checkMap2.get("DRCT_RTRVL_QTY_TOT").equals(listMap.get("DRCT_RTRVL_QTY_TOT")) 
									|| !checkMap2.get("DRCT_PAY_GTN_TOT").equals(listMap.get("DRCT_PAY_GTN_TOT")) )
							{
								//직접회수정보가 일치하지 않습니다. 재조회 후 처리 바랍니다.
								throw new Exception("D003");
							}
						}
						
						if(map.get("MFC_BIZRID").equals(listMap.get("MFC_BIZRID")) && map.get("MFC_BIZRNO").equals(listMap.get("MFC_BIZRNO"))
								&& map.get("STD_YEAR").equals(listMap.get("STD_YEAR")) )
						{
							DRCT_RTRVL_QTY_TOT += Double.parseDouble(listMap.get("DRCT_RTRVL_QTY_TOT"));
							DRCT_PAY_GTN_TOT += Double.parseDouble(listMap.get("DRCT_PAY_GTN_TOT"));
						}
					}
					System.out.println("DRCT_RTRVL_QTY_TOT"+DRCT_RTRVL_QTY_TOT);
					System.out.println("DRCT_PAY_GTN_TOT"+DRCT_PAY_GTN_TOT);
					System.out.println("DRCT_RTRVL_CNT"+DRCT_RTRVL_CNT);
					
					double PLAN_GTN_BAL = 0;				//예정보증금잔액
					double ADIT_GTN_BAL = 0;				//추가보증금 누적액 : 조정 전 추가보증금 잔액
					double DRCT_PAY_GTN_BAL = 0;		//직접지급보증금 누적액 : 조정 전 직접지급보증금 잔액
					
					Map<String, String> balMap = epce2351901Mapper.epce2351901_select5(map); //잔액조회
					if(balMap != null){
						PLAN_GTN_BAL = Double.parseDouble(balMap.get("PLAN_GTN_BAL"));						
						ADIT_GTN_BAL = Double.parseDouble(balMap.get("ADIT_GTN_BAL"));						
						DRCT_PAY_GTN_BAL = Double.parseDouble(balMap.get("DRCT_PAY_GTN_BAL"));	
					}
					System.out.println("PLAN_GTN_BAL"+PLAN_GTN_BAL);
					System.out.println("ADIT_GTN_BAL"+ADIT_GTN_BAL);
					System.out.println("DRCT_PAY_GTN_BAL"+DRCT_PAY_GTN_BAL);
					String doc_psnb_cd = "";
					String bill_doc_no = "";
					
					
					/**
					 * 추가보증금 미발행(보증금고지서 발급 처리)
					 * (예정잔액 + 출고보증금) - 취급수수료 지급예정보증금 == 0 && 직접회수건수 == 0
					 * OR
					 * (예정잔액 + 출고보증금) - 취급수수료 지급예정보증금 > 0 && 직접회수건수 == 0 && 추가보증금 누적액 <= 0 && 직접지급보증금 누적액 < 0
					 */
					if( ((PLAN_GTN_BAL + DLIVY_GTN_TOT) - ADD_BILL_REFN_GTN == 0 && DRCT_RTRVL_CNT == 0) ||
							((PLAN_GTN_BAL + DLIVY_GTN_TOT) - ADD_BILL_REFN_GTN  > 0 && DRCT_RTRVL_CNT == 0 && ADIT_GTN_BAL <= 0 && DRCT_PAY_GTN_BAL <= 0)
						){
						
						doc_psnb_cd ="BG"; // 보증금
						bill_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 문서번호 조회
						map.put("BILL_DOC_NO", bill_doc_no);										//문서채번
						
						map.put("BILL_SE_CD", "G"); /* (그룹코드: D031) : G: 보증금, F: 취급수수료, M: 보증금(조정) */
						
						//master
						epce2351901Mapper.epce2351901_insert(map); 			// 마스터 등록
						
						//보증금고지서 상세 및 기타 상태 처리
						epce2351901_update(map, list2, list3);
						
						
						map.put("PLAN_GTN_BAL", String.valueOf(DLIVY_GTN_TOT)); 
						map.put("ADIT_GTN_BAL", "0");
						map.put("DRCT_PAY_GTN_BAL", "0");
						System.out.println("MAP3"+map);
						//생산자보증금잔액 인서트
						epce2351901Mapper.epce2351901_insert5(map);
						
					/**
					 * 추가보증금 발행
					 * (예정잔액 + 출고보증금) - 취급수수료 지급예정 보증금 < 0
					 */	
					}else if((PLAN_GTN_BAL + DLIVY_GTN_TOT) - ADD_BILL_REFN_GTN < 0){	
						
						double nAditGtnAmt      		= 0;	//추가보증금
						double nAditGtnBal				= 0;	//추가보증금 잔액
						double nDrctPayAdjAmt 		= 0;	//직접지급보증금 조정금액
						double nDrctPayGtnBal		= 0;	//직접지급보증금 잔액
						double nNotyAmt           		= 0;	//고지금액
						
						nAditGtnAmt      		= ADD_BILL_REFN_GTN - (PLAN_GTN_BAL + DLIVY_GTN_TOT); 	// 추가보증금 	= 취급수수료 지급예정보증금 - (예정잔액+출고보증금)
						System.out.println("nAditGtnAmt"+nAditGtnAmt);
						nAditGtnBal      		= ADIT_GTN_BAL + nAditGtnAmt; 							// 추가보증금 잔액 			= 추가보증금 잔액(누적) + 추가보증금
						System.out.println("nAditGtnBal"+nAditGtnBal);
						nDrctPayAdjAmt		= DRCT_PAY_GTN_TOT;										// 직접지급보증금 조정 금액  = 직접회수보증금
						System.out.println("nDrctPayAdjAmt"+nDrctPayAdjAmt);
						nDrctPayGtnBal  		= DRCT_PAY_GTN_BAL + nDrctPayAdjAmt; 			// 직접지급보증금 잔액		= 직접지급보증금 잔액(누적) + 직접지급보증금 조정금액
						System.out.println("nDrctPayGtnBal"+nDrctPayGtnBal);
						nNotyAmt         		= DLIVY_GTN_TOT + nAditGtnAmt; 						// 고지금액					= 출고보증금 + 추가보증금
						System.out.println("nNotyAmt"+nNotyAmt);
						doc_psnb_cd ="BA"; // 보증금(조정)
						bill_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 문서번호 조회
						map.put("BILL_DOC_NO", bill_doc_no);
						
						map.put("BILL_SE_CD", "M"); /* (그룹코드: D031) : G: 보증금, F: 취급수수료, M: 보증금(조정) */
						
						map.put("NOTY_AMT", String.valueOf(nNotyAmt)); 										//고지금액
						map.put("GTN_TOT", String.valueOf(DLIVY_GTN_TOT)); 								//보증금
						map.put("FEE_PAY_GTN", String.valueOf(ADD_BILL_REFN_GTN)); 					//취급수수료지급예정보증금
						map.put("ADD_GTN", String.valueOf(nAditGtnAmt)); 									//추가보증금
						map.put("ADD_GTN_ACMT", String.valueOf(ADIT_GTN_BAL)); 						//추가보증금 잔액(누적)
						map.put("ADD_GTN_BAL", String.valueOf(nAditGtnBal)); 								//추가보증금 잔액
						map.put("DRCT_PAY_GTN_ACMT", String.valueOf(DRCT_PAY_GTN_BAL)); 	//직접지급보증금 잔액(누적)
						map.put("DRCT_PAY_GTN", String.valueOf(DRCT_PAY_GTN_TOT)); 				//직접지급보증금
						map.put("DRCT_PAY_ADJ_AMT", String.valueOf(nDrctPayAdjAmt)); 			//직접지급보증금 조정금액
						map.put("DRCT_PAY_GTN_BAL", String.valueOf(nDrctPayGtnBal)); 				//직접지급보증금 잔액
						map.put("DRCT_RTRVL_ADJ_AMT", "0"); 													//직접회수보증금 조정금액
						map.put("PLAN_BAL" ,String.valueOf(PLAN_GTN_BAL)); 								//예정잔액
						System.out.println("MAP!!"+map);
						//master
						epce2351901Mapper.epce2351901_insert3(map); // 마스터 등록 (추가보증금)
						
						//보증금고지서 상세 및 기타 상태 처리
						epce2351901_update(map, list2, list3);
						
						
						map.put("PLAN_GTN_BAL", String.valueOf(nNotyAmt));
						map.put("ADIT_GTN_BAL", String.valueOf(nAditGtnAmt));
						map.put("DRCT_PAY_GTN_BAL", String.valueOf(nDrctPayAdjAmt));
						
						//생산자보증금잔액 인서트
						epce2351901Mapper.epce2351901_insert5(map);
						
					/**
					 * 추가보증금 조정
					 */	
					}else{
						
						double nBaseGtn         		= 0;	//기준보증금
						double nAditGtnAmt      		= 0;	//추가보증금
						double nAditGtnBal				= 0;	//추가보증금 잔액
						double nDrctPayGtnBal		= 0;	//직접지급보증금 잔액
						double nNotyAmt           		= 0;	//고지금액
						
						double nAditGtnAdjAmt   	= 0;	//추가보증금 조정금액
						double nDrctRtrvlAdjAmt  	= 0;	//직접회수 조정금액
						double nDrctPayAdjAmt 	= 0;	//직접지급 조정금액
						
						//3-1. (예정잔액+출고보증금) - 취급수수료 지급예정 보증금 == 0 && 직접회수건수>0
						if((PLAN_GTN_BAL + DLIVY_GTN_TOT) - ADD_BILL_REFN_GTN == 0 && DRCT_RTRVL_CNT > 0){
							
							nAditGtnAmt     	= 0;																	// 추가보증금
							nDrctPayAdjAmt = DRCT_PAY_GTN_BAL + DRCT_PAY_GTN_TOT; 	// 직접지급 조정금액 	= 직접지급보증금 잔액(누적) + 직접회수 보증금
							nDrctPayGtnBal = DRCT_PAY_GTN_BAL + DRCT_PAY_GTN_TOT; 	// 직접지급보증금 잔액 	= 직접지급보증금 잔액(누적) + 직접회수 보증금
							nNotyAmt        	= DLIVY_GTN_TOT; 											// 고지금액				= 출고보증금
							
						//3-2. (예정잔액+출고보증금) - 취급수수료 지급예정 보증금 > 0		
						}else if((PLAN_GTN_BAL + DLIVY_GTN_TOT) - ADD_BILL_REFN_GTN > 0){
							
							//예정잔액 - 취급수수료 지급예정 보증금 >= 0
							if(PLAN_GTN_BAL - ADD_BILL_REFN_GTN >= 0) {
								
								nBaseGtn = DLIVY_GTN_TOT; 													// 기준보증금 = 출고보증금
							
							//예정잔액-취급수수료 지급예정 보증금 < 0 
							}else{
								
								nBaseGtn = (DLIVY_GTN_TOT - (ADD_BILL_REFN_GTN - PLAN_GTN_BAL)); 	// 기준보증금 = (출고보증금 - (취급수수료 지급예정 보증금 - 예정잔액) )
							}
							
							
							//기준보증금 - 추가보증금 잔액(누적) <= 0
							if(nBaseGtn - ADIT_GTN_BAL <= 0){
								
								nAditGtnAmt        	= nBaseGtn * -1;											// 추가보증금 					= 기준보증금 * -1
								nAditGtnAdjAmt   	= nBaseGtn;													// 추가보증금 조정금액 		= 기준보증금
								nAditGtnBal      	  	= ADIT_GTN_BAL - nAditGtnAdjAmt; 					// 추가보증금 잔액 			= 추가보증금 잔액(누적) - 추가보증금조정금액
								nDrctPayAdjAmt 	= DRCT_PAY_GTN_TOT; 									// 직접지급 조정금액 			= 직접회수 보증금
								nDrctPayGtnBal   	= DRCT_PAY_GTN_BAL + nDrctPayAdjAmt;		// 직접지급 보증금 잔액 		= 직접지급보증금 잔액(누적)  -  직접지급 조정금액
								nNotyAmt         	  	= DLIVY_GTN_TOT - nAditGtnAdjAmt; 				// 고지금액 					= 출고보증금 - 추가보증금조정금액
								
							//기준보증금-추가보증금누적액 > 0
							}else{
								
								nAditGtnAmt    		= ADIT_GTN_BAL * -1;										// 추가보증금 				= 추가보증금 잔액(누적) * -1
								nAditGtnAdjAmt 		= ADIT_GTN_BAL;											// 추가보증금 조정금액 	= 추가보증금 잔액(누적)
								nAditGtnBal    		= 0;																// 추가보증금 잔액		= 0
								
								/**
								 * 직접지급보증금 조정금액 산정
								 */
								//기준보증금 - 추가보증금 조정금액 - 직접회수보증금 <= 0
								if(nBaseGtn - nAditGtnAdjAmt - DRCT_PAY_GTN_TOT <= 0){
									nDrctPayAdjAmt 	= DRCT_PAY_GTN_TOT - (nBaseGtn - nAditGtnAdjAmt);		// 직접지급 조정금액 		= 직접회수보증금 - (기준보증금 - 추가보증금 조정금액)
									nDrctRtrvlAdjAmt  	= DRCT_PAY_GTN_TOT - nDrctPayAdjAmt;						// 직접회수 조정금액	 	= 직접회수보증금 - 직접지급 조정금액
									nDrctPayGtnBal  	= DRCT_PAY_GTN_BAL + nDrctPayAdjAmt;						// 직접지급 보증금 잔액 	= 직접지급보증금 잔액(누적) + 직접지급 조정금액
									nNotyAmt         		= DLIVY_GTN_TOT - nAditGtnAdjAmt - nDrctRtrvlAdjAmt;	// 고지금액				= 출고보증금 - 추가보증금 조정금액 - 직접회수 조정금액
									
								//기준보증금 - 추가보증금 조정 금액 - 직접회수보증금 > 0
								}else{
									nDrctRtrvlAdjAmt = DRCT_PAY_GTN_TOT;														// 직접회수 조정금액 		= 직접회수보증금
									
									//직접지급 조정금액 산정
									//기준보증금 - 추가보증금 조정금액 - 직접회수 조정금액 - 직접지급보증금 잔액(누적) >= 0
									if(nBaseGtn - nAditGtnAdjAmt - nDrctRtrvlAdjAmt - DRCT_PAY_GTN_BAL >= 0){
										nDrctPayAdjAmt = DRCT_PAY_GTN_BAL * -1;										// 직접지급 조정금액 		= 직접지급보증금 잔액(누적) * -1
										nDrctPayGtnBal  = 0;																			// 직접지급 보증금 잔액 	= 0
									
									//기준보증금 - 추가보증금 조정금액 - 직접회수 조정금액 - 직접지급보증금 잔액(누적) < 0
									}else{
										nDrctPayAdjAmt = (nBaseGtn - nAditGtnAdjAmt - nDrctRtrvlAdjAmt) * -1; 	// 직접지급 조정금액 		= (기준보증금 - 추가보증금 조정금액 - 직접회수 조정금액)
										nDrctPayGtnBal  = DRCT_PAY_GTN_BAL - nDrctPayAdjAmt * -1;			 	// 직접지급보증금 잔액 	= 직접지급보증금 잔액(누적) - (직접지급 조정금액 * -1)
									}
									
									// 고지금액 = 출고보증금 - 추가보증금 조정금액 - 직접회수 조정금액 - (직접지급 조정금액 * -1)
									nNotyAmt = DLIVY_GTN_TOT - nAditGtnAdjAmt - nDrctRtrvlAdjAmt - nDrctPayAdjAmt * -1; 
								}
							}
						}//end if
						
						doc_psnb_cd ="BA"; // 보증금(조정)
						bill_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 문서번호 조회
						map.put("BILL_DOC_NO", bill_doc_no);										//문서채번
						
						map.put("BILL_SE_CD", "M"); /* (그룹코드: D031) : G: 보증금, F: 취급수수료, M: 보증금(조정) */
						
						//고지서마스터 등록 
						map.put("NOTY_AMT", String.valueOf(nNotyAmt)); 										//고지금액
						map.put("GTN_TOT", String.valueOf(DLIVY_GTN_TOT)); 								//보증금
						map.put("FEE_PAY_GTN", String.valueOf(ADD_BILL_REFN_GTN)); 					//취급수수료 지급예정 보증금
						map.put("ADD_GTN", String.valueOf(nAditGtnAmt)); 									//추가보증금
						map.put("ADD_GTN_ACMT", String.valueOf(ADIT_GTN_BAL)); 						//추가보증금 잔액(누적)
						map.put("ADD_GTN_BAL", String.valueOf(nAditGtnBal)); 								//추가보증금 잔액
						map.put("DRCT_PAY_GTN_ACMT", String.valueOf(DRCT_PAY_GTN_BAL)); 	//직접지급보증금 잔액(누적)
						map.put("DRCT_PAY_GTN", String.valueOf(DRCT_PAY_GTN_TOT)); 				//직접지급보증금
						map.put("DRCT_PAY_ADJ_AMT", String.valueOf(nDrctPayAdjAmt)); 			//직접지급보증금 조정금액
						map.put("DRCT_PAY_GTN_BAL", String.valueOf(nDrctPayGtnBal)); 				//직접지급보증금 잔액
						map.put("DRCT_RTRVL_ADJ_AMT", String.valueOf(nDrctRtrvlAdjAmt * -1)); 	//직접회수보증금 조정금액
						map.put("PLAN_BAL", String.valueOf(PLAN_GTN_BAL)); 								//예정잔액
						
						//master
						System.out.println("MAP2"+map);
						epce2351901Mapper.epce2351901_insert3(map); // 마스터 등록 (추가보증금)
						
						//보증금고지서 상세 및 기타 상태 처리
						epce2351901_update(map, list2, list3);

						
						map.put("PLAN_GTN_BAL", String.valueOf(nNotyAmt));
						map.put("ADIT_GTN_BAL", String.valueOf(nAditGtnAmt));
						map.put("DRCT_PAY_GTN_BAL", String.valueOf(nDrctPayAdjAmt));
						
						//생산자보증금잔액 인서트
						epce2351901Mapper.epce2351901_insert5(map);
						
					}
				}
			}catch (Exception e) {
				if(e.getMessage().equals("D001") || e.getMessage().equals("D002") || e.getMessage().equals("D003") ){
					throw new Exception(e.getMessage()); 
				 }else{
					throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
		}else{
			
		}
		
		return errCd;    	
	}
	
	/**
	 * 보증금고지서 상세 및 기타 상태 처리
	 * @param data
	 * @param 
	 * @return
	 * @
	 */
	public void epce2351901_update(Map<String, String> map, List list2, List list3) {
		
		//detail
		epce2351901Mapper.epce2351901_insert2(map); 		// 출고정보 고지서 상세 등록

		map.put("DLIVY_STAT_CD", "IB"); //고지등록 상태로 변경
		epce2351901Mapper.epce2351901_update(map); 		// 출고정보 상태 변경
		
		//취급수수료고지서 상태 변경 (추가고지서)
		for(int j=0 ;j<list2.size(); j++){
			Map<String, String> listMap = (Map<String, String>) list2.get(j);
			
			if(map.get("MFC_BIZRID").equals(listMap.get("MFC_BIZRID")) && map.get("MFC_BIZRNO").equals(listMap.get("MFC_BIZRNO"))
					&& map.get("STD_YEAR").equals(listMap.get("STD_YEAR")) )
			{
				listMap.put("ADIT_BILL_DOC_NO", map.get("BILL_DOC_NO"));
				listMap.put("S_USER_ID", map.get("S_USER_ID"));
				epce2351901Mapper.epce2351901_update2(listMap); 		// 취급수수료고지서 상태 변경 (추가고지서)
				
				//취급수수료고지서 생산자 잔액 인서트
				epce2351901Mapper.epce2351901_update6(listMap); 
			}
		}
		
		//직접회수내역  고지서 상세등록 및 상태변경
		for(int j=0 ;j<list3.size(); j++){
			Map<String, String> listMap = (Map<String, String>) list3.get(j);
			
			if(map.get("MFC_BIZRID").equals(listMap.get("MFC_BIZRID")) && map.get("MFC_BIZRNO").equals(listMap.get("MFC_BIZRNO"))
					&& map.get("STD_YEAR").equals(listMap.get("STD_YEAR")) )
			{
				listMap.put("BILL_DOC_NO", map.get("BILL_DOC_NO"));
				listMap.put("S_USER_ID", map.get("S_USER_ID"));
				epce2351901Mapper.epce2351901_insert4(listMap); 		// 직접회수내역 고지서 상세 등록
				
				listMap.put("DRCT_RTRVL_STAT_CD", "IB"); //고지등록 상태로 변경
				epce2351901Mapper.epce2351901_update3(listMap); 		// 직접회수내역 상태 변경
			}
		}
		
	}
	
	/**
	 *  엑셀저장
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce2351901_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
			
			data.put("excelYn", "Y");
			List<?> list = epce2351901Mapper.epce2351901_select(data);

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
