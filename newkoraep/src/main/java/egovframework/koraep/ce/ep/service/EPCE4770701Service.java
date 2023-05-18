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
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE4770701Mapper;

/**
 * 생산자정산발급  서비스
 * @author Administrator
 *
 */
@Service("epce4770701Service")
public class EPCE4770701Service {

	@Resource(name="epce4770701Mapper")
	private EPCE4770701Mapper epce4770701Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4770701_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		List<?> mfcBizrList = epce4770701Mapper.epce4770701_select();
		
		try {
			model.addAttribute("mfcBizrList", util.mapToJson(mfcBizrList));	
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
	 * 정산금액확인 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4770731_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		String title = commonceService.getMenuTitle("EPCE4770731");
		model.addAttribute("titleSub", title);
		
    	String REPAY_AMT = jParams.getString("REPAY_AMT");
    	String PAY_AMT   = jParams.getString("PAY_AMT");
    	
    	model.addAttribute("REPAY_AMT", REPAY_AMT);
    	model.addAttribute("PAY_AMT", PAY_AMT);
		
		try {
			
			List<JSONObject> list = jParams.getJSONArray("list");
			HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
			HashMap<String, String> searchData = new HashMap<String, String>();
			
			//정산금액 계산
			getExcaData(param, list, searchData);

			long nExcaAmt = Long.parseLong(searchData.get("EXCA_AMT"));
			
			//상세정보
			HashMap<String, String> searchDtl = new HashMap<String, String>();
			param.put("EXCA_ISSU_SE_CD", "G");												//정산서발급구분코드(G:보증금, F:취급수수료, W:반환정산)
			param.put("EXCA_SE_CD", nExcaAmt>0 ? "C" : "A");								//정산처리구분(A:납부, C:환급)
			param.put("EXCA_AMT", String.valueOf(Math.abs(nExcaAmt)));				//정산금액
			
			searchDtl = (HashMap<String, String>) epce4770701Mapper.epce4770731_select2(param);
			
			List<?> searchList = new ArrayList<Object>();
			List<?> searchList2 = new ArrayList<Object>();
			List<?> searchList3 = new ArrayList<Object>();
			List<?> searchList5 = new ArrayList<Object>(); //연간혼비율조정
			List<?> searchList6 = new ArrayList<Object>(); //연간출고량조정
			List<?> searchList7 = new ArrayList<Object>(); //정산고지 세부내역
			List<?> searchList8 = new ArrayList<Object>(); //연간입고량조정
			List<?> searchList9 = new ArrayList<Object>(); //연간교환량조정
			
			if(param.get("A").equals("A")) searchList = epce4770701Mapper.epce4770701_select3(param);
			if(param.get("B").equals("B")) searchList2 = epce4770701Mapper.epce4770701_select4(param);
			if(param.get("C").equals("C")) searchList3 = epce4770701Mapper.epce4770701_select5(param);
			if(param.get("E").equals("E")) searchList5 = epce4770701Mapper.epce4770701_select6(param);  //연간혼비율조정
			if(param.get("F").equals("F")) searchList6 = epce4770701Mapper.epce4770701_select7(param);  //연간출고량조정
			if(param.get("I").equals("I")) searchList8 = epce4770701Mapper.epce4770701_select9(param);  //연간입고량조정
			if(param.get("J").equals("J")) searchList9 = epce4770701Mapper.epce4770701_select10(param); //연간교환량조정

			//searchList7 = epce4770701Mapper.epce4770701_select8(param); //정산고지 세부내역
			searchList7 = JSONArray.fromObject(list); //정산고지 세부내역
			
			model.addAttribute("searchData", util.mapToJson(searchData));
			model.addAttribute("searchDtl", util.mapToJson(searchDtl));
			model.addAttribute("searchList", util.mapToJson(searchList));
			model.addAttribute("searchList2", util.mapToJson(searchList2));
			model.addAttribute("searchList3", util.mapToJson(searchList3));
			model.addAttribute("searchList5", util.mapToJson(searchList5));
			model.addAttribute("searchList6", util.mapToJson(searchList6));
			model.addAttribute("searchList7", util.mapToJson(searchList7));
			model.addAttribute("searchList8", util.mapToJson(searchList8));
			model.addAttribute("searchList9", util.mapToJson(searchList9));
			
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			/*e.printStackTrace();*/
			//취약점점검 6301 기원우 
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
    public void getExcaData(HashMap<String, String> param, List<JSONObject> list, HashMap<String, String> searchData){

        HashMap<?, ?> gtnBalMap = new HashMap(); //보증금잔액
        HashMap<?, ?> excaMap = new HashMap(); //정산대상금액

		long nAditGtnPymtAmt = 0;	//추가보증금지급액
		long nDrctGtnPymtAmt = 0;	//직접회수보증금지급액
        
        if(param.containsKey("D") && param.get("D").equals("D") ){ //교환정산 전용

            Map<String, Object> data = new HashMap<String, Object>();
            data.put("list", list);

            gtnBalMap = (HashMap<?, ?>) epce4770701Mapper.epce4770701_select2(param); //보증금잔액
            excaMap = (HashMap<?, ?>) epce4770701Mapper.epce4770731_select4(data); //정산대상금액

        }else{

            param.put("A", "");
            param.put("B", "");
            param.put("C", "");
            param.put("E", "");
            param.put("F", "");
            param.put("I", "");
            param.put("J", "");

            //체크한 정산설정 확인
            for(int i=0; i<list.size(); i++){
                HashMap<String, String> map = util.jsonToMap(list.get(i));
                
                System.out.println("map : " + map.toString());
                
                param.put(map.get("ETC_CD"), map.get("ETC_CD"));
                
                if("G".equals(map.get("ETC_CD")) == true) {
            		nAditGtnPymtAmt = Long.parseLong(String.valueOf(map.get("PAY_PLAN_AMT")));	//추가보증금지급액
                	
                }
                else if("H".equals(map.get("ETC_CD")) == true) {
                	nDrctGtnPymtAmt = Long.parseLong(String.valueOf(map.get("PAY_PLAN_AMT")));	//직접회수보증금지급액
                }
            }

            String BIZRID_NO = param.get("MFC_BIZR_SEL");
            if(BIZRID_NO != null && !BIZRID_NO.equals("")){
                param.put("BIZRID", BIZRID_NO.split(";")[0]);
                param.put("BIZRNO", BIZRID_NO.split(";")[1]);
            }

            gtnBalMap = (HashMap<?, ?>) epce4770701Mapper.epce4770701_select2(param); //보증금잔액
            excaMap = (HashMap<?, ?>) epce4770701Mapper.epce4770731_select(param);    //정산대상금액
        }

        long nDrctPymtGtnBal = 0; //직접회수미지급잔액
        long nAditGtnBal = 0; //추가보증금잔액
        long nDlivyGtnBal = 0; //보증금잔액

        if(gtnBalMap != null){
            nDrctPymtGtnBal = Long.parseLong(gtnBalMap.get("DRCT_PAY_GTN_BAL").toString()); //직접회수미지급잔액
            nAditGtnBal = Long.parseLong(gtnBalMap.get("ADIT_GTN_BAL").toString());         //추가보증금잔액
            nDlivyGtnBal = Long.parseLong(gtnBalMap.get("PLAN_GTN_BAL").toString());        //보증금잔액
        }

        long nGtnBalTmp = nDlivyGtnBal<0 ? 0 : nDlivyGtnBal; //보증금잔액 절대값

        long nGbnCrctAmt1 = Long.parseLong(excaMap.get("GBN_CRCT_AMT1").toString()); //구분정산금액1 (교환정산, 입고정산)
        long nGbnCrctAmt2 = Long.parseLong(excaMap.get("GBN_CRCT_AMT2").toString()); //구분정산금액2 (출고정정, 연간출고량, 연간혼비율, 직접회수정정)
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

        long nAcpAmt = nAcpAmt1 + nAcpAmt2;                                        //수납금액
        long nPymtAmt = nPymtAmt1 + nPymtAmt2 + nPayPlanAmt;                       //지급금액
        long nAditGtnIn = nAditGtnIn1 + nAditGtnIn2;                               //추가보증금증가
        long nAditGtnDe = nAditGtnDe1 + nAditGtnDe2 + nAditGtnPymtAmt;             //추가보증금감소
        long nExcaAmt = nPymtAmt - nAcpAmt;                                        //정산금액
        long nAditGtnInDe = nAditGtnIn - nAditGtnDe;                               //추가보증금증감액
        long nBalInDeAmt = nBalInAmt - nBalDeAmt + nAcpAmt2 - nPymtAmt2;           //잔액증감액
        long nBalInDeAmt2 = nBalInAmt - nBalDeAmt;                                 //보정금 조정 금액(입고정정 금액만)
        long nGtnInde = nAcpAmt2 - nPymtAmt2 - nPayPlanAmt;                        //보증금증감액(입고정정 금액 제외)
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
	 * 생산자정산발급 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4770701_select2(Map<String, String> data) {
		
		String BIZRID_NO = data.get("MFC_BIZR_SEL");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		HashMap<?, ?> searchMap = (HashMap<?, ?>) epce4770701Mapper.epce4770701_select2(data);
		List<?> searchList = epce4770701Mapper.epce4770701_select3(data);
		List<?> searchList2 = epce4770701Mapper.epce4770701_select4(data);
		List<?> searchList3 = epce4770701Mapper.epce4770701_select5(data);
		List<?> searchList5 = epce4770701Mapper.epce4770701_select6(data);  //연간혼비율조정
		List<?> searchList6 = epce4770701Mapper.epce4770701_select7(data);  //연간출고량조정
		List<?> searchList7 = epce4770701Mapper.epce4770701_select8(data);
		List<?> searchList8 = epce4770701Mapper.epce4770701_select9(data);  //연간입고량조정
		List<?> searchList9 = epce4770701Mapper.epce4770701_select10(data); //연간교환량조정
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			
			map.put("searchMap", util.mapToJson(searchMap));
			map.put("searchList", util.mapToJson(searchList));
			map.put("searchList2", util.mapToJson(searchList2));
			map.put("searchList3", util.mapToJson(searchList3));
			map.put("searchList5", util.mapToJson(searchList5));
			map.put("searchList6", util.mapToJson(searchList6));
			map.put("searchList7", util.mapToJson(searchList7));
			map.put("searchList8", util.mapToJson(searchList8));
			map.put("searchList9", util.mapToJson(searchList9));
			
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
	public String epce4770731_insert(Map<String, Object> inputMap, HttpServletRequest request) throws Exception  {
		
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
			HashMap<String, String> amtMap = (HashMap<String, String>)epce4770701Mapper.epce4770731_select3(param); // 지급/수납 예정금액
			searchData.putAll(amtMap);
			long nExcaAmt = Long.parseLong(searchData.get("EXCA_AMT"));
			searchData.put("EXCA_PROC_STAT_CD", "I");									//I:발급 (C024)
			searchData.put("EXCA_ISSU_SE_CD", "G");										//정산서발급구분코드(G:보증금, F:취급수수료, W:반환정산)
			searchData.put("EXCA_SE_CD", nExcaAmt>0 ? "C" : "A");					//정산처리구분(A:납부, C:환급)
			searchData.put("EXCA_AMT", String.valueOf(Math.abs(nExcaAmt)));	//정산금액
			searchData.put("GTN", String.valueOf(Math.abs(nExcaAmt)));
			searchData.put("BIZRID", param.get("BIZRID"));
			searchData.put("BIZRNO", param.get("BIZRNO"));
			searchData.put("EXCA_STD_CD", param.get("EXCA_STD_CD"));
			searchData.put("S_USER_ID", ssUserId);
			param.put("S_USER_ID", ssUserId);
			
			String doc_psnb_cd ="BL"; 
	 		String stac_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 문서번호 조회
			searchData.put("STAC_DOC_NO", stac_doc_no); //문서채번
			param.put("STAC_DOC_NO", stac_doc_no); //문서채번
			//정산서발급 (보증금)
			epce4770701Mapper.epce4770731_insert(searchData);
			//정산서발급 상세 (보증금)
			epce4770701Mapper.epce4770731_insert2(param);
			//정정 및 정산연산조정 상태변경 (입고정정 제외)
			epce4770701Mapper.epce4770731_update(param);
			
			//생산자보증금잔액 인서트
			param.put("GTN_BAL_INDE_AMT", searchData.get("GTN_BAL_INDE_AMT"));
			param.put("AGTN_INDE_AMT", searchData.get("AGTN_INDE_AMT"));
			param.put("DRCT_PAY_GTN_BAL", searchData.get("DRCT_PAY_GTN_BAL"));
			param.put("GTN_INDE", searchData.get("GTN_INDE"));
			
			epce4770701Mapper.epce4770731_insert3(param);
			//입고정정 건이 있는 경우 취급수수료 정산서 발급
			if(param.get("B").equals("B")){
				HashMap<String, String> searchDataB = new HashMap<String, String>();
				searchDataB.putAll(param);
				searchDataB.putAll(amtMap);
				
				double nExcaAmt2 = Double.parseDouble(String.valueOf(searchDataB.get("FEE_AMT"))); //취급수수료 정산금액
				searchDataB.put("EXCA_PROC_STAT_CD", "I");									//I:발급 (C024)
				searchDataB.put("EXCA_ISSU_SE_CD", "F");										//정산서발급구분코드(G:보증금, F:취급수수료, W:반환정산)
				searchDataB.put("EXCA_SE_CD", nExcaAmt2>0 ? "C" : "A");					//정산처리구분(A:납부, C:환급)
				searchDataB.put("EXCA_AMT", String.valueOf(Math.abs(nExcaAmt2)));	//정산금액
				searchDataB.put("S_USER_ID", ssUserId);
		 		searchDataB.put("STAC_DOC_NO", stac_doc_no); //문서번호 그대로 사용
		 		//정산서발급 (취급수수료)
				epce4770701Mapper.epce4770731_insert4(searchDataB);
				
				//정산서발급 상세 (취급수수료)
				epce4770701Mapper.epce4770731_insert5(param);
				
				//정정 및 정산연산조정 상태변경
				epce4770701Mapper.epce4770731_update2(param);
		 		
			}
			
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			/*e.printStackTrace();*/
			//취약점점검 6304 기원우
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		return errCd;
		
	}
	
}
