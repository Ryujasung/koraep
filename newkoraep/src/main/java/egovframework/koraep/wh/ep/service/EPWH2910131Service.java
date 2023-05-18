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

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE6172401Mapper;
import egovframework.mapper.ce.ep.EPCE6172501Mapper;
import egovframework.mapper.wh.ep.EPWH2910131Mapper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 반환내역서등록 Service
 * @author 양성수
 *
 */
@Service("epwh2910131Service")
public class EPWH2910131Service {


	@Resource(name="epwh2910131Mapper")
	private EPWH2910131Mapper EPWH2910131Mapper;  //반환내역서등록 Mapper

	@Resource(name="epce6172401Mapper")
	private EPCE6172401Mapper epce6172401Mapper;  //신구병 통계현황 Mapper

	@Resource(name="epce6172501Mapper")
	private EPCE6172501Mapper epce6172501Mapper;  //회수대비반환 통계현황 Mapper

	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통

	/**
	 * 반환내역서등록 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epwh2910131_select(ModelMap model, HttpServletRequest request) {
		  	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			model.addAttribute("sBizrTpCd", vo.getBIZR_TP_CD()); //W1 도매업자 W2 공병상

		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);

			Map<String, String> map = new HashMap<String, String>();
			List<?> whsl_se_cd = commonceService.whsdl_se_select(request, map);//도매업자구분
			List<?> ctnr_se = commonceService.getCommonCdListNew("E005");//빈용기구분 구/신
			List<?> rmk_list = commonceService.getCommonCdListNew("D025");//소매수수료 적용여부 비고
			map.put("WORK_SE", "5");//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
			HashMap<?,?> rtc_dt_list = commonceService.rtc_dt_list_select(map);//등록일자제한설정

			String title = commonceService.getMenuTitle("EPWH2910131");
			model.addAttribute("titleSub", title);

			try {
				model.addAttribute("whsl_se_cd", util.mapToJson(whsl_se_cd));
				model.addAttribute("ctnr_se", util.mapToJson(ctnr_se));
				model.addAttribute("rmk_list", util.mapToJson(rmk_list));
				model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));//등록일자제한설정
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
		 * 반환내역서등록 도매업자구분 선택시 도매업자업체명, 빈용기구분 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2910131_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	inputMap.put("STAT_CD", "Y");

	    	try {
	    		//rtnMap.put("enp_nmList", util.mapToJson(commonceService.enp_nm_select(inputMap))); //업체명 조회
	    		rtnMap.put("enp_nmList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap))); //업체명 조회
				rtnMap.put("ctnr_seList", util.mapToJson(commonceService.ctnr_se_select(request, inputMap))); //빈용기 구분 조회
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
		 * 반환내역서등록 도매업자업체명 선택시 지점 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2910131_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String brchIdNo = "";
			if(vo != null){
				brchIdNo = vo.getBRCH_ID()+";"+vo.getBRCH_NO();
			}

	    	inputMap.put("STAT_CD", "Y");
	    	try {
				rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select_wh(request, inputMap))); //지점 조회
				rtnMap.put("brchIdNo", brchIdNo); //본인 지점
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
		 * 반환내역서등록 지점 선택시 반환대상 생산자
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2910131_select4(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if(vo != null){
				inputMap.put("CUST_BIZRID", vo.getBIZRID());
				inputMap.put("CUST_BIZRNO", vo.getBIZRNO_ORI());
				inputMap.put("CUST_BRCH_ID", vo.getBRCH_ID());
				inputMap.put("CUST_BRCH_NO", vo.getBRCH_NO());
			}

	    	try {
				rtnMap.put("mfc_bizrnmList", util.mapToJson(commonceService.mfc_bizrnm_select6(inputMap)));  //생산자 조회
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
		 * 반환내역서등록 반환대상생산자 선택시 직매장/공장 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2910131_select5(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if(vo != null){
				inputMap.put("CUST_BIZRID", vo.getBIZRID());
				inputMap.put("CUST_BIZRNO", vo.getBIZRNO_ORI());
				inputMap.put("CUST_BRCH_ID", vo.getBRCH_ID());
				inputMap.put("CUST_BRCH_NO", vo.getBRCH_NO());
			}

	    	try {
				rtnMap.put("brch_dtssList", util.mapToJson(commonceService.mfc_bizrnm_select3(inputMap)));	//지점 조회
				rtnMap.put("ctnr_seList", util.mapToJson(commonceService.ctnr_se_select(request, inputMap))); //빈용기 구분 조회
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
		 * 반환내역서등록 빈용기구분 선택시 빈용기명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2910131_select6(Map<String, String> inputMap, HttpServletRequest request) {
			HashMap<String, Object> rtnMap = new HashMap<String, Object>();

			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if(vo != null){
				inputMap.put("CUST_BIZRID", vo.getBIZRID());
				inputMap.put("CUST_BIZRNO", vo.getBIZRNO_ORI());
				inputMap.put("CUST_BRCH_ID", vo.getBRCH_ID());
				inputMap.put("CUST_BRCH_NO", vo.getBRCH_NO());
			}

	    	try {
	    		inputMap.put("SOJU_STD_EXT", "Y");
				rtnMap.put("ctnr_nm", util.mapToJson(commonceService.ctnr_cd_select(inputMap))); //빈용기명 조회
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
		 * 반환내역서등록 그리드 컬럼 선택시
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2910131_select7(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if(vo != null){
				inputMap.put("CUST_BIZRID", vo.getBIZRID());
				inputMap.put("CUST_BIZRNO", vo.getBIZRNO_ORI());
				inputMap.put("CUST_BRCH_ID", vo.getBRCH_ID());
				inputMap.put("CUST_BRCH_NO", vo.getBRCH_NO());
			}

	    	try {
	    		rtnMap.put("brch_dtssList", util.mapToJson(commonceService.mfc_bizrnm_select3(inputMap))); //지점 조회
				rtnMap.put("ctnr_nm", util.mapToJson(commonceService.ctnr_cd_select(inputMap))); //빈용기명 조회
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
		 * 반환내역서등록 엑셀 업로드 후처리
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2910131_select8(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	try {
				rtnMap.put("selList", util.mapToJson(EPWH2910131Mapper.epwh2910131_select4(inputMap)));
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
		 * 반환내역서등록 생산자, 직매장/공장 선택 후 빈용기구분 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2910131_select9(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			
			if(vo != null){
				inputMap.put("CUST_BIZRID", vo.getBIZRID());
				inputMap.put("CUST_BIZRNO", vo.getBIZRNO_ORI());
				inputMap.put("CUST_BRCH_ID", vo.getBRCH_ID());
				inputMap.put("CUST_BRCH_NO", vo.getBRCH_NO());
			}
			
	    	try {
	    		String bizrTpCd = util.null2void(commonceService.bizr_tp_cd_select(request, inputMap), ""); //빈용기 구분 조회
	    		
	    		inputMap.put("BIZR_TP_CD", bizrTpCd);
	    		
				rtnMap.put("bizr_tp_cd", bizrTpCd); //사업자유형코드
				rtnMap.put("ctnr_seList", util.mapToJson(commonceService.ctnr_se_select(request, inputMap))); //빈용기 구분 조회
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
		 * 반환내역서등록  저장
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception
		 * @
		 */
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String epwh2910131_insert(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				String errCd = "0000";

				//Map<String, String> map;
				List<?> list = JSONArray.fromObject(inputMap.get("list"));
				List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();

				List<?> qtyList;
				Map<String, String> data;
				Map<String, String> qtyMap;
				String strCtnrCd;

				boolean keyCheck = false;
				int sel = 0;

				if (list != null) {
					try {

						for(int i=0; i<list.size(); i++){
							String rtn_doc_no ="";
							keyCheck = false;
							Map<String, String> map = (Map<String, String>) list.get(i);

							if(vo != null){
								map.put("REG_PRSN_ID", vo.getUSER_ID()); //등록자
								map.put("CUST_BIZRID", vo.getBIZRID());
								map.put("CUST_BIZRNO", vo.getBIZRNO_ORI());
								map.put("CUST_BRCH_ID", vo.getBRCH_ID());
								map.put("CUST_BRCH_NO", vo.getBRCH_NO());
							}

							/* 중복체크 제외
							int sel = EPWH2910131Mapper.epwh2910131_select3(map); //중복체크
							if(sel>0){
								inputMap.put("ERR_CTNR_NM", map.get("CTNR_NM").toString());
								throw new Exception("A003");
							}
							*/

							map.put("SDT_DT", map.get("RTN_DT"));	//등록일자제한설정  등록일자 1.DLIVY_DT,2.DRCT_RTRVL_DT, 3.EXCH_DT, 4.RTRVL_DT, 5.RTN_DT
							map.put("WORK_SE", "5"); 						//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
							sel =commonceService.rtc_dt_ck(map);	//등록일자제한설정
							if(sel !=1){
								throw new Exception("A021"); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
							}





							/*
							 * 반환용기의 반환량을 반환가능 잔여량과 체크
							 * 신/구병통계현황 참고
							 */

							//소주표준화병 여부 확인
							strCtnrCd = map.get("CTNR_CD").substring(3,5); //예, 210001 <= 뒤 2~3번째 자리 가져오기(xxx00x)

							int iRtnQty = Integer.parseInt(map.get("RTN_QTY").toString()); //반환량(화면 입력)
							int iRmnQty = 0; //잔여량(신/구병통계현황에서 조회)
							String strRmnQty = "";

							//소주표준화병인 경우, 도매업자정보로만 조회
							if("00".equals(strCtnrCd)) {
								data = new HashMap<String, String>();
								data.put("excelYn"     ,"N");
								data.put("WHSDL_BIZRID",map.get("CUST_BIZRID"));
								data.put("WHSDL_BIZRNO",map.get("CUST_BIZRNO"));
								data.put("CTNR_CD"     ,map.get("CTNR_CD"));
								data.put("CTNR_USE_YN" ,"Y");

								qtyList = epce6172401Mapper.epce6172401_select(data); //신/구통계현황 조회
							}
							//소주표준화병이 아닌 경우, 도매업자, 생산자정보로 조회
							else {
								data = new HashMap<String, String>();
								data.put("excelYn"     ,"N");
								data.put("MFC_BIZRID"  ,map.get("MFC_BIZRID"));
								data.put("MFC_BIZRNO"  ,map.get("MFC_BIZRNO"));
								data.put("WHSDL_BIZRID",map.get("CUST_BIZRID"));
								data.put("WHSDL_BIZRNO",map.get("CUST_BIZRNO"));
								data.put("CTNR_CD"     ,map.get("CTNR_CD"));
								data.put("CTNR_USE_YN" ,"Y");

								qtyList = epce6172401Mapper.epce6172401_select(data); //신/구통계현황 조회
							}

							//신/구통계현황 조회건이 있을경우
							if(qtyList.size() >= 1) {

								System.out.println("신/구통계현황 조회건수 : " + qtyList.size());

								//조호된 건 만큼 잔여량 합산(소주표준화병일경우 다건, 그렇지 않을경우 단건)
								for(int j=0; j<qtyList.size(); j++) {

									qtyMap = (Map<String, String>)qtyList.get(j);

									strRmnQty = String.valueOf(qtyMap.get("RMN_QTY"));
									System.out.println("잔여량 : " + strRmnQty);

									iRmnQty += Integer.parseInt(strRmnQty); //잔여량
								}

								System.out.println("용기 : " + map.get("CTNR_NM") + ", 반환량 : " + iRtnQty + ", 잔여량 : " + iRmnQty);

								//반환량이 잔여량보다 클경우 등록 불가
								if(iRtnQty > iRmnQty) {
									throw new Exception("D_"+map.get("CTNR_NM")+"_"+iRmnQty); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
									//return "D_"+map.get("CTNR_NM")+"_"+iRmnQty;
								}
							}


							/*
							 * 반환용기의 반환량을 회수가능 잔여량과 체크
							 * 회수대비반환통계현황 참고
							 */

							//회수용기코드변환
							strCtnrCd = map.get("CTNR_CD").substring(0,3); //예, 210001 <= 앞 3번째 자리까지 가져오기(210)

							iRmnQty = 0; //잔여량(회수대비반환통계현황 조회)
							strRmnQty = "";

							data = new HashMap<String, String>();
							data.put("excelYn"     ,"N");
							data.put("WHSDL_BIZRID",map.get("CUST_BIZRID"));
							data.put("WHSDL_BIZRNO",map.get("CUST_BIZRNO"));
							data.put("CTNR_CD"     ,strCtnrCd);
							data.put("CTNR_USE_YN" ,"Y");

							qtyList = epce6172501Mapper.epce6172501_select(data); //회수대비반환통계현황 조회

							//회수대비반환통계현황 조회건이 있을경우
							if(qtyList.size() >= 1) {

								System.out.println("회수대비반환통계현황 조회건수 : " + qtyList.size());

								//조호된 건 만큼 잔여량 합산(소주표준화병일경우 다건, 그렇지 않을경우 단건)
								for(int j=0; j<qtyList.size(); j++) {

									qtyMap = (Map<String, String>)qtyList.get(j);

									strRmnQty = String.valueOf(qtyMap.get("RMN_QTY"));
									System.out.println("잔여량 : " + strRmnQty);

									iRmnQty += Integer.parseInt(strRmnQty); //잔여량
								}

								System.out.println("용기 : " + map.get("CTNR_NM") + ", 반환량 : " + iRtnQty + ", 잔여량 : " + iRmnQty);

								//반환량이 잔여량보다 클경우 등록 불가
								if(iRtnQty > iRmnQty) {
									throw new Exception("R_"+map.get("CTNR_NM")+"_"+iRmnQty); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
									//return "R_"+map.get("CTNR_NM")+"_"+iRmnQty;
								}
							}


						 	for(int j=0 ;j<list2.size(); j++){
						 		Map<String, String> map2 = list2.get(j);
						 		if( 	 map.get("MFC_BIZRID").equals(map2.get("MFC_BIZRID"))		&& map.get("MFC_BIZRNO").equals(map2.get("MFC_BIZRNO"))       //생산자
						 			&& map.get("MFC_BRCH_ID").equals(map2.get("MFC_BRCH_ID"))	&& map.get("MFC_BRCH_NO").equals(map2.get("MFC_BRCH_NO"))  //생산자 지점
						 			&& map.get("CAR_NO").equals(map2.get("CAR_NO"))					&& map.get("RTN_DT").equals(map2.get("RTN_DT")) )    				  //자동차, 반환일자
						 	      {
						 			map.put("RTN_DOC_NO",map2.get("RTN_DOC_NO"));
						 			//System.out.println( "RTN_DOC_NO :      "+map.get("RTN_DOC_NO"));
						 			keyCheck = true;
						 			//System.out.println( "keyCheck2 :      "+keyCheck);
						 			break;
						 		   }//end of if

						 	}//end of for list2
						 	if(!keyCheck){
						 		//master
						 		 String doc_psnb_cd ="RT"; 								   						//RT :반환문서 ,IN :입고문서
								 rtn_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 반환문서번호 조회
								 map.put("RTN_DOC_NO", rtn_doc_no);							//문서채번

								 EPWH2910131Mapper.epwh2910131_insert(map); 			// 반환마스터	  등록
						 		 list2.add(map);
						 	}
						 	//detail
						 	 EPWH2910131Mapper.epwh2910131_insert2(map); 		// 반환상세

						}//end of for
					 	for(int j=0 ;j<list2.size(); j++){
					 		Map<String, String> map = list2.get(j);
					 		EPWH2910131Mapper.epwh2910131_update(map);
					 	}

					}catch (IOException io) {
						System.out.println(io.toString());
					}catch (SQLException sq) {
						System.out.println(sq.toString());
					}catch (NullPointerException nu){
						System.out.println(nu.toString());
					} catch (Exception e) {
						 if(e.getMessage().equals("A003")){
							 throw new Exception(e.getMessage());
						 }else  if(e.getMessage().equals("A021")){
							 throw new Exception(e.getMessage());
						 }else if(e.getMessage().charAt(0) == 'D' || e.getMessage().charAt(0) == 'R') {
							 throw new Exception(e.getMessage());
						 }else{
							 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
						 }
					}
				}//end of list
				return errCd;
	    }

}
