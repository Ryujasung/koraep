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
import egovframework.mapper.ce.ep.EPCE4793901Mapper;

/**
 * 수기정산발급  서비스
 * @author Administrator
 *
 */
@Service("epce4793901Service")
public class EPCE4793901Service {

	@Resource(name="epce4793901Mapper")
	private EPCE4793901Mapper epce4793901Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4793901_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		List<?> mfcBizrList = epce4793901Mapper.epce4793901_select();
		
		try {
			model.addAttribute("mfcBizrList", util.mapToJson(mfcBizrList));	
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 정산금액확인 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4793931_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		String title = commonceService.getMenuTitle("EPCE4793931");
		model.addAttribute("titleSub", title);
		
		try {
			
			List<JSONObject> list = jParams.getJSONArray("list");
			HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
			HashMap<String, String> searchData = new HashMap<String, String>();
			
			//정산금액 계산
			getExcaData(param, list, searchData);

			long nExcaAmt = Long.parseLong(searchData.get("EXCA_AMT"));
			
			//상세정보
			HashMap<String, String> searchDtl = new HashMap<String, String>();
			//param.put("EXCA_ISSU_SE_CD", jParams.getString("EXCA_ISSU_SE_CD"));	//정산서발급구분코드(G:보증금, F:취급수수료, W:반환정산)
			param.put("EXCA_SE_CD", nExcaAmt>0 ? "C" : "A");			//정산처리구분(A:납부, C:환급)
			param.put("EXCA_AMT", String.valueOf(Math.abs(nExcaAmt)));	//정산금액
			
			searchDtl = (HashMap<String, String>) epce4793901Mapper.epce4793931_select2(param);
			
			List<?> searchList = new ArrayList<Object>(); //정산고지 세부내역
			
			searchList = JSONArray.fromObject(list); //정산고지 세부내역
			
			model.addAttribute("searchData", util.mapToJson(searchData));
			model.addAttribute("searchDtl", util.mapToJson(searchDtl));
			model.addAttribute("searchList", util.mapToJson(searchList));
	    	model.addAttribute("REPAY_AMT", searchData.get("REPAY_AMT"));
	    	model.addAttribute("PAY_AMT", searchData.get("PAY_AMT"));
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			/*e.printStackTrace();*/
			//취약점점검 6327 기원우
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
    public void getExcaData(HashMap<String, String> param, List<JSONObject> list, HashMap<String, String> searchData){

        HashMap<?, ?> gtnBalMap = new HashMap(); //보증금잔액
        HashMap<?, ?> excaMap = new HashMap(); //정산대상금액

		long nAditGtnPymtAmt = 0;	//추가보증금 지급조정액
		long nDrctGtnPymtAmt = 0;	//직접회수보증금 지급조정액
		long nGtnPymtAmt     = 0;	//보증금잔액 지급조정액
		long nFeePymtAmt     = 0;	//취급수수료 지급조정액
		long nTaxPymtAmt     = 0;	//취급수수료 부가세 지급조정액
        
		long nAditGtnRcvAmt = 0;	//추가보증금 수납예정액
		long nDrctGtnRcvAmt = 0;	//직접회수보증금 수납예정액
		long nGtnRcvAmt     = 0;	//보증금잔액 수납예정액
		long nFeeRcvAmt     = 0;	//취급수수료 수납예정액
		long nTaxRcvAmt     = 0;	//취급수수료 부가세 수납예정액

		
		
		//체크한 정산설정 확인
        for(int i=0; i<list.size(); i++){
            HashMap<String, String> map = util.jsonToMap(list.get(i));
            
            System.out.println("map : " + map.toString());
            
            param.put(map.get("ETC_CD"), map.get("ETC_CD"));
            
            if("G".equals(map.get("ETC_CD")) == true) {
        		nAditGtnPymtAmt = Long.parseLong(String.valueOf(map.get("PAY_PLAN_AMT")));	//추가보증금지급액
        		nAditGtnRcvAmt  = Long.parseLong(String.valueOf(map.get("ACP_PLAN_AMT")));	//추가보증금지급액
            }
            else if("H".equals(map.get("ETC_CD")) == true) {
            	nDrctGtnPymtAmt = Long.parseLong(String.valueOf(map.get("PAY_PLAN_AMT")));	//직접회수보증금지급액
            	nDrctGtnRcvAmt  = Long.parseLong(String.valueOf(map.get("ACP_PLAN_AMT")));	//직접회수보증금지급액
            }
            else if("K".equals(map.get("ETC_CD")) == true) {
            	nGtnPymtAmt = Long.parseLong(String.valueOf(map.get("PAY_PLAN_AMT")));	//보증금잔액
            	nGtnRcvAmt  = Long.parseLong(String.valueOf(map.get("ACP_PLAN_AMT")));	//보증금잔액
            }
            else if("L".equals(map.get("ETC_CD")) == true) {
            	nFeePymtAmt = Long.parseLong(String.valueOf(map.get("PAY_PLAN_AMT")));	//취급수수료
            	nFeeRcvAmt  = Long.parseLong(String.valueOf(map.get("ACP_PLAN_AMT")));	//취급수수료
            }
            else if("M".equals(map.get("ETC_CD")) == true) {
            	nTaxPymtAmt = Long.parseLong(String.valueOf(map.get("PAY_PLAN_AMT")));	//취급수수료 부가세
            	nTaxRcvAmt  = Long.parseLong(String.valueOf(map.get("ACP_PLAN_AMT")));	//취급수수료 부가세
            }
        }

        String BIZRID_NO = param.get("MFC_BIZR_SEL");
        if(BIZRID_NO != null && !BIZRID_NO.equals("")){
            param.put("BIZRID", BIZRID_NO.split(";")[0]);
            param.put("BIZRNO", BIZRID_NO.split(";")[1]);
        }

        gtnBalMap = (HashMap<?, ?>) epce4793901Mapper.epce4793901_select2(param); //보증금잔액
        //excaMap = (HashMap<?, ?>) epce4793901Mapper.epce4793931_select(param);    //정산대상금액

        long nDrctPymtGtnBal = 0; //직접회수미지급잔액
        long nAditGtnBal = 0; //추가보증금잔액
        long nDlivyGtnBal = 0; //보증금잔액

        if(gtnBalMap != null){
            nDrctPymtGtnBal = Long.parseLong(gtnBalMap.get("DRCT_PAY_GTN_BAL").toString()); //직접회수미지급잔액
            nAditGtnBal = Long.parseLong(gtnBalMap.get("ADIT_GTN_BAL").toString());         //추가보증금잔액
            nDlivyGtnBal = Long.parseLong(gtnBalMap.get("PLAN_GTN_BAL").toString());        //보증금잔액
        }

        long nGtnBalTmp = nDlivyGtnBal<0 ? 0 : nDlivyGtnBal; //보증금잔액 절대값

        long nGbnCrctAmt1 = 0; //구분정산금액1 (교환정산, 입고정산)
        long nGbnCrctAmt2 = 0; //구분정산금액2 (출고정정, 연간출고량, 연간혼비율, 직접회수정정)
        long nBalDeAmt = 0; //보증금차감금액
        long nBalInAmt = 0; //보증금증가금액
        long nAditGtnIn1 = 0; //추가보증금증가1
        long nAditGtnIn2 = 0; //추가보증금증가2
        long nAditGtnDe1 = 0; //추가보증금감소1
        long nAditGtnDe2 = 0; //추가보증금감소2
        long nAcpAmt1 = 0; //수납금액1
        long nAcpAmt2 = 0; //수납금액2
        long nPymtAmt1 = 0; //지급금액1
        long nPymtAmt2 = 0; //지급금액2

        long nGtnBalTmp2 = 0; //보증금잔액 중간계산
        long nAditGtnBalTmp2 = 0; // 추가보증금잔액 중간계산
        long nPayPlanAmt = nAditGtnPymtAmt + nDrctGtnPymtAmt;
        long nAcpPlanAmt = nAditGtnRcvAmt  + nDrctGtnRcvAmt;
        long nGtnAmt     = nGtnPymtAmt - nGtnRcvAmt;
        long nFeeAmt     = nFeePymtAmt - nFeeRcvAmt;
        long nTaxAmt     = nTaxPymtAmt - nTaxRcvAmt;

        ///정산금액 계산///
        if(nGbnCrctAmt1 >= 0){                                      //잔액차감 고지. 0보다 크거나 같을 경우
            if(nGtnBalTmp - Math.abs(nGbnCrctAmt1) >= 0){           // 보증금잔액 - 구분정산금액1 >= 0
                nBalDeAmt = Math.abs(nGbnCrctAmt1);                 //   보증금차감금액 = abs(구분정산금액1)
            }else{                                                  // 보증금잔액 - 구분정산금액1 < 0
                nBalDeAmt = nGtnBalTmp;                             //   보증금차감금액 = 보증금잔액
                nAditGtnIn1 = Math.abs(nGbnCrctAmt1) - nGtnBalTmp;  //   추가보증금증가1 = abs(구분정산금액1) - 보증금잔액
                nAcpAmt1 = Math.abs(nGbnCrctAmt1) - nGtnBalTmp;     //   수납금액1 = abs(구분정산금액1) - 보증금잔액
            }
        }else{                                                      //잔액증가 고지. 0보다 작을 경우
            if(nAditGtnBal - Math.abs(nGbnCrctAmt1) >= 0){          // 추가보증금잔액 - abs(구분정산금액1) >= 0
                nAditGtnDe1 = Math.abs(nGbnCrctAmt1);               //   추가보증금감소1 = abs(구분정산금액1)
                nPymtAmt1 = Math.abs(nGbnCrctAmt1);                 //   지급금액1 = abs(구분정산금액1)
            }else{                                                  // 추가보증금잔액 - abs(구분정산금액1) < 0
                nAditGtnDe1 = nAditGtnBal;                          //   추가보증금감소1 = 추가보증금잔액
                nPymtAmt1 = nAditGtnBal;                            //   지급금액1 = 추가보증금잔액
                nBalInAmt = Math.abs(nGbnCrctAmt1) - nAditGtnBal;   //   보증금증가금액 = abs(구분정산금액1) - 추가보증금잔액
            }
        }

        nGtnBalTmp2 = nGtnBalTmp - nBalDeAmt + nBalInAmt;           // 보증금잔액 중간계산 (보증금잔액 - 보증금차감금액 + 보증금증가금액)
        nAditGtnBalTmp2 = nAditGtnBal - nAditGtnDe1 + nAditGtnIn1;  // 추가보증금잔액 중간계산 (추가보증금잔액 - 추가보증금감소1 + 추가보증금증가1)

        if(nGbnCrctAmt2 >= 0){                                      //납부고지. 0보다 크거나 같을 경우
            if(nAditGtnBalTmp2 <= 0){                               // 추가보증금잔액 <= 0
                nAcpAmt2 = Math.abs(nGbnCrctAmt2);                  //   수납금액2 = abs(구분정산금액2)
            }else{                                                  // 추가보증금잔액 > 0
                if(Math.abs(nGbnCrctAmt2) - nAditGtnBalTmp2 >= 0){  //  abs(구분정산금액2) - 추가보증금잔액 >= 0
                    nAditGtnDe2 = nAditGtnBalTmp2;                  //    추가보증금감소2 = 추가보증금잔액
                    nAcpAmt2 = Math.abs(nGbnCrctAmt2) - nAditGtnBalTmp2;    //    수납금액2 = abs(구분정산금액2) - 추가보증금잔액
                }else{                                              //  abs(구분정산금액2) - 추가보증금잔액 < 0
                    nAditGtnDe2 = Math.abs(nGbnCrctAmt2);           //    추가보증금감소2 = abs(구분정산금액2)
                    nAcpAmt2 = 0;                                   //    수납금액2 = 0
                }
            }
        }else{//지급고지. 0보다 작을 경우
            if(nGtnBalTmp2 - Math.abs(nGbnCrctAmt2) >= 0){          // 보증금잔액 - abs(구분정산금액2) >= 0
                nPymtAmt2 = Math.abs(nGbnCrctAmt2);                 //   지급금액2 = abs(구분정산금액2)
            }else{                                                  // 보증금잔액 - abs(구분정산금액2) < 0
                nPymtAmt2 = nGtnBalTmp2;                            //   지급금액2 = 보증금잔액
                nAditGtnIn2 = Math.abs(nGbnCrctAmt2) - nGtnBalTmp2; //   추가보증금증가2 = abs(구분정산금액2) - 보증금잔액
            }
        }

        long nAcpAmt = nAcpAmt1 + nAcpAmt2 + nAcpPlanAmt;                          //수납금액
        long nPymtAmt = nPymtAmt1 + nPymtAmt2 + nPayPlanAmt;                       //지급금액
        long nAditGtnIn = nAditGtnIn1 + nAditGtnIn2;                               //추가보증금증가
        long nAditGtnDe = nAditGtnDe1 + nAditGtnDe2 + nAditGtnPymtAmt;             //추가보증금감소
        long nExcaAmt = nPymtAmt - nAcpAmt + nGtnAmt + nFeeAmt + nTaxAmt;                             //정산금액
        long nAditGtnInDe = nAditGtnIn - nAditGtnDe;                               //추가보증금증감액
        long nBalInDeAmt = nBalInAmt - nBalDeAmt + nAcpAmt2 - nPymtAmt2 - nGtnPymtAmt + nGtnRcvAmt;           //잔액증감액
        long nBalInDeAmt2 = nBalInAmt - nBalDeAmt - nGtnPymtAmt + nGtnRcvAmt;      //보정금 조정 금액(입고정정 금액만)
        long nGtnInde = nAcpAmt2 - nPymtAmt2 - nPayPlanAmt;                                      //보증금증감액(입고정정 금액 제외)
        ///정산금액 계산///

        //HashMap<String, String> searchData = new HashMap<String, String>();

        searchData.put("EXCA_PLAN_GTN_BAL", String.valueOf(nDlivyGtnBal));        //(보증금잔액)
        searchData.put("GTN_BAL_INDE_AMT", String.valueOf(nBalInDeAmt2));         //(보증금조정금액)
        searchData.put("EXCA_GTN_BAL", String.valueOf(nDlivyGtnBal + nBalInDeAmt - nPayPlanAmt)); //(보증금예정잔액)
        searchData.put("AGTN_BAL_PAY_AMT", String.valueOf(nAditGtnBal));          //(추가보증금누적액)
        searchData.put("AGTN_BAL_MDT_AMT", String.valueOf(nAditGtnPymtAmt));	  //(추가보증금잔액 지급조정금액)
        searchData.put("AGTN_INDE_AMT", String.valueOf(nAditGtnInDe));            //(추가보증금조정금액)
        searchData.put("AGTN_BAL", String.valueOf(nAditGtnBal+nAditGtnInDe));     //(추가보증금잔액)
        searchData.put("DRVL_BAL_PAY_AMT", String.valueOf(nDrctPymtGtnBal));      //(직접회수미지급누적액)
        searchData.put("DRVL_BAL_MDT_AMT", String.valueOf(nDrctGtnPymtAmt));	  //(직접회수조정금액)
        searchData.put("DRCT_PAY_GTN_BAL", String.valueOf(nDrctGtnPymtAmt * -1)); //(직접지급보증금잔액)
        searchData.put("DRVL_BAL", String.valueOf(nDrctPymtGtnBal + (nDrctGtnPymtAmt * -1))); //(직접회수미지급예정잔액)
        searchData.put("GTN_INDE", String.valueOf(nGtnInde));                     //보증금증감액(입고정정 금액 제외)
        searchData.put("EXCA_AMT", String.valueOf(nExcaAmt));                     //정산금액
        searchData.put("REPAY_AMT", String.valueOf(nFeePymtAmt + nTaxPymtAmt));
        searchData.put("PAY_AMT", String.valueOf(nFeeRcvAmt + nTaxRcvAmt));
        searchData.put("WHSL_FEE_TOT", String.valueOf(nFeeAmt));
        searchData.put("WHSL_FEE_STAX_TOT", String.valueOf(nTaxAmt));
        searchData.put("FEE_AMT", String.valueOf(nFeeAmt + nTaxAmt));

        //searchData.put("EXCA_AMT", String.valueOf(Math.abs(nExcaAmt)));         //정산금액

        System.out.println("지급금액1(nPymtAmt1) : " + nPymtAmt1);
        System.out.println("지급금액2(nPymtAmt2) : " + nPymtAmt2);
        System.out.println("수납금액1(nAcpAmt1) : " + nAcpAmt1);
        System.out.println("수납금액2(nAcpAmt2) : " + nAcpAmt2);
        System.out.println("지급금액(지급그액1 + 지급금액2) : " + nPymtAmt);
        System.out.println("수납금액(수납금액1 + 수납금액2) : " + nAcpAmt);
        System.out.println("정산금액(지급금액 - 수납금액) : " + nExcaAmt);
        
        //return searchData;
    }
	
	/**
	 * 수기정산발급 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4793901_select2(Map<String, String> data) {
		
		String BIZRID_NO = data.get("MFC_BIZR_SEL");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		HashMap<?, ?> searchMap = (HashMap<?, ?>) epce4793901Mapper.epce4793901_select2(data);
		List<?> searchList7 = epce4793901Mapper.epce4793901_select3(data);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			
			map.put("searchMap", util.mapToJson(searchMap));
			map.put("searchList", util.mapToJson(searchList7));
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
	}
	
	/**
	 * 정산서발급
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4793931_insert(Map<String, Object> inputMap, HttpServletRequest request) throws Exception  {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		String ssUserId  = "";   //사용자ID
		//Map<String, String> map = new HashMap<String, String>();

		try {
			
			if(vo != null){
				ssUserId = vo.getUSER_ID();
			}
			
			List<JSONObject> list = JSONArray.fromObject(inputMap.get("list"));
			HashMap<String, String> param = util.jsonToMap(JSONObject.fromObject(inputMap.get("PARAMS")));
			HashMap<String, String> searchData = new HashMap<String, String>();

			getExcaData(param, list, searchData); //정산금액 계산
			
			HashMap<String, String> amtMap = new HashMap<String, String>(); // 지급/수납 예정금액
			amtMap.put("DLIVY_CRCT_PAY_AMT"     , "0");
			amtMap.put("DLIVY_CRCT_ACP_AMT"     , "0");
			amtMap.put("WRHS_CRCT_PAY_AMT"      , "0");
			amtMap.put("WRHS_CRCT_ACP_AMT"      , "0");
			amtMap.put("DRCT_RTRVL_CRCT_PAY_AMT", "0");
			amtMap.put("DRCT_RTRVL_CRCT_ACP_AMT", "0");
			amtMap.put("FYER_WRHS_PAY_AMT"      , "0");
			amtMap.put("FYER_WRHS_ACP_AMT"      , "0");
			amtMap.put("FYER_DLIVY_PAY_AMT"     , "0");
			amtMap.put("FYER_DLIVY_ACP_AMT"     , "0");
			amtMap.put("WHSL_FEE_TOT"           , searchData.get("WHSL_FEE_TOT"));
			amtMap.put("WHSL_FEE_STAX_TOT"      , searchData.get("WHSL_FEE_STAX_TOT"));
			amtMap.put("RTL_FEE_TOT"            , "0");
			//amtMap.put("FEE_AMT"                , "0");

			searchData.putAll(amtMap);
			
			long nExcaAmt = Long.parseLong(searchData.get("EXCA_AMT"));
			searchData.put("EXCA_PROC_STAT_CD", "I");							//I:발급 (C024)
			searchData.put("EXCA_ISSU_SE_CD", param.get("EXCA_ISSU_SE_CD"));	//정산서발급구분코드(G:보증금, F:취급수수료)
			searchData.put("EXCA_SE_CD", nExcaAmt>0 ? "C" : "A");				//정산처리구분(A:납부, C:환급)
			searchData.put("EXCA_AMT", String.valueOf(Math.abs(nExcaAmt)));	    //정산금액
			searchData.put("GTN", String.valueOf(Math.abs(nExcaAmt)));
			searchData.put("BIZRID", param.get("BIZRID"));
			searchData.put("BIZRNO", param.get("BIZRNO"));
			searchData.put("EXCA_STD_CD", "M");                                 //수기정산
			searchData.put("S_USER_ID", ssUserId);
			searchData.put("STD_YEAR", param.get("EXCA_SE_YEAR"));
			param.put("S_USER_ID", ssUserId);
			
			String doc_psnb_cd ="MN"; 
	 		String stac_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 문서번호 조회
			searchData.put("STAC_DOC_NO", stac_doc_no); //문서채번
			param.put("STAC_DOC_NO", stac_doc_no); //문서채번
			searchData.put("MNUL_ISSU_RSN", String.valueOf(inputMap.get("MNUL_ISSU_RSN"))); //수기정산사유
			
			if("G".equals(param.get("EXCA_ISSU_SE_CD"))) {
				//정산서발급 (보증금)
				epce4793901Mapper.epce4793931_insert(searchData);
				
				//정산서발급 상세
		        for(int i=0; i<list.size(); i++){
		            HashMap<String, String> map = util.jsonToMap(list.get(i));
		            
		            map.put("STAC_DOC_NO", stac_doc_no); //문서채번
		            map.put("EXCA_ISSU_SE_CD", param.get("EXCA_ISSU_SE_CD"));	//정산서발급구분코드(G:보증금, F:취급수수료)
		            map.put("S_USER_ID", ssUserId);
		            
		            //정산서발급 상세 (보증금)
		            epce4793901Mapper.epce4793931_insert2(map);
		        }
				
				//수기보증금잔액 인서트
				param.put("GTN_BAL_INDE_AMT", searchData.get("GTN_BAL_INDE_AMT"));
				param.put("AGTN_INDE_AMT", searchData.get("AGTN_INDE_AMT"));
				param.put("DRCT_PAY_GTN_BAL", searchData.get("DRCT_PAY_GTN_BAL"));
				param.put("GTN_INDE", searchData.get("GTN_INDE"));
				
				epce4793901Mapper.epce4793931_insert3(param);
			}
			else {
				HashMap<String, String> searchDataB = new HashMap<String, String>();
				searchDataB.putAll(param);
				searchDataB.putAll(amtMap);
				
				double nExcaAmt2 = Double.parseDouble(String.valueOf(searchData.get("FEE_AMT"))); //취급수수료 정산금액
				
				searchDataB.put("EXCA_PROC_STAT_CD", "I");							//I:발급 (C024)
				searchDataB.put("EXCA_ISSU_SE_CD", "F");							//정산서발급구분코드(G:보증금, F:취급수수료, W:반환정산)
				searchDataB.put("EXCA_SE_CD", nExcaAmt2>0 ? "C" : "A");				//정산처리구분(A:납부, C:환급)
				searchDataB.put("EXCA_AMT", String.valueOf(Math.abs(nExcaAmt2)));	//정산금액
				searchDataB.put("S_USER_ID", ssUserId);
		 		searchDataB.put("STAC_DOC_NO", stac_doc_no); //문서번호 그대로 사용
		 		searchDataB.put("EXCA_STD_CD", "M");                                //수기정산
				searchDataB.put("S_USER_ID", ssUserId);
				searchDataB.put("STD_YEAR", param.get("EXCA_SE_YEAR"));
				searchDataB.put("MNUL_ISSU_RSN", String.valueOf(inputMap.get("MNUL_ISSU_RSN"))); //수기정산사유

				//정산서발급 (취급수수료)
				epce4793901Mapper.epce4793931_insert4(searchDataB);
				
				//정산서발급 상세
		        for(int i=0; i<list.size(); i++){
		            HashMap<String, String> map = util.jsonToMap(list.get(i));
		            
		            map.put("STAC_DOC_NO", stac_doc_no); //문서채번
		            map.put("EXCA_ISSU_SE_CD", param.get("EXCA_ISSU_SE_CD"));	//정산서발급구분코드(G:보증금, F:취급수수료)
		            map.put("S_USER_ID", ssUserId);
		            
		            //정산서발급 상세 (취급수수료)
		            epce4793901Mapper.epce4793931_insert2(map);
		        }
			}
		} catch (Exception e) {
			/*e.printStackTrace();*/
			//취약점점검 6328 기원우
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}	
}